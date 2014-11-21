hw4: hw4.o
	ld -o hw4 hw4.o
hw4.o: hw4.asm
	nasm -f elf -g -F stabs hw4.asm -l hw4.lst
