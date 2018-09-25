---
title: 一些DFS,BFS可以变成DP,BB的计数题
date: 2018-09-09 15:22:54
tags:
---
### 784 大小写字母的permutation
`'a'-'A'=32`所以就是`(1<<5)`的位置是0或1，但是不会变快
小写和数字都加上这一位继续dfs，大写要
```java
if(idxchar-'A'>=0&&idxchar-'A'<26||idxchar-'a'>=0&&idxchar-'a'<26){
    idxchar = (char)(idxchar^(1<<5));
    dfs(s,idx+1,cur+idxchar);
    idxchar = (char)(idxchar^(1<<5));
}
    dfs(s,idx+1,cur+idxchar);
```

$C(n,r) = P(n,r)/r!$

### 46 permutations
生成全排列的算法: 移动高位
1的全排列只有1，
1，2的全排列考虑2 放在1前，1后
1，2，3的全排列考虑3 放在 1，2 的全排列的左中右3个位置 一共3*2 = 6种

给定{1..n-1}的排列，存在n种方法将n插入得到{1..n}的排列
n个球放入r个盒子里
分步递推：$P(n,r)=nP(n-1,r-1)$
分类递推：不选第一个球，方案数$P(n-1,r)$,选第一个球方案数$rP(n-1,r-1)$->$P(n,r)=P(n-1,r)+rP(n-1,r-1)$
O(2^n)复杂度 3ms
```java
if(tmp.size()==nums.length){         
    rst.add(new ArrayList<Integer>(tmp));
    return;
}
```
一定要复制一份tmp，不然tmp是对象最后tmp会被remove为空
```java
for(int i =0;i<nums.length;i++){
    //dfs的marked
    if(tmp.contains(nums[i]))continue;
    tmp.add(nums[i]);
    help(rst,nums,tmp);
    tmp.remove(tmp.size()-1);
}
```
O(n!)复杂度 只能处理10个数字
不用contains 用markd数组 3ms
{% fold %}
```java
boolean[] used;
private void dfs(int idx,List<List<Integer>> rst,List<Integer> tmp,int[] nums){
    if(idx>=nums.length){
        rst.add(new ArrayList<>(tmp));
        return;
    }
    //注意 排列无顺序 每次从0开始，但是要去重
    for(int i = 0;i<nums.length;i++){
        if(used[i]) continue;
          used[i] = true;
        tmp.add(nums[i]);
        dfs(idx+1,rst,tmp,nums);
        tmp.remove(tmp.size()-1);
        used[i] = false;   
        }
}
public List<List<Integer>> permute(int[] nums) {
    List<List<Integer>> rst = new ArrayList<>();
    int n = nums.length;
    used = new boolean[n];
    dfs(0,rst,new ArrayList<>(),nums);
    return rst;
}
```
{% endfold %}

方法2 swap java不能int[]->List<Integer>

SJI算法：可移动数

[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,2,1],[3,1,2]]
```cpp
vector<vector<int>> permute(vector<int>& nums) {
    vector<vector<int> > ans;
    help(nums,0,ans);
    return ans;
}
void help(vector<int> &num,int begin,vector<vector<int> > &ans){
    if(begin>=num.size()){
        ans.push_back(num);
        return;
    }
    for(int i =begin;i<num.size();i++){
        swap(num[begin],num[i]);
        help(num,begin+1,ans);
        swap(num[begin],num[i]);
    }
}
```

---

### 39 Combination tum target 不重复元素组合求目标
>candidates = [2,3,6,7], target = 7,
> A solution set is:
>[
>  [7],
>  [2,2,3]
>] 

**注意这种写法 如果输入[1,1,1] 有重复元素的不行**
关键：加上start，防止出现3,2,2的重复
组合比排列dfs的时候多一个`start`,每次只向后取数字 
先输出[2,2,3]
44% 15ms
```java
public List<List<Integer>> combinationSum(int[] candidates, int target) {
    List<List<Integer>> rst = new ArrayList<>();
    Arrays.sort(candidates);
    help(rst,candidates,target,new ArrayList<>(),0);
    return rst;
}
private void help(List<List<Integer>> rst,int[] candi,int target,List<Integer> tmp,int idx){
if(target<0)return;
    if (target == 0) {
        rst.add(new ArrayList<>(tmp));
        return;
    }

for (int i = idx ; i <candi.length; i++) {
    //因为排序了，如果之后元素都大则不用向装这个向后找了
    if(candi[i]>target)break;
        tmp.add(candi[i]);
        //可以使用重复元素则idx,不能重复则idx+1
        help(rst,candi, target-candi[i], tmp,i);
        tmp.remove(tmp.size()-1);
    }
}
```

如果要先输出长度短的：先输出[7] 加个长度d和总长度len
可以作为从N个数里选len个数的模板
```java
public List<List<Integer>> combinationSumLenOrder(int[] candidates, int target) {
    List<List<Integer>> rst = new ArrayList<>();
    Arrays.sort(candidates);
    //最长用第一个元素target/candi[0]次
    for (int i = 1; i <=target/candidates[0] ; i++) {
        dfs(rst,candidates,new ArrayList<>(),target,0,0,i);
    }
    return rst;
}
private void dfs(List<List<Integer>> rst,int[] candi,List<Integer> tmp,int target,int d,int idx,int len){

    if(d==len){
        if(target==0)rst.add(new ArrayList<>(tmp));
        return;
    }
    for (int i = idx; i <candi.length ; i++) {
        if(candi[i]>target)break;
        tmp.add(candi[i]);
        dfs(rst,candi,tmp,target-candi[i],d+1,i,len);
        tmp.remove(tmp.size()-1);
    }
}
```

### lt135 有重复元素的可以利用一个元素多次的comb sum
>>输入[1,1,1],target = 2 -> [[1,1]]

方法1.用set去重 
```java
Set<Integer> set = new HashSet<>();
    for(int i:candidates)set.add(i);
    int[] nums = new int[set.size()];
    int idx =0;
    for(int i:set){
        nums[idx++] = i;
    }
```
方法2.加一行
```java
for(int i = idx;i<candidates.length;i++){
    if(candidates[i]>target)break;
    //跳过重复的
    if(i>0&&candidates[i]==candidates[i-1])continue;
    tmp.add(candidates[i]);
    dfs(rst,candidates,target-candidates[i],tmp,i);
    tmp.remove(tmp.size()-1);
}
```

### 40 有重复元素且每个元素只能用一次的combsum
1.直接用`Set<List>`->`List<List>` 34ms 11%
2. 加上注意一定是`>idx`,不然[1,1]会被跳过
`if(i>idx&&candi[i]==candi[i-1])continue;` 
并且`dfs(rst,candi, target-candi[i], tmp,i+1);`

```java
public List<List<Integer>> combinationSum2(int[] candidates, int target) {
    List<List<Integer>> rst = new ArrayList<>();
    Arrays.sort(candidates);
    dfs(rst,candidates,target,new ArrayList<>(),0);
    return new ArrayList<>(rst);
}
private void dfs(List<List<Integer>> rst,int[] candi,int target,List<Integer> tmp,int idx){
    if(target<0)return;
    if (target == 0) {
        rst.add(new ArrayList<>(tmp));
        return;
    }
    for (int i = idx ; i <candi.length; i++) {
        if(candi[i]>target)break;
        //不是第一个元素，如果是[1,1,1] 这一层不找相同的元素
       if(i>idx&&candi[i]==candi[i-1])continue;
        tmp.add(candi[i]);
        //可以使用重复元素则idx,不能重复则idx+1
        dfs(rst,candi, target-candi[i], tmp,i+1);
        tmp.remove(tmp.size()-1);
    }
}
```

### 216 从1-9中选k个数字组成target
> 输入: k = 3, n = 9
输出: [[1,2,6], [1,3,5], [2,3,4]]

AC 78% 1ms

### lt564 无重复，可用多次，顺序不一样也计数，组成target的个数 dp
>给出 nums = [1, 2, 4], target = 4
可能的所有组合有：
[1, 1, 1, 1]
[1, 1, 2]
[1, 2, 1]
[2, 1, 1]
[2, 2]
[4]
返回 6



### ?90 有重复的subset[1,2,2,2]
1. 选不同的2得到{1,2}是重复的
2. 次序不同得到{1,2},{2,1}是重复的
先排序，再去重。

### 78 subset[1,2,3]->[1][1,2][1,2,3][2,3][2][3]
回溯法：[[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]
```java
public List<List<Integer>> subsets(int[] nums) {
    List<List<Integer>> rst = new ArrayList<>();
    back(rst,new ArrayList<>(),nums,0);
    return rst;
    }
private void back(List<List<Integer>> rst,List<Integer> item,int[] nums,int index){
    rst.add(new ArrayList<>(item));
    for(int i =index;i<nums.length;i++){
        item.add(nums[i]);
        back(rst,item,nums,i+1);
        item.remove(item.size()-1);
    }
}
```
位运算法 集合每一项可以用0，1表示取不取
输出：[[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]] 从000到111的过程
{A,B,C}=111=7
{A,B}=110=6
{A}=100=5...
一共有2^3种
A用100表示
B用010表示
C用001表示
如果i=011=3,添加j=0,001,j=1,010到item；i=100=4,添加j==2,1<<2=4
```java
public List<List<Integer>> subsets(int[] nums) {
    List<List<Integer>> rst = new ArrayList<>();
    for(int i=0;i<(1<<nums.length);i++){
        List<Integer> tmp = new ArrayList<>();
        for(int j =0;j<nums.length;j++){
            if((i&(1<<j))!=0){
                tmp.add(nums[j]);
            }
        }
        rst.add(new ArrayList<>(tmp));
    }
    return rst;
}
```



### 45jump game cnt 2do next time
dp:
```java
 private int jumpdp(int[] nums){
    int n = nums.length;
    int[] dp =  new int[n];
    if(n == 0||nums[0] ==0)return 0;
    dp[0] = 0;
    for (int i = 1; i < n; i++) {
        dp[i] = Integer.MAX_VALUE;
        for (int j = 0; j <i ; j++) {
            if(i<=j+nums[j]&&dp[j]!= Integer.MAX_VALUE){
                dp[i] = Math.min(dp[i],dp[j]+1);
                break;
            }
        }
    }
    return dp[n-1];
}
```
BFS：
```java
public int jumpBFS(int[] nums){
    if(nums==null||nums.length<2)return 0;
    int level = 0;
    int cur = 0;
    int max =0;
    int i =0;
    //cur-i+1=1,level++; i<=cur,i++,max = 2;cur = 2;
    //cur=2,i=1;level++; i<=2,i++,max = 4,max>=n-1 return 2;
    while (cur-i+1>0){
        level++;
        for(;i<=cur;i++){
            max = Math.max(max,nums[i]+i);
            if(max>=nums.length-1)return level;
        }
        cur = max;
    }

    return 0;
}
```
递归
```java
public int minJumpRecur(int[] arr){
    int n = arr.length;
    memo = new int[n][n];
    return jump(arr, 0, n-1);
}
int[][] memo;
private int jump(int[] steps,int from,int end){
//        System.out.println(from+" "+end);
    if(from==end)return 0;
    //不可达
    if(memo[from][end]!=0)return memo[from][end];
    if(steps[from]==0)return Integer.MAX_VALUE;
    int min = Integer.MAX_VALUE;
    //当前可以到达的范围是[from,from+step[from]]
    for(int i = from+1;i<=end&&i<=from+steps[from];i++){
        int jumps = jump(steps,i , end);
        if(jumps!=Integer.MAX_VALUE&&jumps+1<min){
            min = jumps+1;
            memo[from][end] = min;
        }
    }
    return min;
}
```
最正常的做法：
```java
public int jump(int[] nums) {
    if(nums==null||nums.length<2)return 0;
    int res = 0;
    int curMax = 0;
    int maxNext = 0;
    //i=0,max = 2 i==cur ->res++,cur = max=2
    //i=1,max = max(2,4)=4, i!=cur
    //i=2,max = max(4,3)=4, i==cur res++,cur = max=4
    //i=3,max = max(4,4)=4, i!=cur break
    //不需要走到i=4,max = max(4,4+4)=8,i==cur res++,cur=max
    for (int i = 0; i < nums.length-1; i++) {
        maxNext = Math.max(maxNext,i+nums[i] );
        if(i==curMax){
          res++;
          curMax = maxNext;
        }
    }
    return res;
}
```


### 743 从一个node广播，让所有节点收到最多要多久 单源最短路径
> time[[2,1,1],[2,3,1],[3,4,1]] times[i] = (u, v, w) u到v花费w
> N个节点，从K发送
dijkstra如果用heap可以从$N^2$->$NlogN+E$ O(N+E)
Bellman-Ford O(NE)稠密图不好 空间O(N) 可以有负的路径
Floyd-Warshall O(N^3)

heapDijkstra 
78%
//todo faster 

dijkstra:每次扩展距离最近的点 70% 32ms
```java
public int networkDelayTimeDFSDj(int[][] times, int N, int K) {
    Map<Integer,List<int[]>> graph = new HashMap<>();
    for(int[] edge:times) {
        if (!graph.containsKey(edge[0]))
            graph.put(edge[0], new ArrayList<int[]>());
        graph.get(edge[0]).add(new int[]{edge[1], edge[2]});
    }
    int[] dis = new int[N];
    Arrays.fill(dis, Integer.MAX_VALUE);
    dis[K-1]=0;
    boolean[] marked = new boolean[N+1];
    while (true){
        int candNode =-1;
        int canDist = Integer.MAX_VALUE;
        for (int i = 1; i <= N ; i++) {
            //最近的点
            if(!marked[i]&&dis[i-1]<canDist){
                canDist = dis[i-1];
                candNode = i;
            }
        }
//            System.out.println(candNode);
        //都当作扩展点过了,
        if(candNode<0)break;
        marked[candNode] = true;
        //最近点的邻接
        if(graph.containsKey(candNode))
            for(int[] next:graph.get(candNode))
                dis[next[0]-1] = Math.min(dis[next[0]-1],dis[candNode-1]+next[1]);
//            System.out.println(Arrays.toString(dis));
    }
    int ans = 0;
    for(int cost:dis){
        if(cost==Integer.MAX_VALUE)return -1;
        ans= Math.max(ans,cost);
    }
    return ans;
}
```

dfs: 邻接表 建图，递归终止条件:到达所有点花费的时间已经是最小的了
dfs Hashmap6% 改成数组11% 124ms
```java
public int networkDelayTimeDFS(int[][] times, int N, int K) {
    //creategraph
    Map<Integer,List<int[]>> graph = new HashMap<>();
    for(int[] edge:times) {
        if (!graph.containsKey(edge[0]))
            graph.put(edge[0], new ArrayList<int[]>());
        graph.get(edge[0]).add(new int[]{edge[1], edge[2]});
    }//end-creategraph
    //只是为了加速， 不排序2.8% 352ms
    for(int node:graph.keySet()){
        Collections.sort(graph.get(node),(a,b)->a[1]-b[1]);
    }
    dis = new int[N];
    Arrays.fill(dis, Integer.MAX_VALUE);
    dfs(graph,K,0);
    int ans = 0;
    for(int cost:dis){
        ans = Math.max(ans,cost);
    }
    return ans==Integer.MAX_VALUE?-1:ans;
}
//用于记录到某点的距离，如果到这个点花费的时间已经超过记录的最小值了，不对这个点dfs了。
int[] dis;
private void dfs(Map<Integer,List<int[]>> graph,int node,int elased){
    if(elased>=dis[node-1])return;
    dis[node-1]=elased;
    if(graph.containsKey(node)){
        for(int[] nei:graph.get(node))
            dfs(graph,nei[0],elased+nei[1]);
    }
}
```

```java
/**Bellman Ford 边集
 * 从K点广播给N个点需要的最少时间
 * @param times u到v花费w秒 1 <= w <= 100.
 * @param N N will be in the range [1, 100].
 * @param K
 * @return
 */
public int networkDelayTime(int[][] times, int N, int K) {
    int max_time = 100*101;
    int[] dis = new int[N];
    int rst = Integer.MIN_VALUE;
    Arrays.fill(dis,max_time);
    //起点
    dis[K-1] = 0;
    //其他N-1个点
    for (int i = 1; i <N ; i++) {
        //遍历n次边的数组
        for(int[] edge:times){
            int u = edge[0]-1;
            int v = edge[1]-1;
            int w = edge[2];
            //动态规划
            dis[v] = Math.min(dis[v],dis[u]+w);
        }

    }
    for(int cost:dis){
        rst = Math.max(cost,rst );
    }
    return rst == max_time?-1:rst;
}
```

弗洛伊德算法 边集
```java
public int networkDelayTimeF(int[][] times, int N, int K) {
    int max_time = 100*101;
    //二维数组 表示i到j的最短路径
    int[][] dis = new int[N][N];
    for(int[] d:dis){
        Arrays.fill(d,max_time);
    }
    for(int[] time:times){
        dis[time[0]-1][time[1]-1] = time[2];
    }
    for (int i = 0; i <N ; i++) {
        dis[i][i] =0;
    }
    for (int k = 0; k <N ; k++) 
        for (int i = 0; i <N ; i++) 
            for (int j = 0; j <N ; j++) 
                //三维动态规划
                dis[i][j] = Math.min(dis[i][j],dis[i][k]+dis[k][j]);
    int ans = Integer.MIN_VALUE;
    for (int i = 0; i <N ; i++) {
        if(dis[K-1][i]>=max_time)return -1;
        ans = Math.max(ans,dis[K-1][i]);
    }
    return ans;
}
```

### 322找钱最少硬币数
贪心算法一般考举反例。
不能用贪心的原因：如果coin={1,2,5,7,10}则使用2个7组成14是最少的，贪心不成立。
满足贪心则需要coin满足倍数关系{1,5,10,20,100,200}


> 输入：coins = [1, 2, 5], amount = 11
> 输出：3 (11 = 5 + 5 + 1)

1. 递归mincoins(coins,11)=mincoins(coins,11-1)+1=(mincoins,10-1)+1+1..=(mincoins,0)+n

![coinchange.jpg](/images/coinchange.jpg)
递归 记忆子问题 剩下3，用2的硬币变成剩下1的子问题和 剩下2，用1的硬币 剩下1的子问题是相同的。递归给count赋值是从下往上的。
```java
public int coinChange3(int[] coins, int amount) {
    if(amount<1)return 0;
    return coinChange2(coins,amount,new int[amount]);
}
private int coinC(int[] coins,int left,int[] count){
    if(left<0)return -1;
    if(left==0)return 0;
    //关键，不然超时
    if(count[left]!=0)return count[left];
    int min = Integer.MAX_VALUE;
    for(int coin:coins){
        int useCoin = coinC(coins,left-coin,count);
        if(useCoin >=0&&useCoin<min){
            min = 1+useCoin;
        }
    }
    return count[left] = (min==Integer.MAX_VALUE)?-1:min;  
}
```

![coin](/images/coin.jpg)

2. dp:
    注意点：初值如果设为Int的max，两个都是max的话+1变成负数，所以设amount+1
    j 从coin开始
81%~94% 不稳定
```java
int[] dp = new int[amount+1];
Arrays.fill(dp,amount+1);
dp[0] =0;
for(int coin:coins){
    for(int j = coin;j<=amount;j++){
        dp[j]=Math.min(dp[j],dp[j-coin]+1);
    }
}
return dp[amount]>amount?-1:dp[amount];    
```

3. 最正确的方法：dfs分支限界
    1.逆序coins数组 贪心从大硬币开始试
    2.dfs终止条件是 找到硬币整除了，或者idx==0但是不能整除
    3.剪枝条件是 考虑用当前`coins[idx]`i个之后，用下一个硬币至少1个，如果超了break
99%
```java
int minCnt = Integer.MAX_VALUE;
public int coinChangedfs(int[] coins,int amount){
    Arrays.sort(coins);
    dfs(amount,coins.length-1,)
    return minCount == Integer.MAX_VALUE?-1:minCount;
}
private void dfs(int amount,int idx,int[] coins,int count){
    if(amount%coins[idx]==0){
        int bestCnt = count+amount/coins[idx];
        //当[1,2,5] 11, 用掉两个5，count=2 idx=0,cnt+1=3 return
        if(bestCnt<minCnt){
            minCnt = bestCnt;
            //这个return放在里面97%
            return;
        }
        //本来应该放在这里 94%
    }
    if(idx==0)return;
    for(int i = amount/coins[idx];i>=0;i--){
        int leftA = amount - i*coins[idx];
        int useCnt = count+i;
        int nextCoin = coins[idx-1];
        //保证只要left>0都还需要至少1枚硬币
        //或者简单一点if(useCnt+1>minCount)break; 98%
        if(useCnt+(leftA+nextCoin-1)/nextCoin>=minCount)break;
        dfs(leftA,idx-1,coins,useCnt);
    }
}
```


### 91 1-26数字对应26个字母，问一个数字对应多少种解码方式
226->2(B)2(B)6(F),22(V)6(F),2(B)26(Z)
1递归：8%
```java
Map<String,Integer> map = new HashMap<>();
public int numDecodings(String s){
    if(s.length()<1)return 1;
    if(map.containsKey(s))return map.get(s);
    if(s.charAt(0)=='0')return 0;
    if(s.length()==1)return 1;
    w = numDecodings(s.substring(1));
    int pre2 = Integer.parseInt(s.substring(0,2));
    if(pre2<=26){
        w+=numDecodings(s.substring(2));
    }
    map.put(s,w);
    return w;
}
```
2递归改成index 63%
```java
public int numDecodings(String s){
    return help(s,0,s.length()-1);
    }
private int help(String s,int l,int r){
    if(l>s.length()-1)return 1;
    if(s.charAt(0)=='0')return 0;
    if(l>=r)return 1;
    w = help(s,l+1,r);
    int pre2 = (s.charAt(l)-'0')*10+s.charAt(l+1)-'0';
    if(pre2<=26){
        w+=help(s,l+2,r);
    }
    map2.put(l,w);
    return w;
}
```
3.dp[i]表示s[0..i]的解码方式？？？
dp[0]=1
226->s['2']->dp[1]=dp[0]=1
   ->s['2']->s['22']->dp[2]=dp[1]+dp[0]=2
   ->s['6']->s['26']->dp[3]=dp[2]+dp[1]=3

102
当s[i]合法,dp[i]=dp[i-1], dp[1]=dp[0]
当s[i][i-1]合法dp[i]=dp[i-2] ,dp[2]=dp[0]
当s[i-1]s[i]合法，dp[i]=dp[i-1]+dp[i-2]

### 343 整数拆分 并使乘机最大
>Input: 2
Output: 1
Explanation: 2 = 1 + 1, 1 × 1 = 1.

```java
int[] memo;
public int IntegerBread(int n){
    memo = new int[n+1];
    return ib(n);
}
private int ib(int n){
    if(memo[n]!=0)return memo[n];
    if(n==1)return 1;
    int res = -1;
    for(int i=1;i<n;i++){
        res = Math.max(res,Math.max(i*(n-i),i*ib(n-i)));
        memo[n]=res;
    }
    return res;
}
```
dp：
```java
public  int integerBreak(int n) {
   int[] dp = new int[n+1];
    dp[1]=1;
    
    for(int i =2;i<=n;i++){
        for(int j=1;j<=i-1;j++){
            dp[i] = Math.max(dp[i],Math.max(j*(i-j),j*dp[i-j]));
        }
    }
    return dp[n];
```

数学方法：
考虑f=x(N-x) 当x=N/2的时候取最大值。
所以当N是偶数时，最大值是(N/2)*(N/2)
当N是奇数， 最大值是(N-1)/2 *(N+1)/2 
`6, 3 * 3>2 * 2 * 2`
```java
public int integerBreak(int n) {
    if(n==2) return 1;
    if(n==3) return 2;
    int product = 1;
    while(n>4){
        product*=3;
        n-=3;
    }
    product*=n;
    
    return product;
}
```




### 787 中间最多停留k次的，最小花费路线
> Input: n = 3, edges = [[0,1,100],[1,2,100],[0,2,500]]
> src = 0, dst = 2, k = 1
> from src to dst with up to k stops 最小花费
> Output: 200

dfs：复杂度n^(k+1)
1.cost边集->邻接表
```java
Map<Integer, Map<Integer, Integer>> edgeC2graph(int[][]edges,int n){
    Map<Integer, Map<Integer, Integer>> graph = new HashMap<>(n);
    for (int[] edge : edges) {
        graph.putIfAbsent(edge[0], new HashMap<>());
        graph.get(edge[0]).put(edge[1], edge[2]);
    }
    return graph;
}
```

dfs 常规回溯
```java
Map<Integer, Map<Integer, Integer>> graph;
boolean[] visited;
public int findCheapestPrice(int n, int[][] flights, int src, int dst, int K) {
    graph = new HashMap<>(n);
    for (int[] edge : flights) {
        graph.putIfAbsent(edge[0], new HashMap<>());
        graph.get(edge[0]).put(edge[1], edge[2]);
    }
    visited = new boolean[n];
    visited[src] = true;
    dfs(graph, src, dst, K + 1, 0);


    return ans == Integer.MAX_VALUE ? -1 : ans;
}

int ans = Integer.MAX_VALUE;
private void dfs(Map<Integer, Map<Integer, Integer>> graph, int src, int dst, int k, int cost) {
    if (src == dst) {
        ans = cost;
        return;
    }
    if (k == 0) return;
    Map<Integer, Integer> adj = graph.getOrDefault(src,new HashMap<>());
    for (int key : adj.keySet()) {
        if (visited[key]) continue;
        if (cost + adj.get(key) > ans) continue;
        visited[key] = true;
        dfs(graph, key, dst, k - 1, cost + adj.get(key));
        visited[key] = false;
    }
}
```

94ms
bfs:复杂度n^(k+1) Dijkstra 最小优先队列扩展，先扩展加上下一个点cost最小的
```java
public int findCheapestPriceDj(int n, int[][] flights, int src, int dst, int k) {
    Map<Integer, Map<Integer, Integer>> graph = edgeC2graph(flights, n);
    //每次选cost最小的先扩展
    Queue<int[]> que = new PriorityQueue<>(Comparator.comparingInt(a -> a[0]));
    que.add(new int[]{0,src,k+1});
    while(!que.isEmpty()){
        int[] top = que.remove();
        int price = top[0];
        int city = top[1];
        int stops = top[2];
        if(city == dst)return price;
        if(stops>0){
            Map<Integer, Integer> adj = graph.getOrDefault(city, new HashMap<>());
            for(int a:adj.keySet()){
                que.add(new int[]{price+adj.get(a),a,stops-1});
            }
        }
    }
    return -1;
}
```

bellman-ford 单源到所有点的最短路径kn^2 dp
`dp[k][v]` 从起点到v最多k次stop的最小花费
```java
public int findCheapestPriceDp(int n, int[][] flights, int src, int dst, int k) {
    int max = 10001*(k+2);
    //走1~k+1步
    int[][] dp = new int[k+2][n];
    for(int[] ints:dp){
        for (int j = 0; j < n; j++) {
            ints[j] = max;
        }
    }
    dp[0][src] = 0;
    //如果不限制中间k个点，则可以遍历n次
    for (int i = 1; i <= k+1; i++) {
        //走i步走到src ， cost 0
        dp[i][src] = 0;
        for(int[] flight:flights){
            //关键
            dp[i][flight[1]] = Math.min(dp[i][flight[1]],dp[i-1][flight[0]]+flight[2]);
        }
    }
    return dp[k+1][dst]>=max?-1:dp[k+1][dst];
}
```




### ？96 不同的BST数量 catalan数
![numbst.jpg](/images/numbst.jpg)
(为什么是乘)
```
1个节点只有1种，2个节点1    2 一共两种
                      \  /
                      2  1
3个节点1      2      3
      / \    / \    / \
   （0）(2) (1)(1) (2)(0)
      1x2  + 1x1  + 2x1
```
![numbst2.jpg](numbst2.jpg)
![numbst3.jpg](numbst3.jpg)
当n=5 $T[4]+T[1][3]+T[2][2]+T[3][1]+T[4]$

左子树有j个节点，右子树有n-j-1个节点
```java
int[] dp = new int[n+1];
dp[0] = 1;
dp[1] = 1;
//节点个数
for(int i =2;i<=n;i++){
    //左边j个
    for(int j =0;j<i;j++){
        //注意是累加
        dp[i]+=dp[j]*dp[i-j-1];
    }
}
return dp[n];
```
dfs:
```java
public int numTreesDfs(int n) {
    int[] memory = new int[n+1];
    return dfs(n,memory);
}
public int dfs(int n,int[] memroy){
    if(n==0||n==1)return 1;
    if(memroy[n-1]!=0)return memroy[n-1];
    int sum = 0;
    for (int i = 1; i <=n ; i++) {
        sum+=dfs(i-1,memroy)*dfs(n-i,memroy);
    }
    memroy[n-1] = sum;
    return sum;
}
```

![catalannum.jpg](/images/catalannum.jpg)
```java
int ans[] = {1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845, 35357670, 129644790, 477638700, 1767263190};
return ans[n];
```

```java
int res = 0;
if(n<=1)return 1;
for (int i = 0; i < n; i++) {
    res += catalan(i) * catalan(n - i - 1);
}
```

二项式系数
![catalanformu.jpg](/images/catalanformu.jpg)
```java
private int C(int a,int b){
    long res = 1;
    for(int i =0;i<Math.min(b,a-b);i++){
        res=res*(a-i)/(i+1);
    }
    return (int)res;
}
//C(2n,n)/(n+1)
public int catalen2(int n){
    int c =C(2*n,n);
    return c/(n+1);
}
```


### 847 BFS边可以重复访问的访问所有点的最短路径
graph.length = N
> Input: [[1,2,3],[0],[0],[0]] 邻接表
> Output: 4
> Explanation: One possible path is [1,0,2,0,3]



dp：比tsp少判断一次next已经是访问过的点
```java
public int shortestPathLengthDP(int[][] graph) {
    int n = graph.length;
    int[][] dp = new int[n][1<<n];
    Deque<State> que = new ArrayDeque<>();
    for (int i = 0; i < n; i++) {
        Arrays.fill(dp[i],Integer.MAX_VALUE);
        dp[i][1<<i]=0;
        que.add(new State(i,1<<i));
    }
    while(!que.isEmpty()){
        State state = que.poll();
        for(int next:graph[state.source]){
            int nextMask = state.mask|(1<<next);
            if(dp[next][nextMask]>dp[state.source][state.mask]+1){
                dp[next][nextMask] = dp[state.source][state.mask]+1;
                que.add(new State(next,nextMask));
            }
        }
    }
    int res = Integer.MAX_VALUE;
    for (int i = 0; i <n ; i++) {
        res = Math.min(res, dp[i][(1<<n)-1]);
    }
    return res;
}
```

BFS：
1. 定点可以访问多次，用当前搜索节点和当前访问过的节点mask作为visited数组
2. bfs第一层每个顶点都可以作为出发点
3. que中存储`pair<当前节点，访问过的节点>`

{% fold %}
```java
class Pair<K,V>{
        K key;
        V value;
}
public int shortestPathLength(int[][] graph) {
    int n = graph.length;
    int endState = (1<<n)-1;
    Deque<Pair<Integer,Integer>> que = new ArrayDeque<>();
    boolean [][] visited = new boolean[n][1<<n];
    for(int i=0;i<n;i++){
        que.add(new Pair<>(i,1<<i));
    }
    int step =0;
    while(!que.isEmpty()){
        int size = que.size();
        while(size-->0){
            Pair<Integer, Integer> front = que.poll();
            Integer cur = front.key;
            Integer state = front.value;
            // mask全是1，访问了所有点
            if(state == endState) return step;
            if(visited[cur][state])continue;
            visited[cur][state] = true;
            for(int next:graph[cur]){
                que.add(new Pair<>(next,state|(1<<next)));
            }
        }
        step++;
    }
    return -1;
}
```

{% endfold %}