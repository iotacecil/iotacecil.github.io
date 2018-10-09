---
title: algTool
date: 2018-10-09 19:16:41
tags: 
categories: [算法备忘]
---
### 最大公约数gcd
```java
public static long gcd(long a, long b) {
    return (b == 0) ? a : gcd(b, a % b);
}
```

### 素数
```java
```
### 正确二分查找的写法
1.查找范围是 [0,len-1]
[0]：l=0,r=1-1，while(l==r)的时候应该继续
```java
int l = 0,r=n-1;
while(l<=r){
    int mid = l+(r-l)/2;
    if(arr[mid]==target){
        return mid;
    }
    else if(arr[mid]<target){
        l=mid+1;//
    }
    else{
        r=mid-1;
    }
}
//如果l>r
return -1;
```
2.[0,len) 保持len取不到 
[0]:l=0,r=1,l++,while(l==r)的时候应该结束
好处：len就是长度[a,a+len)，[a,b)+[b,c)=[a,c),[a,a)是空的
```java
int l = 0,r = n;
while(l<r){
    int mid = l+(r-l)/2;
    if(arr[mid]==target)return mid;
    if(arr[mid]>target){
        //在左边，边界为取不到的数
        r=mid;//[l,mid)
    }else{
        //左闭又开
        l = mid+1;//[mid+1,r)
    }
}
//如果l==r [1,1)表示空的
return -1;
```

### lt 458 lastIndexOf
```java
public int lastPosition(int[] nums, int target) {
    if(nums==null||nums.length<1)return -1;
    int i = 0, j = nums.length-1;
    while(i<=j){
        int mid = (i+j)/2;
        if(nums[mid]>target)j = mid-1;
        //找到了继续向右找
        else i =mid+1;
    }
    if(j<0)return-1;
    if(nums[j]==target) return j; 
        return -1;
}
```

### 34 ？？？？？？二分查找数字的first+last idx
> Input: nums = [5,7,7,8,8,10], target = 8
> Output: [3,4]
> Input: nums = [5,7,7,8,8,10], target = 6
Output: [-1,-1]

二分查找获取最左/右边相等的

```java
public int[] searchRange(int[] a, int k) {
    if(a==null||a.length<1)return new int[]{-1,-1};
    int first = lowerBound(a, k);
    if(first==a.length||a[first]!=k)return new int[]{-1,-1};
    int last = upper_bound(a, k);
    last = last==-1||a[last]!=k?-1:last;
    return new int[]{first,last};
}
```

### lower_bound
二分搜索
lowerBound 
```java
/*
    满足ai>=k条件的最小i
* nums[index] >= target, min(index)
*/
public static int lowerBound(int[] nums, int target) {
    if (nums == null || nums.length == 0) return -1;
    int lb = -1, ub = nums.length;
    while (lb + 1 < ub) {
        int mid = lb + (ub - lb) / 2;
        if (nums[mid] >= target) {
            ub = mid;
        } else {
            lb = mid;
        }
    }
    return ub;
}
```

upper_bound
ai<=k 的最大i
```java
public static int upper_bound(int[] a,int k){
    if (a == null || a.length == 0) return -1;
    int lb = -1,ub = a.length;
    while (ub - lb > 1) {
        int mid = (lb+ub)/2;
        if(a[mid]<=k){
            lb = mid;
        }else
            ub = mid;
    }
    return lb;
}
```

