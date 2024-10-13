    .data
    # Input half-precision floating-point numbers
input1: .half 0x3800  # 1st half-precision input
input2: .half 0x3C00  # 2nd half-precision input
input3: .half 0x7C00  # 3rd half-precision input

    # Storage for the converted single-precision floating-point results
result1: .word 0      # Storage for 1st conversion result
result2: .word 0      # Storage for 2nd conversion result
result3: .word 0      # Storage for 3rd conversion result

    .text
    .globl main

main:
    # Load the first input and call the conversion function
    lh t0, input1          # Load the first half-precision float from memory into t0
    call fp16_to_fp32      # Call the conversion function
    la t1, result1         # Load the address of result1
    sw a0, 0(t1)           # Store the conversion result into result1

    # Load the second input and call the conversion function
    lh t0, input2          # Load the second half-precision float into t0
    call fp16_to_fp32      # Call the conversion function
    la t1, result2         # Load the address of result2
    sw a0, 0(t1)           # Store the conversion result into result2

    # Load the third input and call the conversion function
    lh t0, input3          # Load the third half-precision float into t0
    call fp16_to_fp32      # Call the conversion function
    la t1, result3         # Load the address of result3
    sw a0, 0(t1)           # Store the conversion result into result3

    # Exit the program
    li a7, 10              # System call number 10 indicates program exit
    ecall

# Function section

# Convert half-precision float to single-precision float
fp16_to_fp32:
    # t0 contains the 16-bit half-precision floating-point number

    # Step 1: Extract the sign bit
    srai t1, t0, 15           # Right shift by 15 bits to get the sign bit
    andi t1, t1, 0x1          # Keep only the least significant bit (sign bit)
    slli t1, t1, 31           # Left shift by 31 bits to position the sign bit at the highest bit

    # Step 2: Extract the exponent bits
    srai t2, t0, 10           # Right shift by 10 bits to get the exponent bits
    andi t2, t2, 0x1F         # Keep only 5 bits of exponent

    # Step 3: Extract the mantissa bits
    andi t3, t0, 0x3FF        # Keep only 10 bits of mantissa

    # Step 4: Handle special cases
    beqz t2, fp16_zero_or_subnormal  # If exponent is zero, handle zero or subnormal numbers
    li t4, 0x1F
    beq t2, t4, fp16_infinite_or_nan # If exponent is all ones, handle infinity or NaN

    # Handle normalized numbers
    addi t2, t2, 112          # Adjust exponent bias: t2 = exponent + (127 - 15)
    slli t2, t2, 23           # Shift exponent to the correct position
    slli t3, t3, 13           # Shift mantissa to the correct position
    or t2, t2, t3             # Combine exponent and mantissa
    or a0, t1, t2             # Combine sign bit with the rest
    ret

fp16_zero_or_subnormal:
    # Handle zero or subnormal numbers
    beqz t3, fp16_zero        # If mantissa is zero, it's zero
    # Normalize subnormal numbers
    mv t5, t3                 # Copy mantissa to t5
    call my_clz_16            # Calculate the number of leading zeros in t5
    mv t4, a0                 # t4 = number of leading zeros

    # Adjust exponent
    li t6, 113                # t6 = 113 (127 - 15 + 1)
    sub t2, t6, t4            # t2 = 113 - number of leading zeros

    # Adjust mantissa
    addi a7, t4, 1            # t7 = number of leading zeros + 1
    sll t3, t3, a7            # Left shift mantissa to normalize

    # Shift mantissa to the correct position
    slli t3, t3, 12           # Left shift by 12 bits to position mantissa at [22:0]

    # Combine exponent and mantissa
    slli t2, t2, 23           # Shift exponent to bits [30:23]
    or t2, t2, t3             # Combine exponent and mantissa
    or a0, t1, t2             # Combine sign bit with the rest
    ret

fp16_infinite_or_nan:
    # Handle infinity or NaN
    li t2, 0xFF               # Set exponent bits to 0xFF
    slli t2, t2, 23           # Shift exponent to the correct position
    slli t3, t3, 13           # Shift mantissa to the correct position
    or t2, t2, t3             # Combine exponent and mantissa
    or a0, t1, t2             # Combine sign bit with the rest
    ret

fp16_zero:
    # Handle zero
    mv a0, t1                 # Result is just the sign bit (zero)
    ret

# Calculate the number of leading zeros in a 16-bit integer
my_clz_16:
    # t5 contains a 16-bit value
    # Return value is in a0

    li t1, 0          # Initialize counter
    li t2, 15         # Start from the highest bit

clz16_loop:
    bltz t2, clz16_end    # If t2 < 0, exit the loop

    srl t3, t5, t2        # Right shift t5 by t2 bits
    andi t3, t3, 1        

clz16_end:
    mv a0, t1 
    ret