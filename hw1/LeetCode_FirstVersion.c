#include <stdio.h>

long long zeroFilledSubarray(int* nums, int numsSize) {
    short count_tmp = 0;
    long long result = 0;

    for(int i = 0; i < numsSize; i++) {
        if (nums[i] == 0) {
            count_tmp += 1;
            result += count_tmp;
        } else{
            count_tmp = 0;
        }
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