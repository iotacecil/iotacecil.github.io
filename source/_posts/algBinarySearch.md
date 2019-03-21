---
title: 基础二分查找例题
date: 2018-10-11 21:26:30
tags:
categories: [算法备忘]
---

### 二分C
```java
while(lo < hi){
    int mid = (lo + hi) >> 1;
    (e < A[mid]) ? hi = mid :lo = mid + 1;
}
return --lo;
```
好处:虽然不能命中及时返回，但是最坏情况变好。每一步迭代之需要比较1次
有效区间宽度缩小到0才终止。
正确性：A[0,lo)中元素<=e,A[hi,n)中元素都>e

### 658 K个最接近的元素
从数组中找到最靠近 x（两数之差最小）的 k 个数
结果按升序.
如果有两个数与 x 的差值一样，优先选择数值较小的那个数。

>输入: [1,2,3,4,5], k=4, x=-1
输出: [1,2,3,4]



### 378 矩阵从左到右从上到下有序，找第k小的元素(唯品B 考到)

2.二分：

1.26%全部放进k大的PriorityQueue,最后poll掉k-1个，return peek 28%
```java
public int kthSmallest(int[][] matrix, int k) {
  PriorityQueue<Integer> que = new PriorityQueue(k);
     for(int[] row:matrix){
         for(int x :row){
             que.add(x);
         }
     }
     for(int i = 0;i<k-1;i++){
         que.poll();
     }
     return que.peek();
}
```

3.sort59% 14ms
```java
public int kthSmallest(int[][] matrix, int k) {
    int n = matrix.length;
    int[] a = new int[n*n];
    int i = 0;
    for(int[] row :matrix){
        for(int x:row){
            a[i++] = x;
        }
    }
    Arrays.sort(a);
    return a[k-1];
}
```


### lt 848 数组插数 加油站之间的最小距离
加油站位置中间插入k个之后最小的最大间距是多少。
> stations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], K = 9
返回: 0.500000

如果每次都对最大的间隔二分，切三到会导致10->5,2.5,2.5，不如10/3

思路：找到间距mid，在k步之内可以让所有间距<=mid

```java
public double minmaxGasDist(int[] stations, int k) {
    double left = 0,right = 1e8;
    while (right - left > 1e-6){
        double mid = left + (right - left)/2;
        if(helper(stations, k, mid)){
            right = mid;
        }else{
            left = mid;
        }
    }
    return right;
}

private boolean helper(int[] stations, int k,double mid){
    int cnt = 0, n = stations.length;
    for (int i = 0; i < n-1; i++) {
        // 关键 如果这个是最小间距 ，这个间距需要切几刀
        cnt += (stations[i + 1] - stations[i]) / mid;
    }
    return cnt <= k;
}
```

### 分田地 把田地分为16分，怎样分使16份中最小的一块田地最大
https://www.nowcoder.com/questionTerminal/fe30a13b5fb84b339cb6cb3f70dca699
>4 4
3332
3233
3332
2323
out: 2

暴力判断能不能切4刀 n^4 找最大的k，使切成16块>=k


### 410 分割数组使Max(Sum(subarr))最小
>Input:
nums = [7,2,5,10,8]
m = 2
Output:
18  [7,2,5] and [10,8],

复杂度： mn^2 有mn个子问题 每个子问题找最佳k

`dp[i][j]` 长度为j的数组划分成i组的最大值
1.`dp[1][j]= sum(0,j)`
2.找分割点k，k左边划成i-1组的解和右边划分为1组 取max，在所有分割点k中取最小值 
`dp[i][j] = min(max(dp[i-1][k],sum(k+1,j))`
递归：76ms 6%



二分：复杂度(log(sum(nums))*n) 空间O(1) ok //todo next
lower bound 数组中的最大元素max(nums)
up bound 分成1组 sum(nums)
```java
public int splitArray(int[] nums, int m) {
    int max = 0;long sum = 0;
    for(int num:nums){
        max = Math.max(num,max );
        sum+=num;
    }
    if(m==1)return (int)sum;
    long l = max,r = sum;
    while (l<=r){
        long mid = (l+r)/2;
        //用这个最小值能不能划分成m组 可以更小一点
        if(valid(mid,nums ,m )){
            r = mid-1;
        }
        else{
            l = mid+1;
        }
    }
return (int)l;
}
private boolean valid(long target,int[] nums,int m){
    int cnt =1;
    long total = 0;
    for(int num:nums){
        total += num;
        if(total>target){
            total = num;
            //需要一个新的分组
            cnt++;
            if(cnt> m)return false;
        }
    }
    return true;
}
```

三步翻转法：

### 151 反转英语句子的单词顺序，不翻转单词


### lt 30 恢复 rotated array

### 189 rotate array

### !!!4 两个排序数组的中位数
>nums1 = [1, 2]
nums2 = [3, 4]
中位数是 (2 + 3)/2 = 2.5

考虑找第k大
1.merge k个数就得到第k大O(k)
2.比较两个数组的k/2
如果`A[k/2]<B[k/2]`则`A[0..k/2]<B[k/2]` 

### 88合并排序数组

### !!!33 rotate Sort Array 中查找！！ 没重复元素
方法1 分成4种情况 左半上升 的左右 右半上升的左右 15%
方法2 先找到最小值再在左or右二分
如果有重复只能O(n)

### 81 有重复的rotated sorted array


### !!! lc162 find peak `nums[i] ≠ nums[i+1]`
如果相邻元素可能相同则不能用二分 只能for循环一下
如果mid比左边大，则比mid大的peak肯定在右边
```java
public int findPeakElement(int[] nums) {
    int l = 0, r = nums.length - 1;
    while (l < r) {
        int mid = (l + r) / 2;
        if (nums[mid] > nums[mid + 1])
            r = mid;
        else
            l = mid + 1;
    }
    return l;
}
```

用`s+1<e` 就退出[0,1] s=0,e=1 数组中只有2个时候也退出最后要加一步两个数是哪个
好处是：有些二分的题目s和e不能为mid +1或者 -1

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



### 153 Roataed Sorted Array的最小值 二分logN
右边的肯定比左边的大，最右肯定比左半小，e不断向左移
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

### 278 第一个错误的版本
> n 个版本 [1, 2, ..., n]，你想找出导致之后所有版本出错的第一个错误的版本。
> 可以调用 bool isBadVersion(version) 接口来判断版本号 version 是否在单元测试中出错

```java
public int firstBadVersion(int n) {
    int l = 1,h = n;
    while(l < h){
        int mid = l+(h-l)/2;
        if(isBadVersion(mid)){
            h = mid;
        }else{
            l = mid +1;
        }
    }
    return h;
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




