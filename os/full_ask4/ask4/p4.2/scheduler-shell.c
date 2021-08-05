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
#include "request.h"

static void sigalrm_handler(int);
static void sigchld_handler(int);
static void install_signal_handlers(void);
static void sched_create_shell(char *, int *, int *);
static void shell_request_loop(int, int);
static void do_shell(char *, int, int);
static void signals_enable(void);
static void signals_disable(void);
static int process_request(struct request_struct *);
static void sched_print_tasks(void);
static int sched_kill_task_by_id(int);
static void sched_create_task(char *);

Node *head, *tail; //since the queue will be circular, head indicates the current process
int queue_items;   //is the number of procs except the "shell" (includes the "scheduler")

//Compile-time parameters.
#define TQ 2                              //time quantum
#define TASK_NAME_SZ 60                    //maximum size for a task's name
#define SHELL_EXECUTABLE_NAME "shell"     //shell name defined

int main(int argc, char **argv){
    //The two file descriptors for communication between shell and scheduler are static
    //because they should not lose their value when a function if that would go to happen

    static int request_fd, return_fd;
    int number_of_procs; //is the number of processes about to start including the scheduler
    pid_t pid;
    queue_items = 0;

    number_of_procs = argc; //scheduler and all processes

    //Create the shell
    sched_create_shell(SHELL_EXECUTABLE_NAME, &request_fd, &return_fd);

    //Create processes given as arguments
    for(int i = 1; i < number_of_procs; i++){
        pid = fork();
        if(pid != 0){
            //scheduler puts the generated process in queue
            insert_in_queue(i, pid, argv[i]); //(id, pid, name)
        }
        else{
            change_pname(argv[i]);
            char *newargv[] = {argv[i], NULL};
            char *newenviron[] = {NULL};

            raise(SIGSTOP);

            //forked process is replaced with executable given as an argument
            execve(argv[i], newargv, newenviron);
        }
    }

    //SCHEDULER'S CODE HERE

    //make the queue circular
    free(tail->next);
    tail->next = head;

    //wait for children to raise sigstop and show the current instant of processes
    wait_for_ready_children(number_of_procs);
    show_pstree(getpid());

    install_signal_handlers();

    if(number_of_procs == 0){
        fprintf(stderr, "Sceduler: No tasks. Exiting...\n");
        exit(1);
    }

    //start first child ("shell")
    if(kill(head->pid, SIGCONT) < 0){
        perror("First child Cont error");
        exit(1);
    }

    alarm(TQ);

    //scheduler remains in here to read and execute the tasks sent by the "shell"
    shell_request_loop(request_fd, return_fd);

    //if I get out of a signal handler I exit the following loop and reach an unwanted point
    while(pause())
        ;

    //Unreachable
    fprintf(stderr, "Internal error: Reached unreachable point\n");
    return 1;
}

static void sched_create_shell(char *executable, int *request_fd, int *return_fd){
    pid_t pid;
    int pd_rq[2], pd_ret[2];

    //open two pipes:
    //one for reading or writing requests
    //and one for reading and writing returns
    if(pipe(pd_rq) < 0 || pipe(pd_ret) < 0){
        perror("pipe");
        exit(1);
    }

    pid = fork();
    if(pid < 0){
        perror("scheduler: fork");
        exit(1);
    }

    if(pid == 0){
        //CHILD
        change_pname(SHELL_EXECUTABLE_NAME);
        close(pd_rq[0]);
        close(pd_ret[1]);
        do_shell(executable, pd_rq[1], pd_ret[0]); //create the shell

        //I should not reach here
        assert(0);
    }
    //PARENT AKA SCHEDULER

    //create "shell" process node and since it is the first process
    head = (Node*) malloc (sizeof(Node));
    head->id = 0;
    head->pid = pid;
    head->name = strdup(SHELL_EXECUTABLE_NAME);
    tail = head;
    tail->next = NULL;

    close(pd_rq[1]);
    close(pd_ret[0]);
    *request_fd = pd_rq[0];
    *return_fd = pd_ret[1];
}

static void do_shell(char *executable, int wfd, int rfd){
    char arg1[10], arg2[10];
    char *newargv[] = { executable, NULL, NULL, NULL };
    char *newenviron[] = { NULL };

    sprintf(arg1, "%05d", wfd);
    sprintf(arg2, "%05d", rfd);
    newargv[1] = arg1;
    newargv[2] = arg2;

    raise(SIGSTOP);
    execve(executable, newargv, newenviron);

    //execve() only returns on error
    perror("scheduler: child: execve");
    exit(1);
}

static void shell_request_loop(int request_fd, int return_fd){
    int ret;
    struct request_struct rq;

    //Keep receiving requests from the shell.
    for (;;) {
        if (read(request_fd, &rq, sizeof(rq)) != sizeof(rq)) {
            perror("scheduler: read from shell");
            fprintf(stderr, "Scheduler: giving up on shell request processing.\n");
            break;
        }

        //signals come and go when the TQ seconds end and the scheduler changes the
        //current process. So while the shell is in the middle of a request
        //processing we dont want an external signal to disrupt it and lead to
        //unwanted situations. As soon as the processing ends the signal get
        //unblocked again and if the processing gave a SIGKILL it will be examined
        //now in the sigchld_handler function
        signals_disable();
        ret = process_request(&rq);
        signals_enable();

        if (write(return_fd, &ret, sizeof(ret)) != sizeof(ret)) {
            perror("scheduler: write to shell");
            fprintf(stderr, "Scheduler: giving up on shell request processing.\n");
            break;
        }
    }
}

static void install_signal_handlers(void){

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
    if(kill(head->pid, SIGSTOP) < 0){
        perror("Stop error");
        exit(1);
    }
}

static void sigchld_handler(int signum){
    //it is safer to use write() instead of printf() in
    //asynchronous functions (signal handler functions)

    int pid;
    int status;

    for(;;){
        //waitpid(-1, 0, 0) acts like wait(). -1 means
        //wait for any child. When a child is stopped
        //signaled or exited then move on
        pid = waitpid(-1, &status, WUNTRACED | WNOHANG);
        if(pid == 0)
            break;

        explain_wait_status(pid, status);

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

            //set the alarm in 2 seconds to jump to sigalrm_handler and stop the child
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

static void signals_enable(void){
    sigset_t sigset;

    sigemptyset(&sigset);
    sigaddset(&sigset, SIGALRM);
    sigaddset(&sigset, SIGCHLD);

    if (sigprocmask(SIG_UNBLOCK, &sigset, NULL) < 0) {
        perror("signals_enable: sigprocmask");
        exit(1);
    }
}

static void signals_disable(void){
    sigset_t sigset;

    sigemptyset(&sigset);
    sigaddset(&sigset, SIGALRM);
    sigaddset(&sigset, SIGCHLD);

    if (sigprocmask(SIG_BLOCK, &sigset, NULL) < 0) {
        perror("signals_disable: sigprocmask");
        exit(1);
    }
}

static int process_request(struct request_struct *rq){
    switch (rq->request_no) {
        case REQ_PRINT_TASKS:
            sched_print_tasks();
            return 0;

        case REQ_KILL_TASK:
            return sched_kill_task_by_id(rq->task_arg);

        case REQ_EXEC_TASK:
            sched_create_task(rq->exec_task_arg);
            return 0;

        default:
            return -ENOSYS;
    }
}

static void sched_print_tasks(void){
    Node* temp = head;
    int i = 0;

    printf("Current ");

    for (i = 0; i < queue_items + 1; ++i){
        printf("PID: %d, name: %s \n", temp->pid, temp->name);
        temp = temp->next;
        if (temp == head) break;
    }
}

static int sched_kill_task_by_id(int id){
    Node* temp = head;

    while (temp->id != id) temp = temp->next;
    if (temp == head)
        return -1;
    else{
        printf("PID %d has been killed.\n", temp->pid);
        if (kill(temp->pid, SIGKILL) < 0) {
            printf("SIGKILL error");
        }

        head = temp; //set the current process to be the one that is being deleted and
                     //now when sigchld_handler is called it removes the right process
    }
    return id;
}

static void sched_create_task(char *executable){

    queue_items++;

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        exit(EXIT_FAILURE);
    }

    if(pid != 0){
        printf("Spawn process: %s PID: %d\n", executable, pid);
        show_pstree(getpid());

        //making the queue linear
        tail->next = NULL;

        insert_in_queue(queue_items, pid, executable);

        //making the queue cirqular again
        tail->next = head;
    }
    else{
        change_pname(executable);
        char *newargv[] = {executable, NULL};
        char *newenviron[] = {NULL};

        raise(SIGSTOP);

        execve(executable, newargv, newenviron);
    }
}
