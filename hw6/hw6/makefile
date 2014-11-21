all: encoder decoder

decoder: decoder.o
	ld -o decoder decoder.o
decoder.o: decoder.asm
	nasm -f elf -g -F stabs decoder.asm
	
encoder: encoder.o
	ld -o encoder encoder.o
encoder.o: encoder.asm
	nasm -f elf -g -F stabs encoder.asm

clean:
	rm encoder
	rm encoder.o
	rm decoder
	rm decoder.o
