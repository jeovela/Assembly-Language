TITLE Program 3     (program3.asm)

; Author: Jeovani Vela
; Last Modified: 7/26/20
; OSU email address: velaje@oregonstate.edu
; Course number/section: CS-271
; Assignment Number: Program 3                Due Date: 7/26/20
; Description: Ask user to enter a number 1-400, validate if # is in range, then the program displays all of the composite numbers up to and including the nth composite.
;			   Results are displayed 10 composite #'s per line with at least 3 spaces between numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)

	MAXLIMIT = 400
	LOWLIMIT = 0

	MAXPERLINE = 10

.data

; (insert variable definitions here)

	intro		BYTE	"Composite Numbers            Programmed by Jeovani",0					;included my first name only per example showing on assignment #3
	prompt1		BYTE	"Enter the number of composite numbers you would like to see.",0
	prompt2		BYTE	"I'll accept orders for up to 400 composites.",0
	prompt3		BYTE	"Enter the number of composites to display [1 .. 400]: ",0
	prompt4		BYTE	"Out of Range. Try again.",0
	prompt5		BYTE	"Results certified by Jeovani.   Goodbye.",0
	spaces		BYTE	"   ",0			; 3 spaces

	userNum		DWORD	?
	currentNum	DWORD	2
	itemPerLine	DWORD	0
	found		DWORD	0
	totalComps	DWORD	0




.code
main PROC
  
; (insert executable instructions here)
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;*******************
;introduction Procedure: Displays name of program, programmer and directions for user to follow. 
;	preconditions: none
;	postconditions: none
;	receives: none
;	returns : none
;********************
introduction PROC
	mov		edx, OFFSET intro
	call	WriteString
	mov		eax, 100
	;mov     ebx, 30
	;div		ebx
	call	writedec
	call	Crlf
	call	Crlf

	mov		edx, OFFSET prompt1
	call	WriteString
	call	Crlf

	mov		edx, OFFSET prompt2
	call	WriteString
	call	Crlf
	call	Crlf

	ret
introduction ENDP

;******************
;getUserData Proceudre: Will ask user to enter # 1-400, then call a sub-procedure (validate) to make sure # is in range. 
;	preconditions: userNum must be uninitalized as it will be initialized with # input by user once verified
;	postconditions: # input by user is read into eax register, value moved from eax to variable userNum, then sub-procedure called to ensure range of 1-400
;	receives: integer from user (readInt)
;	returns: userNum is initialized with valid #
;******************
getUserData PROC
	mov		edx, OFFSET prompt3
	call	WriteString
	call	readInt
	mov		userNum, eax
	call	validate				;call sub-procedure
	ret
getUserData ENDP

;*******************
;validate Procedure: This procedure will take a parameter passed by value in userNum and validate it to make sure it is a # 1- 400. 
;	preconditions: userNum must contain an integer to be validated
;	postconditions: none
;	receives: Max and Low Limit are global variables, value of userNum
;	returns: userNum contains valid integer
;*******************
validate PROC
	cmp		userNum, LOWLIMIT
	jle		outOfRange
	cmp		userNum, MAXLIMIT
	jg		outOfRange
	call	Crlf
	jmp		complies		;jumps if userNum is in range 1 - 400

	outOfRange:
		mov		edx, OFFSET prompt4
		call	WriteString
		call	Crlf
		call	getUserData

	complies:
		ret
validate ENDP

;********************
;showComposites: This procedure will display the composite numbers 10 items per line and create a new line once 10 items are reached in a line.
;	preconditions: found == 0, totalComps == 0
;	postconditions: none
;	receives: MaxPerLine - global variable, currentNum
;	returns: prints composite #'s
;*********************
showComposites PROC
	searchForComposite:
		mov		found, 0			;found is used as bool variable
		call	isComposite			;sub-procedure called
		cmp		found, 1			
		je		printCompNum

		inc		currentNum
		mov		eax, totalComps
		cmp		eax, userNum			;if totalComps found is < userNum, cont. searching for composite numbers, else jmp to finished
		jl		searchForComposite
		jmp		finished

	printCompNum:
		mov		eax, currentNum
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString

	;procedure starts here and then jmp to the top with the instruction called
	inc		currentNum
	inc		itemPerLine
	cmp		itemPerLine, MAXPERLINE			;if == 10, then jmp to newLine as there are 10 items in the current line
	je		newLine
	jmp		searchForComposite

	newLine:
		call	Crlf
		mov		itemPerLine, 0			;reset variable to 0 in order to track items for newLine
		jmp		searchForComposite

	finished:
		ret
showComposites ENDP

;*********************
;isComposite: This procedure will check if a number is a composite number or not. 
;	preconditions: currentNum must be moved to ecx, ecx inc, eax == 0 & edx == 0
;	postconditions: ecx decrements each loop to == 1
;	receives: ecx > 1, edx == 0, eax contains an int, of which is a possible composite #
;	returns: an incremented totalComps variable to represent a found composite #
;*********************
isComposite PROC
	mov		ecx, currentNum
	dec		ecx

	checkForComposite:
		cmp		ecx, 1
		je		finish
		mov		edx, 0
		mov		eax, currentNum
		div		ecx
		cmp		edx, 0			
		je		compFound		;comp = composite

	loop	checkForComposite

	compFound:
		mov		found, 1		;set bool variable to true
		inc		totalComps		;inc totalComps which acts as a tracker to compare with userNum

	finish:
		ret				;return back to local procedure showComposites where isComposite procedure was called
isComposite ENDP

;*****************
;farewell: This procedure displays farewell message to user
;	preconditions: none
;	postconditions: none
;	receives: none
;	returns: none
;*****************
farewell PROC
	call	Crlf
	call	Crlf
	mov		edx, OFFSET prompt5
	call	WriteString
	call	Crlf
	call	Crlf
	ret
farewell ENDP

END main
