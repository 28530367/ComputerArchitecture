#include <stdio.h>

static inline short clz(int* nums, int numsStart) {
    int count = 0;
    for (int i = numsStart - 1; i >= 0; --i) {
        if (nums[i] != 0)
            break;
        count++;
    }
    return count;
}

long long zeroFilledSubarray(int* nums, int numsSize) {
    long long result = 0;
    short zero_count = 0;

    while (numsSize > 0) {
        zero_count = clz(nums, numsSize);
        result += (zero_count + 1) * zero_count / 2;
        numsSize -= zero_count+1;
    }
    
    return result;
}

int main() {

    // Example 1
    int nums1[] = {1, 3, 0, 0, 2, 0, 0, 4};  
    int numsSize1 = sizeof(nums1) / sizeof(nums1[0]);

    long long result1 = zeroFilledSubarray(nums1, numsSize1);

    printf("Example 1 - The number of subarrays filled with 0: %lld\n", result1);

    // Example 2
    int nums2[] = {0, 0, 0, 2, 0, 0};  
    int numsSize2 = sizeof(nums2) / sizeof(nums2[0]);

    long long result2 = zeroFilledSubarray(nums2, numsSize2);

    printf("Example 2 - The number of subarrays filled with 0: %lld\n", result2);

    // Example 3
    int nums3[] = {2, 10, 2019};  
    int numsSize3 = sizeof(nums3) / sizeof(nums3[0]);

    long long result3 = zeroFilledSubarray(nums3, numsSize3);

    printf("Example 3 - The number of subarrays filled with 0: %lld\n", result3);

    return 0;
}