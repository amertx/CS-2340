#review for exam1

#PROBLEM 1

	.data
	x:	.word	10
	y: 	.word	5
	z:	.word	5
	q:	.word	5
	
	
	.text
main:	
	
	lw	$s1, x
	lw	$s2, y
	lw	$s3, z
	lw	$s4, q
	
	add 	$s1, $s1, $s2
	add	$s1, $s1, $s3
	sub	$s1, $s1, $s4
	
	#print out result
	li	$v0, 1
	move	$a0, $s1
	syscall
	
	
exit:	
	li	$v0, 10
	syscall
	
	
	
	
	
	