---
title: 前缀和 滑动窗口 子数组问题
date: 2018-10-28 11:17:19
tags: [alg]
categories: [算法备忘]
---
### 930 01数组中有多少个和=target的子数组
> 输入：A = [1,0,1,0,1], S = 2
输出：4

> 输入：A = [0,0,0,0,0], S = 0
> 输出：15  5+4+3+2+1

思路： 计算前缀和`[1,1,2,2,3]`并放入map计数,`{1:2,2:2,3:1}`
步骤[0,0,0,0,0] 初始化map`{0:1}`,扫描到第一个0,查找map中S-0=0有几个，cnt=1,更新`map{0:2}` ,扫描到第二个0，cnt=1+2...最后一个0，cnt+1+2+3+4+5 = 15
```java
public int numSubarraysWithSum(int[] A, int S) {
    Map<Integer, Integer> c = new HashMap<>();
    c.put(0, 1);
    int psum = 0, res = 0;
    for (int i : A) {
        psum += i;
        // 查找前缀
        res += c.getOrDefault(psum - S, 0);
        // 当前前缀计数
        c.put(psum, c.getOrDefault(psum, 0)+1);
    }
    return res;
}
```

### 560 数组中有多少个和为k的子数组
>输入:nums = [1,1,1], k = 2
输出: 2 , [1,1] 与 [1,1] 为两种不同的情况。

同930 一模一样,查找可以组成k的前缀，计数前缀
69%
{% fold %}
```java
public int subarraySum(int[] nums, int k) {
    int psum = 0;
    Map<Integer,Integer> map = new HashMap<>();
    map.put(0,1);
    int cnt =0;
    for(int i =0;i<nums.length;i++){
        psum += nums[i];
        cnt += map.getOrDefault(psum - k,0);
        map.put(psum,map.getOrDefault(psum,0)+1);
    }
    return cnt;
}
```
{% endfold %}

### 713 乘积`<k`的子数组的个数
输入[1,2,3,4] k = 10
当s = 0,e = 0 窗口只有[1]
窗口乘积p = 1 ，子数组个数 1 :[1]

s = 0,e = 1 窗口[1,2]
p = 2 子数组个数3: `[[1],   [2],[1,2]]` (+2)

s = 0,e = 2 窗口[1,2,3]
p = 6 子数组个数3: `[[1],[2][1,2],  [3],[2,3],[1,2,3]]` (+3)

每次子数组的增长个数就是窗口大小
如果 p >k 则s向右
s = 1,e = 3 窗口[2,3,4]
p = 24
s = 2,e = 3窗口[3,4] 
p = 12 子数组个数`[[3],  [4][3,4]]]` (+2)

```java
public int numSubarrayProductLessThanK(int[] nums, int k) {
    int p = 1;
    int cnt =0;
    for(int s = 0, e = 0; e < nums.length;e++){
        p *= nums[e];
        while(p>=k && s<e){
            p /= nums[s++];
        }
        if(p < k){
            cnt += (e - s + 1);
        }  
    }
    return cnt;
}
```

### 152 最大子数组乘积 保留当前值之前的最大积和最小积
>输入: [-2,0,-1]
输出: 0
解释: 结果不能为 2, 因为 [-2,-1] 不是子数组。

负数的最小积有潜力变成最大积
4ms 11.99%
```java
public int maxProduct(int[] nums) {
    int sum = nums[0],min = nums[0],max = nums[0];
    for(int i=1;i<nums.length;i++){
        int nextmax = nums[i]*max;
        int nextmin = nums[i]*min;
        max = Math.max(Math.max(nextmax,nextmin),nums[i]);
        min = Math.min(Math.min(nextmax,nextmin),nums[i]);
        sum = Math.max(max,sum);
    }
    return sum;
}
```

### 



