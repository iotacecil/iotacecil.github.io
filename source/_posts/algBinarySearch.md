---
title: 基础二分查找例题
date: 2018-10-11 21:26:30
tags:
categories: [算法备忘]
---
### 4 两个排序数组的中位数
>nums1 = [1, 2]
nums2 = [3, 4]
中位数是 (2 + 3)/2 = 2.5

考虑找第k大
1.merge k个数就得到第k大O(k)
2.比较两个数组的k/2
如果`A[k/2]<B[k/2]`则`A[0..k/2]<B[k/2]` 

### 33 rotate Sort Array 中查找！！

### 81

### lc26有序数组去重 双指针
```java
public int removeDuplicates(int[] nums) {
    if(nums.length == 0)return 0;
    // 关键
    int cnt = 0;
    for(int i = 1;i<nums.length;i++){
        if(nums[i] != nums[cnt]){
            // 关键
            nums[++cnt] = nums[i];
        }
    }
    // 关键
    return cnt+1;
}
```

### 88合并排序数组

### lc162 find peak//todo
```java
public int findPeakElement(int[] nums) {
    int s = -1,e = nums.length-1;
    while(s+1<e){
        int mid = (s+e)/2;
        int left = nums[mid]-nums[mid+1];
        if(left>0){
            e = mid;
        }else s = mid;
    }
    return e;
}
```

### lc240 行列排序的2d矩阵二分查找 O(m+n)
从左下角或者右上角开始找
```java
public boolean searchMatrix(int[][] matrix, int target) {
    if(matrix == null || matrix.length < 1 || matrix[0].length <1) {
        return false;
    }
    int col = matrix[0].length-1;
    int row = 0;
    while(col >= 0 && row <= matrix.length-1) {
        if(target == matrix[row][col]) {
            return true;
            //左
        } else if(target < matrix[row][col]) {
            col--;
            //往下
        } else if(target > matrix[row][col]) {
            row++;
        }
    }
    return false;
}
```

### 153 Roataed Sorted Array的最小值 二分logN
```java
public int findMin(int[] nums) {
     int s = 0,e = nums.length-1;
    while(s + 1 < e){
        int mid = (e+s)/2;
        if(nums[mid] >= nums[e]){
            s = mid;
        }else{
            e = mid;
        }
    }
    //只剩下2个数之后 取个小的
    if(nums[s]<nums[e])return nums[s];
    else return nums[e];
}
```

```java
public int findMin(int[] nums) {
      if(nums.length==1)return nums[0];
    return findMin(nums,0,nums.length-1);
}
private int findMin(int[] nums,int low,int hi){
    //只有1个或者2个
    if(low+1>=hi)return Math.min(nums[low],nums[hi]);
    if(nums[low]<nums[hi])return nums[low];
    int mid = low+(hi-low)/2;
    //无缝
    return Math.min(findMin(nums,low,mid-1),findMin(nums,mid ,hi));
}
```
### 154 有重复元素Roataed Sorted Array 
> Input: [2,2,2,0,1]
> Output: 0

不能用二分了 不能Ologn 要O(N)
//比遍历都慢
```java
public int findMin(int[] nums) {
    int s = 0, e = nums.length-1;
    while (s+1<e){
        int mid = (s+e)/2;
        if(nums[mid]>nums[e]){
          s = mid;
        }else if(nums[mid]<nums[e]){
            e = mid;
            //关键
        }else e--;
       
    }
    return Math.min(nums[s],nums[e] );
}
```

去掉第二个递归条件。 跟遍历一个速度

