CC = gcc
CFLAGS = Wall

all: arithmetical-expression-tree.o proc-common.o tree.o
	$(CC) -$(CFLAGS) arithmetical-expression-tree.o proc-common.o tree.o -o arithmetical-expression-tree

tree.o: tree.c
	$(CC) -$(CFLAGS) -c tree.c

proc-common.o: proc-common.c
	$(CC) -$(CFLAGS) -c proc-common.c

arithmetical-expression-tree.o: arithmetical-expression-tree.c
	$(CC) -$(CFLAGS) -c arithmetical-expression-tree.c

clean:
	rm arithmetical-expression-tree.o proc-common.o tree.o arithmetical-expression-tree
