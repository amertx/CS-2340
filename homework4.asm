# HW 4
# Amer Din
# Program allows a user to gain experience with memory-mapped I/O


#instructions on how to run program
###################################
#each time you run the program, set the following properties:
#Unit Width in pixels: 4
#Unit Width in pixels: 4
#Display Width in pixels: 256
#Display Height in pixels: 256
#then click "connect to mips"
#finally build and run the program


	# set up some constants
	# width of screen in pixels
	# 256 / 4 = 64
	.eqv 	WIDTH 64
	# height of screen in pixels
	.eqv 	HEIGHT 64
	# memory address of pixel (0, 0)
	.eqv 	MEM 0x10010000 

	# colors
	.eqv	RED 	0x00FF0000
	.eqv	GREEN 	0x0000FF00
	.eqv	BLUE	0x000000FF
	.eqv	WHITE	0x00FFFFFF
	.eqv	YELLOW	0x00FFFF00
	.eqv	CYAN	0x0000FFFF
	.eqv 	MAGENTA 0x00FF00FF


	.data
#counter branch variables
n:	.word 	7
n2:	.word 	7
n3:	.word 	7
n4:	.word	7
#array of colors
colors: .word	MAGENTA, CYAN, YELLOW, WHITE, BLUE, GREEN, RED

	.text
main:

	# check for input
	# t1 holds if input available
	lw 	$t0, 0xffff0000  
	# If no input, keep displaying
    	beq 	$t0, 0, begin   
	# process input
	lw 	$s1, 0xffff0004
	# input space and exits program when space is pressed
	beq	$s1, 32, exit	

begin:
	#loop 1 n value
	li	$t1, 0		# $t1 = i = 0
	lw	$t2, n		# $t2 = stop value
	
	#loop 2 n value
	li	$t3, 0		# $t1 = i = 0
	lw	$t4, n2		# $t2 = stop value
	
	#loop 3 n value
	li	$t5, 0		# $t1 = i = 0
	lw	$t6, n3		# $t2 = stop value
	
	#loop 4 n value
	li	$t7, 0		# $t1 = i = 0
	lw	$t8, n4		# $t2 = stop value
	

	#center the point
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	#for iteration through for all colors in array
	li 	$s6, 0

#allows for the marquee effect
drawLoopAnimation:
	jal 	pause
	move 	$s6, $s7
	#counter for each square
	addi	$s7, $s7, 1
	bne	$s7, 7, loopRight
	li	$s7, 0

#first row	
loopRight:	
	beq	$t1, $t2, loopDown  # branch if i == 7
	# now draw a green 7 times right
	addi	$a0, $a0, 1
	li	$a2, 0
	jal	draw_pixel
	mul	$a2, $s6, 4
	lw	$a2, colors($a2)
	#draw black before each pixel is drawn	
	jal	draw_pixel
	addi	$t1, $t1, 1	# i++
	addi	$s6, $s6, 1
	bne	$s6, 7, tempLabel
	li	$s6, 0
	
tempLabel:		
	j	loopRight

	
loopDown:	
	beq	$t3, $t4, loopLeft  # branch if i == 7		
	# now draw a red 7 times below
	addi	$a1, $a1, 1
	li	$a2, 0
	jal	draw_pixel
	mul	$a2, $s6, 4
	lw	$a2, colors($a2)
	jal	draw_pixel
	addi	$t3, $t3, 1	# i++
	addi	$s6, $s6, 1
	bne	$s6, 7, tempLabel2
	li	$s6, 0
tempLabel2:	
	j	loopDown
	
loopLeft: 
	beq	$t5, $t6, loopUp  # branch if i == 7
	# now draw a blue 7 times left
	addi	$a0, $a0, -1
	li	$a2, 0
	jal	draw_pixel
	mul	$a2, $s6, 4
	lw	$a2, colors($a2)
	jal	draw_pixel
	addi	$t5, $t5, 1	# i++
	addi	$s6, $s6, 1
	bne	$s6, 7, tempLabel3
	li	$s6, 0
	
tempLabel3:	
	j	loopLeft

loopUp:
	beq	$t7, $t8, main  # branch if i == 7
	# now draw a yellow 7 times up
	addi	$a1, $a1, -1
	li	$a2, 0
	jal	draw_pixel
	mul	$a2, $s6, 4
	lw	$a2, colors($a2)
	jal	draw_pixel
	addi	$t7, $t7, 1	# i++
	addi	$s6, $s6, 1
	bne	$s6, 7, tempLabel4
	li	$s6, 0
	
tempLabel4:	
	j	loopUp

exit:	
	li	$v0, 10
	syscall

#################################################
# subroutine to draw a pixel
# $a0 = X
# $a1 = Y
# $a2 = color

draw_pixel:
	# s1 = address = MEM + 4*(x + y*width)
	mul	$s1, $a1, WIDTH   # y * WIDTH
	add	$s1, $s1, $a0	  # add X
	mul	$s1, $s1, 4	  # multiply by 4 to get word offset
	add	$s1, $s1, $gp	  # add to base address
	sw	$a2, 0($s1)	  # store color at memory location
	jr 	$ra

#pause function between pixel writes
pause:
	
    	addi    $sp, $sp, -8
    	sw    	$ra, 4($sp)
    	sw   	$a0, ($sp)
    	#syscall provided in instructions
    	li    	$v0, 32    
    	#allows for sleep of 5ms
   	li    	$a0, 5    
   	syscall
   	
    	lw    	$a0, ($sp)
    	lw    	$ra, 4($sp)
    	addi    $sp, $sp, 8
    	jr    	$ra

