
#looping through array
#while (arr[i] != -1) 
# i++


	.data 
arr 	.word 3, 8, 12, -1

	

	.text 
main: 
	li $s3, 0 #index value set to first one
	la $s6, arr #arr[0] address
	li $s5, -1 #sentinal
	

loop: 	
	
exit:
	#exit call
	li $v0, 10
	syscall
