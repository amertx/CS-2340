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

#length of array		
len:	.word		500

	.text

main:	la	$a0, array	# array pointer, v
	lw	$a1, len	# array size,  n
	jal	sort

	li	$v0, 10
	syscall

#SWAP
swap:	sll	$t1, $a1, 2		# $t1 = k * 4
	add	$t1, $a0, $t1		# $t1 = v + (k * 4)
	lw	$t0, ($t1)		# load the two values
	lw	$t2, 4($t1)
	sw	$t2, ($t1)		# store (swap) the two values
	sw	$t0, 4($t1)
	jr	$ra
#SORT
sort:	addi	$sp, $sp, -20	# push 5 registers onto stack
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, ($sp)
	move	$s2, $a0	# save $a0
	move	$s3, $a1	# save $a1
	# outer loop
	move	$s0, $zero	# i = 0
for1tst: slt	$t0, $s0, $s3	# check if i < n
	beq	$t0, $zero, exit1
	# inner loop
	addi	$s1, $s0, -1	# j = i - 1
for2tst: slti	$t0, $s1, 0	# check if j < 0
	bne	$t0, $zero, exit2
	sll	$t1, $s1, 2	# j * 4
	add	$t2, $s2, $t1	# v + j * 4
	lw	$t3, ($t2)	# v[j]
	lw	$t4, 4($t2)	# v[j+1]
	slt	$t0, $t4, $t3	# need to swap?
	beq	$t0, $zero, exit2
	# swap
	move	$a0, $s2
	move	$a1, $s1
	jal	swap
	addi	$s1, $s1, -1	# j --
	j	for2tst
	# end of inner loop
exit2: 	addi	$s0, $s0, 1	# i++
	j	for1tst
	# end of outer loop
exit1:	lw	$s0, ($sp)	# pop (restore) registers
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	