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

#define SLEEP_TREE_SEC 6
#define SLEEP_LEAF 10
void create_children(struct tree_node *);

int main(int argc, char **argv){
    struct tree_node *root;
    int status;
    id_t pid;

    //Usage
    if(argc != 2){
        fprintf(stderr,"Usage: ./fork-tree [input file]\n");
        exit(1);
    }

    if(open(argv[1], O_RDONLY) < 0){
        perror("Error");
    }

    root = get_tree_from_file(argv[1]);

    //create first child
    pid = fork();
    if(pid < 0){
        perror("Error");
        exit(2);
    }
    if(pid == 0){
        create_children(root);
        exit(0);
    }
    kill(pid,SIGKILL);
    sleep(SLEEP_TREE_SEC);
    show_pstree(pid);

    pid = wait(&status);
    explain_wait_status(pid, status);
    return 0;
}

void create_children(struct tree_node *t){
    int i = 0;
    int status;
    pid_t pid;

    change_pname(t->name);
    printf("I am %s,and about to create some children.\n",t->name);
    //Generate all children through this while loop. A child may be a leaf or a middle node.
    for(i=0;i < t->nr_children;i++){

        if(!fork()){
            change_pname((t->children + i)->name);
            if((t->children + i)->nr_children == 0){
                //--------------------LEAF CODE---------------------------------------------
                printf("My name is %s and I am going to sleep\n", (t->children + i)->name);
                sleep(SLEEP_LEAF);
                printf("Child %s woke up and exiting now...\n", (t->children + i)->name);
                exit(0);
            }
            else{
                //MIDDLE NODE

                create_children(t->children + i);
            }
        }

    }

    //wait for children to exit, print theis exit status and exit
    for (i=0; i<t->nr_children; i++){
        pid = wait(&status);
        explain_wait_status(pid, status);
    }
    exit(0);
}
