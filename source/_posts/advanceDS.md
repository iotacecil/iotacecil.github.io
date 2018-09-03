---
title: 数据结构模板&模板题
date: 2018-09-01 15:29:18
tags:
---
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

### !200 number of islands
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
![unionfind2.jpg](/images/unionfind2.jpg)
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
```java

```


### 208 Trie树 前缀树
实现String`insert` `search` `startsWith`
![trieTree.jpg](/images/trieTree.jpg)
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

### 线段树Segment Tree
定义：
1.叶节点是输入
2。每个内部节点是为不同问题设计的，叶节点的组合（和/最大值/最小值）
![segmentTree.jpg](/images/segmentTree.jpg)
查找范围内的最小值/和 只需要Log(n)

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
![segmentquery.jpg](/images/segmentquery.jpg)
1.区间完全匹配的，return value
2.区间完全不匹配的，return 0
3.部分匹配超出查询区间的 递归查询左右子树
查`[3:4]` 遇到`[3:5]`,继续查`[3:4]`,`[5,5]`完全超出

![segmentminquery.jpg](/images/segmentminquery.jpg)
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
