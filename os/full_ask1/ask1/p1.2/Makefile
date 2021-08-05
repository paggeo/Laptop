fconc: doWrite.o write_file.o fconc.o
	gcc -o fconc doWrite.o write_file.o fconc.o
doWrite.o: doWrite.c
	gcc -Wall -c doWrite.c
write_file.o: write_file.c
	gcc -Wall -c write_file.c
fconc.o: fconc.c
	gcc -Wall -c fconc.c
