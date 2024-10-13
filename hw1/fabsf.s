.data
    # Define three arbitrary 32-bit floating-point test values
test_value1: .word 0xBF800000  # -1.0 in IEEE 754 floating-point format
test_value2: .word 0x3F800000  # 1.0 in IEEE 754 floating-point format
test_value3: .word 0xC1200000  # -10.0 in IEEE 754 floating-point format

    # Storage for the absolute values
result1:    .word 0            # Storage for fabsf(test_value1)
result2:    .word 0            # Storage for fabsf(test_value2)
result3:    .word 0            # Storage for fabsf(test_value3)

    .text
    .globl main

main:
    # Load the first test value and call fabsf
    la t0, test_value1       # Load address of test_value1
    lw t0, 0(t0)             # Load the value into t0
    jal ra, fabsf            # Call the fabsf function
    # Store the result
    la t1, result1           # Load address of result1
    sw t0, 0(t1)             # Store the result

    # Print the result
    mv a0, t0                # Move the result into a0
    li a7, 2                 # Syscall code for print float
    ecall
    # Print newline
    li a0, 10                # ASCII code for newline '\n'
    li a7, 11                # Syscall code for print character
    ecall

    # Load the second test value and call fabsf
    la t0, test_value2       # Load address of test_value2
    lw t0, 0(t0)             # Load the value into t0
    jal ra, fabsf            # Call the fabsf function
    # Store the result
    la t1, result2           # Load address of result2
    sw t0, 0(t1)             # Store the result

    # Print the result
    mv a0, t0                # Move the result into a0
    li a7, 2                 # Syscall code for print float
    ecall
    # Print newline
    li a0, 10                # ASCII code for newline '\n'
    li a7, 11                # Syscall code for print character
    ecall

    # Load the third test value and call fabsf
    la t0, test_value3       # Load address of test_value3
    lw t0, 0(t0)             # Load the value into t0
    jal ra, fabsf            # Call the fabsf function
    # Store the result
    la t1, result3           # Load address of result3
    sw t0, 0(t1)             # Store the result

    # Print the result
    mv a0, t0                # Move the result into a0
    li a7, 2                 # Syscall code for print float
    ecall
    # Print newline
    li a0, 10                # ASCII code for newline '\n'
    li a7, 11                # Syscall code for print character
    ecall

    # Exit the program
    li a7, 10                # Syscall code for program exit
    ecall

# Function: fabsf
fabsf:
    # Remove the sign bit by masking with 0x7FFFFFFF
    li t1, 0x7FFFFFFF        # Load mask value 0x7FFFFFFF into t1
    and t0, t0, t1           # t0 = t0 & t1 (clear the sign bit)
    ret