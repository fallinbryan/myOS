print_string:
	pusha			; Push all registers to the stack		60
after_push:
	mov al, [bx]	; put the value stored at mem address in bx into ax
	cmp al, 0		; compare the value in ax to zero
	je exit			; jump if equal
	mov ah, 0x0e	; BIOS routine teletype to screen  		B4 0E
	int 0x10		; call bios interrup  					CD 10
	add bx, 1		; increment the address in bx by one
	jmp after_push  ; loop
exit:
	popa			; Pop all registers back from the stack 61
	ret				; return to where called