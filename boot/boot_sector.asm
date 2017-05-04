; A boot sector that boots a C kernel in 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000		; this is mem add offset where the kernel will load

	mov [BOOT_DRIVE], dl		; BIOS stores boot drive in DL, so store it
	mov bp, 0x9000			; Set up the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE		; announce boot starting from 16bit real mode
	call print_string
	call load_kernel		; Load the kernel
	call switch_to_pm		; Switch to protected mode, there is no return from there
	jmp $

; Include routines
%include "print_string.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 16]
; load_kernel
load_kernel:
	mov bx, MSG_LOAD_KERNEL		; print a msg that kernel is loading
	call print_string
	
	mov bx, KERNEL_OFFSET		; Set-up params for disk_load func
	mov dh, 15			; so that we load the first 15 sectors ( excluding
	mov dl, [BOOT_DRIVE]		; the boot sector) from the boot disk
	call disk_load

	ret

[bits 32]
;This is where we arrive after switching to and initialising protected mode
BEGIN_PM:
	mov ebx, MSG_PROT_MODE		; Use 32bit func to announce we in PM
	call print_string_pm

	call KERNEL_OFFSET		; Jump to the address of the loaded kernel code,
					; brace yourself and croww fingers

	jmp $				; hang

; Global Variables
BOOT_DRIVE		db 0
MSG_REAL_MODE		db "Started in 16-bit Real Mode",0
MSG_PROT_MODE		db "Successfully Landed in 32-bit PM", 0
MSG_LOAD_KERNEL		db "Loading kernel into RAM.", 0

; Bootsector Padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55

