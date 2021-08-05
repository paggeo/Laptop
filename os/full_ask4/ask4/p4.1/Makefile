CC = gcc
CFLAGS = Wall

all: scheduler prog

prog: prog.o proc-common.o
	$(CC) -$(CFLAGS) prog.o proc-common.o -o prog

scheduler: scheduler.o proc-common.o queue.o
	$(CC) -$(CFLAGS) scheduler.o proc-common.o queue.o -o scheduler

proc-common.o: proc-common.c
	$(CC) -$(CFLAGS) -c proc-common.c

prog.o: prog.c
	$(CC) -$(CFLAGS) -c prog.c

queue.o: queue.c
	$(CC) -$(CFLAGS) -c queue.c

scheduler.o:
	$(CC) -$(CFLAGS) -c scheduler.c

clean:
	rm *o prog scheduler
