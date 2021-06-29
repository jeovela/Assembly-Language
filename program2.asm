TITLE Program 2     (program2.asm)

; Author: Jeovani Vela
; Last Modified: 7/13/2020
; OSU email address: velaje@oregonstate.edu
; Course number/section: CS-271
; Assignment Number: Project 2               Due Date: 7/13/2020
; Description: This program will ask the user his/her name, ask user how many Fibonacci terms to be displayed 1-46 and checking them for range. If confirmed they are within range, it will display the results and say goodbye to the user.

INCLUDE Irvine32.inc

; (insert constant definitions here)

	MAXLIMIT = 46	
	LOWLIMIT = 0

.data

; (insert variable definitions here)
	heading		BYTE "Fibonacci Numbers",0
	heading2	BYTE "Programmed by Jeovani Vela",0
	nameRequest BYTE "What's your name? ",0
	greetUser	BYTE "Hello, ",0
	prompt1		BYTE "Enter the number of Fibonacci terms to be displayed.",0		;The example in Proj 2 assignment did NOT include a period, but I added one assuming it was needed as next line was capitalized in example.
	prompt2		BYTE "Give the number as an integer in the range [1..46].",0
	prompt3		BYTE "How many Fibonacci terms do you want? ",0
	prompt4		BYTE "Out of Range. Enter a number in [1..46] ",0	
	prompt5		BYTE "Results certified by Jeovani Vela",0
	prompt6		BYTE "Goodbye, ",0
	period		BYTE ".",0
	spaces		BYTE "     ",0		;5 spaces
	usersName	BYTE 99 DUP(?)		;created an array called usersName that will hold the user's name. It has a size of 100 spots that are not initialized.
	numOfTerms	DWORD ?				;variable will hold the number user inputs. Should be a number between 1-46. Not initialized
	fiboNum		DWORD ?
	temp1		DWORD ?				;temporary variable(s) to hold values that will be interchanged
	temp2		DWORD ?
	columnTrk	DWORD ?				;trk = tracker


.code
main PROC

; (insert executable instructions here)

;---------------------------------
;Introduction - This will display the program title and programmer's name. Will also ask user for name and greet them.
;----------------------------------
	call	Crlf
	mov	edx, OFFSET heading	
	call	WriteString				
	call	Crlf						
	mov	edx, OFFSET heading2		
	call	WriteString
	call	Crlf						
	;call	Crlf

	;greet
	mov	edx, OFFSET	nameRequest		
	call	WriteString
	mov	edx, OFFSET usersName		;move memory address of usersName variable to edx register
	mov	ecx, 99						;set counter to 99, to match the size of the array, usersName. (0-99) 
	call	ReadString					;read the user's input. It goes into the memory address of usersName that was moved to the edx register
	mov	edx, OFFSET greetUser		
	call	WriteString					
	mov	edx, OFFSET usersName		
	call	WriteString					
	call	Crlf

;------------------------------------
;User Instructions - These lines of code will ask user how many Fibonacci terms to display and to enter integer between 1-46
;-----------------------------------
	mov	edx, OFFSET prompt1
	call	WriteString
	call	Crlf
	mov	edx, OFFSET prompt2
	call	WriteString
	call	Crlf
	call	Crlf
	jmp	getUserData					;jump to section

outOfRange:
	mov	edx, OFFSET prompt4
	call	WriteString
	call	Crlf

;-----------------------------
;Get User Data - read the input by user and move from eax register to variable, numOfTerms. Also check if integer is in range.
;-----------------------------
getUserData:
	mov	edx, OFFSET prompt3
	call	WriteString
	call	readInt
	mov	numOfTerms, eax

	cmp	numOfTerms, LOWLIMIT
	jle	outOfRange					;will jump if <= to prompt informing user input is out of Range
	jg	checkMax					;if input > 0, jump to checkMax to ensure integer is not > 46.

checkMax:
	cmp	numOfTerms, MAXLIMIT
	jg	outOfRange

;-------------------------------
;Display Fibs - solve and display Fibonnaci numbers in required spacing
;-------------------------------
	call	Crlf
	mov	eax, 1
	mov	temp1, eax
	call	WriteDec			;display first 1
	mov	edx, OFFSET spaces
	call	WriteString

	mov	eax, 1
	mov	temp2, eax
	call	WriteDec			;display second 1
	mov	edx, OFFSET spaces
	call	WriteString

	dec	numOfTerms			;decrementing the variable that will act as counter twice since I spit out the first two items outside of loop (1 and 1)
	dec	numOfTerms
	mov	ecx, numOfTerms		;moving the counter t o ecx register					
	mov	eax, 2
	mov	columnTrk, eax		;setting tracker for columns @ 2 since first two items are already output. Starting at 0 would throw it all off

FibLoop:	
	mov	eax, temp1
	add	eax, temp2
	mov	fiboNum, eax
	call	WriteDec
	mov	edx, OFFSET spaces
	call	WriteString

	inc	columnTrk
	mov	edx, 0
	mov	eax, columnTrk
	mov	ebx, 5
	div	ebx
	cmp	edx, 0
	jz	newLine
	jmp	noNewLine

newLine:
	call	Crlf

noNewLine:
	mov	eax, temp2
	mov	temp1, eax
	mov	eax, fiboNum
	mov	temp2, eax
	loop	FibLoop

;----------------------------
;Farewell - have computer output farewell note to user
;----------------------------
	call	Crlf
	call	Crlf
	mov	edx, OFFSET prompt5
	call	WriteString
	mov	edx, OFFSET period
	call	WriteString
	call	Crlf

	mov	edx, OFFSET prompt6
	call	WriteString
	mov	edx, OFFSET usersName
	call	WriteString
	mov	edx, OFFSET period
	call	WriteString
	call	Crlf
	call	Crlf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
