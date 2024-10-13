    .data
    # Define three arbitrary 32-bit test values
test_value1: .word 0x00F0F0F0  # Example value 1
test_value2: .word 0x00000001  # Example value 2
test_value3: .word 0x80000000  # Example value 3

    .text
    .globl main

main:
    # Load the first test value and call my_clz
    la t0, test_value1       # Load address of test_value1
    lw t0, 0(t0)             # Load the value into t0
    call my_clz              # Call the my_clz function
    mv t3, a0                # Move the result to t3 for later use

    # Print the result
    mv a0, a0                # The result is already in a0
    li a7, 1                 # Syscall code for print integer
    ecall
    # Print newline
    li a0, 10                # ASCII code for newline '\n'
    li a7, 11                # Syscall code for print character
    ecall

    # Load the second test value and call my_clz
    la t0, test_value2       # Load address of test_value2
    lw t0, 0(t0)             # Load the value into t0
    call my_clz              # Call the my_clz function
    mv t4, a0                # Move the result to t4 for later use

    # Print the result
    mv a0, a0                # The result is already in a0
    li a7, 1                 # Syscall code for print integer
    ecall
    # Print newline
    li a0, 10                # ASCII code for newline '\n'
    li a7, 11                # Syscall code for print character
    ecall

    # Load the third test value and call my_clz
    la t0, test_value3       # Load address of test_value3
    lw t0, 0(t0)             # Load the value into t0
    call my_clz              # Call the my_clz function
    mv t5, a0                # Move the result to t5 for later use

    # Print the result
    mv a0, a0                # The result is already in a0
    li a7, 1                 # Syscall code for print integer
    ecall
    # Print newline
    li a0, 10                # ASCII code for newline '\n'
    li a7, 11                # Syscall code for print character
    ecall

    # Exit the program
    li a7, 10                # Syscall code for program exit
    ecall

# Function: my_clz
my_clz:
    li t1, 0          # Initialize count to 0
    li t2, 31         # Start checking from bit position 31

clz_loop:
    blt t2, zero, clz_end   # If t2 < 0, exit the loop (all bits checked)

    li t3, 1                # Load 1 into t3
    sll t3, t3, t2          # Compute (1 << t2), store in t3
    and t4, t0, t3          # Perform bitwise AND with x and (1 << t2)
    bne t4, zero, clz_end   # If the result is non-zero, break the loop

    addi t1, t1, 1          # Increment count
    addi t2, t2, -1         # Decrement t2 to move to the next bit
    j clz_loop              # Repeat the loop

clz_end:
    mv a0, t1               # Move the count result to a0
    ret