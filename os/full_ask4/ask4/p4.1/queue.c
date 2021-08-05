//This implementation of a queue works for this program and its not generic.

#include <string.h> //strdup()
#include <stdlib.h>
#include <stdio.h>

#include "queue.h"

Node *tail, *head;
int queue_items;

void insert_in_queue(pid_t pid, const char *name){
    //"const char *name" because the name cannot be changed
    Node *new_node = (Node *) malloc(sizeof(Node));
    new_node->pid = pid;
    new_node->name = strdup(name); //returns a pointer to a string
                                   //that is a dublicate of "name"
    Node *temp = head;
    while(temp->next!=NULL)
        temp = temp->next;

    temp->next = new_node;
    tail = new_node;


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

    if(queue_items == 0){
        printf("Done!\n");
        exit(10);
    }
}
