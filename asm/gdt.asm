; GDT   Global Descriptor Table
;3,593,269,290 = 0xd62cf02a
;1,024,000 = 0f a0 00
gdt_start:


gdt_null:		; the mandatory null descriptor
	dd 0x0		; 'dd' meand define double word  (4 bytes)
	dd 0x0

gdt_code:		; the code segment descriptor
	; base = 0x0, limit = 0xfffff
	; 1st flags:	(Seg is present) 1 (Ring 0=3 priviledge)00 (desc table type)1 -> 1001b
	; type flags:	(Descriptor tyep code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
	; 2nd flags:	(granularity 0=1byte, 1=4kbyte)1 (Op Size:32-bit default)1 (64-big seg)0 (Available for system)0 -> 1100b
	dw 0xA000 	; Limit		(bits 0-15)
	dw 0x0		; Base		(bits 0-15)
	db 0x0		; Base		(bits 16-23)
	db 10011010b	; 1st flags, type Flags
	db 11001111b	; 2nd flags, Limit (bits 16-19)
	db 0x0		; Base (bits 24-31)

gdt_data:		; the data segment descriptor
	; Same as the code segment except for the type flags:
	; type flags:	(code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
	dw 0xA000	; Limit		(bits 0-15)
	dw 0x0		; Base		(bits 0-15)
	db 0x0		; Base		(bits 16-23)
	db 10010010b	; 1st flags, type Flags
	db 11001111b	; 2nd flags, Limit (bits 16-19)
	db 0x0		; Base (bits 24-31)

gdt_end:	; The reason for putting a label at the end of the 
		; GDT is so we can have the assemble calculate
		; the size of the GDT for the GDT descriptor (below)

; GDT descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1	; Size of our GDT, always less one
					; of the true size
	dd gdt_start			; Start address of our GDT

; Define some hand constants for the GDT segment descriprot offsets, which
; are what segment registers mst contain when in protected mode. For example
; when we set DS = 0x10 in PM, the CPU know that we mean it to use the
; segment described at offset 0x10 (ie 16 bytes) in our GDT, which in our
; case is the DATA segment (0x0 -> NULL; 0x08-> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


