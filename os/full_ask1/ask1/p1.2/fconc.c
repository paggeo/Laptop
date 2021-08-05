#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "write_file.h"
int main(int argc, char **argv)
{	
	if (argc>4||argc<3 ){
		printf("Usage: ./fconc infile1 infile2 [outfile (default:fconc.out)] \n" );
		return 1;
  	}

	if (argc==3 ){
		argv[3]="fconc.out";
       }
  	FILE* arxio_1 = fopen (argv[1],"r");
	FILE* arxio_2 = fopen (argv[2],"r");
	if(arxio_1== NULL|| arxio_2== NULL){
		printf("No such file or directory \n"); 
		return 1;
	}
       
	if(*argv[1]==*argv[3]||*argv[2]==*argv[3]){
		printf("Infile different from outfile \n");
		return 1;
	}
		  
	int fd_w;

 	fd_w=open(argv[3],O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR|S_IWUSR);
	write_file(fd_w , argv[1]);
	write_file(fd_w , argv[2]);
	return 0;
}
