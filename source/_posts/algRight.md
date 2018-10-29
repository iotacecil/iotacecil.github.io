---
title: 经典问题 巧妙的算法和DP方程
date: 2018-09-04 11:12:53
tags:
categories: [算法备忘]
---

### poj2686 车票约束的最短路径
![traveldp.jpg](images/traveldp.jpg)
```java
/**
 *
 * 3 4 3路径数量 1 4
 3 1 2
 1 2 10
 2 3 30
 3 4 20
 time = graph[v][w]/hourse[i]
 * @param n ticket number 一张票只能走一条路
 * @param m city number
 * @param graph
 * @param a 起点
 * @param b 终点
 * @param hourse 马的数量
 * @return
 */
public static double mintime(int n,int m,int[][] graph,int a,int b,int[] hourse){
    // dp[S][v]剩下车票S 当前在城市v的最小花费
    double[][] dp = new double[1<<n][m];
    for (int i = 0; i <1<<n ; i++) {
        Arrays.fill(dp[i], inf);
    }
    //起点
    dp[(1<<n)-1][a-1] = 0;
    double res = inf;
    //n = 3 S = 111 用哪个车票的子集
    for (int S = (1<<n)-1; S >=0 ; S--) {
        res = Math.min(res, dp[S][b-1]);
        for (int v = 0; v < m ; v++) {
            //车票i
            for (int i = 0; i < n ; i++) {
                if((S>>i & 1)!=0){
                    for (int u = 0; u <m ; u++) {
                        if(graph[v][u]>=0){
                            dp[S&~(1<<i)][u] = Math.min(dp[S&~(1<<i)][u],dp[S][v]+(double)graph[v][u]/hourse[i]);
                        }
                    }
                }
            }
        }
    }
    if(res == inf){
        return -1;
    }else return res;
}
```

### LCS 最长公共子序列 长度
> "abcd" "becd" ->3("bcd")

{% qnimg dplcs.jpg %}
```java
public int lcs(String s,String t){
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

### 最长上升子序列 LIS
> n = 5,a = {4,2,3,1,5}
> out:3 (2,3,5)

无后效性：可写出递推式。之与子问题函数的状态函数值有关，与到达值的路径无关
子问题：求以`a_k(k=1,2,3...N)`为终点的最长上升子序列长度
max(n个子问题)
- 如果ak比已得最长子序列的最后ai大，则长度+1
`maxLen(k)=max(maxLen(i):i in range(1,k)且ai<ak且k!=1)+1`
```python
for i in range(1,n)
    maxlen[i]=1
for i in range(2,n)
    ##求以ai 为终点的最长
    for j in range(0,i)# ai左边所有的数
        if a[i]>a[j]: # ai为终点的更长
        #？？ maxlen[i]也更新了，可能比manlen[j]+1大
            maxlen[i]=max(maxlen[j]+1,maxlen[i])
```

### 背包9讲:
> dp求解背包问题的复杂度是O(nW)

#### 超大背包v和w都很大，n很小

//364

#### `1<wi<10^7` `1<w<10^9`重量范围很大的01背包！！！ 
测试lt125
> 同01背包：
>  n = 4; A = {2,1,3,2}; V = {3,2,4,2}; W = 5;

{% qnimg dpbag01value.jpg %}
`dp[i+1][j]`表示取前i个物品，获得value j的最小W
```java
int maxV = 100;
int maxW = 1000000000;
public int bigW01bag(int[] A,int[] V,int W)
{
    int n = A.length;
    //dp[i+1][j] 前i个物品中挑选出价值总和为j时的总重量的最小值
    int[][] dp = new int[n+1][n*maxV+1];
    //前0个物品挑任何价值都是INF
    Arrays.fill(dp[0],maxW );
    dp[0][0] = 0;
    for (int i = 0; i <n ; i++) {
        for (int j = 0; j <=n*maxV ; j++) {
            if(j<V[i])dp[i+1][j]=dp[i][j];
            else
                dp[i+1][j] = Math.min(dp[i][j],dp[i][j-V[i]]+A[i] );
        }
    }
    int res = 0;
    //找小于W的最大value
    for (int i = 0; i <= n*maxV ; i++) {
        if(dp[n][i]<=W)res = i;
    }
    return res;
}
```

#### 01背包
N个物品，背包容量V
`F[i,v]`前i件物品放入容量v的背包可获得的最大价值。
如果放第i件，转化为前i-i件放入容量为v-Ci的背包中，最大价值是`F[i-1,v-Ci]+Wi`
$F[i,v]=max{F[i-1,v],F[i-1,v-C_i]+W_i}$
递归
终止条件1：所有物品都装过了->0 2.这个物品w装不下->下一个物品
记忆化递归
```java
int[][] dp;
//参数组合一共nW种 只需要O(nW)复杂度
public int bagmemo(int i,int n,int[][]wv,int w){
    dp = new int[n+1][w+1];
    return memo(i, n, wv, w);
}
public int memo(int i,int n,int[][]wv,int w){
    if(dp[i][w]>0)return dp[i][w];
    int res;
    if(i==n)return 0;
    else if(w<wv[i][0]){
        //不选这个
        res = bagrec(i+1,n,wv,w);
    }else{
        //选和不选
        res = Math.max(bagrec(i+1,n ,wv ,w ),bagrec(i+1, n,wv ,w-wv[i][0])+wv[i][1]);
    }
    dp[i][w] = res;
    return res;
}
```

终止条件：没有物品/剩余重量
```java
private int zoknap(int W,int[] val,int[] wt,int n){
    if(n == 0||W == 0){
        return 0;
    }
    //这个物品超重了 跳过
    if(wt[n-1]>W)return zoknap(W, val, wt,n-1 );
    else return Math.max(val[n-1]+zoknap(W-wt[n-1],val ,wt ,n-1 ),zoknap(W,val ,wt ,n-1) );
}
```
dp 复杂度和记忆化递归一样
逆向
{% qnimg dpbag.jpg %}
n-1->0
```java
public int bagdp(int n,int W,int[][]wv){
    int[][] dp = new int[n+1][W+1];
    for (int i = n-1; i >=0 ; i--) {
        for (int j = 0; j <=W ; j++) {
            if(j<wv[i][0])
                dp[i][j] = dp[i+1][j];
            else
                dp[i][j] = Math.max(dp[i+1][j],dp[i+1][j-wv[i][0]]+wv[i][1]);
        }
    }
    return dp[0][W];
}
```
正向dp
{% qnimg bagdfront.jpg %}

```java
public int frontDp(int n,int W,int[][] wv){
    int[][] dp = new int[n+1][W+1];
    for (int i = 0; i <n ; i++) {
        for (int j = 0; j <=W ; j++) {
            if(wv[i][0]>j)
                dp[i+1][j] = dp[i][j];
            else
                dp[i+1][j] = Math.max(dp[i][j-wv[i][0]]+wv[i][1],dp[i][j]);
        }
    }
     return dp[n][W];
}
```

从前i个物品中选不超过j的状态->前i+1中选不超过j，前i+1不超过`j+w[i]`
{% qnimg dpbag3.jpg %}
```java
public int maxbag(int n,int w,int[][]wv){
    int[][] dp = new int[n+1][w+1];
    for (int i = 0; i <n ; i++) {
        for (int j = 0; j <=w ; j++) {
            dp[i+1][j] = Math.max(dp[i+1][j],dp[i][j]);
            if(j+wv[i][0]<=w)
                dp[i+1][j+wv[i][0]] = Math.max(dp[i+1][j+wv[i][0]],dp[i][j]+wv[i][1]);
        }
    }
    return dp[n][w];
}
```

#### 输出路径
```java
w = W;
for (i = n;  i>0&&res>0 ; i--) {
    if(res ==dp[i-1][w])continue;
    else{
        System.out.println(wt[i-1]+" ");
        res-= val[i-1];
        w-= wt[i-1];
    }
}
```

#### 01背包一维dp
```java
private int zoknapdp1d(int W,int[] wt,int[] val,int n){
    int[] dp = new int [W+1];
    for (int i = 0; i <n ; i++) {
        for (int j = W; j >=wt[i] ; j--) {
            dp[j] = Math.max(dp[j],dp[j-wt[i]]+val[i]);
        }
    }
    return dp[W];
}
```

#### ?taotao要吃鸡
> h为0代表没有装备背包
> n个物品，容量=m+h
> 接下来n行，第i个物品的物品的重量Wi和威力值Vi。0<=Wi,Vi<=100. 
> 当装备背包之后，如果可携带重量没有满，就可以拿一个任意重的东西。
> 3 3 3 
> 2 3 
> 3 2 
> 2 3 
> 0 
> 输出 
> 8 拿了1，2物品val=5,weight=5<6，可以拿3

1.方法1
m+h容量背包，在m+h没装满时可以任意取一个超过重量的
最外层遍历：最后一个超额的物品i.
  计算m+h-1背包容量的最大val
```cpp
int ans = -1;
for(int i =0;i<n;i++){
    ans = max(ans,v[i]+slove(m+h-1),i);
}
int slove(int W,int index){
    for(int i =0;i<n;i++){
        if(i==index)continue;
        for(int j = W;j>=w[i];j--){
            dp[j] = max(dp[j],dp[j-w[i]]+v[i]);
        }
    }
}
```
2.方法2直接dp
    1.按重量排序
```java
for(int i =0;i<n;i++){
    for(int j = m+h;j>=goods[i].w;j--){
        dp[j] = Math.max(dp[j],dp[j-goods[i].w]+goods[i].v);
    }
    if(h>0){
        //强行装的位置,不能填dp[0]，0表示装满了
        for(int j = Math.min(m+h,goods[i].w-1)j>0;j--){
            dp[j] = Math.max(dp[j],goods[i].v);
        }
    }
    out.println(dp[m+h]);
}
```


### 01背包 bb解法
{% fold %}
```java
class Item{
    double weight;
    int value;}
class Node{
    // level  --> Level of node in decision tree (or index
    //             in arr[]
    // profit --> Profit of nodes on path from root to this
    //            node (including this node)
    // bound ---> Upper bound of maximum profit in subtree
    //            of this node/
    int level,profit,bound;
    double weight;}
public class BBpack {
    //用分数背包问题的贪心法求接下去可能的最大值
    public static  int bound(Node u,int n,int W,List<Item> arr){
        if(u.weight>=W)return 0;
        int profit_bound = u.profit;
        int j = u.level+1;
        int totweight = (int)u.weight;
        while(j<n&&(totweight+arr.get(j).weight<=W)){
            totweight += arr.get(j).weight;
            profit_bound += arr.get(j).value;
            j++;
        }
        if(j<n){
            profit_bound+=(W-totweight)*arr.get(j).value/arr.get(j).weight;
        }
        return profit_bound;
    }
    public static int knapsack(int W,List<Item>arr,int n){
        //1. 排序
//        Comparator<Item> comparing = Comparator.comparing(item -> item.value / item.weight);
//        arr.sort(comparing.reversed());
        arr.sort(Comparator.comparing((Item item )-> item.value / item.weight).reversed());
        //2.队列
        System.out.println(arr);
        Deque<Node> que = new ArrayDeque<>();
        // dummy node
        Node u = new Node(-1,0,0);
        Node v = new Node(-1,0,0);
        que.add(u);
        int MaxProfit = 0;
        while(!que.isEmpty()){
            u = que.poll();

            if(u.level == -1){
                v.level =0;
            }
            if(u.level == n-1)continue;
            v.level = u.level+1;
            //装
            v.weight = u.weight+arr.get(v.level).weight;
            v.profit = u.profit+arr.get(v.level).value;
            //如果不超重 更新当前最大收益
            if(v.weight<=W&&v.profit>MaxProfit)
                MaxProfit = v.profit;
            v.bound = bound(v,n ,W ,arr );

            //不装
            if(v.bound>MaxProfit)
                que.add(new Node(v));
            v.weight = u.weight;
            v.profit = u.profit;
            v.bound = bound(v,n,W ,arr);
            //不装也有可能
            if(v.bound>MaxProfit){
                que.add(new Node(v));
            }
        }
        return MaxProfit;
      }
public static void main(String[] args) {
        List<Item> arr= new ArrayList<Item>(5);
        arr.add(new Item(2,40));
        arr.add(new Item(3.14,50));
        arr.add(new Item(1.98,100));
        arr.add(new Item(5,95));
        arr.add(new Item(3,30));
        int W = 10;
        System.out.println(knapsack(W, arr, arr.size()));
    }
```
{% endfold %}



---
#### ！！416 数组分成两部分（不连续) sum相等。list的总sum为奇数则不可能。
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

2.初始化F
- 恰好装满背包，F[0]=0 其余-∞
  没有装任务物品时，只有容量为0的背包表示装满，其它容量为非法解。

- 不用装满，F全部为0
  任何容量的背包，什么都不装，价值F都为0也是合法解。
  
---

#### lt440完全背包 每个物品可用无限次
> n = 3; `[3,4],[4,5],[2,3]`; W = 7;
> out 10 (0选1个，2选2个)

{% qnimg dpcompbag.jpg %}
`dp[i+1][j]`计算k的循环和`dp[i+1][j-w[i]]`计算k-1的循环是重复的

记忆化递归：终止条件，当n==0的时候还要继续削减w
```java
int[][] memo;
public int backPackIII(int[] A, int[] V, int m) {
    if(A==null||V==null||A.length<1||V.length<1)return 0;

    int n = A.length;
    memo = new int[n+1][m+1];
    return backrec(n-1,m,A,V);
}

private int backrec(int n,int w,int[] A,int[] V){
    if(memo[n][w]>0)return memo[n][w];
    if(w==0)return 0;
    if(n==0&&w<A[0])return 0;
    else if(n==0&&w>=A[0])return memo[n][w] = backrec(0,w-A[0],A,V)+V[0];
    else if(n>0){
        if(A[n]>w)return memo[n][w] = backrec(n-1,w,A,V);
        else return memo[n][w] = Math.max(backrec(n-1,w,A,V),backrec(n,w-A[n],A,V)+V[n]);
    }
    return 0;
}
```

```java
public int completeBagDP(int n,int W,int[][] wv){
    //dp[i+1][j]从前i种物品中总重<=j的最大值
    int[][] dp = new int[n+1][W+1];
    for (int i = 0; i < n; i++) {
        for (int j = 0; j <=W ; j++) {
            for (int k = 0; k*wv[i][0] <=j ; k++) {
                dp[i+1][j] = Math.max(dp[i+1][j],dp[i][j-k*wv[i][0]]+k*wv[i][1]);
            }
        }
    }
    return dp[n][W];
    }
```

#### 完全背包一维dp
和01背包的一维dp差别只有循环的方向
```java
public int backPackIII(int[] A, int[] V, int m) {
  int[]dp = new int[m+1];
  int n = A.length;
  for(int i =0;i<n;i++){
    //for(int j = m;j>=A[i];j--)
      for(int j = A[i];j<=m;j++){
          dp[j] = Math.max(dp[j-A[i]]+V[i],dp[j]);
      }
  }
  return dp[m];
}
```

#### 利用奇偶性简化空间`dp[2]`
```java
public int backpackdp2(int[] A, int[] V, int m){
    //只需要计算dp[i+1]和dp[i]
    int[][] dp = new int[2][m+1];
    for (int i = 0; i < A.length; i++) {
        for (int j = 0; j <=m ; j++) {
            if(j<A[i])
            dp[(i+1)&1][j]= dp[i&1][j];
            else
                dp[(i+1)&1][j] = Math.max(dp[i&1][j],dp[(i+1)&1][j-A[i]]+V[i]);
        }
    }
    return dp[A.length&1][m];
}
```
 
- 两个状态转移方程
$F[i,v] = max{F[i-1,v-kC_i]+kW_i|0<=kC_i<=v}$
$F[i,v] = max(F[i-1,v],F[i,v-C_i]+W_i)$

#### exactly装满背包需要的最少/最大物品数量
> Input : W = 100
       `val[]  = {1, 30}`
       `wt[] = {1, 50}`
Output : 100 放100个`{1，1}`是物品数最多的方案

```java
private int multicnt(int W,int n,int[] val,int[] wt){
    int dp[] = new int[W+1];
    for (int i = 0; i <=W ; i++) {
        for (int j = 0; j < n ; j++) {
            if(wt[j]<=i){
                dp[i] = Math.max(dp[i],dp[i-wt[j]]+val[j] );
            }
        }
    }
    return dp[W];
}
```

#### 填满背包的方案数

#### 多重背包 第i种物品最多Mi件可用 能否恰好装满 p62
$F[i,v] = max{F[i-1,v-kC_i]+kW_i|0<=k<=Mi}$
n个不同的数字，每种m个，能否和恰好为K
每种数字，每个最多用m次，能否求和K
> n=3 a = {3,5,8} m = {3,2,2} K = 17

```java
public boolean canSum(int[] A, int[] V,int K){
    int n = A.length;
    //dp[i+1][j]用钱i种数字是否能加和成j
    boolean[][] dp = new boolean[n+1][K+1];
    dp[0][0] = true;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j <=K ; j++) {
            //为了使用数字i，需要i-1数字加成j-vi,j-2*vi,j-m*vi的情况
            for (int k = 0; k <=A[i]&&k*V[i]<=j ; k++) {
                dp[i+1][j] |= dp[i][j-k*A[i]];
            }
        }
    }
    return dp[n][K];
}
```
{% qnimg dpmultibag.jpg %}
```java
public boolean canSumOnk(int[] A,int[] V,int K){
    //dp[i+1][j] 用前i种数求和j 第i种数最多剩多少个 不能得到j 为-1
    int[] dp = new int[K+1];
    int n = A.length;
    Arrays.fill(dp,-1 );
    dp[0] = 0;
    for (int i = 0; i < n ; i++) {
        for (int j = 0; j <=K ; j++) {
            //如果前i-1可以得到j i不用加，剩下全部
            if(dp[j]>=0){
                dp[j] = A[i];
            }else if(j<V[i]||dp[j-V[i]]<=0){
                dp[j] =-1;
            }else{
                //前i-1个可以加出 -V[i]的情况
                dp[j] = dp[j-V[i]]-1;
            }
        }
    }
    return dp[K]>=0;
}
```

> n=3,m=3,a=[1,2,3]

答案
```java
public static int multibagans(int[]a,int n,int m,int M){
    int[][] dp = new int[n+1][m+1];
    //每种都不取
    for (int i = 0; i <=n ; i++) {
        dp[i][0]=1;
    }
   
    for (int i = 0; i <n ; i++) {
        for (int j = 1; j <=m; j++) {
            if(j-1-a[i]>=0)
            dp[i+1][j] = (dp[i+1][j-1]+dp[i][j]-dp[i][j-1-a[i]]+M)%M;
            else 
                dp[i+1][j]=(dp[i+1][j-1]+dp[i][j])%M;
        }
    }
    return dp[n][m];
}
```

### 找钱的方案数
```java
public int waysNCents(int n) {
  int[] coins = {1,5,10,25};    
  int[] dp = new int[n+1];
  dp[0] = 1;
  for(int i =0;i<4;i++){
    for(int j = 1;j<=n;j++){
        if(j-coins[i]>=0)
        dp[j] += dp[j-coins[i]];
    }
  }
  return dp[n];
}
```
lt740 coin change2
```java
public int change(int amount, int[] coins) {
    int n = coins.length;
    int[] dp = new int[amount+1];
    dp[0] =1;
    for(int i=0;i<n;i++){
        for(int j = 1;j<=amount;j++){
            if(j>=coins[i])
                dp[j]+=dp[j-coins[i]];
        }
    }
    return dp[amount];
}
```
递归
```java
int count(int[] coins,int N,int idx){
    if(N==0)return 1;
    if(N<0)return 0;
    if(coins==null||(idx<=0&&N>=1))
        return 0;
    //用/不用这枚硬币(无限次)换
    return count(coins,N ,idx-1)+count(coins,N-coins[idx-1] ,idx);
}
```
二维dp
```java
public int coinDp2(int amount, int[] coins){
    int n = coins.length;
//        Arrays.sort(coins);
    int[][] dp = new int[n+1][amount+1];
    dp[0][0] =1;
    for (int i = 1; i <=n ; i++) {
        for (int j = 0; j <= amount; j++) {
            if(coins[i-1]<=j)
                dp[i][j] += dp[i][j - coins[i-1]];
            dp[i][j]+= dp[i - 1][j];
        }

    }
    return dp[n][amount];
}
```


### 装配线调度问题Assembly Line
{% qnimg assemblyline1.jpg %}
两条装配线分别有相同的n个station
每个任务必须依次通过这n种station
在j号station从装配线1/2换到装配线2/1有额外cost T1(j),T2(j)
每条线用时要加上开始用时10/12和结束用时18/7
{% qnimg assem.jpg %}
```java
public class assembleLine {
    public int assembly(int[][]line,int[][]t,int[]e,int[]x){
        int n = line[0].length;
        int[] T1 = new int[n];
        int[] T2 = new int[n];
        //两条线经过第一个station后的用时
        T1[0] = e[0]+line[0][0];
        T2[0] = e[1]+line[1][0];
        for(int i =1;i<n;i++){
            //line1上第二个station用时是line1前一个用时+当前station 和 从line2上跳过来的用时的min
            T1[i] = Math.min(T1[i-1]+line[0][i],T2[i-1]+t[1][i]+line[0][i]);
            T2[i] = Math.min(T2[i-1]+line[1][i],T1[i-1]+t[0][i]+line[1][i]);
        }
        return Math.min(T1[n-1]+x[0],T2[n-1]+x[1]);
    }
    public static void main(String[] args) {
        //statin num
        int n = 4;
        //[2][4]两条装配线上4个station的耗时
        int[][] line ={
                {4, 5, 3, 2},
                {2, 10, 1, 4}};
        //两条装配线上换装配线到下一个station的额外开销
        int[][] t = {{0, 7, 4, 5},
                {0, 9, 2, 8}};
//        entry time ei and exit time xi
        //要加上的开始时间和结束时间
        int e[] = {10,12};
        int x[] = {18,7};
        assembleLine sl = new assembleLine();
        System.out.println(sl.assembly(line, t, e, x));
    }
}
```

### lt 254 2个鸡蛋从n层楼中找到可以丢碎鸡蛋的楼层，最少几次
1.只能从低往高试，碎了鸡蛋就-1
2.第一次选择楼层n，再向上跳n-1层，再n-2层
假如100层的楼，
$n+(n-1)+(n-2)+...+1>=100$->$(n+1)n/2>=100$ ->n=14
第一次从n层楼投没破，则需要再跳一段再投，cnt++，
当在 n层破了，则需要搜索1~n-1层。
为了平衡向上跳一大格和单步搜索，
**minimize max regret**
所以每次往上跳一大格应该缩短破了之后搜索的间隔，弥补一下cnt的计算。
每次跳一大格，减少单步搜索的次数。

第一次跳到14，如果没破，搜索1~13，在13层破，则最坏情况14步
如果最坏情况跳了14步到达100层破了，跳了14步。

假如10层：策略：
$(1+n)\*n/2>=10$
```python
print(scipy.optimize.fsolve(lambda x: x**2 + 2*x - 20, 0))
```
输出3.58所以4,即4步就能把10层楼遍历掉 4->7->9->10

```java
if(n==1||n==2)return n;
long ans = 0;
//死循环之后外面不需要return语句了
for(int i =1;;i++){
    ans+=(long)i;
    if(ans>=(long)n)
        return i;
}
```

### !!887 K个蛋，N层楼
正确解法：
K个鸡蛋移动M次可以check的最大层数
`dp[m][k] = dp[m - 1][k - 1] + dp[m - 1][k] + 1`
移动1步，
如果碎了可以check`dp[m - 1][k - 1]`层
如果没碎，可以check`dp[m - 1][k]`层
```java
public int superEggDrop(int K, int N) {
    int[][] dp = new int[N + 1][K + 1];
    int m = 0;
    while (dp[m][K] < N) {
        ++m;
        for (int k = 1; k <= K; ++k)
            dp[m][k] = dp[m - 1][k - 1] + dp[m - 1][k] + 1;
    }
    return m;
}
```
压缩成1D 81%
```java
public int superEggDrop(int K, int N) {
    int dp[] = new int[K + 1], m = 0;
    for (m = 0; dp[K] < N; ++m)
        for (int k = K; k > 0; --k)
            dp[k] += dp[k - 1] + 1;
    return m;
}
```

---
drop(9,3)9层楼3个鸡蛋，在6层落下碎了继续[0~5]层drop(5,2),没碎继续[6~9]层drop(3,3)
{% qnimg eggdrop.jpg %}
{% qnimg eggdrop2.jpg %}
超时原因 复杂度O(K\*N^2)
{% fold %}
超时递归
```java
int eggDrop(int k,int n){
    //1层/0层
    if(n==0||n==1)return n;
    if(k==1)return n;
    int min = Integer.MAX_VALUE;
    //[0~5]6[7~9]
    for(int i =1;i<=n;i++){
        int res = Math.max(eggDrop(k-1,i-1),eggDrop(k,n-i));
        min = Math.min(res,min);
    }
    return min+1;
}
```
超时dp
{% qnimg eggdropdp.jpg %}
初始化第一行（鸡蛋）和前两列（楼）
```java
public int superEggDrop(int K, int N) {
    int[][] dp= new int[K+1][N+1];
    //有鸡蛋 两列楼
    for(int i=1;i<=K;i++){
        dp[i][0] = 0;
        dp[i][1] = 1;
    }
    //1个鸡蛋 有楼 一列行 没鸡蛋也没楼第一行默认0
    for(int i =1;i<=N;i++){
        dp[1][i] = i;
    }
    int min = Integer.MAX_VALUE;
    //鸡蛋
    int i,j;
    for( i =2;i<=K;i++){
       
        for( j =2;j<=N;j++){
             dp[i][j] = Integer.MAX_VALUE;
            for(int x = 1;x<=j;x++){
                int res = 1+Math.max(dp[i-1][x-1],dp[i][j-x]);
                dp[i][j] =Math.min(dp[i][j],res);
            }
        }
    }
    return dp[K][N];
}
```
{% endfold %}

#### 加速优化1
[leetcode上的优化和数学方法](https://leetcode.com/articles/super-egg-drop/)
分析递推方程，dp(k-1,x-1)随着x增加递增。dp(k,N-x)随着x增加递减。
{% qnimg eggdp.jpg %}
二分查找到t1=t2的位置是max(t1,t2)最小的位置
复杂度降到复杂度O(K\*NLogN)

5% 263ms
```java
Map<Integer,Integer> memo = new HashMap<>();
public int superEggDrop(int K,int N){
    //1<=k<=100
    if(!memo.containsKey(N*100+K)){
        int ans;
        if(N==0)ans = 0;
        else if(K==1)ans = N;
        else{
            int lo = 1,hi = N;
            while(lo<hi){
                int mid = (lo+hi)/2;
                int t1 = superEggDrop(K-1,mid-1);
                int t2 = superEggDrop(K,N-mid);
                if(t1<t2)lo = mid+1;
                else if(t1>t2) hi = mid;
                //关键
                else lo=hi=mid;
            }
            ans = 1+Math.min(Math.max(superEggDrop(K-1,lo-1),superEggDrop(K,N-lo)),
                Math.max(superEggDrop(K-1,hi-1),superEggDrop(K,N-hi)));
        }
         memo.put(N*100+K,ans);
    }
   return memo.get(N*100+K);
}
```
---

### Celebrity Problem 所有人都认识他但是他不认识所有人
方法1：找全是0的行，O(n^2)
方法2： 如果A认识B，则A肯定不是名人 O(N)；A不认识B，则A可能是名人，B肯定不是名人
A,B不认识，重新入栈A
{% qnimg celebrity.jpg %}
A,C认识，入栈C
{% qnimg celebrity2.jpg %}
{% qnimg celebrity3.jpg %}
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