---
title: 矩阵基本操作和相关题
date: 2018-10-21 14:51:19
tags: [alg]
categories: [算法备忘]
---
### Spiral Matrix II 生成旋转矩阵
贪吃蛇法 ac
```java
public int[][] generateMatrix(int n) {
    int[][] rst = new int[n][n];
    int[] loc = {0,0}; 
    int num = 1;
    rst[loc[0]][loc[1]] = num++;
    while(true){
        int lx = loc[0];
        int ly = loc[1];
        while(loc[1]+1 < n && rst[loc[0]][loc[1]+1] == 0){
            loc[1]+=1;
            rst[loc[0]][loc[1]] = num++;
        }
        while(loc[0]+1 < n && rst[loc[0]+1][loc[1]] == 0){
            loc[0]+=1;
            rst[loc[0]][loc[1]] = num++;
        }
        while(loc[1]-1 >= 0 && rst[loc[0]][loc[1]-1] == 0){
            loc[1]-=1;
            rst[loc[0]][loc[1]] = num++;
        }
        while(loc[0]-1 >= 0 && rst[loc[0]-1][loc[1]] == 0){
            loc[0]-=1;
            rst[loc[0]][loc[1]] = num++;
        }
        if(lx == loc[0] &&ly==loc[1])break;
    }
    return rst;
}
```

### 48 Rotate Image
{% fold %}
逆时针：第一步交换主对角线两侧的对称元素，第二步交换第i行和第n-1-i行，即得到结果。 如果是顺时针， 第一步交换对角线两侧的对称元素，第二步交换第i行和第n-1-i行，即得到结果。
```java
public void rotate(int[][] matrix) {
   int n = matrix.length;  
    for(int i = 0;i<n;i++){
        for(int j = i+1;j<n;j++){
            if(i!=j){
                int tmp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = tmp;  
            }            
        }
    }
    for(int i =0;i<n;i++){
        for(int j = 0;j<n/2;j++){
           int tmp = matrix[i][j];
            matrix[i][j] = matrix[i][n-1-j];
            matrix[i][n-1-j] = tmp;
        }
    }
}
```
{% endfold %}

### 快速幂
给定一个double类型的浮点数base和int类型的整数exponent。求base的exponent次方。
```java
public double Power(double base, int ex) {
    double rst = 1;
    while(ex >0){
        if((ex&1) != 0){
            rst = rst*base;
        }
        base = base*base;
        ex>>=1;
    }
    // 2，-3
   if(ex <0){
       ex = -ex;
   }
    while(ex >0){
        if((ex&1) != 0){
            rst = rst/base;
        }
        base = base*base;
        ex>>=1;
    }
    return rst;
}
```


### 矩阵链乘法O(n^3)的dp

### 最大子矩阵和
https://www.youtube.com/watch?v=yCQN096CwWM
time O(col x col x row)



### 54旋转矩阵 顺时针打印矩阵
1 贪吃蛇法8% 3ms，从这一行到边界，然后掉头，外层访问过的都mark掉
```java
public List<Integer> spiralOrder(int[][] mat) {
    List<Integer> rst = new ArrayList<>();
    int n = mat.length;
    if(n == 0)return rst;
    int m = mat[0].length;
    // int[] rst = new int[n*m];
  
    boolean[][] seen = new boolean[n][m];
    int[][] dirs = {{0,1},{1,0},{0,-1},{-1,0}};

    int r = 0,c = 0,di = 0;
    for (int i = 0; i <n*m ; i++) {
        rst.add(mat[r][c]);
        seen[r][c] = true;
        // rst[i] = mat[r][c];
        int cr = r+dirs[di][0];
        int cc = c+dirs[di][1];
        if(0 <= cr && cr < n&&0 <= cc&&cc < m && !seen[cr][cc]){
            r = cr;
            c = cc;
        }else {
            di = (di+1)%4;
            r += dirs[di][0];
            c += dirs[di][1];
        }
    }
    return rst;
}
```



![rotate2d.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/rotate2d.jpg)
top=0,bot=3,left=0,right = 3
n是矩阵大小n>1的时候继续，每一圈，矩阵大小-=2
将2赋值给8：
[top+i][right]=[top][left+i]
i=3:3赋值给12
每个i要赋值4遍，上下左右
外层完了之后子问题是top++,left++,right--,bot--,n-=2

方法2：翻转？

### 59 生成nxn的旋转矩阵


### 顺时针旋转矩阵


矩阵乘法相关题目：
http://www.matrix67.com/blog/archives/276

### poj3734

### 790 L型，XX型骨牌覆盖2xN的board
> Input: 3
Output: 5
Explanation: 
The five different ways are listed below, different letters indicates different tiles:
XYZ XXZ XYY XXY XYY
XYZ YYZ XZZ XYY XXY

![lc790.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lc790.jpg)
1.如果只XX骨牌
dp[i] 表示N = i的时候有多少种解
其实是费fib数列

#### poj 2411
http://poj.org/problem?id=2411
输入：大矩阵的h高，和w宽
输出:用宽2，高1的骨牌一共有多少种拼法


### 图中长度为k的路径计数
https://www.nowcoder.com/acm/contest/185/B
>求出从 1 号点 到 n 号点长度为k的路径的数目.

{% fold %}
```java
import java.util.Arrays;
import java.util.Scanner;

public class Main {
    //AC
//    final static int M = 10000;
    public static long[][] mul(long[][] A,long[][] B){
        long[][] rst = new long[A.length][B[0].length];
        for (int i = 0; i <A.length ; i++) {
            for (int k = 0; k <B.length ; k++) {
                for (int j = 0; j <B[0].length ; j++) {
                    rst[i][j] = (rst[i][j]+A[i][k]*B[k][j]);
                }
            }
        }
        return rst;
    }
    public static long[][] pow(long[][] A,int n){
        long[][] rst =new long[A.length][A.length];
        for (int i = 0; i <A.length ; i++) {
            rst[i][i] = 1;
        }
        while (n>0){
            if((n&1)!=0){
                rst = mul(rst,A );
            }
            A = mul(A, A);
            n>>=1;
        }
        return rst;
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        int k = sc.nextInt();
        long[][] graph = new long[n][n];
        for (int i = 0; i <n ; i++) {
            for (int j = 0; j <n ; j++) {
                graph[i][j] = sc.nextInt();
            }
        }
        long[][] Gn = pow(graph, k);
        System.out.println(Gn[0][n-1]);
    }
}

```
{% endfold %}

有向图 从A点走K步到达B(边可重复)的方案数
`G[u][v]`表示u到v 长度为k的路径数量
k=1 1条边可达的点 G1是图的邻接矩阵
![kpath.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/kpath.jpg)

### 快速幂logN完成幂运算
carmichael number
```java
//this^exponent mod m
public BigInteger modPow(BigInteger exponent, BigInteger m)
```

### 递推公式
![ditui.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/ditui.jpg)
实际上求m项地推公式的第n项 可以用初项线性表示，通过快速幂O(m^2logn)

### fibo递推公式
[特征方程](https://baike.baidu.com/item/%E7%89%B9%E5%BE%81%E6%96%B9%E7%A8%8B)
1.二阶递推公式的特征方程
递推公式Xn = aXn-1 - bXn-2
特征方程x^2-ax+b =0
解得x1,x2则存在F(n) = Ax1+Bx2
带入F(0),F(1) 可得通项

2.矩阵解法
二阶递推式存在2x2矩阵A
![fibo.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/fibo.jpg)

矩阵乘法：
```java
final int M = 10000;
public int[][] mul(int[][] A,int[][] B){
    int[][] rst = new int[A.length][B[0].length];
    for (int i = 0; i <A.length ; i++) {
        for (int k = 0; k <B.length ; k++) {
            for (int j = 0; j <B[0].length ; j++) {
                rst[i][j] = (rst[i][j]+A[i][k]*B[k][j])%M;
            }
        }
    }
    return rst;
}
```
![quickmi.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/quickmi.jpg)
快速幂，将n用二进制表示，5->101表示A^5 = A^4+A^1,
A每次翻倍，n一直右移，n最右为1的时候加上当前A翻倍的结果。
矩阵的幂
```java
public  int[][] pow(int[][] A,int n){
    int[][] rst =new int[A.length][A.length];
    for (int i = 0; i <A.length ; i++) {
        rst[i][i] = 1;
    }
    //for(;n>0;n>>=1)
    while (n>0){
        //快速幂
        if((n&1)!=0)rst = mul(rst,A );
        A = mul(A, A);
        n>>=1;
    }
    return rst;
}
```

解fibo：
```java
int[][] A = {{1,1},{1,0}};
int[][] rst = sl.pow(A, n);
System.out.println(rst[1][0]);
```

### 867 矩阵转置
```java
public int[][] transpose(int[][] A) {
    int m = A.length;
    int n = A[0].length;
    int [][] rst = new int[n][m];
    for(int r =0;r < m; r++){
        for(int c =0; c < n;c++){
            rst[c][r] = A[r][c];
        }
    }
    return rst;
}
```


### 566 矩阵reshape
```java
public int[][] matrixReshape(int[][] nums, int r, int c) {
    int[][] rst = new int[r][c];
    int m = nums.length;
    int n = nums[0].length;
    if(r*c != n*m){
        return nums;
    }
    for(int i = 0;i < m;i++){
        for(int j = 0;j < n;j++){
            int row = (i*n+j) / c;
            int col = (i*n+j) % c;
            rst[row][col] = nums[i][j];
        }
    }
    return rst;
}
```

concise：
```java
public int[][] matrixReshape(int[][] nums, int r, int c) {
    int n = nums.length, m = nums[0].length;
    if (r*c != n*m) return nums;
    int[][] res = new int[r][c];
    for (int i=0;i<r*c;i++) 
        res[i/c][i%c] = nums[i/m][i%m];
    return res;
}
```