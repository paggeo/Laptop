#include <stdio.h>
#include <unistd.h>
#include "zing.h"

void zing2(){
	char *name;
	name = getlogin();
	printf("Geia sou magka %s!\n", name);
	zing();
}

