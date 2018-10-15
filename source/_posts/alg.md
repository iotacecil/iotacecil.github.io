---
title: alg
date: 2018-03-24 03:07:34
tags: [alg]
categories: [算法备忘]
---
刷题顺序
https://vjudge.net/article/6
https://www.cnblogs.com/JuneWang/p/3773880.html

微软187
https://blog.csdn.net/v_july_v/article/details/6697883
面试
https://blog.csdn.net/v_july_v/article/details/6803368
https://www.cnblogs.com/JuneWang/p/3773880.html

https://www.educative.io/collection/page/5642554087309312/5679846214598656/140001

https://hrbust-acm-team.gitbooks.io/acm-book/content/search/a_star_search.html

笔试题todo
https://www.nowcoder.com/test/4575457/summary

### 401 二进制手表
上排1,2,4,8表示小时 下排1,2,4,8,16,32表示分钟
上1,2 下 16，8，1 表示3:25
>Input: n = 1 两了几个led灯 所有可能的时间
Return: ["1:00", "2:00", "4:00", "8:00", "0:01", "0:02", "0:04", "0:08", "0:16", "0:32"]

计算小时和分钟里有多少个1
```java
public List<String> readBinaryWatch(int num){
    List<String> times = new ArrayList<>();
    for (int h = 0; h < 12 ; h++) {
        for (int m = 0; m < 60 ; m++) {
            if(Integer.bitCount((h<<6) + m) == num){
                times.add(String.format("%d:%02d",h,m));
            }
        }
    }
    return times;
}
```

### 汉明重量 Hamming weight 32位int有多少个1
>Input: 11
>Output: 3
>Integer 11 has binary representation 00000000000000000000000000001011

>X与X-1相与得到的最低位永远是0

| Expression | Value |
| ------| ------ |
| X | 0 1 0 0 0 1 0 0 0 1 0 0 0 0 |
| X-1 | 0 1 0 0 0 1 0 0 0 0 1 1 1 1 |
|X & (X-1) | 0 1 0 0 0 1 0 0 0 0 0 0 0 0 |

### 477 全部汉明距离`Integer.bitCount(x ^ y)`
> Input: 4, 14, 2
> Output: 6 
> HammingDistance(4, 14) + HammingDistance(4, 2) + HammingDistance(14, 2) = 2 + 2 + 2 = 6.

4  = 0100
14 = 1110
2  = 0010
0x3+2*1+2*1+1*2

```java
public int totalHammingDistance(int[] nums){
    int total = 0,n = nums.length;
    for (int i = 0; i < 32 ; i++) {
        int bitCnt = 0;
        //有几个num这个位是1
        for (int j = 0; j < n ; j++) {
            bitCnt += (nums[j] >> i) & 1;
        }
        total += bitCnt*(n-bitCnt);
    }
    return total;
}
```



### 338 0~n每个数字有几个1位 O(n)复杂度
>Input: 5
Output: [0,1,1,2,1,2]

```java
public int[] countBits(int num){
    int[] f = new int[num + 1];
    for (int i = 1; i <= num ; i++) {
        f[i] = f[i >> 1] + (i & 1);
    }
    return f;
}
```

### 220 数组中是否有相差<=t,idx差<=k 的元素

### 219 是否有重复元素 下标相差<=k
>Input: nums = [1,2,3,1], k = 3
Output: true

放进一个FIFO大小为(k+1) 相差k 的set，当有add失败的时候就true

### 442  `1 ≤ a[i] ≤ n` 找到所有出现2次的元素 O(1) 空间
> some elements appear twice and others appear once.
> Input:[4,3,2,7,8,2,3,1]
> Output:[2,3]

```
4->[4,3,2,-7,8,2,3,1] 
3->[4,3,-2,-7,8,2,3,1]
2->[4,-3,-2,-7,8,2,3,1]
7->[4,-3,-2,-7,8,2,-3,1]
8->[4,-3,-2,-7,8,2,-3,-1]
2->[4,[3],-2,-7,8,2,-3,-1]
3->[4,[3],[2],-7,8,2,-3,-1]
1->[-4,[3],[2],-7,8,2,-3,-1]
```
```java
public List<Integer> findDuplicates(int[] nums){
    List<Integer> res = new ArrayList<>();
    for(int i = 0;i < nums.length;i++){
        int idx = Math.abs(nums[i]) - 1;
        if(nums[idx] < 0){
            res.add(Math.abs(idx) + 1);
        }
        nums[idx] = -nums[idx];
    }
    return res;
}
```

### lt 803 建筑物之间的最短距离
```
盖房子，在最短的距离内到达所有的建筑物。
给定三个建筑物(0,0),(0,4),(2,2)和障碍物(0,2):

    1 - 0 - 2 - 0 - 1
    |   |   |   |   |
    0 - 0 - 0! - 0 - 0
    |   |   |   |   |
    0 - 0 - 1 - 0 - 0
点(1,2)是建造房屋理想的空地，因为3+3+1=7的总行程距离最小。所以返回7。
```

### lt640 字符串 S 和 T, 判断他们是否只差一步编辑 lc161
```java
public boolean isOneEditDistance(String s, String t) {
    int sl = s.length();
    int tl = t.length();
    if(s.equals(t))return false;
    if(Math.abs(sl-tl)>1)return false;
    int idx = 0;
    int len = Math.min(sl,tl);
    for(int i = 0; i < len; i++){
        idx = i+1;// >=1
        // 前面已经相等了
        if(s.charAt(i) != t.charAt(i)){
            // 比较两个字符串的a, b的index+1, index+1 位以后是否相等
            // 或者 index+1, index 是否相等，
            // 或者index, index+1是否相等
            return s.substring(idx).equals(t.substring(idx)) || 
            s.substring(idx).equals(t.substring(idx-1)) || 
            s.substring(idx-1).equals(t.substring(idx));
        }
    }
    return true;
}
```

### 72 编辑距离


### 取模和取余rem
java的`%`取余 python 取模
求 整数商： c = a/b;

计算模或者余数： r = a - c*b.
例如：计算-7 Mod 4
```python
>>> -7%4
1
```
那么：a = -7；b = 4；

第一步：求整数商c，如进行求模运算c = -2（向负无穷方向舍入），求余c = -1（向0方向舍入）；

第二步：计算模和余数的公式相同，但因c的值不同，求模时r = 1，求余时r = -3。

### 线段上格点的个数
> P1=(1,11) P2=(5,3)
> out: 3 (2,9) (3,7) (4,5)

答案是gcd(|x1-x2|,|y1-y2|)-1
最大公约数：共有约数中最大的一个
x相差4，y相差8 求分成（/）最多多少份，x,y都是整数

### 火车编组 1,2,3,4不可能的出栈顺序 ACM列车长的烦恼
>3节车厢，按照1，2，3依次入轨编组，可以在左边形成1 2 3，1 3 2，2 1 3，2 3 1，321。
>问1-2-3-4能否编程4，1，3，2

```java
//假设序列是1,2,3,4
public static void main(String[] args) {
    int[] train = {4,1,3,2};
    boolean flag = false;
    int m = train.length;
    for (int i = 0; i < m ; i++) {
        for (int j = i+1; j < m; j++) {
            for (int k = j+1; k < m ; k++) {
                if(train[i]>train[j]&&train[i]>train[k]&&train[k]>train[j]){
                    flag = true;
                    break;
                }
            }
        }
    }
    if(!flag) System.out.println("Yes");
    else System.out.println("No");
}
```

### 区间dp

### lt476石子合并 区间dp
> 有n堆石子排成一列，每堆石子有一个重量w[i], 每次合并可以合并相邻的两堆石子，一次合并的代价为两堆石子的重量和w[i]+w[i+1]。问安排怎样的合并顺序，能够使得总合并代价达到最小
> in : 4 1 1 4 out: 18



### lc84直方图中的最大矩形poj2559
![histo1.jpg](/images/histo1.jpg)
```java
//todo next
```

---
矩阵乘法相关题目：
http://www.matrix67.com/blog/archives/276

### poj3734

### 790 L型，XX型骨牌覆盖2xN的board
> Input: 3
Output: 5
Explanation: 
The five different ways are listed below, different letters indicates different tiles:
XYZ XXZ XYY XXY XYY
XYZ YYZ XZZ XYY XXY

![lc790.jpg](/images/lc790.jpg)
1.如果只XX骨牌
dp[i] 表示N = i的时候有多少种解
其实是费fib数列

#### poj 2411
http://poj.org/problem?id=2411
输入：大矩阵的h高，和w宽
输出:用宽2，高1的骨牌一共有多少种拼法


### 图中长度为k的路径计数
https://www.nowcoder.com/acm/contest/185/B
>求出从 1 号点 到 n 号点长度为k的路径的数目.

{% fold %}
```java
import java.util.Arrays;
import java.util.Scanner;

public class Main {
    //AC
//    final static int M = 10000;
    public static long[][] mul(long[][] A,long[][] B){
        long[][] rst = new long[A.length][B[0].length];
        for (int i = 0; i <A.length ; i++) {
            for (int k = 0; k <B.length ; k++) {
                for (int j = 0; j <B[0].length ; j++) {
                    rst[i][j] = (rst[i][j]+A[i][k]*B[k][j]);
                }
            }
        }
        return rst;
    }
    public static long[][] pow(long[][] A,int n){
        long[][] rst =new long[A.length][A.length];
        for (int i = 0; i <A.length ; i++) {
            rst[i][i] = 1;
        }
        while (n>0){
            if((n&1)!=0){
                rst = mul(rst,A );
            }
            A = mul(A, A);
            n>>=1;
        }
        return rst;
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        int k = sc.nextInt();
        long[][] graph = new long[n][n];
        for (int i = 0; i <n ; i++) {
            for (int j = 0; j <n ; j++) {
                graph[i][j] = sc.nextInt();
            }
        }
        long[][] Gn = pow(graph, k);
        System.out.println(Gn[0][n-1]);
    }
}

```
{% endfold %}

有向图 从A点走K步到达B(边可重复)的方案数
`G[u][v]`表示u到v 长度为k的路径数量
k=1 1条边可达的点 G1是图的邻接矩阵
![kpath.jpg](/images/kpath.jpg)

### 快速幂logN完成幂运算
carmichael number
```java
//this^exponent mod m
public BigInteger modPow(BigInteger exponent, BigInteger m)
```

### 递推公式
![ditui.jpg](/images/ditui.jpg)
实际上求m项地推公式的第n项 可以用初项线性表示，通过快速幂O(m^2logn)

### fibo递推公式
[特征方程](https://baike.baidu.com/item/%E7%89%B9%E5%BE%81%E6%96%B9%E7%A8%8B)
1.二阶递推公式的特征方程
递推公式Xn = aXn-1 - bXn-2
特征方程x^2-ax+b =0
解得x1,x2则存在F(n) = Ax1+Bx2
带入F(0),F(1) 可得通项

2.矩阵解法
二阶递推式存在2x2矩阵A
![fibo.jpg](/images/fibo.jpg)

矩阵乘法：
```java
final int M = 10000;
public int[][] mul(int[][] A,int[][] B){
    int[][] rst = new int[A.length][B[0].length];
    for (int i = 0; i <A.length ; i++) {
        for (int k = 0; k <B.length ; k++) {
            for (int j = 0; j <B[0].length ; j++) {
                rst[i][j] = (rst[i][j]+A[i][k]*B[k][j])%M;
            }
        }
    }
    return rst;
}
```
![quickmi](/images/quickmi.jpg)
快速幂，将n用二进制表示，5->101表示A^5 = A^4+A^1,
A每次翻倍，n一直右移，n最右为1的时候加上当前A翻倍的结果。
矩阵的幂
```java
public  int[][] pow(int[][] A,int n){
    int[][] rst =new int[A.length][A.length];
    for (int i = 0; i <A.length ; i++) {
        rst[i][i] = 1;
    }
    //for(;n>0;n>>=1)
    while (n>0){
        //快速幂
        if((n&1)!=0)rst = mul(rst,A );
        A = mul(A, A);
        n>>=1;
    }
    return rst;
}
```

解fibo：
```java
int[][] A = {{1,1},{1,0}};
int[][] rst = sl.pow(A, n);
System.out.println(rst[1][0]);
```



### 763 划分尽可能多字母区间
>输入: S = "ababcbacadefegdehijhklij"
输出: [9,7,8]
解释:
划分结果为 "ababcbaca", "defegde", "hijhklij"。
每个字母最多出现在一个片段中。
像 "ababcbacadefegde", "hijhklij" 的划分是错误的，因为划分的片段数较少。
ababcba 从第一个a到最后一个a是必须包含的长度

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

### 769 0-n的排列切割，块排序后连接是排序的原数组
>输入: arr = [1,0,2,3,4]
输出: 4
解释:
我们可以把它分成两块，例如 [1, 0], [2, 3, 4]。
然而，分成 [1, 0], [2], [3], [4] 可以得到最多的块数。

```
idx:0 1 2 3 4
arr:1 0 2 3 4
max:0 1 2 3 4
当前index==当前max 表示可以切分
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

### 768






### 532 数组中有几个相差k的pair
> 输入: [3, 1, 4, 1, 5], k = 2
输出: 2
解释: 数组中有两个 2-diff 数对, (1, 3) 和 (3, 5)。
尽管数组中有两个1，但我们只应返回不同的数对的数量。

set的解法33% //todo比双指针慢 


### 15 3sum a + b + c = 0
> Given array nums = [-1, 0, 1, 2, -1, -4],
A solution set is:
[
  [-1, 0, 1],
  [-1, -1, 2]
]

关键：去重技巧
```java
//75%
public List<List<Integer>> threeSum(int[] num) {
    Arrays.sort(num);
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i <num.length-2; i++) {
        //关键去重
        if(i==0||(i>0&&num[i]!=num[i-1])){
            int lo = i+1,hi=num.length-1,sum = 0-num[i];
            //关键
            while (lo<hi){
                if(num[lo]+num[hi] == sum){
                    res.add(Arrays.asList(num[i],num[lo],num[hi]));
                    //去重
                    while (lo<hi&&num[lo]==num[lo+1])lo++;
                    while (lo<hi&&num[hi]==num[hi-1])hi--;
                    lo++;hi--;
                }else if(num[lo]+num[hi]<sum)lo++;
                else hi--;
            }
        }
      }
      return res;
}
```

### 16 3sum 最接近target的值
//todo nexttime

### 18 4sum 外层for 用3sum找`target-nums[i]`

### 454 4 sum 2 poj2785 4 Values whose Sum is 0
用poj的方法11%
4个分别有n个数字的数组ABCD，每个数组中取一个，合为0的组合数。
c+d = -a-b
从A,B中找出n^2种组合，从C,D中找出n^2种组合，排序二分找到lowerbound和upbound。

正确方法：计算c+d的时候放入hashmap计数
```java
public int fourSumCount(int[] A, int[] B, int[] C, int[] D) {
    Map<Integer,Integer> map = new HashMap<>();
    for (int i = 0; i <C.length ; i++) {
        for (int j = 0; j <D.length ; j++) {
            int sum = C[i] + D[j];
            map.put(sum,map.getOrDefault(sum,0 )+1 );
        }
    }
    int res = 0;
    for (int i = 0; i <A.length ; i++) {
        for (int j = 0; j <B.length ; j++) {
            res += map.getOrDefault(-(A[i]+B[j]),0 );
        }
    }
    return res;
}
```



### 914 相同数字的牌划分成一组，每组数量相同 能否划分
> 输入：[1,2,3,4,4,3,2,1]
输出：true
解释：可行的分组是 [1,1]，[2,2]，[3,3]，[4,4]

计数，求最大公约数
```java
public boolean hasGroupsSizeX(int[] deck) {
    if(deck==null||deck.length<2)return false;
   Map<Integer, Integer> count = new HashMap<>();
    int res = 0;
    for (int i : deck) count.put(i, count.getOrDefault(i, 0) + 1);
    for (int i : count.values()) res = gcd(i, res);
    return res > 1;
}

public int gcd(int a, int b) {
    return b > 0 ? gcd(b, a % b) : a;
}
```

### 915 Max(left)<=Min(right)
画折线图，当前`A[i]<left` 则把切分线抬到`globalMax`
![lc915](/images/lc915.jpg)
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

### 916
> b 中的每个字母都出现在 a 中，包括重复出现的字母，那么称单词 b 是单词 a 的子集。 例如，“wrr” 是 “warrior” 的子集，但不是 “world” 

### 7 整数反转 integer越界
{% fold %}
```java
public int reverse(int x) {
    int flag = x<0?-1:1;
    int rst = 0;
    while(x!=0){
        int add = x%10;
        x/=10;
        if(rst>Integer.MAX_VALUE/10||(rst==Integer.MAX_VALUE/10&&add>7))return 0;
        if(rst<Integer.MIN_VALUE/10||(rst==Integer.MIN_VALUE/10&&add<-8))return 0;
        rst = rst*10+add;
    }
    return rst;
}
```
{% endfold %}

### 319 n个灯泡 n轮开关
初始时有 n 个灯泡关闭。 第 1 轮，你打开所有的灯泡。 第 2 轮，每两个灯泡你关闭一次。 第 3 轮，每三个灯泡切换一次开关（如果关闭则开启，如果开启则关闭）。第 i 轮，每 i 个灯泡切换一次开关。 对于第 n 轮，你只切换最后一个灯泡的开关。 找出 n 轮后有多少个亮着的灯泡。
>输入: 3
输出: 1 
解释: 
初始时, 灯泡状态 [关闭, 关闭, 关闭].
第一轮后, 灯泡状态 [开启, 开启, 开启].
第二轮后, 灯泡状态 [开启, 关闭, 开启].
第三轮后, 灯泡状态 [开启, 关闭, 关闭]. 

你应该返回 1，因为只有一个灯泡还亮着。
```java
int bulbSwitch(int n) {
    return sqrt(n);
}
```
被按奇数下的灯泡还亮着。
当第d轮可以整除i灯泡i被按下。所以如果i有奇个除数，则最后是开的。
例如12，


### 451 字符串按频率排序 桶排序


### lt168 吹气球
每次吹气球i可以得到的分数为 `nums[left] * nums[i] * nums[right]`，
>in [4, 1, 5, 10]
out 返回 270
```
nums = [4, 1, 5, 10] burst 1, 得分 4 * 1 * 5 = 20
nums = [4, 5, 10]    burst 5, 得分 4 * 5 * 10 = 200 
nums = [4, 10]       burst 4, 得分 1 * 4 * 10 = 40
nums = [10]          burst 10, 得分 1 * 10 * 1 = 10
总共的分数为 20 + 200 + 40 + 10 = 270
```



### 矩阵链乘法O(n^3)的dp
 



### 最大值为k的不重叠子数组的长度和？??
https://www.geeksforgeeks.org/maximum-sum-lengths-non-overlapping-subarrays-k-max-element/
>Input : arr[] = {2, 1, 4,   9,   2, 3,   8,   3, 4}  k = 4
Output : 5
{2, 1, 4} => Length = 3
{3, 4} => Length = 2
So, 3 + 2 = 5 is the answer

```java
public int lensum(int[] arr,int k){
    int n = arr.length;
    int ans = 0;

    for (int i = 0; i < n ; i++) {
        int cnt=0;
        int flag = 0;
        while (i<n&&arr[i]<=k){
            cnt++;
            if(arr[i] == k)flag = 1;
            i++;
        }
        //？？？
        if(flag == 1) ans+=cnt;
        while (i<n&&arr[i]>k)i++;
    }
    return ans;
}
```


### 689!!!高频题 找到三个长度为k互不重叠的子数组的最大和
> Input: [1,2,1,2,6,7,5,1], 2
> 不重叠窗口为2的数组的和  `[1, 2], [2, 6], [7, 5]`
> 返回 起始索引为 [0, 3, 5]。
> 也可以取 [2, 1], 但是结果 [1, 3, 5] 在字典序上更大。

https://leetcode.com/articles/maximum-sum-of-3-non-overlapping-intervals/
https://www.jiuzhang.com/solution/maximum-sum-of-3-non-overlapping-subarrays/

### 121 只能买卖一次 买卖股票的利润
> 输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。

方法1：两次for，找最大差值 10% 262ms
方法2：Kadane算法(maximum subarray)先找到最低值，保留并更新最低值，并更新最大差值 2ms 36%

```java
public int maxProfit(int[] prices){
    int minP = Integer.MAX_VALUE;
    int maxP = 0;
    int n = prices.length;
    for(int i =0;i<n;i++){
        if(prices[i]<minP)minP = prices[i];
        else if(prices[i]-minP>maxP)maxP = prices[i]-minP;
    }
    return maxP;
}
```

dp 保留前i天的最低值 更新第i天的最大差值 3ms 19%
```java
 public int maxProfit(int[] prices) {
    int n = prices.length;
    if(n<1)return 0;
    int[] mindp = new int[n];
    int[] maxdp = new int[n];
    mindp[0] = prices[0];
    maxdp[0] =0;
    for(int i =1;i<n;i++){
        mindp[i] = Math.min(mindp[i-1],prices[i]);
       //当天的股价-前i-1天的min价格
        maxdp[i] = Math.max(maxdp[i-1],prices[i]-mindp[i-1]);
    }
    return maxdp[n-1];
}
```
dp2: 4 ms 15%
转换成53 将price reduce成每天的收益
`[7,1,5,3,6,4]->[ ,-6,4,-2,3,-2]`
在[4,-2,3]持有股票，从day2 [1]买进后的累积和最大
```java
```



#### 53!!!最大subarray sum
Kadane 14ms 19%
```java
public int maxSubArray(int[] nums){
    int sum = nums[0],rst = nums[0];
    for(int i=1;i<nums.length;i++){
        sum = Math.max(nums[i],sum+nums[i]);
        rst = Math.max(rst,sum);
    }
    return rst;
}
```
greedy:


### 122 可以买卖多次 买股票的利润
> 输入: [7,1,5,3,6,4]
输出: 7
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 3 天（股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5-1 = 4 。
随后，在第 4 天（股票价格 = 3）的时候买入，在第 5 天（股票价格 = 6）的时候卖出, 这笔交易所能获得利润 = 6-3 = 3 。

### 123 最多买卖2次的 买股票利润 考到
> 输入: [3,3,5,0,0,3,1,4]
输出: 6
解释: 在第 4 天（股票价格 = 0）的时候买入，在第 6 天（股票价格 = 3）的时候卖出，这笔交易所能获得利润 = 3-0 = 3 。
 随后，在第 7 天（股票价格 = 1）的时候买入，在第 8 天 （股票价格 = 4）的时候卖出，这笔交易所能获得利润 = 4-1 = 3 。

### 188 最多k次买卖的 买卖股票利润
> 输入: [3,2,6,5,0,3], k = 2
输出: 7
解释: 在第 2 天 (股票价格 = 2) 的时候买入，在第 3 天 (股票价格 = 6) 的时候卖出, 这笔交易所能获得利润 = 6-2 = 4 。
随后，在第 5 天 (股票价格 = 0) 的时候买入，在第 6 天 (股票价格 = 3) 的时候卖出, 这笔交易所能获得利润 = 3-0 = 3 。

### 重复元素很多的数组排序
https://www.geeksforgeeks.org/how-to-sort-a-big-array-with-many-repetitions/
> AVL or Red-Black to sort in O(n Log m) time where m is number of distinct elements.
//todo






### 621 todo
26 种不同种类的任务  每个任务都可以在 1 个单位时间内执行完
两个相同种类的任务之间必须有长度为 n 的冷却时间
> 输入: tasks = ["A","A","A","B","B","B"], n = 2
输出: 8


执行顺序: A -> B -> (待命) -> A -> B -> (待命) -> A -> B.




### 516 最长回文子序列

### Rearrange a string
https://www.geeksforgeeks.org/rearrange-a-string-so-that-all-same-characters-become-at-least-d-distance-away/

### !!386 字典序数字 todo

dfs 112ms 71%
```
   1        2        3    ...
  /\        /\       /\
10 ...19  20...29  30...39   ....
```

```java
public List<Integer> lexicalOrder(int n) {
     List<Integer> rst = new ArrayList<>();
    for (int i = 1; i < 10; i++) {
        dfs(rst,n,i);
    }
    return rst;
}
private void dfs(List<Integer> rst,int n,int cur){
    if(cur>n)return;
    else{
        rst.add(cur);
        for (int i = 0; i <10 ; i++) {
            if(cur*10+i>n)return;
            dfs(rst,n,10*cur+i);
        }
    }
}
```


相关：
permutation的字典序
思想：字典序全排列算法：保证尽可能长的前缀不变，后缀慢慢增加
 abc 保证前面不变，后面增加一点点 -> acb ，cb不能增大了，->bac
 从右向左扫描 例如 321 是递增的 表示不能再增加
 从右向左扫描到第一次增大的位置，和右边比较大的数交换。1 2 3 扫描到2，和3交换。
 1 3 2 扫描到1降了，1和2交换 2 3 1  31不是最小后缀 变成2 1 3 

算法：
![lexpermu.jpg](/images/lexpermu.jpg)
 1.从右想左 找到第一次下降位置
 2.用后缀中比当前位置大的最小数字交换
 3.保证后缀最小（翻转？）


### 636
日志是具有以下格式的字符串：function_id：start_or_end：timestamp。例如："0:start:0" 表示函数 0 从 0 时刻开始运行。"0:end:0" 表示函数 0 在 0 时刻结束。

函数的独占时间定义是在该方法中花费的时间，调用其他函数花费的时间不算该函数的独占时间。
> 输入 n = 2
logs = 
["0:start:0",
 "1:start:2",
 "1:end:5",
 "0:end:6"]
输出：[3, 4]

函数 0 在时刻 0 开始，在执行了  2个时间单位结束于时刻 1。
现在函数 0 调用函数 1，函数 1 在时刻 2 开始，执行 4 个时间单位后结束于时刻 5。
函数 0 再次在时刻 6 开始执行，并在时刻 6 结束运行，从而执行了 1 个时间单位。
所以函数 0 总共的执行了 2 +1 =3 个时间单位，函数 1 总共执行了 4 个时间单位。

stack + start[] ac 15%



### 378 矩阵从左到右从上到下有序，找第k小的元素
1.全部放进k大的PriorityQueue,最后poll掉k-1个，return peek 28%
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
2.

### 373


### 概率生成函数 概率母函数
1.x的系数是a1,a2,…an 的单个组合的全体。
2. x^2的系数是a1,a2,…a2的两个组合的全体。
………
n. x^n的系数是a1,a2,….an的n个组合的全体（只有1个）。

> 有1克、2克、3克、4克的砝码各一枚，能称出哪几种重量？每种重量各有几种可能方案？

设x表示砝码，x的指数表示砝码的重量
1个1克的砝码可以用函数1+1*x^1表示，
1个2克的砝码可以用函数1+1*x^2表示，
1个3克的砝码可以用函数1+1*x^3表示，
1个4克的砝码可以用函数1+1*x^4表示，

- 1表示数量0个
例如1个2克的砝码：1+x^2
1其实应该写为：1*x^0,即1代表重量为2的砝码数量为0个。

- 系数表示状态数（方案数）
1+x^2，也就是1*x^0 + 1*x^2，不取2克砝码，有1种状态；或者取2克砝码，也有1种
状态。

(1+x)(1+x^2)(1+x^3)(1+x^4)
=(1+x+x^2+x^4)(1+x^3+^4+x^7)
=1 + x + x^2 + 2*x^3 + 2*x^4 + 2*x^5 + 2*x^6 + 2*x^7 + x^8 + x^9 + x^10
从上面的函数知道：可称出从1克到10克，系数便是方案数。
有2*x^5 项，即称出5克的方案有2种：5=3+2=4+1；


> 求用1分、2分、3分的邮票贴出不同数值的方案数：每种是无限的。



### 分配问题及应用
![fenpei.jpg](/images/fenpei.jpg)


### 硬币相关问题
http://www.raychase.net/3144
正正反 甲赢 正反反 乙赢 Penney's game

![penneygame.jpg](/images/penneygame.jpg)
> 使用长度为3字节的序列，玩家B相对玩家A有优势。这是因为这个游戏是一个非传递博弈，所以无论如何选定第一个序列，总会有一个序列有更大的获胜概率。


反反正:正反反 = 1：3 
因为只要出现一次正，想得到反反正的人就必输了，他肯定得先看到两次反，我就得到正反反了。
两个硬币4种情况有3种有正

正正反：反正正 = 1：3
只要出现一次反，反正正就赢了。

正反反HTT：正正反HHT = 1:2
反正正thh:反反正tth = 1：2

https://en.wikipedia.org/wiki/Penney%27s_game
对于二号玩家：1-2-3 ->  (not-2)-1-2
第一个字节与1号玩家的第二个字节相反，
第二个字节与1号玩家的第一个字节相同，
第三个字节与1号玩家的第二个字节相同。

http://www.matrix67.com/blog/archives/3638
> 所有 1 都不相邻的 k 位 01 串有 Fk+2 个 Fi 表示 Fibonacci 数列中的第 i 项

抛掷第 k 次才出现连续两个正面”的意思就是， k 位 01 串的末三位是 011，并且前面 k – 3 位中的数字 1 都不相邻。 k-3位的01不相邻的串有F(k-1)个

>平均需要抛掷多少次硬币，才会首次出现连续的 n 个正面？

答案是 2^(n+1) – 2 
神奇的模式概率与“鞅”//todo
http://www.math-engineering.uestc.edu.cn/
模式的平均等待时间：
模式 HHHHHH 的平均等待时间 126

> 扔硬币直到连续两次出现正面，求扔的期望次数

• 扔到的是反面，那么还期望抛 E 次，因为抛到反面完全没用，总数就期望抛 E+1，所以是0.5*(1 + E)
• 扔到的是正面，如果下一次是反面，那么相当于重头来过，总数就期望抛，则是0.25*(2 + E)
• 扔到两次，都是正面，总数是 2，则是0.25*2
所以递归来看E = 0.5*(1 + E) + 0.25*(2 + E) + 0.25*2，解得E = 6


>A赢： 先正后反， B赢 连续两次反面：A胜的概率 3/4

B 赢概率是1/2*1/2 = 1/4


多重排列：pingpang中有重复2个p 2个n 2个g
1. 标记为p1p2n1n2g1g2ia 全排列个数是8!
2. p的重复度 为p1p2的全排列 2!
3. P(N,r1,r2...rt)  标记为P(8;2,2,2,1,1)
4. P(8;2,2,2,1,1)\*2!\*2!\*2! = 8!

理解二项式定理(a+b)^n
![abbinary.jpg](/images/abbinary.jpg)
通项是a^k b^(n-k) 前面的系数表示 n个数的可重排列，a有k个，b有n-k个

不仅是二项式 
通项是a1^(r1) a2^(r2) at^(rt)
![nbinary.jpg](/images/nbinary.jpg)
(x1+x2+…+xm)^n 展开式的项数等于C(n+m-1,n).

> 有6个洞 编号1-9个球，求球入洞的方案数

隔板法：
1. 划分6个洞需要5个隔板，用1~9填充隔板的空间。变成5个隔板和9个球的全排列。
2. 5个隔板是相同的，P（14,5,1,1,1,1,1,1,1,1,1,1) = 14!/5!


另一种方法：
1. 1号球可以放6个位置
2.  1号球等于把空间又划分成了1前和1后，2球有5+2种可能
3.  同理 3号球有7-1+2 =8个可能...
4.  6乘到14 = 14!/5!



> 52张牌分发给4个人，每人13张，问每人有一张A的概率有多少？ 
> 10.55%

52张牌分发给4个人，每人13张的方法数为52！/(13!)^4 。
每人发一张A的方法数为4！* 48！/(12!)^4 .

> 4个相同的桔子和6个不同的苹果放到5个不同的盒子中，问每个盒子里有2个水果的概率有多大？
> 7.4%

把4个相同桔子放入5个不同盒子的放法数为C(5,4),
把6个不同苹果放入5个不同盒子的放法数为5^6 .因此总的分配方法数为C(5,4)*5^6 .

每个盒子有2个水果，有如下三种情况：
1、（AA)(AA)(AA)(OO)(OO)
C(5,2)*6!/2!/2!/2!
2、AA)(AA)(OA)(OA)(OO)
C(5,1)\*C(4,2)\*6!/2!/2!
3.（AA)(OA)(OA)(OA)(OA)
C(5,4)*6!/2!

> 将n个不同的球放入编号为1,2,…,k的k个盒子中，试求：

1. 第一个盒子是空盒的概率: 第一个盒子是空盒的方案数为(k－1) n 。
2. 设k≥n,求n个球落入n个不同盒子的概率:  n个球落入n个不同盒子的方案数为C(k,n)n!。
3. 第一盒或第二盒两盒中至少一个是空盒的概率。该方案数为第一个盒子是空盒的方案数加上第二个
盒子是空盒的方案数，再减去两个盒子都是空盒的方案
数。


> 随机地将15名插班生分配到三个班级，每班各5名。设15名插班生中有3为女生。试求：
将15名插班生分配到三个班级，每班各5名的方案数为C(15,5)C(10,5)C(5,5)=15!/(5!5!5!)。

1. 每一个班级分到一名女生的概率:3!*12!/(4!4!4!)
2. 三名女生分到同一班的概率: 3*12!/(5!5!2!)




### 649 2种n个参议员，2种操作 无限多轮，直到所有票在同一个阵营
禁止一名参议员的权利：
参议员可以让另一位参议员在这一轮和随后的几轮中丧失所有的权利。

宣布胜利：如果参议员发现有权利投票的参议员都是同一个阵营的，他可以宣布胜利并决定在游戏中的有关变化。
> 输入: "RD"
输出: "Radiant"
解释:  第一个参议员来自  Radiant 阵营并且他可以使用第一项权利让第二个参议员失去权力，因此第二个参议员将被跳过因为他没有任何权利。然后在第二轮的时候，第一个参议员可以宣布胜利，因为他是唯一一个有投票权的人

> 输入: "RDD"
输出: "Dire"
解释: 
第一轮中,第一个来自 Radiant 阵营的参议员可以使用第一项权利禁止第二个参议员的权利
第二个来自 Dire 阵营的参议员会被跳过因为他的权利被禁止
第三个来自 Dire 阵营的参议员可以使用他的第一项权利禁止第一个参议员的权利
因此在第二轮只剩下第三个参议员拥有投票的权利,于是他可以宣布胜利



### 495 给定攻击时间和中毒状态持续时间，问中毒状态总时长
> Input: [1,2], 2
Output: 3 (1-2-4)

8ms
```java
public int findPoisonedDuration(int[] timeSeries, int duration) {
    if(timeSeries==null||timeSeries.length<1||duration==0)return 0;
    int rst = 0;
    for(int i =0;i<timeSeries.length-1;i++){
        //每次取间隔或者duration
      rst += Math.min(duration,timeSeries[i+1]-timeSeries[i]);
    }
    rst += duration;
    return rst;
}
```
//todo again
按 区间的做法：100% 4ms
```java
public int findPoisonedDuration(int[] timeSeries, int duration) {
    if(timeSeries==null||timeSeries.length<1||duration==0)return 0;
    int rst = 0;
    int start = timeSeries[0];
    int end = timeSeries[0]+duration;
    for(int i = 1;i<timeSeries.length;i++){
        //Input: [1,4], 2 
        if(timeSeries[i]>end){
            result += (end-start);
            start = timeSeries[i];
        }
        end = timeSeries[i]+duration;
    }
        result+=(end-start);
        return result;
}
```

### 899 操作字符串前k个字符放到最后 输出字典序最小的
> Input: S = "cba", K = 1
> Output: "acb"
> 
> Input: S = "baaca", K = 3
> Output: "aaabc"
> Explanation: 
> In the first move, we move the 1st character ("b") to the end, obtaining the string "aacab".
> In the second move, we move the 3rd character ("c") to the end, obtaining the final result "aaabc".

当k=1 字符串只能旋转
当k>1的时候，固定第一位，可以把后面任意一位转到第二位，即确定第一位，可以和后面所有数字比较，然后放到最后，冒泡排序。


### 77combinations  C(n,k)=C(n-1,k-1)+C(n-1,k)

`C(n-1,k-1)`表示选这个数，`C(n-1,k)`表示不选这个数
88%的写法：
```java
public List<List<Integer>> combineFast(int n,int k) {
    List<List<Integer>> result = new ArrayList<>();
    if(k>n||k<0)return result;
    if(k==0){
        result.add(new ArrayList<>());
        return result;
    }
    result = combine(n-1,k-1 );
    for(List<Integer> list:result){
        list.add(n);
    }
    result.addAll(combine(n-1,k ));
    return result;
}
```

```java
//    math 8% C(n,k)=C(n-1,k-1)+C(n-1,k)
public List<List<Integer>> combineMath(int n,int k){
    if(k==n||k==0){
        List<Integer> row = new ArrayList<>();
        for (int i = 1; i <=k ; i++) {
            row.add(i);
        }
        return new ArrayList<>(Arrays.asList(row));
    }
    List<List<Integer>> result = this.combineMath(n-1,k-1 );
    result.forEach(e->e.add(n));
    result.addAll(this.combineMath(n-1,k ));
    return result;
}
```

### 24两个一组交换链表

### NqueenBB
![nqueenbb.jpg](/images/nqueenbb.jpg)
N – 1’ in the backslash code is there to ensure that the codes are never negative because we will be using the codes as indices in an array.
```
slash /
 0  1  2  3  4  5  6  7 
 1  2  3  4  5  6  7  8 
 2  3  4  5  6  7  8  9 
 3  4  5  6  7  8  9 10 
 4  5  6  7  8  9 10 11 
 5  6  7  8  9 10 11 12 
 6  7  8  9 10 11 12 13 
 7  8  9 10 11 12 13 14 
```

```
backslash \
 7  6  5  4  3  2  1  0 
 8  7  6  5  4  3  2  1 
 9  8  7  6  5  4  3  2 
10  9  8  7  6  5  4  3 
11 10  9  8  7  6  5  4 
12 11 10  9  8  7  6  5 
13 12 11 10  9  8  7  6 
14 13 12 11 10  9  8  7 
```
```java
for (int r = 0; r <N ; r++) {
    for (int c = 0; c <N ; c++) {
       slashCode[r][c]=r+c;
       backslashCode[r][c]=r-c+(N-1);
    }
}
```
bb 5ms 78%
```java
int[][] slashCode, backslashCode;
//记录这个code是不是已经占用了
boolean[] rowocc;
boolean[] slashocc,backslashocc;
public List<List<String>> solveNQueens(int n) {
    List<List<String>> rst = new ArrayList<>();
    int[][] board = new int[n][n];
     slashCode = new int[n][n];
    backslashCode = new int[n][n];
    rowocc = new boolean[n];
     slashocc = new boolean[2*n-1];
    backslashocc = new boolean[2*n-1];
    for (int r = 0; r <n ; r++) {
        for (int c = 0; c <n ; c++) {
           slashCode[r][c]=r+c;
           backslashCode[r][c]=r-c+(n-1);
        }
    }
    nqueen(rst,0,n,board);
    return rst;
}
private List<String> addBoard(int[][] board){
    List<String> rst  = new ArrayList<>();
    for(int[] row:board){
        StringBuilder sb = new StringBuilder();
        for(int i:row){
            sb.append((i==0?".":"Q"));
        }
        rst.add(sb.toString());
    }
    return rst;
}
boolean isSafe(int[][] board,int row, int col)
{
    if (slashocc[slashCode[row][col]] ||
            backslashocc[backslashCode[row][col]] ||
            rowocc[row])
        return false;

    return true;
}
private void nqueen(List<List<String>> rst,int col,int n,int[][] board){
    if(col>=n){
        rst.add(addBoard(board));
        return;
    }
    for(int i=0;i<n;i++){
        if(isSafe(board,i,col)){
             board[i][col] = 1;
             rowocc[i] = true;
            slashocc[slashCode[i][col]] = true;
            backslashocc[backslashCode[i][col]] = true;
            nqueen(rst,col+1,n,board);
            rowocc[i] = false;
            slashocc[slashCode[i][col]] = false;
            backslashocc[backslashCode[i][col]] = false;
            board[i][col] =0;
        }
    }
}
```

check whether slash code ( j + i ) or backslash code ( j – i + 7 ) are used (keep two arrays that will tell us which diagonals are occupied). 

### 179 一组非负数，拼接成最大的正整数
> Input: [10,2]
> Output: "210"


String s1 = "9";
String s2 = "31";

String case1 =  s1 + s2; // 931
String case2 = s2 + s1; // 319
> String concatenation may be O(n^2) in Java (depends on if the compiler optimizes). Using StringBuilder is O(n).

```java
public String largestNumber(int[] nums) {
    if(nums==null||nums.length<1)return "";
    String[] strs = new String[nums.length];
    //变成String数组
    for (int i = 0; i <nums.length ; i++) {
        strs[i] = String.valueOf(nums[i]);
    }
    //关键
    Arrays.sort(strs,(a,b)->(b+a).compareTo(a+b));
    if(strs[0].equals("0"))return "0";
    StringBuilder sb = new StringBuilder();
    for(String str:strs){
        sb.append(str);
    }
    return sb.toString();
}
```


### 500 判断字符串是不是在键盘的同一行
流： 正则很慢 流也很慢
```java
public String[] findWords(String[] words){
    return Stream.of(words).parallel().filter(s->s.toLowerCase().matches("[qwertyuiop]*|[asdfghjkl]*|[zxcvbnm]*")).toArray(String[]::new);
}
```



### 42


### 683 - K Empty Slots

### 最长01串


### 倒水问题 BFS
#### poj 3414 Pots
http://poj.org/problem?id=3414
> 输入：3 5 4
> 输出
> 容量A3 B5 获得4升水的最短序列
> 6
> FILL(2)
> POUR(2,1)
> DROP(1)
> POUR(2,1)
> FILL(2)
> POUR(2,1)

Accepted    3128K   1125MS  Java    3840B

```java
class pathNode{
    int a,b;
    int t;
    public pathNode(int a, int b, int t) {
        this.a = a;
        this.b = b;
        this.t = t;
    }
}
class Cell{
    int a,b;
    public Cell(int a, int b) {
        this.a = a;
        this.b = b;
    }
}

void Bfs(int A,int B,int C){
    int cnt = 0;
    int[][] marked = new int[A+1][B+1];
    pathNode[] pathNodes = new pathNode[A+B+5];
    int[][] pre =  new int[A+1][B+1];

    Deque<Cell> que = new ArrayDeque<Cell>();
    //初始状态 2个空桶
    que.add(new Cell(0,0));
    marked[0][0] = 1;
    while (!que.isEmpty()){
        Cell cell = que.poll();
        int a = cell.a,b = cell.b;
        //6种操作 满，空，互相倒 x2
        for (int d = 0; d <6 ; d++) {
            int na=0,nb=0;
            //装满A
            if(d==0){na=A;nb=b;}
            else if(d==1){na= a;nb=B;}
            else if(d==2){na=0;nb=b;}
            else if(d==3){na=a; nb=0;}
            //A->B
            else if(d==4){
                int all = a+b;
                na = all>=B?all-B:0;
                nb = all>=B?B:all;
            }
            //B->A
            else if(d==5){
                int all = a+b;
                na = all>=A?A:all;
                nb = all>=A?all-A:0;
            }
            //这个桶状态没试过
            if(marked[na][nb]==0){
                marked[na][nb] =1;
                //关键：记录当前操作序号cnt是在node(a,b)是做d操作得来的
                pathNodes[cnt] = new pathNode(a,b,d);
                //可以查到对上一个的操作
                pre[na][nb] = cnt;
                cnt++;
                if(na == C||nb==C){
                    Deque<Integer> op = new ArrayDeque<Integer>();
                    int enda = na,endb = nb;
                    while (enda!=0||endb!=0){
                        int p = pre[enda][endb];
                        op.push(pathNodes[p].t);
                        enda = pathNodes[p].a;
                        endb = pathNodes[p].b;
                    }
                    System.out.println(op.size());
                    while (!op.isEmpty()){
                        int x = op.poll();
                        if(x==0||x==1) System.out.printf("FILL(%d)\n",x+1);
                        else if(x==2||x==3)System.out.printf("DROP(%d)\n",x-1);
                        else if(x==4) System.out.printf("POUR(1,2)\n");
                        else if(x==5)System.out.printf("POUR(2,1)\n");
                    }
                    return;
                }
                que.add(new Cell(na,nb));
            }
        }
//            System.out.println("下一层");
    }
    System.out.println("impossible");
}
```

#### poj 1606


### 2^N 大整数





### 287 O(1)空间，找到数组中重复的数字

### 查找第二小/大的元素
```java
static int secondMin2(int[] arr){
    int first = Integer.MAX_VALUE,second = Integer.MAX_VALUE;
    for (int j = 0; j < arr.length; j++) {
        if(arr[j]<=first){
            second = first;
            first = arr[j];
        }else if(arr[j]<=second&&arr[j]!=first)
            second = arr[j];
    }
    return second;
}
static int secondMax(int[] arr){
    int first = Integer.MIN_VALUE,second = Integer.MIN_VALUE;
    for (int j = 0; j < arr.length; j++) {
        if(arr[j]>=first){
            second = first;
            first = arr[j];
        }else if(arr[j]>=second&&arr[j]!=first)
            second = arr[j];
    }
    return second;
}
```

### 排序数组中小于target的
2 4 6 8 9 target=14
1. 2+9<14 cnt+=4
2. 4+9<14 cnt+=3
3. 6+9>14,6+8==14,start==end 结束

### 给定一个数字范围，找到其中有几个首尾相同的数字
![digits.jpg](/images/digits.jpg)

### 百万数字中找最大20个
用开始20个数字构造20个node的最小堆，接下来的数字比root大则replace，insert

### 每秒最大桶数量减半，求t时刻一共消耗了多少
方法1：按递减排序，减半，再排序，一共排序t次
方法2：维持最大堆，每次取root减半再插入

### ？445 链表数字相加
> Input: (7 -> 2 -> 4 -> 3) + (5 -> 6 -> 4)
> Output: 7 -> 8 -> 0 -> 7

？递归写法

### 896有正负的数列判断单调
用首尾判断up/down，中间相邻遍历判断up/down和之前不符return false
20ms
```java
public boolean isMonotonic(int[] A) {
    if (A.length==1) return true;
    int n=A.length;
    //关键
    boolean up= (A[n-1]-A[0])>0;
    for (int i=0; i<n-1; i++)
        if (A[i+1]!=A[i] && (A[i+1]-A[i]>0)!=up) 
            return false;
    return true;
}
```

### 14 最长公共前缀
```java
public String longestCommonPrefix(String[] strs) {
   if(strs==null||strs.length<1)return "";
   String rst = strs[0];
   for(int i =1;i<strs.length;i++){
    //削减rst以匹配每个后面的单词
       while(strs[i].indexOf(rst)!=0){
           rst =rst.substring(0,Math.min(rst.length()-1,strs[i].length()));
       }
   }
   return rst;
}
```

### 718 最长公共子串40ms 90%
```java
public int findLength(int[] a,int[] b){
    int m = a.length,n = b.length;
    if(m==0||n==0)return 0;
    int[][] dp = new int[m+1][n+1];
    int max= 0;
    for(int i=m-1;i>=0;i--){
        for(int j=n-1;j>=0;j--){
            max = Math.max(max,dp[i][j]=a[i]==b[j]?1+dp[i+1][j+1]:0);
        }
    }
    return max;
}
```
rolling hash
https://leetcode.com/problems/maximum-length-of-repeated-subarray/solution/


### 括号串达到匹配需要最小的逆转次数
> Input:  exp = "}}}{"
> Output: 2 

将匹配的括号都去掉，`{`的个数是m=3，`}`的个数是n=3
m/3+n/2 = 2+1=3
![minbracket.jpg](/images/minbracket.jpg)
```java
private int minReversal(String s){
    int len = s.length();
    if((len&1)!=0)return -1;
    Deque<Character> que = new ArrayDeque<>();
    int n=0;
    for(int i=0;i<s.length();i++){
        char c = s.charAt(i);
        if(c=='}'&&!s.isEmpty()){
            if(que.peek()=='{')que.pop();
            else {
                que.push(c);
            }
        }
    }
    int mn = que.size();
    while (!que.isEmpty()&&que.peek()=='{'){
        que.pop();
        n++;
    }
    //当m+n是偶数的时候ceil(n/2)+ceil(m/2)=
    return (mn/2+n%2);
}
```


### 28字符串indexOf匹配暴力 Substring Search
各种字符串匹配算法
http://www-igm.univ-mlv.fr/~lecroq/string/
![strstrbest.jpg](/images/strstrbest.jpg)
https://algs4.cs.princeton.edu/53substring/
![backup](/images/backup.jpg)
方法1是维持一个pattern长度的buffer
![substring.jpg](/images/substring.jpg)
流的情况下 没有backup
```
ADA B RAC
ADA[C]R i-=j
 ADACR
```

#### !!!Boyer-Moore 74% 5ms 亚线性
alg4
1.构建right表示target中字符的最右位置是NEEDLE
![boyerright.jpg](/images/boyerright.jpg)
2.source从左到右扫描，target从右向左
如果出现不匹配T是target里没有的，i到j+1
如果出现不匹配N是target里的，则用right，将target里N的位置和它对齐
![boyerright2.jpg](/images/boyerright2.jpg)
当前j=3,right['N'] = 0,skip=3
第三种情况，至少保证i不能回退
![boyer3.jpg](/images/boyer3.jpg)

```java
 public int strStr(String source, String target) {
    if(source.length()<target.length())return -1;
        if(target==null||target.length()==0)return 0;
        int R = 256;
        int[] right = new int[R];
        for (int c = 0; c < R; c++)
        right[c] = -1;
        for (int j = 0; j < target.length(); j++)
            right[target.charAt(j)] = j;
        int m = target.length();
        int n = source.length();
        int skip;
        for (int i = 0; i <= n - m; i += skip) {
            skip = 0;
            for (int j = m-1; j >= 0; j--) {
                if (target.charAt(j) != source.charAt(i+j)) {
                    skip = Math.max(1, j - right[source.charAt(i+j)]);
                    break;
                }
            }
            if (skip == 0) return i;
        }
        return -1;
}
```

#### RabinKarp 31% 8ms 线性
![rabin-karp](/images/rabin-karp.jpg)
![ranbinmod.jpg](/images/ranbinmod.jpg)

正确性：
![kbright.jpg](/images/kbright.jpg)
线性求mod
```java
//    private long longRandomPrime(){
//        BigInteger prime = BigInteger.probablePrime(31,new Random());
//        return prime.longValue();
//    }
int R = 256;
long q;

private long hash(String key, int m) {
    long h = 0;
    for (int j = 0; j < m; j++)
        h = (R * h + key.charAt(j)) % q;
    return h;
}
    //变成拉斯维加斯算法
private boolean check(String source,String target, int i) {
    for (int j = 0; j <target.length() ; j++)
        if (target.charAt(j) != source.charAt(i + j))
            return false;
    return true;
}
public  int searchRabinKarp(String source,String target){
    if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int R = 256;
    int m = target.length();
    int n = source.length();
    long RM = 1;
    q = 1877124611;//保证不冲突
    for (int i = 1; i <=m-1 ; i++) {
        RM = (R * RM) % q;
    }
    long patHash = hash(target,m);
    long txtHash = hash(source, m);
   
    //一开始就匹配成功
    if ((patHash == txtHash) && check(source,target, 0))
        return 0;

    // check for hash match; if hash match, check for exact match
    for (int i = m; i < n; i++) {
        // Remove leading digit, add trailing digit, check for match.
        txtHash = (txtHash + q - RM*source.charAt(i-m) % q) % q;
        txtHash = (txtHash*R + source.charAt(i)) % q;

        // match
        int offset = i - m + 1;
        if ((patHash == txtHash) && check(source, target,offset))
            return offset;
    }

    // no match
    return -1;

}
```

#### 187 rolling-hash DNA序列中出现2次以上长为10的子串
//todo

#### 暴力 O（MN）
双指针
i的位置是txt已匹配过的最后位置
15% 13ms
```java
public int strStr(String source, String target) {
    if(source.length()<target.length())return -1;
    if(source==null||source.length()==0)return 0;
    int i,N = source.length();
    int j,M = target.length();
    for (i = 0,j=0; i <N&&j<M ; i++) {
        if(source.charAt(i)==target.charAt(j))j++;
        else{
            i-=j;
            j=0;
        }
    }
    if(j==M)return i-M;
    else return -1;
}
```

按indexOf简化 43% 7ms
```java
public int strStr(String source, String target) {
if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int lens = source.length();
    int tar = target.length();
    char[] targetArr = target.toCharArray();
    char[] sourceArr = source.toCharArray();
    char first = targetArr[0];
    int max = lens-tar;
    for (int i = 0; i <= max ; i++) {
        if(sourceArr[i]!=first){
            while (++i<=max&&sourceArr[i]!=first);
        }
        if(i<=max){
            int j = i+1;
            int end = j+tar-1;
            for (int k = 1; j <end&&sourceArr[j]==targetArr[k] ; k++,j++) ;
            if(j == end)return i;
        }
    }
    return -1;
}
```

java `indexOf`实现
- 最长公共前缀：indexOf
73% 5ms
```java
public int strStr(String source, String target) {
   return indexOf( source.toCharArray(),0,source.length(),target.toCharArray(),0,target.length(),0);
}
```

{% fold %}
```java
/*
@param source:左值（被查找）
@param count长度
*/
 static int indexOf(char[] source, int sourceOffset, int sourceCount,
            char[] target, int targetOffset, int targetCount,
            int fromIndex) {
        // 查找位置>=左值长度
        if (fromIndex >= sourceCount) {
            //traget空？返回左值长度
            return (targetCount == 0 ? sourceCount : -1);
        }
        if (fromIndex < 0) {
            fromIndex = 0;
        }
        // 右值为0，返回查找位置
        if (targetCount == 0) {
            return fromIndex;
        }

        char first = target[targetOffset];
        //最后一个匹配的下标，至少减去右值的长度
        int max = sourceOffset + (sourceCount - targetCount);

        for (int i = sourceOffset + fromIndex; i <= max; i++) {
            /* Look for first character. */
            if (source[i] != first) {
                while (++i <= max && source[i] != first);
            }

            /* Found first character, now look at the rest of v2 */
            if (i <= max) {
                int j = i + 1;
                int end = j + targetCount - 1;
                for (int k = targetOffset + 1; j < end && source[j]
                        == target[k]; j++, k++);

                if (j == end) {
                    /* Found whole string. */
                    return i - sourceOffset;
                }
            }
        }
        return -1;
    }
```
{% endfold %}
 
### KMP-Knuth-Morris-Pratt 适合查找自我重复的字符串 线性的M倍
基于DFA
![DFA.jpg](/images/DFA.jpg)
用一个dfa[][]记录j回退多远
1对target构建dfa
构造DFA的时间是O（MR）的，可以对每个状态设置一个匹配/非匹配去掉R
9ms 24%
```java
public static int serachByKMP(String source,String target){
    if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int M = target.length();
    int N = source.length();
    int[] dfa = new int[M];
    int k = 0;
    dfa[0] =0;
    //For the pattern “AAACAAAAAC”,
    //lps[] is [0, 1, 2, 0, 1, 2, 3, 3, 3, 4]
    for (int i = 1; i < M; i++) {
        while (k>0&&target.charAt(k)!=target.charAt(i))
            k = dfa[k-1];
        if(target.charAt(k)==target.charAt(i)){
            k++;
        }
        dfa[i]=k;
    }
    int q = 0;
    //[0, 0, 0, 1, 0]
    //"mississippi", 
    // "issip"     q=4 i=5 dfa[3]=1
    // "issip"     q=1 i=5
    //    "issip" 
    for (int i = 0; i <N ; i++) {
        while(q>0&&target.charAt(q)!=source.charAt(i))
            q = dfa[q-1];
        if(target.charAt(q)==source.charAt(i))
            q++;
        if(q==M)
            return i-M+1;
    }
    return -1;
}
```
![dfaconstruction.jpg](/images/dfaconstruction.jpg)
![KMPDFA.jpg](/images/KMPDFA.jpg)
2.对source遍历一遍dfa
12.44% 39ms
```java
public int strStr(String source, String target) {
 if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int R = 256;
    int M = target.length();
    int[][] dfa = new int[R][M];
    //构建DFA
    dfa[target.charAt(0)][0] =1;
    for(int X = 0,j=1;j<M;j++){
        for (int c = 0; c < R; c++)
            dfa[c][j] = dfa[c][X];//复制上一列匹配失败
        dfa[target.charAt(j)][j] = j+1;//更新匹配成功
        X = dfa[target.charAt(j)][X];//重启状态
    }
    //模拟一遍DFA
    int i,j,N = source.length();
    for (i = 0,j=0; i  < N&&j< M; i++) {
        j = dfa[source.charAt(i)][j];
    }
    if(j==M) return i-M;
    else return -1;
}
```
文本串T某个前缀的后缀是模式串P的前缀。取最长的后缀。
1 子序列 不连续 2 字串 连续
KMP:getIndexOf
d之前【最长前缀】和【最长后缀】的匹配长度
(abcabc)d 前缀：(a->ab->abc->...->abcab) 后缀:(c->bc->abc->...->bcabc)
所以最长匹配是3：abc,记录在d位置上
int[]next =  f("abcabcd")={-1,0,0,1，2，3}
关键加速求解匹配




### 3 最长不重复字串
18%
```java
public int LS(String s){
    int max = 0;
    int start = 0;
    Map<Character,Integer> map = new HashMap<>();
    for(int i =0;i<s.length();i++){
        char c = s.charAt(i);
        if(map.containsKey(c)){
            start = Math.max(start,map.get(c)+1);
        }
        max = Math.max(max,i-start+1);
        map.put(c,i);
    }
    return max;
}
```


### 879
G 名成员 第i种犯罪会产生`profit[i]` 利润，需要`group[i]`名成员参与。计划产生P利润有多少种方案。
>Input: G = 5, P = 3, group = [2,2], profit = [2,3]
>output: 2

`dp[k][i][j]` 产生i利润 用j个人 完成前k个任务 的方案数


### 576 无向图访问所有点的最短边数

### fraction 背包问题
Items can be broen down 贪心按value/weight排序
![knapsack.jpg](/images/knapsack.jpg)

### 顶点覆盖
![pointcover.jpg](/images/pointcover.jpg)
![vetexcover.jpg](/images/vetexcover.jpg)

### 最大团：在一个无向图中找出一个点数最多的完全图

### 任务分配问题一般可以在多项式时间内转化成最大流量问题

### hdu 1813 IDA*搜索Iterative Deepening A*,


### tsp 
最小生成树解TSP
![MSTTSP.jpg](/images/MSTTSP.jpg)
这样求得的最优解不超过真正最优解的2倍
证明：2-近似算法
任何一个哈密顿回路OPT删去一条边就是一个生成树。
我们找的是最小生成树T肯定小于哈密顿回路减1条边的生成树长度
所以T<OPT
所以欧拉回路<2OPT
因为抄近路不会增加长度所以MST生成的结果不会超过2OPT

最小权匹配算法MM
![MMTSP.jpg](/images/MMTSP.jpg)
1.奇数度的顶点一定是偶数个，将偶数个奇数度定点两两配对
2.将每个匹配加入最小生成树，每个顶点都变成偶数度，得到欧拉图
3.沿着欧拉回路跳过走过的点抄近路 得到哈密顿回路
证明：不超过最优解的1.5倍

代价函数：
在搜索树结点计算的最大化问题以该节点为根的值（可行解/目标函数）的上界。
父节点不小于子节点（最大化问题）

界：到达叶节点得到的最优值
![pagbb.jpg](/images/pagbb.jpg)
![bbtsp.jpg](/images/bbtsp.jpg)


optaPlanner
![optaplanner.jpg](/images/optaplanner.jpg)
1. 数学公式定义
2. 随机算法模板
2.1 迭代局部搜索

tsp数据集
https://comopt.ifi.uni-heidelberg.de/software/TSPLIB95/

https://docs.optaplanner.org/7.10.0.Final/optaplanner-docs/html_single/index.html#travelingTournament
TSPP:tsp with profit（在顶点上）分3种
1. PTP(profitable tour problem)找到最小 cost-profit 的circuit
2. OP(orienteering problem),也叫selective TSP(STSP)。cost是约束，求不超过cost的最大profit
3. PCTSP（prize-collecting)profit是约束，目的是找到不低于profit的最小cost。

数据：
遗传算法：
最大效益中國郵差問題


time window on vertex OP 

 VRP

0~3的tspdp解法
![tspdp.jpg](/images/tspdp.jpg)

### 17 九宫格输入法数字对应的字符串
```java
private String[] letters = {"","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"};
private void help(List<String> rst,int idx,String digits,String cur){
    if(cur.length()==digits.length()){
        rst.add(cur);
        return;
    }
    if(digits.charAt(idx)>='2'&&digits.charAt(idx)<='9'){
        String num2letter = letters[digits.charAt(idx)-'0'];
        for(int i =0;i<num2letter.length();i++){
            help(rst,idx+1,digits,cur+num2letter.charAt(i));
        }   
    }
}
```

### 93 分解Ip地址
dfs
```java
private void dfs(List<String> rst,String s,int idx,String cur,int cnt){
    if(cnt>4)return;
    if(cnt==4&&idx==s.length()){
        rst.add(cur);
    }
    for(int i =1;i<4;i++){
        if(idx+i>s.length())break;
        String tmp = s.substring(idx,idx+i);
        if((tmp.startsWith("0")&&tmp.length()>1)||(i==3&&Integer.parseInt(tmp)>=256))continue;
        dfs(rst,s,idx+i,cur+tmp+(cnt==3?"":"."),cnt+1);
    }
}
```

### ip2cidr
找末尾1的位置`x & -x`



### 131 

### 54旋转矩阵
![rotate2d.jpg](/images/rotate2d.jpg)
top=0,bot=3,left=0,right = 3
n是矩阵大小n>1的时候继续，每一圈，矩阵大小-=2
将2赋值给8：
[top+i][right]=[top][left+i]
i=3:3赋值给12
每个i要赋值4遍，上下左右
外层完了之后子问题是top++,left++,right--,bot--,n-=2

方法2：翻转？

### 59 生成nxn的旋转矩阵

### 49 
直接拿CharArray的sort重建String当key 49%





### 435 去掉最少区间使区间不重叠
```java
Arrays.sort(intervals,(a,b)->{a.end!=b.end?(a.end-b.end):(a.start-b.start)});
```
性能很慢44ms
换 提升到2ms 打败了100%
```java
Arrays.sort(intervals,new Comparator<Inteval>(){
    public int compare(Interval a,Interval b){
        if(a.start==b.start)return a.end-b.end;
        return a.start-b.start;
    }
})
```

`算法：按start排序，如果重叠了，end更新成min(end1,end2)`



### 697 保留数组中最高频出现数字频数的最短数组长度
> Input: [1,2,2,3,1,4,2]
> 最小连续子数组，使得子数组的度与原数组的度相同。返回子数组的长度
> Output: 6 最高频是2->【2,2,3,1,4,2】
用3个hashmap扫一遍记录每个数字出现的cnt,left,right
最后cnt最大的right-left+1
合并成一个hashmap<Integer,int[3]>


### 819 找出句子中出现频率最高没被ban掉的词
正则去掉所有标点
> "Bob hit a ball, the hit BALL flew far after it was hit."

pP 其中的小写 p 是 property 的意思，表示 Unicode 属性，用于 Unicode 正表达式的前缀。

大写 P 表示 Unicode 字符集七个字符属性之一：标点字符。
其他六个是
L：字母；
M：标记符号（一般不会单独出现）；
Z：分隔符（比如空格、换行等）；
S：符号（比如数学符号、货币符号等）；
N：数字（比如阿拉伯数字、罗马数字等）；
C：其他字符
P：各种标点

```java
//busymannote
// [Bob, hit, a, ball, the, hit, BALL, flew, far, after, it, was, hit]
paragraph.split("\\PL+");
// Bob hit a ball the hit BALL flew far after it was hit
paragraph.replaceAll("\\pP","");
paragraph.replaceAll("[^a-zA-Z ]", "")
```

```java
public String mostCommonWord(String paragraph, String[] banned) {
 Set<String> ban = new HashSet<>(Arrays.asList(banned));
    Map<String,Integer> cnt = new HashMap<>();
    String[] split = paragraph.toLowerCase().split("\\PL+");
    for(String s:split)if(!ban.contains(s))cnt.put(s,cnt.getOrDefault(s,0 )+1);
    return Collections.max(cnt.entrySet(),Map.Entry.comparingByValue()).getKey();
}
```




### 亚线性算法o(n)小于输入规模
亚线性时间：
[scale-free network](https://zh.wikipedia.org/wiki/%E6%97%A0%E5%B0%BA%E5%BA%A6%E7%BD%91%E7%BB%9C)S：
大部分节点只和很少节点连接，而有极少的节点与非常多的节点连接。
网络中随机抽取一个节点，它的度是多少呢？这个概率分布就称为节点的度分布
![scalenetwork.jpg](/images/scalenetwork.jpg)
顶点的度满足幂律分布（也称为帕累托分布）,所以不能均匀采样计算每个人的平均度数。

亚线性空间
中位数问题，知道所有的输入，有O(n)的分治算法

### 水库抽样Reservpor Sampling 亚线性空间
> “给出一个数据流，这个数据流的长度很大或者未知。并且对该数据流中数据只能访问一次。请写出一个随机选择算法，使得数据流中所有数据被选中的概率相等。”

当扫描到前n个数字时，保留数组中k个均匀的抽样
1.k大小的数组
2.填充k个元素
3.收到第i个元素t。以k/i的概率替换A中的元素。这样保证收到第i个数字的时候，i在k中的概率是k/i。
实现：生成`[1..k..i]`中随机数j，如果j<=k（k/i的概率),A[j]=t
证明：第i个数接收时有k/i的概率在k数组中，当第i+1个数接收时,i+1有k/(i+1)概率在数组k中，并且刚好替换掉的是第i个数的概率是k中选i：1/k，所以第i+1个数来之后i还在k中的概率是（1-k/(i+1)\*1/k)=（1-1/(1+i)）
![shuku.jpg](/images/shuku.jpg)
```java
private void select(int[] stream,int n,int k){
    int[] reserve = new int[k];
    int i;
    for(i=0;i<k;i++){
        reserve[i]=stream[i];
    }
    Random r = new Random();
    for(;i<n;i++){
        int j = r.nextInt(i+1);
        if(j<k)reserve[j]=stream[i];
    }//sout
}
```

### 398 数组中重复元素随机返回index
> int[] nums = new int[] {1,2,3,3,3};
Solution solution = new Solution(nums);

> // pick(3) should return either index 2, 3, or 4 randomly. Each index should have equal probability of returning.
solution.pick(3);

> // pick(1) should return 0. Since in the array only nums[0] is equal to 1.
solution.pick(1);

水库抽样：流式处理，空间复杂度O(1),pick O(N)
如果用hashmap，初始化O(N)时间，O（N）空间，数组太大就不行。
```java
class Solution {
    int[] nums;
    Random r;
    public Solution(int[] nums) {
        this.nums=nums;
        this.r = new Random();
    }
    
    public int pick(int target) {
        int cnt =0;
        int rst =-1;
        for(int i=0;i<nums.length;i++){
            if(nums[i]!=target)continue;
            //以1/++cnt的概率抽这个数
            // int j = r.nextInt(++cnt);
            // if(j==0)rst=i;
            else{//不赋值变量从180ms->127ms
            if(r.nextInt(++cnt)==0)rst=i;
            }
        }
        return rst;
    }
}
```

### ？？382 随机链表 extremely large and its length is unknown
长度不知，读到第三个node，让它的概率变成1/3，用1/3的概率替换掉之前选择的item
> 由于计算机产生的随机数都是伪随机数，对于相同的随机数引擎会产生一个相同的随机数序列，因此，如果不使用静态变量（static），会出现每次调用包含随机数引擎的函数时，随机数会重新开始产生随机数，因此会产生相同的一串随机数。比如你第一次调用产生100个随机数，第二次调用仍然会产生这一百个随机数。如果将随机数引擎设置为静态变量，那么第一次调用会产生随机数序列中的前100个随机数，第二次调用则会产生第100到200的随机数。

### 频繁元素计算 Misra Gries(MG)算法


### 最小生成树

### 笛卡尔树

### 链式前向星


### 堆排序不稳定

![stringsort.jpg](/images/stringsort.jpg)
测试：6 5 12 至少都比内置的快
{% fold %}
```java
 public static void main(String[] args) {
        String str="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        String[] words2 = new String[10000];
        Random random=new Random();
        for (int  j= 0; j <words2.length ; j++) {
            StringBuffer sb=new StringBuffer();
            int length = random.nextInt(30);
            for(int i=0;i<length;i++){
                int number=random.nextInt(62);
                sb.append(str.charAt(number));
            }
            words2[j] = sb.toString();
        }
        String[] word3 = words2.clone();
        String[] word4 = words2.clone();
        long start = System.currentTimeMillis();
        sort(words2, 0,words2.length-1 ,0 );
        long end = System.currentTimeMillis();
        System.out.println(end-start);
        long start2 = System.currentTimeMillis();
        MSD.sort(word3);
        long end2 = System.currentTimeMillis();
        System.out.println(end2-start2);

        long start3 = System.currentTimeMillis();
        Arrays.sort(word4);
        long end3 = System.currentTimeMillis();
        System.out.println(end3-start3);

    }
```
{% endfold %}

### 三向快速排序 不稳定
![threepart.jpg](/images/threepart.jpg)
取第一位，将所有字符串分成3份
{% fold %}
```java
public class threewaypart {
    private static int charAt(String s,int d){
        if(s.length()>d)return s.charAt(d);
        else return -1;
    }
    private static void swap(String[] a ,int i,int j){
        String tmp = a[i];
        a[i]=a[j];
        a[j]=tmp;
    }
    private static void sort(String[] a,int lo,int hi,int d){
        if(hi<=lo)return;
        int lt = lo,gt = hi;
        int v = charAt(a[lo],d);
        int i = lo+1;
        while (i<=gt){
            int t = charAt(a[i],d);
            if(t<v)swap(a,lt++,i++);
            else if(t>v)swap(a,i,gt--);
            else i++;
        }
        sort(a,lo,lt-1,d);
        if(v>=0)sort(a, lt, gt, d+1);
        sort(a,gt+1,hi , d );
    }

    public static void main(String[] args) {
        String[] words = {"4PGC938","2iye230","2iye231","3cio720","fds","1","4PGC933","4PGC9382","4PGC9384","4PGC9385","4PGC9387","4PGC9388","4PGC9389"};
       sort(words,0 , words.length-1,0 );
        System.out.println(Arrays.toString(words));
    }
}

```
{% endfold %}

### MSD most-significant-digit-first 不用长度相同从左开始
一般也是NW复杂度，对于N很大的情况可以达到$Nlog_RN$
![MSD](/images/MSD.jpg)
ASCII的R是256，需要count[258]
Unicode需要65536，可能要几小时
按第0位分组，对每组递归按第1位分组...n
![MSD2](/images/MSD2.jpg)
当前前d位都相同的组，组内字符串个数小于15，用插入排序
{% fold %}
```java
import java.util.Arrays;

public class MSD {
private static String[] aux;
private static int R = 256;
private static final int M = 3;
private static int charAt(String s,int d){
    if(s.length()>d)return s.charAt(d);
    else return -1;
}
public static void sort(String[] a){
    aux = new String[a.length];
    sort(a,0,a.length-1,0);
}
private static boolean less(String v,String w,int d){
    for (int i = d; i <Math.min(v.length(),w.length()) ; i++) {
        if(v.charAt(i)<w.charAt(i))return true;
        if(v.charAt(i)>w.charAt(i))return false;
    }
    return  v.length()<w.length();
//        return v.substring(d).compareTo(w.substring(d))<0;
}
private static void sort(String[] a,int lo,int hi,int d){
    if(hi<=lo)return;
    //添加一步阈值，如果a长度太小，直接用插入排序
    if(hi<=lo+M){
        for (int i = lo; i <=hi ; i++) {
            for (int j = i; j >lo&&less(a[j],a[j-1],d);j--) {
                String tmp = a[j];
                a[j]=a[j-1];
                a[j-1]=tmp;
            }
        }
        return;
    }
    //0位留作字符串结尾？
    int[] count = new int[R+2 ];
    for (int i = lo; i <=hi ; i++) {
        count[charAt(a[i],d)+2]++;
    }
    for (int i = 0; i <R+1 ; i++) {
        count[i+1]+=count[i];
    }
    for (int i = lo; i <=hi ; i++) {
        aux[count[charAt(a[i],d)+1]++] = a[i];
    }
    for (int i = lo; i <=hi ; i++) {
        a[i] =aux[i-lo];
    }
    for (int i = 0; i <R ; i++) {
        sort(a,lo+count[i],lo+count[i+1]-1,d+1);
    }
}

public static void main(String[] args) {
    String[] words = {"4PGC938","2iye230","2iye231","3cio720","fds","1","4PGC933","4PGC9382","4PGC9384","4PGC9385","4PGC9387","4PGC9388","4PGC9389"};
    sort(words);
    System.out.println(Arrays.toString(words));
}
}
```
{% endfold %}


### LSD 基数排序radix sort 定长字符串 复杂度WN  低位优先
![LSD](/images/LSD.jpg)
长度相同的字符串，从最后一位开始排序
（如何应用到变长字符串？）
```java
public static void sort(String[] a,int w){
    int N = a.length;
    int R = 256;
    //只初始化一次
    String[] aux = new String[N];
    for (int d = w-1; d >=0 ; d--) {
        int[] count = new int[R+1];

        for (int i = 0; i <N ; i++) {
            count[a[i].charAt(d)+1]++;
        }
        for (int i = 0; i <R ; i++) {
            count[i+1]+=count[i];
        }
        for (int i = 0; i <N ; i++) {
            aux[count[a[i].charAt(d)]++]=a[i];
        }
        for (int i = 0; i < N; i++) {
            a[i]=aux[i];
        }

    }

}
```

### key-index count sort键索引计数法 稳定的
![indexsort](/images/indexsort.jpg)
count:[0, 2, 3, 1, 2, 1, 3]
累加cnt[0, 2, 5, 6, 8, 9, 12] 起始索引
结果[a, a, b, b, b, c, d, d, e, f, f, f]
```java
static int[] count = new int[7];
static private int[] countt(String s){
    int N = s.length();
    for (int i = 0; i <N ; i++) {
        //关键 +1
        count[s.charAt(i)-'a'+1]++;
    }
    return count;
}
static private int[] acu(){
    for (int i = 0; i < count.length-1; i++) {
        count[i+1]+=count[i];
    }
    return count;
}
static private char[] axuu(String s){
  char[] axu = new  char[s.length()];

    for (int i = 0; i < s.length(); i++) {
        //关键 ++
        axu[count[s.charAt(i)-'a']++] = s.charAt(i);
    }
    return axu;
}
System.out.println(Arrays.toString(countt("dacffbdbfbea")));
System.out.println(Arrays.toString(acu()));
String dacffbdbfbea = Arrays.toString(axuu("dacffbdbfbea"));
```

### 611数组中符合三角形边长的对数 
线性扫描 复杂度n^2
![lc611.jpg](/images/lc611.jpg)

### 数组组成三角形的最大周长nlogn
贪心，排序，如果 $a[i]<a[i-1]+a[i-2]$ 则没有其他两条边可以两边之和`>`第三边了，换下一条当最长边。
```java
public int maxC(int[] A){
    Arrays.sort(A);
    int n = A.length;
    for (int i = n-1; i >=2 ; i--) {
        if(A[i]<A[i-1]+A[i-2])return A[i]+A[i-1]+A[i-2];
    }
    return 0;
}
```

### MST：
将图的点分成2个集合，用边连接两个集合中的点，最小的边集是MST


### MST和聚类：
连通图
将图的点分成2个集合，边两端连的是不同集合，最小的边集是MST
![mst](/images/mst.jpg)
假设分为6和其它点2个集合，在6-2 3-6 6-0 6-4四条连接两个集合的边中取最小边，标记成黑色。
再随机分两个集合，不要让黑色边跨集合

#### kruskal
kruskal遍历所有边(优先队列)，判断边的两点是否在一个集合里(find)，如果在则说明这条边加上会有环，如果不在，则union(v,w)并且将这条边加入mst。直到找到n-1条边。
复杂度$ElogE$ 空间E
- 因为不仅维护优先队列还要union-find所以效率一般比prim慢

#### prim
prim复杂度$ElogV$ 空间V
prim优化：将marked[]和emst[] 替换为两个顶点索引数组edgeTo[] 和distTo[]
![prim.jpg](/images/prim.jpg)
每个没在MST中的顶点只保留(更新)离mst中点最短的边。

### 聚类：single link
![singlelink.jpg](/images/singlelink.jpg)
![singleclu.jpg](/images/singleclu.jpg)



#### 前序ABCDEFGH->中序不可能是

### 145 后序遍历二叉树 
1.函数式编程 不用help函数（可变数组），复制数组

{% fold %}
```java
public List<Integer> post(TreeNode root){
    List<Integer> list = new ArrayList<>();
    if(root==null)return list;
    List<Integer> left = post(root.left);
    List<Integer> right = post(root.right);
    list.addAll(left);
    list.addAll(right);
    list.add(root.val);
    return list;
}
```
{% endfold %}

原理：
```python
rev_post(root):
    # 全部反过来刚好是后序遍历
    print(root->val);
    rev_post(root->right)
    rev_post(root->left)
reverse(rev_post(root));
```

方法1：
```java
public List<Integer> postorderTraversal(TreeNode root) {
    LinkedList<Integer> list = new LinkedList<>();
     if(root==null)return list;
    Deque<TreeNode> stack = new ArrayDeque<>();
    stack.push(root);
    while(!stack.isEmpty()){
        root = stack.pop();
        list.addFirst(root.val);
        if(root.left!=null)stack.push(root.left);
        //下一次poll出的是右子树
        if(root.right!=null)stack.push(root.right);
    }
    // 如果使用ArrayList 1%
    //Collections.reverse(list);
    return list;
}
```

### 753 输出能包含所有密码可能性的最短串
> Input: n = 2, k = 2
> Output: "00110" 包含了00,01,10,11

[官方解](https://leetcode.com/problems/cracking-the-safe/solution/)
[de Bruijn Card Trick](https://www.youtube.com/watch?v=EWG6e-yBL94)
1. 方法1
![hamilton](/images/lc753.jpg)
每个点1次
写出n个数的组合(11,12,22,21) 并找出哈密尔顿路径
2. 方法2 
![euler](/images/lc7532.jpg)
每条边1次
写出(n-1)个数的组合(1,2) 的完全图，找出欧拉环路(circuit)。de Bruijn 序列的数量为欧拉环的数量。
用k个数字，长度有n的组合有$k^n$种，但是因为可以首尾相连，总共de Bruijn的数量是
$\frac{k! k^{n-1}}{k^n}$
3. 方法3 用不重复的最小字典序Lyndon Word
例子：
1.列出所有长度为4的组合1111,1112...以及能被4整除的长度(1,2)的组合1,2,11,22.
2.所有按字典序排序
3.去除所有旋转之后相同的组合，只保留字典序最小的：01和10只保留01
> n = 6, k = 2
> 0 000001 000011 000101 000111 001 001011 001101 001111 01 010111 011 011111 1
4. 连起来就是最小的de Bruijin sequence

#### Inverse Burrows-Wheeler Transform (IBWT) 生成 Lyndon words.  

### 332 欧拉路径 每条边一次
(这道题不用判断)
只有1个点入度比出度少1（起点）&& 只有一个点入度比出度多1（终点）其余点入度==出度

#### Hierholzer：O(e)
删除边`e(u,v)`，并`dfs(v)`，不断寻找封闭回路，

> 从v点出发一定会回到v。因为入度出度相等。虽然可能不包含所有点和边。
> 总是可以回到以前的点，从另一条路走，把其它所有的边全部遍历掉。

**不是拓扑排序，拓扑排序每个点仅1次**
![Hierholzer](/images/Hierholzer1.jpg)
path里加入{0},{2}头插法{2,0}//保证远的在后面
dfs回到1，继续找封闭回路
![Hierholzer](/images/Hierholzer2.jpg)

> Input: tickets = `[["MUC", "LHR"], ["JFK", "MUC"], ["SFO", "SJC"], ["LHR", "SFO"]]`
> Output: `["JFK", "MUC", "LHR", "SFO", "SJC"]`

1. 用hashmap记录每个点的出度的点，建图
2. 输出字典序靠前的序列，用优先队列，先访问的会后回溯到dfs插到链表头。（后序遍历：全部遍历完了再加入（退栈)）

```java
public List<String> findItinerary(String[][] tickets) {
    LinkedList<String> rst = new LinkedList<>();
    
    Map<String,PriorityQueue<String> > map = new HashMap<>();
    for(String[] edge:tickets){
        PriorityQueue<String> nei = map.getOrDefault(edge[0],new PriorityQueue<String>());
        nei.add(edge[1]);
        map.put(edge[0],nei);
    }
    dfs(rst,map,"JFK");
    return rst;
}
private void dfs(LinkedList<String> rst,Map<String,PriorityQueue<String> > map,String start){
  PriorityQueue<String> pri = map.get(start);
    while(pri!=null&&!pri.isEmpty())
        dfs(rst,map,pri.poll());
    rst.addFirst(start);  
}
```
后序遍历stack：
```java

```



### 两个帅不能处在同一条直线上的所有可行位置
```
1 2 3
4 5 6
7 8 9
```
```cpp
#include<iostream>
using namespace std;
int main(){
    int i = 81;
    while(i--){
        if(i/9%3==i%9%3)continue;
        cout<<i/9+1<<" "<<i%9+1<<endl;
    }
} 
```


### 翻煎饼排序的最少次数



### 279完美平方数？？？

### 198

### 164 桶排序找区间最大值

### 求数组的最大gap

### 二分图 让每条边的两个顶点属于不同的集合
![bipartite.jpg](/images/bipartite.jpg)
max match：没有两点共享1点，最多的边数
![matching](/images/matching.jpg)
maximal:再加一条边就有两条边有共同顶点了
maximum：有两种matching的画法，3条边的为max

1. 室友分配问题不是二分图，因为有3人团，是最大团问题
2. 出租车和乘客匹配问题 问题是求最小边和
3. 分配老师给班级是二分图max match问题

#### 785 是否是二分图
```
输入[0]={1,3}0的邻点是1,3
[[1,3], [0,2], [1,3], [0,2]]
The graph looks like this:
0----1
|    |
|    |
3----2
```
不用建图，已经是邻接表了。
按算法4上75%
还可以优化mark和color为一个数组，用位运算变更状态，变成boolean的dfs
```java
boolean[] marked;
boolean[] color;
boolean isTwo = true;
public boolean isBiartie(int[][] graph){
    marked = new int[graph.length];
    color = new int[graph.length];
    for(int s =0;s<graph.length;s++){
        if(!marked[s])dfs(graph,s);
    }
    return isTwo;
}
private void dfs(int[][] G,int v){
    marked[v]=true;
    for(int w :G[v]){
        color[w]=!color[v];
        dfs(G,w);
    }else if(color[w]==color[v])isTwo=false;
}
```
改成boolean的dfs->100%
```java
boolean[] marked;
boolean[] color;
public boolean isBipartite(int[][] graph) {
    marked = new boolean[graph.length];
    color = new boolean[graph.length];
    for (int s = 0; s <graph.length ; s++) {
        if(!marked[s]&&!dfs(graph,s))return false;
    }
    return true;
}
private boolean dfs(int[][] graph,int v){
    marked[v]=true;
    for(int w:graph[v]){
        //*关键
        if(!marked[w]){
        color[w]=!color[v];
        if(!dfs(graph,w))return false;
        }
        else if(color[w]==color[v])return false;
    }
    return true;
}
```

#### 886 给出dislike边集，能不能分成2组，组里没有互相讨厌的人
边集->邻接表->二分图

边集->邻接矩阵->二分图dfs染色
```java
public boolean possibleBiparitition(int N,int[][] dislikes){
    int[][] graph = new int[N][N];
    //边集->无向图 邻接矩阵
    for(int[] d:dislikes){
        graph[d[0]-1][d[1]-1] = 1;
        graph[d[1]-1][d[0]-1] = 1;
    }
    int[] group = new int[N];
    for (int i = 0; i < N; i++) {
        if(group[i] == 0&& !dfs2d(graph,group,i,1))return false;
    }
    return true;
}
//可不可以分到g组
private boolean dfs2d(int[][] graph,int[] group,int idx,int g){
    group[idx] = g;
    //行是邻边
    for (int i = 0; i < graph.length; i++) {
        if(graph[idx][i] == 1){
            if(group[i] == g){
             return false;
            }
            if(group[i] == 0&&!dfs2d(graph,group,i,-g))return false;

        }
    }
    return true;
}
```



### 494 在数字中间放正负号使之==target
递归的2种写法另一种void用全局变量累加
？？为什么递归中不能写`dfs(idx++)`
O(2^n)
```java
private int dfs(int[] nums,int S,int idx){
    if(idx == nums.length){
        if(S==0)return 1;
        else return 0;
    }
    int cnt =dfs(nums, S+nums[pos], pos+1)+dfs(nums, S-nums[pos], pos+1);
    return cnt;
}
```
53% 
优化记忆化：用当前的idx和当前的S当key 注意如果用`String key=idx+""+S`有一个case会报错，应该是数字大的时候混淆了。
sum不会超过1000所以`Integer key = idx*10000+S`就可以通过。

dp??：
所有可能的target最大值是全部正号sum(a),或者全部负号）dp[2\*sum(a)+1]
题目sum最大2k，则dp[4001]


### 图的度
![graphmostuse](/images/graphmostuse.jpg)
1.顶点v的度
```java
public static int degree(Map<Integer,List<Integer>> graph,int v){
    int degree = 0;
    for(int w :graph.get(v)){
        degree++;
    }
    return degree;
}
```
2.所有顶点的最大度
```java
public static int maxDegree(Map<Integer,List<Integer>> graph){
    int max = 0;
    for(int v:graph.keySet()){
        max = Math.max(degree(graph,v ),max);
    }
    return max;
}
```
3.


### 图的遍历顺序
![graphtra](/images/graphtra.jpg)
{% fold %}
```java
public class DepthFirstOrder {
    private boolean[] marked;
    private List<Integer> pre;
    private List<Integer> post;
    private Deque<Integer> reversePost;

    public DepthFirstOrder(int n,int[][] edges){
        List<Integer>[] graph = new ArrayList[n];
        for (int i = 0; i <n ; i++) {
            graph[i] = new ArrayList<>();
        }
        for(int[] edge:edges){
            graph[edge[0]].add(edge[1]);
        }
        marked = new boolean[n];
        pre = new ArrayList<>();
        post = new ArrayList<>();
        reversePost = new ArrayDeque<>();

        for (int i = 0; i <n ; i++) {
            if(!marked[i])dfs(graph,i);
        }
    }
    private void dfs( List<Integer>[] graph ,int v){
        pre.add(v);
        marked[v] = true;
        for(int w :graph[v]){
            if(!marked[w])
                dfs(graph,w);
        }
        post.add(v);
        reversePost.push(v);
    }
/*
[0, 1, 5, 4, 6, 9, 10, 11, 12, 2, 3, 7, 8]
[1, 4, 5, 10, 12, 11, 9, 6, 0, 3, 2, 7, 8]
[8, 7, 2, 3, 0, 6, 9, 11, 12, 10, 5, 4, 1]
*/
    public static void main(String[] args) {
        DepthFirstOrder sl = new DepthFirstOrder(13,new int[][]{{0,1},{0,5},{0,6},{2,0},{2,3},{3,5},{5,4},{6,4},{6,9},{7,6},{8,7},{9,10},{9,11},{9,12},{11,12}});
        System.out.println(sl.pre);
        System.out.println(sl.post);
        System.out.println(sl.reversePost);
    }
}
```
{% endfold %}


### 调度问题：给定一组任务，安排执行时间->拓扑排序
**DAG的拓扑排序是dfs逆后排序**
将一张图拉成边全部向下的图
![tuopu](/images/tuopu.jpg)

#### 拓扑排序：有向环
> {0, 3}, {1, 3}, {3, 2}, {2, 1} 0-> 3->2->1->3
![graphcy](/images/graphcy.jpg)

{% fold %}
```java
//算法4 p386
private boolean[] marked;
private int[] edgeTo;
private Deque<Integer> cycle;//环
private boolean[] onStack;
public Deque cycle(int numCourses, int[][] prerequisites) {
    onStack = new boolean[numCourses];
    edgeTo = new int[numCourses];
    marked =new boolean[numCourses];
    List<Integer>[] graph=new ArrayList[numCourses];
    for (int i = 0; i <numCourses ; i++) {
        graph[i] = new ArrayList<>();
    }
    for (int[] edge :prerequisites) {
        graph[edge[0]].add(edge[1]);
    }
    System.out.println(Arrays.toString(graph));
    for (int i = 0; i < numCourses; i++) {
        if(!marked[i])dfs(graph,i);
    }
    return cycle;
}
private void dfs(List<Integer>[] graph,int v){
    onStack[v] =true;
    marked[v] =true;
   if(graph[v].size()<1)return;
    for(int w:graph[v]){
        if(cycle!=null) return;
        else if(!marked[w]){
            edgeTo[w] = v;
            dfs(graph,w);
        }
        else if(onStack[w]){
            cycle = new ArrayDeque<>();
            for (int x = v; x !=w ; x=edgeTo[x]) {
                cycle.push(x);
            }
            cycle.push(w);
            cycle.push(v);
        }
    }
    onStack[v] =false;
}
```
{% endfold %}


#### ?207 先修课程有环则返回false 拓扑排序
??和并查集的区别（？
按算法4上88.45%
```java
private boolean[] marked;
private boolean cycle = true;
private boolean[] onStack;
public boolean canFinish(int numCourses, int[][] prerequisites) {
    onStack = new boolean[numCourses];
    marked =new boolean[numCourses];
    List<Integer>[] graph=new ArrayList[numCourses];
    for (int i = 0; i <numCourses ; i++) {
            graph[i] = new ArrayList<>();
    }
    //{2,0},{1,0},{3,1},{3,2},{1,3}}->[[], [0, 3], [0], [1, 2]]
    for (int[] edge :prerequisites) {
        graph[edge[0]].add(edge[1]);
    }
    for (int i = 0; i < numCourses; i++) {
            if(!marked[i])dfs(graph,i);
    }
    return cycle;
}
private void dfs(List<Integer>[] graph,int v){
    if(graph[v].size()<1)return;
    //dfs是从起点到v的有向路径，onstack保存了递归中经历的点
    onStack[v] = true;
    marked[v] = true;
    for(int w :graph[v]){
        if(!marked[w])
        dfs(graph,w);
        else if(onStack[w]){
            cycle = false;
            return;
        }
    }
    //这个点出发没有环
    onStack[v] = false;
}
```

56% 有可以优化到100%4ms的方法
1.邻接表存储课程依赖图L
```java
List[] graph_;
public boolean canFinish(int numCourses, int[][] prerequisites) 
    graph_ = new ArrayList[numCourses];
    for(int i =0;i<numCourses;i++)
    {graph_[i] = new ArrayList<Integer>();}
    for(int[] back:prerequisites){
        int pre = back[0];
        int lesson = back[1];
        graph_[lesson].add(pre);
    }
```
2.定义状态`int[] visit = new int[numCourses];`
3.dfs每个顶点
```java
for(int i =0;i<numCourses;i++){
    if(hasCircle(i,visit))return false;
}
return true;
```
4.dfs 检查有没有环
```java
boolean hasCircle(int idx,int[] visited){
    if(visited[idx]==1)return true;
    if(visited[idx]==2)return false;
    List<Integer> neib = graph_[idx];
    for(int i:neib){
        if(hasCircle(i,visited))return true;
    }
    visited[idx]=2;
    return false;
}
```

#### 210 输出修课顺序
> Input: 4, [[1,0],[2,0],[3,1],[3,2]]
  Output: [0,1,2,3] or [0,2,1,3]

用onStack和post 11%

### kolakoski序列找规律
![kolakoski](/images/kolakoski.jpg)

#### lc481 返回kolakoski前N中有几个1



### 174 骑士从左上到右下找公主，求初始血量
dp[i][j]表示到i,j的最少血量，因为右下角一格也要减
dp[n-1][m],dp[n][m-1]=1表示走完了右下角还剩下1点血
dp[0~n-2][m]和dp[n][0~m-2]都是非法值，为了取min设置MAX_VALUE
```java
dp[i][j]=Math.max(1,Math.min(dp[i+1][j],dp[i][j+1])-dungeon[i][j]);
```





### 671 根的值<=子树的值的二叉树中的第二小元素
```
      2
  2       5
4   3(out)
```
1.dfs在set中加入所有节点，遍历set
```java
int min = root.val;
int ans = Long.MAX_VALUE;
for(int v:set){
    if(min<v&&v<ans)ans = v;
}
return ans<Long.MAX_VALUE?(int) ans:-1;
```
2.在dfs的时候只有node.val == root.val的时候表示这个分支需要继续遍历
```java
min = root.val;
int ans = Long.MAX_VALUE;
private dfs(TreeNode rote){
    if(root!=null){
        if(min<root.val&&root.val<ans)
            ans = root.val;
    }else if(min == root.val){
        dfs(root.left);
        dfs(root.right);
    }
}
```




### 伪多项式时间
一个整数是否是素数
```python
def isPrime(n):
    for i in range(2,n):
        if n mod i 
```
运行时间与数值n的二进制位数呈指数增长
整数需要的bit位数x=logn 复杂度$O(2^{x})$
每加1位，时间翻倍
857 ：‭‭001101011001‬
421 ：‭‭000110100101‬

---


### !!97 s1和s2是否交错组成s3
[Solution](https://leetcode.com/problems/interleaving-string/solution/)
状态dp[len1][len2]表示s1长度len1，s2长度len2出现在s3[len1+len2]中
任意位置s3[i]一定是由s1[m],s2[n]组成的
```
s1="aa  bc   c"
s2="  db  bca"
s3="aadbbcbcac"
```
dp行表示当前len1的匹配情况下，不断扩展len2与s3的匹配情况
dp列表示当前len2的匹配情况下，不断扩展len1与s3的匹配情况
```
遍历s3的位置：
  遍历s1的长度，s3+1-s1为s2的长度
    如果s3当前位置与s2当前匹配&&dp[][s2-1]匹配了
       ||s3当前与s1当前匹配并且dp[s1-1][s2]:
         dp[s1][s2] = true
```
可以用滚动数组降成1维

？？？按背包问题递减更新 99%
ct的意义
动态规划中的ct
```java
public boolean isInterleave(String s1, String s2, String s3) {
    if (s1.length() + s2.length() != s3.length()) return false;
    boolean[] dp = new boolean[s1.length() + 1];
    dp[0] = true;
    for (int i = 0; i < s3.length(); i++) {
        boolean ct = true;
        for (int j = Math.min(s1.length(), i + 1); j > 0; j--) {
            if (dp[j] && (i-j)<s2.length() &&s2.charAt(i - j) == s3.charAt(i)) ct = false;
            else if (dp[j - 1] && s1.charAt(j- 1) == s3.charAt(i)){
                dp[j] = true;
                ct = false;
            }else dp[j] = false;
        }
        if(dp[0]&&i<s2.length()&&s2.charAt(i)==s3.charAt(i))ct = false;
        if(ct)return false;
    }
    return true;
}
```

---
### 62 从左上角走到右下角总共有多少种不同方式
f[m][n] = f[m-1][n]+f[m][n-1]
简化成一维dp
```java
public int uniPath(int m,int n){
    int[] res = new int[n];
    for(int i =0;i<m;i++){
        //一行一行扫下去，下一行的底数是上一行，表示从上一行走下来的走法
        for(int j =1;j<n;j++){
            //加上左边走过来的走法
            res[j]+=res[j-1];
        }
    }
    return res[n-1];
}
```

#### !数学公式
m行n列，左上到右下总共步数m+n-2步，可以选择m-1个时间点向下走。
问题可以转换为有(m+n-2)位，可以赋值m-1次1和n-1次0有多少数字。
$C_{m+n-2}^{m-1}$
```java
long rst=1;
for(int i =0;i<Math.min(m-1,n-1);i++){
    rst=rst*(m+n-2-i)/(i+1);
}
return (int)rst;
```

---
### 63 有障碍物的左上到右下
dp[i][j]定义为走到i,j的方法数，障碍物则为0
```java
if(obs[i][j]==1)continue;//dp[i][j]=0//res[j]=0;
```

### 64 从左上角走到右下角的最少sum
grid[n][m]+=Math.min(grid[n-1][m],grid[n][m-1]);

---
### 32 ?括号字符串中合法的括号对
方法1. stack:栈底放-1，当栈空&&读到是`)`将`)`的index当栈底。每次读到`)`弹栈，并更新`i-peek()`，因为peek为没消掉的`(`的前一个位置
方法22. 从左向右扫描，当左括号数==右括号数更新max，当右括号>左括号置0.
  从右向左扫描，同理更新max，当左括号>右括号重置0.

---
### 本福特定律
以1为首位的数字的概率为30%



### 719



### !!!169 众数 Boyer-Moore Voting Algorithm 
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

---


### 节点是随机变量的有向无环图=贝叶斯网络BN
求联合概率会用到最小生成树
1. 如果$84\*148=B6A8$成立，则公式采用的是__进制表示的
$(8\*x+4)\*(x^2+4\*x+8)=11\*x^3+6\*x^2+10\*x+8$
$=>(3x^2+6x+2)(x-12)=0$
$=>x=12$
- 快速算法：84和148末尾4\*8=32实际上是8，则32-8=24是12的倍数
24表示在这种进制下个位应该为0

逆邻接表：A->B->C->D：B,C,D指向A
 
树的前/中/后序遍历本质都是DFS


---
### 402 去掉数字串中k个数字留下最小的数字
Input: num = "1432219", k = 3
Output: "1219"
找最小数字：从高位，越高位越小的数。
算法：从高位开始，如果去掉这个数用后面一位换上来，143->13变小了，则换掉
用栈，下一个位置比栈顶小，则把栈顶换掉。
注意点：如果下一个数字比栈顶小，k>0表示可以替换多少个，向前(栈里)找最多k个应该应该去掉的数，把top放在下一个覆盖的位置。
```java
num="1234567890";
k=9;
for(int i =0;i<len;i++){
    // len=10,k=9  但是0比所有前9个都小，则
while(top!=0&&num.charAt(i)<stack[top-1]&&k>0){
    top--;
    k--;   
    }
    //0覆盖掉1 之后截取stack中len-k=1长度并且去掉0
    stack[top++]=num.charAt(i);
}
```

---
### 236 最低的二叉树公共祖先LCA
方法1：找出两条从root开始的路径，返回路径不开始不相同的前一个点
27%空间两个array
{% fold %}
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    List<TreeNode> pathp = new ArrayList<>();
    List<TreeNode> pathq = new ArrayList<>();
   // if(!findPath(root,p,pathp)||!findPath(root,p,pathp))return 
    findPath(root,p,pathp);
    findPath(root,q,pathq);
    int i;
    for(i = 0;i<Math.min(pathp.size(),pathq.size());i++){
        if(pathp.get(i).val!=pathq.get(i).val)
            break;
    }
    return pathp.get(i-1);
}
private boolean findPath(TreeNode root,TreeNode node,List<TreeNode> path){
    if(root == null)return false;
    path.add(root);
    if(root.val == node.val)return true;
    if(root.left!=null&&findPath(root.left,node,path))return true;
    if(root.right!=null&&findPath(root.right,node,path))return true;
    path.remove(path.size()-1);
    return false;
}
```
{% endfold %}
方法二：只遍历一次树，这种方法如果其中一个q不在树中，会返会p,应该返回null
13%
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if(root==null)return null;
    if(root.val==p.val||root.val==q.val)return root;
    TreeNode left = lowestCommonAncestor(root.left,p,q);
    TreeNode right = lowestCommonAncestor(root.right,p,q);
    if(left!=null&&right!=null)return root;
    return left!=null?left:right;
}
```
这道题两个点都保证存在，可以absent的

终止条件`root==null|root==q||root=p`
1. 在左/右子树找p|q，两边都能找到一个值（因为值不重复） 则返回当前root
2. 如果左边没找到p|q，右边找到了p|q，最低的祖先就是找到的p|q，(因为保证p|q一定在树中)


### 235 BST的LCA
8.9%
```java
TreeNode lcaBST(TreeNode root,TreeNode p,TreeNode q){
    if(root== null)return null;
    if(root.val>p.val&&root.val>q.val)return lcaBST(root.left,p ,q );
    if(root.val<p.val&&root.val<q.val)return lcaBST(root.right,p ,q );
    return root;
}
```
优化1： 13% 9ms
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if(root.val > p.val && root.val > q.val){
        return lowestCommonAncestor(root.left, p, q);
    }else if(root.val < p.val && root.val < q.val){
        return lowestCommonAncestor(root.right, p, q);
    }else{
        return root;
    }
}
```


### 222 完全二叉树的节点数
[83%](https://blog.csdn.net/jmspan/article/details/51056085)


### DLS可以达到BFS一样空间的DFS

### word search
用全局mark数组58%，改用char修改board98%
{% fold %}
```java
//    boolean[][] marked;
public boolean exist(char[][] board, String word) {
    int n  = board.length;
    int m = board[0].length;
//        marked = new boolean[n][m];
    for (int i = 0; i <n ; i++) {
        for (int j = 0; j <m ; j++) {
            if(word.charAt(0)!=board[i][j])continue;
            if(dfs(board,0,i,j,word))return true;

        }

    }
    return false;
}

private boolean dfs(char[][] board,int idx,int i,int j,String word){
    if(i>board.length-1||i<0||j>board[0].length-1||j<0||word.charAt(idx)!=board[i][j])return false;

    if(idx==word.length()-1)return true;
    char tmp = board[i][j];
//        marked[i][j] = true;
board[i][j]='0';

    boolean ans = dfs(board,idx+1,i+1,j,word)||
            dfs(board,idx+1,i,j+1,word)||dfs(board,idx+1,i-1,j,word)
            ||dfs(board,idx+1,i,j-1,word);
//        marked[i][j]=false;
    board[i][j]=tmp;
    return ans;
}
```
{% endfold %}

#### Boggle
![boggle.jpg](/images/boggle.jpg)
> ```
> board =
> [
  ['A','B','C','E'],
  ['S','F','C','S'],
  ['A','D','E','E']
]
> Given word = "ABCCED", return true.
> Given word = "SEE", return true.
> Given word = "ABCB", return false.
> ```



 

---





### 后缀树字典树 每层多一个字符的字典树
### 后缀树 对字典树路径压缩，一层多个字符 生成需要O(N^2)

### 后缀数组 A[]后缀的起始位置
//Memory Limit Exceeded
```java
private final String[] suffixes;
private final int N;
public SuffixArray(String s){
    N = s.length();
    suffixes = new String[N];
    for (int i = 0; i < N; i++) {
        suffixes[i] = s.substring(i);
    }
    Arrays.sort(suffixes);
}
```
"alohomora"
1.按字典序排序所有可能的后缀S[0]="a",[1]="alohomora",[2]="homora"..[len-1]="ra"
2.A[i]是S[A[i]]的索引,是后缀的真实起始位置.A[i]是i包括i位以后的后缀
  [0] ="alohomora"，[len-1]="a"，[len-2]="ra
  A[i]的i是字典序的i，值是真实位置
  例：S[A[0]]=S[8]=表示第一个字典序，实际位置是字符串substring(8);

#### 生成后缀数组  
Manber-Myers O(n)但是太复杂

排序后缀目录：桶排序



### Aho-Corasick
1添加失败链接
2缝衣针字符串序号数组

---
### A,B两人选k种可乐达到期望最大
A选m个，B选(n-m)个
每种可乐对A,B的满意度为a,b 如何使两人满意度期望和最大
输出 买k种可乐的数量
期望和：$m/n\*a+(m-n)/n\*b$的最大值 全部买期望最大那种
输入：n=2 m=1 k=2；a=1 b=2；a=3 b=1
m/n=.5
0.5x1+0.5x2=0.5+1=1.5
0.5x3+0.5x1 = 2  全部买第二种可乐
输出:0 2

---
### ??火车换乘
保证每个车错过能在30分钟以后换车
输入：城市n 火车数m
from1 to3 cost800 18:00 21:00
...
输出从1到n的最小花费

---
### 16支队伍两两获胜概率已知求冠军概率1/8->1/4->1/16
A进入1/8只需要打败B，A进入1/4需要P(A进入1/8)\*(P(C进入1/8)\*P(A赢了C)+P(D进入1/8)\*P(A赢了D))
A进入1/2需要赢没比过的另外4个队
A变成冠军需要赢没比过的另外8个队
分组问题：如果1/4赛 1234 5678是一组4个是一组
如果1/2赛  8个是一组
![shijiebei](/images/shijiebei.jpg)


```java
for(int i =1;i<4;i++){
 int inergroup = 1<<i;
 int group= 1<<i+1;
  for (int j = 0; j <16 ; j++) {
   for(int k=0;k<16;k++) {
    //在同一个大组
    if(j/group==k/group) {
    //不在同一个小组
    if (j / inergroup != k / inergroup) {
        dp[i][j] += dp[i - 1][j] * dp[i - 1][k] * p[j][k];
}}}}}
```
{% fold %}
第一轮：1进入1/8赢的概率是[1][2] 1打败2的概率=0.133
第二轮：1赢了1/8进入1/4赢的概率是
```
1在第2轮的获胜概率是0加上1在上一轮胜利的概率0.133 ×3在上一轮获胜的概率0.335×1赢3的概率0.21
1 2 0.00935655
1在第2轮的获胜概率是0.00935655加上1在上一轮胜利的概率0.133 ×4在上一轮获胜的概率0.665×1赢4的概率0.292
1 2 0.0351825
```
第三轮：1赢了1/4在1/2半决赛赢的概率是
```
1在第3轮的获胜概率是0加上1在上一轮胜利的概率0.0351825 ×5在上一轮获胜的概率0.336947×1赢5的概率0.67
1 3 0.00794261
1在第3轮的获胜概率是0.00794261加上1在上一轮胜利的概率0.0351825 ×6在上一轮获胜的概率0.198831×1赢6的概率0.27
1 3 0.00983136
1在第3轮的获胜概率是0.00983136加上1在上一轮胜利的概率0.0351825 ×7在上一轮获胜的概率0.0229419×1赢7的概率0.953
1 3 0.0106006
1在第3轮的获胜概率是0.0106006加上1在上一轮胜利的概率0.0351825 ×8在上一轮获胜的概率0.44128×1赢8的概率0.353
1 3 0.016081
```
第四轮：1赢了1/2变成冠军的概率
```
1在第4轮的获胜概率是0加上1在上一轮胜利的概率0.016081 ×9在上一轮获胜的概率0.0606261×1赢9的概率0.328
1 4 0.000319777
1在第4轮的获胜概率是0.000319777加上1在上一轮胜利的概率0.016081 ×10在上一轮获胜的概率0.0113548×1赢10的概率0.128
1 4 0.000343149
1在第4轮的获胜概率是0.000343149加上1在上一轮胜利的概率0.016081 ×11在上一轮获胜的概率0.203126×1赢11的概率0.873
1 4 0.00319478
1在第4轮的获胜概率是0.00319478加上1在上一轮胜利的概率0.016081 ×12在上一轮获胜的概率0.147508×1赢12的概率0.082
1 4 0.00338929
1在第4轮的获胜概率是0.00338929加上1在上一轮胜利的概率0.016081 ×13在上一轮获胜的概率0.160952×1赢13的概率0.771
1 4 0.00538485
1在第4轮的获胜概率是0.00538485加上1在上一轮胜利的概率0.016081 ×14在上一轮获胜的概率0.0877648×1赢14的概率0.3
1 4 0.00580826
1在第4轮的获胜概率是0.00580826加上1在上一轮胜利的概率0.016081 ×15在上一轮获胜的概率0.240971×1赢15的概率0.405
1 4 0.00737766
1在第4轮的获胜概率是0.00737766加上1在上一轮胜利的概率0.016081 ×16在上一轮获胜的概率0.0876971×1赢16的概率0.455
1 4 0.00801932
```
{% endfold %}

---


---


---
### !815 换公交 BFS
`routes = [[1, 2, 7], [3, 6, 7]]`
表示环线`1->5->7->1->5->7->1->`
求从S->T的最少公交车数量（不是少的站点）
> Input: routes = [[1, 2, 7], [3, 6, 7]]
> S = 1
> T = 6
> Output: 2乘坐 routes[0]到7，换routes[1]到6

易错点1： bfs的size保留当前层的定点数
易错点2： deque的add和poll

{% fold %}

```
{{0,1,6,16,22,23},
 {14,15,24,32},
 {4,10,12,20,24,28,33},
 {1,10,11,19,27,33},
 {11,23,25,28},
 {15,20,21,23,29},
 {29}};
```

 S=4 T=21
bfs，起点入队，遍历起点可以到达的所有公交(4可以达公交2)，遍历所有公交2上的可达`stop{4,10,12,20,24,28,33},`
如果没到T，则4乘的公交换一辆，再遍历有4公交上的其他可达stop。
**用size保留当前层的定点数** 4的bus全部遍历完后size==0。下一轮重新获取`que.size()`
如果4的所有公交都不能达到T，则必须换乘cnt+1。当前起点变成`stop{10}`，遍历它的公交和stop，不行就{12}这些都是cnt+1可达的。直到`stop{20}->bus{2,5}`遍历公交5的stop找到T，bfs换乘1层找到的。

注意deque的add是addLast，push是addFirst,poll是pollFirst，pop是poolFirst 队列应该是add+poll,
bfs如果用栈，则会在这一层还没找完先找下一层cnt=1{4}->
![bus1.jpg](/images/bus1.jpg)
`cnt=2{33:[2, 3]}->`
将{1,10,11,19,27,33}入队
![bus2.jpg](/images/bus2.jpg)
所以回到下一次size--的时候取到了下一层的点33,两个bus都标记过了
然后就全乱了
`{27:[3]}->{19:[3]}->{11:[3,4]}->bus4`的最后`{28:[2,4]}->25:[4]->cnt=3{23:[0,4,5]}->bus5`找到21
本来应该`bus[2]->20->bus[5]`结果`bus[2]->bus[4]->bus[5]`
{% endfold %}

数据结构：
1. {站点：list<经过的公交车id>}
2. list<公交车id> 标记已经乘过的公交
3. BFS连通分量`while(!que.empty)`，
    遍历一辆车的连通分量`while(que.size()>0)`
    遍历当前节点相邻的busid是否乘过`for(int car:list)，`
    并标记这个车的连通分量已乘过，遍历这个连通分量`for(int t:routes[car])`中有没有T，有则结束，没有则将整个连通分量入队。
```java
//todonexttime
```

---
### fib
```java
int fib(int n){
    num++;//计数
    if(n==0||n==1)return n;
    if(memo[n] == -1)memo[n] = fib(n-1)+fib(n-2);
    return memo[n];
}
```

---
### 11 数组index当底边，值当杯子两侧，最大面积


---


---
### ?347桶排序 int数组中最常出现的n个
桶长度为数组长度，数字出现的最高次数为len，把频率相同的放在同一个桶。最后从桶序列高到低遍历。


### 242 Anagram 相同字母的单词

### 22 卡特兰数括号
left括号数量小于n，right括号数量必须小于left不然(()))肯定不合理
```java
if(left>right)return;
if(left==0&&right==0){rst.add(s);return;}
if(left>0)help(rst,s+"(",left-1,right);
if(right<0)help(rst,s+")",left,right+1);
```

### 344 reverse String 
转成char数组/位运算做法77%比stringbuilder好

### 238 [1,2,3,4]->返回1位置是除了1其它数的乘积 不用除法
left数组：自己左边数的乘积[1,1,2,6]
right数组:自己右边的乘积（包括自己）[24,12,4,1]
left和right对应位置相乘
不用extra space
```java
res[0]=1;
for(1 to n-1){
    res[i]=res[i-1]*nums[i-1];
}
int right=1;
for(n-1 to 0){
    res[i]*right;
    right*=nums[i];
}
return res;
```


### 371 不用'+'用位运算完成求和
```java
public int getSum(int a, int b) {
    int rst = a^b;//0^0=0,0^1=1,1^1=0 
    int carry = (a&b)<<1;//当ab相等的时候需要进位
    //a+b=（a xor b）+ （(a and b) << 1）
    if(carry!=0)return getSum(rst,carry);
    return rst;}
```

### 412 遇到3||5和3&5的倍数变成特定字符
不用%最快方法!
对于CPU取余数的运算相对来说效率很低
```java
  for(int i=1,fizz=0,buzz=0;i<=n ;i++){
            fizz++;
            buzz++;
            if(fizz==3 && buzz==5){
                ret.add("FizzBuzz");
                fizz=0;
                buzz=0;
            }else if(fizz==3){
                ret.add("Fizz");
                fizz=0;
            }else if(buzz==5){
                ret.add("Buzz");
                buzz=0;
            }else{
                ret.add(String.valueOf(i));
            }
        } 
```






### 551 出现两个以上A或者3个以上L为false
```java
return s.indexOf("A")==s.lastIndexOf("A") && s.indexOf("LLL") == -1; 
```



### 476 
前导0
```java
//找到左边第一个1，然后后面全置0
public static int highestOneBit(int i) {
    // HD, Figure 3-1
    i |= (i >>  1);//高位为1的右1步，再|则第二高位肯定是1->00011xxxxx
    i |= (i >>  2);//连续4个1 但是如果位数不够就只有3个1或者更少
    i |= (i >>  4);
    i |= (i >>  8);
    i |= (i >> 16);
    return i - (i >>> 1);//让全1的无符号右移1格1111-0111得到1000
}
```

---




### 292每个人可以拿1-3块石头，拿到最后一块的赢，所有4的倍数的情况先手不能赢 



###  lc538 O(1)空间 线索二叉树 Morris Inorder(中序) Tree Traversal
#### Morris Inorder(中序) Tree Traversal
**先把每个中缀的前缀（左子树最右）指向中缀，遍历完后把这些链接都删除还原为 null**
1. 找root的前趋：root 的中序前趋是左子树(第一个左结点)cur的最右标记为pre， pre.right = root
```java
//找前趋
Node cur = root;
if(cur.left!=null){
    Node pre = current.left;
    while(pre.right!=null&&pre.right!=cur){
        pre=pre.right;
    }
}
```
```java
//创建链接：第一次到达这个最右的结点，cur的左边其实还有结点
if(pre.right==null){
  pre.right = cur;
  cur=cur.left;
}
```
2. 找root.left的前趋：cur向左（相当于新的root（1）的状态），找到cur的最右，标识成pre.right = cur
3. 当cur向左是null则找到中序遍历的第一个输出，cur向右
```java
if(cur.left==null){
    sout(current.val);
    current=current.right;}
```
4. 当cur的left==null并且右链接已经建立到上一层。cur移动到上一层，找到前趋pre就是右链接的cur.left。 把这个右链接(pre.right)删除，输出（中），然后继续向右（上）并删除这种从前趋right过来的线。
```java
//pre.right=cur
else if(pre.right!=null){
  pre.right = null;
  sout(cur.val);
  cur=cur.right;
}
```


### 110 判断树平衡 在计算高度时同时判断平衡只需要O(n)
```java
private boolean balance =true;
public boolean isbalance(TreeNode root){
    height(root);
    return balance;
}
private int height(TreeNode root){
    if(root==null) return 0;
    int left = height(root.left);
    int right = height(root.right);
    if(Math.abs(left-right)>1)balance = false;
    return Math.max(left,right)+1;
}
```

### 2-3树 
10亿结点的2-3树高度在19-30之间。：math.log(1000000000,3)~math.log(1000000000,2)
与BST不同，2-3树是由下往上构建，防止升序插入10个键高为9的情况
2-3树的高度在$\lfloor log_3N \rfloor=\lfloor logN/log3 \rfloor$ 到$\lfloor lgN \rfloor$ 之间

### 红黑树：将3-结点变成左二叉树，将2-3变成二叉树
有二叉树高效查找和2-3树高效平衡插入
红黑树高度不超过$\lfloor 2logN \rfloor$ 实际上查找长度约为$1.001logN-0.5$

插入：总是用红链接将新结点和父节点链接（如果变成了右红链接需要旋转）

### 581 需要排序的最小子串，整个串都被排序了 递增
![lc581](/images/lc581.jpg)
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

### 136 Single Number
异或 0^12=12,12^12=0
[single number](https://leetcode.com/articles/single-number/)
$$2(a+b+c)-(a+a+b+b+c)$$ `2*sum(set(list))-sum(list)`




### 141链表环检测
空间O(1) 快慢指针：快指针走2步，慢指针走一步，当快指针遇到慢指针
最坏情况，快指针和慢指针相差环长q -1步
{% fold cpp练习 %}
```java
class Solution{
    public:
    bool hasCycle(ListNode *head) {
        auto slow = head;
        auto fast = head;
        while(fast){
            if(!fast->next)return false;
            fast = fast->next->next;
            slow = slow->next;
            if(fast == slow) return true;
        }
        return false;
    }
};
```
{% endfold %}



## 160 链表相交于哪一点
```
A:          a1 → a2
                   ↘
                     c1 → c2 → c3
                   ↗            
B:     b1 → b2 → b3
```
思路1：计算len(a),len(b)，a长则a一直跳到len(a)==len(b)再开始比较.val
思路2：将a,b连成m+n长的链表遍历两遍
```
  a1 → a2  c1 → c2 → c3 -null- b1 → b2 → b3  c1 → c2 → c3
         // ↘
         //   c1 → c2 → c3
          // ↗            
  b1 → b2 → b3  c1 → c2 → c3 -null- a1 → a2  c1 → c2 → c3
```

{% fold %}
```java
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
           if(headA==null||headB==null)return null;
            ListNode a = headA;
            ListNode b = headB;
            while(a!=b){
                if(a==null){a=headB;}else{a=a.next;}
                if(b==null){b=headA;}else{b=b.next;} 
            }
            return a;
    }
}
```
{% endfold %}

### 168 lt1350
1 -> A
2 -> B
3 -> C
...
26 -> Z
27 -> AA
28 -> AB 
递归26进制
```java
 public String convertToTitle(int n) {
    return n == 0 ? "" : convertToTitle(--n / 26) + (char)('A' + (n % 26));
}
```
88%
```java
StringBuilder sb = new StringBuilder();
while (n!=0){
   --n;
   sb.insert(0,(char)(n%26+'A' ));
   n/=26;
}
return sb.toString();
```



### 1. 爬山：局部贪心，快速找到可行解，局部最优
- 8数码:启发函数：当前状态和目标状态的距离：错位方块个数。
    1. 深度优先
![mounting](/images/mounting.jpg)
    2. 每次将当前节点S的子节点按启发式函数由大到小压入栈

8数码BFS优先队列
{% fold %}
```java
void swap(int[][] matrix,int x,int y,int newX,int newY){
    int tmp = matrix[x][y];
    matrix[x][y] = matrix[newX][newY];
    matrix[newX][newY] = tmp;
}
void printPath(Node root){
    if(root == null)return;
    printPath(root.parent);
    print2D(root.mat);
    System.out.println();
}
Node createNode(int[][] matrix,int x,int y,int newX,int newY,int level,Node parent){
    Node node = new Node();
    node.parent = parent;

    node.mat = new int[matrix.length][];
    for (int i = 0; i < matrix.length; i++) {
        node.mat[i] = matrix[i].clone();
    }
    swap(node.mat,x ,y , newX,newY);
    node.cost = Integer.MAX_VALUE;
    node.x = newX;
    node.y = newY;
    return node;
}
void slove(int[][] from,int x,int y,int[][] end){
    //扩展距离小的
    PriorityQueue<Node> que = new PriorityQueue<>(
            Comparator.comparingInt(node -> (node.cost + node.level))
    );
    Node root = createNode(from,x ,y ,x ,y ,0 , null);
    root.cost = calCost(from,end );
    que.add(root);
    while(!que.isEmpty()){
        Node min = que.poll();
        //结果，从子节点向上递归打印
        if(min.cost==0) {
            printPath(min);
            return;
        }
        //4个方向挪动白块四个方向为什么不会重复状态死循环
        for (int i = 0; i < 4; i++) {
            if(isInBoard(min.x+row[i],min.y+col[i])){
                Node child = createNode(min.mat,min.x ,min.y , min.x+row[i], min.y+col[i], min.level+1, min);
                child.cost = calCost(child.mat,end );
                que.add(child);
            }
        }
    }
}
```
{% endfold %}

### Best-First搜索：全局最优贪心
- 当前所有可扩展节点中启发函数最优点
- 用堆

### 分支界限：组合优化
- 多阶段图搜索：最短路径
    - 爬山与BF算法得到最优解都需要遍历整个空间
    1. 用爬山生成界限(可行解or最优解的上限)
![fenzhi](/images/fenzhi.jpg)



### Rabin-Karp
O(MN)


### 1. 枚举：
1. 小于N的完美立方 $a^3=b^3+c^3+d^3$
    > 按a的值从小到大输出a>b>c>d

    + a->[2,N];b->[2,a-1];c[c,a-1];d[c,a-1]

3. 称硬币:已经分组称了3次12枚硬币，找出假币
    > ABCD EFGH even
    > ABI EFJK up
    > ABIJ EFGH even
    > 输出假的硬币
    
    + 数据结构 `char Left[3][7]``char Right[3][7]` `char result[3][7]` 一共称3次，每边最多放6个硬币，result（天平右边的情况）
    + `isFake(char c,bool light )`假设函数：c是轻的
    + `for(char c= 'A' to 'L')`枚举假硬币
    + `for(3)`三次称重情况都匹配
        + 如果假设c是轻的，数组保存输入的left,right;如果c是种的，right保存到left 互换
        + `switch result[i][0]` 选择三种u,e,d的情况
            + 如果 第一次实验为up,右边高，则c应该出现在right,当`right.indexOf(c)==null`//没出现 return false
            + 如果even 判断出现在left||right
            + d 判断出现在left
---
4. 熄灯问题(deng.java)
    > 按一个位置，改变上下左右自己5个灯的状态，边角自动变少3，4
    > 给定每盏灯的初始状态，求按钮方案，使灯全熄灭
    > 输入 01矩阵 输出 01矩阵
    > 一个按钮按两次及以上是无意义的，按钮次序无关
    > {0,1,1,0,1,0},
    > {1,0,0,1,1,1},
    > {0,0,1,0,0,1},
    > {1,0,0,1,0,1},
    > {0,1,1,1,0,0}
    
    + 枚举所有可能的开关状态30个开关有$2^{30}$个状态（方案数）
    + 只需枚举第一行作为（局部） 后面几行都是确定的。第一行没灭的灯必须要第二行按灭，且其它灯不能按
    + 一行01可以采用位运算 一维char数组5位(5行) 用int [0,2^6-1]
    + 一个bit异或1 反转`1^1->0反转0^1->1反转；`
    + j位 置1 `|=(1<<j)`
    + j位 置0 `&=~(1<<j)`
    + 取第j 位的值 `>>j&1`
    >  主循环：1.遍历第一行开关状态
    >  2.每次换第一行重置原来灯状态lighting[]=输入
    >  3.对每一行，每一个灯，按switch更新lighting
    
```java
for (int j = 0;j<6;j++){
  if(getBit(result,i,j)==1){
if(j>0)FlipBit(lights,i,j-1);
FlipBit(lights,i,j);
if(j<5)FlipBit(lights,i,j+1);}}
if(i<4){lights[i+1]^= switchs;}
```
    >  4.更新开关，下一行开关为上一行还亮着灯的位置回3
    >  5.当lighting最后一行为0，结束


### 递归
1. 汉诺塔：将A上的n个移动到C用B中转可以分解为3个字问题(1,2)
    1. A上n-1个移动到B，用C中转+移动一个盘子sout(A->c)
    2. 再将B上n-1个移动到C，用A中转
    3. 回到0 A上n-2个移动到C，用B中转
2. n皇后 递归代替多重循环
    
#### 链表DELETE_IF
```java

```


#### 创建链表    
list->nodelist 会stackOverflow
```java
Node create(List<Integer> data){
    Node first = new Node(data.get(0));
    Node sub = create(data.subList(1,data.size()));
    first.next=sub;
    return first;
}
```
---
迭代：
```java
Node pre = null;
Node head =null;
for(1 to size){
    Node node = new Node(i);
    if(pre!=null){
        pre.next =node;
    }else{
        head = node;
    }
    pre = node;
}
return head;
```

#### 反转链表
```java
Node reverse(Nodde head){
    if(head==null)return null;
    if(head.next == null)return head;
    Node second = reverse(head.next);
    second.next = head;
    head.next = null;
    return second;
}
```
---
迭代：
中间状态null<-1<-2<3 |  4->5->null
3是newhead 反转成功的链表 | 4curhead是还没反转的链表
newhead=null开始，curhead从第一个node开始，两个同时向右每次移一格，直到curhead=null
```java
Node newhead = null;
Node curhead = head;
while(head!=null){
    Node tmp = curhead.next;
    curhead.next = newhead;
    curhead=tmp;
    newhead = curhead;
}
return newhead;
```


转成栈浪费空间并且代码复杂






### 654 二叉树根是数组中最大元素，左子树是左边元素建子树，右子树是右边元素建子树
stack：
[3,2,1,6,0,5]
1.栈底是数组最大值，即树根
```
3left->
 right->2->1 stack:3,2,1
将栈里比cur小的右链变成当前最大值的左链，pop所有比6小的元素
6left->3
        ->right->2->1 stack：6
6left->3
 right->0 stack:6,0
5left->0,6right->5
6->left->3
         ->right->2->1
 ->right->5
          ->left->0
```
68%
```java
Deque<Integer> stack = new ArrayDeque<>();
for(int i =0;i<nums.length;i++){
    TreeNode cur = nums[i];
    while(!stack.isEmpty()&&stack.peek().val<cur.val){
        cur.left = stack.pop();
    }
    if(!stack.isEmpty())
        stack.peek().right=cur;
    stack.push(cur);
    }
return stack.isEmpty()?null:stack.removeLast();
```
递归95% 递归熟练 11ms
```java
build(nums,0,nums.length-1);
private TreeNode build(int[] nums,int start,int end){
    if(start>end)return null;
    int max = start;
    for(int i =start+1;i<=end;i++){
        max = nums[]
    }
    TreeNode root = new TreeNode(nums[max]);
    root.left = build(nums,start,max-1);
    root.right = build(nums,max+1,end);
    return root;
}
```