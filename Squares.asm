# ~~~~~~~~~~~~~~~~~~~~ author: Tarun Sunkaraneni~~~~~~~~~~~~~~~~~~~~
# Next Square: a MIPS assembly program in the MARS simulator that solves the following problem.
# Given a number N and its square (N2), the square of N + 1 can be computed with the following equation: (N +1)2 = N^2 +2*N +1 = N^2 +N +(N +1).
# In other words, computes the square of N +1 by adding N and N +1 to the square of N. The program should have a main routine that 
# (i) prompts the user to enter the values for N and N2, 
# (ii) reads in these two integer values and confirms they are greater than zero (print an error message and exit if this is not true),
# (iii) enters a loop that prints the squares of numbers (N + i) from i = 1 to i = 3. The loop calls a procedure ”nextsq” to implement the math.
# Procedure nextsq takes in arguments X and X2 and returns the value X2 + X + (X + 1).
.data
	n: .word 0
	n_square: .word 0
	# we store three strings here, one for the input prompt 
	prompt: .asciiz "\Enter N and N^2 (both positive):\n" 
	# and two strings for the output. 
	output: .asciiz "\Next 3 squares are: " 
	failed_output: .asciiz "\The input is erroneous\n" 
.text
main:
	# prompt the user for the value of N
	li $v0, 4 # 4 is to display a string
	la $a0, prompt
	syscall 
	
	# Get the user's input (N)
	li $v0,5 # 5 is to load an integer
	syscall
	# store first input (N) in $t0
	move $a0, $v0
	
	# Get the user's input (N^2)
	li $v0,5 # 5 is to load an integer
	syscall
	# store first input (N)
	move $a1, $v0	
	# where we could fail
	bltz $a0, fail
	bltz $a0, fail
	# now we won't fail 	
	move $t0, $zero # nextsq needs to run three times
	j nextsq
nextsq:	
	beq $t0, 3, success # N^2 will already be in $a1
	addi $t2, $a0, 1 # this is the N + 1 term
	add $t3, $t2,$a0 # N + (N+1) = 2N+1
	add $t3, $t3, $a1 # 2N+1 + N^2 = N^2 + 2N + 1
	
	li $v0, 1
	move $a0, $t3
	syscall
	# print space, 32 is ASCII code for space
	li $a0, 32
	li $v0, 11  # syscall number for printing character
	syscall
	
	addi $t0, $t0, 1 # incrementing our "for" loop
	move $a0, $t2 # move N+1 into N for our next number
	move $a1, $t3 # move N^2 + 2N + 1 into N^2 for our next number
	jal nextsq                
	j exit
	
fail:	# prompt the error message
	li $v0, 4 # 4 is to display a string
	la $a0, failed_output # displays our failure message
	syscall 
	j exit                     # Exit 
success:
	# print space, 32 is ASCII code for end of text
	li $a0, 3
	li $v0, 11  # syscall number for printing character
	syscall
exit:
    	li      $v0, 10              # terminate program run and
    	syscall 
