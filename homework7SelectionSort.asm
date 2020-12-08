# HW 7
# Amer Din
# Program allows a user to compare 2 sorting algorithms in terms of number of instructions 
# and cache utilization

#Bubble Sort Program
	.data
	
#hardcoded array	
array:	.word	19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40
		19,-2,95,26,83,17,-5,69,-16,10,45,-17,88,27,-13,67,-48,6,-66,40

	.text
	#load the address of array into $a0
	la	$a0, array
	#load length into a1
	li	$a1, 500
   	
   	#jump to function
  	jal 	selectionSort             
  	j 	exit


selectionSort:
   	li 	$t0, 0     
   	#subtract current index by length                
   	sub 	$s0, $a1, 1                
   
outerloop:
   	beq 	$t0, $s0, returnSelectionSort
   	move 	$s1, $t0     
   	#t++             
   	add 	$t1, $t0, 1                 
   	
innerloop:
	#iterate and send to loop to check if the values are swapped
   	beq 	$t1, $a1, checkIfSwapped
   	sll 	$t2, $t1, 2
   	sll 	$t3, $s1, 2
   	add 	$t2, $t2, $a0
   	add 	$t3, $t3, $a0
  	lw 	$t4, 0($t2)                  
   	lw 	$t5, 0($t3)                  
   	#swap indexes
   	blt 	$t4, $t5, updateIndex             
   	j 	postInner

updateIndex:  
	move 	$s1, $t1   
	      
postInner:
   	add 	$t1, $t1, 1
   	j 	innerloop        
   	      
checkIfSwapped:
   	bne 	$s1, $t0, swap                                           
  	j 	postOuter
  	
#swaps element if the conditional is executed
swap:
   	sll 	$t2, $t0, 2
   	sll 	$t3, $s1, 2
   	add 	$t2, $t2, $a0        
   	add 	$t3, $t3, $a0
   	lw 	$t4, 0($t2)        
   	lw 	$t5, 0($t3)
   	sw 	$t4, 0($t3)
  	sw 	$t5, 0($t2)
  	
postOuter:
   	add 	$t0, $t0, 1
   	j 	outerloop

#jump back to main   	                  	               
returnSelectionSort:     
   	jr 	$ra
   	
#exit case   	
exit:   
	li 	$v0, 10               
	syscall 