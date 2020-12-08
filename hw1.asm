# HW 1
# Amer Din
# Program allows a user to enter their name and store 3 integers
# Results in returning the name and returning expressions

	.data 
	
a:	.word		0
b:	.word		0
c:	.word		0

ans1:	.word		0
ans2:	.word		0
ans3:	.word		0

name:	.space		20

namePrompt:	.asciiz 	"What is your name? "
integerPrompt: 	.asciiz 	"Please enter an integer between 1-100: "
finalAnswers: 	.asciiz 	"your answer provided were "


	.text
	
	#get name from user
	li 	$v0, 4
	la	$a0, namePrompt
	syscall 
	
	#input name 
	li	$v0, 8
	la	$a0, name
	li	$a1, 20
	syscall 
	
	
	
	#3 time iteration for prompting user for integers
	
	#first iteration
	#prompt user for an integer between 1-100
	la	$a0, integerPrompt
	li	$v0, 4
	syscall
	#reading in input
	li	$v0, 5
	syscall
	#storing of first iteration
	sw	$v0, a
	
	
	
	#second iteration
	la	$a0, integerPrompt
	li	$v0, 4
	syscall
	#reading in input
	li	$v0, 5
	syscall 
	#storing of second iteration
	sw	$v0, b

	
	#third iteration
	li	$v0, 4
	la	$a0, integerPrompt
	syscall 
	#reading in input
	li	$v0, 5
	syscall
	#storing of third iteration
	sw	$v0, c	
	
	
	#load variables from memory
	lw	$t0, a
	lw	$t1, b
	lw	$t2, c
	
	
	#first calculation- ans1
	add	$t4, $t0, $t0
	sub	$t4, $t4, $t2
	addi	$t4, $t4, 4
	
	#storing first calculation 
	sw	$t4, ans1
	
	#second calculation- ans2
	#(a-2)
	sub 	$t5, $t1, $t2
	addi	$t6, $t0, -2
	add	$t7, $t5, $t6
	
	#storing calculation- ans3
	sw	$t7, ans2
	
	#calculation 3- ans3
	# (a-3)
	addi	$t3, $t0, 3
	addi	$t5, $t1, -1
	addi	$t6, $t2, 3
	sub 	$t8, $t3, $t5
	add	$t8, $t8, $t6
	
	
	#storing calculation- ans3
	sw	$t8, ans3
	
	
	#output name back to console
	li	$v0, 4
	la	$a0, name
	syscall
	
	
	#output of results inputted above
	li	$v0, 4
	la	$a0, finalAnswers
	syscall
	
	#output of calculation1
	li	$v0, 1
	lw	$a0, ans1
	syscall
	
	#space character
	li	$v0, 11
	li	$a0, ' '
	syscall
	
	#output of calculation2
	li	$v0, 1
	lw	$a0, ans2
	syscall
	
	#space character
	li	$v0, 11
	li	$a0, ' '
	syscall
	
	#output of calculation3
	li	$v0, 1
	lw	$a0, ans3
	syscall
		
	
	
exit:	li	$v0,	10
	syscall

	#test case 1
	
	#What is your name? Amer
	#Please enter an integer between 1-100: 10
	#Please enter an integer between 1-100: 6
	#Please enter an integer between 1-100: 5
	#Amer
	#your answer provided were 19 9 16
	#-- program is finished running --
	
	#test case 2
	
	#What is your name? Bob
	#Please enter an integer between 1-100: 15
	#Please enter an integer between 1-100: 10
	#Please enter an integer between 1-100: 6
	#Bob
	#your answer provided were 28 17 18
	#-- program is finished running --


	
