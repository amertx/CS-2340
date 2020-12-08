# file for macros

# HW 5
# Amer Din
# Program allows a user to simulate a Run-length encoding (RLE) 
# which is a very simple form of lossless data compression in which runs of data 
# (that is, sequences in which the same data value occurs in many consecutive data elements) are stored 

# as a single data value and count, rather than as the original run. 
# This is most useful on data that contains many such runs. 


	
	
	#### print_int ####  	print_int(4)	print_int($t0)
	.macro print_int (%x)
    	li 	$v0, 1
    	add	$a0, $zero, %x
    	syscall
    	.end_macro
    	
	
	#### print_gloat ####  	print_loat(4.2)	print_int($f0)
	.macro print_float (%f)
    	li 	$v0, 2
    	mov.s   $f12, %f
    	syscall
    	
	.end_macro
	
	#prints a new Line
	.macro newLine
    	li    $v0, 11
    	li    $a0, '\n'
    	syscall
	.end_macro
	
	#removes line from input
	.macro deleteLine (%name, %size)
	la	$t5, %name
	add	$t1, $t5, %size
	loop:
	#checking for size 
	beq	$t5, $t1, postLoop
	lb	$t4, ($t5)
	bne	$t4, '\n', continue
	sb	$0, ($t5)
	j 	postLoop
	continue:
	add 	$t5, $t5, 1
	j 	loop
	postLoop:
	.end_macro 
	
	
	#### print_str ####  	print_str("string in quotes")
	.macro print_str (%str)
   	.data
macro_str:	.asciiz %str
	.text
   	 li	$v0, 4
   	 la	$a0, macro_str
   	 syscall
	.end_macro
	
	#print string from file
	.macro print_strFromFile (%label)
	la 	$a0, %label
	li	$v0, 4
	syscall
	.end_macro
	
	#print string from register 
	.macro print_strFromRegister (%label)
	la 	$a0, (%label)
	li	$v0, 4
	syscall
	.end_macro
	

	#print char literally
	.macro print_char (%chr)
	.data
charProcessing: .byte %chr
	.text
	li	$v0, 11
	la	$a0, charProcessing
	syscall
	.end_macro
	
	
	#input file validation portion
	#prompt for file string input
	.macro get_input(%str, %space)
	la	$a0, %str
	li 	$a1, %space
	li 	$v0, 8
	syscall
	.end_macro 
	
	#open file
	.macro openFile (%file)
	
	la	$a0, %file
	li	$v0, 13
	la 	$a1, 0
	la	$a2, 0
	syscall
	#file stored in register
	move 	$s1, $v0
	blt	$s1, $0, failure
	.end_macro 
	
	#close file
	.macro closeFile
	li	$v0, 16
	la	$a0, ($s1)
	syscall
	.end_macro 
	
	#read file
	.macro  readFile(%buffer, %size)
    	move    $a0, $s1
    	la    	$a1, %buffer
    	li    	$a2, %size
    	li    	$v0, 14
    	syscall 
    	#s0 
    	move    $t9, $v0
	.end_macro

	
	#allocate memory
	.macro allocate ( %space)
	li	$a0, %space
	li	$v0, 9
	syscall
	
	.end_macro 
	
	#exit the program while invoking this macro
	.macro done
	 li $v0, 10
	 syscall
	.end_macro 
	
	
	
	
