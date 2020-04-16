.data
v0: .asciiz "v0: "
v1: .asciiz "v1: "

good_game: .asciiz "good game"
sillllllly: .asciiz "sillllllly"
hmm: .asciiz "hmm"
s220: .asciiz "220"
Computer_Science: .asciiz "Computer Science"
cs: .asciiz "cs"
I: .asciiz "I"
Stony_Brook_University: .asciiz "Stony Brook University"
i: .asciiz "i"
help: .asciiz "help"
what: .asciiz "what"
OK_thanks: .asciiz "OK thanks"
hmmmm: .asciiz "hmmmm"
u: .asciiz "u"
hepl: .asciiz "hepl"
CSE101: .asciiz "CSE101"
ams: .asciiz "ams"
thx: .asciiz "thx"
silly: .asciiz "silly"
yuo: .asciiz "yuo"
Boise_State_University: .asciiz "Boise State University"
subtraction: .asciiz "subtraction"
OH: .asciiz "OH"
sto: .asciiz "sto"
wat: .asciiz "wat"
sbu: .asciiz "sbu"
sub: .asciiz "sub"
MIPS: .asciiz "MIPS"
s101: .asciiz "101"
kk: .asciiz "kk"
Universal_Serial_Bus: .asciiz "Universal Serial Bus"
calss: .asciiz "calss"
bsu: .asciiz "bsu"
you: .asciiz "you"
can: .asciiz "can"
MIPSR10000: .asciiz "MIPSR10000"
oh: .asciiz "oh"
cna: .asciiz "cna"
class: .asciiz "class"
thanks: .asciiz "thanks"
gg: .asciiz "gg"
usb: .asciiz "usb"
Stony_Brook: .asciiz "Stony Brook"
argh: .asciiz "argh"
arrgghh: .asciiz "arrgghh"
Applied_Mathematics: .asciiz "Applied Mathematics"
CSE_220: .asciiz "CSE 220"
arrow: " -> "
zero: .asciiz "0x00000000"
one: .asciiz "0x00000001"
size: .asciiz "Size: "
capacity: .asciiz "Capacity: "


hash_table:
.word 7
.word 5

# Example 1:

#.word 0, 0, 0, 0, 0, 0, 0
#.word 0, 0, 0, 0, 0, 0, 0

# Example 2 and 3:

#.word 0, usb, 0, 0, kk, 0, s101
#.word 0, Universal_Serial_Bus, 0, 0, OK_thanks, 0, CSE101

# Example 4:

#.word i, usb, 1, 1, thx, 0, s101
#.word I, Universal_Serial_Bus, 0, 0, thanks, 0, CSE101

# Example 5: 

#.word s101, ams, 0, 0, kk, thx, yuo
#.word CSE101, Applied_Mathematics, 0, 0, OK_thanks, thanks, you

# Example 6: 

#.word kk, 1, 1, ams, 0, 0, 1
#.word OK_thanks, 0, 0, Applied_Mathematics, 0, 0, 0

# Example 7: ################## Prints 1, 4 instead of 1, 3

.word s101, ams, cs, oh, kk, thx, yuo
.word CSE101, Applied_Mathematics, Computer_Science, OH, OK_thanks, thanks, you

# Initial:

#.word s101, ams, 0, 0, kk, thx, yuo
#.word CSE101, Applied_Mathematics, 0, 0, OK_thanks, thanks, you



.text
.globl main
main:
la $a0, hash_table
la $a1, gg
jal delete
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
