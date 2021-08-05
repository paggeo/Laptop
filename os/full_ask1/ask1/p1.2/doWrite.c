#include <unistd.h>
#include <stdio.h>
#include <string.h>
void doWrite(int fd, const char *buff, int len){
	size_t indx=0;
	ssize_t wcnt;
	do{
		wcnt=write(fd, buff + indx , len - indx);
		if (wcnt ==-1)perror("write");
		indx += wcnt;
	} while (indx < len);
}

