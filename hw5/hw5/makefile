hw5: hw5.o
	ld -o hw5 hw5.o
hw5.o: hw5.asm
	nasm -f elf -g -F stabs hw5.asm -l hw5.lst
