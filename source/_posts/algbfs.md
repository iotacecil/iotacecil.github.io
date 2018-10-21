---
title: algbfs
date: 2018-10-21 18:19:30
tags: [alg]
categories: [算法备忘]
---
### 倒水问题 BFS ax + by = m 最大公约数

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