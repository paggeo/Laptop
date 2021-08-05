CC = gcc
CFLAGS = Wall -O2 -g

all: scheduler-shell shell prog

scheduler-shell: scheduler-shell.o proc-common.o queue.o
	$(CC) -o scheduler-shell scheduler-shell.o proc-common.o queue.o

shell: shell.o proc-common.o
	$(CC) -o shell shell.o proc-common.o

prog: prog.o proc-common.o
	$(CC) -o prog prog.o proc-common.o

scheduler-shell.o: scheduler-shell.c
	$(CC) -$(CFLAGS) -o scheduler-shell.o -c scheduler-shell.c

proc-common.o: proc-common.c
	$(CC) -$(CFLAGS) -o proc-common.o -c proc-common.c

scheduler.o: scheduler.c
	$(CC) -$(CFLAGS) -o scheduler.o -c scheduler.c

shell.o: shell.c
	$(CC) -$(CFLAGS) -o shell.o -c shell.c

prog.o: prog.c
	$(CC) -$(CFLAGS) -o prog.o -c prog.c

queue.o: queue.c
	$(CC) -$(CFLAGS) -c queue.c

clean:
	rm -r scheduler-shell shell prog *o
