all: encoder decoder

decoder: decoder.o
	ld -o decoder decoder.o
decoder.o: decoder.asm
	nasm -f elf -g -F stabs decoder.asm -l decoder.lst
	
encoder: encoder.o
	ld -o encoder encoder.o
encoder.o: encoder.asm
	nasm -f elf -g -F stabs encoder.asm -l encoder.lst
