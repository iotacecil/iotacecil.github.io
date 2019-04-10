---
title: algArr
date: 2019-03-04 19:38:25
tags: [alg]
categories: [算法备忘]
---


### lt912 最佳见面地点 meeting point
{% note %}
现在有三人分别居住在(0,0), (0,4), 和 (2,2)
```
1 - 0 - 0 - 0 - 1
|   |   |   |   |
0 - 0 - 0 - 0 - 0
|   |   |   |   |
0 - 0 - 1 - 0 - 0
```
点(0, 2)是最佳见面地点，最小的路程总和为2+2+2=6，返回6。
{% endnote %}

思路：只要见面地点在A,B中间，到A,B的花费都是 AB长度。
把横/纵坐标排序，每次取最大最小的两个，差就是AB。

```java
public int minTotalDistance(int[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    List<Integer> cols = new ArrayList<>();
    List<Integer> rows = new ArrayList<>();
    for(int i =0;i<n;i++){
        for(int j = 0;j<m;j++){
            if(grid[i][j] == 1){
                cols.add(j);
                rows.add(i);
            }
        }
    }
    cols.sort(Integer::compareTo);
    rows.sort(Integer::compareTo);
    int sum = 0;
    int l = 0;

    for(int i =0;i<cols.size()/2;i++){
        sum += cols.get(cols.size()-1 - i)-cols.get(i);
    }
    for(int i =0;i<rows.size()/2;i++){
        sum += rows.get(rows.size()-1 - i)-rows.get(i);
    }
    return sum;
}
```

### 462 选一个数字 +1 / -1 元素相等的最小步数
{% note %}
Input:
[1,2,3]

Output:
2
{% endnote %}

```java
public int minMoves2(int[] nums) {
    Arrays.sort(nums);
    int i = 0, j = nums.length-1;
    int count = 0;
    while(i < j){
        count += nums[j]-nums[i];
        i++;
        j--;
    }
    return count;
}
```

### 719 数组中两两匹配，第k小的两数之差
{% note %}
nums = [1,3,1]
k = 1
输出：0 
解释：
所有数对如下：
(1,3) -> 2
(1,1) -> 0
(3,1) -> 2
因此第 1 个最小距离的数对是 (1,1)，它们之间的距离为 0。
{% endnote %}

### 532 数组中有几个相差k的pair
{% note %}
输入: [3, 1, 4, 1, 5], k = 2
输出: 2
解释: 数组中有两个 2-diff 数对, (1, 3) 和 (3, 5)。
尽管数组中有两个1，但我们只应返回不同的数对的数量。
{% endnote %}

set的解法33% //todo比双指针慢

### 220 数组中是否有相差<=t,idx差<=k 的元素
>Input: nums = [1,2,3,1], k = 3, t = 0
Output: true

2.桶

1.40% 用容量k的TreeSet,超过k删除最左
判断能否和ceiling合floor<=t
如果不能 放入treeset等待

### 219 是否有重复元素 下标相差<=k
{% note %}
Input: nums = [1,2,3,1], k = 3
Output: true
{% endnote %}
放进一个FIFO大小为(k+1) 相差k 的set，当有add失败的时候就true

### 数对
x和y均不大于n, 并且x除以y的余数大于等于k，一共有多少对(x,y)
{% note %}
输入：5 2
输出：7
满足条件的数对有(2,3),(2,4),(2,5),(3,4),(3,5),(4,5),(5,3)
{% endnote %}
思路：
如果 y > x 能产生的余数是1-(y-1), 所以y>k，并且产生的余数>=k的有(y-k)个
对于一个y，n个数字产生的完整余数区间有n/y个
y = 3 -> +2 (2,3)(5,3) 1-5的余数 1 2 0| 1 2
y = 4 -> +2 (2,4)(3,4) 1-5的余数 1 2 3 0 | 1
y = 5 -> +3 (2,5)(3,5)(4,5) 1-5的余数 1 2 3 4 | 0
对于最后一个区间不满y个数，最后一个区间>=k的个数是n%y+1-k ,例如5%3->2最后一个循环有2个符合的

特殊情况如果k=0 xy可以相等n*n个
```java
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    long n = sc.nextLong();
    int k = sc.nextInt();
    if(k == 0)System.out.println(n*n);
    else {
        long cnt = 0;
        for (int y = k + 1; y <= n; y++) {
            cnt += (n / y) * (y - k);
            if (n % y >= k) {
                cnt += (n % y) + 1 - k;
            }
        }
        System.out.println(cnt);
    }
}
```
 

### 215 Kth Largest Element in an Array
{% note %}
Input: [3,2,1,5,6,4] and k = 2
Output: 5
{% endnote %}

用快排用头中尾的中位数最快。
找第k个最大，就是找下标为k = len-k = 4的数字

```java
public  int findKthLargest(int[] nums,int k){
     k = nums.length-k;
     int l = 0;
     int r = nums.length-1;
     while(l<r){
         int idx = part(nums,l,r);
         if(idx<k)l=idx+1;
         else if(idx>k) r = idx-1;
         else break;
     }
     return nums[k];
}
// 闭区间[l,r],r作为pivot
private int part(int[] nums,int l,int r){
    int i = l-1;
    int j = r;
    while(true){
        while(++i<j&&nums[i]<nums[r]);
        while(--j>i&&nums[r]<nums[j]);
        if(i>=j)break;
        swap(nums,i,j);
    }
    swap(nums,r,i);
    return i;
}
```

### 376. Wiggle Subsequence 最长摇摆序列
{% note %}
Input: [1,17,5,10,13,15,10,5,16,8]
Output: 7
One is [1,17,10,13,10,16,8].
第一个差能正能负，差正负交替的最长子序列。
{% endnote %}

贪心：
```java
public int wiggleMaxLength(int[] nums) {
 if (nums == null) return 0;
    if (nums.length <= 1) return nums.length;
    int f = 1, b = 1; 
    for (int i = 1; i < nums.length; i++) {
        if (nums[i] > nums[i-1]) f = b + 1;
        else if (nums[i] < nums[i-1]) b = f + 1;
    }
    return Math.max(f, b);
}
```

正确做法：动态规划只要记住-1位置上的最大值就好了
```java
public int wiggleMaxLength(int[] nums) {
  if(nums == null)return 0;
  int n = nums.length;
  if(n < 2)return n;
  int predif = 0;
  int cnt = 1;
  for(int i =1;i<n;i++){
      int dif = nums[i] - nums[i-1];
      if(dif >0 && predif <=0 || 
        dif <0 && predif >=0){
          cnt++;
          predif = dif;
      }
  }
    return cnt;   
}
```


### ！974 和整除k的子数组个数
{% note %}
Input: A = [4,5,0,-2,-3,1], K = 5
Output: 7
Explanation: There are 7 subarrays with a sum divisible by K = 5:
`[4, 5, 0, -2, -3, 1], [5], [5, 0], [5, 0, -2, -3], [0], [0, -2, -3], [-2, -3]`
{% endnote %}

1)用前缀和可以快速得到区间和
`P = [0,4,9,9,7,4,5]`,
2）如果`(sums[i] - sums[j]) % K == 0`，说明sums[i]和sums[j]都是K的倍数，所以得出sums[i] % K == sums[j] % K
例如：%K ==0的位置 [0]和[6] 得到子数组`[4, 5, 0, -2, -3, 1]`
同余的如果有4个，两两组合的位置数有C(4,2)=6

注意：presum为负数的时候，取模应该`(p % K + K) % K`
-1 % 5 = -1, but we need the positive mod 4
例如presum[1] = -1  presum[4] = 4
```java
public int subarraysDivByK(int[] A, int K) {
    int n = A.length;
    int rst = 0;
    int[] presum = new int[n+1];
    //[1]-[0] = pre[0:1)
    for(int i =0;i<n;i++){
        presum[i+1] = presum[i]+A[i];
    }
    int[] mod = new int[K];
    for(int p:presum){
        mod[((p%K)+K)%K]++;
    }
    for(int c:mod){
        rst += (c*(c-1))/2;
    }
    return rst;
}
```

### 209最小连续子数组 和>=K 的长度
{% note %}
Input: s = 7, nums = [2,3,1,2,4,3]
Output: 2
Explanation: the subarray [4,3] 
{% endnote %}

```java
public int minSubArrayLen(int s, int[] nums) {
    int n = nums.length;
    int e = 0;
    int st = 0;
    int minl = n+1;
    int sum = 0;
    while(e < n){
        sum += nums[e++];
        while (st<=e&&sum>=s) {
            minl = Math.min(minl, e - st);
            sum -= nums[st++];
        }
    }
    return minl==n+1?0:minl;
}
```

1 二分搜索
暴力法搜索前缀数组`sum[j]-sum[i]+nums[i]>=k`的最短ij
二分发寻找`sum[j] >= sum[i]-nums[i]+k` j的最小值

### 560 数组中有多少个和为k的子数组
{% note %}
输入:nums = [1,1,1], k = 2
输出: 2 , [1,1] 与 [1,1] 为两种不同的情况。
{% endnote %}

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

### 930 01数组中有多少个和=target的子数组
{% note %}
输入：A = [0,0,0,0,0], S = 0
输出：15  5+4+3+2+1
{% endnote %}

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

### 713 乘积`<k`的子数组的个数
{% note %}
Input: nums = [10, 5, 2, 6], k = 100
Output: 8
Explanation: The 8 subarrays that have product less than 100 are: `[10], [5], [2], [6], [10, 5], [5, 2], [2, 6], [5, 2, 6]`.
Note that `[10, 5, 2]` is not included as the product of 100 is not strictly less than k.
{% endnote %}

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


{% fold%}
```java
 public int numSubarrayProductLessThanK(int[] nums, int k) {
    int n = nums.length;
    int s = 0;
    int e = 0;
    int p = 1;
    int rst = 0;
    //[2]+1  [2,3] +2 [2,3,4]->[3,4]+2
    while(e<n){
        p *= nums[e++];// e = 1
        while(s<e && p>=k){
            p /= nums[s++];
        }// s = 0
        rst += (e-s);
    }
    return rst;
}
```
{% endfold %}

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

### 862 和至少为K的最短子数组
{% note %}
Input: A = [2,-1,2], K = 3
Output: 3
{% endnote %}

思路：用前缀和找区间和，关键：递增有序栈，
用当前值更新队尾，如果当前的presum比队尾presum小，则下一个减这个得到的区间更短而且值更大。

```java
public int shortestSubarrayWindow(int[] A, int K) {
    int n = A.length;
    long[] presum = new long[n+1];

    for (int i = 0; i <n ; i++) {
        if(A[i] >=K)return 1;
        presum[i+1] = presum[i] +A[i];
    }
    int minlen = n+1;

    Deque<Integer> deque = new ArrayDeque<>();

    for (int i = 0; i <n ; i++) {

        while (deque.size() >0 && presum[i] - presum[deque.getFirst()] >= K){

            minlen = Math.min(minlen, i-deque.pollFirst());
        }
        // 关键
        while (deque.size() > 0 && presum[i] <= presum[deque.getLast()]){
         deque.pollLast();
        }
        deque.addLast(i);

    }
    return minlen == n+1?-1:minlen;

}
```

### 283 Move Zeroes 所有0移到后面
把0都放到后面并且保证原来顺序不变。 没有额外空间。
{% note %}
Input: [0,1,0,3,12]
Output: [1,3,12,0,0]
{% endnote %}
思路：两个指针，如果找到非零，则和前面那个指针的交换
j保证左边没有0，扫一遍i保证所有的非0都移到j的左边。
011->101->110
```java
public void moveZeroes(int[] nums) {
    for(int i = 0,j =0; i < nums.length; i++) {
        if(nums[i] != 0) {
            swap(nums,i,j++);
        }
    }
}
```
优化点：如果数组全部都是非零元素，每个元素都自己和自己交换了，防止自己和自己交换这种操作：
```java
public void moveZeroes(int[] nums) {
    for(int i = 0,j =0; i < nums.length; i++) {
        if(nums[i] != 0) {
            if(i!=j)
            swap(nums,i,j++);
            else j++;
        }
    }
}
```

### 88 Merge Sorted Array
{% note %}
Input:
nums1 = [1,2,3,0,0,0], m = 3
nums2 = [2,5,6],       n = 3

Output: [1,2,2,3,5,6]
{% endnote %}
```java
public void merge(int A[], int m, int B[], int n) {
    int i=m-1, j=n-1, k=m+n-1;
    while (i>-1 && j>-1) A[k--]= (A[i]>B[j]) ? A[i--] : B[j--];
    while (j>-1)         A[k--]=B[j--];
}
```

{% fold %}
```java
public void merge(int[] nums1, int m, int[] nums2, int n) {
    int len = m+n-1;
    int i = m-1;
    int j = n-1;
    while(len>=0){ 
        if(j<0 || (i>=0 && j>=0 && nums1[i] >= nums2[j])){
            nums1[len--] = nums1[i--]; 
        }else if(i<0 || (i>=0 && j>=0 && nums1[i] < nums2[j])) {
            nums1[len--] = nums2[j--];
        }     
    }
}
```
{% endfold %}

### 75 ！!Sort Colors
{% note %}
Input: [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
{% endnote %}
不会！
思路：
left 左边都是0 是1
right 右边都是2 right是0/1

用idx遍历，
1）如果从left开始是1，可以后移，保证00011是正确的顺序
2）如果是2，和right换，right--，因为idx是后面的数字还没遍历，所以idx不动
3）如果是0，和left换，但是left是肯定对的，所以idx++，left被换成0了，保证了左边是0，left++。
4）注意终止条件，因为right可能是0，所以当i==right的时候还可能跟right换一下，直到i>right
```java
public void sortColors(int[] nums) {
    int n = nums.length;
    int left = 0;
    int right = n-1; 
    int i = 0;
    while(i <= right){
        if(nums[i] == 0){
            swap(nums,i++,left++);
        }  
        else if(nums[i] == 2){
            swap(nums,i,right--);
        }else 
            i++;
    }
}
```

### 228 Summary Ranges
{% note %}
输入: [0,1,2,4,5,7]
输出: ["0->2","4->5","7"]
{% endnote %}

### 217 Contains Duplicate
判断数组中是否有重复元素
{% note %}
Input: [1,2,3,1]
Output: true
{% endnote %}
1)两个for循环 
2）排序
3）set


### 275 H-Index II
排好序的h-index
{% note %}
Input: citations = [0,1,3,5,6]
Output: 3 
{% endnote %}

### 274 H-Index
所有学术文章N中有h篇论文分别被引用了至少h次，他的H指数就是h.其他N-h篇论文都没有h次引用
{% note %}
Input: citations = [3,0,6,1,5]
Output: 3
{% endnote %}
解释: 给定数组表示研究者总共有 5 篇论文，每篇论文相应的被引用了 3, 0, 6, 1, 5 次。
由于研究者有 3 篇论文每篇至少被引用了 3 次，其余两篇论文每篇被引用不多于 3 次，所以她的 h 指数是 3。

AC 方法不对
正确做法：桶计数
```java
public int hIndex(int[] citations) {
    int n = citations.length;
    int[] cnt = new int[n+1];
    for(int ci : citations){
        if(ci > n)cnt[n]++;
        else cnt[ci]++;
    }
    int rst = 0;
    for(int i = n;i>=0;i--){
        rst+=cnt[i];
        if(rst >= i)return i;
    }
    return 0;
}
```

### 485 Max Consecutive Ones 最多连续的1
{% note %}
Input: [1,1,0,1,1,1]
Output: 3
{% endnote %}

AC
```java
public int findMaxConsecutiveOnes(int[] nums) {
    int cnt = 0;
    int max = 0;
    for(int i =0;i<nums.length;i++){
        if(nums[i] != 1 && cnt>0){
            max = Math.max(max,cnt);
            cnt =0;
        }else if(nums[i] ==1){
            cnt++;
        }
    }
    max = Math.max(max,cnt);
    return max;
}
```

### 229 Majority Element II
找到所有出现次数超过 ⌊ n/3 ⌋ 次的数字
{% note %}
Input: [3,2,3]
Output: [3]
{% endnote %}

不会
思路：1）超过n/3的数最多只能有2个 注意顺序

```java
public List<Integer> majorityElement(int[] nums) {      
    int n = nums.length;       
    List<Integer> rst = new ArrayList<>();
    int r1 = 0;int r2 = 0;
    int cnt1 = 0;int cnt2 = 0;
    for(int num:nums){
        if(num == r1){
            cnt1++;
        }
        else if(num == r2){
            cnt2++;
        }else if(cnt1 == 0){
            r1=num;
            cnt1++;
        }else if(cnt2 == 0){
            r2 = num;
            cnt2++;
        }    
        else{
            cnt1--;
            cnt2--;
        }
        
    }
    cnt1 = 0;cnt2 = 0;
    for(int num:nums){
        if(num == r1){
            cnt1++;
            if(cnt1>n/3){
                rst.add(r1);
                break;
            }
        }
    }
    if(r2== r1)return rst;
      for(int num:nums){  
        if(num == r2){
            cnt2++;
            if(cnt2>n/3){
                rst.add(r2);
                break;
            }
        }
    }
    return rst;    
}
```

### !!!169 众数 Boyer-Moore Voting Algorithm 
{% note %}
Input: [3,2,3]
Output: 3
{% endnote %}
关键：计数变量
```java
public int majorityElement(int[] nums) {
    int rst = 0;
    int cnt =0;
    for(int num:nums){
        if(cnt == 0){
            rst = num;
        } 
        if(rst != num){
            cnt--;
        }else{
            cnt++;
        }    
    }
    return rst;
}
```

{% fold %}
1.hashmap,直到有计数>n/2 break->return 11%
2.随机数44% 因为一半以上都是这个数，可能只要循环两边就找到了
```java
public int majorityElement(int[] nums){
    Random random = new Random(System.currentTimeMillis());
    while(true){
        int idx = random.nextInt(nums.length);
        int choose = nums[idx];
        int cnt = 0;
        for(int num:nums){
            if(num==cur&&++cnt>nums.length/2)return num;
        }
    }
}
```
3.39% 计算用每个数字的每一位投票，1的个数>n/2则为1 
```java
public int majorityElement(int[] nums){
    int n = nums.length;
    int rst =0;
    int mask =0;
    for(int i=0;i<32;i++){
        mask = 1<<i;
        int cnt =0;
        for(int num:nums){
            if((num&mask)!=0)cnt++;
        }
        if(cnt>n/2)rst|=mask;
    }
    return rst;
}
```

#### 4.moore voting 在线算法92%
```java
public int majorityElement(int[] nums){
    //假设就是第一个数
    int maj = nums[0];
    int cnt=0;
    for(int num:nums){
        //第一个数就cnt=1
        if(num==maj)cnt++;
        else if(--cnt==0){
            //等于0 从头开始做
            cnt=1;
            maj = num;
        }
    }
    return maj;
}
```
**优化100%**
每次取两个不同的数删除，最后剩下的返回
{% fold %}
```java
class Solution {
    public int majorityElement(int[] nums) {
        if(nums==null)return -1;
        int res=0;
        int count=0;
        for(int e : nums){
            if(count==0){
                res=e;
            }
                if(res!=e){
                    count--;//删除这个数
                }
                else count++;
        }
        return res;
    }
}
```
{% endfold %}

5.排序取中间的数
6.C++专有 部分排序
```cpp
int majorityElement(vector<int> & nums){
    nth_element(nums.begin(),nums.begin()+nums.size()/2,nums.end());
    return nums[nums.size()/2];
}
```
7.分治???
{% endfold %}

### 119 ！Pascal's Triangle II 帕斯卡三角形的第k行
{% note %}
Input: 3
Output: [1,3,3,1]
{% endnote %}
不会


### 118 Pascal's Triangle
{% note %}
Input: 5
Output:
```
[
     [1],
    [1,1],
   [1,2,1],
  [1,3,3,1],
 [1,4,6,4,1]
]
```
{% endnote %}

```java
public List<List<Integer>> generate(int numRows) {
    List<List<Integer>> rst = new ArrayList<>();
    for(int i = 0;i<numRows;i++){
        List<Integer> row = new ArrayList<>();
        row.add(1);
        for(int j = 1;i>1&&j<i;j++){
            row.add(rst.get(i-1).get(j-1)+rst.get(i-1).get(j));
        }
        if(i>0)row.add(1);
        rst.add(row);
    }
    return rst;
}
```

### 134 ！Gas Station 环形加油站出发点
找到一个起点可以获得gas[i]汽油，到下一个花费cost[i]可以遍历完所有加油站回到起点的点。
{% note %}
Input: 
gas  = [1,2,3,4,5]
cost = [3,4,5,1,2]
Output: 3
{% endnote %}

AC但是方法不对
前段总的余量为负，即油不够用，要想有解，那么后段油量应该为正，此时才可能有解.

反之，如果前段就为正了，那么显然可以直接选择前面的点为起点；

如果整段加起来都是负的，那么无解

```java
public int canCompleteCircuit(int[] gas, int[] cost) {
   int sum = 0;int total = 0;int rst = 0;
    for(int i = 0;i<gas.length;i++){
        sum += (gas[i]-cost[i]);       
        if(sum<0){
            total +=sum;
            rst = i+1;
            sum = 0;
        }     
    }
    total +=sum;
    return total>=0?rst:-1;
}
```

### 299 !Bulls and Cows 猜对了几个字符
{% note %}
A表示位置对+数值对，B表示位置不对。
Input: secret = "1123", guess = "0111"
Output: "1A1B"
{% endnote %}

关键：计数，如果secret当前字符的计数<0，表示在guess出现过，b++,然后再计数这个字符。
注意对secret和guess的当前字符都判断是否之前出现过，分别计数b。

```java
public String getHint(String secret, String guess) {
    int bulls = 0;
    int cows = 0;
    int[] numbers = new int[10];
    for (int i = 0; i<secret.length(); i++) {
        if (secret.charAt(i) == guess.charAt(i)) bulls++;
        else {
            if (numbers[secret.charAt(i)-'0']++ < 0) cows++;
            if (numbers[guess.charAt(i)-'0']-- > 0) cows++;
        }
    }
    return bulls + "A" + cows + "B";
}
```

### 41 !First Missing Positive 数组中第一个不存在的正数
{% note %}
Input: [1,2,0]
Output: 3
{% endnote %}

不会 思路：用[0-n-1]存储数组中出现的[1-n]如果超出长度不计，再遍历一遍第一个没标记的
```java
public int firstMissingPositive(int[] nums) {
    int n = nums.length;
    if(n<1)return 1;
    int i = 0;
    while(i<n){
        if(nums[i]>0 && nums[i]-1<n && i!=nums[i]-1 && nums[nums[i]-1]!=nums[i] ){
            swap(nums,i,nums[i]-1);
        }
        else i++;
    }
    i = 0;
    while(i<n){
        if(i+1!=nums[i])break;
        i++;
    }
    return i+1;
    
}
private void swap(int[] arr,int i,int j){
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}
```

### 189 Rotate Array 旋转数组
{% note %}
Input: [1,2,3,4,5,6,7] and k = 3
Output: [5,6,7,1,2,3,4]
{% endnote %}
注意划分[0,k-1],[k,n-1]
```java
public void rotate(int[] nums, int k) {
    int n = nums.length;
    if(n<2 || k == 0)return;
    k %= n;
    reverse(nums,0,n-1);
    reverse(nums,0,k-1);
    reverse(nums,k,n-1);
    
}
private void reverse(int[] nums,int i,int j){
    while(i<j){
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
        i++;j--;
    }
}
```

### 277 Find the Celebrity (lintcode)
 Celebrity Problem 所有人都认识他但是他不认识所有人
方法1：找全是0的行，O(n^2)
方法2： 如果A认识B，则A肯定不是名人 O(N)；A不认识B，则A可能是名人，B肯定不是名人
A,B不认识，重新入栈A
![celebrity.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/celebrity.jpg)
A,C认识，入栈C
![celebrity2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/celebrity2.jpg)
![celebrity3.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/celebrity3.jpg)

方法3：双指针
```java
int findCele(int[][]Matrix){
    int n = Matrix.length;
    int a = 0;
    int b = n-1;
    while (a<b){
        if(Matrix[a][b]==1){
            a++;
        }
        else{
            b--;
        }
    }
    for (int i = 0; i <n ; i++) {
        //不是自己，但是别人不认识他，或者他认识别人
        if(i!=a&&Matrix[i][a]!=1||Matrix[a][i]==1)
            return -1;
    }
    return a;
}
```

### 80 !Remove Duplicates from Sorted Array II有序数组只保留每个2个不同元素
{% note %}
Given nums = [1,1,1,2,2,3],
length = 5
{% endnote %}
调了好久
```java
public int removeDuplicates(int[] nums) {
    int i = 0;
    for (int n : nums)
        if (i < 2 || n > nums[i-2])
            nums[i++] = n;
    return i;
}
```

### 26 ！Remove Duplicates from Sorted Array 有序数组只保留不同元素
{% note %}
Given nums = [1,1,2],
2
{% endnote %}
长度bug调了好久
```java
public int removeDuplicates(int[] nums) {
    int n = nums.length;
    if(n<2)return n;
    int cnt = 1;
    for(int i =1;i<n;i++){
        if(nums[i]-nums[i-1]>0){
            nums[cnt++] = nums[i];
        }
    }
    return cnt;
}
```

### 27 Remove Element
熟练
```java
public int removeElement(int[] nums, int val) {
    int cnt = 0;
    for(int i =0;i<nums.length;i++){
        if(nums[i]!=val){
           nums[cnt++] = nums[i]; 
        }
    }
    return cnt;
}
```

### 121 Best Time to Buy and Sell Stock 只能买卖一次 买卖股票的利润
> 输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。

能一次AC 熟练
```java
 public int maxProfit(int[] prices) {
    if(prices.length <1)return 0;
    // 之前最低
    int pre = prices[0];
    int rst = 0;
    for(int i = 1;i < prices.length;i++){
        rst = Math.max(rst,prices[i]-pre);
        pre = Math.min(pre,prices[i]);
    }
    return rst;
}
```