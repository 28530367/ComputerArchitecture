.data
nums1: .word 1, 3, 0, 0, 2, 0, 0, 4
numsSize1: .word 8
nums2: .word 0, 0, 0, 2 ,0 ,0
numsSize2: .word 6
nums3: .word 2, 10, 2019
numsSize3: .word 3

    .text
    .globl main

main:
    # Initialize pointers for nums1 array
    la t0, nums1      # Load the address of nums1 into t0
    lw t1, numsSize1   

    call zeroFilledSubarray

    # Print result
    mv a0, a2        # Move result to a1 for printing
    li a7, 1          # Print integer syscall
    ecall
    # Print newline
    li a0, 10        # ASCII code for newline '\n'
    li a7, 11        # Syscall code for print character
    ecall
    
    # Initialize pointers for nums1 array
    la t0, nums2      # Load the address of nums2 into t0
    lw t1, numsSize2   

    call zeroFilledSubarray

    # Print result
    mv a0, a2        # Move result to a1 for printing
    li a7, 1          # Print integer syscall
    ecall
    # Print newline
    li a0, 10        # ASCII code for newline '\n'
    li a7, 11        # Syscall code for print character
    ecall
    
    # Initialize pointers for nums1 array
    la t0, nums3      # Load the address of nums3 into t0
    lw t1, numsSize3 

    call zeroFilledSubarray

    # Print result
    mv a0, a2        # Move result to a1 for printing
    li a7, 1          # Print integer syscall
    ecall
    # Print newline
    li a0, 10        # ASCII code for newline '\n'
    li a7, 11        # Syscall code for print character
    ecall
    
    # Exit
    li a7, 10         # Exit syscall
    ecall

zeroFilledSubarray:
    # Arguments:
    # t0: nums (pointer to array)
    # t1: numsSize (size of array)

    addi sp, sp, -12  # Allocate stack space for 3 registers
    sw ra, 8(sp)      # Save return address
    sw s1, 4(sp)      # Save s1 (zero_count)
    sw s2, 0(sp)      # Save s2 (result)

    # Initialize result and zero_count
    li s2, 0          # result = 0
    li s1, 0          # zero_count = 0

loop:
    beqz t1, end      # If numsSize == 0, exit loop

    # Call clz function
    call clz

    # Update result
    mv s1, a1         # Move clz result to s1 (zero_count)
    addi t2, s1, 1    # t2 = zero_count + 1
    mul t2, t2, s1    # t2 = (zero_count + 1) * zero_count
    srai t2, t2, 1    # t2 = t2 / 2
    add s2, s2, t2    # result += t2

    # Update nums pointer and numsSize
    addi t0, t0, 4
    beqz t1, loop     # If numsSize == 0, numsSize don't have to -1
    addi t1, t1, -1   # numsSize -= 1 (for the non-zero element)
    j loop            # Repeat loop

end:
    # Load count to return
    mv a2, s2         # Move count to a0

    # Restore registers and return
    lw ra, 8(sp)      # Restore return address
    lw s1, 4(sp)      # Restore s1
    lw s2, 0(sp)      # Restore s2
    addi sp, sp, 12   # Deallocate stack space
    ret

clz:
    # Arguments:
    # t0: nums (pointer to array)
    # t1: numsStart (start index in array)

    addi sp, sp, -8   # Allocate stack space for 2 registers
    sw ra, 4(sp)      # Save return address
    sw s0, 0(sp)      # Save s0 (count)

    # Initialize count to 0
    li s0, 0          # count = 0

    # Loop from numsStart - 1 to 0
loop_clz:
    beqz t1, end_clz  # If a1 == 0, exit loop

    # Load value from nums
    lb a0, 0(t0)      # Load byte from nums

    bnez a0, end_clz  # If nums[i] != 0, exit loop
    addi s0, s0, 1    # Increment count
    addi t0, t0, 4
    addi t1, t1, -1
    j loop_clz        # Repeat loop

end_clz:
    # Load count to return
    mv a1, s0         # Move count to a0

    # Restore registers and return
    lw ra, 4(sp)      # Restore return address
    lw s0, 0(sp)      # Restore s0
    addi sp, sp, 8    # Deallocate stack space
    ret