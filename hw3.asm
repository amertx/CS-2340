# HW 3
# Amer Din
# Program allows a user to read in an input file and extract the string "numbers" and converts them
# into integers, stores them into tha array
# Results in the array performing selection sort and calculations of mean, median and standard deviation to console

	.data
	
fname:	.asciiz "input.txt"
arr:	.word	20
mean:	.float	0.0
median:	.word	0
sd:	.float	0.0
buffer:	.space	80
newline:.asciiz "\n"
space:  .asciiz " "
msg_b:	.asciiz "\nThe array before: \t"
msg_a:	.asciiz "\nThe array after: \t"
msg_mn:	.asciiz	"\nThe mean is "
msg_md:	.asciiz "\nThe median is "
msg_sd:	.asciiz "\nThe standard deviation is "
msg_er:	.asciiz	"\nError reading file "
msg_er2:.asciiz "Program terminated. "

	.text

	 # Open (for reading) a file that hopefully exists
	la $a0, fname
     	la $a1, buffer
	jal readFile
	
	#checking if there is an error message
	beq $v0, $0, exit

	# address of array
  	la $a0, arr         
  	 #max of 20  
  	li $a1, 20                 
  	la $a2, buffer                
  	
  	# Retrieve ints from input
  	jal extraction                  
   	move $t7,$v0                 

	# print label for before the selection sort
  	li $v0, 4               
  	la $a0, msg_b
   	syscall
   
	#load address
   	la $a0, arr           
   	#if array is equal to  length of the array   
  	move $a1,$t7                
  	 
  	#print array before
   	jal printArray 
   	
   	
	
	
	
exit:
 
  	li $v0, 10
  	syscall
  	
  	
readFile:
	move $t1,$a1               
   
   	li   $v0, 13                     
   	li   $a1, 0                     
   	syscall                          

  	blt $v0,$0 returnFile         
  	move $s0, $v0                   
  	
  	li   $v0, 14                    
   	move $a0, $s0                  
   	
   	move $a1, $t1                
   	li   $a2, 80                   
   	syscall                        

   	li   $v0, 16                   
   	move $a0, $s0              
   	syscall
   	
   	move $v0,$s0                  

returnFile:
	jr $ra
	
#extracting integers from text input file 
extraction:
  	li $s1,-1                      
   	li $t0,0
loopPre:   
	lb $t1,($a2)      
	#checking if ascii value of 10 is newLine        
   	beq $t1,10,storeArray        
   	beq $t1,$zero,returnInts      

	#As you load a byte from the buffer, ignore the byte if it is <48 decimal 
   	blt $t1,48,ignoreNnextByte         
   	bgt $t1,57,ignoreNnextByte          
	
	#If it is within this range, it is a digit. Subtract 48 decimal (or 30 hex) to convert it from ASCII to int. 
   	addi $t1,$t1,-48              
                             
        #Multiply the register you are using as an accumulator by 10       
   	bne $s1,-1,multiplyIndex10      
   	li $s1,0              

multiplyIndex10:
  	li $t3,10       
  	# Multiply by 10 
   	mul $s1,$s1,$t3        
   	# Add converted decimal $s1          
   	add $s1,$s1,$t1                
   	
ignoreNnextByte:    
	#next byte        
   	add $a2,$a2,1                  
   	j loopPre             

storeArray:             
	#no integer formation
  	beq $s1,-1,skipStoring        
   	sll $t2,$t0,2                 
   	 #index multiplied by 4
   	add $t2,$t2,$a0                 
   	sw $s1,0($t2)               
   	 #Storing into array
   	li $s1,-1                      
   
skipStoring:
 	#post increment
   	addiu $t0,$t0,1                  
   	add $a2,$a2,1                 
   	beq $t0,20,returnInts        
   	 #maximum 20 ints
  	j loopPre			
  	
returnInts:
	# Return to main function
   	move $v0,$t0                  
   	jr $ra                      

printArray:
	#load 0 into register $t0
   	move $s0,$a0
   	li $t0, 0
   	
   	# Loop to check if register equal to size of the array
loopPost:
	#checks if array size is equal to array
   	beq $t0,$a1,postReturn         
   	li $v0,1
   	sll $t1,$t0,2
   	add $t1,$t1,$s0
   	lw $a0,0($t1)          
   	syscall               	
   	
   	li $v0, 4                        
   	la $a0, space              
  	syscall
  	
  	add $t0,$t0,1            
  	
  	j loopPost			
  	
  	
postReturn:
 	# Return to main function
 	li $v0, 4
 	la $a0, newline
 	syscall
 	
   	jr $ra           
   	
  

