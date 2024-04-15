# mipstest.asm
# David_Harris@hmc.edu	9 November 2005 
#
# Test the MIPS processor.
# add, sub, and, or, slt, addi, lw, sw, beq, j
# If successful, it should write the value 7 to address 84

# Updated by @vsilchuk. Added: new test insructions:

#	Assembly			Description									Address		Machine                       
main:	addi $2, $0, 5			# initialize $2 = 5								0		20020005
	addi $3, $0, 12			# initialize $3 = 12								4		2003000c
	addi $7, $3, -9			# initialize $7 = 3								8		2067fff7 
	or   $4, $7, $2			# $4 <= 3 or 5 = 7								c		00e22025
	and $5,  $3, $4			# $5 <= 12 and 7 = 4								10		00642824
	add $5,  $5, $4			# $5 = 4 + 7 = 11								14		00a42820
	beq $5,  $7, end		# shouldn’t be taken								18		10a7000a
	slt $4,  $3, $4			# $4 = 12 < 7 = 0								1c		0064202a
	beq $4,  $0, around		# should be taken								20		10800001
	addi $5, $0, 0			# shouldn’t happen								24		20050000
around:	slt $4,  $7, $2			# $4 = 3 < 5 = 1								28		00e2202a
	add $7,  $4, $5			# $7 = 1 + 11 = 12								2c		00853820
	sub $7,  $7, $2			# $7 = 12 - 5 = 7								30		00e23822
	sw   $7, 68($3)			# [80] = 7									34		ac670044
	lw   $2, 80($0)			# $2 = [80] = 7									38		8c020050
	j    end			# should be taken								3c		08000011
	addi $2, $0, 1			# shouldn’t happen								40		20020001
end:	sw   $2, 84($0)			# write adr 84 = 7								44		ac020054
	addi $8, $0, 9			## initialize $8 = 9 = 0b1001									20080009
	addi $9, $0, 170		## initialize $9 = 170 = 0xAA = 0b10101010							200900AA		
	xor $10, $8, $9			## $8^$9 = 9^170 = 0b00001001 ^ 0b10101010 = 0b10100011 = 163					01095026
	nor $10, $8, $9			## ~(9 | 170) =  ~(0b00001001 | 0b10101010) = ~(0b10101011) = 0b01010100 = 84			01095027
	andi $11, $8, 10		## 9 & 10 = 0b1001 & 0b1010 = 0b1000 = 8							310B000A
	ori $11, $8, 10 		## 9 | 10 = 0b1001 | 0b1010 = 0b1011 = 11							350B000A					
	xori $11, $8, 10 		## 9 ^ 10 = 0b1001 ^ 0b1010 = 0b0011 = 3							390B000A				
	slti $12, $8, 20		## 9 < 20 --> $12 = 1										290C0014							
	bne $12, $0, label		## 1 != 0, will branch										15800001							
	andi $8, $0, 228		## shouldn't happen										300800E4								
label:	addi $13, $0, 2			## $13 = 2 = 0b10										200D0002								
	sll $14, $13, 3			## $14 = 2 * 2^^3 = 2 * 8 = 16									000D70C0
	addi $15, $0, 21845		## $15 = 21845 = 0b0101010101010101 = 0x5555 --> 0b00000000000000000101010101010101		200F5555				
	srl $16, $15, 4			## $16 = 0b00000000000000000000010101010101 = 1365						000F8102			
	sra $17, $15, 4			## $17 = 0b00000000000000000000010101010101 = 1365 						000F8903
	ror $18, $15, 4			## $18 = 0b01010000000000000000010101010101 = 1342178645 					000F9105
	rol $19, $15, 4			## $19 = 0b00000000000001010101010101010000 = 349520						000F9909		
	
