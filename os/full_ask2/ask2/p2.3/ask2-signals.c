#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <assert.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <string.h>
#include "proc-common.h"
#include "tree.h"

#define SLEEP_TREE_SEC 1

void create_children(struct tree_node *);
void handler();

int got_signal = 0;

int main(int argc, char **argv){
    struct tree_node *root;
    pid_t pid;
    int status;


    if(argc != 2){
        fprintf(stderr,"Usage: ./ask2-signals [input file]\n");
        exit(1);
    }

    if(open(argv[1], O_RDONLY) < 0){
        perror("Error");
    }

    root = get_tree_from_file(argv[1]);


    pid = fork();
    if(pid < 0){
        perror("Error");
        exit(2);
    }
    if(pid == 0){
        create_children(root);
        exit(0);
    }


    sleep(SLEEP_TREE_SEC);
    show_pstree(pid);


    kill(pid,SIGCONT);


    pid = wait(&status);
    explain_wait_status(pid, status);
    return 0;
}


void create_children(struct tree_node *t){
    int i = 0;
    int status;
    pid_t childPid[t->nr_children];
    pid_t pid;

    change_pname(t->name);

    for(i=0;i < t->nr_children;i++){

        childPid[i] = fork();
        if(childPid[i] == 0){
            change_pname((t->children + i)->name);

            if((t->children + i)->nr_children == 0){

                signal(SIGCONT, handler);
                raise(SIGSTOP);
                printf("Haha,hey mama %s its me,%s,your favorite child.\n",t->name, (t->children + i)->name);
                exit(0);
            }
            else{
                create_children(t->children + i);
            }
        }

    }


    signal(SIGCONT, handler);
    raise(SIGSTOP);



    for(i=0;i < t->nr_children;i++)
    {
        kill(childPid[i], SIGCONT);

        pid = wait(&status);
        explain_wait_status(pid, status);

    }

    printf("Hey,I am %s,ooo,those children are trying.Can I have a nap too?\n", t->name);

    exit(0);
}


void handler(){
    got_signal = 1;
}
