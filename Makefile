all:
	gcc -c ./ip_to_bin.c -o ip_to_bin.o
	nasm -felf64 ./main.asm
	ld main.o ip_to_bin.o -o main
