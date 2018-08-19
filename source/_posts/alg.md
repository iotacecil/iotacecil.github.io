---
title: alg
date: 2018-03-24 03:07:34
tags: [alg]
---
### 879

### 576 无向图访问所有点的最短边数

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

### 旋转矩阵
![rotate2d.jpg](/images/rotate2d.jpg)
top=0,bot=3,left=0,right = 3
n是矩阵大小n>1的时候继续，每一圈，矩阵大小-=2
将2赋值给8：
[top+i][right]=[top][left+i]
i=3:3赋值给12
每个i要赋值4遍，上下左右
外层完了之后子问题是top++,left++,right--,bot--,n-=2

方法2：翻转？

### 49 
直接拿CharArray的sort重建String当key 49%


### 56 合并区间 扫描线
方法1：O(nLogn) 需要O(n)空间
1.按起点排序，
2.push第一个interval
3.for全部interval：
  a.不交叉，push
  b.交叉,更新栈顶的end

方法2：分解成`start[],end[]`
starts:   1    2    8    15
ends:     3    6    10    18
push(1,6)
当`start[i+1]<end[i]` `push(start[j],end[i])` 更新`j=i+1`

方法3：原地算法
1.按地点降序排序
2. a如果不是第一个，并且和前一个可以合并，则合并
   b push当前

### 57 插入一个区间并合并
方法1： 将区间插到newInterval.start>interval.start之前的位置，用56的和last比较合并
方法2： 分成left+new+right三部分并合并
```java
public List<Interval> insert(List<Interval> intervals, Interval newInterval) {
     List<Interval> left = new ArrayList<>();
     List<Interval> right = new ArrayList<>();
     int start =newInterval.start;
     int end =newInterval.end;
     for(Interval interval:intervals){
         if(interval.end<newInterval.start){
             left.add(interval);
         }else if(interval.start>newInterval.end){
             right.add(interval);
         }else {
             start = Math.min(start,interval.start);
             end = Math.max(end,interval.end);
         }
     }
     left.add(new Interval(start,end));
     left.addAll(right);
    return left;
}
```

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


### 743 从一个node广播，让所有节点收到最多要多久 单源最短路径
dijkstra如果用heap可以从$N^2$->$NlogN+E$ O(N+E)
Bellman-Ford O(NE)稠密图不好 空间O(N)

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

### 382 随机链表 extremely large and its length is unknown
长度不知，读到第三个node，让它的概率变成1/3，用1/3的概率替换掉之前选择的item
> 由于计算机产生的随机数都是伪随机数，对于相同的随机数引擎会产生一个相同的随机数序列，因此，如果不使用静态变量（static），会出现每次调用包含随机数引擎的函数时，随机数会重新开始产生随机数，因此会产生相同的一串随机数。比如你第一次调用产生100个随机数，第二次调用仍然会产生这一百个随机数。如果将随机数引擎设置为静态变量，那么第一次调用会产生随机数序列中的前100个随机数，第二次调用则会产生第100到200的随机数。

### 频繁元素计算 Misra Gries(MG)算法


### 最小生成树

### 笛卡尔树

### RMQ


### 链式前向星


### 堆排序不稳定

### 三向快速排序
![threepart.jpg](/images/threepart.jpg)
取第一位，将所有字符串分成3份

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

### 数组组成三角形的最大周长
贪心，排序，如果 $a[i]<a[i-1]+a[i-2]$ 则没有其他两条边可以两边之和`>`第三边了，换下一条当最长边。

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

### 106 中序+后序建树

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

> Input: tickets = [["MUC", "LHR"], ["JFK", "MUC"], ["SFO", "SJC"], ["LHR", "SFO"]]
> Output: ["JFK", "MUC", "LHR", "SFO", "SJC"]

1. 用hashmap记录每个点的出度的点，建图
2. 输出字典序靠前的序列，用优先队列，先访问的会后回溯到dfs插到链表头。（后序遍历：全部遍历完了再加入（退栈)）

```java
public List<String> findItinerary(String[][] tickets){
    Map<String,PriorityQueue<String>> graph = new HashMap<>();
    List<String> rst = new ArrayList<>();
    for(String[] edge:tickets){
        graph.putIfAbsent(edge[0],new PriorityQueue<>());
        graph.putIfAbsent(edge[1],new PriorityQueue<>());
        map.get(edge[0]).add(edge(1));
    }
    dfs("JFK",rst,graph);
    return rst;
}
private void dfs(String s,List<String> rst,Map<String,PriorityQueue<String>>graph){
    PriorityQueue<String> edge = graph.get(s);
    if(edge!=null&&!edge.isEmpty()){
        dfs(edge.poll(),rst,graph);
    }
    rst.addFirst(s);
}
```
后序遍历stack：
```java

```

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
    if(tmp.contains(nums[i]))continue;
    tmp.add(nums[i]);
    help(rst,nums,tmp);
    tmp.remove(tmp.size()-1);
}
```
O(n!)复杂度

### 39 等于target的每个数字无限次的combination
关键：加上start，防止出现3,2,2的重复

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
boolean isTwo = true;
public boolean isBipartite(int[][] graph) {
    marked = new boolean[graph.length];
    color = new boolean[graph.length];
    for (int s = 0; s <graph.length ; s++) {
        if(!marked[s]&&!dfs(graph,s))return false;
    }
    return true;
}
private boolean dfs(int[][] graph,int v){
    marked(v)=true;
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

### 5只猴子分桃，每次拿走一个正好分成5堆，问桃子数

### !543树中两点的最远路径，自己到自己0
> [4,2,1,3]路径长度3

![lc545](/images/lc545.jpg)
将每个点试当成转折点,在更新左右最长高度的同时更新rst = Max(rst,l+r);

### ！！687树中值相等的点的路径长

### !!!114原地将二叉树变成链表
1.入栈迭代40%
    1. 先入栈右子树，再入栈左子树，更新右节点为栈顶。
    2. 将当前左子树变成null。下一次循环cur是栈顶（原左子树）
2. 后序遍历 递归6%
```java
pre = null;
flat(root.right);
flat(root.left);
root.right = pre;
root.left = null;
pre = root;
```

### 174 骑士从左上到右下找公主，求初始血量
dp[i][j]表示到i,j的最少血量，因为右下角一格也要减
dp[n-1][m],dp[n][m-1]=1表示走完了右下角还剩下1点血
dp[0~n-2][m]和dp[n][0~m-2]都是非法值，为了取min设置MAX_VALUE
```java
dp[i][j]=Math.max(1,Math.min(dp[i+1][j],dp[i][j+1])-dungeon[i][j]);
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
    ans+=(long)n;
    if(ans>=(long)n)
        return i;
}
```

### lt 584 m个蛋，n层楼最少次数




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
递归95%
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
### ？96 不同的BST数量
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
左子树有j个节点，右子树有n-j-1个节点
```java
int[] dp = new int[n+1];
dp[0] = 1;
dp[1] = 1;
//节点个数
for(int i =2;i<=n;i++){
    //左边j个
    for(int j =0;j<i;j++){
        dp[i]+=dp[j]*dp[i-j-1];
    }
}
return dp[n];
```

### ！95 输出全部不同的BST
[1~n]组成的BST
```
1.......k...n
       / \
[1~k-1]  [k+1,n] 与上一层的构建过程是一样的
```

---

### 背包9讲:
#### 01背包
N个物品，背包容量V
F[i,v]前i件物品放入容量v的背包可获得的最大价值。
如果放第i件，转化为前i-i件放入容量为v-Ci的背包中，最大价值是F[i-1,v-Ci]+Wi
$F[i,v]=max{F[i-1,v],F[i-1,v-C_i]+W_i}$
```c
for i<- 1 to N
  for v<- Ci to V
    F[i,v]<-max{F[i-1,v],F[i-1,v-Ci]+Wi}
```
时间/空间复杂度O（VN)
1.简化空间->O(V) 递减顺序计算F[v]，保证计算F[v]时F[v-Ci] 保存的是F[i-1,v-Ci] 
```c
for i<- 1 to N
  for v <- V to Ci
    F[v] <- max(F[v],F[v-Ci]+Wi)
```
第二个for可以优化
for v<- V to max(V-$\sum_{i}^{N}W_i$,Ci)

#### taotao要吃鸡
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

---
#### ！416 数组分成两部分（不连续) sum相等。list的总sum为奇数则不可能。
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

#### 完全背包 每个物品可用无限次
简化1.如果Ci<=Cj,Wi>=Wj 则j可以不考虑。
简化2.重量大于V的去掉。用计数排序算出v相同的物品中价值最高的那个O(V+N)
转化成01背包：将第i种物品拆成重量$C_i2^k$价值为$W_i2^k$ 件数可写成若干个$2^k$件的组合
用递增的循环O(VN)：
 01背包V<-V to Ci 因为保证选i件物品时F[i-1,v-Ci]是绝对没有选第i件物品的情况
 而完全背包的子结果F[i,v-Ci]是**加选一件第i种物品**
```c
for i<- 1 to N
  for v<- Ci to V
    F[v]<- max(F[v],F[v-Ci]+Wi)
```
- 两个状态转移方程
$F[i,v] = max {F[i-1,v-kC_i]+kW_i|0<=kC_i<=v} $
$F[i,v] = max(F[i-1,v],F[i,v-C_i]+W_i)$

---
#### 多重背包 第i种物品最多Mi件可用
$F[i,v] = max{F[i-1,v-kC_i]+kW_i|0<=k<=Mi}$

### 本福特定律
以1为首位的数字的概率为30%

### 786 数组中可能组成的分数排序后第k大的是哪个组合
数组长度2000 n^2的算法是超时
> A = [1, 2, 3, 5], K = 3
> Output: [2, 5]
Explanation:
The fractions to be considered in sorted order are:
1/5, 1/3, 2/5, 1/2, 3/5, 2/3.
The third fraction is 2/5.

`M[i][j]=A[i]/A[j]`肯定在右上角最小
```
1/2 1/3 1/5 
-   2/3 2/5
-   -   3/5
```
1 查比0.5小有1/2,1/3,2/5 大于3个 r =0.5
2 查比0.25小的有1/5 l=0.25
3 查比0.375小的有1/3,1/5 l=0.375
4 查比0.475小的正好3个



### 378 矩阵从左到右从上到下有序，找第k大个元素
1.全部放进k大的PriorityQueue,最后poll掉k-1个，return peek 28%
2.

### 719

### 正确二分查找的写法
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

### 34 二分查找数字的first+last idx？？？？？？
> Input: nums = [5,7,7,8,8,10], target = 8
> Output: [3,4]

二分查找获取最左/右边相等的
```java
//获取最右
while(i<j){
 int mid = (i+j)/2+1;
 if(nums[mid]>target)j = mid-1;
 //找到了继续向右找
 else i =mid;}
rst[1]=j;
```

---
### 307 求数组范围和，并且带更新元素
#### Binary Index Tree
与dp不同，dp[i]存储了前i个的总和 e只存部分
[visualgo可视化](https://visualgo.net/bn/fenwicktree)
1.update树
每个叶子节点的父节点的计算方法i+lowbit(i)
1的父节点=001+001=010
2的父节点=010+010=100==4
4的父节点=100+100 = 1000==8
***
最低位：lowbit(5) = 101&((010+1)==011)=001
5的父节点=101+001=110==6
沿着path向上更新，最多只会更新logn(树高个节点)
```java
void update(int i,int val){
    int dif = val-nums[i];
    nums[i++]=val;
    while(i<e.length){
        e[i]+=dif;
        i+=(i&-i);
    }
}
```
![BIT](/images/BIT.jpg)
2.sum树 前7个元素的和=7+11+10
```java
int query(int i){
    int sum = 0;
    while(i>0){
        sum+=e[i];
        i-=(i&-i);
    }
    return sum;
}
int rangeSum(int i,int j){
    return query(j+1)-query(i);
}
```

| k=末尾零个数 | 二进制末尾有k个0则e[i] 是2^k个元素的和 |
| ---------| ------------------------ |
| 1 -> 1   | e[1]=a[1]                |
| 2 -> 10  | e[2]=a[1]+a[2]           |
| 3 -> 11  | e[3]=a[3]                |
| 4 -> 100 | e[4]=a[1]+a[2]+a[3]+a[4] = e[2]+e[3]+a[4] |
| 5 -> 101 | e[5]=a[5] |
| 6 -> 110 | e[6] = e[5]+e[6] |
| 7 -> 111 | e[7] = a[7] |
| 8 -> 1000 | e[8] = e[4]+e[6]+e[7]+a[8] |

#### ？？？315 输出数组每个位置后有多少个数字比它小
暴力n^2复杂度一般只能到1k数量级

方法一：
1.把input倒序，并映射到argsort的index
2.建立unique frequence list 原数组中unique的元素+1
3.逆序扫描input，更新相应的frequence[rank]++。
    并求frequence rank-1前的sum #有几个元素比当前元素小
4.依次读入的sum list 倒序就是结果

方法2：BST
1.逆序读入建BST 动态更新 并sum所有有右节点的count+left累加和

方法3：归并排序

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
        int mid = l+((r-l)>>2);
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
### 80 数组每个元素只保留<=2次
cnt表示插入位置，i用于遍历 
```java
int cnt=2;
for(int i =2;i<nums.length;i++){
    if(nums[i]!=nums[cnt-2]){
        nums[cnt++] = nums[i];
    }
}
```

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

### 连通分量
![connect.jpg](/images/connect.jpg)
无向图的连通分量可以用并查集（集合）来做
并查集：[12,3,4,5]->[6,2,3,4,5]位置存放的是根节点
![unionfind.jpg](/images/unionfind.jpg)
有向图的连通分量Kosaraju 算法4p380
![kosaraju.jpg](/images/kosaraju.jpg)
1.将图的边反向,dfs得到逆后序
2.按逆后序列dfs原图 cnt++
![kosaraju2.jpg](/images/kosaraju2.jpg)

[tarjan](https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm)

https://algs4.cs.princeton.edu/42digraph/TarjanSCC.java.html
和拓扑排序一样Tarjan算法的运行效率也比Kosaraju算法高30%左右
每个顶点都被访问了一次，且只进出了一次堆栈，每条边也只被访问了一次，所以该算法的时间复杂度为O(N+M)。

### 452 重叠线段
```java
int cnt =0;
//按结束顺序排序不会出现
//  |__|     只有：  |___| 和 |____|
//|______|的情况  |____|       |_|
Arrays.sort(points,(a,b)->a[1]>b[1])
for(int i =0;i<points.length;i++){
    int cur = points[i][1];
    cnt++;
    while(i+1<points.length&&points[i+1][0]<=cur&&cur<=points[i+1][1]){
        i++;
    }
}
return cnt;
```
前一个的end在i+1的线段中，则跳过。
问题：
```
{{1,3},{2,5},{4,7},{6,9}}输出2还是3？
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


---
### 236 最低的二叉树公共祖先
终止条件`root==null|root==q||root=p`
1. 在左/右子树找p|q，两边都能找到一个值（因为值不重复） 则返回当前root
2. 如果左边没找到p|q，右边找到了p|q，最低的祖先就是找到的p|q，(因为保证p|q一定在树中)


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
### 139 word break
1.状态：boolean[n+1]长度为i的前缀能否由字典组成
2.初始值：[0]=true 空字符串
3.转移方程if(dp[i]==true&&dic.contains(sub(i,i+j))) dp[i+j]=true
4.结果

```java
f[0]=true;
for(int i =1;i<s.length();i++){
    for(int j=0;j<i;j++){
        if(f[j]&&dic.contains(s.substring(j,i))){
            f[i]=true;
            break;
        }
    }
}
return f[s.length()];
```

---
### 55 ?jump game
[jump game](https://leetcode.com/problems/jump-game/solution/)
i+nums[i]大于lastp表示i位置可以跳到lastp位置。
将lastp更新成现在的i。再向前直到lastp变成0，表示0位置可以到下一个lastp一直到len-1。
```java
lastp = len-1;
for(int i =len-1;i>=0;i--)
    if(i+nums[i]>=lastp)lastp==i;
return lastp==0;
```

### 45 ?jump game最少跳跃次数
1.在本次可跳跃的长度范围内如果不能达到len-1则表示一定要跳跃
2.BFS

### 322找钱最少硬币数
贪心算法一般考举反例。
不能用贪心的原因：如果coin={1,2,5,7,10}则使用2个7组成14是最少的，贪心不成立。
满足贪心则需要coin满足倍数关系{1,5,10,20,100,200}

输入：coins = [1, 2, 5], amount = 11
输出：3 (11 = 5 + 5 + 1)
1. 递归mincoins(coins,11)=mincoins(coins,11-1)+1=(mincoins,10-1)+1+1..=(mincoins,0)+n
![coin](/images/coin.jpg)

2. dp:
    1. 初始化table[amount+1]={0,max,max...}
    2. table[5]=table[0]对每个coin重填整行表格
    3. if(amount>=coin)dp[amoun]+=dp[amount-coin]
3. dfs分支限界
    1.逆序coins数组 贪心从大硬币开始试

定义dp[i][j]用前i种硬币达到amount[j]最少的硬币数量
用1，2，5组成11的数量=只用1,2组成11的数量+1，2，5组成[11-5]
1. ?dp[i][j]=min(dp[i][j],dp[i-1][j-k\*coin[i]]+k)：[i-1]不用这枚硬币之前能够到加上k枚i硬币达到amount[J]。需要遍历n.复杂度n\*amount^2
2.不需要遍历几枚硬币dp[i][j]=min(dp[i][j],dp[i][j-coin[i]]+1).复杂度n\*amount 降成了一维。dp[i]=dp[i-coin[i]]+1
基础：dp[amount] 当amount=0时，dp=0;当coin有1时dp[i]=i

---
### 网络流
1. 最小割 st-cut 去掉这几条边，源点S和终点T就会被分为两个不相交的set，S到不了T。这种边集的最小值
断掉两点间的通信的最小代价。
2. 最大流max-flow 边的流量小于capacity。每个点的入流和出流相等。除了源点S和终点T。求源点/终点能发出/接收的最大值。

其实可以是一个问题。

#### Ford-fulkerson算法
1 先假设每条边的当前流量是0/capacity
2 找到S到T的路径，并最大化这条路径上的空的边的当前流量 
3 继续找路径，如果可以通过一条边的反向到达T，经过的是一条边的反向流，则减少这条边逆向流过去。
4 每条边到达正向包和或者负向为0 不能remove from backward edge

#### flow value lemma :最小cut上的流量 == 最大网络流
flow <= capacity of cut
max flw == min cut

#### 已知最大流(cur/capacity) 求cut
从S点 正向走最不满的正向流。走最满的逆向流，满正向流和空逆向流当作不存在。

#### 如何找augmenting path BFS
如果容量都是integer
number of augemntation <= maxflow value 每次增加至少1

---
### TrieNode字典树 find/insert复杂度为字符串长度
结点保存子节点（指针）的目录[26]下一个字符
和结点是否终止boolean
```java
struct TrieNode{
    TrieNode* children[26];
    boolean terminal;
}
```
可以把terminal变成int用`map<String,int>`表示字典树

#### 677计算单词前缀的累积和
```cpp
struct Trie{
    Trie():children(128,nullptr),sum(0){}
    ~Trie(){
        //动态分配内存 内存泄漏 写析构会递归删除 
        for(auto child:children){
            if(child)delete child;
        }
        children.clear();
    }
    vector<Trie*> children;
    int sum;
    }
};
```

### 后缀树字典树 每层多一个字符的字典树
### 后缀树 对字典树路径压缩，一层多个字符 生成需要O(N^2)

### 后缀数组 A[]后缀的起始位置
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

{% fold %}
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
第一轮：1进入1/8赢的概率是[1][2] 1打败2的概率=0.133
第二轮：1赢了1/8进入1/4赢的概率是
```
1在第2轮的获胜概率是0加上1在上一轮胜利的概率0.133 ×3在上一轮获胜的概率0.335×1赢3的概率0.21
1 2 0.00935655
1在第2轮的获胜概率是0.00935655加上1在上一轮胜利的概率0.133 ×4在上一轮获胜的概率0.665×1赢4的概率0.292
1 2 0.0351825```
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
### KMP
文本串T某个前缀的后缀是模式串P的前缀。取最长的后缀。
1 子序列 不连续 2 字串 连续
KMP:getIndexOf
d之前【最长前缀】和【最长后缀】的匹配长度
(abcabc)d 前缀：(a->ab->abc->...->abcab) 后缀:(c->bc->abc->...->bcabc)
所以最长匹配是3：abc,记录在d位置上
int[]next =  f("abcabcd")={-1,0,0,1，2，3}
关键加速求解匹配

---
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
        //1.当i=2+1==nums.length 则回到上一层i=2,remove
        back(rst,item,nums,i+1);
        //2.结束了back(,,2)并去掉了{3} 
        //3回到back(,,index=1)并去掉了[2] item里只有1，
        //  i++ 添加[3]->rst.add({1,3})
        //4.结束back(,,index=1)回到index=0 remove 0 index=1 add{2} back
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
  int setnum = 1<<nums.length;
    List<List<Integer>> rst = new ArrayList<>();
    for(int i =0;i<setnum;i++){
        List<Integer> item = new ArrayList<>();
        for(int j=0;j<nums.length;j++){
            if((i&(1<<j))!=0)
            {
                item.add(nums[j]);
            }
        }
        rst.add(item);
    }
    return rst;
}
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
### ！30 字典中单词连续出现在字符串中的位置 AC自动机（？
加入字典的常用写法`dict.put(word,dict.getOrDefault(word,0)+1)`
{% fold %}
```java
class Solution {
public List<Integer> findSubstring(String s, String[] words) {
    List<Integer> res = new ArrayList<Integer>();
    int n = s.length(), m = words.length, k;
    if (n == 0 || m == 0 || (k = words[0].length()) == 0)
        return res;

    HashMap<String, Integer> wDict = new HashMap<String, Integer>();

    for (String word : words) {
        if (wDict.containsKey(word))
            wDict.put(word, wDict.get(word) + 1);
        else
            wDict.put(word, 1);
    }

    int i, j, start, x, wordsLen = m * k;
    HashMap<String, Integer> curDict = new HashMap<String, Integer>();
    String test, temp;
    for (i = 0; i < k; i++) {
        curDict.clear();
        start = i;
        if (start + wordsLen > n)
            return res;
        for (j = i; j + k <= n; j += k) {
            test = s.substring(j, j + k);

            if (wDict.containsKey(test)) {
                if (!curDict.containsKey(test)) {
                    curDict.put(test, 1);

                    start = checkFound(res, start, wordsLen, j, k, curDict, s);
                    continue;
                }

                // curDict.containsKey(test)
                x = curDict.get(test);
                if (x < wDict.get(test)) {
                    curDict.put(test, x + 1);

                    start = checkFound(res, start, wordsLen, j, k, curDict, s);
                    continue;
                }

                // curDict.get(test)==wDict.get(test), slide start to
                // the next word of the first same word as test
                while (!(temp = s.substring(start, start + k)).equals(test)) {
                    decreaseCount(curDict, temp);
                    start += k;
                }
                start += k;
                if (start + wordsLen > n)
                    break;
                continue;
            }

            // totally failed up to index j+k, slide start and reset all
            start = j + k;
            if (start + wordsLen > n)
                break;
            curDict.clear();
        }
    }
    return res;
}

public int checkFound(List<Integer> res, int start, int wordsLen, int j, int k,
        HashMap<String, Integer> curDict, String s) {
    if (start + wordsLen == j + k) {
        res.add(start);
        // slide start to the next word
        decreaseCount(curDict, s.substring(start, start + k));
        return start + k;
    }
    return start;
}

public void decreaseCount(HashMap<String, Integer> curDict, String key) {
    // remove key if curDict.get(key)==1, otherwise decrease it by 1
    int x = curDict.get(key);
    if (x == 1)
        curDict.remove(key);
    else
        curDict.put(key, x - 1);
}
}
```
{% endfold %}

### ?3 连续最长不重复子序列
两指针i从左向右遍历到最后
j指示i之前不重复的最高位置。
i-j+1为当前最长结果

### ?409 string中字符组成回文串的最大长度
1.开int[128]，直接用int[char]++计数
2.奇数-1变偶数&(~1)
3.判断奇数(&1)>0

---
### ！5 最长回文串
bealen[i][j]表示[i]-[j]是回文串
反转做法不行:abcxyzcba -> abczyxcba ->相同的abc并不是回文
“cba”是“abc”的 reversed copy
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
#### Manacher's 算法 O(n)
前缀/

#### 回文树
`next[i][c]` 编号为i的节点表示的回文串两边添加c后变成的回文串编号。
`fail[i]`节点i失配后
`cnt[i]`

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


### 15 3sum=0 荷兰国旗写法3指针
1p：从0~len-2，3个数的和 右边至少留两个数 sum=0-nums[i]转化成2sum问题
去重：当num[i]=num[i-1]:continue
另外两个指针从1p往后从len-1往前。
去重：预判：nums[low]=nums[low+1]:low++;nums[high]=nums[high-1]:high--;

### 152 最大子列乘积 保留当前值之前的最大积和最小积
负数的最小积有潜力变成最大积
```java
for(int i =1;i<nums.length;i++){
    int nextmax = nums[i]*curmax;
    int nextmin = nums[i]*curmin;
    curmax=Math.max(Math.max(nextmax,nextmin),nums[i]);
    curmin=Math.min(Math.min(nextmax,nextmin),nums[i]);
    sum = Math.max(curmax,sum);
}
```

### 818 A加速，R掉头并减速，到指定位置最少需要多少条指令

### 551 出现两个以上A或者3个以上L为false
```java
return s.indexOf("A")==s.lastIndexOf("A") && s.indexOf("LLL") == -1; 
```

### 239
Monotonic queue 前后可以修改o(1)，并且可以随机访问
维护一个单调递减的序列，读一个窗口输出单调队列的first

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
### 464 博弈
A,B玩家轮流从1-10中选数组加到同一个total，让total先大于11的赢.B肯定赢。
1.计算1-n个数的permutation，并判断每个赢的可能性复杂度(n!)
2.因为1,2...和2,1...是一样的，所以可以降为$2^n$
状态压缩

1. 子状态，m个数state[m+1]表示visited
2. 记忆化递归key是子状态，`Arrays.toString(state)`
3. 遍历state中还是0的没选的数，
    如果d-i选这个数赢了或者另一个人递归d-i的子问题不能赢，
    更新map中这个state为true，可以先state[i]=0回溯return true到之前的选择(上一层递归)
    ```java
    if(d-i<0||!canwin(d-i,hmap)){
        hmap.put(key,true);
        state[i]=0;
        return true;
    }
    ```
    如果对方赢了，不选这个state[i]=0，继续尝试循环中其它state
   如果所有的state都试过了也不行，说明当前子问题
   `hamp.put(key,false)`,`return false`

优化19ms：用二进制存一个int表示状态 用`byte[i<<M+1]`记忆化
```java
int byte[] m_;
m = new byte[1<<M+1];
```
遍历M个数
```java
if(state&(1<<i)>0)continue;
if(!canwin(d-i,state|(1<<i))){
    m_[state]=1;
    return true;
}
```
出循环，表示这个状态不行
```java
m_[state]=-1;
return false;
```
- 优化2：如果用byte[1<<M] 遍历0~M ,`canwin(d-i+1,state|(1<<i))`只需要15ms

1左移i位`int mask=1<<i`表示选这个数的状态
如果`(mask&visited)==0`表示没使用过这个数
另一个玩家能不能赢的state：`mask|visited` 在visited（上一个状态）的基础将i位也置1

---
### ？？？有100个帽子，每个人有几顶，问每个人戴出来都不一样有多少种



### 698 将数组分成sum相等的k份


### 486 两个人只能从list的两端取数，预测最后谁摸到的点数sum高
{3，9，1，2}
1. 二维数组dp：`[i][j]`只用右上三角表示两个人都从list取1个数，2个数，3个数到list长能获得的最大差值
1. 填对角线，如果两个人只剩下一个数为3：{A取3，B取0}，剩下9：{A取9，B取0}...
2. 如果剩下2个数，剩下{3,9}`[1][2]`：{A取9，B剩下{3}回到1的情况}...
3. 如果剩下3个数，剩下{3,9,1}`[1][3]`:{A取3,B剩下{9,1}即表格`[2][3]`的情况}
4. 剩下4个数，填`[1][4]`即为答案

递归：但是会有很多重复计算复杂度$2^n$
比如让对手选[3,9,1]后，自己选[9,1]和[3,9]/让对手选[9,1,2]后，自己选[9,1]和[1,2]
[9,1]被计算了两次。可以进行存储
```java
//最大的分数差
int dif(int[] nums,int left,int right){
    //如果长度为1，获得的差值就是这个数
    if(left==right)return nums[left];
    //选一个数之后 交给对手用相同策略选
    return max(nums[left]-dif(nums,left+1,right),nums[right]-dif(nums,left,right+1));
}
```
用一维数组存储key是`left*len+right`
{% fold %}
```java
int[] m;
int len =0;
public boolean PredictTheWinner(int[] nums) {
    this.len = nums.length;
    if(len==1)return true;
    this.m= new int[len*len];
  return help(nums,0,len-1)>=0;
}
private int help(int[] nums,int l,int r){
    if(l==r)return nums[l];
    int index = l*len+r;
    if(m[index]>0)return m[index];
    m[index]=Math.max(nums[l]-help(nums,l+1,r),nums[r]-help(nums,l,r-1));
    return m[index];
}
```
{% endfold %}

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

### Convert BST to Greater Tree
[17ms 66% Reverse Morris In-order Traversal](https://leetcode.com/problems/convert-bst-to-greater-tree/solution/)
{% fold %}
```java
 public TreeNode convertBST(TreeNode root) {
     int sum = 0;
     TreeNode cur = root;
     while(cur!=null){
         //最右 
         if(cur.right==null){
             sum+=cur.val;
             cur.val=sum;
             cur=cur.left;
         }else{
             //找前继，键link
             TreeNode pre = cur.right;
             //一直向左
             while(pre.left!=null&&pre.left!=cur){
                 pre=pre.left;
             }
            //找到了pre 联立链接
             if(pre.left== null){
                pre.left = cur;
                cur=cur.right;
             }
             //右边没了，并且左连接向上
             else{
                 pre.left=null;
                 sum+=cur.val;
                 cur.val= sum;
                 cur=cur.left;
                 
             }
         }
         
     }
        return root;
    }
```
{% endfold %}

正常做法递归中序 15ms 99%
```java
public TreeNode convertBST(TreeNode root) {
if(root==null)return root;
convertBST(root.right);
sum+=root.val;
root.val=sum;
convertBST(root.left);
return root;
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

### 438 Anagrams in a String 滑动窗口
[Sliding Window algorithm](https://leetcode.com/problems/find-all-anagrams-in-a-string/discuss/92007/Sliding-Window-algorithm-template-to-solve-all-the-Leetcode-substring-search-problem.)
![anagram](/images/anagram.jpg)
![anagram2](/images/anagram2.jpg)
两个数组一样，则找到index，不一样，则窗口向前滑动一哥
输出0，1，4
s: "cbaebabacd" p: "abc" 顺序无关，连续出现在s中
Output:
[0, 6]
> **Anagram** result of [rearranging the letter of a word to produce a new word using all the orginal letters exactly once]
> 1) The first count array store frequencies of characters in pattern.
2) The second count array stores frequencies of characters in current window of text.

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

### 142 环起始于哪个node
![loops](/images/loops.jpg)
1->2->3->4->5->6->7->3 meet:6
a: 从head到环 
b：快指针走了两次的环内距离(慢指针到环起点的距离)
c: 慢指针没走完的环内距离
已知快指针走的距离是slow的两倍
慢=a+b  快=a+2b+c
则a=c
从len(head - 环起点) == 慢指针没走完的环距离
head与慢指针能在环起点相遇。
```java
if(slow==fast){
    while(head!=slow){
        head=head.next;
        slow=slow.next;
    }
    return slow;
}
```

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

### 168
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


# 搜索算法的优化

## 问题
- 8数码（9宫格拼图) 移动序列，树搜索：每个移动状态为节点，边为状态转移。
- 哈密顿环：从一个点出发经过所有的点1次回到原点。
- 子集的合 S={} 求sum(S')=num ：树搜索，栈，深度优先
> 搜索速度：广度优先 最优解 ；深度优先:存在问题，可行解。（得遍历完整个空间得到最优）

> ？？？空间：深度栈：多项式； 广度优先队列：最坏指数

## 1. 爬山：局部贪心，快速找到可行解，局部最优
- 8数码:启发函数：当前状态和目标状态的距离：错位方块个数。
    1. 深度优先
![mounting](\images\mounting.jpg)
    2. 每次将当前节点S的子节点按启发式函数由大到小压入栈

### Best-First搜索：全局最优贪心
- 当前所有可扩展节点中启发函数最优点
- 用堆

### 分支界限：组合优化
- 多阶段图搜索：最短路径
    - 爬山与BF算法得到最优解都需要遍历整个空间
    1. 用爬山生成界限(可行解or最优解的上限)
![fenzhi](\images\fenzhi.jpg)

# 字符串搜索

## Rabin-Karp
O(MN)

## Review

### 1. 枚举：
1. 小于N的完美立方 $a^3=b^3+c^3+d^3$
    > 按a的值从小到大输出a>b>c>d

    + a->[2,N];b->[2,a-1];c[c,a-1];d[c,a-1]

2. 生理周期
    > A周期23天，B周期28天，C周期31天
    > 给定三个高峰p,e,i;求给定日子d后下一次三次高峰同一天还有多少天。 输出天数小于21252.
    > 输入：0 0 0 0

    + k=[d+1,21252] ;(k-p)%23,(k-e)%28,(k-i)%31==0
    ```java
            for(k=d+1;(k-p)%23;++k); //找到第一个高峰
            for(;(k-e)%28;k+=23); //找双高峰
            for(;(k-i)%33;k+=23*28); //找三高峰
            //输出k-d
    ```
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



最长上升子序列
无后效性：可写出递推式。之与子问题函数的状态函数值有关，与到达值的路径无关
子问题：求以$a_k(k=1,2,3...N)$为终点的最长上升子序列长度
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
