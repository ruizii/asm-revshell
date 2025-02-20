all:
	mkdir -p build
	nasm -felf64 ./src/main.asm -o ./src/main.o
	ld ./src/main.o -o ./build/revshell
