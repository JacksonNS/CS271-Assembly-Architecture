SECTION .data
	SIZE: equ 50000					;Declare a constant SIZE and set equal to 50000
	numRead: dd 0x0					;Declare number of characters read variable and set to 0
	curChar: dd 0x0					;Declare current character variable and set to 0
	curCount: dd 0x0				;Declare count of current character and set to 0
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
	xor edx,edx						;Ensure edx is set to 0 on all bits
	mov dl, [buf]					;Move first character read in to the dl register
	mov [curChar], dl				;Move first character read in from dl register to the curChar variable
	;Loop through read in data
_loop:
	mov dl, byte [curChar]			;Move the current character into the dl register to compare with next character read in
	cmp byte [buf+ecx], dl			;Compare current character to character currently in curChar buffer
	jne _charChange					;If equal, jump to increment label
	mov ebx, [curCount]				;Move count of current character to ebx register
	inc ebx							;Increment current count held in ebx
	mov [curCount], ebx				;Move increased count from ebx back to the curCount variable
	
	inc ecx							;Increment loop counter
	cmp ecx, [numRead]				;Compare current loop counter to number of characters read in
	jne _loop						;Return to the loop
	jmp _write						;Write encoded result and exit program
	;Add encoded character to output and change character to count
_charChange:
	push ecx						;Push current loop counter value onto the stack
	mov ecx, [outBufIdx]			;Put current output buffer index into ecx register
	mov byte [output + ecx], dl		;Put current character into the output buffer
	inc ecx							;Increment ecx to put current character count into output buffer
	add bl, IAZERO					;Add current count of characters to the ASCII equivilent of '0' and store answer in bl
	mov byte [output + ecx], bl		;Put current character count into the output buffer
	inc ecx							;Increment output buffer index for next time
	mov byte [outBufIdx], cl		;Set output buffer index to new value after adding first letter count
	pop ecx							;Pop current loop counter back into ecx register
	cmp byte [buf+ecx], 10			;Compare current character to new line character
	je _write						;If equal to new line, go to _write label and print output and exit program
	mov dl, [buf+ecx]				;Move character currently being read from input to dl register
	mov [curChar], dl				;Move dl register to curChar variable
	mov byte [curCount], 0			;Reset current character count to 0	
	jmp _loop						;Return to the loop
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
	mov edx, [outputLen + 1]		;Write as many characters as are in the output buffer
	int 80h

_exit:								;Make clean exit
	mov eax, 1						;Setup Exit system call
	mov ebx, 0						;Exit call
	int 80h							;Make system call
