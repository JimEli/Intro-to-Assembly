# Pima-CC-CIS250-Intro-to-Assembly
CIS-250 Labs and selected homework assignments.

Lab #1: Hello World Program. Adaptation of Kip Irvine's Project_sample for CIS 250 Lab #1. Display a simple text message on the console and perform some very basic math on numbers input by user. Checks for signed 32-bit integer overflow.

Lab #1 EC: Using lab1.asm as your start. Ask the user for 2 different numbers. Subtract them. If the difference is zero, print "the numbers are equal". If the difference is positive, print "the first number is greater than the second". If the difference is negative, print "the second number is greater than the first one".

Lab #2: Multiplication Fun! Part 1: Create a procedure, and in that procedure multiply two numbers together using mul. Then call the procedure from the main procedure. Part 2: Do bitwise mulitiplication using only shift and add statements. In your multiplication procedure multiply two numbers not using mul but by combining a fixed number of shift and add commands. For this part you only need to be able to handle 8 bit numbers so you don't need to use a loop for this part. Part 3: Add loop to bitwise multiplication procedure. Instead of using a fixed number of bitwise multipliers, use a loop to run the bitwise multiplication. Create a bitwise division procedure.
Notes:
* Russian peasant multiplication routine researched here: https://en.wikipedia.org/wiki/Ancient_Egyptian_multiplication
* Binary division by shift/subtraction researched here: http://courses.cs.vt.edu/~cs1104/BuildingBlocks/divide.030.html

Lab #3: Array Exercise 10 on pg. 364 of the textbook. Part 1 - Generate an array of formated characters. In a procedure create a print a matrix that writes stores and writes out characters in a format that writes 4 characters per line and for 4 lines. For example:
```text
   ABCD
   EFGH
   IJKL
   MNOP
```
To do this write, create a matrix that can hold all  the letters, and mark the end of the line store a new line character (0Dh, 0Ah). So your array will look something like this "ABCD", 0Dh, 0Ah, "EFGH", 0Dh, 0Ah, etc. Then write the array out with call WriteString. Part 2 - Write out random letters using RandomRange. Using the commands:
```C
   mov eax, 26
   call RandomRange ; in the irvine library
```
and an array made up of all the letters in the alphabet. Write out a 4X4 matrix that prints out 16 random letters taken from an alphabet matrix you created. Part 3 - Randomly generate vowels or consonants. Using randomRange that selects 0 or 1. If the value is 0, have your list randomly print out a vowel, if the value returned is 1, have a consonant randomly printed out.

Homework #6: ASM program that draws a square using ASCII characters and ASM video commands. Utilizes the extended ASCII character set.

Homework #7: FPU code to calculate:  double P = -M * (N + B);

Homework #8: BubbleSort.

