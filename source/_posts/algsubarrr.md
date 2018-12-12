---
title: 数组划分 前缀和 滑动窗口 子数组、序列问题
date: 2018-10-28 11:17:19
tags: [alg]
categories: [算法备忘]
---
### lt 45 最大子数组差
>给出数组[1, 2, -3, 1]，返回 6
找出两个不重叠的子数组A和B，使两个子数组和的差的绝对值|SUM(A) - SUM(B)|最大


### 724 最小划分 数字分成2组 和的差最小
>给出nums = [1, 6, 11, 5]，返回1
// Subset1 = [1, 5, 6]，和是12
// Subset2 = [11]，和是11
// abs(11 - 12) = 1

### 813 数组A分成K个相邻的非空子数组，子数组平均和和最大多少
>输入: 
A = [9,1,2,3,9]
K = 3
输出: 20
解释: 
A 的最优分组是[9], [1, 2, 3], [9]. 得到的分数是 9 + (1 + 2 + 3) / 3 + 9 = 20.
我们也可以把 A 分成[9, 1], [2], [3, 9].
这样的分组得到的分数为 5 + 2 + 6 = 13, 但不是最大值.



### !!!698 将数组分成sum相等的k份 不用连续
>Input: nums = [4, 3, 2, 3, 5, 2, 1], k = 4
Output: True
Explanation: It's possible to divide it into 4 subsets (5), (1, 4), (2,3), (2,3) with equal sums.

//todo DP
https://leetcode.com/problems/partition-to-k-equal-sum-subsets/

1.计算出数组的sum看能不能整除k，同时得到了每组的subsum
2.如果数组中有一个元素>subsum则不可能。最大的几个==subsum，自己分成一组。
3.对前面都比subsum小的元素回溯将数字放入group数组。变成 Combination tum target
```java
public boolean canPartitionKSubsets(int[] nums, int k) {
    // 1. 求每组应该的平均值
    int sum = 0;
    for(int num : nums){
        sum += num;
    }
    if(sum % k != 0){
        return false;
    }
    int subsum = sum/k;
    // 2. 等于平均值的单独分成一组
    Arrays.sort(nums);
    int n = nums.length;
    int idx = n-1;
    if(nums[n-1] > subsum)return false;
    for(int i = n-1;i >= 0;i--){
        if(nums[i] < subsum)break;
        if(nums[i] == subsum){
            k--;
            idx--;
        }
    }
    // 3. 回溯分组
    int[] group = new int[k];
    return back(group,idx,subsum,nums);
}
private boolean back(int[] group,int idx,int target,int[] nums){
    // 全部都分组好了
    if(idx < 0){
        return true;
    }
         // 试着放到每一组
    for(int i = 0;i < group.length;i++){
        if(group[i] + nums[idx] > target){
            continue;
        }
        group[i] += nums[idx];
        if(back(group,idx-1,target,nums)){
            return true;
        }
        group[i] -= nums[idx];
        // 重要剪枝30%->100% 
        // 如果这个桶已经装过了，减到0了，用其他数字装这个桶的结果其实已经在别的桶实现过了
        // 一个桶肯定有一个数字，减到没有数字其他桶也没可能了，直接退出
        if (group[i] == 0) break;

    }
    return false;
}
```

### !!!152 最大子数组乘积 保留当前值之前的最大积和最小积
>输入: [-2,0,-1]
输出: 0
解释: 结果不能为 2, 因为 [-2,-1] 不是子数组。

维护前缀乘积的min/max，每次当前数组元素必须参与运算。
注意：更新min/max的时候考虑放弃前缀，只考虑本身，所以变成子数组。
注意：子数组所以min/max是前一个index的结果

负数的最小积有潜力变成最大积
当前max是 `nums[i]*max`,`nums[i]*min`,`nums[i]` 三者的最大者
当前min是 `nums[i]*max`,`nums[i]*min`,`nums[i]` 三者最小值
更新全局max
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

### 合唱团 背包(只能向前找k个物品)+数组最大子数组(差d的子数组)???乘积
> 从这 n 个学生中按照顺序选取 k 名学生，要求相邻两个学生的位置编号的差不超过 d，使得这 k 个学生的能力值的乘积最大
> 输入3
7 4 7
2 50
> 输出49

更新当前结尾最大子数组和 需要试min/max取前d个数之内(可以跳过前d-1个)的全部结果

```java
public static long maxability(int n,long[]arr,int k,int d){
    long[][] fmax = new long[k+1][n];
    long[][] fmin = new long[k+1][n];
    long res = Integer.MIN_VALUE;
    fmax[1] = arr.clone();
    fmin[1] = arr.clone();
      //选2-k个人
        for (int j = 2; j <=k ; j++) {
            for (int i = 0; i <n ; i++) {
            // 遍历上次层结果的[i-d,i)
            for (int l = i-1; l>=0&&l>=i-d ; l--) {
                // 前面以l结尾的最大和最小
                fmax[j][i] = Math.max(fmax[j][i],Math.max(fmax[j-1][l]*arr[i],fmin[j-1][l]*arr[i]) );
                fmin[j][i] = Math.min(fmin[j][i],Math.min(fmax[j-1][l]*arr[i],fmin[j-1][l]*arr[i]) );
            }
        }
    }
    for (int i = 0; i <n ; i++) {
        res = Math.max(res, fmax[k][i]);
    }
    return res;
    }
```




---

### 763 划分尽可能多字母区间  返回各区间的长度 双指针
>输入: S = "ababcbacadefegdehijhklij"
输出: [9,7,8]
解释:
划分结果为 "ababcbaca", "defegde", "hijhklij"。
每个字母最多出现在一个片段中。
像 "ababcbacadefegde", "hijhklij" 的划分是错误的，因为划分的片段数较少。
ababcba 从第一个a到最后一个a是必须包含的长度

思路：字母last index数组，遍历string，维护一个当前字符出现的最晚index，直到当前字符index就是这个最晚index，可以划分，记录当前长度并且重置start计数。
注意：不能直接i跳到curmaxend，因为abab如果a直接跳到下一个a会漏更新b的last index

```java
//45%
public List<Integer> partitionLabels(String S) {
    List<Integer> rst = new ArrayList<>();
    //每个字母最后出现的index
    int[] last = new int[26];

    for(int i=0;i<S.length();i++){
      last[S.charAt(i)-'a'] = i;
    }
    int start=0,end=0;
    for(int i = 0;i<S.length();i++){
        //更新当前字母的区间
        end = Math.max(end,last[S.charAt(i)-'a']);
        //关键
        if(i==end){
            rst.add(end-start+1);
            start = end+1;
        }
    }
    return rst;
}
```

### 769 !!!!!最多能排序的块 0-n的排列切割，块排序后连接是排序的原数组 
>输入: arr = [1,0,2,3,4]
输出: 4
解释:
我们可以把它分成两块，例如 [1, 0], [2, 3, 4]。
然而，分成 [1, 0], [2], [3], [4] 可以得到最多的块数。

注意条件：arr that is a permutation of `[0, 1, ..., arr.length - 1]`
思路1:当前的index==当前的最大值，左边一共有index-1个数字，比index小的都在左边了，可以切分。
```
idx:0 1 2 3 4
arr:1 0 2 3 4
max:0 1 2 3 4
当前index<当前max 表示可以划分成一组，==max表示要换下一组
```

```java
public int maxChunksToSorted(int[] arr) {
    int res = 0;
    for(int i =0,max = 0;i<arr.length;i++){
        if(i==(max=Math.max(max,arr[i])))
            res++;
    }
    return res;
}
```

思路2：维护一个leftmax和minright数组，当leftmax<=rightmin则可以划分

### 915 Max(left)<=Min(right)
画折线图，当前`A[i]<left` 则把切分线抬到`globalMax`
![lc915.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lc915.jpg)
7ms 60%
```java
public int partitionDisjoint(int[] A) {
    int n = A.length;
    int leftMax = A[0];
    int global = leftMax;
    int parti = 0;
    for(int i = 1;i<n;i++){
        if(leftMax>A[i]){
            leftMax = global;
            parti = i;
        }else global = Math.max(global,A[i]);
    }
    return parti+1;
}
```

### 768 最多能排序的块 重复元素
> 输入: arr = [2,1,3,4,4]
输出: 4
解释:
我们可以把它分成两块，例如 [2, 1], [3, 4, 4]。
然而，分成 [2, 1], [3], [4], [4] 可以得到最多的块数。 
arr的长度在[1, 2000]之间。
arr[i]的大小在[0, 10**8]之间。

最快的100%： 只构造后缀min数组,线性扫描更新max,保证`leftMax<Rmin`的划分

```java
public int maxChunksToSorted100(int[] arr) {
    int n = arr.length;
    int[] minOfRight = new int[n];
    minOfRight[n - 1] = arr[n - 1];
    for (int i = n - 2; i >= 0; i--) {
        minOfRight[i] = Math.min(minOfRight[i + 1], arr[i]);
    }
    int res = 0;
    int max = Integer.MIN_VALUE;
    for (int i = 0; i < n - 1; i++) {
        max = Math.max(max,arr[i]);
        // 等于 重复元素 去掉=就是第一题 68%
        if (max <= minOfRight[i + 1]) res++;
    }
    return res + 1;
}
```


56%：前缀max数组 后缀min数组
left`[2,1]` right`[3,4,4]`
`leftMax<rightMin`的时候
```
arr     [2, 1, 3, 4, 4]

比较切分位置0~n-1：[0:i][i+1:n-1]
leftMax    [2, !2, !3, !4, 4] 
rightMin[1, 1, !3, !4, !4]
```

```java
public int maxChunksToSorted(int[] arr) {
    int n = arr.length;
    int[] maxLeft = new int[n];
    int[] minRight = new int[n];
    maxLeft[0] = arr[0];
    for (int i = 1; i < n; i++) {
        maxLeft[i] = Math.max(maxLeft[i-1],arr[i]);
    }
    minRight[n-1] = arr[n-1];
    for (int i = n-2; i >= 0 ; i--) {
        minRight[i] = Math.min(minRight[i+1],arr[i]);
    }

    int res = 0;
    for (int i = 0; i < n-1; i++) {
        if(maxLeft[i] <= minRight[i+1]){
            res++;
        }
    }
    return res+1;
}
```

44%拷贝一个数组排序，做累加,相等则可以划分
`[2,1 |,3 |,4 |,4]`
`[1,2 |,3 |,4 |,4]`
```java
public int maxChunksToSorted(int[] arr) {
    int sum1 =0,sum2 =0,res = 0;
    int[] copy = arr.clone();
    for(int i =0;i<arr.length;i++){
        sum1 += copy[i];
        sum2 += arr[i];
        if(sum1 == sum2)ans++;
    }
    return ans;
}
```

### 581 需要排序的最小子串，整个串都被排序了 递增
![lc581.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lc581.jpg)
40大于35，只排序到右边遍历过来第一个`n<n-1`是不够的
要找到[30~31]中的min和max
```java
public static int fid(int[]A){
    //1,3,2,2,2
    int n = A.length, beg = -1, end = -2, min = A[n-1], max = A[0];
    for (int i=1;i<n;i++) {
        max = Math.max(max, A[i]);//从前往后，找到最大值max=3
        min = Math.min(min, A[n-1-i]);//从后往前找到最小值min=2
        if (A[i] < max) end = i; //a=2<3 end = 2->3->4 直到找到a[i]>max
        if (A[n-1-i] > min) beg = n-1-i;//begin =1 直到找到a[i]<min
    }
    return end - beg + 1;
    }
```

### 697 ？？保留数组中最高频出现数字频数的最短数组长度
> Input: [1,2,2,3,1,4,2]
> 最小连续子数组，使得子数组的度与原数组的度相同。返回子数组的长度
> Output: 6 最高频是2->【2,2,3,1,4,2】

用3个hashmap扫一遍记录每个数字出现的cnt,left,right
最后cnt最大的right-left+1
合并成一个`hashmap<Integer,int[3]>`

### ！！416 数组分成两部分（不连续) sum相等。list的总sum为奇数则不可能。
```java
public boolean canPartition(int[] nums){
    int sum = 0;
    for(int n : nums){
        sum+=n;
    }
    if(sum%2!=0)return false;
    int[] dp = new int[sum+1];
    dp[0] = 1;
    for(int n : nums){
        for(int v = sum;v>=0;v--){
            if(dp[v]==1)dp[v+n]=1;
        }
        if(dp[sum/2]==1)return true;
    }
    return false;
}
```


### !594 最长max min相差1的子序列(不是连续的数组)
数组 hashmap 计数模板



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



### 209最小连续子数组 和>=K 的长度
>Input: s = 7, nums = [2,3,1,2,4,3]
Output: 2
Explanation: the subarray [4,3] 

1 二分搜索
暴力法搜索前缀数组`sum[j]-sum[i]+nums[i]>=k`的最短ij
二分发寻找`sum[j] >= sum[i]-nums[i]+k` j的最小值





