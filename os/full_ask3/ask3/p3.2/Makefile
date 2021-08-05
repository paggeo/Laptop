CC = gcc
#compile multi-threaded applications with -pthread and when -g
#is use(for gdb info) use -O2 to optimize compilation again
CFLAGS = -Wall -O2 -pthread

all: mandel

##################### Mandelbrot #############################
mandel: mandel-lib.o mandel.o
	$(CC) $(CFLAGS) -o mandel mandel-lib.o mandel.o

mandel-lib.o: mandel-lib.h mandel-lib.c
	$(CC) $(CFLAGS) -c -o mandel-lib.o mandel-lib.c

mandel.o: mandel.c
	$(CC) $(CFLAGS) -c -o mandel.o mandel.c 

########################### Clean ###############################
clean:
	rm -f *.o mandel
