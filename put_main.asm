.data
v0: .asciiz "v0: "
v1: .asciiz "v1: "

hash_table:
.word 7 # Capacity
.word 0 # Size

# Example 1:

.word 0, 0, 0, 0, 0, 0, 0
.word 0, 0, 0, 0, 0, 0, 0

# Example 2:

#.word 0, 0, 0, 0, kk, oh, 0
#.word 0, 0, 0, 0, OK_thanks, OH, 0

# Example 3:

#.word 0, bsu, 0, 0, kk, oh, 0
#.word 0, Boise_State_University, 0, 0, OK_thanks, OH, 0

# Example 4:

#.word 0, bsu, usb, 0, kk, oh, 0
#.word 0, Boise_State_University, Universal_Serial_Bus, 0, OK_thanks, OH, 0

# Example 5: ################## Prints 2, 4 instead of 2, 3

#.word s101, usb, 0, 0, kk, thx, yuo
#.word CSE101, Universal_Serial_Bus, 0, 0, OK_thanks, thanks, you

# Example 6: 

#.word 1, 1, thx, 1, 1, 1, 1
#.word 0, 0, thanks, 0, 0, 0, 0

# Example 7:

#.word s101, 1, 0, 0, kk, thx, yuo
#.word CSE101, 0, 0, 0, OK_thanks, thanks, you

you: .asciiz "you"
arrgghh: .asciiz "arrgghh"
subtraction: .asciiz "subtraction"
CSE_220: .asciiz "CSE 220"
MIPS: .asciiz "MIPS"
Boise_State_University: .asciiz "Boise State University"
sillllllly: .asciiz "sillllllly"
usb: .asciiz "usb"
i: .asciiz "i"
s101: .asciiz "101"
CSE101: .asciiz "CSE101"
class: .asciiz "class"
I: .asciiz "I"
cs: .asciiz "cs"
hmmmm: .asciiz "hmmmm"
hepl: .asciiz "hepl"
help: .asciiz "help"
Computer_Science: .asciiz "Computer Science"
can: .asciiz "can"
OK_thanks: .asciiz "OK thanks"
Applied_Mathematics: .asciiz "Applied Mathematics"
MIPSR10000: .asciiz "MIPSR10000"
ams: .asciiz "ams"
kk: .asciiz "kk"
silly: .asciiz "silly"
gg: .asciiz "gg"
OH: .asciiz "OH"
what: .asciiz "what"
argh: .asciiz "argh"
sto: .asciiz "sto"
sbu: .asciiz "sbu"
yuo: .asciiz "yuo"
thx: .asciiz "thx"
Stony_Brook_University: .asciiz "Stony Brook University"
wat: .asciiz "wat"
Universal_Serial_Bus: .asciiz "Universal Serial Bus"
hmm: .asciiz "hmm"
cna: .asciiz "cna"
bsu: .asciiz "bsu"
u: .asciiz "u"
good_game: .asciiz "good game"
oh: .asciiz "oh"
thanks: .asciiz "thanks"
sub: .asciiz "sub"
Stony_Brook: .asciiz "Stony Brook"
calss: .asciiz "calss"
arrow: " -> "
zero: .asciiz "0x00000000"
one: .asciiz "0x00000001"
size: .asciiz "Size: "
capacity: .asciiz "Capacity: "

.text
.globl main
main:
la $a0, hash_table
la $a1, usb
la $a2, Universal_Serial_Bus

#j print

jal put
move $t0, $v0
move $t1, $v1

la $a0, v0
li $v0, 4
syscall
li $v0, 1
move $a0, $t0
syscall
li $a0, '\n'
li $v0, 11
syscall

la $a0, v1
li $v0, 4
syscall
li $v0, 1
move $a0, $t1
syscall
li $a0, '\n'
li $v0, 11
syscall

# You should probably write code here to print the state of the hash table.
print:

	la $a0, capacity
	li $v0, 4
	syscall
	
	la $a0, hash_table
	lw $t0, 0($a0)
	#lw $t0, 0($s1)
	#lw $t0, 0($t0)
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall

	la $a0, size
	li $v0, 4
	syscall
	
	la $a0, hash_table
	#addi $s1, $a0, 4
	lw $t1, 4($a0)
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $t9, 0
	la $s0, hash_table

	addi $s1, $s0, 8 # Addr to keys[0]
	addi $s2, $s0, 36 # Addr to values[0]

loop:

	beq $t9, 7, quit
	
	lw $t1, 0($s1)
	
	beq $t1, 0, found_zero
	beq $t1, 1, found_one
	
	li $v0, 4
	move $a0, $t1
	syscall 

loop_continue:
	
	lw $t2, 0($s2)
	
	beq $t2, 0, found_zero_again
	beq $t2, 1, found_one_again

	la $a0, arrow
	li $v0, 4
	syscall

	li $v0, 4
	move $a0, $t2
	syscall

	li $a0, '\n'
	li $v0, 11
	syscall
	
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $t9, $t9, 1
	
	j loop
	
found_zero:
	
	la $a0, zero
	li $v0, 4
	syscall
	
	j loop_continue
	
found_zero_again:
	
	la $a0, arrow
	li $v0, 4
	syscall
	
	la $a0, zero
	li $v0, 4
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $t9, $t9, 1
	
	j loop
	
found_one:

	la $a0, one
	li $v0, 4
	syscall
	
	j loop_continue
	
found_one_again:
	
	la $a0, arrow
	li $v0, 4
	syscall
	
	la $a0, one
	li $v0, 4
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $t9, $t9, 1
	
	j loop
	
quit:

	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $v0, 10
	syscall

.include "proj3.asm"
