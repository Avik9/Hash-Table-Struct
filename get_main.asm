.data
.data
v0: .asciiz "v0: "
v1: .asciiz "v1: "

hash_table:
.word 7 # Capacity
.word 3 # Size

# Example 1:

#.word 0, 0, 0, 0, 0, 0, 0
#.word 0, 0, 0, 0, 0, 0, 0

# Example 2, 5: 

################################### Parts 1 - 5 work correctly.

#.word s101, ams, 0, 0, kk, thx, yuo
#.word CSE101, Applied_Mathematics, 0, 0, OK_thanks, thanks, you

# Example 3:

#.word 0, usb, 0, 0, kk, 0, s101
#.word 0, Applied_Mathematics, 0, 0, OK_thanks, 0, Universal_Serial_Bus

# Example 4:

#.word i, usb, 1, 1, thx, 0, s101
#.word I, Universal_Serial_Bus, 0, 0, thanks, 0, CSE101

# Example 6: 

################################### Returns 3, 5 when it is supposed to return 3, 4

#.word kk, 1, 1, ams, 0, 0, 1
#.word OK_thanks, 0, 0, Applied_Mathematics, 0, 0, 0

# Example 6 from Get:

.word 1, 1, thx, 1, 1, 1, 1
.word 0, 0, thanks, 0, 0, 0, 0

# Example 7:

#.word s101, ams, cs, oh, kk, thx, yuo
#.word CSE101, Applied_Mathematics, CS, OH, OK_thanks, thanks, you

# There are some extra strings here you can work with. Or add your own!
subtraction: .asciiz "subtraction"
s101: .asciiz "101"
sbu: .asciiz "sbu"
yuo: .asciiz "yuo"
u: .asciiz "u"
you: .asciiz "you"
wat: .asciiz "wat"
ams: .asciiz "ams"
help: .asciiz "help"
CSE101: .asciiz "CSE101"
bsu: .asciiz "bsu"
arrgghh: .asciiz "arrgghh"
calss: .asciiz "calss"
thx: .asciiz "thx"
Applied_Mathematics: .asciiz "Applied Mathematics"
hepl: .asciiz "hepl"
OK_thanks: .asciiz "OK thanks"
class: .asciiz "class"
can: .asciiz "can"
kk: .asciiz "kk"
i: .asciiz "i"
thanks: .asciiz "thanks"
usb: .asciiz "usb"
Universal_Serial_Bus: .asciiz "Universal_Serial_Bus"
oh: .asciiz "oh"
OH: .asciiz "OH"
I: .asciiz "I"
cs: .asciiz "cs"
CS: .asciiz "Computer Science"
gg: .asciiz "gg"

.text
.globl main
main:
la $a0, hash_table
la $a1, thx
jal get
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

li $v0, 10
syscall


.include "proj3.asm"
