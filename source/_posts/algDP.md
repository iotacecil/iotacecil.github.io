---
title: algDP
date: 2019-03-07 20:56:46
tags: [alg]
categories: [算法备忘]
---
### 击鼓传花
每个同学都可以把花传给自己左右的两个同学中的一个（左右任意）有多少种不同的方法可以使得从小赛手里开始传的花，传了m次以后，又回到小赛手里。
对于传递的方法当且仅当这两种方法中，接到花的同学按接球顺序组成的序列是不同的，才视作两种传花的方法不同。比如有3个同学1号、2号、3号，并假设小赛为1号，花传了3次回到小赛手里的方式有1->2->3->1和1->3->2->1，共2种。

### 746. Min Cost Climbing Stairs
付钱可以跳1阶或者2阶台阶。可以从第0阶或者第1阶开始
{% note %}
Input: cost = [10, 15, 20]
Output: 15
{% endnote %}
dp定义为离开第i个台阶的最小花费，递推到离开第min(dp[n-2],dp[n-1])个楼梯

dp定义为 到达第n阶楼梯的最小花费
```java
public int minCostClimbingStairs(int[] cost) {
    int n = cost.length;
    int[] dp = new int[n+1];
    for(int i = 2;i<=n;i++){
        dp[i] += Math.min(dp[i-1]+cost[i-1],dp[i-2]+cost[i-2]);
    }
    return dp[n]; 
}
```

### 491 复制或者复制一半长度到n的最少操作次数
字符串“A”，有两种操作
1）copyall 设定当前长度为一次粘贴的长度 C = K
2）粘贴n次copy长度 K += C
如何最快得到长度N
这道题就是将N分解为M个数字的乘积，且M个数字的和最小
{% note %}
输入: 3
输出: 3
解释:
最初, 我们只有一个字符 'A'。
第 1 步, 我们使用 Copy All 操作。
第 2 步, 我们使用 Paste 操作来获得 'AA'。
第 3 步, 我们使用 Paste 操作来获得 'AAA'。
{% endnote %}
1->0,2->cp(2),3->cpp(3),4->cpcp(4),5->cp(AA)ppp(5),6cppcp(5)

求n的所有质因数之和。
// 6可以通过长度3的复制，再递归得到3需要多少步。
思路：从长度为2开始试（？）
```java
public int minSteps(int n) {
  int s = 0;
    for (int d = 2; d <= n; d++) {
        while (n % d == 0) {
            s += d;
            n /= d;
        }
    }
    return s;
}
```


### 91 1-26数字对应26个字母，问一个数字对应多少种解码方式
226->2(B)2(B)6(F),22(V)6(F),2(B)26(Z)

3.dp[i]表示s[0..i]的解码方式
关键：
1）长度为0的时候解码方式为1
2）判断前1位数字和前2位的合法性，加上前i-1,i-2长度的方案数
3）越过0
```java
public int numDecodings(String s) {
    int n = s.length();
    int[] dp = new int[n+1];
    dp[0] = 1;
    dp[1] = s.charAt(0)!='0'?1:0;
    for(int i =2;i<=n;i++){
        int one = Integer.valueOf(s.substring(i-1,i));
        if(one <10 && one >0)dp[i] += dp[i-1];
        int two = Integer.valueOf(s.substring(i-2,i));
        if(two <=26 && two >=10)dp[i] += dp[i-2];
    }
    return dp[n];
}
```

{% fold %}
1递归：8%
```java
Map<String,Integer> map = new HashMap<>();
public int numDecodings(String s){
    if(s.length()<1)return 1;
    if(map.containsKey(s))return map.get(s);
    if(s.charAt(0)=='0')return 0;
    if(s.length()==1)return 1;
    // 取一个数字之后的解码方式
    w = numDecodings(s.substring(1));
    // 取两个数字之后的解码方式
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
{% endfold %}




### 718 最长公共子串40ms 90%
{% note %}
Input:
A: [1,2,3,2,1]
B: [3,2,1,4,7]
Output: 3
Explanation: 
The repeated subarray with maximum length is [3, 2, 1].
{% endnote %}
思路：A从位置i开始，和B从j开始匹配的最大长度

```java
public int findLength(int[] A, int[] B) {
        int n = A.length;
        int m = B.length;
        int max = 0;
        int[][] dp = new int[n+1][m+1];  
        for(int i = 1;i<=n;i++){
            for(int j =1;j<=m;j++){
                if(A[i-1]==B[j-1]){
                    dp[i][j] = dp[i-1][j-1]+1;
                    max = Math.max(max,dp[i][j]);
                }
            }
        }     
        return max;
    }
```