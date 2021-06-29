TITLE Program Template     (template.asm)

; Author: Jeovani Vela
; Last Modified: 6/26/2020
; OSU email address: velaje@oregonstate.edu
; Course number/section: (CS271-400)
; Assignment Number:  #1               Due Date: 7/6/2020
; Description: Display my name and program title on the output screen. Next, display instruction for user asking to input 2 nums to calculate sum, difference, product, quotient and remainder of the nums. 
;              Lastly, display terminating message.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; (insert variable definitions here)
heading			BYTE	"        Elementary Arithmetic    by Jeovani Vela",0			;strings must end w/ 0 - variable contains header for project
instructions	BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.",0
sentSpace		BYTE	" ",0															; this is so I can print out a space between sentence lines of code ie sentSpace

firstInt	DWORD	?		;this variable is left uninitialized and will hold user's input for first number
secInt		DWORD	?		;uninitialized and will hold user's input for second number

prompt1		BYTE "First number: ",0
prompt2		BYTE "Second number: ",0
prompt3		BYTE " remainder ",0
prompt4		BYTE "Impressed? Bye!",0

addResult	DWORD ?		;uninitialized, holds the result for addition
subResult	DWORD ?		;uninitialized, holds the result for subtraction
multiplyResult	DWORD ?	;uninitialized, holds the result for multiplication
divisionResult	DWORD ?	;uninitialized, holds the result for division
remainder	DWORD ?		;uninitialized and will hold the remainder from division

addSign		BYTE " + ",0	
equalSign	BYTE " = ",0
minusSign	BYTE " - ",0
multiplySign	BYTE " * ",0
divisionSign	BYTE " / ",0


.code
main PROC

; (insert executable instructions here)
;displays header to user
mov	edx, OFFSET heading			;moving the string called heading to register edx to be prepared for WriteString directive
call	WriteString
call	Crlf

;display a line of space between header and instructions
mov	edx, OFFSET sentSpace
call	WriteString
call	Crlf

;display instructions to user to enter 2 numbers
mov	edx, OFFSET instructions	;sending memory location of instruction to edx register to be called upon with WriteString
call	WriteString
call	Crlf

;display space
mov	edx, OFFSET sentSpace
call	WriteString
call	Crlf

;read first integer entered by user into memory and display the number
mov	edx, OFFSET prompt1
call	WriteString
call	ReadInt					;read first integer input by user
mov	firstInt, eax			;move from eax register to firstInt variable

;read second integer entered by user into memory and display the number
mov	edx, OFFSET prompt2
call	WriteString
call	ReadInt				;read first integer input by user
mov	secInt, eax			;move from eax register to secInt variable

;display space
mov	edx, OFFSET sentSpace
call	WriteString
call	Crlf

;add the two numbers
mov	eax, firstInt	;move firstInt to eax register
add	eax, secInt		;add secInt to firstInt located in eax
mov	addResult, eax	;move the result from adding the two numbers from the eax register to the variable, addResult

;subtract the two numbers
mov	eax, firstInt
sub     eax, secInt
mov	subResult, eax		;move the result from subtracting the two numbers from the eax register to the variable, subResult

;mulitply the two numbers
mov	eax, firstInt
mul	secInt					;multiplying the secInt with the firstInt located in register eax
mov	multiplyResult, eax		;move the result from subtracting the two numbers from the eax register to the variable, multiplyResult

;divide both numbers
mov	eax, firstInt
div	secInt					;dividing the secInt with the firstInt located in register eax
mov	divisionResult, eax
mov	remainder, edx			;edx register holds the remainder from division, so moving that value to the variable, remainder

;display the result of adding the two integers in equation form
mov	eax, firstInt				;display first integer
call	WriteDec
mov	edx, OFFSET addSign			;display add sign
call	WriteString
mov	eax, secInt					;display second integer
call	WriteDec
mov	edx, OFFSET equalSign		;display equal sign
call	WriteString
mov	eax, addResult				;display sum
call	WriteDec					
call	Crlf

;display the result of subtracting the two integers in equation form
mov	eax, firstInt			;display first integer
call	WriteDec
mov	edx, OFFSET minusSign	;display subtraction sign
call	WriteString
mov	eax, secInt				;display second integer
call	WriteDec
mov	edx, OFFSET equalSign	;display equal sign
call	WriteString
mov	eax, subResult			;display result of subtraction
call	WriteDec
call	Crlf

;display the result of multiplying the two numbers
mov	eax, firstInt				;display first int
call	WriteDec
mov	edx, OFFSET multiplySign	;display multiply sign
call	WriteString
mov	eax, secInt					;display second int
call	WriteDec
mov	edx, OFFSET equalSign		;display equal sign
call	WriteString
mov	eax, multiplyResult			;display multiplication result
call	WriteDec
call	Crlf

;display the result of dividing the numbers
mov	eax, firstInt					;display first integer
call	WriteDec
mov	edx, OFFSET divisionSign		;display division sign
call	WriteString
mov	eax, SecInt						;display second integer
call	WriteDec
mov	edx, OFFSET equalSign			;display equal sign
call	WriteString
mov	eax, divisionResult				;display result of dividing numbers
call	WriteDec
mov	edx, OFFSET prompt3				;show the word remainder
call	WriteString
mov	eax, remainder					;display remainder in number form
call	WriteDec
call	Crlf							;new Line

;display space
mov	edx, OFFSET sentSpace
call	WriteString
call	Crlf

;display last prompt asking if user is impressed and printing goodbye
mov	edx, OFFSET prompt4				;calling prompt 4
call	WriteString
call	Crlf							;newLine

;exit	; exit to operating system
Invoke ExitProcess, 0
main ENDP

; (insert additional procedures here)

END main
