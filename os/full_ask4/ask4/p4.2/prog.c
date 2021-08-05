#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#include "proc-common.h"

#define NMSG 20
#define DELAY 130

int main(int argc, char *argv[])
{
	int i, delay, pid;

	 //Print a number of messages,
	 //use a random delay, so that processes terminate
	 //in random order.

	pid = getpid();
	srand(pid); //rand() produces a sequence of numbers if called in a loop.
				//This sequence will be random but always the same in every 				//execution.
				//To achieve different sequences I should call srand(time(0))
				//or srand(getpid()), or any other argument that is different
				//in every execution. srand() initializes the sequence.

	delay = 30 + ((double)rand() / RAND_MAX) * DELAY;
	printf("%s: Starting, NMSG = %d, delay = %d\n",
		argv[0], NMSG, delay);

	for (i = 0; i < NMSG; i++) {
		printf("%s[%d]: This is message %d\n", argv[0], pid, i);
		compute(delay);
	}

	return 0;
}
