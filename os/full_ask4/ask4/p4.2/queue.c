//This implementation of queue.h is slightly different from the
//one in the previous exercise.

#include <string.h> //strdup()
#include <stdlib.h>
#include <stdio.h>

#include "queue.h"
#include "proc-common.h"
Node *tail, *head;
int queue_items;

void insert_in_queue(int id, pid_t pid, const char *name){
    //"const char *name" because the name cannot be changed
    Node *new_node = (Node *) malloc(sizeof(Node));
    new_node->id = id;
    new_node->pid = pid;
    new_node->name = strdup(name); //returns a pointer to a string
                                   //that is a dublicate of "name"
    Node *temp = head;
    while(temp->next!=NULL)
        temp = temp->next;

    temp->next = new_node;
    tail = new_node;
    tail->next = NULL;

    queue_items++;
}

void remove_from_queue(pid_t pid){
    Node *temp = head;
    while(temp->next->pid != pid)
        temp = temp->next;

    Node *node_to_delete = temp->next;
    free(node_to_delete);

    temp->next = temp->next->next;
    queue_items--;

    show_pstree(getpid());

    if(queue_items == 0){
        printf("Done!\n");
        exit(10);
    }
}
