;protected mode print string function

[bits 32]
; Define some constants
VIDEO_MEMORY equ 0xb8000		; the location of the video memomry space
WHITE_ON_BLACK equ 0x0f			; White text on black background

;prints a null-terminated string pointed to by EDX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY		; set EDX to the start of vid mem
	
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
