TITLE Program 5     (program5.asm)

; Author: Jeovani Vela
; Last Modified: 8/11/20
; OSU email address: velaje@oregonstate.edu
; Course number/section: CS271-400
; Assignment Number: Program 5                Due Date: 8/10/20  (*Used 2 Grace Days)
; Description: A small test program that gets 10 valid integers from the user and stores the numeric values in an array. The program than displays the integers, their sum, and their avg.

INCLUDE Irvine32.inc


	;********************
	;displayString	macro	stringAddr:req 
	;	This macro displays a string.
	;	preconditions: the OFFSET of the string must be pushed prior to invoking MACRO
	;	receives: 
	;		[ebp+ ] = some prompt				;did not include # w/ ebp+ as I use a variety of different prompts that are pushed in different locations on stack
	;	returns: outputs a string
	;********************
	displayString	MACRO	memoryAddress			
		push	edx
		mov	edx, memoryAddress
		call	WriteString
		pop	edx
	ENDM

	;*******************
	;getString	macro	stringAddr:req, arrayAddr:req, sizeOfArray:req 
	;		This macro prompts user to enter an unsigned int and reads the value entered as a string.
	;		preconditions:  the address of a prompt, array and size must be pushed prior to invoking MACRO.
	;		receives:
	;			[ebp+16] = prompt2
	;			[ebp+8] = OFFSET listArray
	;			[ebp+24] = SIZEOF listArray
	;		returns: generates a string
	;********************
	getString	MACRO	prompt, memoryAddress, size
		displayString	prompt
		push	ecx
		push	edx
		mov	edx, memoryAddress				;memoryAddress = destination string
		mov	ecx, size
		call	ReadString						;call to get num from user in string form & save to destination string, memoryAddress which is in edx register
		pop	edx
		pop	ecx
	ENDM

; (insert constant definitions here)

.data

; (insert variable definitions here)
	intro		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
	author		BYTE	"Written by: Jeovani Vela",0

	space		BYTE	"   ",0							;3 spaces

	;using example on pg. 82 to divide a string between multiple lines by using 0dh, 0ah after each dividing line and using 0 to show end of string, 0dh, 0ah
	prompt1		BYTE	"Please provide 10 unsigned decimal integers.",	0dh, 0ah				
				BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0dh, 0ah
				BYTE	"After you have finished inputting the raw numbers I will display a list", 0dh, 0ah
				BYTE	"of the integers, their sum, and their average value.",0

	prompt2		BYTE	"Please enter an unsigned number: ",0
	prompt3		BYTE	"You entered the following numbers: ",0
	errorMsg	BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0dh, 0ah
				BYTE	"Please try again: ",0
	prompt4		BYTE	"You entered the following numbers: ",0
	prompt5		BYTE	"The sum of these numbers is: ",0
	prompt6		BYTE	"The average is: ",0
	comma		BYTE	", ",0
	prompt7		BYTE	"Thanks for playing!",0

	inputArray	DWORD	10	DUP(?)
	outputArray 	DWORD	10	DUP(?)
	listArray	DWORD	10	DUP(?)
	sum		DWORD	?
	avg		DWORD	?

.code
main PROC
	
; (insert executable instructions here)
	
	push	OFFSET intro
	push	OFFSET author
	push	OFFSET space
	push	OFFSET prompt1
	call	introduction

	push	SIZEOF listArray
	push	OFFSET prompt2
	push	OFFSET errorMsg
	push	OFFSET sum
	push	OFFSET inputArray
	push	OFFSET outputArray
	push	OFFSET listArray
	call	getUserNums

	push	OFFSET avg
	push	sum
	call	calculateAvg

	push	OFFSET comma
	push	OFFSET prompt4
	push	OFFSET prompt5
	push	OFFSET prompt6
	push	sum
	push	avg
	push	OFFSET listArray
	push	OFFSET inputArray
	push	OFFSET outputArray
	call	printValues

	push	OFFSET prompt7
	call	farewell

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;*********************
;introduction- This procedure displays the title of the program, author, and the directions.
;		receives: 
;			[ebp+20] = OFFSET intro
;			[ebp+16] = OFFSET author
;			[ebp+12] = OFFSET space
;			[ebp+8]  = OFFSET prompt1
;		returns: nothing
;		preconditions: offsets of strings need to be pushed on stack frame to use with MACRO displayString
;		postconditions: none
;*********************
introduction PROC
	push	ebp
	mov	ebp, esp

	displayString	[ebp+20]
	call	Crlf
	displayString	[ebp+16]
	call	Crlf
	displayString	[ebp+12]
	call	Crlf
	displayString	[ebp+8]
	call	Crlf
	displayString	[ebp+12]
	call	Crlf

	pop		ebp
	ret		16
introduction ENDP

;*********************
;readVal - This procedure is called 10 times from getUserNum. It invokes the MACRO getString to get user number in string format and then validates the string in the procedure.
;		receives: 
;			[ebp+8] = OFFSET listArray
;			[ebp+12] = edi				;current element
;			[ebp+16] = OFFSET prompt2
;			[ebp+20] = OFFSET errorMsg
;			[ebp+24] = SIZEOF listArray
;		returns: a valid number in string form to the proper position passed in the array
;		preconditions: proper array postion must be passed to getString from getUserNum (ie edi)
;		postconditions: registers changed: eax, ebx, ecx, edx, esi
;********************* 
readVal PROC 
	push	ebp
	mov	ebp, esp

	pushad 

	getString	[ebp+16], [ebp+8], [ebp+24]				;prompt2, listArray, SIZEOF listArray

	start:	
		mov	esi, [ebp+8]			; point source index pointer to listArray
		mov	eax, 0
		mov	ebx, 1
		mov	ecx, 0
		mov	edx, 0
		cld

	chkForEndOfStr:
		lodsb
		cmp	ax, 0
		je	checkStrLength				
		inc	ecx
		jmp	chkForEndOfStr				;setup to loop until end of str

	checkStrLength:
		cmp	ecx, 10						;compare if # will fit in 10 digits, 32-bit fits in 10 digits
		jg	invalid
		mov	esi, [ebp+8]				;point to front of string
		add	esi, ecx
		dec	esi	
		std	

	keepReadingStr:
		lodsb
		cmp	ax, 48						;compare to ASIIC code # 48, which equals 0
		jl	invalid
		cmp	ax, 57						;compare to ASIIC code # 57, which equals 9
		jg	invalid

		sub	ax, 48
		push	edx
		mul	ebx
		pop	edx	
		jc	invalid						;jmp if carry (CF)

		add	edx, eax
		jc	invalid
		push	edx
	
		mov	eax, ebx
		mov	ebx, 10
		mul	ebx
		mov	ebx, eax

		mov	eax, 0
		pop	edx
	loop	keepReadingStr
	
	jmp		valid

	invalid:
		displayString	[ebp+20]
		call	CrLf
		getString	[ebp+16], [ebp+8], [ebp+24]
		jmp	start

	valid:	
		mov	ebx, [ebp+12]
		mov	[ebx], edx

	finished:
		popad
		pop	ebp
		ret	20
readVal ENDP

;*********************
;getUserNums - This procedure proceeds to gather the user's number by calling the readVal procedure 10 times to fill an array of size 10 and also calculate the sum.
;		receives: 
;			[ebp+8] = OFFSET listArray
;			[ebp+12] = OFFSET outputArray
;			[ebp+16] = OFFSET inputArray
;			[ebp+20] = OFFSET sum
;			[ebp+24] = OFFSET errorMsg
;			[ebp+28] = OFFSET prompt2 - asks user to enter unsigned int
;			[ebp+32] = SIZEOF listArray
;		returns: an array filled with values and the sum
;		preconditions:	listArray must be uninitialized
;		postconditions: registers changed: eax, ebx, ecx, edi
;*********************
getUserNums	PROC
	push	ebp
	mov	ebp, esp

	pushad

	mov	edi, [ebp+8]				;setting first element of array into edi register
	mov	ebx, 0						;sum counter
	mov	ecx, 10						;loop counter

	start:
		push	[ebp+32]
		push	[ebp+24]
		push	[ebp+28]
		push	edi						;current element
		push	[ebp+16]
		call	readVal
		add	ebx, [edi]				;add value in edi to ebx to keep track of the sum
		add	edi, 4					;add 4 to edi to move to next memory location in array
	loop	start

	finished:
		mov	eax, [ebp+20]			;sum address moved to eax
		mov	[eax], ebx			;move value of sum counter, ebx, to the variable sum
		popad
		pop	ebp
		ret	28
getUserNums ENDP

;******************
;calculateAvg - This procedure will calculate the average with the sum that is passed by value.
;		receives:
;			[ebp+8] = sum
;			[ebp+12] = OFFSET avg
;		returns: The average of the elements in the array
;		preconditions:	avg must be uninitialized and sum must already have a value
;		posconditions:	registers changed: eax, ebx, edx
;**********************
calculateAvg PROC
	push	ebp
	mov	ebp, esp

	push	eax
	push	ebx
	push	edx

	mov	eax, [ebp+8]
	mov	ebx, 10				
	mov	edx, 0		
	div	ebx						;eax/ebx

	mov	ebx, [ebp+12]
	mov	[ebx], eax				;avg variable now has value

	pop	edx
	pop	ebx
	pop	eax
	pop	ebp
	ret	8
calculateAvg ENDP

;**********************
;printValues - This procedure will print the string values held in the array by calling proc printArray, the avg and the sum.
;		receives:
;			[ebp+8] = OFFSET outputArray
;			[ebp+12] = OFFSET inputArray
;			[ebp+16] = OFFSET listArray
;			[ebp+20] = avg
;			[ebp+24] = sum
;			[ebp+28] = OFFSET prompt6
;			[ebp+32] = OFFSET prompt5
;			[ebp+36] = OFFSET prompt4
;			[ebp+40] = OFFSET comma
;		returns: does not return a value. instead displays values
;		preconditions: the variables avg and sum must already be initialized with a value as the array
;		postconditions: registers changed:
;*********************
printValues PROC
	push	ebp
	mov	ebp, esp

	call	Crlf
	call	Crlf
	displayString	[ebp+36]			;prompt stating "#'s entered:"
	call	Crlf

	push	[ebp+8]
	push	[ebp+12]
	push	[ebp+16]
	push	[ebp+40]
	call	printArray

	call	Crlf
	displayString	[ebp+32]			;show sum
	push	[ebp+24]
	push	[ebp+12]
	push	[ebp+8]
	call	WriteVal

	call	Crlf
	displayString	[ebp+28]			;show avg
	push	[ebp+20]
	push	[ebp+12]
	push	[ebp+8]
	call	WriteVal
	call	Crlf


	pop		ebp
	ret		36
printValues ENDP

;************************
;printArray - This procedure will use a loop so WriteVal instruction will print correct value in each spot of array.
;		receives:
;			[ebp+8] = OFFSET comma
;			[ebp+12] = OFFSET listArray
;			[ebp+16] = OFFSET inputArray
;			[ebp+20] = OFFSET outputArray
;		returns: shows values in the array
;		preconditions: array must be initialized already
;		postconditions: registers changed: ecx, esi
;***********************
printArray PROC
	push	ebp
	mov	ebp, esp

	push	esi
	push	ecx

	mov	esi, [ebp+12]				;source pointer pointing to listArray
	mov	ecx, 10						;loop counter

	print:
		push	[esi]					;pass current element
		push	[ebp+16]
		push	[ebp+20]
		call	WriteVal
		
		cmp		ecx, 1
		je		skipComma
		displayString	[ebp+8]			;comma
		add		esi, 4					;add 4 to source pointer to move to next memory location in array

		skipComma:						
										;left vacant to signify the intentional skip
			loop	print

	pop	ecx
	pop	esi
	pop	ebp
	ret	16
printArray ENDP

;****************************
;WriteVal - This procedure is called to convert an int to a string. It then uses the MACRO displayString to print the values.
;		receives:
;			[ebp+8] = OFFSET outputArray
;			[ebp+12] = OFFSET inputArray
;			[ebp+16] = esi
;		returns: none
;		preconditions: values must have been validated to ASIIC table # prior to this procedure
;		postconditions: resgisters changed: eax, ebx, ecx, edx, esi, edi
;****************************
WriteVal PROC

	push	ebp
	mov	ebp, esp

	pushad

	mov	eax, [ebp+16]			;number to print moved to eax
	mov	edi, [ebp+12]
	mov	ecx, 0					; counter
	cld
	
	convert:
		mov	edx, 0
		mov	ebx, 10
		div	ebx
		mov	ebx, edx
		add	ebx, 48
		push	eax
		mov	eax, ebx
		stosb
		pop	eax	
		inc	ecx
		cmp	eax, 0
		je	finished
		jmp	convert						;jump if more #'s to convert

	finished:							;string now reversed
		mov	esi, [ebp+12]
		add	esi, ecx
		dec	esi
		mov	edi, [ebp+8]

	flipStr:								;Used from demo program6 to reverse digits in string
		std
		lodsb
		cld
		stosb
	loop	flipStr

	mov	eax, 0							;move a 0 to denote end of string
	stosb									;move to edi
	displayString	[ebp+8]
	
	popad								
	pop	ebp
	ret	12					
WriteVal ENDP

;***************
;farwell: This procedure outputs a farwell message thanking user for playing.
;		receives: 
;			[ebp+8] = OFFSET prompt7
;		returns: nothing
;		preconditions: must push offset of prompt7
;		postconditions: none
;*****************
farewell PROC
	push	ebp
	mov	ebp, esp

	call	Crlf
	displayString	[ebp+8]
	call	Crlf

	pop	ebp
	ret	4
farewell ENDP

END main
