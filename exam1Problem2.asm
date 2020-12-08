#review for exam1

#PROBLEM 2

	.data
	a: 	.word, 5
	b:	.word, 6
	c:	.word, 7
	result:	.word  0
	
	.text
	lw	$t1, a
	lw	$t2, b
	lw	$t3, c

	
	
	bgt	$t1, $t2, Else
	#c == a
	sw	$t3, a
	lw 	$t4, a
	j	Print
	
Else:
	#c == b
	sw	$t2, b
	lw 	$t4, b

Print:	
	li	$v0, 1
	move	$a0, $t4 
	syscall
	
exit:	
	
	li	$v0, 10
	syscall
	