#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <assert.h>
#include <sys/wait.h>
#include "proc-common.h"

#define SLEEP_TREE_SEC 6
#define SLEEP_LEAF 10

void fork_procs(void);

int main(void)
{
    pid_t pid;
    int status;

    pid = fork();
    //create first child (A)
    if (pid < 0) {
        perror("main: fork");
        exit(1);
    }
    if (pid == 0) {
        printf("Creating root A...\n");
        fork_procs();
        exit(1);
    }

    sleep(SLEEP_TREE_SEC);

    show_pstree(pid); //print process tree

    pid = wait(&status);
    explain_wait_status(pid, status);

    return 0;
}

void fork_procs(void){

    pid_t pB, pC, pD, p;
    int status;
    fprintf(stderr, "A creating B...\n");
    pB = fork();
    if(pB < 0){
        perror("error whle forking to B");
        exit(1);
    }
    else if(pB == 0){
        fprintf(stderr, "B creating D...\n");
        pD = fork();
        if(pD < 0){
            perror("error while forking to D");
            exit(1);
        }
        else if(pD == 0){
            /*-------child D code here-----------*/
            change_pname("D");
            fprintf(stderr, "D Sleeping...\n");
            sleep(SLEEP_LEAF);
            fprintf(stderr, "D Exiting...\n");
            exit(13);
        }
        else{
            /*--------child B code here----------*/
            change_pname("B");
            p = wait(&status);
            explain_wait_status(pD, status);
            sleep(SLEEP_LEAF);
            printf("B: All done,exiting...\n");
            exit(19);
        }
    }
    else{
        fprintf(stderr, "A creating C...\n");
        pC = fork();
        if(pC < 0){
            perror("while forking to C");
            exit(1);
        }
        else if(pC == 0){
            /*------child C code here------------*/
            change_pname("C");
            fprintf(stderr, "C Sleeping...\n");
            sleep(SLEEP_LEAF);
            fprintf(stderr, "C Exiting...\n");
            exit(17);
        }
        else{
            /*-----father A code here------------*/
            change_pname("A");
            p = wait(&status);
            explain_wait_status(p, status);
            p = wait(&status);
            explain_wait_status(p, status);
            sleep(SLEEP_LEAF);
            printf("A: All done,exiting...\n");
            exit(16);
        }
    }
}
