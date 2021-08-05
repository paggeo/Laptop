CC = gcc
CFLAGS = -Wall
all: first second

first: zing.o main.o
	$(CC) $(CFLAGS)  zing.o main.o -o linking
main.o: main.c
	$(CC) $(CFLAGS) -c main.c

second: zing.o zing2.o main2.o
	$(CC) $(CFLAGS) main.o zing.o zing2.o -o second
zing2.o:
	$(CC) $(CFLAGS) -c zing2.c
main2.o:
	$(CC) $(CFLAGS) -c main2.c
clean:
	rm  main.o  zing2.o main2.o linking second
