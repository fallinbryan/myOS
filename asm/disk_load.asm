; Load DH sectros to ES : BX from drive DL

disk_load:
	push dx			; Store DX on the stack for later
	mov ah, 0x02		; BIOS read sectors func
	mov al, dh		; Read DH sectors
	mov ch, 0x00		; Cylinder 0
	mov dh, 0x00		; Head 0
	mov cl, 0x02		; Sector 2 ( sector after boot sector )
	int 0x13		; BIOS interrupt
	
	jc disk_error_flag		; Jump if carry flag set from error

	pop dx			; restore DX from the stack
	cmp dh, al		; AL <- sectors read  DH <- sectors expected
	jne disk_error_uneq		; jump not equal
	ret

disk_error_flag:

	mov bx, DISK_ERROR_MSG_FLAG
	call print_string
	jmp $			; hang
	
disk_error_uneq:

	mov bx, DISK_ERROR_MSG_UNEQ
	call print_string
	jmp $			; hang

DISK_ERROR_MSG_FLAG db "Disk read error! Flag set", 0
DISK_ERROR_MSG_UNEQ db "Disk read error! UNEXPECTED BYTE COUNT",0
