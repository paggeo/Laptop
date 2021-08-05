#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <string.h>
#include <assert.h>

#include <sys/wait.h>
#include <sys/types.h>

#include "proc-common.h"
#include "queue.h"

static void sigalrm_handler(int);
static void sigchld_handler(int);
static void install_signal_handlers(void);

Node *head, *tail;
int queue_items;

//Compile-time parameters.
#define TQ 2              //time quantum
#define TASK_NAME_SZ 60   //maximum size for a task's name

int main(int argc, char **argv){

    int number_of_procs;
    pid_t pid;
    queue_items = 0;

    number_of_procs = argc; //scheduler and all progs

    head = (Node *) malloc(sizeof(Node));
    head->next = NULL;

    for(int i = 1; i < number_of_procs; i++){
        pid = fork();
        if(pid != 0){
            //scheduler puts the generated process in queue
            insert_in_queue(pid, argv[i]);
        }
        /*else{
            //forked process is replaced with executable "prog"
            //before that they are stopped
            char executable[] = "prog";
            char *newargv[] = {executable, NULL};
            char *newenviron[] = {NULL};

            raise(SIGSTOP);

            execve(executable, newargv, newenviron);
        }*/
    }

    //SCHEDULER'S CODE HERE

    //make the queue circular
    head = head->next;
    free(tail->next);
    tail->next = head;

    //wait for children to raise sigstop
    wait_for_ready_children(number_of_procs - 1);

    install_signal_handlers();

    if(number_of_procs == 0){
        fprintf(stderr, "Sceduler: No tasks. Exiting...\n");
        exit(1);
    }

    //start first child
    if(kill(head->pid, SIGCONT) < 0){
        perror("First child Cont error");
        exit(1);
    }

    //in TQ seconds an alarm is made for me (scheduler)
    //and I asynchronously go to sigalrm_handler function
    alarm(TQ);

    //pause() returns only when a signal was caught and the
    //signal-catching function returned. In this case, pause() returns -1

    //so loop forever until we exit from inside a signal handler
    while(pause())
        ;

    //Unreachable
    fprintf(stderr, "Internal error: Reached unreachable point\n");
    return 1;
}

static void install_signal_handlers(void){
    /*
    NOTE THAT SIGACTION IS A STRUCT AS SHOWN BELOW:
    struct sigaction {
        void     (*sa_handler)(int);
        void     (*sa_sigaction)(int, siginfo_t *, void *);
        sigset_t   sa_mask;
        int        sa_flags;
        void     (*sa_restorer)(void);
    };
    ALSO:
    void (*sa_handler)(int); is the declaration of a pointer
    to the function sa_handler(int). This pointer points
    to the memory where the code of this functions starts.
    CODE NOT DATA.
    Unlike normal pointers, we do not allocate de-allocate
    memory using function pointers.
    void (*sa_handler)(int) = &function_ptr is the same as
    void (*sa_handler)(int) = function_ptr
    void (*sa_handler)(int) = &function_ptr
        declare pointer to function
    void *sa_handler(int) = &function_ptr
        declare function that returns void pointer
    */
    sigset_t sigset;
    struct sigaction sa;

    sa.sa_handler = sigchld_handler;
    sa.sa_flags = SA_RESTART;

    sigemptyset(&sigset);
    sigaddset(&sigset, SIGCHLD);
    sigaddset(&sigset, SIGALRM);
    sa.sa_mask = sigset;

    if(sigaction(SIGCHLD, &sa, NULL) < 0){
        perror("sigaction: SIGCHLD");
        exit(1);
    }

    sa.sa_handler = sigalrm_handler;
    if(sigaction(SIGALRM, &sa, NULL) < 0){
        perror("sigaction: SIGALRM");
        exit(1);
    }

    // Ignore SIGPIPE, so that write()s to pipes
    // with no reader do not result in us being killed,
    // and write() returns EPIPE instead.
    //
    if (signal(SIGPIPE, SIG_IGN) < 0) {
        perror("signal: sigpipe");
        exit(1);
    }
}

static void sigalrm_handler(int signum){
    //static means that access is permitted only
    //from the current file. I could now use another
    //sigalrm_handler function in another file
    //with no problem

    //When a child process stops or terminates,
    //SIGCHLD is sent to the parent process (scheduler).
    //The default response to the signal is to ignore it.
    //But here, scheduler "goes to" sigchld_handler.

    if(kill(head->pid, SIGSTOP) < 0){
        perror("Stop error");
        exit(1);
    }
}

static void sigchld_handler(int signum){
    //it is safer to use write() instead of printf() in
    //asynchronous functions (signal handler functions)

    int p; //this is a process ID (pid)
    int status;

    for(;;){
        //waitpid(-1, 0, 0) acts like wait(). -1 means
        //wait for any child. When a child is stopped
        //signaled or exited then move on
        p = waitpid(-1, &status, WUNTRACED | WNOHANG);
        if(p == 0)
            break;

        explain_wait_status(p, status);

        if(WIFEXITED(status) | WIFSIGNALED(status)){
            //the child has been terminated

            //remove it from queue
            remove_from_queue(head->pid);

            //set the queue ready for next operation
            head = head->next;
            tail = tail->next;

            //continue the next one
            if(kill(head->pid, SIGCONT) < 0){
                //WNOHANG: return immediately if no child has exited.
                //WUNTRACED: also return if a child has stopped (but not traced via ptrace(2))
                perror("Cont error (WIFEXITED) | (WIFSIGNALED)");
                exit(1);
            }

            //set the alarm in 2 seconds to jump to sigalrm_handler
            //and stop the child
            alarm(TQ);
        }
        if(WIFSTOPPED(status)){
            //the child did not terminate yet

            //set the queue ready for next operation
            head = head->next;
            tail = tail->next;

            //continue the next one
            if(kill(head->pid, SIGCONT) < 0){
                perror("Cont error (WIFSTOPPED)");
                exit(1);
            }
            alarm(TQ);
                   }
               }
           }
