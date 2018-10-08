---
title: ToDoAgain
date: 2018-09-03 14:44:31
tags:
categories: [算法备忘]
---
### 818 A加速，R掉头并减速，到指定位置最少需要多少条指令
>当车得到指令 "A" 时, 将会做出以下操作： position += speed, speed *= 2。

>当车得到指令 "R" 时, 将会做出以下操作：如果当前速度是正数，则将车速调整为 speed = -1 ；否则将车速调整为 speed = 1。  (当前所处位置不变。)

例如，当得到一系列指令 "AAR" 后, 你的车将会走过位置 0->1->3->3，并且速度变化为 1->2->4->-1。

>输入: 
target = 3
输出: 2
解释: 
最短指令列表为 "AA"
位置变化为 0->1->3


### ！！！！76 最小的子串窗口 很重要的题

### 152 最大子列乘积 保留当前值之前的最大积和最小积
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

### 127 word Ladder bfs最短单词转换路径
//todo双向bfs

注意marked和dfs的不同，
单纯bfs访问wordlist里每个单词1.79% 1097ms
//`list.size()*cur.length()`
{% fold %}
```java
private boolean dif(String difword,String cur){
    int cnt=0;
    for(int i =0;i<difword.length();i++){
        if(difword.charAt(i)!=cur.charAt(i)){
            cnt++;
            if(cnt>1)return false;
        }
    }
    return true;
}
public int ladderLength(String beginWord, String endWord, List<String> wordList) {
    int cnt = 0;
    HashSet<String> words = new HashSet<>();
    for(String word:wordList){
        words.add(word);
    }
    Set<String> marked = new HashSet<>();
    Deque<String> que = new ArrayDeque<>();
    que.add(beginWord);
    marked.add(beginWord);
    while(!que.isEmpty()){
    cnt++;
    int size = que.size();
    while(size>0){
        size--;
        String cur = que.poll();
        for(String difword:words){
            if(dif(difword,cur)){
                if(difword.equals(endWord))return cnt+1;
                if(!marked.contains(difword)){
                que.add(difword);
                marked.add(difword);}}}}}
    return 0;
}
```
{% endfold %}
先改变单词cur.length()*25再查表
47% 97ms
{% fold %}
```java
public int ladderLength(String beginWord, String endWord, List<String> wordList) {
        int cnt = 0;
        HashSet<String> words = new HashSet<>();
        for(String word:wordList){
            words.add(word);
        }
        Set<String> marked = new HashSet<>();
        Deque<String> que = new ArrayDeque<>();
        que.add(beginWord);
        marked.add(beginWord);
        while(!que.isEmpty()){
            cnt++;
            int size = que.size();
            while(size>0){
                size--;
                String cur = que.poll();
                //System.out.println(cur);
             
                char[] curr = cur.toCharArray();
                for(int i =0;i<curr.length;i++){
                    char ori = curr[i];
                    for(char c='a';c<='z';c++){
                        if(curr[i]!=c){
                            curr[i]=c;
                            String next = new String(curr);
                          

                            if(words.contains(next)){
                               
                                if(next.equals(endWord))return cnt+1;
                                if(!marked.contains(next)){
                                     
                                    que.add(next);
                                    marked.add(next);
                                }
                            }
                        }
                    }
                    curr[i] = ori;
                }
              
            }
        }
        return 0;
    }
```
{% endfold %}

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



### 486 两个人只能从list的两端取数，预测最后谁摸到的点数sum高
https://leetcode.com/problems/predict-the-winner/solution/
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

#### lt 1470 
> 1号玩家先取。问最后谁将获胜。 他们只能从数组的两头进行取数，且一次只能取一个。
> 若1号玩家必胜或两人打成平局，返回1，若2号玩家必胜，返回2。
> 如果数组长度是偶数 先手必胜只要return 1就行了

```java
public int theGameOfTakeNumbers(int[] arr) {
   if(dif(arr,0,arr.length-1)>=0)return 1;
   else return 2;
}
private int dif(int[] nums,int left,int right){
    if(left<right)return 0;
    if(left==right)return nums[left];
    return Math.max(nums[left]-dif(nums,left+1,right),nums[right]-dif(nums,left,right-1));
}
```

#### lc 877
> 偶数堆石子排成一行，每堆都有正整数颗石子 piles[i] 
> 输入： [5,3,4,5]

先手可以拿1+3 或者2+4 对手反之拿2+4或者1+3，所以先手选大的那个肯定赢。
递归同上 77% 
可以加一个`memo[l][r]` 从2^n->n^2 因为l和r一共有n^2个子问题

dp ：
```java
public boolean stoneGame(int[] piles) {
    int n = piles.length;
    int[][] dp = new int[n][n];
    //left=i,right=i的子问题
    for (int i = 0; i <n ; i++) {
        dp[i][i] = piles[i];
    }
    //长度为[2,n]的子问题
    for (int i = 2; i <=n ; i++) {
        for (int l = 0; l <n-i+1 ; l++) {
            int r = i+l-1;
            //[l+1][r]的长度比[l][r]小 已经计算过了
            dp[l][r] = Math.max(piles[l]-dp[l+1][r],piles[r]-dp[l][r-1]);
        }
    }
    return dp[0][n-1]>0;
}
```
子问题是 长度-1的dp 降维
```java
public boolean stoneGameDP1D(int[] piles) {
    int n  = piles.length;
    int[] dp = piles.clone();
    for (int i = 2; i <=n ; i++) {
        for (int l = 0; l<n-i+1 ; l++) {
            //dp[i] 还没有更新,都是长度i-1的值
            dp[i] = Math.max(piles[l]-dp[i+1],piles[l+i-1]-dp[i] );
        }
    }
    return dp[0]>0;
}
```

### lt920 meeting room
给定一系列的会议时间间隔，包括起始和结束时间[[s1,e1]，[s2,e2]，…(si < ei)，确定一个人是否可以参加所有会议。
[[0,30]，[5,10]，[15,20]]，返回false。
贪心
```java
public boolean canAttendMeetings(List<Interval> intervals) {
    if(intervals == null||intervals.size() == 0)return true;
    Collections.sort(intervals,(o1,o2)->o1.start-o2.start);
    int end = intervals.get(0).end;
    for (int i = 1; i < intervals.size(); i++) {
        if(intervals.get(i).start<end)return false;
        end = Math.max(end,intervals.get(i).end);
    }
    return true;
}
```

### lt919 !!!需要几个会议室
不能贪心：
> `[[1, 5][2, 8][6, 9]]`
> 这种情况本来只需要2间房，但是直接贪心就会需要3间房

```java
/**
 |___| |______|
   |_____|  |____|
 starts:
 | |   |    |
 i
 ends:
      |  |     | |
     end
 res++;
 ---------
    i
     end
 res++; 这个end之前有2个start，前一个会议没有结束
 ---------
        i
     end
 end++; start>end表示有个room的会议已经结束，可以安排到这个room
 ---------
 */
//251ms 74%
public int minMeetingRooms2Arr(List<Interval> intervals) {
    int[] starts = new int[intervals.size()];
    int[] ends = new int[intervals.size()];
    for(int i=0;i<intervals.size();i++){
        starts[i] = intervals.get(i).start;
        ends[i] = intervals.get(i).end;
    }
    Arrays.sort(starts);
    Arrays.sort(ends);
    int cnt =0;
    int end = 0;
    for (int i = 0; i < intervals.size(); i++) {
        if(starts[i]<ends[end])cnt++;
        else end++;
    }
    return cnt;
}
```

用TreeMap
```java
//240ms 75%
public int minMeetingRooms(List<Interval> intervals) {
    TreeMap<Integer,Integer> map = new TreeMap<>();
    for(Interval i:intervals){
        map.put(i.start,map.getOrDefault(i.start,0)+1);
        map.put(i.end,map.getOrDefault(i.end,0)-1);
    }
    int room = 0;
    int max = 0;
    for(int num:map.values()){
        room+=num;
        max = Math.max(max,room);
    }
    return max;
}
```

用PriorityQ
```java
//403ms 54%
public int minMeetingRoomsPQ(List<Interval> intervals) {
    Collections.sort(intervals,(o1, o2)->o1.start-o2.start);
    PriorityQueue<Interval> heap = new PriorityQueue<>(intervals.size(),(o1, o2)->o1.end-o2.end);
    heap.add(intervals.get(0));
    for (int i = 1; i <intervals.size() ; i++) {
        if(intervals.get(i).start>=heap.peek().end)heap.poll();
        heap.add(intervals.get(i));
    }
    return heap.size();
}
```

### 452 重叠线段？？
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



### 56 合并区间 扫描线
>Input: [[1,4],[4,5]]
Output: [[1,5]]


方法1：O(nLogn) 需要O(n)空间
1.按起点排序，
2.push第一个interval
3.for全部interval：
  a.不交叉，push
  b.交叉,更新栈顶的end

59ms 27%
{% fold %}
```java
public List<Interval> merge(List<Interval> intervals) {
  if(intervals==null||intervals.size()<2)return intervals;
    intervals.sort((a,b)->a.start-b.start);
    List<Interval> rst = new ArrayList<>();
    for(Interval interval:intervals){
        if(rst.size()<1){       
            rst.add(interval);
        }
        else if(rst.get(rst.size()-1).end>=interval.start){
            // 不用新建 只需要更新栈顶
            // Interval newInter = rst.get(rst.size()-1);
            // rst.remove(rst.size()-1);
            // newInter.end = Math.max(newInter.end,interval.end);
            // rst.add(newInter);
            rst.get(rst.size()-1).end =Math.max(rst.get(rst.size()-1).end,interval.end); 
        }else{
            rst.add(interval );
        }
    }
    return rst;
}
```
{% endfold %}

方法2：分解成`start[],end[]`
思想：后一个区间的start(i+1)一定要大于前一个区间的end(i)
98% 10ms
```
starts:   1    2    8    15
               i    i+1
ends:     3    6    10    18
          j
```
add(1,6)
`start[i+1]>end[i]` 直到找的第一个start>end `add(start[j],end[i])` `j=i+1`
如果start到了最后一个，这个区间肯定是从上一个区间(j)开始，到end(i)结束
```java
public List<Interval> merge(List<Interval> intervals) {
    int len = intervals.size();
    int[] start = new int[len];
    int[] end = new int[len];
    for(int i =0;i<len;i++){
        start[i] = intervals.get(i).start;
         end[i] = intervals.get(i).end;
    }
    Arrays.sort(start);
    Arrays.sort(end);
    List<Interval> rst = new ArrayList<>();
    for(int i =0,j=0;i<len;i++){
        //关键 当start扫描到最后一个 ，直接建立起最后一个区间
        if(i==len-1||start[i+1]>end[i]){
            rst.add(new Interval(start[j],end[i]));
            //下一个区间起点
            j=i+1;
        }
    }
}
```

方法3：原地算法
1.按地点降序排序
2. a如果不是第一个，并且和前一个可以合并，则合并
   b push当前

#### lt156合并区间
> ```
[                     [
  (1, 3),               (1, 6),
  (2, 6),      =>       (8, 10),
  (8, 10),              (15, 18)
  (15, 18)            ]
]
```
O(n log n) 的时间和 O(1) 的额外空间。 原地算法





### 57 插入一个区间并合并
方法1： 将区间插到newInterval.start>interval.start之前的位置，用56的和last比较合并
方法2： 分成left+new+right三部分并合并 中间部分取自身和重叠区间的min/max
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
![nixu315.jpg](/images/nixu315.jpg)

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

### ??Convert BST to Greater Tree
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


### lc393 判断合法UTF8编码

### 287 数组中重复元素


### 网络流
https://algs4.cs.princeton.edu/64maxflow/
https://www.geeksforgeeks.org/minimum-cut-in-a-directed-graph/
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

查找
![trie.jpg](/images/trie.jpg)
插入
![tirinsert.jpg](/images/tirinsert.jpg)

---

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



### ！？？？95 输出全部不同的BST
[1~n]组成的BST
```
1.......k...n
       / \
[1~k-1]  [k+1,n] 与上一层的构建过程是一样的
```



### 287 数组中只有1个重复元素 返回元素

> containing n + 1 integers where each integer is between 1 and n (inclusive)

不用set，空间降为O(1)
将数组的数字想象成链表，找环
> 1 4 6 6 6 2 3

慢指针走`num[slow]`
快指针走`num[num[fast]]`

慢指针会在环与head指针相遇
```java
public int findDuplicate(int[] nums) {
// use only constant, O(1) extra space
    int slow = nums[0];
    int fast = nums[0];
    do{
        slow = nums[slow];
        fast =  nums[nums[fast]];
    }while(slow != fast);
    
    int head = nums[0];
    while(head!=slow){
        head= nums[head];
        slow = nums[slow];
    }
    return head;
}
```

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
**head与慢指针能在环起点相遇。**
```java
if(slow==fast){
    while(head!=slow){
        head=head.next;
        slow=slow.next;
    }
    return slow;
}
```

### lt 458 lastIndexOf
```java
public int lastPosition(int[] nums, int target) {
    if(nums==null||nums.length<1)return -1;
    int i = 0, j = nums.length-1;
    while(i<=j){
        int mid = (i+j)/2;
        if(nums[mid]>target)j = mid-1;
        //找到了继续向右找
        else i =mid+1;
    }
    if(j<0)return-1;
    if(nums[j]==target) return j; 
        return -1;
}
```

### 34 ？？？？？？二分查找数字的first+last idx
> Input: nums = [5,7,7,8,8,10], target = 8
> Output: [3,4]

二分查找获取最左/右边相等的

### 719

### 410 分割数组使Max(Sum(subarr))最小
>Input:
nums = [7,2,5,10,8]
m = 2
Output:
18  [7,2,5] and [10,8],

复杂度： mn^2 有mn个子问题 每个子问题找最佳k

`dp[i][j]` 长度为j的数组划分成i组的最大值
1.`dp[1][j]= sum(0,j)`
2.找分割点k，k左边划成i-1组的解和右边划分为1组 取max，在所有分割点k中取最小值 
`dp[i][j] = min(max(dp[i-1][k],sum(k+1,j))`
递归：76ms 6%



二分：复杂度(log(sum(nums))*n) 空间O(1) ok //todo next
lower bound 数组中的最大元素max(nums)
up bound 分成1组 sum(nums)
```java
public int splitArray(int[] nums, int m) {
    int max = 0;long sum = 0;
    for(int num:nums){
        max = Math.max(num,max );
        sum+=num;
    }
    if(m==1)return (int)sum;
    long l = max,r = sum;
    while (l<=r){
        long mid = (l+r)/2;
        //用这个最小值能不能划分成m组 可以更小一点
        if(valid(mid,nums ,m )){
            r = mid-1;
        }
        else{
            l = mid+1;
        }
    }
return (int)l;
}
private boolean valid(long target,int[] nums,int m){
    int cnt =1;
    long total = 0;
    for(int num:nums){
        total += num;
        if(total>target){
            total = num;
            //需要一个新的分组
            cnt++;
            if(cnt> m)return false;
        }
    }
    return true;
}
```





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

### 438 Anagrams in a String 滑动窗口`Arryas.equals`
> Anagrams 字母相同，顺序不同的单词 连续
> s: "cbaebabacd" p: "abc" 
> Output:[0, 6] 输出起始位置

[Sliding Window algorithm](https://leetcode.com/problems/find-all-anagrams-in-a-string/discuss/92007/Sliding-Window-algorithm-template-to-solve-all-the-Leetcode-substring-search-problem.)
![anagram](/images/anagram.jpg)
![anagram2](/images/anagram2.jpg)
16ms 50%
```java
public List<Integer> findAnagrams(String s, String p) {
    List<Integer> rst = new ArrayList<>();
    int[] ch = new int[26];
    int wcn = p.length();
    for(char c:p.toCharArray()){
        ch[c-'a']++;
    }
    int[] window = new int[26];
    for (int i = 0; i <s.length() ; i++) {
        if(i>=wcn){
            --window[s.charAt(i-wcn)-'a'];
        }
        window[s.charAt(i)-'a']++;
        if(Arrays.equals(window, ch)){
            rst.add(i-wcn+1);
        }
    }
    return rst;
}
```



### ！5 最长回文串 lt893
最快最正确的做法8ms 99%:
版本2
```java
public String longestPalindrome(String s) {
    if (s == null || s.length() == 0){
        return s;
    }
    char[] ca = s.toCharArray();
    int rs = 0, re = 0;
    int max = 0;
    for(int i = 0; i < ca.length; i++) {
        if(isPalindrome(ca, i - max - 1, i)) {
            rs = i - max - 1; re = i;
            max += 2;
        } else if(isPalindrome(ca, i - max, i)) {
            rs = i - max; re = i;
            max += 1;
        }
    }
    return s.substring(rs, re + 1);
}

private boolean isPalindrome(char[] ca, int s, int e) {
    if(s < 0) return false;
    
    while(s < e) {
        if(ca[s++] != ca[e--]) return false;
    }
    return true;
}
```
版本1
```java
int max = 0;
int left = 0;
char[] chars;
public String longestPalindrome(String s) {
    if (s == null || s.length() == 0){
        return s;
    }
    chars = s.toCharArray();
    for (int i = 0; i < chars.length; i++){
        i = longestPalindrome(i);
    }
    return s.substring(left, left + max);
}

private int longestPalindrome(int index){
    int ll = index, rr = index;
    while (rr + 1 < chars.length && chars[rr] == chars[rr + 1]){
        rr++;
    }
    int temp = rr;
    while (ll - 1 >= 0 && rr + 1 < chars.length && chars[ll - 1] == chars[rr + 1]){
        ll--;
        rr++;
    }
    if (rr - ll  + 1 > max){
        max = rr - ll + 1;
        left = ll;
    }
    return temp;
}
```
http://windliang.cc/2018/08/05/leetCode-5-Longest-Palindromic-Substring/
!!反转做法不行:abcxyzcba -> abczyxcba ->相同的abc并不是回文!! 不能用LCS
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

#### Manacher's 算法 O(n) 并不理解
https://algs4.cs.princeton.edu/53substring/Manacher.java.html
前缀/

73%
```java
public String longestPalindrome2(String s) {
    StringBuilder sb = new StringBuilder("^#");
    for (int i = 0; i !=s.length() ; i++)
        sb.append(s.charAt(i)).append("#");
    sb.append("$");
    final int N = sb.length();
    int[] p = new int[N];
    //id是长度为mx的回文串的中心(?
    int id = 0,mx = 0;
    int maxLen = 0,maxId= 0;
    for (int i = 1; i <N-1 ; i++) {
        //注意
//            System.out.println(2*id-i);

        p[i] = mx > i ? Math.min(p[2 * id - i], mx - i ) : 1;

        while(sb.charAt(i+p[i])==sb.charAt(i-p[i]))
            p[i]++;
        if(mx < i+p[i]){
            mx = i+p[i];
            id = i;
        }
        if(maxLen < p[i]){
            maxLen = p[i];
            maxId = i;
        }
    }
    int start = (maxId-maxLen)/2;
    return s.substring(start,start+maxLen-1);
}
```

#### 回文树
`next[i][c]` 编号为i的节点表示的回文串两边添加c后变成的回文串编号。
`fail[i]`节点i失配后
`cnt[i]`

### K-D tree

### 快速排序的各种优化
https://algs4.cs.princeton.edu/23quicksort/

### 前序中序构造二叉树
A BDEG CF
DBGE A CF
```java
public TreeNodeT<Character> createTree(String preOrder,String inOrder){
    if(preOrder.isEmpty())return null;
    char rootVal = preOrder.charAt(0);
    int leftLen = inOrder.indexOf(rootVal);
    TreeNodeT<Character> root = new TreeNodeT<Character>(rootVal);
    root.left = createTree(
            preOrder.substring(1,1+leftLen),
            inOrder.substring(0,leftLen));

    root.right = createTree(
            preOrder.substring(1+leftLen),
            inOrder.substring(leftLen+1));
    return root;
}
```

### 106 中序+后序建树

### 698 将数组分成sum相等的k份

### ？？？有100个帽子，每个人有几顶，问每个人戴出来都不一样有多少种

### 239 数组给定滑动窗口大小的最大值
Monotonic queue 前后可以修改o(1)，并且可以随机访问
维护一个单调递减的序列，读一个窗口输出单调队列的first




### 15 3sum=0 荷兰国旗写法3指针
1p：从0~len-2，3个数的和 右边至少留两个数 sum=0-nums[i]转化成2sum问题
去重：当num[i]=num[i-1]:continue
另外两个指针从1p往后从len-1往前。
去重：预判：nums[low]=nums[low+1]:low++;nums[high]=nums[high-1]:high--;

### poj2406 字符串周期 power string
https://my.oschina.net/hosee/blog/661974
http://poj.org/problem?id=2406
abcd 1
aaaa 4
ababab 3

### 459 判断字符串有重复模式 KMP
kmp89% todo


### !!!3 连续最长不重复子序列

32%
用set维护一个`[i,j)`窗口，不重复则窗口向右扩展，重复则窗口右移。
```java
public int lengthOfLongestSubstring(String s){
    int n = s.length();
    Set<Character> set = new HashSet<>();
    int ans = 0,i=0,j=0;
    while(i<n&&j<n){
        if(!set.contains(s.charAt(j))){
            set.add(s.charAt(j++));
            ans = Math.max(ans,j-i);
        }
        else set.remove(s.charAt(i++));
    }  
    return ans;
}
```
优化： todo
`int[26]` for Letters 'a' - 'z' or 'A' - 'Z'
`int[128]` for ASCII
`int[256]` for Extended ASCII

### 659 数组

### 413 数组划分 能组成的等差数列个数
> A = [1, 2, 3, 4]
> 返回: 3, A 中有三个子等差数组: [1, 2, 3], [2, 3, 4] 以及自身 [1, 2, 3, 4]。

### 725链表划分成k份子集

### lt886 判断凸包
https://www.lintcode.com/problem/convex-polygon/description


### ?409 string中字符组成回文串的最大长度
1.开int[128]，直接用int[char]++计数
2.奇数-1变偶数&(~1)
3.判断奇数(&1)>0

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

### 45 ??????jump game最少跳跃次数
超时递归（？
递归终止条件是from==end，如果有0不可达
{% fold %}
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
{% endfold %}
1.在本次可跳跃的长度范围内如果不能达到len-1则表示一定要跳跃//不懂
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
2.!!!BFS
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

