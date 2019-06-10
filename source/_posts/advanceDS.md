---
title: 数据结构模板&模板题
date: 2018-09-01 15:29:18
tags: [并查集,Trie,线段树]
categories: [算法备忘]
---
### Merkle tree

### 归并树
每个节点对应区间排好序的结果 O(nlogn)建立树

### 连通分量
![connect.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/connect.jpg)
无向图的连通分量可以用并查集（集合）来做
并查集：[12,3,4,5]->[6,2,3,4,5]位置存放的是根节点
![unionfind.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/unionfind.jpg)
有向图的连通分量Kosaraju 算法4p380
![kosaraju.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/kosaraju.jpg)
1.将图的边反向,dfs得到逆后序
2.按逆后序列dfs原图 cnt++
![kosaraju2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/kosaraju2.jpg)

[tarjan](https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm)

https://algs4.cs.princeton.edu/42digraph/TarjanSCC.java.html
和拓扑排序一样Tarjan算法的运行效率也比Kosaraju算法高30%左右
每个顶点都被访问了一次，且只进出了一次堆栈，每条边也只被访问了一次，所以该算法的时间复杂度为O(N+M)。

### 130 围棋 用并查集
dfs ac100%

### ! lc200 number of islands 岛屿 水坑
dfs 52% 5ms
{% fold %}
```java
public int numIslands(char[][] grid) {
    int cnt =0;
    for(int i = 0;i<grid.length;i++){
        for(int j =0;j<grid[0].length;j++){
            if(grid[i][j]=='1'){
                dfs(grid,i,j);
                ++cnt;
            }
        }
    }
    return cnt;
}
private void dfs(char[][] grid,int x,int y){
    if(x<0||x>grid.length-1||y<0||y>grid[0].length-1||grid[x][y]=='0')
        return;
    grid[x][y] = '0';
    dfs(grid,x+1,y);
    dfs(grid,x-1,y);
    dfs(grid,x,y+1);
    dfs(grid,x,y-1);
}
```
{% endfold %}
并查集模板
find O(1)判断是否在同一个集合中（同一个parent)
![unionfind2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/unionfind2.jpg)
1.找到一个‘1’
2.用并查集把相邻的‘1’都union起来，本来8个‘1’，每次合并两个不同分量的就cnt--
22% 8ms
```java
//union find模板
class UnionFind{
    int [] parent;
    int m,n;
    int count = 0;
    UnionFind(char[][] grid){
        m = grid.length;
        n = grid[0].length;
        parent = new int[m*n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if(grid[i][j] == '1'){
                    int id = i*n+j;
                    parent[id] = id;
                    count++;
                }

            }
        }
//            System.out.println(Arrays.toString(parent));
//            System.out.println("初始化完成");
    }
    public void union(int node1,int node2){
        int find1 = find(node1);
        int find2 = find(node2);
        System.out.println("int union:"+node1+" "+node2);
        System.out.println("find1,find2:"+find1+" "+find2);
        if(find1 != find2){
            parent[find1] = find2;
            count--;
        }
    }
    public int find (int node){
        if(parent[node] == node)return node;
        parent[node] = find(parent[node]);
        return parent[node];
    }
}
int[][] distance = {{1,0},{-1,0},{0,1},{0,-1}};
public int numIslands(char[][] grid){
    //
    if(grid==null||grid.length<1||grid[0].length<1)
        return 0;
    UnionFind uf = new UnionFind(grid);
    int rows = grid.length;
    int cols = grid[0].length;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j <cols ; j++) {
            
            if(grid[i][j] == '1'){
                for(int[] d :distance){
                    int x = i+d[0];
                    int y = j+d[1];
                
                    if(x>=0&&x<rows&&y>=0&&y<cols&&grid[x][y] == '1'){
                        int id1 = i*cols+j;
                        int id2 = x*cols+y;
                        uf.union(id1,id2);
                        System.out.println(Arrays.toString(uf.parent));
                    }
                }
            }

        }
    }
    return uf.count;
    }
```

bfs：
{% fold %}
```java
public int numIslandsBFS(char[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    boolean[][] marked = new boolean[n][m];
    int count = 0;
    for (int i = 0; i < grid.length; i++) {
        for (int j = 0; j < grid[0].length; j++) {
            if (!marked[i][j] && grid[i][j] == '1') {
                count++;
                bfs(grid,marked, i, j);

            }
        }
    }
    return count;
}
public void bfs(char[][] grid,boolean[][] marked,int x,int y){
    int[][] dxy = {{1,0},{-1,0},{0,1},{0,-1}};
    Deque<int[]> que = new ArrayDeque<>();
    que.push(new int[]{x,y});
    marked[x][y] = true;

    while (!que.isEmpty()){
        int[] xy = que.poll();
        for (int i = 0; i <4 ; i++) {
            int newx = xy[0] + dxy[i][0];
            int newy = xy[1] + dxy[i][1];

            if(newx < 0 || newx > marked.length || newy <0 || newy > marked[0].length){
                continue;
            }

            if(!marked[newx][newy] && grid[newx][newy] == '1'){
                que.add(new int[]{newx,newy});
                marked[newx][newy] = true;
            }
        }
    }
}
```
{% endfold %}

### ！684 多余的连接（构成环）
用UF模板 uf可以改到97%
```java
//Unifind模板
class UnionFind{
    int [] parent;
    UnionFind(int size){
        parent = new int[size+1];
        for (int i = 0; i < size+1; i++) {
            parent[i] = i;
        }
    }
    public boolean union(int node1,int node2){
        int find1 = find(node1);
        int find2 = find(node2);
        //已经在一个集合里了
        if(find1==find2)return false;
        if(find1 != find2){
            parent[find1] = find2;
        }
        return true;
    }
    public int find (int node){
        if(parent[node] == node)return node;
        parent[node] = find(parent[node]);
        return parent[node];
    }
}
public int[] findRedundantConnectionUF(int[][] edges) {
    UnionFind uf = new UnionFind(edges.length);
    for(int[]edge:edges){
        if(!uf.union(edge[0],edge[1] ))
            return edge;
    }
    return new int[]{};
}
```
其他方法//todo


### 547 互相是朋友的圈子有几个



### 208 Trie树 前缀树
n个item查询，和item数量无关，只和查询的item长度有关
如果不止26个字符，可以直接用一个map保存叶子节点
```java
class Node{
    // 节点可以不存 因为边有了
    char c;
    // 边
    Map<char,Node> next;
    boolean isWord;
}
```

实现String`insert` `search` `startsWith`
![trieTree.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/trieTree.jpg)
插入和查找的time都是O(len(s))
```java
class TrieNode{
    public char val;
    public boolean end;
    public TrieNode[] children = new TrieNode[26];
    TrieNode(char c){
        TrieNode node = new TrieNode();
        node.val = c;
    }
}
class Trie {

    private TrieNode root;

    public Trie() {
       root = new TrieNode(' ');
    }

    public void insert(String word) {
        TrieNode cur = root;
        for (int i = 0; i < word.length(); i++) {
            char c= word.charAt(i);
            if(cur.children[c-'a']==null){
                cur.children[c-'a'] = new TrieNode(c);
            }
            cur = cur.children[c-'a'];
        }
        cur.end = true;
    }

    public boolean search(String word) {
        TrieNode cur = root;
        for (int i = 0; i < word.length() ; i++) {
            char c = word.charAt(i);
            if(cur.children[c-'a']==null)return false;
            cur = cur.children[c-'a'];
        }
        return cur.end;
    }

//trie.startsWith("app"); // returns true
    public boolean startsWith(String prefix) {
        TrieNode cur = root;
        for (int i = 0; i < prefix.length() ; i++) {
            char c = prefix.charAt(i);
            if(cur.children[c-'a']== null)return false;
            cur = cur.children[c-'a'];
        }
        return true;
    }
}
```

Trie应用：
https://leetcode.com/problems/implement-trie-prefix-tree/solution/
应用场景：
1.查找公共前缀的key
2.以字典序遍历数据
相比hashtable节省空间

### 211 单词查询`.`匹配Trie

#### 677计算单词前缀的累积和

### RMQ
https://www.jianshu.com/p/bb2e6b355b31

### 线段树Segment Tree
定义：
1.叶节点是输入
2.每个内部节点是为不同问题设计的，叶节点的组合（和/最大值/最小值）
![segmentTree.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/segmentTree.jpg)
查找范围内的最小值/和 只需要Log(n)

数组实现
https://leetcode.com/articles/a-recursive-approach-to-segment-trees-range-sum-queries-lazy-propagation/

### lc307 sum线段树
> Given nums = [1, 3, 5]
> sumRange(0, 2) -> 9
> update(1, 2)
> sumRange(0, 2) -> 8

#### Binary Index Tree/ Fenwick Tree 34% 106ms
O(logN) sum和update
与dp不同，dp[i]存储了前i个的总和 e只存部分
[visualgo可视化](https://visualgo.net/bn/fenwicktree)
1.树
```java
class NumArray {

    int[] nums=null;
    int[] e = null;
    int len =0;
    public NumArray(int[] nums) {
        len = nums.length;
         e = new int[len+1];
        this.nums = new int[len];
        for(int i =0;i<len;i++){
            update(i,nums[i]);
        } 
    }
```
每个叶子节点的父节点的计算方法i+lowbit(i)
1的父节点=001+001=010
2的父节点=010+010=100==4
4的父节点=100+100 = 1000==8
![BITFT.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/BITFT.jpg)
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
![BITFT2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/BITFT2.jpg)
![BIT.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/BIT.jpg)
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



###  区间和查询305+修改307
**n个元素线段树的初始化时间复杂度和空间复杂度都是O(n)**
![sparsetable.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/sparsetable.jpg)
*Spare Table 预处理时空复杂度都是O(nlogn) 但是二分查询i只需要O(loglogn)*
因为节点数是n+n/2+n/4+...=2n
1.线段树用模板 59% 80ms
```java
class SegmentTreeNode {
    int start, end;
    SegmentTreeNode left, right;
    int sum;

    public SegmentTreeNode(int start, int end) {
        this.start = start;
        this.end = end;
        this.left = null;
        this.right = null;
        this.sum = 0;
    }
}

SegmentTreeNode root = null;
private SegmentTreeNode build(int[] nums, int start, int end) {
    if (start > end) {
        return null;
    } else {
        SegmentTreeNode ret = new SegmentTreeNode(start, end);
        if (start == end) {
            ret.sum = nums[start];
        } else {
            int mid = start  + (end - start) / 2;
            ret.left = build(nums, start, mid);
            ret.right = build(nums, mid + 1, end);
            ret.sum = ret.left.sum + ret.right.sum;
        }
        return ret;
    }
}
public int query(SegmentTreeNode root, int start, int end) {
    if (root.end == end && root.start == start) {
        return root.sum;
    } else {
        int mid = root.start + (root.end - root.start) / 2;
        if (end <= mid) {
            return query(root.left, start, end);
        } else if (start >= mid+1) {
            return query(root.right, start, end);
        }  else {
            return query(root.right, mid+1, end) + query(root.left, start, mid);
        }
    }
}
void modify(SegmentTreeNode root, int pos, int val) {
    if (root.start == root.end) {
        root.sum = val;
    } else {
        int mid = (root.end + root.start) / 2;
        if (pos <= mid) {
            modify(root.left, pos, val);
        } else {
            modify(root.right, pos, val);
        }
        root.sum = root.left.sum + root.right.sum;
    }
}

public NumArray(int[] nums) {
    root = build(nums, 0, nums.length-1);
}
void update(int i, int val) {
    modify(root, i, val);
}
public int sumRange(int i, int j) {
    return query(root, i, j);
}
```
 
2.用数组实现的线段树 太复杂就快3ms
https://leetcode.com/problems/range-sum-query-mutable/solution/

#### sqrt(n)复杂度拆分成sqrt份和 8% 308ms
![sqrtrm.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/sqrtrm.jpg)
```java
private int[] b;
private int len;
private int[] nums;
public NumArray(int[] nums){
    this.nums = nums;
    double l = Math.sqrt(nums.length);
    len = (int)Math.ceil(nums.length/l);
    b = new int[len];
    for (int i = 0; i < nums.length; i++) {
        b[i/len]+=nums[i];
    }
}
public int sumRange(int i,int j){
    int sum = 0;
    int startBlock = i/len;
    int endBlock = i/len;
    //在同一个区间里
    if(startBlock == endBlock){
        for (int k = i; k <= j ; k++) {
            sum+=nums[k];

        }
    }else{
        //start所在区间
        //len =  3,start =0
        for (int k = i; k <(startBlock+1)*len ; k++) {
            sum += nums[k];
        }
        //1-2)
        for (int k = startBlock+1; k <endBlock ; k++) {
            sum += b[k];
        }
        for (int k = endBlock*len; k <j ; k++) {
            sum += nums[k];
        }
    }
    return sum;
}
public void update(int i,int val){
    int bidx  = i/len;
    b[bidx] = b[bidx]-nums[i]+val;
    nums[i] = val;
}
```


### lt206区间求和

#### lt201按区间构造线段树
{% fold %}
```java
class SegmentTnode{
    public int start,end;
    public SegmentTnode left,right;

    public SegmentTnode(int start, int end) {
        this.start = start;
        this.end = end;
        this.left = null;
        this.right = null;
    }

    @Override
    public String toString() {
        Queue<SegmentTnode> q = new ArrayDeque<>();
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        q.add(this);
        while (!q.isEmpty()) {
            SegmentTnode top = q.remove();
           sb.append("["+top.start+","+top.end+"]");
            if (top.left != null) {
                q.add(top.left);}
            if (top.right != null) {
                q.add(top.right);
            }
        }
        sb.append("]");
        return sb.toString();

    }

}
public SegmentTnode build(int start,int end){
    if(start>end)return null;
    SegmentTnode root = new SegmentTnode(start,end);
    int left = (start+end)/2;
    int right = left+1;
    if(start!=end){
        root.left = build(start,left);
        root.right = build(right,end);
    }
    return root;
}

public static void main(String[] args) {
    SegmentTree sl = new SegmentTree();
    System.out.println(sl.build(1, 4));
}
```
{% endfold %}

#### lt439 对数组构造max线段树
> 输入[3,2,1,4]
> 输出
> "[0,3,max=4][0,1,max=3][2,3,max=4][0,0,max=3][1,1,max=2][2,2,max=1][3,3,max=4]"
1.递归到0,0 max =3.回到上一层left = (0,0,3)
2.root.right = (1,1,2);
3.root.max = max(left,right)
4.return `root[0,1,3][0,0,3][1,1,2]`

```java
class SegmentTreeNode {
    public int start, end, max;
    public SegmentTreeNode left, right;
    public SegmentTreeNode(int start, int end, int max) {
    this.start = start;
    this.end = end;
    this.max = max;
    this.left = this.right = null; }
    @Override
    public String toString() {
        Queue<SegmentTreeNode> q = new ArrayDeque<>();
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        q.add(this);
        while (!q.isEmpty()) {
            SegmentTreeNode top = q.remove();
            sb.append("["+top.start+","+top.end+", max="+top.max+"]");
            if (top.left != null) {
                q.add(top.left);}
            if (top.right != null) {
                q.add(top.right);
            }
        }
        sb.append("]");
        return sb.toString();

    }
}

public SegmentTreeNode build(int[] A){

    return build(A,0,A.length-1);
}
private SegmentTreeNode build(int[] A,int start,int end){
    if(start==end){return new SegmentTreeNode(start,end,A[start]);}
    SegmentTreeNode root = new SegmentTreeNode(start,end,Integer.MIN_VALUE);
    int left = (start+end)/2;
    root.left = build(A,start ,left );
    root.right = build(A,left+1,end);
    root.max = Math.max(root.left.max, root.right.max);
    return root;

}
public static void main(String[] args) {
    lt439 sl = new lt439();
    System.out.println(sl.build(new int[]{3, 2, 1, 4}));
}
```

### 202 max线段树查询
>对于数组 [1, 4, 2, 3], 对应的线段树为：
```
                  [0, 3, max=4]
                 /             \
          [0,1,max=4]        [2,3,max=3]
          /         \        /         \
   [0,0,max=1] [1,1,max=4] [2,2,max=2], [3,3,max=3]
```
query(root, 1, 1), return 4
query(root, 1, 2), return 4
query(root, 2, 3), return 3
query(root, 0, 2), return 4

求和线段树
![segmentquery.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/segmentquery.jpg)
1.区间完全匹配的，return value
2.区间完全不匹配的，return 0
3.部分匹配超出查询区间的 递归查询左右子树
查`[3:4]` 遇到`[3:5]`,继续查`[3:4]`,`[5,5]`完全超出

![segmentminquery.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/segmentminquery.jpg)
90%
```java
public int query(lt439.SegmentTreeNode root, int start, int end) {
    if(root.start>=start&&root.end<=end)return root.max;
    int rst = Integer.MIN_VALUE;
    int mid = (root.start+root.end)/2;
    //关键
    if(mid>=start)rst = Math.max(rst,query(root.left,start,end));
    if(mid+1<=end)rst = Math.max(rst,query(root.right,start,end));
    return rst;
}
```
写法2：98%
```java
public int query(SegmentTreeNode root,int start,int end){
    if(start>end)return 0;
    if(root.start==root.end)return root.max;
    int mid = (root.start+root.end)/2;
    //分割当前查询区间，如果和左边有交集，则查找左边最大值
    int left = query(root.left,start,Math.min(mid,end));
    //mid = 4,query(5,4)
    int right = query(root.right,Math.max(start,mid+1),end);
    return Math.max(left,right);
}
```

### lt203 线段树更新
```
                      [1, 4, max=3]
                    /                \
        [1, 2, max=2]                [3, 4, max=3]
       /              \             /             \
[1, 1, max=2], [2, 2, max=1], [3, 3, max=0], [4, 4, max=3]
如果调用 modify(root, 2, 4), 返回:

                      [1, 4, max=4]
                    /                \
        [1, 2, max=4]                [3, 4, max=3]
       /              \             /             \
[1, 1, max=2], [2, 2, max=4], [3, 3, max=0], [4, 4, max=3]
```
90%
```java
public void modify(SegmentTreeNode root, int index, int value) {
    if(index>root.end&&index<root.start)return;
    if(index==root.start&&root.end==index){
        root.max = value;
        return;
    }
    int mid = (root.start+root.end)/2;
    if(mid>=index){
        modify(root.left,index,value);
    }else{
        modify(root.right,index,value);
    }
    root.max = Math.max(root.left.max,root.right.max);
}
```
### lt205区间最小数LogN 查询时间
```java
class segMinNode{
    public int start,end,min;
    public segMinNode left,right;
    public segMinNode(int start,int end,int min){
        this.start = start;
        this.end = end;
        this.min = min;
        this.left = null;
        this.right = null;
    }
}
private segMinNode build(int[] A,int start,int end){
    if(start>end)return null;
    if(start == end)return new segMinNode(start,end,A[start]);
    segMinNode root = new segMinNode(start,end,A[0]);
    int mid = (start+end)/2;
    root.left = build(A,start,left);
    root.right = build(A,left+1,end);
    root.min = Math.min(root.left.min,root.right.min);
    return root;
}
public int query(segMinNode root,int start,int end){
    if(start == root.start&&root.end ==end)return root.min;
    int mid = (root.start+root.end)/2;
    int left = Integer.MAX_VALUE,right = Integer.MAX_VALUE;
    //查询区间<=mid，肯定全在左边
    if(end<=mid){
        left = query(root.left,start,end);
    }
    if(mid<end){
        //查询区间开始在mid或者mid左边，必须查左子树
        if(start<=mid){
            left = query(root.left,start,mid);
            right = query(root.right,mid+1,end);
        }else{
            right = query(root.right,start,end);
        }
    }
    return Math.min(left,right);
}
public List<Integer> intervalMinNumber(int[] A, List<Interval> queries) {
    segMinNode root = build(A,0,A.length-1);
    List<Integer> rst = new ArrayList<>(queries.size());
    for(Interval in:queries){
        rst.add(query(root, in.start,in.end ));
    }
    return rst;
}
```