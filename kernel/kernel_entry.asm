; Ensures that we jump straight into the kernel's entry function int main() { }

[bits 32]		; We're in protected mode by now, so use 32-bit instructions.
[extern main]		; Declare that we will be referencing he external symbol 'main'
[extern idtp]
				; so the linker can substitute the final address

call main		; invoke main() from the C kernel
jmp $			; Hang forever when return from the kernel

;  Loads the DTP defined in '_idtp' in the processor
;  Declared in C as extern void idt_load();

global _idt_load

_idt_load:
	pusha
	;call get_eip
	;mov eax, 0
	;call print_hex
	;shr edx, 16
	;mov eax, 0x10
	;call print_hex
	
	;jmp $
	lidt [idtp]
	
	popa
	ret
	
	get_eip:
		mov edx, [esp]
		ret


global _isr0
global _isr1
global _isr2
global _isr3
global _isr4
global _isr5
global _isr6
global _isr7
global _isr8
global _isr9
global _isr10
global _isr11
global _isr12
global _isr13
global _isr14
global _isr15
global _isr16
global _isr17
global _isr18
global _isr19
global _isr20
global _isr21
global _isr22
global _isr23
global _isr24
global _isr25
global _isr26
global _isr27
global _isr28
global _isr29
global _isr30
global _isr31

; 0: Divide By Zero Exception
_isr0:
	cli
	push byte 0	; A normal ISR stub that pops a dummy error code to keep
	push byte 0	; a uniform stack frame
	
	jmp isr_common_stub

; 1: Debug exception
_isr1:
	cli
	push byte 0
	push byte 1
	jmp isr_common_stub

_isr2:
	cli
	push byte 0
	push byte 2
	jmp isr_common_stub
	
_isr3:
	cli
	push byte 0
	push byte 3
	jmp isr_common_stub
	
_isr4:
	cli
	push byte 0
	push byte 4
	jmp isr_common_stub
	
_isr5:
	cli
	push byte 0
	push byte 5
	jmp isr_common_stub
	
_isr6:
	cli
	push byte 0
	push byte 6
	jmp isr_common_stub
	
_isr7:
	cli
	push byte 0
	push byte 7
	jmp isr_common_stub

; 8: Double Fault Exception
_isr8:
	cli
	push byte 8	; Note we DON't push a value on the stack for this one
			; It pushes one already.  Use this type of stub for exceptions
			; that pop error codes
	jmp isr_common_stub

;.. todo 9 to 31
 _isr9:
	cli
	push byte 0
	push byte 9
	jmp isr_common_stub
 _isr10:
	cli
	push byte 10
	
	jmp isr_common_stub
 _isr11:
	cli
	push byte 11
	
	jmp isr_common_stub
 _isr12:
	cli
	push byte 12
	
	jmp isr_common_stub
 _isr13:
	cli
	push byte 13
	
	jmp isr_common_stub
 _isr14:
	cli
	push byte 14
	
	jmp isr_common_stub
 _isr15:
	cli
	push byte 0
	push byte 15
	jmp isr_common_stub
 _isr16:
	cli
	push byte 0
	push byte 16
	jmp isr_common_stub
 _isr17:
	cli
	push byte 0
	push byte 17
	jmp isr_common_stub
 _isr18:
	cli
	push byte 0
	push byte 18
	jmp isr_common_stub
 _isr19:
	cli
	push byte 0
	push byte 19
	jmp isr_common_stub

 _isr20:
	cli
	push byte 0
	push byte 20
	jmp isr_common_stub
 _isr21:
	cli
	push byte 0
	push byte 21
	jmp isr_common_stub
 _isr22:
	cli
	push byte 0
	push byte 22
	jmp isr_common_stub
 _isr23:
	cli
	push byte 0
	push byte 23
	jmp isr_common_stub
 _isr24:
	cli
	push byte 0
	push byte 24
	jmp isr_common_stub
 _isr25:
	cli
	push byte 0
	push byte 25
	jmp isr_common_stub
 _isr26:
	cli
	push byte 0
	push byte 26
	jmp isr_common_stub
 _isr27:
	cli
	push byte 0
	push byte 27
	jmp isr_common_stub
 _isr28:
	cli
	push byte 0
	push byte 28
	jmp isr_common_stub
 _isr29:
	cli
	push byte 0
	push byte 29
	jmp isr_common_stub
 _isr30:
	cli
	push byte 0
	push byte 30
	jmp isr_common_stub
 _isr31:
	cli
	push byte 0
	push byte 31
	jmp isr_common_stub

; Call a C function here
[extern fault_handler]

; This the common ISR stub. Save the procesor state, sets up for kernel mode 
; segments, calls the C fault handler, and resotres the stack frame
isr_common_stub:
	pusha
	push ds
	push es
	push fs
	push gs
	mov ebx, DEBUG_MSG
	call print_string_pm
	jmp $
	mov ax, 0x10	; Load the kernel Data Segment descriptor
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov eax, esp	; Push us the stack
	push eax
	mov eax, fault_handler
	call eax	; A speacial call, preserves the EIP reg
	pop eax
	pop gs
	pop fs
	pop es
	pop ds
	popa
	add esp, 8	; Cleans up the pushed error code and pushed ISR number
	iret		; pops 5 this at once: CS, EIP, EFLAGS, SS, AND ESP

DEBUG_MSG:  db "COMMON Stub Called",0

VIDEO_MEMORY equ 0xb8000		; the location of the video memomry space
WHITE_ON_BLACK equ 0x0f			; White text on black background

;prints a null-terminated string pointed to by EDX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY		; set EDX to the start of vid mem
	add edx, eax
print_string_pm_loop:
	mov al, [ebx]			; Store the char at EBX in AL
	mov ah, WHITE_ON_BLACK		; Store the attributes in AH

	cmp al, 0			; if al==0, end of string, jump to done
	je print_string_pm_done

	mov [edx], ax			; Store the char and attributes at current char cell
	add ebx, 1			; Inc EBX to next char in string
	add edx, 2			; move to next char cell in vid mem

	jmp print_string_pm_loop	; loop around to print the next char

	

print_string_pm_done:
	popa
	ret
	
print_hex:
	pusha
	
	
	
	mov bx, HEX_OUT			; ONLY BX can be used as an address pointer
	mov ch, dh 				; should move 0001 1111 into ch
							;ch now has an 8 bit byte  xxxx yyyyy
	
	shr ch, 4	  			;  ch will have 0000 0001
	;mov bh, ch    			;  al will have 0000 0001
	call PRINT_HEX_CHAR		;  should print 1
	
	add bx, 0x1
	mov ch, dh  			; move 0001 1111 int ch
	and ch, 0x0F 			; ch now = 0000 1111
	;mov bh, ch
	call PRINT_HEX_CHAR     ;
	
	add bx, 0x1
	mov ch, dl
	
	shr ch, 4
	;mov bh, cl
	call PRINT_HEX_CHAR
	
	add bx,0x1
	mov ch, dl    			;  should move 1011 0110 into cl
							;  cl now has an 8 bit byte xxxx yyyyy
	and ch, 0x0F  			;  cl will have 0000 0110
	;mov bh, cl    			;  al will have 0000 0110
	call PRINT_HEX_CHAR		;  should print 6
	
	
	
	mov bx , HEX_OUT 		; print the string pointed to
	call print_string_pm 		; by BX
	
	popa
	ret
	
PRINT_HEX_CHAR:
		pusha
							; al has 0000 xxxx
		cmp ch, 0xa   		; compare al to 0xA bin 0000 1010
		  jl deci_digit  	; if al < 0xA, then its a decimal digit
		cmp ch, 0xf	  		; compare al to 0xF bin 0000 1111
		  jle hexi_digit  	; if al <= 0xF && al > 0xA, then is a hex digit
	 return_here:
		
		mov [bx], ch		
		
		popa
		ret
		
	deci_digit:
		or ch, 0x30
		jmp return_here
	hexi_digit:
		sub ch, 9
		or ch, 0x40
		jmp return_here	
		
HEX_OUT: db '0x0000 ',0