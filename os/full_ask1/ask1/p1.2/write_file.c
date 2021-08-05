#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "doWrite.h"

void write_file(int fd,const char *infile){// fd ==fd_w
	char buff[1024];
	int i ;
	for(i=0;i<1024;i++){
	buff[i]=(char)0;}
	ssize_t rcnt;
	size_t len ;
 	int fd_r=open(infile,O_RDONLY);
	int eof=0;
	while (eof==0){
		rcnt = read(fd_r,buff,sizeof(buff)-1);
		if (rcnt == 0) eof=1;/*end_of_file*/
		if (rcnt == -1)perror("read");/*dont_read_file*/
	 
	}	
  len = strlen(buff);
  doWrite(fd ,buff, len );
}
