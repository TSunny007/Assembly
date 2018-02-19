# Compressed Genomic Data: Write a MIPS assembly program in the MARS simulator that accepts an input string of size less than
# 40 characters, applies the following decom- pression algorithm to the string, and then prints the resulting decompressed string.
# In the input string, if a ”#” is encountered, the next byte is interpreted as a number i between 0-255;
# the output string would then replace the # and its i with i-32 consecutive occurrences of the character ”A” 
# If i=32 , then the output string would replace the # and its i with one occurrence of ”#”. Similarly,
# ”$” corresponds to multiple occurrences of the character ”C”; ”%” corresponds to multiple occurrences of the character ”G”;
# ”&” corresponds to multiple occurrences of the character ”T”. For all other encountered characters,
# the output string should simply reproduce that character. We will only test your code with valid inputs, i.e.,
# strings of under 40 characters and i > 31. Keep an ASCII table handy.
.data 
	prompt: .asciiz "\Provide an input of less than 40 characters:\n"
	output_prompt: .asciiz "\The decompressed string is:\n"
	input:  # this will hold our input (compressed) string
		.space 40
		.text	
main:
	li $v0,4 # 4 is to print a string prompt
	la $a0, prompt
	syscall
	
	li $v0, 8 # 8 is to read in a string
	la $a0, input # beginning of where to write in data
	li $a1, 40 # how long we expect the string to be
	syscall
	
	li $v0,4 # 4 is to print a string prompt
	la $a0, output_prompt # we are going to have to print the "punchline" before our actual logic
	syscall
	
	move $a1, $zero # a1 will be our "POINTER"
	jal body # this starts processing our string

body:	
	lbu $t1, input($a1) # processes the current char
	
	beq $t1,'\0',exit # null character means we've reached end of the input
	beq $t1,'#',pound # similarily we have different jumps for $, $, %, and &
	beq $t1,'$',dollar 
	beq $t1,'%',percent
	beq $t1,'&',ampersand
	
	# The following code will only hit if the current character isn't a compression character
	move $a0, $t1 # If we're just priniting this character, then we need to load it onto $a0
	li $v0, 11    # print_character instruction
	syscall
	addi $a1, $a1, 1 # move the head one position.
	j body
pound:  
        # we have to read the character after the pound too
	addi $a1, $a1, 1
	lbu $t1, input($a1)
	
	addi $a1, $a1, 1 # advances to the start of the SECOND character AFTER the pound.
	beq $t1,' ', print_pound # if it is just a space (32) then we just need to print a pound then return to body
	
	sub $a2, $t1, ' ' # a2 stores the number of times we actually need to print A, and this symbolizes (i-32)
	j print_A # otherwise we need to print some amount of A's to our output
	
print_A:
	li $a0, 'A'  # A is what we need to print
	li $v0, 11    # print_character instruction
	syscall
	subi $a2, $a2, 1 # keep decrementing the a2 becasue we just printed an A
	beq $a2, $zero, body # if it's zero proceed back to the body, so we can continue processing our string. 
	j print_A
	
print_pound:
	li $a0, '#'  # pound is  what we need to print
	li $v0, 11  # print_character instruction
	syscall
	j body # ready to go back and continue processing our string
#--------------------------------------- Dolla
dollar:  
        # we have to read the character after the dollar too
	addi $a1, $a1, 1
	lbu $t1, input($a1)
	
	addi $a1, $a1, 1 # advances to the start of the SECOND character AFTER the dollar.
	beq $t1,' ', print_dollar # if it is just a space (32) then we just need to print a pound then return to body
	sub $a2, $t1, ' ' # a2 stores the number of times we actually need to print C, and this symbolizes (i-32)
	j print_C # otherwise we need to print some amount of C's to our output
	
print_C:
	li $a0, 'C'  # C is what we need to print
	li $v0, 11    # print_character instruction
	syscall 
	subi $a2, $a2, 1 # keep decrementing the a2 becasue we just printed a C
	beq $a2, $zero, body # if it's zero proceed back to the body, so we can continue processing our string. 
	j print_C 
	
print_dollar:
	li $a0, '$'  # dollar is  what we need to print
	li $v0, 11  # print_character instruction
	syscall
	j body # ready to go back and continue processing our string
#-------------------------------------- Percent
percent:  
        # we have to read the character after the percent too
	addi $a1, $a1, 1
	lbu $t1, input($a1)
	addi $a1, $a1, 1  # advances to the start of the SECOND character AFTER the percent.
	beq $t1,' ', print_percent # if it is just a space (32) then we just need to print a percent then return to body
	sub $a2, $t1, ' ' # a2 stores the number of times we actually need to print G, and this symbolizes (i-32)
	j print_G # otherwise we need to print some amount of G's to our output
	
print_G:
	li $a0, 'G'  # G is what we need to print
	li $v0, 11    # print_character instruction
	syscall
	subi $a2, $a2, 1 # keep decrementing the a2 becasue we just printed a G
	ble $a2, $zero, body # if it's zero proceed back to the body, so we can continue processing our string. 
	j print_G
	
print_percent:
	li $a0, '%'   # percent is  what we need to print
	li $v0, 11  # print_character instruction
	syscall
	j body # ready to go back and continue processing our string
#-------------------------------------- Ampersand	
ampersand:
	# we have to read the character after the ampersand too
	addi $a1, $a1, 1
	lbu $t1, input($a1)
	addi $a1, $a1, 1 # advances to the second charactr past the pound.
	beq $t1,' ', print_ampersand # if it is just a space (32) then we just need to print a ampersand then return to body
	sub $a2, $t1, ' ' # a2 stores the number of times we actually need to print G, and this symbolizes (i-32)
	j print_T # otherwise we need to print some amount of G's to our output
	
print_T:
	li $a0, 'T'  # T is what we need to print
	li $v0, 11    # print_character instruction
	syscall
	subi $a2, $a2, 1 # keep decrementing the a2 becasue we just printed a T
	ble $a2, $zero, body # if it's zero proceed back to the body, so we can continue processing our string. 
	j print_T
	
print_ampersand:
	li $a0, '&'  # ampersand is  what we need to print
	li $v0, 11  # print_character instruction
	syscall
	j body # ready to go back and continue processing our string
exit:
    	li      $v0, 10              # terminate program run 
    	syscall   
	
	
