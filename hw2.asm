# HW 2
# Amer Din
# Program allows a user to enter a phrase in a system dialog
# Results in returning the number of words and characters are in the phrase

	.data
userPrompt:	.asciiz "Enter some text"
words:		.asciiz " words"
characters:	.asciiz " characters"
goodbye:	.asciiz "goodbye"
goodbye2:	.asciiz ""
emptyLine:	.asciiz "\n"
input: 		.space 100
numCharacters:	.word 0
numSpaces:	.word 0
		
	
	
	.text
	
main: 
	#get string from user
	li	$v0, 54
	la 	$a0, userPrompt
	la 	$a1, input
	li	$a2, 100
	syscall
	
	#allow for a buffer
	beq	$a1, -2, exit
	beq	$a1, -3, exit
	
	
	
	#function call
	jal	counterCharactersWords
	
	#storing of character counter
	sw	$v0, numCharacters
	
	#storing of space counter
	addi	$v1, $v1, 1
	sw	$v1, numSpaces
	
	#output first string back to console
	li	$v0, 4
	la	$a0, input
	syscall
	
	#outputs the number of words
	li	$v0, 1
	la	$a0, ($v1)
	syscall
	
	#with word extension
	li	$v0, 4
	la	$a0, words
	syscall

	#outputs a space
	li	$v0, 11
	li	$a0, ' '
	syscall

	#outputs the number of characters
	li	$v0, 1
	la	$a0, ($t1)
	syscall
	
	#character extension
	li	$v0, 4
	la	$a0, characters
	syscall
	
	#skips a line for new iteration within loop
	li	$v0, 4
	la	$a0, emptyLine
	syscall
	
	#jumps back to main until loop is finished
	j main
	
#function creation 
counterCharactersWords:	

	#storing the counters as registers for the characters and number of words
	la	$t0, input
	#characters
	li	$t1, 0
	#words
	li	$t2, 0
	

loop: 		
	#branch to check whether a null terminating character and new space has been reached
	lb	$a0, 0($t0)
	beq	$a0, '\0', postLoop
	beq	$a0, '\n', postLoop
	addi	$t0, $t0, 1
	addi	$t1, $t1, 1
	beq	$a0, ' ', spaceIncrement
	j 	loop
	
#stack accounting
postLoop:
	add	$v0, $zero, $t1
	add	$v1, $zero, $t2
	
	add	$s0, $zero, $t1
	
	#push to the stack
	addi	$sp, $sp, -4
	sw	$s0, 0($sp)
	
	#pop from the stack
	lw	$s0, 0($sp) 
	addi	$sp, $sp, 4
	
	jr 	$ra
	
#increase counter each time called	
spaceIncrement:
	addi	$t2, $t2, 1
	j 	loop
	
	#branch function is the condition, sends back to loop line
	#sub 	$s1, $s1, 2
	#addi	$a0, $s1, 0
	#li	$v0, 1
	#syscall
	
exit:	

	#outputs dialog message 59
	#4 is to output to console
	la	$a0, goodbye
	la	$a1, goodbye2
	li	$v0, 59
	syscall
	
	li	$v0, 10
	syscall
	
	
	
