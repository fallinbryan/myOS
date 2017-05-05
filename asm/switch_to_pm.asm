;Making the switch to 32-bit Protected mode

[bits 16]
switch_to_pm:

	cli		; We must switch all of the interrupts until we have 
			; set-up the protected mode iterrupt vector
			; otherwise interrupts will run riot
	lgdt [gdt_descriptor] 	; Load the global desc table, which defines
				; the protected mode segments

	mov eax, cr0		; To make the switch to protected mode, we set
	or  eax, 0x1		; the first bit of CR0, a control register
	mov cr0, eax
	;mov eax, CODE_SEG
	;mov cs, eax
	
	jmp 0x08:init_pm	; Make a far jump (to a new seg) to our 32 bit
				; code. This also forces the CPU ot flush its cache of
				; pre-fetched and real-mode decoded instructions, which can
				; cause problems

[bits 32]
; Initalize registers and the stack once in PM
init_pm:

	mov ax, DATA_SEG	; Now in PM, our old segs are meaningless,
	mov ds, ax		; so we point our seg registers to the 
	mov ss, ax		; data selector we defined in our GDT
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000	; Update our stack pos so it is right
	mov esp, ebp		; at the top of the free space

	call BEGIN_PM		; finally call some well-known label

