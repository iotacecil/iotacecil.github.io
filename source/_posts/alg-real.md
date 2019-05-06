---
title: 笔试真题
date: 2019-03-21 15:40:14
tags: [alg]
categories: [算法备忘]
---

### mt01 切割树 树形DP计数
https://www.luogu.org/problemnew/show/CF461B
给你一棵含有n个结点的树，编号为0~n-1，这n个结点都被染成了黑色或白色。
显然，对于一棵树而言，我们每去掉一条边就能把树分成两部分。
现在，要求你把这棵树切开，使得**每一个连通块内只有一个白色结点**。
问共有多少种切开的方式满足以上条件，如果被删除的边集不同，我们则认为两种方式不同，反之，认为相同。
请输出对1000000007取模后的结果。
{% note %}
3
0 0
1 0 0
输出样例1：
2
输入样例2：
10
0 0 1 2 0 5 1 2 3
1 0 0 1 0 0 1 1 0 1
输出样例2：
3
{% endnote %}
转移方程
```
f[u]表示u的连通区域有一个白的方案数 
g[u]表示u的连通区域没有白的方案数 
// u的连通区域有1个白 自己是白，可以断开的方案数+自己不是白，不能断开的方案数 
// 多个孩子节点为什么是乘法（？）
// 1）自己是白 子树有/没有白f[u]*(g[son]+f(u)) 2)自己是黑，子树有白g[u]*f[son]
f[u]=f[u]*g[son]+f[u]*f[son]+g[u]*f[son] 
// 例子，如果dfs返回的一个son是白f[son] = 1,g[son] = 0当前也是白f[u] = 1 =0+1+0
// 包括当前节点的树 没有白 子树怎么样都行的方案数
g[u]=g[u]*g[son]+g[u]*f[son]
// 每个节点的初始条件，如果是白，则f[u] = 1 不然g[u] = 1
```
```java
public class Main {
    static long[] f;
    static long[] g;
    final static long mod = 1000000007;
    public static void dfs(List[] tree,int[]color,int idx,int fd){
        // 白色
        if(color[idx] == 0)f[idx] = 1;
        else g[idx] = 1;
        List<Integer> nexts = tree[idx];
        for(Integer next : nexts){
            if(next == fd)continue;
            dfs(tree,color,next,idx);
            f[idx] =(f[idx]*g[next]%mod + f[next]*f[idx]%mod + g[idx] *f[next]%mod)%mod;
            g[idx] =(g[idx]*g[next]%mod + g[idx] * f[next]%mod)%mod;
        }
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        List<Integer>[] tree = new ArrayList[n];
        for (int i = 0; i <n ; i++) {
            tree[i] = new ArrayList<>();
        }
        // 连接 当前节点 i+1和读入的father
        for (int i = 0; i <n-1 ; i++) {
            int fd = sc.nextInt();
            tree[fd].add(i+1);
            tree[i+1].add(fd);
        }
        int[] color = new int[n];
        f = new long[n];
        g = new long[n];
        // 每个节点的颜色 0 白色 1 黑色
        for (int i = 0; i <n ; i++) {
            color[i] = sc.nextInt();
        }
        dfs(tree,color,0,-1);
        System.out.println(f[0]);
    }
```

### jd02 寻找子串
给出m个字符串，和一个字符串T，在T中选出经可能多的子串，同时满足
1）这些子串在T中互不相交
2）这些子串是这m个中的 
T最多能选多少个子串（注意一个串可以用好几次）（b,b,aa)(b,b,ac)
{% note %}
3
aa
b
ac
bbaac
输出
3
{% endnote %}

### jd01 逃生
1是根，每个位置上只能有1个人，一分钟移动1个，问全部移动到1最短时间多少
{% note %}
input
6
3 2
2 1
4 3
5 2
6 1

output
4
{% endnote %}
```java
public class taosheng {
    static class Node{
        int val;
        List<Integer> nexts;

        public Node(int val) {
            this.val = val;
            this.nexts = new ArrayList<>();
        }
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        // 邻接表
        Node[] graph = new Node[n];
        for (int i = 0; i <n ; i++) {
            graph[i] = new Node(i);
        }
        for (int i = 0; i <n-1 ; i++) {
            int v = sc.nextInt();
            int w = sc.nextInt();
            graph[v-1].nexts.add(w-1);
            graph[w-1].nexts.add(v-1);
        }
        int max = 0;
        // 计算根节点的所有相邻点 的最大深度
        List<Integer> roots = graph[0].nexts;
        for(Integer root : roots){
            int count = getEdgeCnt(graph,root,0);
            max = Math.max(max, count);
        }
        System.out.println(max+1);
    }
    //dfs遍历计算子节点(边）个数
    private static int getEdgeCnt(Node[] graph, Integer root, int i) {
        int cnt = 0;
        List<Integer> nexts = graph[root].nexts;
        // 忽略到 父节点 i 的边
        cnt += nexts.size()-1;
        for(Integer next:nexts){
            if(next == i)continue;
            cnt += getEdgeCnt(graph, next, root);
        }
        return cnt;
    }
}

```

### tt 变身程序员 lc994
1是新鲜橘子，2是烂橘子,全部变成烂橘子的最少分钟数
{% note %}
Input: [
[2,1,1],
[1,1,0],
[0,1,1]]
Output: 4
{% endnote %}
ac

### bd lc 871最低加油次数


### ali02
班上同学聚餐吃火锅，一锅煮了的M(1<=M<=50)个鱼丸和N(1<=N<=50)个肉丸，现欲将M个鱼丸和N个肉丸分到K(1<=K<=50)个碗中，允许有空碗，鱼丸和肉丸不允许混在同一个碗里，问共有多少种装法？假设碗足够大，能装50个鱼丸或者50个肉丸，碗之间也没有区别，因此当M=N=1，K=3时，只有1种装法，因为(1,1,0)(1,0,1)(0,1,1)被看作是同一种装法。


### ali01
小明、小华，是校内公认的数据算法大牛。两人组队先后参加了阿里云天池大赛多项奖金赛事，多次获奖，小明是其中的队长。最近的一次工业数据智能竞赛中，两人又斩获季军，获得奖金1万元。

作为算法大牛，两人竞赛奖金分配也有独特方式，由两人共同编写的一个程序来决定奖金的归属。每次获奖后，这个程序首先会随机产生若干0~1之间的实数{p_1, p_2, …, p_n}，然后从小明开始，第一轮以p_1的概率将奖金全部分配给小明，第二轮以p_2的概率将奖金全部分配给小华，这样交替地小明、小华以p_i的概率获得奖金的全部，一旦奖金被分配，则程序终止，如果n轮之后奖金依旧没发出，则从p_1开始继续重复（这里需要注意，如果n是奇数，则第二次从p_1开始的时候，这一轮是以p_1的概率分配给小华）；直到100轮，如果奖金还未被分配，程序终止，两人约定通过支付宝将奖金捐出去。

输入:
输入数据包含N+1行，
第一行包含一个整数N
接下来N行，每行一个0~1之间的实数，从p_1到p_N
输出:
单独一行，输出一个小数，表示小明最终获得奖金的概率，结果四舍五入，小数点后严格保留4位(这里需要注意，如果结果为0.5，则输出0.5000)。
输入范例:
1
0.999999
输出范例:
1.0000

```cpp
int N;   
cin >> N;   

vector<double> p(N);
for (int i = 0; i < N; i++)
{
    cin >> p[i];
}
vector<double> p100(100);
for (int i = 0; i < 100; i++)
{
    int index = i % N;
    p100[i] = p[index];
}

double sum = 0.0;
double pre = 1.0;
for (int i = 0; i < 50; i+=2)
{
    sum += pre * p100[i];
    pre *= ((1.0 - p100[i]) * (1.0 - p100[i + 1]));
}

printf("%.4f\n", sum);
```

### bd02
叶子节点的最大乘积

#### !543树中两点的最远路径，自己到自己0


![lc545.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lc545.jpg)
将每个点试当成转折点,在更新左右最长高度的同时更新rst = Max(rst,l+r);

### wz02
有n个勇士，都要要学会k个技能，有m个先知，
先知教一个勇士1分钟，一个勇士只能同时学1个技能，一个先知同时也只能教一个勇士学技能
不同先知或不同勇士可以在同一时间教授/学习技能
一轮可以学m个技能，最有剩下少于m个技能只需要1秒。
```java
if (m >= n) {
   System.out.println(k);
}
if (m < n) {
   double M = (double) (m);
   double res = (n * k) / M;
   long result = (long) Math.ceil(res);
   System.out.println(result);
}
```

### tt03 lc135
n个人有得分，领取奖品
如果某个人分数比左右的人高，那么奖品数量比左右多
每个人至少得到一个奖品
第一行表示测试样例个数
样例第一行，人数n，第二行是分数，输出应该准备的最少奖品数量
{% note %}
输入：
2
2
1 2
4
1 2 3 3


输出
3
8
{% endnote %}

### tt04
N根绳子长度为Li 需要M根登场的，不能拼接，m根绳子最长长度
{% note %}
输入：
3 4
3 5 4
输出：
2.5
{% endnote %}

#### poj1064 n条线段切割成等长k段 的最大长度
> in: 4 11 8.02 7.43 4.57 5.39
> out:2.00 (4+3+2+2=11)

{% fold %}
```java
/**
 * 长度为L的绳子 最多可以切 floor(L/x)段
 * @param x
 * @return
 */
public static boolean C(double x){
    int num = 0;
    for (int i = 0; i <n ; i++) {
        num+=(int)(lines[i]/x);
    }
    return num>=k;
}
public static double howlong(double[] lines,int k){
    //All cables are at least 1 meter and at most 100 kilometers in length.
    double l = 0,h = 100001;
    // while ((h-l)>1e-6){
     //可以达到10^-30的精度
    for (int i = 0; i <100 ; i++) {
        double mid = (l+h)/2;
        if(C(mid))l = mid;
        else h = mid;
    }
    return Math.floor(h*100)/100;
}
```
{% endfold %}

### tx03
剪刀石头布3种排，无限张。牛妹选n张，小Qn张。依次比对，如果Q赢，Q得一分，现在已知牛妹的每一张牌和小Q的最终得分，问小Q有多少种选择卡片的方案（多少种不同的排列）？
n，s（小Q的得分）牛妹的牌0石头1布2剪刀
n<=2000 ,s<=2000

### tx04 lc76
有m种不同颜色的气球，编号1-m，一共n发子弹，连续开了n抢，在这n枪重打爆所有颜色的气球最少用连续几枪？
输入
n<=1000000 m<=2000
一个打爆的气球颜色序列
输出最短包含m个颜色气球的长度 如果无法打爆-1


### tx05
给n 1-n代表n个楼，第i个楼高度为i，每个楼会有一种颜色
有多少种排列满足从左往右（站在左边很远的地方看）能看到L种颜色（看到了L-1次颜色的变化）
答案对1e9+9取模
如果两个相同颜色的楼高度分别为H1，H2(H1<H2)，H1在左边，H1和H2之间的楼都比H1矮，那么左边看来是一种颜色。
能看到一个楼的前提是这个楼之前的楼都比它矮。
输入
n L[1,1296] 1<=L<=n 
n个楼颜色


### pdd 04
给两个不一定合法的括号字符串，交错这两个序列，（在组成的新字符串中，每个初始字符串都保持原来的顺序）得到一个新的合法的圆括号表达式（不同的交错方式可能会得到相同的表达式，这种情况分开计数，求共有多少结果合法的交错方式（无法得到合法表达式则输出0)
结果mod 10^9+7
{% note %}
输入： 长度<2500
(()
())
输出：19
{% endnote %}

### pdd 抢劫 (后缀最大值)
{% note %}
在一条街上的有n个银行，银行在xi位置，有ai元，然后有两个抢劫犯
找两个相距不小于d的银行，使得这两个银行的权值加起来最大
输入：
6 3
1 1
3 5
4 8
6 4
10 3
11 2
输出：
11
{% endnote %}
思路：用两个一维数组保存包括位置i以及i右边 money最大值和最大值的index
位置：1 3 4 6 10 11
利润：1 5 8 4 3  2
dp1 :8 8 8 4 3  2
dp2 :2 2 2 3 4  5
因为位置数组有序，用二分查找当前位置`w[i]`相距d之后的第一个符合的位置。就可以查找dp1得到选择w[i]银行 和距离d右边可能得到的最大利润，并且用dp2得到位置。

pdd的题目银行位置不递增。可以考虑位置数组用于排序，用map记录位置和利润。
{% note %}
```java
// 输出[0,n]
public static int lowerBound(long[] nums, long target) {
    if (nums == null || nums.length == 0) return -1;
    int lb = -1, ub = nums.length;
    while (lb + 1 < ub) {
        int mid = lb + (ub - lb) / 2;
        if (nums[mid] >= target) {
            ub = mid;
        } else {
            lb = mid;
        }
    }
    return ub;
}
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    int n = sc.nextInt();
    int d = sc.nextInt();
    long[] w = new long[n];
    Map<Long,Long> map = new HashMap<>();
    for (int i = 0; i <n ; i++) {
        w[i] = sc.nextLong();
        map.put(w[i],sc.nextLong());
    }
    Arrays.sort(w);
    long max = -1;
    // [i:n-1]的最大值
    long[] backsmax = new long[n+1];
    backsmax[n] = -1;
    for (int i = n-1; i >= 0; i--) {
        backsmax[i] = Math.max(backsmax[i+1],map.get(w[i]));
    }
    for (int i = 0; i <n ; i++) {
        long tmp = w[i] + d;
        int idx = lowerBound(w, tmp);
        if(backsmax[idx] + map.get(w[i]) > max){
            max = Math.max(max, backsmax[idx] + map.get(w[i]));
        }
    }
    System.out.println(max);
}
```
{% endnote %}

### 手串 
莫队算法：有n个数组成一个序列，有m个形如询问L, R的询问，每次询问需要回答区间内至少出现2次的数有哪些。

n个珠子的环，无色或有一个珠子很多种颜色，一共c种颜色，m个珠里同种颜色最多出现1次。
给定n个珠的颜色
输出：有多少种颜色在任意连续m个串珠中出现了至少两次。
接下来n行每行的第一个数num_i(0 <= num_i <= c)表示第i颗珠子有多少种颜色。
依次读入num_i个数字，每个数字x表示第i颗柱子上包含第x种颜色(1 <= x <= c)
{% note %}
输入
n=5 m=2 c=3
3 1 2 3
0
2 2 3
1 2
1 3
输出
2
{% endnote %}

思路：滑动窗口
