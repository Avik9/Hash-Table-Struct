# Name: Avik Kadakia
# Net ID: akadakia
# SBU ID: 111304945

.text
##################################### PART I #######################################
	#																			#
	#	Parameters:																#
	#		$a0 - Starting address of the first string				    		#
	#		$a1 - Starting address of the second string		    				#
    #                                                                           #
	#	    $s0 - Starting address of the first string          				#
	#	    $s1 - Starting address of the second string         				#
    #                                                                           #
	#	    $t0 - Holds individual characters from the first string				#
	#	    $t1 - Holds individual characters from the second string			#
	#	    $t2 - Length of the first string                        			#
	#	    $t3 - Length of the second string                        			#
	#																			#
	#	Returns:																#
	#	   $v0 = str1[n] - str2[n]                                              #
	#                                                                           #
    #            0: both strings are identical (including empty strings)        #
    #                                                                           #
    #            length of str1: str2 is an empty string but str1 is not.       # 
    #                                                                           #
    #            negated length of s2: str1 is empty string but str2 is not.  	#
	#																    		#
####################################################################################
strcmp:

    addi $sp, $sp, -12 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
	sw $s1, 8($sp) # Stored s1 from the caller function

    move $s0, $a0 # s0 = the starting address of the first string
	move $s1, $a1 # s1 = the starting address of the second string

    # Get the length of the first string
strlen1:

	lb $t0, 0($s0) # 0th offset of the string
	li $t2, 0 # Counter = 0

strlen_loop1:

	beq $t0, $0, strlen2 # If the character in the string is equal to null terminating string, end the loop
	addi $t2, $t2, 1 # Counter++

	addi $s0, $s0, 1 # Next character in the string
	lb $t0, 0($s0) # Holds the individual character from $a0
	j strlen_loop1

    # Get the length of the second string
strlen2:

	lb $t1, 0($s1) # 0th offset of the string
	li $t3, 0 # Counter = 0

strlen_loop2:

	beq $t1, $0, strcmp_continue # If the character in the string is equal to null terminating string, end the loop
	addi $t3, $t3, 1 # Counter++

	addi $s1, $s1, 1 # Next character in the string
	lb $t1, 0($s1) # Holds the individual character from $a0
	j strlen_loop2

strcmp_continue:

    move $s0, $a0 # s0 = the starting address of the first string
	move $s1, $a1 # s1 = the starting address of the second string

    lb $t0, 0($s0) # First letter in the first string
    lb $t1, 0($s1) # First letter in the second string

    beq $t2, 0, first_string_empty
    beq $t3, 0, second_string_empty

strcmp_loop:

    lb $t0, 0($s0) # First letter in the first string
    lb $t1, 0($s1) # First letter in the second string

    beq $t0, $0, first_string_done # If current character is null, string is done
    beq $t1, $0, second_string_done # If current character is null, string is done

    bne $t0, $t1, strings_not_equal # If $t0 != $t1, loop is done

    # Else get the next characters to compare: 

    addi $s0, $s0, 1
    addi $s1, $s1, 1

    j strcmp_loop

first_string_empty:

    beq $t3, 0, strings_equal # If string 1 is empty and string 2 is empty, return 0
    li $t4, -1
    mul $v0, $t3, $t4 # To return the negated length

    j Part_I_Done

first_string_done:

    beq $t1, $0, strings_equal # If string 2 is done too, return 0
    j strings_not_equal

second_string_empty:

    beq $t2, 0, strings_equal # If string 1 is empty and string 2 is empty, return 
    move $v0, $t2
    
    j Part_I_Done
    
second_string_done:

    beq $t0, $0, strings_equal # If string 1 is done too, return 0
    j strings_not_equal

strings_equal:
    
    li $v0, 0 # Both the strings are equal

    j Part_I_Done

strings_not_equal:

    sub $v0, $t0, $t1

    j Part_I_Done

Part_I_Done:

    lw $ra, 0($sp) # Stored the return address on the stack
	lw $s0, 4($sp) # Loaded s0 from the caller function
	lw $s1, 8($sp) # Loaded s1 from the caller function
	
	addi $sp, $sp, 12 # Deallocated the stack space
    jr $ra

##################################### PART II ######################################
	#																			#
	#	Parameters:																#
	#		$a0 - starting address of the target                                #
	#		$a1 - starting address of several null-terminated strings			#
    #       $a2 - length of the null-terminated string                          #
    #                                                                           #
	#	    $s0 - Starting address of the target string          				#
	#	    $s1 - Starting address of the several null-terminating strings      #
 	#	    $s2 - Length of the null-terminated string                        	#
	#	    $s3 - Null-terminated string counter                               	#    
	#                                                                           #
	#	    $t0 - Holds individual characters from the string				    #
	#	    $t1 - Null-terminated string counter                            	#
	#	    $t2 - Position counter                                             	#
	#																			#
	#	Returns:																#
	#	   $v0 = index of the first letter of target inside strings             #
	#                                                                           #
    #            -1: target not found                                           #
    #                strings_length ($a2) < 2                                	#
	#																    		#
####################################################################################
find_string:

    addi $sp, $sp, -20 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
	sw $s1, 8($sp) # Stored s1 from the caller function
    sw $s2, 12($sp) # Stored s2 from the caller function
    sw $s3, 16($sp) # Stored s3 from the caller function

    move $s0, $a0 # s0 = Starting address of the target string
	move $s1, $a1 # s1 = Starting address of the several null-terminating strings
    move $s2, $a2 # s2 = Length of the null-terminated string

find_string_continue:

    blt $s2, 2, not_found # If the length of the null_terminating string < 2, done
	li $s3, 0 # Counter for the null-terminating strings

find_string_loop:

    beq $s2, $s3, not_found # Counter = length then done

    add $s1, $a1, $t2 # Null terminating string beginning address + Null-terminated string counter

    move $a0, $s0 # the target
    move $a1, $s1 # new address in the null-terminating string to start from

    jal strcmp

    beq $v0, 0, found

find_string_length:

    # Get the length of the first string

	lb $t0, 0($s1) # 0th offset of the string
	li $t2, 0 # Position counter

find_string_length_loop:

	beq $t0, $0, find_string_continue2 # If the character in the string is equal to null terminating string, end the loop
	addi $t2, $t2, 1 # Counter++

	addi $s1, $s1, 1 # Next character in the string
	lb $t0, 0($s1) # Holds the individual character from $a0
	j find_string_length_loop

find_string_continue2:

    add $s3, $s3, $t2 # Null-terminated string counter += position counter 
    addi $s3, $s3, 1 # Null-terminated string counter++
    addi $t2, $t2, 1

    # starting address of the several null-terminating strings + current character in the several null-terminating strings
    j find_string_loop

found:

    move $v0, $s3
    j Part_II_Done

not_found:

    li $t0, -1
    move $v0, $t0

    j Part_II_Done

Part_II_Done:

    lw $ra, 0($sp) # Stored the return address on the stack
	lw $s0, 4($sp) # Loaded s0 from the caller function
	lw $s1, 8($sp) # Loaded s1 from the caller function
    lw $s2, 12($sp) # Loaded s2 from the caller function
    lw $s3, 16($sp) # Loaded s2 from the caller function

    addi $sp, $sp, 20 # Deallocated the stack space
    jr $ra

##################################### PART III #####################################
	#																			#
	#	Parameters:																#
	#		$a0 - HashTable                                                     #
	#		$a1 - Key                                                           #
    #                                                                           #
	#	    $s0 - Address of the HashTable                        				#
	#		$s1 - key                                                           #
	#                                                                           #
	#	    $t0 - Capacity                                  				    #
	#	    $t1 - Size                                                          #
	#	    $t2 - Sum of the characters                                     	#
	#																			#
	#	Returns:																#
	#	   $v0 = hash code of the string                                       	#
	#																    		#
####################################################################################
hash:

    addi $sp, $sp, -12 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
    sw $s1, 8($sp) # Stored s1 from the caller function

    move $s0, $a0 # $s0 = HashTable
    move $s1, $a1 # $s1 = key

    lw $t0, 0($s0) # Capacity 
    lw $t1, 4($s0) # Size
    li $t2, 0

hash_loop:

    lb $t3, 0($s1) # $t3 = First character of key
    beq $t3, $0, exit_loop # If 4t3 == $0, exit

    add $t2, $t2, $t3 # totalSum += current character's ASCII value
    addi $s1, $s1, 1 # Next character

    j hash_loop

exit_loop:

    div $t2, $t0 # totalSum % capacity

    mfhi $v0 # $v0 = totalSum % capacity

Part_III_Done:

    lw $ra, 0($sp) # Stored the return address on the stack
	lw $s0, 4($sp) # Loaded s0 from the caller function
    lw $s1, 8($sp) # Loaded s0 from the caller function

    addi $sp, $sp, 12 # Deallocated the stack space
    jr $ra

##################################### PART IV #####################################
	#																			#
	#	Parameters:																#
	#		$a0 - HashTable                                                     #
    #                                                                           #
	#	    $s0 - Address of the HashTable                        				#
	#                                                                           #
	#	    $t0 - Capacity                                  				    #
	#	    $t1 - 2 or 5                                                        #
	#																			#
####################################################################################
clear: ########################## Make size 0

    addi $sp, $sp, -8 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function

    move $s0, $a0

    lw $t0, 0($s0) # Capacity
    li $t1, 2
    mul $t0, $t0, $t1
    li $t1, 0

clear_loop:

    beq $t0, $0, Part_IV_Done

    sw $t1, 8($s0)

    addi $s0, $s0, 4
    addi $t0, $t0, -1

    j clear_loop

Part_IV_Done:

    lw $ra, 0($sp) # Stored the return address on the stack
	lw $s0, 4($sp) # Loaded s0 from the caller function

    addi $sp, $sp, 8 # Deallocated the stack space
    jr $ra

##################################### PART V ######################################
	#																			#
	#	Parameters:																#
	#		$a0 - HashTable                                                     #	
    #		$a1 - Key                                                           #
    #                                                                           #
	#	    $s0 - Address of the HashTable                        				#
	#		$s1 - key                                                           #
	#       $s2 - keys[]                                                        #
	#       $s3 - Capacity                                                      #
	#       $s4 - Counter                                                       #
	#       $s5 - Index                                                         #
	#                                                                           #
	#	    $t0 - Hash Code for the key / Hash Code for the key * 4             #
	#	    $t1 - First word in the keys[]                                      #
	#																			#
	#	Returns:																#
	#	   $v0 = index in hash table's keys[]                                  	#
	#			-1: if key is not found						    	    		#
	#																    		#
	#	   $v1 = number of probes required to find the key in keys[]		    #
	#																    		#
####################################################################################
get:
    addi $sp, $sp, -28 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
    sw $s1, 8($sp) # Stored s1 from the caller function
    sw $s2, 12($sp) # Stored s2 from the caller function
    sw $s3, 16($sp) # Stored s3 from the caller function
	sw $s4, 20($sp) # Stored s4 from the caller function
	sw $s5, 24($sp) # Stored s5 from the caller function	

    move $s0, $a0 # $s0 = HashTable
    move $s1, $a1 # $s1 = key
    lw $s3, 0($s0) # $s3 = capacity

    jal hash

    move $t0, $v0 # $t0 = hash code of the string
    sll $t0, $t0, 2 # Multiply by 4
    addi $s2, $s0, 8 # starting address of the keys[]
    add $s2, $s2, $t0 # Hash code + starting address of the keys[]

    li $s4, -1 # Counter
    addi $s5, $v0, -1 # Index
    
get_loop:

    addi $s4, $s4, 1 # Counter++ 
    addi $s5, $s5, 1 # Index++
    
    ble $s3, $s5 get_check_index # if capacity <= index, get_loop

    beq $s3, $s4, part_V_not_found # if capacity == counter, stop

    lw $t1, 0($s2) # Get the first word from $t1

    beq $t1, 1, get_found_one

    beq $t1, 0, get_found_empty_space # If the word == 0x00000000
	
	lw $a0, 0($s2) # $a0 = the first word in keys[]
	move $a1, $s1 # $a1 = key

	jal strcmp # Compare the strings
	
	beq $v0, 0, part_V_found # If strings are equal, done
    
    addi $s2, $s2, 4 # next index in the keys[]

    j get_loop

get_check_index:

    addi $s4, $s4, -1
    li $s5, -1
    addi $s2, $s0, 8 # Reset to the beginning of keys[]
    
    j get_loop

part_V_found: # Case 1

    move $v0, $s5
    addi $v1, $s4, 0

    j Part_V_Done

get_found_empty_space: # Case 2

    li $v0, -1
    addi $v1, $s4, 0

    j Part_V_Done

part_V_not_found: # Case 3

    li $v0, -1
    addi $v1, $s3, -1 # Account for probe

    j Part_V_Done

get_found_one:

    addi $s2, $s2, 4 # next index in the keys[]

    j get_loop

Part_V_Done:

    lw $ra, 0($sp) # Stored the return address on the stack
	lw $s0, 4($sp) # Loaded s0 from the caller function
	lw $s1, 8($sp) # Loaded s1 from the caller function
    lw $s2, 12($sp) # Loaded s2 from the caller function
    lw $s3, 16($sp) # Loaded s3 from the caller function
    lw $s4, 20($sp) # Loaded s4 from the caller function
    lw $s5, 24($sp) # Loaded s5 from the caller function

    addi $sp, $sp, 28 # Deallocated the stack space
    jr $ra

##################################### PART VI #####################################
	#																			#
	#	Parameters:																#
	#		$a0 - HashTable                                                     #	
    #		$a1 - Key                                                           #
    #		$a2 - Value                                                         #
    #                                                                           #
	#	    $s0 - Address of the HashTable                        				#
	#		$s1 - key                                                           #
	#       $s2 - keys[]                                                        #
	#       $s3 - Capacity                                                      #
	#       $s4 - Counter                                                       #
	#       $s5 - Index                                                         #
	#                                                                           #
	#	    $t0 - Hash Code for the key / Hash Code for the key * 4             #
	#	    $t1 - First word in the keys[]                                      #
	#																			#
	#	Returns:																#
	#	   $v0 = index in hash table's keys[]                                  	#
	#			-1: if key is not found						    	    		#
	#																    		#
	#	   $v1 = number of probes required to find the key in keys[]		    #
	#			-1: if key is not found						    	    		#
	#																    		#
####################################################################################
put:

    addi $sp, $sp, -32 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
    sw $s1, 8($sp) # Stored s1 from the caller function
    sw $s2, 12($sp) # Stored s2 from the caller function
    sw $s3, 16($sp) # Stored s3 from the caller function
	sw $s4, 20($sp) # Stored s4 from the caller function
	sw $s5, 24($sp) # Stored s5 from the caller function
    sw $s6, 28($sp) # Stored s6 from the caller function
    sw $s7, 32($sp) # Stored s7 from the caller function

    move $s0, $a0 # $s0 = Address of the Hash Table
    move $s1, $a1 # $s1 = Key
    lw $s3, 0($s0) # $s3 = Capacity
    li $s4, 0 # $s4 = Counter
    move $s6, $a2 # $s6 = Value
    lw $s7, 4($s0) # $s7 = Size

    jal get

    beq $v0, -1, check_space
    bne $v0, -1, put_here

    j put_continue

put_here:

    move $t0, $v0 # $t0 = hash code of the string
    sll $t0, $t0, 2 # Multiply by 4
    # $t0 = 4 * hascode that will be added to the values[]

    addi $t1, $s3, 4
    sll $t1, $t1, 2
    
    #lw $s2, 12($s0) # $s2 = starting address of values[]
    add $s2, $s0, $t1 # $s2 = starting address of values[]
    
    #addi $s2, $s0, 8 # starting address of the keys[]
    #add $s2, $s2, $t0 # Hash code + starting address of the keys[]

    sw $s6, 0($s2)
    j Part_VI_Done

check_space:

    beq $s3, $s7, no_key_or_space

    j put_continue

put_continue:

    move $a0, $s0 # $a0 = HashTable
    move $a1, $s1 # $a1 = key

    jal hash

    move $t0, $v0 # $t0 = hash code of the string
    sll $t0, $t0, 2 # Multiply by 4
    addi $s2, $s0, 8 # starting address of the keys[]
    add $s2, $s2, $t0 # Hash code + starting address of the keys[]

    li $s4, -1 # Counter
    addi $s5, $v0, -1 # Index

put_continue_loop:

    ble $s3, $s5 put_check_index # if capacity <= index, get_loop

    addi $s4, $s4, 1 # Counter++ 
    addi $s5, $s5, 1 # Index++

    beq $s3, $s4, no_key_or_space # if capacity == counter, stop

    lw $t1, 0($s2) # Get the first word from $t1

    beq $t1, 1, put_found_one

    beq $t1, 0, put_found_empty_space # If the word == 0x00000000
	
	lw $a0, 0($s2) # $a0 = the first word in keys[]
	move $a1, $s1 # $a1 = key

	jal strcmp # Compare the strings
	
	beq $v0, 0, put_found_key # If strings are equal, done

    addi $s2, $s2, 4 # next index in the keys[]

    j put_continue_loop

put_found_key:

    sll $t2, $s3, 2
    add $s2, $s2, $t2
    sw $s6, 0($s2)

    j put_done

put_check_index:

    #bgt $s3, $s5 put_continue_loop # if capacity >= index, get_loop
    addi $s4, $s4, -1
    li $s5, -1
    addi $s2, $s0, 8 # Reset to the beginning of keys[]
    
    j put_continue_loop

put_found_one:

    sw $s1, 0($s2)
    sll $t2, $s3, 2
    add $s2, $s2, $t2

    sw $s6, 0($s2)

    j put_done
    
put_found_empty_space:

    addi $s7, $s7, 1
    sw $s7, 4($s0)

    sw $s1, 0($s2)
    sll $t2, $s3, 2
    add $s2, $s2, $t2

    sw $s6, 0($s2)
    
    j put_empty_space

no_key_or_space:

    li $v0, -1
    li $v1, -1

    j Part_VI_Done

put_done:

    move $v0, $s5
    addi $v1, $s4, 0

    j Part_VI_Done

put_empty_space:
	
	move $v0, $s5
    move $v1, $s4

    j Part_VI_Done

Part_VI_Done:

    lw $ra, 0($sp) # Stored the return address on the stack
	lw $s0, 4($sp) # Loaded s0 from the caller function
	lw $s1, 8($sp) # Loaded s1 from the caller function
    lw $s2, 12($sp) # Loaded s2 from the caller function
    lw $s3, 16($sp) # Loaded s3 from the caller function
    lw $s4, 20($sp) # Loaded s4 from the caller function
    lw $s5, 24($sp) # Loaded s5 from the caller function
    lw $s6, 28($sp) # Stored s6 from the caller function
    lw $s7, 32($sp) # Stored s7 from the caller function


    addi $sp, $sp, 32 # Deallocated the stack space
    jr $ra

##################################### PART VII ####################################
	#																			#
	#	Parameters:																#
	#		$a0 - HashTable                                                     #	
    #		$a1 - Key                                                           #
    #                                                                           #
	#	    $s0 - Address of the HashTable                        				#
	#		$s1 - key                                                           #
	#       $s2 - Capacity                                                      #
	#       $s3 - Size                                                    		#
	#       $s4 - Keys[]                                                        #
	#       $s5 - Values[]                                                      #
	#       $s6 - Keys[key]                                                     #
	#       $s7 - Values[key]                                                   #
	#                                                                           #
	#	    $t0 - 0													            #
	#	    $t1 - 1							                                    #
	#	    $t2 - 4 * (Capacity + 2) 			                                #
	#																			#
	#	Returns:																#
	#	   $v0 = index in hash table's keys[]                                  	#
	#			-1: if key is not found						    	    		#
	#																    		#
	#	   $v1 = number of probes required to find the key in keys[]		    #
	#			-1: if key is not found						    	    		#
	#																    		#
####################################################################################
delete:

    addi $sp, $sp, -36 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
    sw $s1, 8($sp) # Stored s1 from the caller function
    sw $s2, 12($sp) # Stored s2 from the caller function
    sw $s3, 16($sp) # Stored s3 from the caller function
	sw $s4, 20($sp) # Stored s4 from the caller function
	sw $s5, 24($sp) # Stored s5 from the caller function
    sw $s6, 28($sp) # Stored s6 from the caller function
    sw $s7, 32($sp) # Stored s7 from the caller function

    move $s0, $a0 # $s0 = Hash Table
    move $s1, $a1 # $s1 = Key

    lw $s2, 0($s0) # $s2 = Capacity
    lw $s3, 4($s0) # $s3 = Size
    lw $s4, 8($s0) # $s4 = Beginning address of keys[]
    lw $s5, 12($s0) # $s5 = Beginning address of values[]

    beq $s3, 0, delete_empty_hash_table # If size == 0, table is empty

    move $a0, $s0 # $a0 = Address of the Hash Table
    move $a1, $s1 # $a1 = Address of the key

    jal get

    beq $v0, -1, Part_VII_Done
    bne $v0, -1, delete_index_found

    sll $s6, $v0, 2
    add $s6, $s6, $s4

    sll $s7, $v0, 2
    add $s7, $s7, $s5

    li $t0, 0
    li $t1, 1

    sw $t0, 0($s6)
    sw $t1, 0($s7)
    
    # Decremented the size
    addi $s3, $s3, -1
    sw $s3, 4($s0)

    j Part_VII_Done

delete_index_found:

    move $t0, $v0 # $t0 = hash code of the string
    sll $t0, $t0, 2 # Multiply by 4
    # $t0 = 4 * hascode that will be added to the values[]
    
    addi $s6, $s0, 8
    add $s6, $s6, $t0

    li $t0, 0
    li $t1, 1

    sw $t1, 0($s6)
    
    # For the values[]
    addi $t2, $s2, 2
    add $t2, $t2, $v0
    sll $t2, $t2, 2
    
    add $s7, $s0, $t2 # $s2 = starting address of values[]
    
    sw $t0, 0($s7)

    # Decremented the size
    addi $s3, $s3, -1
    sw $s3, 4($s0)

    j Part_VII_Done

delete_empty_hash_table:

    li $v0, -1
    li $v1, 0

    j Part_VII_Done

Part_VII_Done:

    lw $ra, 0($sp) # Stored the return address on the stack
	lw $s0, 4($sp) # Loaded s0 from the caller function
	lw $s1, 8($sp) # Loaded s1 from the caller function
    lw $s2, 12($sp) # Loaded s2 from the caller function
    lw $s3, 16($sp) # Loaded s3 from the caller function
    lw $s4, 20($sp) # Loaded s4 from the caller function
    lw $s5, 24($sp) # Loaded s5 from the caller function
    lw $s6, 28($sp) # Stored s6 from the caller function
    lw $s7, 32($sp) # Stored s7 from the caller function

    addi $sp, $sp, 36 # Deallocated the stack space
    jr $ra

################################## PART VIII ######################################
	#																			#
	#	Parameters:																#
	#		$a0 - HashTable                                                     #	
    #		$a1 - strings                                                       #
    #		$a2 - strings_length                                                #
    #		$a3 - filename                                                      #
    #                                                                           #
	#		$s0 - HashTable                                                     #	
    #		$s1 - strings                                                       #
    #		$s2 - strings_length                                                #
    #		$s3 - filename / Counter for the stack                              #
    #       $s4 - Keys[]                                                        #
	#       $s5 - Values[]                                                      #
	#       $s6 - Keys[key]                                                     #
	#       $s7 - Values[key]                                                   #
	#                                                                           #
	#	    $t0 - 0													            #
	#	    $t1 - 1							                                    #
	#	    $t2 - 4 * (Capacity + 2) 			                                #
	#																			#
	#	Returns:																#
	#	   $v0 = # of key-value pairs read                                  	#
	#																    		#
####################################################################################
build_hash_table:

    addi $sp, $sp, -36 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
    sw $s1, 8($sp) # Stored s1 from the caller function
    sw $s2, 12($sp) # Stored s2 from the caller function
    sw $s3, 16($sp) # Stored s3 from the caller function
	sw $s4, 20($sp) # Stored s4 from the caller function
	sw $s5, 24($sp) # Stored s5 from the caller function
    sw $s6, 28($sp) # Stored s6 from the caller function
    sw $s7, 32($sp) # Stored s7 from the caller function

    move $s0, $a0 # $s0 = Hash Table
    move $s1, $a1 # $s1 = strings
    move $s2, $a2 # $s2 = strings_length
    move $s3, $a3 # $s3 = filename

    jal clear
    
    lw $ra, 0($sp)

    # Open a file
    li $v0, 13          # system call for open file
    move $a0, $s3       # input file name
    li $a1, 0           # Open for reading (flags are 0: read, 1: write)
    li $a2, 0           # mode is ignored
    syscall             # open a file (file descriptor returned in $v0)
    
    beq $v0, -1, file_not_found
    
    move $t5, $v0
    
    addi $sp, $sp, -80  # Allocated space on the stack to read the file
    move $s4, $sp       # To store on the stack

    li $s5, 0
    move $s3, $sp       # Stack Pointer location

read_file:

    move $s4, $s3

    # Read the file just opened
    li $v0, 14      	# system call for write to file
    move $a0, $t5     	# file descriptor 
    move $a1, $s4 		# address of buffer from which to write
    li $a2, 80      	# hardcoded buffer length
    syscall         	# Read the file   

    li $t2, -1

look_for_key:

    addi $t2, $t2, 1

    beq $v0, 0, close_file # If nothing is read, file has reached the end, thus close it

    lb $t1, 0($s4) # get the first char read.

    beq $t1, ' ', build_hash_table_found_key # If $t1 == ' ', key is found

    #beq $t1, '\n', build_hash_table_found_value # If $t1 == '\n', value is found 

    addi $s4, $s4, 1 # Move to the next char in the stack

    j look_for_key

look_for_value:

    addi $t2, $t2, 1

    beq $v0, 0, close_file # If nothing is read, file has reached the end, thus close it

    lb $t1, 0($s4) # get the first char read.

    #beq $t1, ' ', build_hash_table_found_key # If $t1 == ' ', key is found

    beq $t1, '\n', build_hash_table_found_value # If $t1 == '\n', value is found 

    addi $s4, $s4, 1 # Move to the next char in the stack

    j look_for_value


build_hash_table_found_key:

    move $sp, $s3
    add $s4, $t2, $s3
    #addi $s4, $s4, 1
    
    li $t1, 0
    sb $t1, 0($s4)

    #sub $s3, $s4, $t2

    move $a0, $s3 # $a0 = Starting address of the target string
    move $a1, $s1 # $a1 = Starting address of the several null-terminating strings
    move $a2, $s2 # $a2 = length of the null-terminated string

    jal find_string

    lw $ra, 80($sp) 	# Loaded the return address on the stack 
    
    move $s4, $s3

    add $s6, $s1, $v0 # $s6 = null-terminated strings' base address + the index where the target appears
    # $s6 = starting address of the key

    move $sp, $s3

    move $s4, $s3

    li $t2, -1

    j look_for_value # Continue to look for value

build_hash_table_found_value: ######### continue logic

    move $sp, $s3
    add $s4, $t2, $s3

    li $t1, 0
    sb $t1, 0($s4)

    move $a0, $s4 # $a0 = Starting address of the target string
    move $a1, $s1 # $a1 = Starting address of the several null-terminating strings
    move $a2, $s2 # $a2 = length of the null-terminated string

    jal find_string

    lw $ra, 80($sp) 	# Stored the return address on the stack


    add $s7, $s1, $v0 # $s7 = null-terminated strings' base address + the index where the target appears
    # $s6 = starting address of the value

    move $a0, $s0 # $a0 = Hash Table
    move $a1, $s6 # $a1 = Starting address of the key in the null-terminated string
    move $a1, $s7 # $a2 = Starting address of the value in the null-terminated string

    jal put # Add it to the hash table

    lw $ra, 80($sp) 	# Stored the return address on the stack

    move $sp, $s3

    bne $v0, -1, add_counter # If the string is added, counter++

    move $s4, $s3

    addi $s4, $s4, 1

    j look_for_key

add_counter:
	
	addi $s5, $s5, 1 # counter++

    addi $s4, $s4, 1

    j look_for_key # continue reading the file

close_file:
	
	li   $v0, 16       # system call for close file
    move $a0, $s4      # file descriptor to close
    syscall            # close file
    
    addi $sp, $sp, 80 # Deallocated stack space saved to read the file
    move $v0, $s5 # Number of pairs added == counter
    
    j Part_VIII_Done

file_not_found:
	
 	li $v0, -1
	
 	j Part_VIII_Done
	
Part_VIII_Done:

    #lw $ra, 0($sp) 	# Stored the return address on the stack
	lw $s0, 4($sp) 	# Loaded s0 from the caller function
	lw $s1, 8($sp) 	# Loaded s1 from the caller function
    lw $s2, 12($sp) # Loaded s2 from the caller function
    lw $s3, 16($sp) # Loaded s3 from the caller function
    lw $s4, 20($sp) # Loaded s4 from the caller function
    lw $s5, 24($sp) # Loaded s5 from the caller function
    lw $s6, 28($sp) # Stored s6 from the caller function
    lw $s7, 32($sp) # Stored s7 from the caller function

    addi $sp, $sp, 36 # Deallocated the stack space
    jr $ra

################################## PART IX ########################################
	#																			#
	#	Parameters:																#
	#		$a0 - HashTable                                                     #	
    #		$a1 - strings                                                       #
    #		$a2 - strings_length                                                #
    #		$a3 - filename                                                      #
    #                                                                           #
	#		$s0 - HashTable                                                     #	
    #		$s1 - strings                                                       #
    #		$s2 - strings_length                                                #
    #		$s3 - filename                                                      #
    #       $s4 - Keys[]                                                        #
	#       $s5 - Values[]                                                      #
	#       $s6 - Keys[key]                                                     #
	#       $s7 - Values[key]                                                   #
	#                                                                           #
	#	    $t0 - 0													            #
	#	    $t1 - 1							                                    #
	#	    $t2 - 4 * (Capacity + 2) 			                                #
	#																			#
	#	Returns:																#
	#	   $v0 = # of key-value pairs read                                  	#
	#																    		#
####################################################################################
autocorrect:

    addi $sp, $sp, -36 # Allocated space on the stack
	sw $ra, 0($sp) # Stored the return address on the stack
	sw $s0, 4($sp) # Stored s0 from the caller function
    sw $s1, 8($sp) # Stored s1 from the caller function
    sw $s2, 12($sp) # Stored s2 from the caller function
    sw $s3, 16($sp) # Stored s3 from the caller function
	sw $s4, 20($sp) # Stored s4 from the caller function
	sw $s5, 24($sp) # Stored s5 from the caller function
    sw $s6, 28($sp) # Stored s6 from the caller function
    sw $s7, 32($sp) # Stored s7 from the caller function

Part_IX_Done:
