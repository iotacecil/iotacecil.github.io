---
title: 刷题记录
date: 2018-03-24 03:07:34
tags: [alg]
categories: [算法备忘]
---
排序算法复杂度
![sorttime.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/sorttime.jpg)


刷题顺序
https://vjudge.net/article/6
https://www.cnblogs.com/JuneWang/p/3773880.html

网易
https://www.nowcoder.com/discuss/105576?type=2

微软187
https://blog.csdn.net/v_july_v/article/details/6697883
面试
https://blog.csdn.net/v_july_v/article/details/6803368
https://www.cnblogs.com/JuneWang/p/3773880.html

https://www.educative.io/collection/page/5642554087309312/5679846214598656/140001

https://hrbust-acm-team.gitbooks.io/acm-book/content/search/a_star_search.html


笔试题todo
https://www.nowcoder.com/test/4575457/summary

数据范围 
10^4 可以用(n^2)
10^8 用O(n)
10^7 O(nlogn)

### 海盗分金
https://baike.baidu.com/item/%E6%B5%B7%E7%9B%97%E5%88%86%E9%87%91

### 403 青蛙跳石子
第一步只能跳跃一步。上一步跳了k步，下一步可以跳k,[k]+1步或者[k]-1步。
问能否跳到终点
{% note %}
8个石头
[0,1,3,5,6,8,12,17]
0->1跳1步，
1->3跳2步，
3->5跳2步
5->8跳3步
8->12跳4步
12->17跳5步
true
{% endnote %}

`[0,1,3,5,6,8,12,17]`

`{17=[], 0=[1], 1=[1, 2], 3=[1, 2, 3], 5=[1, 2, 3], 6=[1, 2, 3, 4], 8=[1, 2, 3, 4], 12=[3, 4, 5]}`

```java
public boolean canCross(int[] stones) {
   int n = stones.length;
    Map<Integer,Set<Integer>> map = new HashMap<>();
    for(int i = 0;i<n;i++){
        map.put(stones[i],new HashSet<>());
    }
    map.get(0).add(1);
    for(int i = 0;i<n;i++){
        for(int step:map.get(stones[i])){
            int nxt = stones[i]+step;
            if(nxt == stones[n-1])return true;
            if(map.containsKey(nxt)){
                Set<Integer>steps = map.get(nxt);
                steps.add(step);
                if(step-1>0)
                    steps.add(step-1);
                steps.add(step+1);
            }
        }
    }
    return false;
}
```


### 458 毒药
1000个水桶，1个有毒药，喝了15分钟死，一小时内搞清哪个有毒最少需要多少只猪
5只 
4个水桶，1个有毒药，喝了15分钟死，30分钟搞清哪个有毒最少需要多少只猪
2只 2轮

假设有 n 只水桶，猪饮水中毒后会在 m 分钟内死亡，你需要多少猪（x）就能在 p 分钟内找出 “有毒” 水桶？这 n 只水桶里有且仅有一只有毒的桶。
思路：2只猪可以把桶放成一个二维的矩形，每一轮2只确定一行和一列，找到一个坐标。
如果3只猪，可以把桶放成三维X X X ，用三只每一轮确定一个位置。

1 2
3 4
第一轮喝 1，2 另一个1，3，都死说明1，不然说明2或者3.不死说明4.

1  2  3
4  5  6
7  8  9

第一轮1 2 3， 另一个 1，4 ，7
三只猪，测两次，可以测27桶

求数组的维度，我们知道了数组的总个数，所以要尽量增加数组的长宽，尽量减少维度。

数组的长宽其实都是测试的次数+1（因为全部测完了都没发生，下一轮不用测肯定在），所以我们首先要确定能测的次数，通过总测试时间除以毒发时间，再加上1就是测试次数。
$$log_{T+1}(N)$$

```java
public int poorPigs(int buckets, int minutesToDie, int minutesToTest) {
    return (int)Math.ceil(Math.log(buckets)/Math.log(minutesToTest / minutesToDie + 1));
}
```

正常思路：
如果2只，4个桶，一轮
都不喝0,A喝1，B喝2，AB喝3，
00      01    10     11
有x个猪可以表示2^x个状态。
如果有t次尝试，用t位二进制去表示bucket。

如果8个桶，15分钟死，有40分钟
可以测试2轮，用3位二进制表示桶
Math.log(8, 3).ceil


### 407 二维数组存水
{% note %}
[
  [1,4,3,1,3,2],
  [3,2,1,3,2,4],
  [2,3,3,2,3,1]
]

Return 4.
{% endnote %}
用优先队列



### 629 K个逆序对的排列数量


### 349 数组交集
{% note %}
Input: nums1 = [1,2,2,1], nums2 = [2,2]
Output: [2]
{% endnote %}

`set1.retainAll(set2);`

### 字符串交集


### 166. Fraction to Recurring Decimal 分数转小数用括号表示循环节
{% note %}
Input: numerator = 2, denominator = 3
Output: "0.(6)"
{% endnote %}

### 395

### 854 Split Array into Fibonacci Sequence
{% note %}
Input: "123456579"
Output: [123,456,579]
{% endnote %}


### 873. Length of Longest Fibonacci Subsequence
{% note %}
Input: [1,3,7,11,12,14,18]
Output: 3
Explanation:
The longest subsequence that is fibonacci-like:
[1,11,12], [3,11,14] or [7,11,18].
{% endnote %}

### 842

### 650

### 493 Reverse Pairs 逆序对的个数
如果 i < j and nums[i] > 2*nums[j].算一个逆序对
{% note %}
Input: [1,3,2,3,1]
Output: 2
{% endnote %}

```java
public static int ret;
public static int reversePairs(int[] nums) {
    ret = 0;
    mergeSort(nums, 0, nums.length-1);
    return ret;
}

public static void mergeSort(int[] nums, int left, int right) {
    if (right <= left) {
        return;
    }
    int middle = left + (right - left)/2;
    mergeSort(nums, left, middle);
    mergeSort(nums,middle+1, right);

    //count elements
    int count = 0;
    for (int l = left, r = middle+1; l <= middle;) {
        if (r > right || (long)nums[l] <= 2*(long)nums[r]) {
            l++;
            ret += count;
        } else {
            r++;
            count++;
        }
    }

    //sort
    Arrays.sort(nums, left, right + 1);
}

```


#### 315 输出数组每个位置后有多少个数字比它小
{% note %}
Input: [5,2,6,1]
Output: [2,1,1,0] 
{% endnote %}

暴力n^2复杂度一般只能到1k数量级

BIT:
倒序:`[1,6,2,5]`
rank:`[0,3,1,2]`
prefix sum:建立rank计数数组，读1，6，2.. 并在prefix 上计数
并求和
pre：[]



BST 二叉搜索树
节点(val,sum,dup)sum是左（小）节点的个数，dup是当前数字重复的个数。
1.逆序读入建BST

方法3：归并排序
![nixu315.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/nixu315.jpg)

#### 小和问题(右边有多少个数比它大)
```
1 3  4 2 5
   /   \
1 3 4  2 5
  /\   
13  4     
```
归并1,3得小和->+1
归并13，4 得小和->+1,+3 并且merge好了[1,3,4]
归并2,5 得小和->+2
归并134,25 :
1比右边多少个数小：2的位置是mid+1，所以通过index可以得到 小和1x2个
p1指向3，p2指2，无小和
p1=3 p2=5 小和3x1个
p1=4 p2=5 小和4x1

例子2
```
1 3 4 5 6 7
1比多少个数小：
13)->1
13)4)->1
13)4)567)->1*3
```

如果[p1...][p2...]
如果p1比p2小，则p1比p2后面的数都小，是后面的数的小和
比归并排序就多这一句
```java
res+=arr[p1]<arr[p2]?(r-p2+1)*arr[p1]:0;
```
{% fold %}
```java
//数组每个数左边比当前小的数累加起来叫这个 组数的小和。
//[1,3,4,2,5]->1 +1+3 +1 +1+3+4+2
    public int xiaohe(int[] arr){
        if(arr==null||arr.length<2)return 0;
        return mergesort(arr,0,arr.length-1);
    }
    private int mergesort(int[] arr,int l,int r){
        if(l==r)return 0;
        int mid = l+((r-l)>>1);
        return mergesort(arr,l,mid)+mergesort(arr,mid+1,r)+merge(arr,l,mid,r);
    }
//    如果[p1...][p2...]
//    如果p1比p2小，则p1比p2后面的数都小，是后面的数的小和
    private static int merge(int[] arr,int l,int mid,int r){
        int[] help = new int[r-l+1];
        int i = 0;
        int p1 = l;
        int p2 = mid+1;
        int res = 0;
        while (p1<=mid&&p2<=r){
            System.out.println(res);
            res+=arr[p1]<arr[p2]?(r-p2+1)*arr[p1]:0;
            help[i++] = arr[p1]<arr[p2]?arr[p1++]:arr[p2++];
            System.out.println(Arrays.toString(help));

        }
        while (p1<=mid){
            help[i++] = arr[p1++];
        }
        while (p2<=r){
            help[i++] = arr[p2++];
        }
        for (int j = 0; j <help.length ; j++) {
            arr[l+j] = help[j];
        }
        System.out.println(Arrays.toString(help));
        return res;
    }
```
{% endfold %}

### lg1966
让b数组中第i小的数和a数组中第i小的数在同一个位置
{% note %}
4
2 3 1 4
3 2 1 4

out:1
{% endnote %}

1）归并排序
$c[b[i].loc]=a[i].loc$ 排序的交换次数，逆序对个数。
利用下标的单调升序,用归并排序最后让c[i]=i
(x,loc)按数值排序后
a:`[(1,2), (2,0), (3,1), (4,3)]`
b:`[(1,2), (2,1), (3,0), (4,3)]`
c:`[1, 0, 2, 3]`
1）树状数组

### lg1455 搭配购买 必须搭配购买的背包问题
买一朵云则与这朵云有搭配的云都要买，钱是有限的，所以你肯定是想用现有的钱买到尽量多价值的云。
输入输出格式
输入格式：
第1行n,m,w,表示n朵云，m个搭配和你现有的钱的数目
第2行至n+1行，每行ci,di表示i朵云的价钱和价值
第n+2至n+1+m ，每行ui,vi表示买ui就必须买vi,同理，如果买vi就必须买ui

输出格式：
一行，表示可以获得的最大价值
{% note %}
输入输出样例
输入样例#1：

5 3 10
3 10
3 10
3 10
5 100
10 1
1 3
3 2
4 2
输出样例#1：
1
{% endnote %}

思路：用并查集把n个必须一起买的物品组合成一个大物品，再用背包
```cpp
int father[20001],c[20001],w[20001],f[20001];
int n,m,k,x,y;

int find(int x)  //并查集
{
    return x==father[x]?x:father[x]=find(father[x]);
}

int main()
{
    scanf("%d%d%d",&n,&m,&k);
    for (int i=1;i<=n;i++)
    {
        scanf("%d%d",&w[i],&c[i]);
        father[i]=i;  //初始化
    } 
    for (int i=1;i<=m;i++)
    {
        scanf("%d%d",&x,&y);
        if (find(x)!=find(y)) father[find(y)]=find(x);  //划为同一集合
    }
    for (int i=1;i<=n;i++)
     if (father[i]!=i)  //如果买了这一件商品就得买另一件商品
     {
        c[find(i)]+=c[i];
        w[find(i)]+=w[i];  //划为同一集合
        c[i]=w[i]=0;  //清零，不清零就可能会造成重复购买一件商品
     }
    for (int i=1;i<=n;i++)
     for (int j=k;j>=w[i];j--)
      f[j]=max(f[j],f[j-w[i]]+c[i]); //01背包
    printf("%d\n",f[k]);
    return 0;
}
```

### 334 三个上升子序列
`arr[i] < arr[j] < arr[k]`
given 0 ≤ i < j < k ≤ n-1 else return false.
{% note %}
Input: [5,4,3,2,1]
Output: false
{% endnote %}

### 639 解码方式
{% note %}
Input: "1*"
Output: 9 + 9 = 18
1* -> 10 11 12... 19  1,*-> 1,0 1,1...
{% endnote %}

```java
public int numDecodings(String s) {
    long e0 = 1,e1 = 0,e2=0,f0,f1,f2;
    long M =1000_000_007;
    for(char c : s.toCharArray()){
        if(c == '*'){
            f0 = 9*e0 + 9*e1 +6*e2;
            f1 = e0;
            f2 = e0;
        }else{
            f0 = ((c > '0')?1:0 )* e0 + e1 + ((c <= '6')?1:0) * e2;
            f1 = ((c == '1')?1:0 ) * e0;
            f2 = ((c == '2')?1:0 ) * e0;
        }
        e0 = f0 % M;
        e1 = f1;
        e2 = f2;
    }
    return (int)e0;
}
```



### 324 摇摆序列sort
{% note %}
in：
[4,5,5,6]
out:
[5,6,4,5]
{% endnote %}


{% fold %}
```java
public void wiggleSort(int[] nums) {
    int n = nums.length;
    int[] arr = nums.clone();
    Arrays.sort(arr);
    int j = n-1;
    int half = (n+1)/2;
    int i = half-1;
    for(int k = 0;k<n;k++){
        if((k%2) ==0){
            nums[k] = arr[i--];
        }else{
            nums[k] = arr[j--];
        }
    }  
}
```
{% endfold %}


### 891 子序列宽度和
{% note %}
Input: [2,1,3]
Output: 6
Explanation:
Subsequences are [1], [2], [3], [2,1], [2,3], [1,3], [2,1,3].
The corresponding widths are 0, 0, 0, 1, 1, 2, 2.
The sum of these widths is 6.
{% endnote %}
思路，
1）排序，对第`A[i]`个数字，
有i个比它小，有2^i个序列A[i]是最大的(这i个数字选或者不选的集合），
有n-1-i个比它大，有2^(n-1-i)个序列，A[i]是最小的。
2）注意 2^i 用`1<<i` 如果数组长度>32答案会很奇怪（？）
```java
public int sumSubseqWidths(int[] A) {
    long rst = 0;
    int mod = 1_000_000_000+7;
    Arrays.sort(A);
    int n = A.length;
   
    long[] pow2 = new long[n];
    pow2[0] = 1;
    for (int i = 1; i < n; ++i)
        pow2[i] = pow2[i-1] * 2 % mod;
    for (int i = 0; i < n ; i++) {
        rst = (rst+ (pow2[i] - pow2[n-1-i])*A[i])%mod;
    }
    return (int)rst;
}
```



### 992 有K个不同整数的子数组的个数
{% note %}
输入：A = [1,2,1,3,4], K = 3
输出：3
解释：恰好由 3 个不同整数组成的子数组：[1,2,1,3], [2,1,3], [1,3,4].
{% endnote %}



### 502 IPO
{% note %}
输入: k=2, W=0, Profits=[1,2,3], Capital=[0,1,1].
输出: 4
最初有W=0元钱，最多完成k个项目，每个项目有最低资本和利润，最后获得的钱数。
从 0 号项目开始，总资本将变为 1。完成 2。最后最大化的资本，为 0 + 1 + 3 = 4。 完成项目是不扣资本的。
{% endnote %}

两个优先队列AC

### 4位25个字符的编码
假定一种编码的编码范围是a ~ y的25个字母，从1位到4位的编码，如果我们把该编码按字典序排序，形成一个数组如下： a, aa, aaa, aaaa, aaab, aaac, … …, b, ba, baa, baaa, baab, baac … …, yyyw, yyyx, yyyy 其中a的Index为0，aa的Index为1，aaa的Index为2，以此类推。 编写一个函数，输入是任意一个编码，输出这个编码对应的Index.

输入：baca
输出：16331

a开头的长度为4的编码一共有25^3个，长度为3有25^2个，长度为2有25个，长度为1有1个。
例：bcd
第一位是b所以处在第二大块，result += 1 *  (25^3+25^2+25+1) 
第二位是c， result += 2 *（25^2+25+1）+1
第三位是d， result += 3* （25+1）+1  （加一是因为最前面有个空）
第四位是空，不管，因为空就是第一个
result = 17658

```java
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    String str = sc.next();
    int n = str.length();
    int rst = 0;
    if(n>0)
        rst += (str.charAt(0)-'a')*(25*25*25+25*25+25+1);
    if(n>1)
        rst += (str.charAt(1)-'a')*(25*25+25+1)+1;
    if(n>2)
        rst += (str.charAt(2)-'a')*(25+1)+1;
    if(n>3)
        rst += (str.charAt(3)-'a')+1;
    System.out.println(rst);
}
```

### geohash
纬度的二进制编码[-90, 90]
```java
public static void main(String[] args) {
    Scanner sc =new Scanner(System.in);
    int wd = sc.nextInt();
    StringBuilder sb = new StringBuilder();
    int[] bound = {-90,90};
    for (int i = 0; i <6 ; i++) {
        int mid = (bound[0]+bound[1])/2;
        if(wd>=mid){
            sb.append(1);
            bound[0] = mid;
        }else {
            sb.append(0);
            bound[1] = mid;
        }
    }
    System.out.println(sb.toString());
}
```

### 素数
生成<=n之内的所有素数
给定一个正整数，编写程序计算有多少对质数的和等于输入的这个正整数，并输出结果。输入值小于1000。
如，输入为10, 程序应该输出结果为2。（共有两对质数的和为10,分别为(5,5),(3,7)）
```java
public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int num = sc.nextInt();
        boolean[] prime = new boolean[num+1];
        Arrays.fill(prime, true);
        for(int i = 2; i <= num; i++){
            if(prime[i]){
                // 将i的2倍、3倍、4倍...都标记为非素数
                for(int j = i * 2; j <= num; j =  j + i){
                    prime[j] = false;
                }
            }
        }
        int cnt = 0;
        for(int i = 2;i<=num/2;i++){
                if(prime[i] && prime[num-i])cnt++;
        }
        System.out.println(cnt);
    }
```

### 切铜板 哈夫曼编码
给定数组{10,20,30}， 代表一共三个人， 整块金条长度为10+20+30=60. 金条要分成10,20,30三个部分。
如果，先把长度60的金条分成10和50， 花费60 再把长度50的金条分成20和30，花费50一共花费110铜板。
但是如果， 先把长度60的金条分成30和30， 花费60 再把长度30金条分成10和20， 花费30 一共花费90铜板。

### 797 All Paths From Source to Target

### 437树中找部分路径，和为target的路径条数
{% note %}
```
root = [10,5,-3,3,2,null,11,3,-2,null,1], sum = 8

      10
     /  \
    5   -3
   / \    \
  3   2   11
 / \   \
3  -2   1

Return 3. The paths that sum to 8 are:

1.  5 -> 3
2.  5 -> 2 -> 1
3. -3 -> 11
```
{% endnote %}

hashMap+回溯
```java
public int pathSum(TreeNode root, int sum) {
    // key:前缀和 value：有多少种方式可以得到这个值
    HashMap<Integer,Integer> preSum = new HashMap<>();
    preSum.put(0, 1);
    return helper(root,0,sum,preSum);
    }
int helper(TreeNode root,int currSum,int target,HashMap<Integer,Integer> preSum){
    if(root == null)return 0;
    currSum += root.val;
    int rst = preSum.getOrDefault(currSum - target,0);
    preSum.put(currSum, preSum.getOrDefault(currSum,0)+1);
    rst += helper(root.left,currSum,target,preSum)+helper(root.right,currSum,target,preSum);
    // 关键 ？
    preSum.put(currSum,preSum.get(currSum)-1);
    return rst;
}
```

### pdd 花灯铺路最远距离

### 926 hiho 1326 将01串变成前0后1或全0或全1的最少flip次数 前缀！
> Input: "010110"
Output: 2
Explanation: We flip to get 011111, or alternatively 000111.

思路1：前缀`[1..i]` 变成全0或者变成`[000111]`的最小反转次数,推到整个数组
```
0101100011 S
0112333345 oCnt(把所有1转0)
0011123444 fCnt(第一个1之后0的个数)
0011122333 fCnt更新为min(将当前位置之前的所有1转0，或者当前位置之前1后0转1)
```

```java
public int minFlipsMonoIncr(String S) {
    int oCnt = 0;
    int fCnt = 0;
    for(int i =0;i<S.length();i++){
        if(S.charAt(i) == '1'){
            oCnt ++;
        }else if(oCnt >0){
            fCnt ++;
        }
        // 关键 fCnt 随前缀更新
       fCnt = oCnt < fCnt ? oCnt:fCnt;
    }
    return fCnt;
}
```

### 636 单核cpu函数调用栈
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

### 3 !!最长不重复子串 做了3遍还是不熟练
{% fold %}
Input: "abcabcbb"
Output: 3 
Explanation: The answer is "abc", with the length of 3. 
{% endfold %}

思路：`abca`最长的是两个a之间,start是上一个a。`bbvfg`最长的是重复b之后更新start。
关键：`tmmzuxt` start应该只增不减。`Math.max(start,map.get(c) + 1)`

```java
public int lengthOfLongestSubstring(String s) {
    if(s==null || s.length() <1 )return 0;
    int n = s.length();
    int start = 0;
    int mlen = 0;
    Map<Character,Integer> map = new HashMap<>();
    for(int i =0;i < n ;i++){
        char c = s.charAt(i);
        if(map.containsKey(c)){
            start = Math.max(start,map.get(c) + 1);
        }
        mlen = Math.max(mlen,i - start +1);
        map.put(c, i);
    }
    return mlen;
}
```

方法2：用`Set<Character>`
维持一个窗口[i,j)， 放到set中，如果没重复继续向右扩展，如果重复，窗口向右移动
```java
public int lengthOfLongestSubstring(String s){
    int n = s.length();
    Set<Character> set = new HashSet<>();
    int ans = 0,i=0,j=0;
    //维持一个窗口[i,j)， 放到set中，如果没重复继续向右扩展，如果重复，窗口向右移动
    while (i<n&&j<n){
        if(!set.contains(s.charAt(j))){
            set.add(s.charAt(j++));
            ans = Math.max(ans,j-i);
        }else{
            set.remove(s.charAt(i++));
        }
    }
    return ans;
}
```

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


### 575 分糖果 两人数量相等 最大化一组的品种
{% note %}
Input: candies = [1,1,2,3]
Output: 2
{% endnote %}

思路：
获得的种类最多是n/2种 每种都不同，>2次的个数<=n/2。
或者重复的元素很多,可以得到所有种类。
```java
public int distributeCandies(int[] candies) {
   Set<Integer> set = new HashSet();
    int n = candies.length;
    for(int i = 0;i < n;i++){     
        if(!set.contains(candies[i])){
            set.add(candies[i]);
        }
        if(set.size() > n/2)return n/2;
    }
    return set.size();
}
```

### 888 换1个糖果使两组和相等
{% note %}
交换A，B数组中的2个数字(exchange one candy bar)，数组总和相等
Input: A = [2], B = [1,3]
Output: [2,3] 
输出是A和B要交换的数字
{% endnote %}
AC 排序二分

---

### 621 !!!!!!任务调度
26 种不同种类的任务  每个任务都可以在 1 个单位时间内执行完
两个相同种类的任务之间必须有长度为 n 的冷却时间
> 输入: tasks = ["A","A","A","B","B","B"], n = 2
输出: 8
执行顺序: A -> B -> (待命) -> A -> B -> (待命) -> A -> B.

正确方法：找出slot

方法1 排序： 45% 20ms思路：
1.将任务数量排序，保证数量最大的几个任务都连续在数组尾部
2.大循环终止条件 ： 最右>0,并且每次都排序。
3.冷却时间循环n次，总时间和冷却时间计数器都++，从最后一个任务开始消耗,能消耗就消耗

复杂度`O(time)`

```java
public int leastInterval(char[] tasks, int n) {
    int[] cnt = new int[26];
    int m = tasks.length;
    for(char c :tasks){
        cnt[c - 'A'] ++;
    }
    Arrays.sort(cnt);
    int time = 0;
    while(cnt[25]>0){
        int i = 0;
        while(i < d){
            // 大循环的判断
            if(cnt[25] == 0)break;
            if(i < 26 && cnt[25 - i] > 0)cnt[25 - i]--;
            time++;
            i++;
        }
        Arrays.sort(cnt);
    }
    return time;
}
```

### 453 数组中n-1个数字每次增加1，最少多少次数组中元素相等
>[1,2,3]  =>  [2,3,3]  =>  [3,4,3]  =>  [4,4,4]

思路：n-1个数字+1和一个数字-1是等价的。所以看需要多少次能把所有数字减成和最小的一样。

```java
public int minMoves(int[] nums) {
    int min = nums[0];
    for(int i :nums){
        min = Math.min(min,i);
    }
    int cnt =0;
    for(int i:nums){
        cnt += i - min;
    }
    return cnt; 
}
```

### 634 n个数字的错排有几个 lt869
{% note %}
在组合数学中，错乱是一组元素的排列，这种排列中没有元素出现在它的原始位置上。
最初有一个由n个整数组成的数组，从1到n，按升序排列，你需要找到它能产生的错乱的数量。
而且，由于答案可能非常大，您应该返回输出mod 10^9 + 7的结果

给定n=3，返回 2.

解释：
原始数组是[1,2,3]。这两个错乱是[2,3,1]和[3,1,2]。
{% endnote %}

![Derangement.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/Derangement.jpg)


```java
public int findDerangement(int n) {
    long dn2 = 0,dn1= 1;
    long res = (n==1)?0:1;
    for(int i =3;i<=n;i++){
        res = ((i - 1)*(dn1+dn2)) % 1000000007;
        dn2 = dn1;
        dn1 = res;
    }
    return (int)res;
}
```

### 801 ??让数组递增的最少交换次数
可以交换 A[i] 和 B[i] 的元素
{% note %}
Input: A = [1,3,5,4], B = [1,2,3,7]
Output: 1
交换 A[3] 和 B[3] 后，两个数组如下:
A = [1, 3, 5, 7] ， B = [1, 2, 3, 4]
两个数组均为严格递增的。
{% endnote %}

思路：如果两个数组`[i]>[i-1]`可以保持不变，如果`A[i]>B[i-1]&&B[i]>A[i-1]`可以尝试交换。
dp思想，保存每个位置的两种状态：
1）可以交换
2）保持不变。

```java
public int minSwap(int[] A, int[] B) {
   int n = A.length;
    int[] swap = new int[n];
    int[] keep = new int[n];
    swap[0] = 1;
    for (int i = 1; i <n ; i++) {
        // 关键
        keep[i] = swap[i] = n;
        if(A[i-1] < A[i] && B[i-1]<B[i]){
            keep[i] = keep[i-1];
            swap[i] = swap[i-1] +1;
        }
        if(A[i-1] <B[i] && B[i-1] <A[i]){
            keep[i] = Math.min(keep[i],swap[i-1]);
            swap[i] = Math.min(swap[i],keep[i-1]+1);
        }
    }
    return Math.min(keep[n-1],swap[n-1]);
}
```

### 670 




有序矩阵nxn个复杂度O(n)

在100-999这900个自然数中,若将组成这个数的三个数字认为是三条线段的长度,那么是三条线段组成一个等腰三角形(包括等边)的共有()个.
先考虑等边三角形情况 
则a=b=c=1，2，3，4，5，6，7，8，9，此时n有9个 
再考虑等腰三角形情况，若a，b是腰，则a=b 
当a=b=1时，c＜a+b=2，则c=1，与等边三角形情况重复； 
当a=b=2时，c＜4，则c=1，3（c=2的情况等边三角形已经讨论了），此时n有2个； 
当a=b=3时，c＜6，则c=1，2，4，5，此时n有4个； 
当a=b=4时，c＜8，则c=1，2，3，5，6，7，有6个； 
当a=b=5时，c＜10，有c=1，2，3，4，6，7，8，9，有8个； 
由加法原理知n有2+4+6+8+8+8+8+8=52个 
同理，若a，c是腰时，c也有52个，b，c是腰时也有52个 
所以n共有9+3×52=165个 


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

### 316 !!删除重复字母，输出字典序最小的（按原顺序）
{% note %}
Input: "bcabc"
Output: "abc"
{% endnote %}
pdd原题
不会

```java
public String removeDuplicateLetters(String s) {
    int[] cnt = new int[26];
    int pos = 0; // the position for the smallest s[i]
    for (int i = 0; i < s.length(); i++) cnt[s.charAt(i) - 'a']++;
    for (int i = 0; i < s.length(); i++) {
        if (s.charAt(i) < s.charAt(pos)) pos = i;
        if (--cnt[s.charAt(i) - 'a'] == 0) break;
    }
    return s.length() == 0 ? "" : s.charAt(pos) + removeDuplicateLetters(s.substring(pos + 1).replaceAll("" + s.charAt(pos), ""));
}
```

### 677 优美排列，相邻两个数的差有k种的数组
{% note %}
输入: n = 3, k = 2
输出: [1, 3, 2]
解释: diff: [2, 1] 中有且仅有 2 个不同整数: 1 和 2
k,n<10^4
{% endnote %}

大小数字插空放 能有不同的dif，之后就顺序放全部dif为1.
```
i: 1   2   3   4   5
j:   9   8   7   6
out: 1 9 2 8 3 7 4 6 5
dif:  8 7 6 5 4 3 2 1
```

```java
public int[] constructArray(int n, int k) {
 int[] arr = new int[n];
    int c = 0;
    int l = 1, h = n;

    while(l <= h)
    {
        if(k > 1)arr[c++]= ((k--%2 != 0)?l++:h--);
        else arr[c++]=l++;
    }

   return arr;
}
```

### 526 1-N构造i位数能整除i或者整除[i]位数的数组
{% note %}
输入: 2
输出: 2
解释: 

第 1 个优美的排列是 [1, 2]:
  第 1 个位置（i=1）上的数字是1，1能被 i（i=1）整除
  第 2 个位置（i=2）上的数字是2，2能被 i（i=2）整除

第 2 个优美的排列是 [2, 1]:
  第 1 个位置（i=1）上的数字是2，2能被 i（i=1）整除
  第 2 个位置（i=2）上的数字是1，i（i=2）能被 1 整除
{% endnote %}
bracktrack 计数

### 796 字符串是不是旋转成的
{% note %}
Example 1:
Input: A = 'ab cde', B = 'cde ab'
Output: true
{% endnote %}

最正确的做法：虽然是N^2 contains
```java
public boolean rotateString(String A, String B) {
   if(A.length() == B.length() && (A+A).contains(B))return true; 
    else return false;
}
```

rolling hash 很慢（？）


### lc 73 矩阵如果有0,则整行/列置0
{% note %}
```
Input: 
[
  [1,1,1],
  [1,0,1],
  [1,1,1]
]
Output: 
[
  [1,0,1],
  [0,0,0],
  [1,0,1]
]
```
{% endnote %}

正确做法：空间O(1),时间O(MxN)
```java
public void setZeroes(int[][] matrix) {
    int n = matrix.length;
    int m = matrix[0].length;
    //用第一行和第一列 记录 所有行，所有列的0的个数。
    // 第一行，第一列要不要变0可以存一个在[0][0]上，另一个用一个变量,
    boolean col0 = false;
    for (int i = 0; i < n; i++) {
        // 不用考虑[0][0]，如果[0][0]本身是0，则0行全0. 只需考虑[0]列上有没有本身是0的。
        if(matrix[i][0] == 0)col0 = true;
        for (int j = 1; j <m ; j++) {
            if(matrix[i][j]==0){
                matrix[i][0] =  0;
                matrix[0][j] = 0;
            }
        }
    }
    for (int i = n-1; i >=0 ; i--) {
        for (int j = m-1; j >=1 ; j--) {
            if(matrix[i][0] ==0 || matrix[0][j] ==0){
                matrix[i][j] = 0;
            }
        }
        // 注意一行完了再变第一列
        if(col0)matrix[i][0] = 0;
    }
}
```

### 295 流数据找中位数
{% note %}
addNum(1)
addNum(2)
findMedian() -> 1.5
addNum(3) 
findMedian() -> 2
{% endnote %}

思路2：BST？
思路1：leftmax堆和rightmin堆。保证left大小和right大小相等or大1。

### lc 4 两个排序数组的中位数, 排序数组找第k小
{% note %}
nums1 = [1, 2]
nums2 = [3, 4]

The median is (2 + 3)/2 = 2.5
{% endnote %}

中位数是两个数组的划分位置，使两个数组左边加起来个数和右边一样。
```
x1 x2 |  x3 x4 x5 x6
y1 y2 y3 y4 y5 |  y6 y7 y8

x2（L1) <= y6(R2) && y5(L2)<= x3(R1)
```

如果划分在num1左边有partX个元素，总共是k=(n+m+1)/2个元素 ,
则用这个数字在nums2应该划分出左边有(n+m+1)/2-partX个元素
例子：如果partX = 2， k=(6+8+1)/2=7, partY应该=7-2=5.
如果 y5=10 > x3 = 8.则表示partX 划少了。
如果 x2 > y6 表示partX多了

关键：如果二分partX是0或者n，则在nums2中数partY个肯定对的

```java
public double findMedianSortedArrays(int[] nums1, int[] nums2) {
    int n1 = nums1.length;
    int n2 = nums2.length;
    if(n1 > n2) return findMedianSortedArrays(nums2, nums1);

    int lo = 0, hi = n1;
    while (lo <= hi){
        // mid:短的那个
        int partX = (lo + hi)/2;
        int partY = (n1+n2+1)/2 - partX;
        //L1<R2 && L2 < R1
        /*
        x1 x2 |  x3 x4 x5 x6
        y1 y2 y3 y4 y5 |  y6 y7 y8

        x2（L1) <= y6(R2) && y5(L2)<= x3(R1)
         */
        double L1 = (partX == 0)?Integer.MIN_VALUE:nums1[partX-1];
        double L2 = (partY == 0)?Integer.MIN_VALUE:nums2[partY-1];
        double R1 = (partX == n1)?Integer.MAX_VALUE:nums1[partX];
        double R2 = (partY == n2)?Integer.MAX_VALUE:nums2[partY];

        if(L1 <= R2 && L2 <= R1){
            if((n1+n2) % 2 ==0){
                return (Math.max(L1,L2) + Math.min(R1, R2))/2.0;
            }
            else return Math.max(L1, L2);
        }else if(L1 > R2){
            hi = partX - 1;
        }else {
            lo = partX + 1;
        }
    }
    return -1;
}
```

【前k二分】(为什么比暴力merge还慢）：在两个数组里都找第k/2个元素2,4, 2小，表示nums1 的[1]之前的元素都不可能是第k大。所以问题变成找第k-k/2大。
边界条件：
1 num1没有元素，两个数组的第k大就是nums2的B[idx2+k-1]
2 终止条件：如果k=1，返回两个第一个元素小的那个。（注意，保证k/2-1是正的。)
3 如果有一个数组已经没有k/2个了，则令这个数组的k/2个为无限大。
```java
public double findMedianSortedArrays(int[] nums1, int[] nums2) {
    int n1 = nums1.length;
    int n2 = nums2.length;
    int l = (n1+n2+1)/2;
    int r = (n1+n2+2)/2;
    return (getkth(nums1, 0, nums2,0 ,l )+getkth(nums1, 0, nums2,0 ,r ))/2;

}
public double getkth(int[] A,int idx1,int[]B,int idx2,int k){
    if(idx1 > A.length - 1)return B[idx2+k-1];
    if(idx2 > B.length - 1)return A[idx1+k-1];
    if(k==1)return Math.min(A[idx1],B[idx2]);
    int amid = Integer.MAX_VALUE,bmid = Integer.MAX_VALUE;
    if(idx1+k/2-1<A.length) amid = A[idx1+k/2-1];
    if(idx2+k/2-1<B.length) bmid = B[idx2+k/2-1];
    if(amid < bmid)return getkth(A, idx1+k/2, B, idx2, k-k/2);
    else return getkth(A, idx1, B,idx2+k/2,k-k/2 );
}
```


### 9 判断回文
{% note %}
Input: 121
Output: true
{% endnote %}

### 添加最少字符回文串 区间dp
可以在任意位置添加,
{% note %}
？
{% endnote %}

### 最尾添加回文串 Manacher 最右回文边界
https://www.nowcoder.com/questionTerminal/cfa3338372964151b19e7716e19987ac
{% note %}
对于一个字符串，我们想通过添加字符的方式使得新的字符串整体变成回文串，但是只能在原串的结尾添加字符，请返回在结尾添加的最短字符串。
"ab"
返回“a"  （aba）
{% endnote %}
思路：最后n位一定是回文的。
例如 abc 12321 ，将前面不是回文的逆序加到后面。
加#是为了偶回文。
abc12321

n^2的方法, 这个串反转，原串后n位和反转串n前位相同就是回文串。

### !131 Palindrome Partitioning 回文切割
{% note %}
```
Input: "aab"
Output:
[
  ["aa","b"],
  ["a","a","b"]
]
```
{% endnote %}

### ?409 string中字符组成回文串的最大长度
1.开int[128]，直接用int[char]++计数
2.奇数-1变偶数&(~1)
3.判断奇数(&1)>0


### ！！！516 最长回文子序列
```java
public static int longestPalindromeSubseq(String s) {
    int[][] dp = new int[s.length()][s.length()];

    for (int i = s.length() - 1; i >= 0; i--) {
        dp[i][i] = 1;
        for (int j = i+1; j < s.length(); j++) {
            if (s.charAt(i) == s.charAt(j)) {
                dp[i][j] = dp[i+1][j-1] + 2;
            } else {
                dp[i][j] = Math.max(dp[i+1][j], dp[i][j-1]);
            }
        }
    }
    return dp[0][s.length()-1];
}
```


### ！5 最长回文串 lt893

http://windliang.cc/2018/08/05/leetCode-5-Longest-Palindromic-Substring/
!!反转做法不行:abcxyzcba -> abczyxcba ->相同的abc并不是回文!! 不能用LCS
“cba”是“abc”的 reversed copy 但是可以再加一步检查下标
中心扩展法：回文的中心有奇数：n个，偶数：n-1个位置
会输出靠后的abab->输出bab
```java
int len;
public String longestPalindrome(String s) {
    if(s==null||s.length()<2)return s;
    len = s.length();
    int start = 0;int end = 0;
    // int max = 0;
    for(int i =0;i<len;i++){
        //"babad" ->"bab" ->i =1 len = 3   
        //"cbbd" -> "bb" ->i=1 len = 2
        int len1 = help(s,i,i);//奇数扩展
        int len2 = help(s,i,i+1);//偶数扩展
        int max = Math.max(len1,len2);
        if(max>end-start){
            start = i - (max-1)/2;//去掉中间那个左边长度的一半
            end = i+max/2;//右边长度的一半
        }//end-start= i+max/2-i+(max-1)/2 = max-1/2
    }
    return s.substring(start,end+1);     
    
}
private int help(String s,int left,int right){
    while(left>=0&&right<len&&s.charAt(left)==s.charAt(right)){
        left--;
        right++;
        
    }
    return right-left-1;
}
```

#### Manacher's 算法 O(n) 并不理解
https://algs4.cs.princeton.edu/53substring/Manacher.java.html
1回文半径数组，2最右回文串右边界，3最右回文右边界的最左回文中心
情况1：回文右边界初始为-1，当前扩展位置是0，不在右边界里面，暴力扩，右边界到0位置。
情况2：回文右边界在当前扩展位置右边。
情况2.1：当前位置i的对称点i'的半径在当前最右中心的LR里面，则可以复制对称点的半径
情况2.2：对称点i'的半径超过L 则半径就是i到R
情况2.3：对称点i'的半径和L一样，i要扩展
![mach.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/mach.jpg)

73%
```java
public String longestPalindrome2(String s) {
    StringBuilder sb = new StringBuilder("^#");
    for (int i = 0; i !=s.length() ; i++)
        sb.append(s.charAt(i)).append("#");
    sb.append("$");
    final int N = sb.length();
    int[] p = new int[N];
    //id是长度为mx的回文串的中心
    int id = 0,mx = 0;
    int maxLen = 0,maxId= 0;
    for (int i = 1; i <N-1 ; i++) {
        // i在右边界里面, i'的回文半径长度 和 i到当前最右边界的距离 哪个小取哪个
        // 如果i在右边界上或者i在右边界右边，不用扩展的区域只有自己
        p[i] = mx > i ? Math.min(p[2 * id - i], mx - i ) : 1;
        // 以i为中心扩展
        while(sb.charAt(i+p[i])==sb.charAt(i-p[i]))
            p[i]++;
        // 更新最右边界和其中心
        if(mx < i+p[i]){
            mx = i+p[i];
            id = i;
        }
        // 全局最大回文串和其中心
        if(maxLen < p[i]){
            maxLen = p[i];
            maxId = i;
        }
    }
    int start = (maxId-maxLen)/2;
    return s.substring(start,start+maxLen-1);
}
```

### 572 A树中是否有B作为一个完整的子树
{% note %}
Example 1:
Given tree s:
```
     3
    / \
   4   5
  / \
 1   2
```
Given tree t:
```
   4 
  / \
 1   2
```
True
{% endnote %}

思路1：序列化之后indexOf  (kmp) 注意1每个value用“#”前后分割，2区分左右null
```java
private String tree2string(TreeNode root){
    StringBuilder sb = new StringBuilder();
    sb.append("#"+root.val+"#");
    if(root.left==null)sb.append("l_");
    else
        sb.append(tree2string(root.left));
    if(root.right==null)sb.append("r_");
    else
        sb.append(tree2string(root.right));
    return sb.toString();
}
```

方法2：递归
```java
 public boolean isSubtree(TreeNode s, TreeNode t) {
        if(s == null)return false;
        // 以根为子树相等
        //左子树或者右子树 为子树相等
        if(isSame(s,t))return true;
        return isSubtree(s.left,t) || isSubtree(s.right,t);   
    }
    // 两棵树是不是每个节点都相等
    private boolean isSame(TreeNode s,TreeNode t){
        if(s == null && t == null)return true;
        if(s == null || t == null)return false;
        if(s.val != t.val)return false;
        return isSame(s.left,t.left) && isSame(s.right,t.right);
    }
```

### KMP算法 两个子串
https://www.nowcoder.com/questionTerminal/abf0f0d6b4c44676b44e66060286c45a?orderByHotValue=0&commentTags=Python
{% fold %}
KMP算法核心，在S中indexOf(T),对T建立next数组
1:next数组的用法
![kmp1.png](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/kmp1.png)
2:next数组构建
![kmp2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/kmp2.jpg)

{% endfold %}

给定的一个长度为N的字符串str,查找长度为P(P<N)的字符串在str中的出现次数.下面的说法正确的是()
正确答案: D   你的答案: B (错误)
A不存在比最坏时间复杂度O(NP)好的算法
B不存在比最坏时间复杂度O(N^2)好的算法
C不存在比最坏时间复杂度O(P^2)好的算法
**D存在最坏时间复杂度为O(N+P)的算法**
E存在最坏时间复杂度为O(log(N+P))的算法
以上都不对


{% note %}
给定一个字符串s, 请计算输出含有连续两个s作为子串的最短字符串。 注意两个s可能有重叠部分。例如,"ababa"含有两个"aba". 
{% endnote %}

```java
String in = sc.next();
int n = in.length();
int[] next = new int[n+1];
Arrays.fill(next,0);
next[0] = -1;
next[1] = 0;
for (int i = 2; i < n+1 ; i++) {
    char pre = in.charAt(i-1);
    // 前面多少位和开头一样 后退的位置(个数正好是从头数+1个的位置）
    // abcab next[b] = 2
    int k = next[i-1];
    // 中止 如果 abc k = 0 c和开头的a还是不等，k=-1不能往前匹配了next[i]=0下一个
    while (k!=-1){
        if(in.charAt(k) == pre){
            next[i] = next[i-1]+1;
            break;
        }
        //如果 ab dd abc | ab dd abd
        // k = next[b] = 6 c和d不等，
        // next[c] = 2 d和d相等，所以最后的next[d] = 3
        k = next[k];
    }
}
// 求完最后一个位置的前缀后缀长度 abcdabc next = 3
// abcdabc
//     abc dabc
System.out.println(in+in.substring(next[in.length()]));
```




### lc300 !!!最长上升子序列 最长递增子序列
{% note %}
Input: [10,9,2,5,3,7,101,18]
Output: 4 
Explanation: The longest increasing subsequence is [2,3,7,101], therefore the length is 4. 
{% endnote %}

正常解法
```java
public int lengthOfLIS(int[] nums) {
    if(nums == null || nums.length < 1)return 0;
    int n = nums.length;
    int[] dp = new int[n];
    Arrays.fill(dp,1);
    for(int i = 1;i <n;i++){
        for(int j = 0;j<i;j++){
            if(nums[i] > nums[j]){
                dp[i] = Math.max(dp[i],dp[j]+1);
            }
        }
    }
    int max = 0;
    for(int i : dp){
        max = Math.max(i,max);
    }
    return max;
}
```

nlogn解法!!!
思路：单调栈，用更小的数替换掉前面比它大的数，并且长度不变，只有当这个值比栈顶大，长度才增加。
注意len是只增不减
```java
public int lengthOfLIS(int[] nums) {
   if(nums == null ||nums.length <1)return 0;
    int len = 0;
    int n = nums.length;
    int[] dp = new int[n];
    for(int num:nums){
        // 关键 查找范围是[0,len)
        int i = Arrays.binarySearch(dp,0,len,num);
        if(i < 0){
            i = -(i+1);
        }
        dp[i] = num;
        if(i == len)len++;
    }
    return len;
}
```

### lc354 ！！！！俄罗斯套娃
{% note %}
Input: [[5,4],[6,4],[6,7],[2,3]]
Output: 3 
Explanation: The maximum number of envelopes you can Russian doll is 3 ([2,3] => [5,4] => [6,7]).
{% endnote %}

思路：[0]升序 之后[1]降序.查找[1]应该在的位置。
[1]从大到小排序 (1,3)在(1,2)之前，同宽度按[1]排序，先判断可不可能装，如果能装再缩小[1]。为了同宽度的能套上去的只计数一次，所以先放大的。
`[3, 1] [3, 2] [3, 3]` will get 3, but `[3, 3], [3, 2], [3, 1]` will get 1



### ！798数组rotate，每个位置值比index小计分+1，分最大的旋转位置K
{% note %}
we have [2, 4, 1, 3, 0], and we rotate by K = 2, it becomes [1, 3, 0, 2, 4].  This is worth 3 points because 1 > 0 [no points], 3 > 1 [no points], 0 <= 2 [one point], 2 <= 3 [one point], 4 <= 4 [one point].
{% endnote %}
很多赞的题



### 折纸 折痕
https://www.nowcoder.com/questionTerminal/430180b66a7547e1963b69b1d0efbd3c
二叉树结构。该二叉树的特点是：根节点是下，每一个节点的左节点是下，右节点是上。该二叉树的中序遍历即为答案，但不需要构造一颗二叉树，用递归方法可打印出来。

### ！！！安排机器 有错的题


### ！！！小Q的歌单 01背包求方案数
https://www.nowcoder.com/questionTerminal/f3ab6fe72af34b71a2fd1d83304cbbb3
xA+yB = K ,x<=X,y<=Y有多少种取法
{% note %}
5
2 3 3 3
out:9
{% endnote %}

方法2：01背包问题的方法数
```java
long[][] dp =new long[201][1001];
int[] p = new int[201];
// 展开成背包物品的输入
dp[0][0] = 1;
// 放到[1,x+y]上
for (int i = 1; i <=x ; i++) {p[i] = a;}
for (int i = x+1; i <=x+y ; i++) {p[i] = b;}
// 一共有x+y个物品
for (int i = 1; i <=x+y ; i++) {
    for (int j = 0; j <=k ; j++) {
        if(j >= p[i]){
            dp[i][j] = (dp[i-1][j] + dp[i-1][j-p[i]]) % mod;
        }
        else
            dp[i][j] = dp[i-1][j]%mod;
    }
}
System.out.println(dp[x+y][k]%mod);
```


方法1：组合数 构建 杨辉三角
```java
public static long qlist(int k,int a,int x,int b,int y){
    long mod = 1000000007;
    int max = 101;
    long[][] tri = new long[max][max];
    tri[0][0] = 1;
   for (int i = 1; i < max; i++) {
        tri[i][0] = 1;
       for (int j = 1; j <max ; j++) {
           tri[i][j] = (tri[i-1][j-1] + tri[i-1][j])%mod;
       }
   }
   long sum = 0;
   for (int i = 0; i <=k ; i++) {
       if(i % a == 0 && (k-i) % b ==0 &&  i/a <= 100 && (k - i) / b <= 100)
           sum += tri[x][i/a]*tri[y][(k-i)/b]%mod;
   }
   return sum % mod;
}
```

### lc312 lt168 吹气球
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

![lc312.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lc312.jpg)

回溯法超时ac

1[4,1,5,10]1 如果最后是1[1]1,上一次只有两种可能性1[4,1]1,1[1,5]1。

```java
public int maxCoins(int[] iNums) {
    int[] nums = new int[iNums.length + 2];
    int n = 1;
    for (int x : iNums) if (x > 0) nums[n++] = x;
    nums[0] = nums[n++] = 1;


    int[][] memo = new int[n][n];
    return burst(memo, nums, 0, n - 1);
}

public int burst(int[][] memo, int[] nums, int left, int right) {
    if (left + 1 == right) return 0;
    if (memo[left][right] > 0) return memo[left][right];
    int ans = 0;
    for (int i = left + 1; i < right; ++i)
        ans = Math.max(ans, nums[left] * nums[i] * nums[right] 
        + burst(memo, nums, left, i) + burst(memo, nums, i, right));
    memo[left][right] = ans;
    return ans;
}
```

DP todo


### lc140

### lc391 完美矩形
{% note %}
每个小矩形用左下角和右上角点表示，问能一起是不是一个大矩形。
{% endnote %}

### lt516 房屋染色
{% note %}
给定n个房屋k种颜色的花费
相邻的房屋颜色不同，并且费用最小。
costs = [[14,2,11],[11,14,5],[14,3,10]] return 10
房屋 0 颜色 1, 房屋 1 颜色 2, 房屋 2 颜色 1， 2 + 5 + 3 = 10
{% endnote %}


### lc324 将数组重排成摆动序列
{% note %}
Input: nums = [1, 5, 1, 1, 6, 4]
Output: One possible answer is [1, 4, 1, 5, 1, 6].
{% endnote %}






### 955 删掉几列让String数组排序
{% note %}
Input: ["xga","xfb","yfa"]
Output: 1
{% endnote %}

### poj1408
边长1的木方框，每条边上有n个钉子。一共4n个钉子。切分一根长绳子，只能连接在对边中。
有n个钉子就有2n条切分，就能分割出2(n+1)个格子，返回最大格子的面积。


### poj1273
求pond到stream的最大流量
N是边数，M是点数。1是pond，M是stream。
每一行是从s到e的容量。
{% note %}
5 4
1 2 40
1 4 20
2 4 20
2 3 30
3 4 10
{% endnote %}
算法1：dfs找到一条路，流量是这条路上的最小值。然后把这条路反向，值就是最小值。再dfs。复杂度是 所有边容量C O（C\*(m+n)) 如果有一条边是1，其他便100.可能会执行200次dfs

算法二。用bfs 复杂度是O(nm^2)



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


### 500 判断字符串是不是在键盘的同一行
流： 正则很慢 流也很慢
```java
public String[] findWords(String[] words){
    return Stream.of(words).parallel().filter(s->s.toLowerCase().matches("[qwertyuiop]*|[asdfghjkl]*|[zxcvbnm]*")).toArray(String[]::new);
}
```



### 683 - K Empty Slots

### 最长01串

### 799倒香槟第`[i,j]`个杯子的容积
>输入: poured(倾倒香槟总杯数) = 2, 
query_glass(杯子的位置数) = 1, query_row(行数) = 1
输出: 0.5
解释: 我们在顶层（下标是（0，0）倒了两杯香槟后，有一杯量的香槟将从顶层溢出，位于（1，0）的玻璃杯和（1，1）的玻璃杯平分了这一杯香槟，所以每个玻璃杯有一半的香槟。

第一行流过10杯，则第二行流过9杯，左边分到4.5 右边分到4.5
```java
public double champagneTower(int poured, int query_row, int query_glass) {
    double[][] A= new double[102][102];
    A[0][0] = (double) poured;
    for(int r = 0;r<= query_row;++r){
        for(int c = 0;c<=r;c++){
            double q = (A[r][c] - 1)/2;
            if(q > 0){
                A[r+1][c] += q;
                A[r+1][c+1] += q;
            }
        }
    }
    return Math.min(1,A[query_row][query_glass]);
}
```


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
![digits.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/digits.jpg)

### 百万数字中找最大20个
用开始20个数字构造20个node的最小堆，接下来的数字比root大则replace，insert

### 每秒最大桶数量减半，求t时刻一共消耗了多少
方法1：按递减排序，减半，再排序，一共排序t次
方法2：维持最大堆，每次取root减半再插入



#### 187 rolling-hash DNA序列中出现2次以上长为10的子串
//todo


### 879
G 名成员 第i种犯罪会产生`profit[i]` 利润，需要`group[i]`名成员参与。计划产生P利润有多少种方案。
>Input: G = 5, P = 3, group = [2,2], profit = [2,3]
>output: 2

`dp[k][i][j]` 产生i利润 用j个人 完成前k个任务 的方案数


### 576 无向图访问所有点的最短边数


### ip2cidr
找末尾1的位置`x & -x`


### 131 


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
![scalenetwork.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/scalenetwork.jpg)
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
![shuku.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/shuku.jpg)
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



### 611数组中符合三角形边长的对数 
{% note %}
Input: [2,2,3,4]
Output: 3
Explanation:
Valid combinations are: 
2,3,4 (using the first 2)
2,3,4 (using the second 2)
2,2,3
{% endnote %}
线性扫描 复杂度n^2
![lc611.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lc611.jpg)

思路，排完序之后，固定一个数，用二分双指针，找之前的一个区间两数之和>target
例如
固定 4, 找[2,2,3] +2
固定 3, 找[2,2] +1

```java
public int triangleNumber(int[] nums) {
   int cnt = 0;
    Arrays.sort(nums);
    int n = nums.length;
    for (int i = n-1; i >1 ; i--) {
        int l = 0,r = i-1;
        while (l<r){
            if(nums[l] + nums[r] >nums[i]){
                cnt += r-l;
                r--;
            }else l++;
        }
    }
    return cnt;
}
```

### 判断点D是否在三角形ABC内
思路，计算边AB,BC,CA 顺时针的边和 点D的叉积是不是都>=0
```java
// 计算AB 和 AC的叉积 边AB和点C的叉积
double Product(point A, point B,point C){
    return (B.x - A.x)*(C.y-A.y)-(C.x-A.x)*(B.y-A.y);
}
boolean isIn(point A,point B,point C,point D){
    if(Product(A, B, D) >= 0 && Product(B, C, D) >=0 && Product(C,A,D) >=0){
        return true;
    }
    return false;
}
```


### 812 最大三角形面积
{% note %}
Example:
Input: points = `[[0,0],[0,1],[1,0],[0,2],[2,0]]`
Output: 2
{% endnote %}
三角形面积公式：
https://leetcode.com/problems/largest-triangle-area/discuss/122711/C%2B%2BJavaPython-Solution-with-Explanation-and-Prove
```java
double Product(int[] A, int[] B,int[] C){
        return (B[0] - A[0])*(C[1]-A[1])-(C[0]-A[0])*(B[1]-A[1]);
    }
  public double largestTriangleArea(int[][] p) {
    double rst = 0;
      int n = p.length;
      for(int i = 0;i<n-2;i++){
          for(int j = i+1;j<n-1;j++){
              for(int k = j+1;k<n;k++ ){
                  rst = Math.max(rst,0.5 * Math.abs(Product(p[i],p[j],p[k])));
              }
          }
      }
      return rst;
}
```

### 332 欧拉路径 每条边一次
(这道题不用判断)
只有1个点入度比出度少1（起点）&& 只有一个点入度比出度多1（终点）其余点入度==出度

#### Hierholzer：O(e)
删除边`e(u,v)`，并`dfs(v)`，不断寻找封闭回路，

> 从v点出发一定会回到v。因为入度出度相等。虽然可能不包含所有点和边。
> 总是可以回到以前的点，从另一条路走，把其它所有的边全部遍历掉。

**不是拓扑排序，拓扑排序每个点仅1次**
![Hierholzer1.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/Hierholzer1.jpg)
path里加入{0},{2}头插法{2,0}//保证远的在后面
dfs回到1，继续找封闭回路
![Hierholzer2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/Hierholzer2.jpg)

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
![kolakoski.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/kolakoski.jpg)

#### lc481 返回kolakoski前N中有几个1



### 174 骑士从左上到右下找公主，求初始血量
dp[i][j]表示到i,j的最少血量，因为右下角一格也要减
dp[n-1][m],dp[n][m-1]=1表示走完了右下角还剩下1点血
dp[0~n-2][m]和dp[n][0~m-2]都是非法值，为了取min设置MAX_VALUE
```java
dp[i][j]=Math.max(1,Math.min(dp[i+1][j],dp[i][j+1])-dungeon[i][j]);
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
![shijiebei.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/shijiebei.jpg)


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
![bus1.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/bus1.jpg)
`cnt=2{33:[2, 3]}->`
将{1,10,11,19,27,33}入队
![bus2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/bus2.jpg)
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

### 11 数组index当底边，值当杯子两侧，最大面积

### 242 Anagram 相同字母的单词



### 344 reverse String 
转成char数组/位运算做法77%比stringbuilder好

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




### 443 !压缩字符串
The length after compression must always be smaller than or equal to the original array. aabb可以压缩成a2b2
>Input:
["a","b","b","b","b","b","b","b","b","b","b","b","b"]
Output:
Return 4, and the first 4 characters of the input array should be: ["a","b","1","2"].

```java
public int compress(char[] chars) {
  int n = chars.length;
    int idx = 0;int i = 0;
    while (idx < n){
        char cur = chars[idx];
        int cnt = 0;
        while (idx < n && chars[idx] == cur)
        {
            idx++;
            cnt++;
        }
        chars[i++] = cur;
        if(cnt != 1){
            if(cnt < 10){
               chars[i++] = (char)(cnt +'0'); 
            }else{
            for(char c:Integer.toString(cnt).toCharArray()){
                chars[i++] = c;
            }
            }
        }
    }
    return i;
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

### hiho1892 S中字符可以移动首部，移动最少次数得到T
>选定S中的一个字符Si，将Si移动到字符串首位。  
例如对于S="ABCD"，小Ho可以选择移动B从而得到新的S="BACD"；也可以选择移动C得到"CABD"；也可以选择移动D得到"DABC"。  
请你计算最少需要几次移动操作，可以使S变成T。
in:
ABCD  
DBAC
out:2

思路：T的最后一个字符找到S中的对应位置之后 也就是说 S这个位置之后的，都应该是被提到最前面去了。然后S和T 都向前一格是一样的子问题。
。
```java
public static int trans3(String s,String t){
    if(s.length() != t.length())return -1;
    int n = s.length();
    int[] scnt  = new int[256];
    int[] tcnt  = new int[256];
    for (int i = 0; i <n ; i++) {
        scnt[s.charAt(i)]++;
        tcnt[t.charAt(i)]++;
    }
    for (int i = 0; i <256 ; i++) {
        if(scnt[i]!=tcnt[i])return -1;
    }
    int tidx = n-1;
    int ans = 0;
    for (int i = n-1; i >=0 ; i--) {
        if(s.charAt(i) == t.charAt(tidx)){
            ans++;
            tidx--;
        }
    }
    return n-ans;
}
```


### lc749 病毒隔离
每天只能隔离一片1的圈,而且必须是不隔离会感染最多的圈，每天1会向周围扩散
>Input: 
```
grid = 
[[1,1,1,0,0,0,0,0,0],
 [1,0,1,0,1,1,1,1,1],
 [1,1,1,0,0,0,0,0,0]]
Output: 13
```
Explanation: The region on the left only builds two new walls.

先隔离掉右边的1 用上5+1+5，然后左边扩散了，之需要把`[0][3]`和`[0][4]`隔离了。
还有`[2]`排 所以就只有2个墙了

---


### 456 !132 pattern
> Input: [3, 1, 4, 2]
Output: True
Explanation: There is a 132 pattern in the sequence: [1, 4, 2].

正确做法：栈


方法1：用一个for循环找到当前i之前的min,从[i+1,n)找符合的两个数字
```java
public boolean find132pattern(int[] nums) {
    int n = nums.length;
    int min_i = Integer.MAX_VALUE;
        for(int j = 0;j<n-1;j++){
            min_i = Math.min(min_i,nums[j]);  
            for(int k =j+1;k<n;k++){
               if(nums[k] > min_i && nums[j]>nums[k]){
                   return true;
               }  
            }
        }
    return false;
}
```

### lt700 怎么划分最赚钱 完全背包
```
长度    | 1   2   3   4   5   6   7   8  
--------------------------------------------
价格    | 1   5   8   9  10  17  17  20
```
给出 price = [1, 5, 8, 9, 10, 17, 17, 20], n = 8 返回 22//切成长度为 2 和 6 的两段

dp:(0,n),(1,n-1),...,(n/2,n/2)
二维dp（？）
```java
public int cutting(int[] prices, int n) {
  int[][] dp = new int[n+1][n+1];
    for(int j = 1; j <= n; j++) {
        for(int i = 1; i <=n; i++) {
            dp[i][j] = Math.max(dp[i][j], dp[i-1][j]);
            if(j >= i) {
                dp[i][j] = Math.max(dp[i][j], dp[i][j - i] + prices[i-1]);
            }
        }
    }
    return dp[n][n];
}
```

记忆递归：
{% fold %}
```java
Map<Integer,Integer> map = new HashMap<>();
public int cutting(int[] prices, int n) {
    if(map.containsKey(n))return map.get(n);
    if(n <=0 )return 0;
    if(n == 1)return prices[0];
    int sum = 0;
    for (int i = 1; i <n+1; i++) {
        sum = Math.max(sum, cutting(prices, n-i) + prices[i-1]);
    }
    map.put(n, sum);
    return sum;
}
```
{% endfold %}



### 861 01矩阵反转能得到的最大01行和
> Input: [[0,0,1,1],[1,0,1,0],[1,1,0,0]]
Output: 39
Explanation:
Toggled to [[1,1,1,1],[1,0,0,1],[1,1,1,1]].
0b1111 + 0b1001 + 0b1111 = 15 + 9 + 15 = 39

思路：贪心
1判断行首是0，直接翻转一行，因为2^3比4+2+1还要大
同列是一个数量级2^?的，判断列0和1的个数翻转。

```java
public int matrixScore(int[][] A) {
    int R = A.length, C = A[0].length;
    int ans = 0;
    for (int c = 0; c < C; ++c) {
        int col = 0;
        for (int r = 0; r < R; ++r)
            col += A[r][c] ^ A[r][0];
        ans += Math.max(col, R - col) * (1 << (C-1-c));
    }
    return ans;
}
```



### sw44 判断扑克牌是否顺子
1.排序，
2.数0（大王小王可以当作任意数字）的个数，
3.统计数组相邻数字之间的空缺数

```java
public boolean isContinuous(int[] cards){
    if(cards == null || cards.length <1)return false;
    Arrays.sort(cards);
    int zerocnt = 0;
    for(int card :cards){
        if(card == 0)zerocnt ++;
    }
    int interval = 0;
    for (int i = 1; i <cards.length ; i++) {
        if(cards[i-1] == 0 ||cards[i-1] ==0)continue;
        if(cards[i] == cards[i-1])return false;
        interval += cards[i] - cards[i-1] - 1;

        if(interval > zerocnt)return false;
    }
    return true;
}
```

### 263 Ugly Number 判断是否是丑数
包含因子2、3和5的数称作丑数（Ugly Number）。例如6、8都是丑数，但14不是，因为它包含因子7。 
```java
public boolean isUgly(int num) {
    if(num <=0)return false;
     while( num % 2 ==0){
        num /= 2;
    }
    while(num % 3 ==0){
        num /= 3;
    }
    while( num % 5 ==0){
        num /= 5;
    }
    return num ==1;
}
```

#### 264 输出第n个丑数
正确做法：3ms //todo
```java
public int nthUglyNumber(int n) {
    int[] nums = new int[n];
    nums[0] = 1;
    int t2 = 0, t3 = 0, t5 = 0;
    for (int i = 1; i < n; i++) {
        int m2 = nums[t2] * 2, m3 = nums[t3] * 3, m5 = nums[t5] * 5;
        int mm = Math.min(m2, Math.min(m3, m5));
        if (mm == m2) t2++;
        if (mm == m3) t3++;
        if (mm == m5) t5++;
        nums[i] = mm;
    }
    return nums[n - 1];
}
```

8% 105ms
```java
public int nthUglyNumber(int n) {
    if(n == 1)return 1;
    PriorityQueue<Long> que =new PriorityQueue<>(n);
    que.add(1l);
    for (int i = 1; i <n ; i++) {
        long tmp = que.poll();
        // 重复元素
        while (!que.isEmpty() && que.peek() == tmp)tmp = que.poll();

        que.add(tmp * 2);
        que.add(tmp * 3);
        que.add(tmp * 5);
    }
    return que.poll().intValue();
}
```

### 859 如果交换A字符串中两个字母可以得到B就true
> Input: A = "", B = "aa"
Output: false

1.如果长度不一样，false

> Input: A = "ab", B = "ab"
Output: false
Input: A = "aa", B = "aa"
Output: true

2.如果一样的字符串，一定要有重复的字符

> Input: A = "ab", B = "ba"
Output: true

3.不一样的字符只有2个，记录位置并交换比较。
```java
public boolean buddyStrings(String A, String B) {
    if(A.length() != B.length())return false;
    boolean same = false;
    int[] acnt = new int[26];
    int dif = 0;
    int idx1 = -1,idx2=-1;
    for(int i = 0;i<A.length();i++){
        acnt[A.charAt(i) -'a']++;
        if(acnt[A.charAt(i) -'a'] >=2)same = true;
        if(dif == 0 && i == A.length()-1)return same;
        if(A.charAt(i) != B.charAt(i)){
            dif++;
            if(dif>2)return false;
            if(idx1 < 0 )idx1 = i;
            else idx2 = i;
        }
    }
//        System.out.println(idx1+" "+idx2);
    if(idx1!=idx2)return A.charAt(idx1) == B.charAt(idx2) && A.charAt(idx2) ==B.charAt(idx1);
    return false;
}
```

### lc70爬楼梯
```java
public int climbStairs(int n) {
    int[] dp = new int[n+1];
    dp[0] =1;
    dp[1] =1;
   for(int i =2;i<n+1;i++){
       dp[i] = dp[i-1]+dp[i-2];
   }
    return dp[n];
}
```

> 有一段楼梯台阶有15级台阶，以小明的脚力一步最多只能跨3级，请问小明登上这段楼梯有多少种不同的走法?()

$f(n)=f(n-1)+f(n-2)+f(n-3)$      (对于n>=4) 
$f(n-1)=f(n-2)+f(n-3)+f(n-4)$    (对于n>=5) 
前面两式相减可以得到：  $f(n)=2\*f(n-1)-f(n-4)$  (对于n>=5)
而对于n<=5的情况有： 
f(1)=1 
f(2)=2 
f(3)=4 
f(4)=7 
一直算到15.

```java
public int f(int n){
    if(n <=2)return n;
    if(n == 3)return 4;
    return f(n-1) + f(n-2) + f(n-3);
}
public int f2(int n){
    int[] dp = new int[n+1];
    dp[0] =1;
    dp[1] =1;
    dp[2] =2;
    dp[3] =4;
    for (int i = 4; i <n+1 ; i++) {
        dp[i] = dp[i-1]+dp[i-2]+dp[i-3];
    }
    return dp[n];
}
```


### 栈混洗 火车调度

### 随机数发生器
在 C 语言标准库中，Brian W. Kernighan 和 Dennis M. Ritchie 设计的随机数収生器如下： 
```cpp
unsigned long int next = 1; 
 
/* rand:  return pseudo-random integer on 0..32767 */ 
int rand(void) 
{ 
    next = next * 1103515245 + 12345; 
    return (unsigned int)(next/65536) % 32768; 
} 
 
/* srand:  set seed for rand() */ 
void srand(unsigned int seed) 
{ 
    next = seed; 
} 
```
维护一个32位的无符号长整数next，随着next的“随意”变化，不断输出伪随机数。
通过srand(seed)，可以设置next的初始值（随机种子）。

![randomgen.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/randomgen.jpg)

1. 在next当前值的基础上乘以1103515245 = 3 5   5  7  129749，并加上12345。
2. 通过整除运算在该长整数的二进制展开中截取高16位，进而通过模余运算抹除最高比特位。
经如此的“混沌化”处理之后，即可作为“随机数”返回。 

### 231 2的整数次

### 405 十进制转16进制
{% note %}
Input:
-1
Output:
"ffffffff"
{% endnote %}
每次用1111取右边四位，因为int已经补码表示了，正负都一样取4位直接转。
(2^n的时候 位运算&(n-1)正好是取余（？）)
```java
public String toHex(int num) {
    if(num == 0)return "0";
    String hexs = "0123456789abcdef";
    String str = "";
    while(num != 0){
        str = hexs.charAt((num & 15)) +str;
        num >>>= 4;
    }
    return str;
}
```

### lc 325 lt 919

### 数组嵌套
> `S[i] = {A[i], A[A[i]], A[A[A[i]]], ... }`
>  stop adding right before a duplicate element occurs in S.
>  Input: A = [5,4,0,3,1,6,2]
Output: 4
Explanation: 
A[0] = 5, A[1] = 4, A[2] = 0, A[3] = 3, A[4] = 1, A[5] = 6, A[6] = 2.

>One of the longest S[K]:
>S[0] = {A[0], A[5], A[6], A[2]} = {5, 6, 2, 0}

### 素数定理
从不大于n的自然数随机选一个，它是素数的概率大约是1/ln(n)
https://baike.baidu.com/item/%E7%B4%A0%E6%95%B0%E5%AE%9A%E7%90%86/1972457?fromtitle=%E8%B4%A8%E6%95%B0%E5%AE%9A%E7%90%86&fromid=4710126
1-100有25个素数
```python
>>>math.log(100)
4.605170185988092
```



### 平面最近点对 分治

### !!780 x,y可以向下x步，或者向右y步能否到达tx,ty
>Input: sx = 1, sy = 1, tx = 3, ty = 5
>One series of moves that transforms the starting point to the target is:
(1, 1) -> (1, 2)
(1, 2) -> (3, 2)
(3, 2) -> (3, 5)
out: True

正常递归思路 超时




### lt1472 s任意交换奇数位字符和偶数位字符 能否变成t
>给出 s="abcd"，t="cdab"，返回"Yes"。
第一次a与c交换，第二次b与d交换。

对奇数位和偶数位计数


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
0x3+2\*1+2\*1+1\*2

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


### 87 判断两个字符串是不是拆分成两半二叉树交换子树构成的
```java
public boolean isScramble(String s1, String s2) {
    if(s1.length()!=s2.length())return false;
    if(s1.equals(s2))return true;
    // 不剪枝这一步会TL
    int[] cnt = new int[26];
    for (int i = 0; i <s1.length() ; i++) {
        cnt[s1.charAt(i)-'a']++;
        cnt[s2.charAt(i)-'a']--;
    }
    for (int i = 0; i <26 ; i++) {
        if (cnt[i]!=0) {
            return false;
        }
    }
   
    for (int i = 1; i <s1.length() ; i++) {
        if((isScramble(s1.substring(0,i), s2.substring(0,i))&&
                isScramble(s1.substring(i), s2.substring(i)))||
                (isScramble(s1.substring(0,i), s2.substring(s1.length()-i))&&
                isScramble(s1.substring(i), s2.substring(0,s1.length()-i)))){
            return true;
        }

    }
    return false;
}
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

### 469 lt886 判断凸多边形
{% note %}
输入: points = [[0, 0], [0, 1], [1, 1], [1, 0]]
输出:  true
{% endnote %}
思路：计算3个点的偏向，是否和之前3个点的偏向相同。注意环，最后一个点要模到第1、2个点
```java
double product(int[]A,int[]B,int[]C){
     return (C[1]-A[1])*(B[0]-A[0]) - (C[0]-A[0])*(B[1]-A[1]);
 }
public boolean isConvex(int[][] point) {
    int n = point.length;
    double pre = 0;
    for(int i = 0;i<n;i++){
         double pro = product(point[i],point[(i+1)%n],point[(i+2)%n]);
        if(pro!=0){
            if(pro * pre <0)return false;
            else pre = pro;
        }
    }
    return true;
}
```


### 149 在同一条直线上最多的点数
{% note %}
Input: [[1,1],[2,2],[3,3]]
Output: 3
Explanation:
```
^
|
|        o
|     o
|  o  
+------------->
0  1  2  3  4
```
{% endnote %}
注意如果x相等的斜率应该为INT_MAX不是0. 相同的点要单独算（？）

### 线段上格点的个数
P1=(1,11) P2=(5,3)
out: 3 (2,9) (3,7) (4,5)

答案是gcd(|x1-x2|,|y1-y2|)-1
最大公约数：共有约数中最大的一个
x相差4，y相差8 求分成（/）最多多少份，x,y都是整数


### 区间dp

### lt476石子合并 区间dp
> 有n堆石子排成一列，每堆石子有一个重量w[i], 每次合并可以合并相邻的两堆石子，一次合并的代价为两堆石子的重量和w[i]+w[i+1]。问安排怎样的合并顺序，能够使得总合并代价达到最小
> in : 4 1 1 4 out: 18



### lc84直方图中的最大矩形poj2559
![histo1.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/histo1.jpg)
```java
//todo next
```

---


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

### lt 1487 2sum 最接近target

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



### 916 A单词出现B中所有字母
> b 中的每个字母都出现在 a 中，包括重复出现的字母，那么称单词 b 是单词 a 的子集。 例如，“wrr” 是 “warrior” 的子集，但不是 “world” 

{% note %}
Input: A = ["amazon","apple","facebook","google","leetcode"], B = ["e","o"]
Output: ["facebook","google","leetcode"]
{% endnote %}

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


### Rearrange a string
https://www.geeksforgeeks.org/rearrange-a-string-so-that-all-same-characters-become-at-least-d-distance-away/

### 440 第k小的字典序

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
![lexpermu.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lexpermu.jpg)
 1.从右想左 找到第一次下降位置
 2.用后缀中比当前位置大的最小数字交换
 3.保证后缀最小（翻转？）



### NqueenBB
![nqueenbb.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/nqueenbb.jpg)
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

### 567 s1的一种排列是否在s2中
{% note %}
Input:s1 = "ab" s2 = "eidbaooo"
Output:True
{% endnote %}

正确方法22ms：频率数组在s2中滑动 直到有一个窗口可以把s1全置0
```java
public boolean checkInclusion(String s1, String s2) {
    if(s1.length() > s2.length())return false;
       int[] cnt = new int[26];
    for(int i = 0;i<s1.length();i++){
        char c = s1.charAt(i);
        char c2 = s2.charAt(i);
        cnt[c - 'a'] ++;
        cnt[c2 - 'a'] --;
    }
     if(allzero(cnt))return true;
    for (int i = s1.length(); i <s2.length(); i++) {
        cnt[ s2.charAt(i) - 'a'] --;
        cnt[ s2.charAt(i - s1.length()) - 'a']++;
        if(allzero(cnt))return true;
    }
    return false;

}
private boolean allzero(int[] cnt){
    for(int t : cnt){
        if(t !=0) return false;
    }
    return true;
}
```


129ms
从s2中取每个s1长度的substring 统计字符频率，和s1的频率相等。
```java
public boolean checkInclusion(String s1, String s2) {
        int[] s1cnt = new int[26];
        for(char c : s1.toCharArray()){
            s1cnt[c - 'a'] ++;
        }
        for (int i = 0; i <s2.length()-s1.length()+1 ; i++) {
            String s2tmp = s2.substring(i, i + s1.length());
            if(cntmatch(s1cnt, s2tmp)){
                return true;
            }
        }
        return false;

    }

    boolean cntmatch(int[] s1cnt,String s2){
        int[] s2cnt = new int[26];
        for(char c : s2.toCharArray()){
            int idx = c - 'a';
            s2cnt[idx] ++;
            if(s2cnt[idx] > s1cnt[idx])return false;
        }
        for (int i = 0; i <26 ; i++) {
            if(s2cnt[i] != s1cnt[i])return false;
        }
        return true;
    }
```

1078ms的排序：从s2中取每个s1长度的substring排序，和s1的排序相等。
{% fold %}
```java
public boolean checkInclusion(String s1, String s2) {
    s1 = sort(s1);
    for (int i = 0; i <s2.length()-s1.length()+1 ; i++) {
        if(s1.equals(sort(s2.substring(i,i+s1.length() )))){
            return true;
        }
    }
    return false;
}
String sort(String s1){
    char[] s11 = s1.toCharArray();
    Arrays.sort(s11);
    s1 = new String(s11);
    return s1;
}
```
{% endfold %}

超时的全排列
{% fold %}
```java
boolean flag = false;
public boolean checkInclusion(String s1, String s2) {
    permute(s1, s2, 0);
    return flag;
}

void permute(String s1, String s2, int idx) {
    if (idx == s1.length()) {
        if (s2.indexOf(s1) >= 0)
            flag = true;
    } else {
        char[] chars = s1.toCharArray();
        for (int i = idx; i < s1.length(); i++) {
            char tmp = chars[i];
            chars[i] = chars[idx];
            chars[idx] = tmp;
            String news = new String(chars);
            permute(news, s2, idx + 1);
            chars[idx] =chars[i];
            chars[i] = tmp;
        }
    }
}
```
{% endfold %}

### pdd 数组中找三个数乘积的最大值
{% note %}
3 4 1 2
{% endnote %}
```java
package niuke.pdd;

import java.util.Scanner;

public class chenji {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        long[] nums = new long[n];
        for (int i = 0; i <n ; i++) {
            nums[i] = sc.nextInt();
        }
        if(n == 3){
            System.out.println(nums[0] *
                    nums[1] *
                    nums[2]);

        }else{
            long max1 = Long.MIN_VALUE;
            long max2 = Long.MIN_VALUE;
            long max3 = Long.MIN_VALUE;
            long min1 = Long.MAX_VALUE;
            long min2 = Long.MAX_VALUE;


//            System.out.println(numss.length);
            for (int i = 0; i <n ; i++) {
                Long tmp = nums[i];
//                System.out.println(tmp);
                if(tmp > max1){
                    max3 = max2;max2 = max1;
                    max1 = tmp;
                }else if(tmp > max2){
                    max3 = max2;max2 = tmp;
                }else if(tmp > max3){
                    max3 = tmp;
                }

                if(tmp < min1){
                    min2 = min1;min1 = tmp;
                }else if(tmp < min2){
                    min2 = tmp;
                }
            }
            System.out.println(Math.max(min1*min2*max1, max1*max2*max3));
        }

    }
}
```


### 爱奇艺 平方串  最长公共子序列
{% note %}
如果一个字符串S是由两个字符串T连接而成,即S = T + T, 我们就称S叫做平方串,例如"","aabaab","xxxx"都是平方串.
输入例子1:
frankfurt

输出例子1:
4
{% endnote %}
```java
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    String str = sc.next();

    int n = str.length();
    if (n == 0 || n == 1) System.out.println(0);
    int max = 0;
    for (int i = 1; i <n-1 ; i++) {
        int len = LCS(str.substring(0, i),str.substring(i,n));
        max = Math.max(max, len);
    }
    System.out.println(max*2);

}
// 最长公共子序列 s长度以i结尾，t到j结尾的最长匹配长度
private static int LCS(String s,String t){
    int n = s.length();
    int m = t.length();
    int[][] dp = new int[n+1][m+1];
    for (int i = 0; i <n ; i++) {
        for (int j = 0; j <m ; j++) {
            if(s.charAt(i)==t.charAt(j)){
                dp[i+1][j+1] = dp[i][j]+1;
            }else
                dp[i+1][j+1] = Math.max(dp[i][j+1],dp[i+1][j]);
        }
    }
    return dp[n][m];

}
```


---



### fraction 背包问题
Items can be broen down 贪心按value/weight排序
![knapsack.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/knapsack.jpg)

### 顶点覆盖
![pointcover.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pointcover.jpg)
![vertexcover.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/vertexcover.jpg)

### 最大团：在一个无向图中找出一个点数最多的完全图

### 任务分配问题一般可以在多项式时间内转化成最大流量问题

### hdu 1813 IDA*搜索Iterative Deepening A*,


### tsp 
最小生成树解TSP
![MSTTSP.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/MSTTSP.jpg)
这样求得的最优解不超过真正最优解的2倍
证明：2-近似算法
任何一个哈密顿回路OPT删去一条边就是一个生成树。
我们找的是最小生成树T肯定小于哈密顿回路减1条边的生成树长度
所以T<OPT
所以欧拉回路<2OPT
因为抄近路不会增加长度所以MST生成的结果不会超过2OPT

最小权匹配算法MM
![MMTSP.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/MMTSP.jpg)
1.奇数度的顶点一定是偶数个，将偶数个奇数度定点两两配对
2.将每个匹配加入最小生成树，每个顶点都变成偶数度，得到欧拉图
3.沿着欧拉回路跳过走过的点抄近路 得到哈密顿回路
证明：不超过最优解的1.5倍

代价函数：
在搜索树结点计算的最大化问题以该节点为根的值（可行解/目标函数）的上界。
父节点不小于子节点（最大化问题）

界：到达叶节点得到的最优值
![pagbb.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pagbb.jpg)
![bbtsp.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/bbtsp.jpg)


optaPlanner
![optaplanner.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/optaplanner.jpg)
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
![tspdp.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/tspdp.jpg)


### 频繁元素计算 Misra Gries(MG)算法

### 笛卡尔树

### 链式前向星


### 堆排序不稳定

![stringsort.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/stringsort.jpg)
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
![threepart.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/threepart.jpg)
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
![MSD.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/MSD.jpg)
ASCII的R是256，需要count[258]
Unicode需要65536，可能要几小时
按第0位分组，对每组递归按第1位分组...n
![MSD2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/MSD2.jpg)
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
![LSD.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/LSD.jpg)
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
![indexsort.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/indexsort.jpg)
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

### pdd给定一堆点，判断能连成几个三角形
{% note %}
4
0 0
0 1
1 0
1 1
输出 4
{% endnote %}
思路：遍历所有3个点的组合，只要不是三点共线都行
```java
int a = (x1-x2)*(y1-y3) ;
int b = (y1-y2)*(x1-x3);
if(a!=b)cnt++;
```

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
![mst.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/mst.jpg)
假设分为6和其它点2个集合，在6-2 3-6 6-0 6-4四条连接两个集合的边中取最小边，标记成黑色。
再随机分两个集合，不要让黑色边跨集合

#### kruskal
kruskal遍历所有边(优先队列)，判断边的两点是否在一个集合里(find)，如果在则说明这条边加上会有环，如果不在，则union(v,w)并且将这条边加入mst。直到找到n-1条边。
复杂度$ElogE$ 空间E
- 因为不仅维护优先队列还要union-find所以效率一般比prim慢

#### prim
prim复杂度$ElogV$ 空间V
prim优化：将marked[]和emst[] 替换为两个顶点索引数组edgeTo[] 和distTo[]
![prim.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/prim.jpg)
每个没在MST中的顶点只保留(更新)离mst中点最短的边。

### 聚类：single link
![singlelink.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/singlelink.jpg)
![singleclu.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/singleclu.jpg)


#### Inverse Burrows-Wheeler Transform (IBWT) 生成 Lyndon words.  

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




### 164 桶排序找区间最大值

### 求数组的最大gap

### 二分图 让每条边的两个顶点属于不同的集合
![bipartite.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/bipartite.jpg)
max match：没有两点共享1点，最多的边数
![matching.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/matching.jpg)
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






### 图的度
![graphmostuse.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/graphmostuse.jpg)
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
![graphtra.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/graphtra.jpg)
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
![tuopu.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/tuopu.jpg)

#### 拓扑排序：有向环
> {0, 3}, {1, 3}, {3, 2}, {2, 1} 0-> 3->2->1->3
![graphcy.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/graphcy.jpg)

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





### 本福特定律
以1为首位的数字的概率为30%





### 节点是随机变量的有向无环图=贝叶斯网络BN
求联合概率会用到最小生成树

### 求进制
1. 如果$84\*148=B6A8$成立，则公式采用的是__进制表示的
$(8\*x+4)\*(x^2+4\*x+8)=11\*x^3+6\*x^2+10\*x+8$
$=>(3x^2+6x+2)(x-12)=0$
$=>x=12$
- 快速算法：84和148末尾4\*8=32实际上是8，则32-8=24是12的倍数
24表示在这种进制下个位应该为0

---

假设在n进制下,下面的等式成立,n值是()240*12=2880
正确答案: F   你的答案: E (错误)
19
18
17
16
15
以上都对

逆邻接表：A->B->C->D：B,C,D指向A
 







### DLS可以达到BFS一样空间的DFS




 

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
### ?347桶排序 int数组中最常出现的n个
桶长度为数组长度，数字出现的最高次数为len，把频率相同的放在同一个桶。最后从桶序列高到低遍历。
99%
不用map，遍历一次找到max和min 建len = max-min+1的数组计数
{% fold %}
```java
public List<Integer> topKFrequent(int[] nums, int k) {
    List<Integer> rst = new ArrayList<>();
    if(nums.length == 0) return rst;
    int min = Integer.MAX_VALUE,max = Integer.MIN_VALUE;
    for (int i = 0; i < nums.length; i++) {
        if(nums[i] < min)min = nums[i];
        if(nums[i] >max) max = nums[i];
    }
    int[] data = new int[max-min + 1];
    for (int i = 0; i <nums.length ; i++) {
        data[nums[i] - min]++;
    }
    List<Integer>[] bucket = new ArrayList[nums.length+1];
    for(int i = 0;i<data.length;i++){
        if(data[i]> 0){
            if(bucket[data[i]]== null){
                bucket[data[i]] = new ArrayList<Integer>();
                bucket[data[i]].add(i+min);
            }else{
                bucket[data[i]].add(i+min);
            }
        }
    }
    for(int i =nums.length;i>0;i--){
        if(k<=0)return rst;
        if(bucket[i]!=null){
            rst.addAll(bucket[i]);
            k-=bucket[i].size();
        }
    }
    return rst;

}
```
{% endfold %}
用map AC34%

优先队列O(nlogk)如果k和n的数量差不多 还能维护一个(n-k)的堆 复杂度变成nlog(n-k)




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


---



### 2-3树 
10亿结点的2-3树高度在19-30之间。：math.log(1000000000,3)~math.log(1000000000,2)
与BST不同，2-3树是由下往上构建，防止升序插入10个键高为9的情况
2-3树的高度在$\lfloor log_3N \rfloor=\lfloor logN/log3 \rfloor$ 到$\lfloor lgN \rfloor$ 之间

### 红黑树：将3-结点变成左二叉树，将2-3变成二叉树
有二叉树高效查找和2-3树高效平衡插入
红黑树高度不超过$\lfloor 2logN \rfloor$ 实际上查找长度约为$1.001logN-0.5$

插入：总是用红链接将新结点和父节点链接（如果变成了右红链接需要旋转）

### 160 链表相交于哪一点
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
![mounting.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/mounting.jpg)
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
![fenzhi.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/fenzhi.jpg)



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