---
title: 巧妙的算法和DP方程
date: 2018-09-04 11:12:53
tags:
categories: [算法备忘]
---
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
![assemblyline1.jpg](/images/assemblyline1.jpg)
两条装配线分别有相同的n个station
每个任务必须依次通过这n种station
在j号station从装配线1/2换到装配线2/1有额外cost T1(j),T2(j)
每条线用时要加上开始用时10/12和结束用时18/7
![assem.jpg](/images/assem.jpg)
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
![eggdrop.jpg](/images/eggdrop.jpg)
![eggdrop2.jpg](/images/eggdrop2.jpg)
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
![eggdropdp.jpg](/images/eggdropdp.jpg)
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
![eggdp.jpg](/images/eggdp.jpg)
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
![celebrity.jpg](/images/celebrity.jpg)
A,C认识，入栈C
![celebrity2.jpg](/images/celebrity2.jpg)
![celebrity3.jpg](/images/celebrity3.jpg)
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
