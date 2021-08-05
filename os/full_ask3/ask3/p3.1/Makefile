CC = gcc -s -g
#compile multi-threaded applications with -pthread and when -g
#is use(for gdb info) use -O2 to optimize compilation again
CFLAGS = -Wall -O2 -pthread
LIBS =

all: pthread-test simplesync-atomic simplesync-mutex

##################### Pthread test ##############################
pthread-test: pthread-test.o
	$(CC) $(CFLAGS) -o pthread-test pthread-test.o

pthread-test.o: pthread-test.c
	$(CC) $(CFLAGS) -c -o pthread-test.o pthread-test.c

############### Simple sync (two versions) #######################
simplesync-mutex: simplesync-mutex.o
	$(CC) $(CFLAGS) -o simplesync-mutex simplesync-mutex.o $(LIBS)

simplesync-atomic: simplesync-atomic.o
	$(CC) $(CFLAGS) -o simplesync-atomic simplesync-atomic.o $(LIBS)

simplesync-mutex.o: simplesync.c
	$(CC) $(CFLAGS) -DSYNC_MUTEX -c -o simplesync-mutex.o simplesync.c

simplesync-atomic.o: simplesync.c
	$(CC) $(CFLAGS) -DSYNC_ATOMIC -c -o simplesync-atomic.o simplesync.c

########################### Clean ###############################
clean:
	rm -f *.o pthread-test simplesync-atomic simplesync-mutex
