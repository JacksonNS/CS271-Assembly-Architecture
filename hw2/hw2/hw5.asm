SECTION .data
	SIZE: equ 1024	;define SIZE to be 1024 bytes large
	input: dd 0x0	;create variable input and initialize it to 0
	ErrorMsg: db "ERROR! Unbalanced",10	;define error message
	ErrorLen: equ $-ErrorMsg	;calculate length in bytes of error message
	opnCtr: db 0x0	;create and initialize variable to count how many opening brackets are read in
SECTION .bss
	buf: resb SIZE ;reseve a 1024 byte long buffer
SECTION .text

global _start

_start:
	nop
	mov eax,3		;setup system call for Read instruction
	mov ebx, 0		;use STDIN
	mov ecx, buf	;setup buffer for read operation
	mov edx, SIZE	;read in 1024 bytes
	int 80H			;make system call of READ and store result in eax
	mov [input], dword eax	;store read in bytes in variable input
	
	mov ecx, 0		;setup counter to be 0
	;loop through read in data
_loop:
;check for opening bracket or brace
	cmp byte [buf+ecx], '{'	;compare current character in buffer to {
	je _push				;if equal, jump to _push label
	cmp byte [buf+ecx], '['	;compare current character in buffer to [
	je _push				;if equal, jump to _push label
	cmp byte [buf+ecx], '('	;compare current character in buffer to (
	je _push				;if equal, jump to _push label
;check for closing bracket or brace
	cmp byte [buf+ecx], '}'	;compare current character in buffer to }
	je _pop				;if equal, jump to _pop label
	cmp byte [buf+ecx], ']'	;compare current character in buffer to ]
	je _pop				;if equal, jump to _pop label
	cmp byte [buf+ecx], ')'	;compare current character in buffer to )
	je _pop				;if equal, jump to _pop label
	
_continue:	
	inc ecx				;increment ecx by 1
	cmp ecx,[input]		;compare ecx to number of bytes read in
	jb _loop			;if less than bytes read in, run loop again
	jmp _done			;if previous jump not executed, finish loop
	
_push:
	mov dx, [buf+ecx]	;move current character to 16 bit dx register
	push dx		;push current character to the stack
	inc byte [opnCtr]	;increment the counter for how many opening brackets have been read in
	jmp _continue		;jump to loop continuation point

_pop:
	pop dx				;pop value at top of stack to ax register
	cmp dx,0			;compare valued popped to 0
	jnz _decCtr			;if not zero, jump to _decCtr
	
_decCtr:
	dec byte [opnCtr]		;decrement counter of open brackets read in
	
	cmp [buf+ecx], byte'}'	;compare current character to }
	je _qBrace			;if equal, jump to _qBrace label
	cmp [buf+ecx], byte ']'	;compare current character to ]
	je _bracket			;if equal, jump to _bracket label
	cmp [buf+ecx], byte ')'	;compare current character to )
	je _paren			;if equal, jump to _paren label

_qBrace:
	cmp dl, '{'	;compare popped character to opening curly brace
	je _continue ;if equal, this set of braces is balanced, therefore continue loop
	jne _error	 ;if not equal, unbalanced, jump to error condition
	
_bracket:
	cmp dl, '['	;compare popped character to opening square bracket
	je _continue ;if equal, this set of braces is balanced, therefore continue loop
	jne _error	 ;if not equal, unbalanced, jump to error condition
_paren:
	cmp dl, '('	;compare popped character to opening paren
	je _continue ;if equal, this set of braces is balanced, therefore continue loop
	jne _error	 ;if not equal, unbalanced, jump to error condition
	
_error:
	mov eax, 4			;setup write system call
	mov ebx, 1			;use STDOUT
	mov ecx, ErrorMsg	;tell where to start printing from
	mov edx, ErrorLen	;tell how many bytes to print
	int 80H				;make system call to WRITE command
	jmp _exit			;jump to clean exit code
		
_done:
	cmp byte [opnCtr],0	;compare opnCtr variable to zero to ensure all opening brackets have closing
	jne _error		;if not equal to zero, jump to _error and print error message
	mov eax, 4		;setup WRITE system call
	mov ebx, 1		;use STDOUT
	mov ecx, buf	;start writing from buf variable, which holds the users inputted string
	mov edx, [buf]	;write the same number of characters as the user input
	int 80H			;make WRITE system call
	jmp _exit		;jump to clean exit code
		
_exit:
	mov eax, 1		;setup exit system call
	mov ebx, 0		;system call thing
	int 80H			;make EXIT system call
