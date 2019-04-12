---
title: 笔试真题
date: 2019-03-21 15:40:14
tags: [alg]
categories: [算法备忘]
---
### bd02
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
