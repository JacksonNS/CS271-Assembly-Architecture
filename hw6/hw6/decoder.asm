SECTION .data
	SIZE: equ 50000					;Declare a constant SIZE and set equal to 50000
	numRead: dd 0x0					;Declare number of characters read variable and set to 0
	curChar: db 0x0					;Declare current character variable and set to 0
	curCount: db 0x0				;Declare count of current character and set to 0
	outBufIdx: dd 0x0				;Declare the index for the output buffer
	IAZERO: equ '0'					;Declare a constant IAZERO and set it equal to the ASCII code for the character '0'
	outputLen: db 0x0				;Declare output length variable and set it to 0
SECTION .bss
	buf: resb SIZE					;Reserve a buffer for read in
	output: resb SIZE				;Reserve an output buffer
SECTION .text
global _start:

_start:
	;Read user input in
	mov eax, 3						;Setup Read system call
	mov ebx, 0						;Use STDIN
	mov ecx, buf					;Place read in characters into the buffer
	mov edx, SIZE					;How many characters to read in
	int 80h							;Make system call
	
	mov dword [numRead], eax		;Set numRead to number of characters read in from user
	
	mov ecx,0						;Set ecx to 0 to begin loop counter
	xor edx,edx						;Ensure all bits in edx are set to 0
	;Loop through read in data
_loop:
	mov dl, byte [buf+ecx]			;Move the current character into the dl register to compare with next character read in
	cmp dl,10						;Compare current character with newline character
	je _write						;If equal to newline, jump to _write label to begin printing and exit
	inc ecx							;Increment ecx to get encoding
	mov bl, byte [buf+ecx]			;Move number of times repeated to bl register
	sub bl, IAZERO					;Subtract ASCII '0' from ASCII value of current count
	mov eax, 0						;Set al, the second loop counter, to 0
	push ecx						;Push ecx to store current location
	sub ecx, 1						;Subtract 1 from ecx to ensure output starts at the first character
	;Add current character to output buffer. Repeat until this encoded character is fully decoded
	.multi:
		mov edi, [outBufIdx]			;Put current buffer index in edi register
		mov [output+edi], dl			;Move current character to output buffer
		inc edi							;Increment edi register, which stores the output buffer index
		mov dword [outBufIdx], edi		;Store altered output buffer index into it's variable
		inc eax							;Increment second loop counter
		cmp bl, al						;Compare number of times to repeat character to current number of times printed
		jne .multi						;If not equal, run .multi loop again
		jmp .continue
	;Continue with the main loop
	.continue:
		pop ecx
		inc ecx							;Increment loop counter
		cmp ecx, [numRead]				;Compare current loop counter to number of characters read in
		jne _loop						;Return to the loop
		jmp _write						;Write encoded result and exit program
	;Add encoded character to output and change character to count
;Make Write system call
_write:
	mov ecx, [outBufIdx]			;Set ecx to current output buffer index
	mov byte [output + ecx], 10		;Add newline character to output
	mov ecx, 0						;Set loop counter to 0
	
	.loop:							;loop through output buffer and count characters in it
		cmp byte [output+ecx], 10	;Compare current character in output buffer to newline character
		je .finish					;If equal to newline, jump to the .finish local label
		mov dl, [outputLen]			;Move output length variable to dl
		inc dl						;Increment output length
		mov byte [outputLen], dl	;Store incremented length into output length variable
		inc ecx						;Increment loop counter
		jmp .loop					;Run loop again
		
	.finish:
		mov eax, 4						;Setup Write system call
		mov ebx, 1						;Use STDOUT
		mov ecx, output					;Use the output buffer
		mov edx, [outBufIdx + 1]		;Write as many characters as are in the output buffer
		int 80h

_exit:								;Make clean exit
	mov eax, 1						;Setup Exit system call
	mov ebx, 0						;Exit call
	int 80h							;Make system call
