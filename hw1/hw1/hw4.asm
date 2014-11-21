SECTION .data			;Data section
	
	x:dd 0x2 				; create variable x in memory
	y:dd 0x0 				; create variable y in memory
	z:dd 0x0 				; create variable z in memory
	a:dd 0x0 				; create variable a in memory
	temp: dd 0x0			; create variable temp in memory
	temp1: dd 0x0			; create variable temp1	in memory
	temp2: dd 0x0			; create variable temp2	in memory
	
SECTION .text			;Code section
	
global 	_start ; Entry point for Linker
	
_start:
	nop 					; no-op makes debugging easier
	mov eax, [x] 			; eax = 2
	add eax, 0x4			; eax = 6
	mov [y], dword eax 		; y = 6
	mov ebx, [x]			; ebx = 2
	add ebx, 0x1			; ebx = 3
	sub eax, ebx			; eax = 3
	mov [z], dword eax		; z = 3
	mov eax, [z]			; eax = 3. Done for safety.
	mov ebx, [x]			; ebx = 2
	add eax, ebx			; eax = 5
	mov [temp], dword eax	; temp = 5, x + z
	mov eax, [y]			; eax = 6
	mov ebx, 0x2			; ebx = 2
	div ebx					; eax = 3
	mov [temp1], dword eax	; temp1 = 3, y / 2
	mov eax, [z]			; eax = 3
	mov ebx, [z]			; ebx = 3. Done for safety.
	mul ebx					; eax = 9. Done for safety, mul eax would work just fine.
	mov [temp2], dword eax	; temp2 = 9, z * z
	mov eax, [temp]			; eax = 5
	mov ebx, [temp1]		; ebx = 3
	mul ebx					; eax = 15, (x+z)*(y/2)
	mov ebx, [temp2]		; ebx = 9
	add eax, ebx			; eax = 24
	mov [a], dword eax		; a = 24
	mov ebx, [z]			; ebx = 3
	mov eax, [a]			; eax = 24
	add eax, ebx			; eax = 27
	mov [x], dword eax		; x = 27
	
	mov eax, [x]			; eax = 27
	mov ebx, [y]			; ebx = 6
	mov ecx, [z]			; ecx = 3
	mov edx, [a]			; edx = 24
	
	MOV eax,1		; Code for Exit Syscall
	mov ebx,0		; Return a code of zero	
	int 80H			; Make kernel call
	
	
	
