;printHex2
;test val is 0x1fb6
; A = 0x41 = 0100 0001    	0xA = 1010 
; B = 0x42 = 0100 0010		0xB = 1011
; C = 0x43 = 0100 0011		0xC = 1100
; D = 0x44 = 0100 0100		0xD = 1101
; E = 0x45 = 0100 0110		0xE = 1110
; F = 0x46 = 0100 0111		0xF = 1111

; value is stored in dx : dh = 0001 1111 dl=1011 0110 
; HEX_OUT: db '0x0000 ',0

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
	call print_string 		; by BX
	
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
		;int 0x10			;BIOS interrupt cd10
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
