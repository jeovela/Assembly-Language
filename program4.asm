TITLE Program 4     (program4.asm)

; Author: Jeovani Vela
; Last Modified: 8/2/20
; OSU email address: velaje@oregonstate.edu
; Course number/section: CS-271
; Assignment Number: Program 4                 Due Date: 8/3/20
; Description: Ask user for a number in the range of 10-200, use that number to generate an exact # of random integers in the range of 100-999. Display the integers BEFORE sorting to 10 #'s per line.
;			   Then sort the list in descending order (ie largest first). Finally calcualte and display the median value, rounded to the nearest integer. Display sorted list to 10 #'s per line.

INCLUDE Irvine32.inc

; (insert constant definitions here)
	MIN = 10
	MAX = 200

	MAX_SIZE = 199		;created this global variable to use when I declare an array named listArray in .data

	LO = 100
	HI = 999

	MAXPERLINE = 10

.data

; (insert variable definitions here)
	prompt1		BYTE	"Sorting Random Integers			Programmed by Jeovani Vela",0
	prompt2		BYTE	"This program generates random numbers in the range [100 .. 999],",0			;created new line per example in assignment
	prompt3		BYTE	"displays the original list, sorts the list, and calculates the",0
	prompt4		BYTE	"median value. Finally, it displays the list sorted in descending order.",0

	prompt5		BYTE	"How many numbers should be generated? [10 .. 200]: ",0
	prompt6		BYTE	"Invalid input",0

	prompt7		BYTE	"The unsorted random numbers:",0
	prompt8		BYTE	"The sorted list:",0
	prompt9		BYTE	"The median is ",0
	
	period		BYTE	".",0
	spaces		BYTE	"   ",0					; 3 spaces

	count		DWORD	?						;leaving uninitialized as it will be filled by user and will be counter
	listArray	DWORD	MAX_SIZE DUP (?)
	tracker		DWORD	0						; this variable will be used to keep track of items per line
	




.code
main PROC

; (insert executable instructions here)
	push	OFFSET	prompt1
	push	OFFSET	prompt2
	push	OFFSET	prompt3
	push	OFFSET	prompt4
	call	introduction

	push	OFFSET	count
	push	OFFSET	prompt5
	call	getData		
 
	push	OFFSET	listArray
	push	count
	call	fillArray

	push	OFFSET	listArray
	push	count
	push	tracker
	push	OFFSET	prompt7
	call	displayList

	push	count
	push	OFFSET listArray
	call	sortList

	push	count
	push	OFFSET	listArray
	push	OFFSET	prompt9
	push	OFFSET	period
	call	displayMedian

	push	OFFSET	listArray
	push	count
	push	tracker
	push	OFFSET	prompt8
	call	displayList

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;*******************
;introduction - This procedure introduces the name of the program, programmer and what the program does
;	receives: 
;			[ebp+20] = prompt1
;			[ebp+16] = prompt2
;			[ebp+12] = prompt3
;			[ebp+8]  = prompt4
;	returns: none
;	preconditions: prompt1 through prompt4 must be pushed on stack
;	postconditions: changes register edx
;********************
introduction PROC
	push	ebp
	mov		ebp, esp

	mov		edx, OFFSET prompt1
	call	WriteString
	call	Crlf

	mov		edx, OFFSET prompt2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET prompt3
	call	WriteString
	call	Crlf
	mov		edx, OFFSET prompt4
	call	WriteString
	call	Crlf
	call	Crlf

	pop		ebp
	ret		16
introduction ENDP

;****************
;getData - This procedure receives a parameter (ie userNum) by reference and then validates it [10-200]
;	receives: 
;			[ebp+12] = count
;			[ebp+8]	 = prompt5
;			Global variables: MIN, MAX
;	returns: count with a valid # [10-200]
;	preconditions: count must be uninitialized
;	postconditions: changes registers eax, ebx, edx
;****************
getData PROC
	push	ebp
	mov		ebp, esp

	getNumber:
		mov		edx, OFFSET prompt5
		call	WriteString
		call	ReadInt

	validate:
		cmp		eax, MIN
		jl		invalidNum
		cmp		eax, MAX
		jg		invalidNum
		jmp		finished

	invalidNum:
		mov		edx, OFFSET prompt6
		call	WriteString
		call	Crlf
		jmp		getNumber

	finished:
		mov		ebx, [ebp+12]		;address of count moved in ebx
		mov		[ebx], eax			;value in eax moved to address in ebx
		pop		ebp
		ret		8
getData	ENDP

;************************
;fillArray - This procedure will fill the array, listArray with random integers
;	receives: 
;			[ebp+12] = OFFSET listArray
;			[ebp+8] =count
;	returns: listArray filled with random integers generated
;	preconditions: listArray must be uninitialized
;	postconditions: changes registers eax, ebx, ecx
;************************
fillArray PROC
	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp+8]		;count moved in ecx
	mov		edi, [ebp+12]		;move OFFSET of listArray into EDI to use with indirect addressing

	call	Randomize			;must only be called once like in C & C++. W/o this you get the same random #'s

	;used randomRange example from lecture 20 - Wk 5
	fill:
		mov		eax, hi
		sub		eax, lo
		inc		eax
		call	RandomRange
		add		eax, lo				;generate a # 100-999
		mov		[edi], eax			;moving value in eax to the sequential memory address location in listArray [edi]
		add		edi, 4				;add 4 to edi as operand size is DWORD and to progress through each spot in listArray's memory
	loop fill

	pop		ebp
	ret		8
fillArray ENDP

;*********************
;displayList - This procedure receives 3 parameters and displays the array, listArray.
;	receives:	
;			[ebp+20] = OFFSET listArray
;			[ebp+16] = count
;			[ebp+12] = tracker
;			[ebp+8]  = prompt7  (when procedure is called a second time, [ebp+8] = prompt8)
;	returns: does not return anything to .main, just displays items in array
;	preconditions: listArray must be initialized with random numbers generated in fillArray procedure
;	postconditions: changes registers eax, ebx, ecx, edx
;********************
displayList PROC
	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp+16]		;move counter into ecx
	mov		esi, [ebp+20]		;move OFFSET of listArray into ESI to use with indirect addressing
	mov		ebx, [ebp+12]		;move tracker to ebx
	
	;pass by reference string signifying unsorted list first time called and sorted list second time procedure is called
	call	Crlf
	mov		edx, [ebp+8]		;offset of prompt moved to edx register with call WriteString right after
	call	WriteString

	newLine:
		call	Crlf
		mov		ebx, 0			;reset tracker to 0 to track items in new line

	display:
		cmp		ebx, 10			;placed here to prevent a 0 from being printed after all elements are printed if counter is 20, 30, 40 etc...
		je		newLine
		mov		eax, [esi]
		call	WriteDec
		add		esi, 4
		mov		edx, OFFSET spaces
		call	WriteString
		inc		ebx
	loop	display

	pop		ebp
	ret		16
displayList ENDP

;************************
;sortList - This procedure will sort the values in the array that is passed by refernce in descending order and calculate the median
;	receives:
;			[ebp+8] = OFFSET listArray
;			[ebp+12] = count
;	returns: listArray is sorted in descending order.
;	preconditions: listArray must be initialized with random values from fillArray
;	postconditions: changes registers eax, ebx, ecx, edx
;************************
sortList PROC
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp+8]			;moving offset of listArray into esi
	mov		ecx, [ebp+12]			;count
	dec		ecx
	mov		ebx, edi				;save ptr to listArry in ebx

	outerLoop:
		mov		eax, edi
		mov		esi, ecx

		innerLoop:
 			add		edi, 4				;4 added b/c operand size is DWORD; progressing through each spot in array via memory+4
			mov		edx, [eax]			;move value currently in eax to edx
			cmp		edx, [edi]			;comparing value in edx with value in next item in listArray
			ja		keepGoing			;if left operand is above (ie higher in value) than right operand, ja to keepGoing insturction which will call innerLoop to run again to compare current value in eax to next value in listArray
			mov		eax, edi			;if left operand is not above than right operand, value moved to eax and loop continues to run with new value in eax

			keepGoing:	
				loop	innerLoop
				
		mov		edx, [ebx]				;moving ptr pointing to memory location in listArray to edx
		xchg	[eax], edx				;exhcange memory location edx with value in [eax]
		xchg	[ebx], edx

		add		ebx, 4
		mov		edi, ebx
		mov		ecx, esi
	loop	outerLoop
	
	pop		ebp
	ret		8
sortList	ENDP

;**********************
;displayMedian: This procedure will calculate the median out of the sorted array and display it.
;	receives:
;			[ebp+20] = count
;			[ebp+16] = OFFSET listArray
;			[ebp+12] = OFFSET prompt9
;			[ebp+8]  = OFFSET period
;	returns: displays the median to the display
;	preconditions: listArray must be initalized and be sorted in descending order
;	postconditions: changes registers eax, ebx, ecx, edx
;**********************
displayMedian PROC
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp+16]
	mov		eax, [ebp+20]

	call	Crlf
	call	Crlf
	mov		edx, [ebp+12]
	call	WriteString

	mov		ecx, 2
	cdq
	div		ecx
	cmp		edx, 0		;if remainder is == 0, jmp to evenNum, else it is a odd #
	je		evenNum
	
	mov		ecx, 4		;if odd, program continues as it skips the je instruction
	mul		ecx
	add		edi, eax
	mov		eax, [edi]
	call	WriteDec
	mov		edx, [ebp+8]
	call	WriteString
	call	Crlf
	jmp		finished

	evenNum:
		mov		ecx, 4
		mul		ecx
		add		edi, eax
		mov		eax, [edi]
		sub		edi, ecx
		add		eax, [edi]
		mov		ecx, 2
		cdq
		div		ecx
		cmp		edx, 0
		je		dontRound
		inc		eax				;round up #

	dontRound:
		call	WriteDec
		mov		edx, [ebp+8]
		call	WriteString
		call	Crlf

	finished:

	pop		ebp
	ret		16
displayMedian ENDP


END main
