# HW 5
# Amer Din
# Program allows a user to simulate a Run-length encoding (RLE) 
# which is a very simple form of lossless data compression in which runs of data 
# (that is, sequences in which the same data value occurs in many consecutive data elements) are stored 
# as a single data value and count, rather than as the original run. 
# This is most useful on data that contains many such runs. 



#instructions on how to run program
###################################
#type a legitamate file name
#if successful the algorithm will run and output analysis of text file
#the program will run in a loop until the users enters the space for when it asks for a file name

.include "macros.asm"
.eqv	NINE 9
	.data
	
#file names
	.align 2
fileName: .space 50
#outputs for each data
originalData: .asciiz "Original Data: "
compressedData:	.asciiz "Compressed Data: "
UnCompressedData: .asciiz "Uncompressed Data: "
OriginalFileSize: .asciiz "Original File Size: "
CompressedFileSize: .asciiz "Compressed File Size: "


#loop headers
prompt:	.asciiz "Please enter a file name to compress or <enter> to exit:"
newLine: .asciiz "\n"
	.align 2
buffer: .space 80
	.align 2
read:	.space	1024
emptyWord: .word 0
compSize: .word 0
size: 	.word 0
heap: 	.word 0

        .text        
       	
main:
	
loop:
	#prompt
	print_str("Enter the filename to compress or <enter> to exit: ")
	get_input(fileName, 50)
	lb 	$t0, fileName
	beq 	$t0, '\n', exit
	
	deleteLine(fileName, 50)
	
	#opens file
	openFile(fileName)
	readFile(read, 1024)
	
	#close file
	closeFile
	
	print_str("Original Data: \n")
	print_strFromFile(read)
	newLine
	
	
	
	print_str("Compressed Data: \n")
	
   	lw 	$a1, size       
   	#first step of allocating
	allocate(1024)
	move	$a2, $v0
	la 	$a0, read    
   	jal 	compression       
  
   	lw   	$t0, heap
	newLine
	
	
	print_str("Original File Size: \n")
	print_int($t9)
	newLine
	
	print_str("Compressed File Size: \n")
	print_int($s7)
	newLine	
	
	j 	loop
	
compression:
	#dynamic heap size allocation
	addi 	$s0, $a1, -1      
   	li 	$t0, 0       
   	li 	$s7, 0
   	#counter for size
for:   	
	bge 	$t0, $a1, backToMain  
   	li 	$t1, 1     
  	
  	#update index
while:   
	add 	$t2, $a0, $t0
   	lb 	$s1, ($t2)       
   	addi 	$t3, $t0, 1
   	add 	$t3, $a0, $t3
   	lb 	$s2, ($t3)     
  	
  	#check if next index is equal to current
   	bge 	$t0, $s0, heapStore   
   	bne 	$s1, $s2, heapStore  
   	addi 	$t1, $t1, 1
   	addi 	$t0, $t0, 1
   	#jump to check condition
   	j 	while
  	
  	#store back to Heap
heapStore:   
	sb 	$s1, ($a2)       
   	addi 	$s7, $s7, 1
   	addi 	$a2, $a2,1       
   	bgt 	$t1, NINE, secondDigit  
   	addi 	$t1, $t1, 48      
   	sb 	$t1, ($a2)      
   	addi 	$s7, $s7, 1      
   	addi 	$a2, $a2, 1       
   	addi 	$t0, $t0, 1      
   	j 	for
  	
  	#analyzes orientation of digits
secondDigit:   
	li 	$t8, 10
   	div 	$t1, $t8
   	mflo 	$t4      
   	addi 	$t4, $t4, 48      
   	sb 	$t4, ($a2)       
   	addi 	$s7, $s7, 1       
   	mfhi 	$t5     
   	addi 	$t5, $t5, 48       
   	addi 	$a2, $a2, 1       
   	sb 	$t5, ($a2)      
   	addi 	$a2, $a2, 1       
   	addi 	$t0, $t0, 1       
   	j 	for
  	
  	#save compression size
backToMain:   
	sw 	$s7, compSize      
   	jr 	$ra  
   	
   	#exit case
exit: 
	done

  	
failure:
	print_str("Error Opening File. Program Terminating.")
	j 	exit
  	
