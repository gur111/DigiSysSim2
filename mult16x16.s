# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
	la		t3, a
	lw		t3, 0(t3)
	la		t4, b
	lw		t4, 0(t4)
	
	# t6 will contain the result
	add		t6, x0, x0

	# Mask for 16x8=24 multiply
	ori		t0, x0, 0xff
	slli	t0, t0, 8
	ori		t0, t0, 0xff
	slli	t0, t0, 8
	ori		t0, t0, 0xff
	
####################
# Start of your code

# Use the code below for 16x8 multiplication
#   mul		<PROD>, <FACTOR1>, <FACTOR2>
#   and		<PROD>, <PROD>, t0


	beq		x0, t3, finish
	beq		x0, t4, finish

	# Put 8 lower bits of b in t1
	andi	t1, t4, 0xff
	beq		x0, t1, upper
	# Multiply 8 lower bits by a and save to t1
	mul		t1, t1, t3
	and		t1, t1, t0
	# Add to the result
	add		t6, t6, t1

upper:
	# Put 8 upper bits of b in t1
	srli	t1, t4, 8
	andi	t1, t1, 0xff
	beq		x0, t1, finish
	# Multiply 8 lower bits by a and save to t1
	mul		t1, t1, t3
	and		t1, t1, t0
	# Shift back left
	slli	t1, t1, 8
	# Add to the result
	add		t6, t6, t1

# End of your code
####################
		
finish: addi    a0, x0, 1
	addi    a1, t6, 0
	ecall # print integer ecall
	addi    a0, x0, 10
	ecall # terminate ecall


