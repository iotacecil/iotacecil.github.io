---
title: 广度优先用于无权图的最短路径
date: 2018-10-21 18:19:30
tags: [alg]
categories: [算法备忘]
---
有权图的最短路径要用DijKstra

### 279完美平方数


### 距离场
距离场的题不适合用dfs，递归全部完成才建立好距离场。

#### lt 803 建筑物之间的最短距离
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

思路：
1.BFS可以求每个0到这个建筑物的距离。BFS保证每个可达的格子只访问1次肯定是最短距离。
2.用一个矩阵累加空地到所有建筑物的距离。并且计数这是累加了几个建筑物的。
3.遍历累加距离矩阵中累加了和1相等的数量的格子中最小的那个。

`int[n][m][2]` 每个位置(2,1)表示从一个建筑物出发，走两步到达这个格子。
从另一个建筑物出发，叠加距离变成(4,2)表示第二个建筑物走两步到达这个格子。
```java
int[][] dirs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
public int shortestDistance(int[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    int[][][] res = new int[n][m][2];
    // 城市的数量
    int count = 0;
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
            if(grid[i][j] == 1) {
                count++;
                bfs(grid, i, j, res);
            }
//                System.out.println();
        }
    }
    int min = Integer.MAX_VALUE;
    for(int i = 0; i < n; i++)
        for(int j = 0; j < m; j++)
            if(res[i][j][1] == count)
                min = Math.min(min, res[i][j][0]);
    return min;
}

void bfs(int[][] grid, int i, int j, int[][][] res) {
    int n = grid.length;
    int m = grid[0].length;
    Queue<int[]> q = new LinkedList<>();
    q.offer(new int[]{i, j});
    boolean[][] v = new boolean[n][m];

    int step = 1;
    while(!q.isEmpty()) {
        int size = q.size();
       while (size-- > 0){
            int[] cur = q.poll();
            for(int[] dir : dirs) {
                int x = cur[0] + dir[0];
                int y = cur[1] + dir[1];
                // 四个方向继续找空地
                if(x < 0 || x >= n || y < 0 || y >= m || grid[x][y] != 0 || v[x][y]) continue;
                q.offer(new int[]{x, y});
                res[x][y][0] += step;
                res[x][y][1] += 1;
                v[x][y] = true;
            }
        }
//            System.out.println(Arrays.deepToString(res));
        step++;
    }
}
```

#### lt573 邮局建立
同上
{% fold %}
```java
public int shortestDistance(int[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    int cnt = 0;
    int[][][] res = new int[n][m][2];
    for(int i = 0;i<n;i++){
        for(int j = 0;j<m;j++){
            if(grid[i][j] == 1){
              cnt ++;
              bfs(grid,i,j,res);
            }
        }
    }
    int min = Integer.MAX_VALUE;
    for(int i =0;i<n;i++){
        for(int j = 0;j<m;j++){
            if(res[i][j][1] == cnt)
            min = Math.min(min,res[i][j][0]);
        }
    }
    return min == Integer.MAX_VALUE? -1:min;
}

int[][] dirs = {{0,1},{0,-1},{-1,0},{1,0}};
private void bfs(int[][] grid,int cx,int cy,int[][][] res){
     int n = grid.length;
    int m = grid[0].length;
    boolean[][] visited = new boolean[n][m];
    visited[cx][cy] = true;
    Queue<int[]> que = new ArrayDeque<>();
    que.add(new int[]{cx,cy});
    int step = 0;
    while(!que.isEmpty()){
        int size = que.size();
        while(size-- >0){
        int[] cur = que.poll();
        int x = cur[0];
        int y = cur[1];
        for(int i =0;i<dirs.length;i++){
            int nx = x + dirs[i][0];
            int ny = y + dirs[i][1];
            if(nx >=0 && ny >=0 && ny<m && nx <n && grid[nx][ny] == 0 && !visited[nx][ny]){
                res[nx][ny][0] += (step+1);
                res[nx][ny][1] += 1;
                que.add(new int[]{nx,ny});
                visited[nx][ny] = true;
            }
        }
        
    }
    step ++;
    }
}
```
{% endfold %}

#### 542 01矩阵 变成离0距离的矩阵
```
0 0 0
0 1 0
1 1 1

0 0 0
0 1 0
1 2 1
```

还可以dp todo

还可以dfs todo

1.把0都放入队列，非零格子最大化
2.如果bfs到这个格子的距离比格子的值小就更新。
```java
int[][] ori = {{0, 1}, {0, -1}, {-1, 0}, {1, 0}};
public int[][] updateMatrix(int[][] matrix) {
    int n = matrix.length;
    int m = matrix[0].length;   
    Queue<int[]> que = new LinkedList<>();
    for (int i = 0; i < matrix.length; i++) {
        for (int j = 0; j < matrix[0].length; j++) {
            if (matrix[i][j] == 0) {
              que.add(new int[]{i, j});
            }else{
                matrix[i][j] = Integer.MAX_VALUE;
            }
        }
    }
    while (!que.isEmpty()) {
        int[] top = que.poll();             
        int curx = top[0];
        int cury = top[1];
        
        for (int i = 0; i < ori.length; i++) {
                int newx = curx + ori[i][0];
                int newy = cury + ori[i][1];

                if (newx < 0 || newx >= n || newy < 0 || newy >= m ||
                    matrix[newx][newy] <= matrix[curx][cury] +1)
                    continue;
                matrix[newx][newy] = matrix[curx][cury] + 1;
                que.add(new int[]{newx, newy});    
        }      
    }
    return matrix;
}
```

#### lt 663 墙和门
您将获得一个使用这三个可能值初始化的 m×n 2D 网格。
-1 - 墙壁或障碍物。
0 - 门。
INF - Infinity是一个空房间。我们使用值 2 ^ 31 - 1 = 2147483647 来表示INF，您可以假设到门的距离小于 2147483647

在代表每个空房间的网格中填入到距离最近门的距离。
如果不可能到达门口，则应填入 INF。


>给定 2D 网格：
```
INF  -1  0  INF
INF INF INF  -1
INF  -1 INF  -1
  0  -1 INF INF
```
返回结果：
```
  3  -1   0   1
  2   2   1  -1
  1  -1   2  -1
  0  -1   3   4
```

dfs 1415 ms
```java
int[][] dirs = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};

public void wallsAndGates(int[][] rooms) {
   int n = rooms.length;
   int m = rooms[0].length;
   for(int i = 0;i<n;i++){
       for(int j = 0;j<m;j++){
           if(rooms[i][j] == 0)
            dfs(rooms,i,j,0,m,n);}}}

private void dfs(int[][] rooms,int x,int y,int d,int m,int n){
     if(rooms[x][y] > d || d == 0){
         rooms[x][y] = d;
    
     for(int i = 0;i< dirs.length ;i++){
         int newx = x + dirs[i][0];
         int newy = y + dirs[i][1];
         if(newx>=n || newy>=m ||newx<0||newy<0 ||rooms[newx][newy] ==-1)continue;
         dfs(rooms,newx,newy,d+1,m,n);
     }}
     return;
}
```


BFS方法同上
{% fold %}
```java
int[][] dirs = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};

public void wallsAndGates(int[][] rooms) {
    int n = rooms.length;
    int m = rooms[0].length;
    Queue<int[]> que = new ArrayDeque<>();

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (rooms[i][j] == 0) {
                que.add(new int[]{i, j});
            }}}
    while (!que.isEmpty()) {
        int[] cur = que.poll();
        int curx = cur[0];
        int cury = cur[1];

        for (int i = 0; i < dirs.length; i++) {
            int newx = curx + dirs[i][0];
            int newy = cury + dirs[i][1];
            if (newx < 0 || newx >= n || newy < 0 || newy >= m
                    || rooms[newx][newy] == -1 || rooms[newx][newy] < rooms[curx][cury] + 1) {
                continue;
            }
            rooms[newx][newy] = rooms[curx][cury] + 1;
            que.add(new int[]{newx,newy});
        }}}
```
{% endfold %}

---

### !!126 word Ladder 返回所有可能的路径 记录宽搜搜索路径！
77% 117ms
1.先bfs，在bfs的过程中，构建有向图邻接表map。完成一个最长路径为k的图。
2.在构建完的图中dfs，回溯找完到end的路径tmp添加到rst中。
```java
public List<List<String>> findLadders(String beginWord, String endWord, List<String> wordList) {
        HashSet<String> words = new HashSet<>(wordList);
        words.add(beginWord);
        List<List<String>> rst = new ArrayList<>();
        HashMap<String,List<String>> graph = new HashMap<>();
        // pair <node,step>
        HashMap<String,Integer> pairs = new HashMap<>();
        ArrayList<String> tmp = new ArrayList<>();
        bfs(beginWord,endWord,words,graph,pairs);
        dfs(beginWord,endWord,words,graph,pairs,tmp,rst);
        return rst;
    }

    // 从set 中筛选出 步长差1的String
    private List<String> getNeib(String top,Set<String> words){
        List<String> rst = new ArrayList<>();
        char[] chs = top.toCharArray();
        // 这两个循环如果反一下 慢30ms （数量小的循环要写外面？）
            for(char ch = 'a'; ch <= 'z' ; ch++ ){
                for (int i = 0; i <chs.length ; i++) {
                if(chs[i] == ch)continue;
                char old = chs[i];
                chs[i] = ch;
                if(words.contains(String.valueOf(chs))){
                    rst.add(String.valueOf(chs));
                }
                chs[i] = old;
            }
        }
        return rst;
    }

    // bfs可以找到所有 k步可达的顶点，并建立起链接， k是到达end的最少步数
    private void bfs(String start,String end,Set<String> words,HashMap<String,List<String>> graph,HashMap<String,Integer> pairs){
        for(String word : words){
            graph.put(word, new ArrayList<>());
        }
        // 队列只放node 或者结构体把step也带着
        Deque<String> que = new ArrayDeque<>();
        que.add(start);
        pairs.put(start, 0);
        while (!que.isEmpty()){
            // 这一层
            int count = que.size();
            boolean found = false;
            for (int i = 0; i < count ; i++) {
                String top = que.poll();
                int step = pairs.get(top);
                List<String> neib = getNeib(top, words);

                for(String next : neib){
                    // 构建有向图
                    graph.get(top).add(next);
                    // 记录访问过了并且当前访问的步长 不用了visit set
                    if(!pairs.containsKey(next)){
                        // 注意找到了也需要先把pair放进去
                        pairs.put(next, step+1);
                        // 如果找到了
                        if(end.equals(next)){
                            found = true;
                        }else{
                            que.add(next);
                        }
                    }
                }

                if(found)break;


            }

        }

    }

    private void dfs(String start,String end,Set<String> words,Map<String,List<String>> graph,Map<String,Integer> pairs,List<String> tmp,List<List<String>> res){
        tmp.add(start);
        if(end.equals(start))
        {
            res.add(new ArrayList<>(tmp));
        }else {
            // 从start dfs找这个最长只有k步的图， dfs的条件是1 是邻边表示差1步，2是pair中记录这个邻边是下一个step
            for(String next : graph.get(start)){
                if(pairs.get(next) == pairs.get(start) + 1){
                    dfs(next,end,words,graph,pairs,tmp,res);
                }
            }
        }
        //如果这条路走不通或者走完了，一段一段删回来
        tmp.remove(tmp.size()-1);
    }

```


队列中的结构`<顶点，前驱，步数>`

### !!127 word Ladder bfs最短单词转换路径
todo 为什么复杂度差那么多

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


构建图，用map 邻接表，两层for遍历wordList(包括start) ,如果两个字符串只差一个字符，则加到双方邻接表(map)中。
将start放进队列`<顶点,步数>`，宽搜,搜到返回步数。
需要markedSet，因为一个点的父节点有多个，将一个点的邻接点放进队列，有的点早被别的父节点就放进队列过了。 AC 17.88% 570ms
{% fold %}
```java
class Pair{
    String word;
    int step;

    public Pair(String word, int step) {
        this.word = word;
        this.step = step;
    }
}
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
    Map<String,List<String>> map = new HashMap<>();
    List<String> words = new ArrayList<>(new HashSet<>(wordList));
    words.add(beginWord);
    if(!words.contains(endWord)){
        return 0;
    }
    // graph build
    for(int i = 0;i<words.size();i++){
        String word1 = words.get(i);
        List<String> word1List = map.getOrDefault(word1, new ArrayList<>());
        for (int j = i+1; j <words.size() ; j++) {
            String word2 = words.get(j);
            if(dif(word1,word2 )){
                List<String> word2List = map.getOrDefault(word2, new ArrayList<>());
                word2List.add(word1);
                map.put(word2,word2List);
                word1List.add(word2);
            }
            map.put(word1,word1List );
        }
    }
    // bfs
    Deque<Pair> que = new ArrayDeque<>();
    Set<String> visited = new HashSet<>();
    que.add(new Pair(beginWord,1));
    visited.add(beginWord);

    while (!que.isEmpty()){
        Pair top = que.poll();
        int step = top.step;
        List<String> neib = map.get(top.word);
        for(String next : neib){
            if(!visited.contains(next)){
                if(next.equals(endWord)){
                    return step + 1;
                }
                que.add(new Pair(next,step+1));
                visited.add(next);
            }
        }
    }
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

### 倒水问题 BFS ax + by = m 最大公约数 
有无限的水源,一个5L无刻度桶和一个7L无刻度桶,则只利用这两个无刻度桶,将不能获得()L水
正确答案: F   你的答案: E (错误)
A2
B3
C6
D8
E11
F以上均能获得

#### 365 容量x,y的两个杯子能否量出z
>Input: x = 3, y = 5, z = 4
Output: True
>Input: x = 2, y = 6, z = 5
Output: False

bfs 4种情况
```java
public boolean canMeasureWater(int x, int y, int z) {
    if(z == 0)return true;
    if(x + y < z)return false;
    int total = x+y;
    Set<Integer> set = new HashSet<>();
    Queue<Integer> q = new LinkedList<>();
    q.offer(0);
    while (!q.isEmpty()){
        int n = q.poll();
        if(n + x <= total && set.add(n + x)){
            q.offer(n + x);
        }
        if(n + y <= total && set.add(n + y)){
            q.offer(n + y);
        }
        if(n - x >=0 && set.add(n -x)){
            q.offer(n-x);
        }
        if(n -y >=0 &&set.add(n - y)){
            q.offer(n - y);
        }
        if(set.contains(z)){
            return true;
        }
    }
    return false;
}
```

`-2*3 + 2*5 = 4`
倒掉3的容器2次倒满5的容器2次
1.装满5，倒给3 -> (0,2)
2.装满5，倒给3 -> (4,3)

只要z是x,y的最大公约数的倍数就True

- 裴蜀定理:ax + by = m
**有整数解，当且仅当 m是d = gcd(a,b)的倍数**

d 是最小的 可以写成ax+by形式的正整数。
ax+by = 1有整数解 当且仅当 a,b互质

```java
public boolean canMeasureWater(int x, int y, int z) {
    if(z == 0)return true;
    if(x == 0 && y != z)return false;
    if(y == 0 && x != z)return false;
    if(x + y < z)return false;

    if(z % gcd(x,y) == 0){
        return true;
    }else{
        return false;
    }
}
public static long gcd(long a, long b) {
    return (b == 0) ? a : gcd(b, a % b);
}
```

#### hdu 1495 容量S 用N和M的平分
> S:可乐体积 N杯子1 M杯子2 N+M=S 三个容器可以互相倒 能不能2人平分 
> 7 4 3
> 4 1 3
> out： 最少次数
> NO
> 3

`ax+by = (a+b)/2`
第一个瓶子倒入x次第二个倒出y次
倒进倒出都是大瓶子，倒进1次之后继续用还要把小瓶子倒回大瓶子，倒出同理。
但是最后 一定是放在两个小瓶子里不用倒回大瓶子 所以操作数=(a+b)/gcd(a,b)-1


#### poj 3414 Pots 容量A,B的容器 量出C升水
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

Accepted    3128K   1125MS 

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