#ifndef QUEUE_H_
#define QUEUE_H_

#include <unistd.h>

struct Node_t{
    pid_t pid;
    char *name;
    struct Node_t *next;
};

typedef struct Node_t Node;

void insert_in_queue();
void remove_from_queue();

#endif
