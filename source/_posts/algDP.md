---
title: algDP
date: 2019-03-07 20:56:46
tags: [alg]
categories: [算法备忘]
---
### lc312 lt168 吹气球
每次吹气球i可以得到的分数为 `nums[left] * nums[i] * nums[right]`，
{% note %}
Input: [3,1,5,8]
Output: 167 
Explanation: nums = [3,1,5,8] --> [3,5,8] -->   [3,8]   -->  [8]  --> []
             coins =  3*1*5      +  3*5*8    +  1*3*8      + 1*8*1   = 167
{% endnote %}
思路 可以把这个问题建模成矩阵链,每次相乘之后中间一维就消失了
变成5个矩阵A1(1x3)A2(3x1)A3(1,5)A4(5x8)A5(8x1)
最优解是(((A1(A2xA3))A4)A5)
i>=j dp[i][j] = 0 
dp[i][j] = max(k∈[i,j]){dp[i][k]+dp[k+1][j]+nums[i-1]\*nums[k]\*nums[j]}

![lc312.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lc312.jpg)

```java
public int maxCoins(int[] nums) {
    int n = nums.length;
    int[] arr = new int[n+2];
    int[][] dp = new int[n+2][n+2];
    System.arraycopy(nums, 0, arr, 1, n);
    arr[0] =1;
    arr[n+1] = 1;
    n = n+2;
    // n+1个矩阵
    for (int k = 2; k < n; k++) {
        for(int left = 0;left <n-k;left++){
            int right = left+k;
            for (int i = left+1; i <right ; i++) {
                dp[left][right] = Math.max(dp[left][right],arr[left]*arr[i]*arr[right] + dp[left][i]+dp[i][right] );
            }
        }     
    }
    return dp[0][n-1]; 
}
```

回溯法超时ac

1[4,1,5,10]1 如果最后是1[1]1,上一次只有两种可能性1[4,1]1,1[1,5]1。

```java
public int maxCoins(int[] iNums) {
    int[] nums = new int[iNums.length + 2];
    int n = 1;
    for (int x : iNums) if (x > 0) nums[n++] = x;
    nums[0] = nums[n++] = 1;
    int[][] memo = new int[n][n];
    return burst(memo, nums, 0, n - 1);
}

public int burst(int[][] memo, int[] nums, int left, int right) {
    if (left + 1 == right) return 0;
    if (memo[left][right] > 0) return memo[left][right];
    int ans = 0;
    for (int i = left + 1; i < right; ++i)
        ans = Math.max(ans, nums[left] * nums[i] * nums[right] 
        + burst(memo, nums, left, i) + burst(memo, nums, i, right));
    memo[left][right] = ans;
    return ans;
}
```

### 968 树形dp 监控照相机覆盖
{% note %}
Input: [0,0,null,0,0]
Output: 1
Explanation
{% endnote %}

正确做法贪心dfs：，叶子节点不放，到cover不住叶子的时候再放
3种状态：
0.叶子节点 ： left和right返回状态都是2
1.子节点有个叶子 ++,放照相机，被覆盖
2.null / 子节点有个有照相机 ：没有照相机但是被覆盖

考虑如果dfs返回就是叶子节点状态，need没有增加，要手动+1
```java
int need = 0;
public int minCameraCover(TreeNode root) {
    if(dfs(root)==0)return need+1;
    return need;
}
private int dfs(TreeNode root){
    if(root == null)return 2;
    int left = dfs(root.left);
    int right = dfs(root.right);
    if(left == 0 || right == 0){
        need++;
        return 1;
    }
    if(left == 1 ||right == 1)return 2;
    else if(left == 2 &&right == 2)return 0;
    // return什么都行
    else return 0;
}
```

dp[3]记录3种状态当前节点及子树放的照相机数量。
状态1：子树已经cover，这个节点还没
状态2：子树和这个节点被cover，不放照相机
状态3：子树和这个节点被cover，在此放置照相机（可能cover父节点）
```java
public int minCameraCover(TreeNode root) {
   int[] rst = solve(root);
    return Math.min(rst[1],rst[2]);
}
 public int[]solve(TreeNode node){
    if(node == null)return new int[]{0,0,1};
    // left not cover , left cover , left parent covered
    int[] l = solve(node.left);
    int[] r = solve(node.right);
    return new int[]{l[1]+r[1],
            Math.min(l[0]+r[0]+1, Math.min(l[2]+r[1],l[1]+r[2])),
    Math.min(l[0],l[1])+Math.min(r[0],r[1])+1};
}
```

### lg p1352


### 337 树形house robber 不能抢相邻层
{% note %}
```
Input: [3,2,3,null,3,null,1]
     3
    / \
   2   3
    \   \ 
     3   1

Output: 7 
Explanation: Maximum amount of money the thief can rob = 3 + 3 + 1 = 7.
```
{% endnote %}
每个节点有两种状态，偷或者不偷，保存的是当前节点及以下的最大利润
```java
public int rob(TreeNode root) {
        int[] rst = robb(root);
        return Math.max(rst[0],rst[1]);
    }  
    private int[] robb(TreeNode root){
        if(root == null)return new int[2];
        int[] rst = new int[2];  
        int[] left = robb(root.left); 
        int[] right = robb(root.right);
        rst[0] = Math.max(left[0],left[1]) + Math.max(right[0],right[1]);
        rst[1] = root.val+left[0]+right[0];
        return rst;      
 }
```

### 派间谍 二维背包1 lg 1910
https://www.luogu.org/problemnew/show/P1910

### 称砝码 多重背包1
[nowcoder](https://www.nowcoder.com/questionTerminal/f9a4c19050fc477e9e27eb75f3bfd49c?mutiTagIds=579&orderByHotValue=1&commentTags=C/C++)
利用给定的数量的砝码可以称出的不同的重量数
{% note %}
2
1 2
2 1
输出
5
{% endnote %}

```java
public static int fama(int n, int[] weight, int[] nums){
    int sum = 0;
    for (int i = 0; i <n ; i++) {
        sum += weight[i]*nums[i];
    }
    boolean[][] dp = new boolean[n+1][sum+1];
    dp[0][0] = true;
    for (int i = 0; i <n ; i++) {
        // 使用这个物品，尝试凑出这个总量，并且尝试使用几个
        for (int j = 0; j <=sum ; j++) {
            for (int k = 0; k <= nums[i] && k*weight[i]<=j ; k++) {
                dp[i+1][j] |= dp[i][j-k*weight[i]];
            }
        }
    }
    int cnt = 0;
    for (int i = 0; i <=sum ; i++) {
        if(dp[n][i])cnt++;
    }
    return cnt;
}
```



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




