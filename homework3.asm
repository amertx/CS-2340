# HW 3
# Amer Din
# Program allows a user to read in an input file and extract the string "numbers" and converts them
# into integers, stores them into tha array
# Results in the array performing selection sort and calculations of mean, median and standard deviation to console

	.data
fname: 	.asciiz "input.txt" 
errMsg:	.asciiz	"Error loading the message "
errMsg2:.asciiz "File Corrupted"
newLine:.asciiz "\n"
space:  .asciiz " "
arr_b:  .asciiz "The array before: \t"
arr_a:  .asciiz "The array after: \t"
mean:   .asciiz "the mean is: "
median: .asciiz "The median is: "
std: 	.asciiz "The standard deviation is: "
buffer: .space 	80
arr: 	.word 	20
len:	.word	500

	.text
	 # Open (for reading) a file that hopefully exists
   	la 	$a0, fname		
   	la 	$a1, buffer       
  	jal 	readFile                  
  	
  	#checking if there is an error message
  	slti	$t0, $v0, 1
   	bne 	$t0, 1, success
   	la	$a0, errMsg       
   	la	$a1, errMsg2
   	li	$v0, 59
   	syscall
   	j 	exit     
   	     
success:	
	#max buffer of 20
  	la 	$a0, arr              
  	li 	$a1, 20                 
  	la 	$a2, buffer              
  	
  	jal 	extraction                  
   	move 	$t7, $v0        
   	          
	#output of preselectionsort
  	li 	$v0, 4              
  	la 	$a0, arr_b
   	syscall
	#address of array, then print function
   	la 	$a0, arr                
  	move 	$a1, $t7              
   	jal 	printArray                     
   	
   	#output of selection sort
  	la 	$a0, arr                
  	move 	$a1, $t7                  
  	jal 	selectionSort             
  	#after selection sort output
   	li 	$v0, 4               
   	la 	$a0, arr_a
   	syscall
   	#address of array, then print function
   	la 	$a0, arr              
   	move 	$a1, $t7                 
  	jal 	printArray                     


	#loading address, calling mean function
   	la 	$a0, mean               
   	li 	$v0, 4
   	syscall
   	#Use single precision for the mean. Store the mean in memory as a float.
  	la 	$a0, arr               
   	move 	$a1, $t7                
  	jal 	meanCalculation
   	li 	$v0, 2           
  	syscall
   	la 	$a0, newLine
   	li 	$v0, 4
   	syscall
   	
   	#loading address, calling median function
   	la 	$a0, median              
   	li 	$v0, 4
   	syscall
   	la 	$a0, arr              
   	move 	$a1, $t7                 
  	#Set $v1 to be a flag to indicate whether the result was int or float
   	jal 	medianCalculation    
  	bltz 	$v1, medianFloatConversion         
   	move 	$a0, $v0
   	li 	$v0, 1               
   	syscall
   	
#float conversion
medianFloatConversion: 
   	li 	$v0, 2
   	syscall   
   
   	#jumps to print standard deviation
   	j 	printStandardDeviation        
   	
printStandardDeviation: 
	li 	$v0, 4
   	la 	$a0, newLine
   	syscall
   	#loading address, print prompt for standard deviation
   	li 	$v0, 4              
   	la 	$a0, std  
   	syscall              
   	la 	$a0, arr               
  	move 	$a1, $t7                 
  	#call standard deviation function
   	jal 	standardDeviation
   	li 	$v0, 2
  	syscall         
   	        
exit:   
	#if file is not corrupted and succesfully exits
	li 	$v0, 10               
	syscall 	


readFile:
	#load byte from buffer
  	move 	$t1, $a1               
   	li   	$v0, 13                     
   	li   	$a1, 0                   
   	syscall                          
	
	#if the register is 0 ASCII then ignore
  	blt 	$v0, $0, postFileRead          
  	move 	$s0, $v0                   
  	
  	li   	$v0, 14                   
   	move 	$a0, $s0                  
   	
   	move 	$a1, $t1                
   	li   	$a2, 80                   
   	syscall                          

   	li   	$v0, 16                   
   	move 	$a0, $s0              
   	syscall
   	
   	move 	$v0, $s0         
   	         
postFileRead:
	#return to main
   	jr 	$ra                     

#beginning of extracting integers from input buffer
extraction:
  	li	$s1, -1                     
   	li 	$t0, 0
   	
  #loop and store into array
loopExtraction:   
	lb 	$t1, ($a2)             
   	beq 	$t1, 10, storeArray       
   	beq 	$t1, $zero, postInt    

	#load a byte from the buffer, ignore the byte if it is <48 decimal or 30 hex (ASCII for 0) or >57 decimal 
   	blt 	$t1, 48, ignoreNextIndex       
   	bgt 	$t1, 57, ignoreNextIndex         
	
	#If it is within this range, it is a digit. Subtract 48 decimal (or 30 hex) to convert it from ASCII to int.
   	addi 	$t1, $t1, -48           
        
        #Multiply the register you are using as an accumulator by 10, then add this new digit.                    
   	bne 	$s1, -1, multiplyBy10      
   	li 	$s1, 0            

 #Multiply the register you are using as an accumulator by 10, then add this new digit.           
multiplyBy10:
  	li  	$t3, 10        
   	mul 	$s1, $s1, $t3                  
   	add 	$s1, $s1, $t1                 

#if it is within range
ignoreNextIndex:            
   	add 	$a2, $a2, 1                 
   	j 	loopExtraction             

storeArray:      
	#achieve each index by multiplying the index by 4 then store              
  	beq 	$s1, -1, postStoring        
   	sll 	$t2, $t0, 2                  
   	add 	$t2, $t2, $a0               
   	sw 	$s1, 0($t2)                 
   	li	$s1, -1                    

#to catch a max of 20 elements
postStoring:
   	addiu 	$t0, $t0, 1                   
   	add 	$a2, $a2, 1                
   	beq 	$t0, 20, postInt        
  	j 	loopExtraction
#post increment 					
postInt:
   	move 	$v0, $t0                  
   	jr 	$ra                    

#print function utilized by array before and after
printArray:
   	move 	$s0, $a0
   	li 	$t0, 0	
#iterates through array and accounts for spaces and new lines to print
loopExtraction2:
   	beq 	$t0, $a1, postPrintFunction       
   	li 	$v0, 1
   	sll 	$t1, $t0, 2
   	add 	$t1, $t1, $s0
   	lw 	$a0, 0($t1)          
   	syscall               
   	#adds a space between each element
   	li 	$v0, 4                        
   	la 	$a0, space             
  	syscall
  	# i++
  	add 	$t0,$t0,1          
  	j 	loopExtraction2			
  	
  	
postPrintFunction:
	#returns a new line
   	li 	$v0, 4                        
   	la 	$a0, newLine          
   	syscall
   	jr 	$ra                     

###################################################

#beginning of selection sort procedure
#for (i = 0; i < aLength-1; i++){
#     [i .. aLength-1]
#     assume the min is the first element 
#     int jMin = i;

selectionSort:
	#current index and length-1
   	li 	$t0, 0                      
   	sub 	$s0, $a1, 1   
   	            
 #to find smallest int and store into t1
outerloop:
   	beq 	$t0, $s0, returnSelectionSort
   	move 	$s1, $t0                  
   	add 	$t1, $t0, 1             
   
 #if the current element is less then it is the new minimum and should be swapped
innerloop:
	#if the element is less, calls minimum swap function
   	beq 	$t1, $a1, minimumSwap
   	sll 	$t2, $t1, 2
   	sll 	$t3, $s1, 2
   	add 	$t2, $t2, $a0
   	add 	$t3, $t3, $a0
  	lw	$t4, 0($t2)                  
   	lw 	$t5, 0($t3)                  
   	#swaps the index value if the current index is smaller than t0
   	blt 	$t4, $t5, postIndex             
   	j 	postLoop

#updates the index
postIndex:  
	move 	$s1, $t1   
postLoop:
   	add 	$t1, $t1, 1
   	j 	innerloop    
   	          
minimumSwap:
	#checks if it has been swapped then goes postloop2
   	bne 	$s1, $t0, swap                           
  	j 	postLoop2

#(jMin != i) 
#{
# swap(a[i], a[jMin]);
# }
swap:
	#finds new minimum and swaps the index
   	sll 	$t2, $t0, 2
   	sll 	$t3, $s1, 2
   	add 	$t2, $t2, $a0        
   	add 	$t3, $t3, $a0
   	#stores back into array 
   	lw 	$t4, 0($t2)        
   	lw 	$t5, 0($t3)
   	sw 	$t4, 0($t3)
  	sw 	$t5, 0($t2)
 
#jumps back to outerloop 
postLoop2:
   	add 	$t0, $t0, 1
   	j 	outerloop

#end of selection sort function          
returnSelectionSort:     
   	jr 	$ra
   	
###################################################

#average calculation
meanCalculation:
	#set initial registers before looping
   	li 	$t0, 0
   	mtc1 	$t0, $f12                 
   	mtc1 	$t0, $f0


loopMean:
	#t0=array.size()
   	beq 	$t0, $a1, postLoopMean       
  	sll 	$t1, $t0, 2
   	add 	$t1, $t1, $a0
   	#before next iteration, post increment to $f12 and add 1 to t0
   	lwc1 	$f0, 0($t1)         
   	add.s 	$f12, $f12, $f0          
   	add 	$t0, $t0, 1         
   	j 	loopMean         


postLoopMean:
	#f0 stores size of array and is the divisor for f12	
   	mtc1 	$a1, $f0              
   	div.s 	$f12, $f12, $f0        
   	jr 	$ra      
   	             
###################################################

#median calculation
medianCalculation:
	#t0 holds the middle value
   	div 	$t0, $a1, 2         
   	#scenario of if t0 is 0, it calls the getMiddleValues function 
   	mfhi 	$t1
   	beqz 	$t1, getmiddleValues           
        #else
        #returns median into v1  
 	sll 	$t2, $t0, 2
   	add 	$t2, $t2, $a0
   	lw 	$v0, 0($t2)          
   	li 	$v1, 0              
   	j 	medianCalculation
   	
getmiddleValues:
	#mid values shifted and added
   	sub 	$t1, $t0, 1
   	sll 	$t2, $t0, 2
  	sll 	$t3, $t1, 2
   	add 	$t2, $t2, $a0        
   	add 	$t3, $t3, $a0
   	#load values t2 and t3
   	lw 	$t4, 0($t2)             
   	lw 	$t5, 0($t3)
   	#summation
   	add 	$t4, $t4, $t5 
   	#holds sum         
   	mtc1 	$t4, $f12           
   	li 	$t5, 2
   	mtc1 	$t5, $f0             
   	#final division of f12
   	div.s 	$f12, $f12, $f0     
   	#Set $v1 to be a flag to indicate whether the result was int or float so that you can use the appropriate syscall in main to print the median.      
   	li 	$v1, -1                
   	jr 	$ra               

standardDeviation:
   	add 	$sp, $sp, -4
   	sw 	$ra, 4($sp)    
   	#retrieve average              
   	jal 	meanCalculation  
	
	#allow f12 to keep summation
   	mov.s 	$f0, $f12           	
   	li 	$t0, 0
   	mtc1 	$t0, $f12       
   	          
loopStd:
	#loop to iterate through array 
   	beq 	$t0, $a1, postStd      
   	sll 	$t1, $t0, 2
   	#load integers
   	add 	$t1, $t1, $a0
   	lw 	$t2, 0($t1)          
   	mtc1 	$t2, $f1              
   	cvt.s.w $f1, $f1           
   	#f2 is average, f3 holds variance 
   	sub.s 	$f2, $f1, $f0            
   	mul.s 	$f3, $f2, $f2      
   	#f12 holds final standarad deviation     
   	add.s 	$f12, $f12, $f3       
   	add 	$t0, $t0, 1
   	j 	loopStd              
   
#once looped, the postStd function allows for a the equation to be processed   
postStd:

	#n-1 for t3 and t4 registers
   	sub 	$t2, $a1, 1                
   	mtc1 	$t2, $f4                  
   	cvt.s.w $f4, $f4    
   	#sum/n-1 set f12 register        
   	div.s 	$f12, $f12, $f4       
   	sqrt.s 	$f12, $f12              
   	lw 	$ra, 4($sp)
   	add 	$sp, $sp, 4                  
   	jr 	$ra 
   	 

