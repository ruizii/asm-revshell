all:
	mkdir -p build
	gcc -c ./src/ip_to_bin.c -o ./src/ip_to_bin.o
	nasm -felf64 ./src/main.asm -o ./src/main.o
	ld ./src/main.o ./src/ip_to_bin.o -o ./build/revshell
