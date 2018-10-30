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
    int cnt = 1;
    for(int i = 1;i<nums.length;i++){
        if(nums[i] != nums[cnt-1]){
            nums[cnt++] = nums[i];
        }
    }
    return cnt;
}
```

### 80 数组每个元素只保留<=2次
cnt表示插入位置，i用于遍历 
```java
public int removeDuplicates(int[] nums) {
    if(nums.length < 2)return nums.length;
    int cnt = 2;
    for(int i =2;i<nums.length;i++){
        if(nums[cnt-2] != nums[i]){
            nums[cnt++] = nums[i];
        }
    }
    return cnt;
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

### 正确二分查找的写法 lc35
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

3.(-1,len] from jpbook
```java
public int searchInsert(int[] a, int k) {
    int l = -1,h = a.length;
    while (h-l>1){
        int mid = (l+h)/2;
        if(a[mid]>=k){
            h = mid;
        }else{
            l = mid;
        }
    }
    //l+1=h
    return h;
}
```

#### poj1064 n条线段切割成等长k段 的最大长度
> in: 4 11 8.02 7.43 4.57 5.39
> out:2.00 (4+3+2+2=11)

{% fold %}
```java
/**
 * 长度为L的绳子 最多可以切 floor(L/x)段
 * @param x
 * @return
 */
public static boolean C(double x){
    int num = 0;
    for (int i = 0; i <n ; i++) {
        num+=(int)(lines[i]/x);
    }
    return num>=k;
}
public static double howlong(double[] lines,int k){
    //All cables are at least 1 meter and at most 100 kilometers in length.
    double l = 0,h = 100001;
    // while ((h-l)>1e-6){
     //可以达到10^-30的精度
    for (int i = 0; i <100 ; i++) {
        double mid = (l+h)/2;
        if(C(mid))l = mid;
        else h = mid;
    }
    return Math.floor(h*100)/100;
}
```
{% endfold %}

#### poj2456 最大化最小值 最大化最近两头牛的距离
> in:5 3 [1,2,8,4,9]
> out: 3 在1，4，9 分别放入这三头牛

```java
private static boolean C(int d){
    int last = 0;
    for (int i = 1; i <m ; i++) {
        int crt = last + 1;
        //找到间隔>d的房间
        while (crt < n && room[crt] - room[last] < d) {
            crt++;
        }
        if (crt == n) return false;
        last = crt;
    }
    return true;
}
public static int maxmin(int[] room,int m){
    Arrays.sort(room);
    // positions x1,...,xN (0 <= xi <= 1,000,000,000).
    int l = 0,h = 1000000+1;
  while (h-l>1){
      int mid = (h+l)/2;
      if(C(mid))l = mid;
      else h = mid;
  }
  //为什么这里是low
  return l;
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

