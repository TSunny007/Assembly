# Binary Search algorithm
.data
	myArray:   .word 1,4,8,9,10,11,12,13,50,490,512,513,514,525,530,600
	searchValue: .word 530
	myArraySize: .word 16
	failure: .asciiz "\Not present!\n"
	success: .asciiz "\Contained at index: "
.text 

main:				
	la $a0, myArray
	add $a3, $zero, $zero
	lw $a1, searchValue 
	lw $a2, myArraySize
	j new_proc
	
new_proc: 
beq $a2, $zero, proc_fail # If the ’size’ in focus is 0 then we automatically fail
srl $a2, $a2, 1 #divide the ’current focus size’ into half to act as the pivot for elimination

#add the last ’pivot number’ we used, because we are looking for a number higher than it (everything including it and numbers in lower index are eliminated).
add $t0, $a2, $a3 
sll $t1, $t0, 2 #Multiply by 4 to go to the pivot in focus because each index takes 4 bytes (a word)
add $t2, $a0, $t1 # add this relative distance to get to desired index to the beginning of our array, so we can retrieve the number correctly
lw $t3, 0($t2) #The retrieval process
beq $t3, $a1, proc_succ #If there is a match in values then our job is finished so jump to success

#If it is greater than what we are looking for then treat the current high as maximum (because we already halved ’size’) and conduct the same procedure again
bgt $t3, $a1, call_again 
add $a3, $zero, $t0 #If the ’pivot’ is less than what we are looking for then we need to add it to our ’offset’ (treat as new lower bound)

call_again: #This is called AUTOMATICALLY if the pivot was less than desired value
addi $sp, $sp, -4 #digs the stack one word deeper to store the previous $ra
sw $ra, 0($sp) #store the previous return address because we are about to jump and return
jal new_proc #automagically jumps and links back here after a return. This is pretty close to how recursion works even in high level languages
lw $ra, 0($sp) #load the previous $ra to prepare for ’step return’
addi $sp, $sp, 4 #end of this stack’s life
jr $ra #’step return’

proc_succ: 
li $v0,4 # 4 is to print a string prompt
la $a0, success
syscall

li $v0, 1 # 1 is to print a number (the index)
move $a0, $t0 
syscall

li $v0, 10
syscall

proc_fail: 
addi $v0, $zero, -1 

li $v0,4 # 4 is to print a string prompt
la $a0, failure
syscall

li $v0, 10
syscall
