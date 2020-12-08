# HW 3
# Amer Din
# Program allows a user to read in an input file and extract the string "numbers" and converts them
# into integers, stores them into tha array
# Results in the array performing selection sort and calculations of mean, median and standard deviation to console

	.data
	
fname:	.asciiz "input.txt"
newline:.asciiz "\n"
space:  .asciiz " "
msg_b:	.asciiz "The array before: \t"
msg_a:	.asciiz "The array after: \t"
msg_mn:	.asciiz	"The mean is "
msg_md:	.asciiz "The median is "
msg_sd:	.asciiz "The standard deviation is "
msg_er:	.asciiz	"Error reading file "
msg_er2:.asciiz "Program terminated. "
arr:	.word	20
buffer:	.space	80

	.text

	la $a0,fname		#loading the address of the input file into $a0
   	la $a1, buffer       #loading the address of the buffer into $a1
   
  	jal readFile                  
   	beq $v0,$0,exit                  # Exit if file can't be opened

  	la $a0, arr                # address of integer array
  	li $a1, 20                  # maximum number of integers can be stored
  	la $a2, buffer                # address input buffer
  	
  	jal extraction                  # Call the procedure getInts
   	move $t7,$v0                  # $t7 equal to  number of integers extracted or

  	li $v0,4               # print label "The array before:"
  	la $a0, msg_b
   	syscall
   

   	la $a0,arr                # address of integer array
  	move $a1,$t7                  # $a  equal to  length of the array
  	 
   	jal print                  # Call the procedure print
   	
   	la $a0,newline
   	li $v0,4
   	syscall

exit:
 
  	li $v0, 10
  	syscall
  	
  	

   

readFile: #function to read the file
  	 move $t1,$a1               # tempararily store address of buffer in $t1
   
   	li   $v0, 13                     # system call for open file
   	li   $a1, 0                      # 0 is the flag for reading
   	syscall                          

  	blt $v0,$0 returnReadFile          # If failed to open input file, return to main
  	move $s0, $v0                    # save the file descriptor in $s0
  	
  	li   $v0, 14                     # system call for reading from file
   	move $a0, $s0                    # file descriptor
   	
   	move $a1,$t1                  # address of buffer
   	li   $a2, 80                    # hardcoded buffer length
   	syscall                          # read from file

   	li   $v0, 16                     # system call for reading from file
   	move $a0,$s0               # #a0 file descripter
   	syscall
   	
   	move $v0,$s0                  
returnReadFile:
   	jr $ra                      # Return to main

extraction :

  	li,$s1,-1                      # To store the integer decimal
   	li $t0,0
loop1:   
	lb $t1,($a2)              # Load the address of first byte into $t2
   	beq $t1,10,storeInArray         # if byte is new line(new line means one complete


   	beq $t1,$zero,returngetInts      # If $t1 is 0, end of file is reached


   	blt $t1,48,ignoreNnext          # ignore the byte if register value is less than 48
   	bgt $t1,57,ignoreNnext          # ignore the byte if register value is greater than 57

   	addi $t1,$t1,-48              # Convert charcter digit to decimal digit
                              # by subtracting 48 from ASCII integer.
   	bne $s1,-1,multiplyBy10      
   	li $s1,0               # if $s1 equal to -1, current byte is the starting digit

multiplyBy10:
  	li $t3,10        
   	mul $s1,$s1,$t3                  # Multiply $s1 with 10
   	add $s1,$s1,$t1                  # Add converted decimal digit to $s1
   	
ignoreNnext:            
   	add $a2,$a2,1                  # goes to the next byte
   	j loop1             

storeInArray:                    
  	beq $s1,-1,skipStoring         # -1 means , no integer is formed
   	sll $t2,$t0,2                  # multiply index with 4
   	add $t2,$t2,$a0                  # #t2 equal to address to store integer
   	sw $s1,0($t2)                  # Store decimal integer into array
   	li $s1,-1                      # Re set $s1 to -1(for fresh integer)
   
skipStoring:
   	addiu $t0,$t0,1                   # increment the index of integer array
   	add $a2,$a2,1                  # go to next byte
   	beq $t0,20,returngetInts         # only allow maximum 20 integer
  	j loop1				#jump to loop1
returngetInts:
   	move $v0,$t0                  
   	jr $ra                      # Return to main 

print:
   	move $s0,$a0
   	li $t0,0	#load 0 into register $t0
   	
loop2:
   	beq $t0,$a1,returnPrint         # if register  equal to  size of the array, return
   	li $v0,1
   	sll $t1,$t0,2
   	add $t1,$t1,$s0
   	lw $a0,0($t1)           # load the int
   	syscall               	# print int
   	
   	li $v0, 4                        
   	la $a0, space               #insert space
  	syscall
  	
  	add $t0,$t0,1            # Move to next int
  	
  	j loop2			#jump to loop2
  	
  	
returnPrint:
   	li $v0, 4                        
   	la $a0, newline             # Print new line
   	syscall
   	
   	jr $ra                      # Return to main

  
        

