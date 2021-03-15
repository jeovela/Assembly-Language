TITLE Program Template     (template.asm)

; Author:
; Last Modified:
; OSU email address: 
; Course number/section:
; Assignment Number:                 Due Date:
; Description:

INCLUDE Irvine32.inc

space	MACRO	x
	LOCAL	again
	push	eax
	push	ecx
	mov		al, '  '
	mov		ecx, x
	again:
		call	WriteChar
		loop	again

		pop     ecx
		pop		eax
ENDM

; (insert constant definitions here)
	MAX = 2
.data

; (insert variable definitions here)
	mystring BYTE\
		"jeovani vela the playa",0

 intro_1   BYTE    "Welcome, "
  userName  BYTE    "Fred."
  intro_2   BYTE    "What's up?"
  count     DWORD   0

.code
main PROC
	MOV   EDX, OFFSET intro_1
  CALL  WriteString
  CALL  CrLf
  MOV   EDX, OFFSET userName
  CALL  WriteString
  CALL  CrLf
  MOV   EDX, OFFSET intro_2
  CALL  WriteString
  CALL  CrLf


	

	;mov		edx, OFFSET mystring
	;call	writeString

; (insert executable instructions here)
	;push	1
	;push	1
	;push	5
	;call	rFinal

	;mov		EAX, 25
	;call    writeDec
	;mov		EBX, 7
	;call    writeDec
	;mov     EDX, 0
	;DIV		EBX
	;mov     EAX, EDX
	;call	writeDec



	exit	; exit to operating system
main ENDP

; (insert additional procedures here)
rFinal	PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+16]
	mov		ebx, [ebp+12]
	mov		ecx, [ebp+8]
	mul		ebx
	mov		[ebp+16], eax
	cmp		ebx, ecx
	jge		unwind

	inc		ebx
	push	eax
	push	ebx
	push	ecx
	call	rFinal
unwind:
		mov		eax, [ebp+16]
		call	WriteDec
		;space	2
		pop		ebp
		ret		12
rFinal ENDP

END main
