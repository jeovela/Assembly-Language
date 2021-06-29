# 271

This repository contains all my coursework pertaining to CS-271: Computer Architecture & Assembly Language.
Below is a brief description of each program.

Program 1: Program asks user to enter two numbers. Program then calculates the values using elementary
arithmetic and displays the results to the user.

Program 2: Program calculates Fibonacci numbers. First, program will ask user how many Fibonacci numbers to
display. User must select a number in range of [1..46]. Program will validate user's input before proceeding.
Next, program will calculate and display Fibonacci numbers with at least 5 spaces between terms.

Program 3: Wrote a program to calculate composite numbers. First, the user is instructed to enter the number
of composites to be displayed, and is prompted to enter an integer in the range of [1...400]. The user
enters a number, n and the program verifies that 1 <= n <= 400. If n is out of range, the user is re-prompted
until user enters a value in the specified range. Finally, if number is in range, the program then calculates
and displays all of the composite numbers up to and including the nth composite. Results are displayed
10 composites per line with at least 3 spaces between the numbers.

Program 4: Wrote a program that gets a user to enter a # in the range of [min = 10 .. max = 200]. # is validated
before proceeding. Next, program will generate random integers in the range of [lo = 100 .. hi = 999], and
store them in consecutive elements of an array. Next, the program will display the integers before sorting
with 10 numbers per line. After displaying the unsorted integers, program will sort the list in descending
order. Program will calculate the median value and round it to the nearest integer to display along with
the sorted list with 10 numbers per line.

Program 5: Using ReadVal and WriteVal, wrote a program that read's a user's input as a string, and then
converts the string to numeric form. If the user enters non-digits or the number is too large for 32-bit
registers, an error message will be displayed and the number will be discarded. Conversion routines utilize
lodsb and/or stosb where necessary.
