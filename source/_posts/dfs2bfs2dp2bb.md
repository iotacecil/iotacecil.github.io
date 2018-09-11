---
title: 一些DFS,BFS可以变成DP,BB的计数题
date: 2018-09-09 15:22:54
tags:
---
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

### 343 整数分割求乘积最大值
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
dp[i] = Math.max(dp[i],Math.max(j*(i-j),j*dp[i-j]));
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


### BFS边可以重复访问的访问所有点的最短路径
graph.length = N
> Input: [[1,2,3],[0],[0],[0]] 邻接表
> Output: 4
> Explanation: One possible path is [1,0,2,0,3]

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