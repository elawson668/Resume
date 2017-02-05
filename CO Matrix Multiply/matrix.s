#############################################################################
#############################################################################
## Assignment 3: Eric Lawson
#############################################################################
#############################################################################

#############################################################################
#############################################################################
## Data segment
#############################################################################
#############################################################################

.data

matrix_a:    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
matrix_b:    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
result:      .word 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,  0,  0,  0,  0,  0,  0

prompt_a:    .asciiz "Enter the values for matrix A: "
prompt_b:    .asciiz "Enter the values for matrix B: "
product:     .asciiz "Product A x B matrices: "
newline:     .asciiz "\n"
tab:         .asciiz "\t"


#############################################################################
#############################################################################
## Text segment
#############################################################################
#############################################################################

.text                  # this is program code
.align 2               # instructions must be on word boundaries
.globl main            # main is a global label

.globl matrix_multiply
.globl matrix_print

#############################################################################
main:
#############################################################################
    # alloc stack and store $ra
    sub $sp, $sp, 4
    sw $ra, 0($sp)

    # input

    # matrix_a input
    la $a0, prompt_a
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    li $t0, -1
    jal InputALoop

    # matris_b input
    la $a0, prompt_b
    li $v0, 4
    syscall 
    la $a0, newline
    li $v0, 4
    syscall
    li $t0, -1
    jal InputBLoop

    # load A, B, and result into arg regs
    la $a0, matrix_a
    la $a1, matrix_b
    la $a2, result
    jal matrix_multiply

    la $a0, result
    jal matrix_print

    # restore $ra, free stack and return
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

# matrix_a input loop
InputALoop:  
    add $t0, $t0, 1
    beq $t0, 16, IALExit
    li $v0, 5
    syscall
    move $t1, $v0 
    mul $t2, $t0, 4
    la $a0, matrix_a
    add $a0, $a0, $t2
    sw $t1, 0($a0)
    j InputALoop

IALExit:
    jr $ra

# matrix_b input loop
InputBLoop:
    add $t0, $t0, 1
    beq $t0, 16, IBLExit
    li $v0, 5
    syscall
    move $t1, $v0 
    mul $t2, $t0, 4
    la $a0, matrix_b
    add $a0, $a0, $t2
    sw $t1, 0($a0)
    j InputBLoop  

IBLExit:
    jr $ra     

##############################################################################
matrix_multiply: 
##############################################################################
# mult matrices A and B together of square size N and store in result.

    # alloc stack and store regs
    sub $sp, $sp, 24
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    sw $s2, 20($sp)

    # setup for i loop
    li $t0, -1
    # setup for j loop
    li $t1, -1
    # setup for k loop
    li $t2, -1

    jal Loop1

    # retore saved regs from stack
    lw $s2, 20($sp)
    lw $s1, 16($sp)
    lw $s0, 12($sp)
    lw $a1, 8($sp)
    lw $a0, 4($sp)
    lw $ra, 0($sp)

    # free stack and return
    add $sp, $sp, 24
    jr $ra

# i loop
Loop1:
    addi $t0, $t0, 1
    beq $t0, 4, Exit
    li $t1, -1
    j Loop2

# j loop
Loop2:
    addi $t1, $t1, 1
    beq $t1, 4, Loop1
    li $t6, 0
    li $t2, -1
    j Loop3

# k loop
Loop3:
    addi $t2, $t2, 1
    beq $t2, 4, Loop2Store
    # compute A[i][k] address and load into $t3
    mul $t5, $t0, 4
    add $t5, $t5, $t2
    mul $t5, $t5, 4
    la $t7, matrix_a
    add $t7, $t7, $t5
    lw $t3, 0($t7)
    # compute B[k][j] address and load into $t4
    mul $t5, $t2, 4
    add $t5, $t5, $t1
    mul $t5, $t5, 4
    la $t7, matrix_b
    add $t7, $t7, $t5
    lw $t4, 0($t7)
    # invoke mul instruction
    mul $t5, $t3, $t4
    # add to sum
    add $t6, $t6, $t5
    j Loop3

# store sum in result
Loop2Store:
    la $t7, result
    mul $t5, $t0, 4
    add $t5, $t5, $t1
    mul $t5, $t5, 4
    add $t7, $t7, $t5
    sw $t6, 0($t7)
    j Loop2    

Exit:
    jr $ra



##############################################################################
matrix_print:
##############################################################################

    # alloc stack and store regs.
    sub $sp, $sp, 16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $a0, 12($sp)

    li $t0, 4 # size of array

    la $a0, product
    li $v0, 4
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    # do your two loops here
    
    li $t1, -1
    jal PrintLoop

    # setup to jump back and return

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $a0, 12($sp)
    add $sp, $sp, 16
    jr $ra

# i loop
PrintLoop:
    addi $t1, $t1, 1
    beq $t1, 4, PrintExit
    li $t2, -1
    j PrintLoop2
    
# j loop
PrintLoop2:  
    addi $t2, $t2, 1
    beq $t2, 4, PL2Exit
    # print value at result[i][j]
    mul $t3, $t1, 4
    add $t3, $t3, $t2
    mul $t3, $t3, 4
    la $t7, result
    add $t7, $t7, $t3
    lw $a0, 0($t7)
    li $v0, 1
    syscall
    # print tab
    la $a0, tab
    li $v0, 4
    syscall
    j PrintLoop2
    

PrintExit:
    jr $ra

# print newline
PL2Exit:
    la $a0, newline
    li $v0, 4
    syscall
    j PrintLoop



