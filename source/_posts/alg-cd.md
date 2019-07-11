---
title: 国内公司面试高频题
date: 2019-05-29 20:39:39
tags: [alg]
categories: [算法备忘]
---
### 730 统计不同回文子字符串 bd
{% note %}
输入：
S = 'bccb'
输出：6
解释：
6 个不同的非空回文子字符序列分别为：'b', 'c', 'bb', 'cc', 'bcb', 'bccb'。
注意：'bcb' 虽然出现两次但仅计数一次。
{% endnote %}

### 25 k个一组反转链表
{% note %}
Given this linked list: 1->2->3->4->5
For k = 2, you should return: 2->1->4->3->5
For k = 3, you should return: 3->2->1->4->5
{% endnote %}

```java
public ListNode reverseKGroup(ListNode head, int k) {
    int cnt = 0;
    ListNode cur = head;
    while(cur!=null && cnt <k){
        cur = cur.next;
        cnt++;
    }       
    // 如果不到k个不翻转
    if(cnt == k){
        // 4->3->5
         cur = reverseKGroup(cur,k);
        while(cnt-->0){
            ListNode next = head.next;
            head.next = cur;
            cur = head;
            head = next;
        }
        // 关键
        head = cur;
    }  
    return head;   
}
```

### 698 划分成k个相等子集
{% note %}
输入： nums = [4, 3, 2, 3, 5, 2, 1], k = 4
输出： True
说明： 有可能将其分成 4 个子集（5），（1,4），（2,3），（2,3）等于总和。
{% endnote %}

//todo DP
https://leetcode.com/problems/partition-to-k-equal-sum-subsets/

1.计算出数组的sum看能不能整除k，同时得到了每组的subsum
2.如果数组中有一个元素>subsum则不可能。最大的几个==subsum，自己分成一组。
3.对前面都比subsum小的元素回溯将数字放入group数组。变成 Combination tum target
```java
public boolean canPartitionKSubsets(int[] nums, int k) {
    // 1. 求每组应该的平均值
    int sum = 0;
    for(int num : nums){
        sum += num;
    }
    if(sum % k != 0){
        return false;
    }
    int subsum = sum/k;
    // 2. 等于平均值的单独分成一组
    Arrays.sort(nums);
    int n = nums.length;
    int idx = n-1;
    if(nums[n-1] > subsum)return false;
    for(int i = n-1;i >= 0;i--){
        if(nums[i] < subsum)break;
        if(nums[i] == subsum){
            k--;
            idx--;
        }
    }
    // 3. 回溯分组
    int[] group = new int[k];
    return back(group,idx,subsum,nums);
}
private boolean back(int[] group,int idx,int target,int[] nums){
    // 全部都分组好了
    if(idx < 0){
        return true;
    }
         // 试着放到每一组
    for(int i = 0;i < group.length;i++){
        if(group[i] + nums[idx] > target){
            continue;
        }
        group[i] += nums[idx];
        if(back(group,idx-1,target,nums)){
            return true;
        }
        group[i] -= nums[idx];
        // 重要剪枝30%->100% 
        // 如果这个桶已经装过了，减到0了，用其他数字装这个桶的结果其实已经在别的桶实现过了
        // 一个桶肯定有一个数字，减到没有数字其他桶也没可能了，直接退出
        if (group[i] == 0) break;

    }
    return false;
}
```

### 638 大礼包
{% note %}
输入: [2,5], [[3,0,5],[1,2,10]], [3,2]
输出: 14
解释: 
有A和B两种物品，价格分别为¥2和¥5。
大礼包1，你可以以¥5的价格购买3A和0B。
大礼包2， 你可以以¥10的价格购买1A和2B。
你需要购买3个A和2个B， 所以你付了¥10购买了1A和2B（大礼包2），以及¥4购买2A。
{% endnote %}

### 547 朋友圈
{% note %}
输入: 
[[1,1,0],
 [1,1,0],
 [0,0,1]]
输出: 2 
说明：已知学生0和学生1互为朋友，他们在一个朋友圈。
第2个学生自己在一个朋友圈。所以返回2。
{% endnote %}


### 322找钱最少硬币数 （递归求最小步数的解法）！
贪心算法一般考举反例。
不能用贪心的原因：如果coin={1,2,5,7,10}则使用2个7组成14是最少的，贪心不成立。
满足贪心则需要coin满足倍数关系{1,5,10,20,100,200}


> 输入：coins = [1, 2, 5], amount = 11
> 输出：3 (11 = 5 + 5 + 1)

1. 递归mincoins(coins,11)=mincoins(coins,11-1)+1=(mincoins,10-1)+1+1..=(mincoins,0)+n

![coinchange.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/coinchange.jpg)
递归 记忆子问题 剩下3，用2的硬币变成剩下1的子问题和 剩下2，用1的硬币 剩下1的子问题是相同的。递归给count赋值是从下往上的。
```java
public int coinChange3(int[] coins, int amount) {
    if(amount<1)return 0;
    return coinChange2(coins,amount,new int[amount]);
}
private int coinC(int[] coins,int left,int[] count){
    if(left<0)return -1;
    if(left==0)return 0;
    //关键，不然超时
    if(count[left]!=0)return count[left];
    int min = Integer.MAX_VALUE;
    for(int coin:coins){
        int useCoin = coinC(coins,left-coin,count);
        if(useCoin >=0&&useCoin<min){
            min = 1+useCoin;
        }
    }
    return count[left] = (min==Integer.MAX_VALUE)?-1:min;  
}
```

![coin.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/coin.jpg)

2. dp:
    注意点：初值如果设为Int的max，两个都是max的话+1变成负数，所以设amount+1
    j 从coin开始
81%~94% 不稳定
```java
int[] dp = new int[amount+1];
Arrays.fill(dp,amount+1);
dp[0] =0;
for(int coin:coins){
    for(int j = coin;j<=amount;j++){
        dp[j]=Math.min(dp[j],dp[j-coin]+1);
    }
}
return dp[amount]>amount?-1:dp[amount];    
```

3. 最正确的方法：dfs分支限界
    1.逆序coins数组 贪心从大硬币开始试
    2.dfs终止条件是 找到硬币整除了，或者idx==0但是不能整除
    3.剪枝条件是 考虑用当前`coins[idx]`i个之后，用下一个硬币至少1个，如果超了break
99%
```java
int minCnt = Integer.MAX_VALUE;
public int coinChangedfs(int[] coins,int amount){
    Arrays.sort(coins);
    dfs(amount,coins.length-1,)
    return minCount == Integer.MAX_VALUE?-1:minCount;
}
private void dfs(int amount,int idx,int[] coins,int count){
    if(amount%coins[idx]==0){
        int bestCnt = count+amount/coins[idx];
        //当[1,2,5] 11, 用掉两个5，count=2 idx=0,cnt+1=3 return
        if(bestCnt<minCnt){
            minCnt = bestCnt;
            //这个return放在里面97%
            return;
        }
        //本来应该放在这里 94%
    }
    if(idx==0)return;
    for(int i = amount/coins[idx];i>=0;i--){
        int leftA = amount - i*coins[idx];
        int useCnt = count+i;
        int nextCoin = coins[idx-1];
        //保证只要left>0都还需要至少1枚硬币
        //或者简单一点if(useCnt+1>minCount)break; 98%
        if(useCnt+(leftA+nextCoin-1)/nextCoin>=minCount)break;
        dfs(leftA,idx-1,coins,useCnt);
    }
}
```

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

### 45 jump game最少跳跃次数

### 754 向左向右走1-n步到达target，求最小n
{% note %}
Input: target = 3
Output: 2
Explanation:
On the first move we step from 0 to 1.
On the second step we step from 1 to 3.
{% endnote %}
10^9的题一般是logn或者sqrt的问题
思路：相等于1..n中间放正负号等于target
如果1..n=target+d 
d是偶数很重要，因为改变一个数的符号会导致sum-2x

target=11
1+2+3+4+5 =15 (dif=4) 翻转2的符号ok
target=12
dif=3 +6 dif=9 +7 dif=16->凑一个8(1+3+4)//奇偶性??
```java
public int reachNumber(int target) {
        target = Math.abs(target);
        int sum = 0;
        int cnt = 1;
        while (target>sum || (target-sum)%2!=0){
            sum+=cnt;
            cnt++;
          //  System.out.println(cnt+" "+sum);

        }
        return cnt-1;
    }
}
```


### 673 最长递增子序列的个数
{% note %}
Input: [1,3,5,4,7]
Output: 2
Explanation: The two longest increasing subsequence are [1, 3, 4, 7] and [1, 3, 5, 7].
{% endnote %}
思路：cnt[j]记录以j结尾最大长度的个数，
如果dp[i]==dp[j]+1就表示之前cnt[j]个结尾的+1都可以变成dp[i]长度，
如果当前`dp[i]<dp[j]+1`表示找到了一条更长的，个数是cnt[j]条

```java
public int findNumberOfLIS(int[] nums) {
    int n = nums.length;
    if(n==0)return 0;
    int[] cnt = new int[n];
    int[] dp = new int[n];
    Arrays.fill(dp,1);
    Arrays.fill(cnt,1);
    int rst = 0;
    int max = 1;     
    for(int i = 1;i<n;i++){
        for(int j = 0;j<i;j++){
            if(nums[i]>nums[j]){       
                if(dp[j]+1==dp[i]){
                     cnt[i] += cnt[j];
                }else if(dp[j]+1>dp[i]){
                     cnt[i] = cnt[j];
                }   
                dp[i] = Math.max(dp[i],dp[j]+1);
                max = Math.max(dp[i],max);
            }                
        }
    }
    for(int i = 0;i<n;i++){
        if(dp[i] == max){
            rst += cnt[i];
        }
    }  
    return rst;
}
```

### 223 矩形重叠后的总面积
给出两个矩形的左下角 右上角坐标
{% note %}
输入: -3, 0, 3, 4, 0, -1, 9, 2
输出: 45
{% endnote %}
思路： 计算重叠区域的长宽 注意int越界
```java
public int computeArea(int A, int B, int C, int D, int E, int F, int G, int H) {   int x = 0;
        if(Math.min(C,G)>Math.max(A,E)){
            x = Math.min(C,G)-Math.max(A,E);
        };
        int y = 0;
        if(Math.min(D,H)>Math.max(B,F)){
            y = Math.min(D,H)-Math.max(B,F);
        }
        return (int)((D-B)*(C-A)+(G-E)*(H-F) -x*y);
    }
```


### 836 矩形重叠
{% note %}
矩形以列表 [x1, y1, x2, y2] 的形式表示，其中 (x1, y1) 为左下角的坐标，(x2, y2) 是右上角的坐标。

如果相交的面积为正，则称两矩形重叠。需要明确的是，只在角或边接触的两个矩形不构成重叠。
输入：rec1 = [0,0,2,2], rec2 = [1,1,3,3]
输出：true
{% endnote %}
关键：rec2在rec1的上、下、左、右都只要和一个坐标比就可以了。
```java
class Solution {
    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {
        return !(rec1[2] <= rec2[0] ||   // left
                 rec1[3] <= rec2[1] ||   // bottom
                 rec1[0] >= rec2[2] ||   // right
                 rec1[1] >= rec2[3]);    // top
    }
}
```

```java
return rec1[0] < rec2[2] && rec2[0] < rec1[2] && rec1[1] < rec2[3] && rec2[1] < rec1[3];
```


### 230 二叉搜索树/BST第K小元素
{% note %}
输入: root = [3,1,4,null,2], k = 1
   3
  / \
 1   4
  \
   2
输出: 1
{% endnote %}
方法1：计算节点数 53%
```java
private int cntNodes(TreeNode root){
    if(root==null)return 0;
    return cntNodes(root.left)+cntNodes(root.right)+1;
}
//left = 2 k=1 
public int kthSmallest(TreeNode root, int k) {
    int left = cntNodes(root.left);
    if(left == k-1)return root.val;
    else if(left < k-1)return kthSmallest(root.right,k-1-left);
    else return kthSmallest(root.left,k);       
}
```

方法2：中序遍历第k步的时候100%
```java
int rst = -1;
int kk = 0;
public int kthSmallest(TreeNode root, int k) {
   kk = k;
   find(root);
   return rst;
}
private void find(TreeNode root){
    if(root.left!=null)find(root.left);
    kk--;
    if(kk==0){
        rst = root.val;
        return; 
    }
    if(root.right!=null)find(root.right);
}
```

方法3：用栈中序迭代54%
```java
public int kthSmallest(TreeNode root, int k) {
  Deque<TreeNode> stk = new ArrayDeque<>();
  while(root!=null){
    stk.push(root);
    root = root.left;
  }
  while(k>0){    
        TreeNode cur = stk.pop();
        k--;
        if(k==0)return cur.val;
        if(cur.right!=null){
            root = cur.right;
            while(root!=null){
            stk.push(root);
            root = root.left;
          }
        }       
    }
 return -1;
}
```


### 846 一手顺子
{% note %}
Input: hand = [1,2,3,6,2,3,4,7,8], W = 3
Output: true
Explanation: Alice's hand can be rearranged as [1,2,3],[2,3,4],[6,7,8].
{% endnote %}

```java
public boolean isNStraightHand(int[] hand, int W) {
    int[] cnt = new int[W];
    for(int v:hand){
        // 关键
        cnt[v%W]++;
    }
    for(int i = 1;i<W;i++){
        if(cnt[i]!=cnt[i-1])return false;
    }
    return true;
}
```


### 19删除倒数第k个结点
难点：
1如果要删除的是头节点 2快指针在null的时候相差n步正好是倒数第n个，所以要在前一个，在.next!=null的时候就要停止
```java
public ListNode removeNthFromEnd(ListNode head, int n) {
    ListNode p = head;
    ListNode pp = head;
    while(n-->0)p=p.next;
    //关键
    if(p==null)return head.next;
    //关键
    while(p.next!=null){
        p = p.next;
        pp = pp.next;
    }
    pp.next = pp.next.next;
    return head;
}
```

### 560 和为K的子数组个数 tc
{% note %}
输入:nums = [1,1,1], k = 2
输出: 2 , [1,1] 与 [1,1] 为两种不同的情况。
{% endnote %}




### 12整数转罗马
{% note %}
输入: 58
输出: "LVIII"
解释: L = 50, V = 5, III = 3.
{% endnote %}

```java
public String intToRoman(int num) {
   int[] nums = {1,4,5,9,10,40,50,90,100,400,500,900,1000};
    String[] rm = {"I","IV","V","IX","X","XL","L","XC","C","CD","D","CM","M"};
    StringBuilder sb = new StringBuilder();
    for(int i = rm.length-1;i>=0 && num>0;i--){
        while(num >= nums[i]){
            sb.append(rm[i]);
            num -= nums[i];
        }
    }
    return sb.toString();
}
```

### ！！！32 最长括号子串
{% note %}
输入: ")()())"
输出: 4
解释: 最长有效括号子串为 "()()"
{% endnote %}
```java
public int longestValidParentheses(String s) {
    Deque<Integer> stk =  new ArrayDeque<>();
    stk.push(-1);
    int n = s.length();
    int rst = 0;
    for(int i = 0;i < n;i++){
        if(s.charAt(i) == '('){
            stk.push(i);
        }else {
            stk.pop();
            if(stk.isEmpty()){
// 正确匹配串的左边一位可能是-1也可能是一个错误的右括号的位置
                stk.push(i);
            }else
// 每次正确的右括号 记录串长
            rst = Math.max(rst,i-stk.peek());
        }
    }
    return rst;
}
```

左右扫描两遍
```java
public int longestValidParentheses(String s) {
  int rst = 0;
    int left = 0;
    int right = 0;
    int n = s.length();
    for(int i = 0;i<n;i++){
        if(s.charAt(i)=='('){
            left++;
        }else if(s.charAt(i)==')'){
            right++;
        }
        if(left == right){
            rst = Math.max(rst,left*2);
        }
        else if(right > left){
            left = 0;
            right = 0;
        }
    }
    left = 0;
    right = 0;
     for(int i = n-1;i>=0;i--){
        if(s.charAt(i)=='('){
            left++;
        }else if(s.charAt(i)==')'){
            right++;
        }
        if(left == right)rst = Math.max(rst,left*2);
         //关键
        else if(left > right){
            left = 0;
            right = 0;
        }
    }
    return rst;
}
```

### 765 情侣牵手 aqy
{% note %}
输入: row = [0, 2, 1, 3]
输出: 1
解释: 我们只需要交换row[1]和row[2]的位置即可。
{% endnote %}
思路：贪心 每次取一对，遍历所有之后的，将匹配的换上来，再下一对

### 有趣的排序
任取数组中的一个数然后将它放置在数组的最后一个位置。
问最少操作多少次可以使得数组从小到大有序？
{% note %}
4
19 7 8 25
out:4
{% endnote %}
19 7 8 25
7 8 19 25
思路：统计有多少个不用移动位置
```java
int cnt = 0;
int[] arr2 = arr.clone();
Arrays.sort(arr2);
int p1 = 0;int p2 =0;
while(p1<n && p2<n){        
     if(arr[p1] == arr2[p2]){
        p1++;
        p2++;
        cnt++;
    }else p1++;
}
System.out.println(n-cnt);
```

#### hiho1892 S中字符可以移动首部，移动最少次数得到T
选定S中的一个字符Si，将Si移动到字符串首位。  
例如对于S="ABCD"，小Ho可以选择移动B从而得到新的S="BACD"；也可以选择移动C得到"CABD"；也可以选择移动D得到"DABC"。  
请你计算最少需要几次移动操作，可以使S变成T。
in:
ABCD  
DBAC
out:2

思路：T的最后一个字符找到S中的对应位置之后 也就是说 S这个位置之后的，都应该是被提到最前面去了。然后S和T 都向前一格是一样的子问题。
。
```java
public static int trans3(String s,String t){
    if(s.length() != t.length())return -1;
    int n = s.length();
    int[] scnt  = new int[256];
    int[] tcnt  = new int[256];
    for (int i = 0; i <n ; i++) {
        scnt[s.charAt(i)]++;
        tcnt[t.charAt(i)]++;
    }
    for (int i = 0; i <256 ; i++) {
        if(scnt[i]!=tcnt[i])return -1;
    }
    int tidx = n-1;
    int ans = 0;
    for (int i = n-1; i >=0 ; i--) {
        if(s.charAt(i) == t.charAt(tidx)){
            ans++;
            tidx--;
        }
    }
    return n-ans;
}
```


### 330 从1-n中选哪些数字可以求和得到1-n 贪心 tx
最少需要给nums加几个数字，使其能组成[1,n]之间的所有数字
{% note %}
输入: nums = [1,3], n = 6
输出: 1 
解释:
根据 nums 里现有的组合 [1], [3], [1,3]，可以得出 1, 3, 4。
现在如果我们将 2 添加到 nums 中， 组合变为: [1], [2], [3], [1,3], [2,3], [1,2,3]。
其和可以表示数字 1, 2, 3, 4, 5, 6，能够覆盖 [1, 6] 区间里所有的数。
所以我们最少需要添加一个数字。
{% endnote %}

思路：int miss = [1-n] 中不能表示的最小值, 
如果 现在能凑出1，遇到3 > miss 需要+miss这个数，不然凑不出 + 2，
当前miss是4，遇到3，则可以凑出[1-4+3), 思考原来可以用1，2凑出[1,2,3]，每个数字+3
注意：循环条件 miss<=n，不是数组，考虑空数组也应该++

```java
public int minPatches(int[] nums, int n) {
    long miss = 1;
    int len = nums.length;
    int idx = 0;
    int cnt = 0;
    while(miss <= n){
        //如果可以
        if(idx < len && nums[idx] <= miss){
            miss+= nums[idx];
            idx++;
        }else {
            cnt++;
            miss+=miss;
        }
    }
    return cnt;
}
```

### 805 能否将数组划分成均值相等的两个数组
第i个石头的位置是stones[i]，最大的位置和最小的位置是端点。
每次可以移动一个端点到一个非端点。
如果石子像 stones = [1,2,5] 这样，你将无法移动位于位置 5 
的端点石子，因为无论将它移动到任何位置（例如 0 或 3），该石子都仍然会是端点石子。
1,2,5->2,3,5->3,4,5
当无法移动时游戏结束。问最少结束游戏的步数和最大结束的步数。
{% note %}
输入：[7,4,9]
输出：[1,2]
解释：
我们可以移动一次，4 -> 8，游戏结束。
或者，我们可以移动两次 9 -> 5，4 -> 6，游戏结束。
{% endnote %}


### 688 马K步留在棋盘的概率
```java
 int[][]dirs = {{-1,2},{-2,1},{1,2},{2,1},{-1,-2},{-2,-1},{2,-1},{1,-2}};

public double knightProbability(int N, int K, int r, int c) {
    memo = new double[N][N][K+1];
    return dfs(N,r,c,K);
}
double[][][]memo;
double dfs(int N,int x,int y,int K){
    
    if(x>=N  || x<0 || y<0 ||y>=N){
        return 0;
    }
    if(memo[x][y][K] >0)return memo[x][y][K];
    if(K == 0){
        memo[x][y][K] = 1;
        return 1;
    }
    double rate = 0;
    for(int[] dir:dirs){
        rate += 0.125 * dfs(N,x+dir[0],y+dir[1],K-1);
    }
    memo[x][y][K] = rate;
    return rate; 
}
```

### 71 !!简化路径
{% note %}
输入："/a/./b/../../c/"
输出："/c"
{% endnote %}
```java
public String simplifyPath(String path) {
    String[] paths = path.split("/");
    Deque<String> stk = new ArrayDeque<>();
    for(String p :paths){
        p = p.replace("/","");
        if(p.equals("..") && !stk.isEmpty()){
            stk.pop();
        }
        if(!p.equals(".")&& !p.equals("")&&!p.equals("..")){
            stk.push(p);
        }
    }
    StringBuilder sb = new StringBuilder();
    while(!stk.isEmpty()){
        sb.insert(0,"/"+stk.pop());
    }
    if(sb.length()==0)return "/";
    return sb.toString();
}
```


### 135 Candy 分数发糖
你需要按照以下要求，帮助老师给这些孩子分发糖果：
每个孩子至少分配到 1 个糖果。
相邻的孩子中，评分高的孩子必须获得更多的糖果。
{% note %}
输入: [1,0,2]
输出: 5
解释: 你可以分别给这三个孩子分发 2、1、2 颗糖果。
{% endnote %}

https://leetcode.com/problems/candy/discuss/42774/Very-Simple-Java-Solution-with-detail-explanation

正常思路：计算递增序列的同时计算递减序列的长度，当递增or相等时，用求和公式结算递减序列长度。

思路：
1.从左向右扫，把所有上升序列设置成从1开始的递增糖数
2.从右向左扫，更新右边向左边的递增糖数。

相似题目： 32 最长匹配括号 

```java
 public int candy(int[] ratings) {
        int sum = 0;
        int n = ratings.length;
        int[] left = new int[n];
        Arrays.fill(left,1);
        int[] right = new int[n];
        Arrays.fill(right,1);
        for(int i = 1;i<n;i++){
            if(ratings[i]>ratings[i-1]){
                left[i] = left[i-1]+1;
            }        
            if(ratings[n-1-i] > ratings[n-i]){
                right[n-1-i] = right[n-i]+1;
            }
        }
        for(int i = 0;i<n;i++){
            sum += Math.max(left[i],right[i]);
        }
        return sum;
    }
```



## 问题很大

### 786 第 K 个最小的素数分数
{% note %}
输入: A = [1, 2, 3, 5], K = 3
输出: [2, 5]
解释:
已构造好的分数,排序后如下所示:
1/5, 1/3, 2/5, 1/2, 3/5, 2/3.
很明显第三个最小的分数是 2/5.
{% endnote %}
思路：
先把所有数字/最后一个数 1/5，2/5，3/5放进去？？？
排序方法：`p/q<x/y` <==> `py<xq`取k-1次，如果分母序号-1>分子，入堆
```java
public int[] kthSmallestPrimeFraction(int[] A, int K) {
    int n = A.length;
   //a[0]/a[1]<b[0]/b[0] -> a[0]b[1] - b
    PriorityQueue<int[]> pq = new PriorityQueue<>((a,b)->{
        return A[a[0]]*A[b[1]] - A[a[1]]*A[b[0]];
    });
    for (int i = 0; i <n-1 ; i++) {
        pq.add(new int[]{i,n-1});

    }
    while (--K >0){
        int[] p = pq.poll();
        if(--p[1]>p[0]){
            pq.add(p);
        }
    }
    return new int[]{A[pq.peek()[0]],A[pq.peek()[1]]};
}
```

二分查找
不是找k个而是找一个m，使比m小的正好有7个。
构建成 从左往右递减，从上下往下递增。确定一个m，从右上角向左向下。
可以用O(n)确定有多少个<=m.复杂度log(max)n
难点：二分搜索的精度A[i] will be between 1 and 30000.所以精度到1/30000
```
1/2 1/3 1/5
-   2/3 2/5
-   -   3/5
```
378 719



### 726 化学式中各原子的数量
{% note %}
输入: 
formula = "K4(ON(SO3)2)2"
输出: "K4N2O14S4"
解释: 
原子的数量是 {'K': 4, 'N': 2, 'O': 14, 'S': 4}。
{% endnote %}

### 460 LFU Cache cd tx 
最不经常使用LFU缓存。最近最少使用的将被删除
{% note %}
{% endnote %}
难点：put如何在O(1)找到访问频率最少的kv删掉，如果频次相同，把时间戳最远的删掉。
注意：每次get/put修改堆中元素的排序指标并堆不会自动重排，要删除再插入。并且注意用堆不是O（1）
正确做法：3个hashMap

### 394 字符串解码 hw aqy
{% note %}
```
s = "3[a]2[bc]", 返回 "aaabcbc".
s = "3[a2[c]]", 返回 "accaccacc".
s = "2[abc]3[cd]ef", 返回 "abcabccdcdcdef".
```
{% endnote %}
```java
public String decodeString(String s) {
    String res = "";
    Deque<Integer> nums = new ArrayDeque<>();
    Deque<String> strs = new ArrayDeque<>();
    int idx = 0;
    while(idx < s.length()){
        if(Character.isDigit(s.charAt(idx))){
            int tmp = 0;
            while (Character.isDigit(s.charAt(idx))){
                tmp = 10*tmp + (s.charAt(idx) - '0');
                idx++;
            }
            nums.push(tmp);
        }
        else if(s.charAt(idx) == '['){
            // 关键
            strs.push(res);
            res = "";
            idx ++;
        }
        else if(s.charAt(idx) == ']'){
            // res = c tmps = a num = 2 res = acc tmps="" res = acc*3
            StringBuilder tmps =new StringBuilder(strs.pop());
            int num = nums.pop();
            for (int i = 0; i <num ; i++) {
                //关键
                tmps.append(res);
            }
            // 关键
            res = tmps.toString();
            idx++;

        }else{
            res += s.charAt(idx++);
        }
    }
    return res;
}
```

### 664 奇怪的打印机wy
打印机每次只能打印同一个字符。
每次可以在任意起始和结束位置打印新字符，并且会覆盖掉原来已有的字符。
给定一个只包含小写英文字母的字符串，你的任务是计算这个打印机打印它需要的最少次数。
{% note %}
输入: "aba"
输出: 2
解释: 首先打印 "aaa" 然后在第二个位置打印 "b" 覆盖掉原来的字符 'a'。
{% endnote %}

```java
public int strangePrinter(String s) {
    int n = s.length();
    int[][] dp = new int[n][n];
    return dfs(s, 0, n-1, dp);   
}

private int dfs(String s, int i,int j,int[][] dp){
    if(i > j)return 0;
    if(dp[i][j] == 0){
        //最坏情况，后面的一个一个打
        dp[i][j] = dfs(s,i,j-1,dp)+1;
        for (int k = i; k < j; k++) {
            // 可以同时打印 k和j
            if(s.charAt(k) == s.charAt(j)){
                dp[i][j] = Math.min(dp[i][j],dfs(s,i,k,dp)+dfs(s,k+1,j-1,dp) );
            }

        }
    }
    return dp[i][j];
}
```

### 546 移除盒子 不会tc+cd
可以移除具有相同颜色的连续 k 个盒子（k >= 1），这样一轮之后你将得到 k*k 个积分。
{% note %}
```
Input:
[1, 3, 2, 2, 2, 3, 4, 3, 1]
Output:
23
Explanation:
[1, 3, 2, 2, 2, 3, 4, 3, 1] 
----> [1, 3, 3, 4, 3, 1] (3*3=9 points) 
----> [1, 3, 3, 3, 1] (1*1=1 points) 
----> [1, 1] (3*3=9 points) 
----> [] (2*2=4 points)
```
{% endnote %}
定义状态dp[i][j][k]表示j右边有k个和j一样的元素，可以消除掉j和k中间的其它元素一起消除这k+1个，得到的分数。
或者可以选择继续把ij区间拆分，

```java
public int removeBoxes(int[] boxes) {
    int n = boxes.length;
    int[][][] dp  = new int[101][101][101];
    return dfs(boxes, 0, n-1, 0, dp);
}
private int dfs(int[] boxes,int l,int r,int k,int[][][] dp){
    if(r<l)return 0;
    while (l<r && boxes[r-1] == boxes[r]){--r;++k;}
    if(dp[l][r][k] > 0)return dp[l][r][k];
    dp[l][r][k] = (1+k)*(1+k) + dfs(boxes, l, r-1, 0, dp);
    for (int i = l; i < r ; i++) {
        if(boxes[i] == boxes[r]){
            dp[l][r][k] = Math.max(dp[l][r][k], dfs(boxes,l,i,k+1,dp) +dfs(boxes,i+1,r-1,0,dp));
        }
    }
    return dp[l][r][k];
}
```

---
## 问题不大


### 33 !!旋转数组查找
{% note %}
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
{%endnote %}
关键：第一步分割：
mid>=最左，表示旋转点在mid右边，从左到mid是递增的，再考虑target在不在左侧>=left。
else 旋转点在左侧，
```java
public int search(int[] nums, int target) {
    int n = nums.length;
    if(n <1)return -1;
    int l = 0;
    int r = n-1;
    while(l<=r){
        int mid = l+(r-l)/2;
        if(nums[mid] == target)return mid;
        // 旋转点在中位数右侧
        if(nums[mid] >= nums[l]){
            if(target < nums[mid] && target >= nums[l]){
                r = mid-1;
            }else{
                l = mid+1;
            }
        }
        else {
            if(target >nums[mid] && target<= nums[r]){
                l = mid+1;
            }
            else r = mid-1;
        }
    }
     return -1;
}
```


### 93 分割IP地址
注意：3个点之后还是要判断长度和数量关系


### 53 最大子数组和
```java
public int maxSubArray(int[] nums) {
    int sum = 0;
    // 关键：测试用例[-1]
    int rst = nums[0];
    for(int num:nums){
        sum = Math.max(sum+num,num);
        rst = Math.max(sum,rst);
    }
    return rst;
}
```

### ！！42 雨水
{% note %}
Input: [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
{% endnote %}

思路：
1 一个格子的水有两个边界，
2 如果左边or右边有更低的，水都会流走，尽量从两边让墙越来越高
3 如果当前格子靠近低的那侧，这个格子没可能更大了，最多就是left-A[i]水量，可以继续考虑这个格子更里那个格子。

普通做法 栈
```java
public int trap(int[] height) {
   if(height==null)return 0;
   int n  = height.length;
   Deque<Integer> stk = new ArrayDeque<>();
   int idx = 0;
   int tmp = 0;
   int rst = 0;
   while(idx<n){
       // 关键，==的时候也入栈
       if(stk.isEmpty() || height[idx] <= height[stk.peek()]){
           stk.push(idx++);
        
       }else{
           int top = stk.pop();
           // 如果是递增的坡 1 2 3 没水
           if(stk.isEmpty())tmp=0;
           else{}
            // 关键
           tmp = (Math.min(height[idx],height[stk.peek()])-height[top])*(idx-stk.peek()-1);
            }
           rst += tmp;
           
       }
   }
   return rst;
```


正确做法：双指针
```java
public int trap(int[] A){
    int a=0;
    int b=A.length-1;
    int max=0;
    int leftmax=0;
    int rightmax=0;
    while(a<=b){
        leftmax=Math.max(leftmax,A[a]);
        rightmax=Math.max(rightmax,A[b]);
        if(leftmax<rightmax){
            max+=(leftmax-A[a]);
            a++;
        }
        else{
            max+=(rightmax-A[b]);
            b--;
        }
    }
    return max;
}
```

两个数组做法：left保存当前位置左边的max。right保存当前位置右边的max。
注意 第0位置没有left，left只要计算到n-2个元素
n-1没有right,只要计算到第1个元素
```java
public int trap(int[] height) {
  int n  = height.length;
  int[] left = new int[n];
  int[] right = new int[n];
  for(int i = 1;i<n;i++){
      left[i] = Math.max(left[i-1],height[i-1]);
  }
  for(int i = n-2;i>=0;i--){
      right[i] = Math.max(right[i+1],height[i+1]);
  }
    int rst = 0;
    for(int i = 0;i<n;i++){
        int tmp = Math.min(left[i],right[i]) - height[i];
        if(tmp >0)
        rst += tmp;
    }
    return rst;
}
```

### 2 链表数字相加
注意：p1,p2,p不要忘了前进。carry用除，值用取余。

### 3 ！无重复的最长子串
{% note %}
输入:abba
输出：2
{% endnote %}
注意：测试用例" "，注意last应该递增
```java
public int lengthOfLongestSubstring(String s) {
    Map<Character,Integer> map = new HashMap<>();
    int max = -1;
    int last = 0;
    for(int i = 0;i<s.length();i++){
        if(map.containsKey(s.charAt(i))){
            last = Math.max(last,map.get(s.charAt(i))+1);
        }
        map.put(s.charAt(i),i);
        // 注意为了统一 “ ” 这个测试用例必须+1
        max = Math.max(max,i-last+1);
    }
    return max==-1?s.length():max;
}
```

### 440 ！字典序的第k小 计数！
1-n的第k小
{% note %}
Input:
n: 13   k: 2
Output:
10
Explanation:
The lexicographical order is [1, 10, 11, 12, 13, 2, 3, 4, 5, 6, 7, 8, 9], so the second smallest number is 10.
{% endnote %}
dfs超时
思路：高效计算同层每个两个数字在树中的间隔，并递归计算每一层。字典序是10进制1层
例如n=100 1和2之间的距离gap ->[1-2)的距离1 + [10-20)的距离10 + [100 -100]的距离 1 =12 
（注意计数，右边界n2如果不在当前树n2-n1，如果n2>n ,右边界在这棵树中，这棵树中的节点数统计为n+1-n1。
利用gap前进，如果k>gap则说明在当前子树。当前树根下移。

```java
public int findKthNumber(int n, int k) {   
    int cur = 1;
    k--;
    while(k>0){
    int gap = getGap(n,cur,cur+1);
        if(k < gap){
            cur*=10;
            k--;
    
        }else{
            k -= gap;
            cur++;
        }
    }
    return cur;
}
private int getGap(int n,long n1,long n2){
    int gap = 0;
    while(n1 <= n){
        if(n2 >n){
            gap += n-n1+1;
        
        }else{
            gap += n2-n1;
        }
           n1 *=10;
           n2 *=10;
    }
    return gap;
}
```

### 826 安排工作以达到最大收益 wy
{% note %}
输入: difficulty = [2,4,6,8,10], profit = [10,20,30,40,50], worker = [4,5,6,7]
输出: 100 
解释: 工人被分配的工作难度是 [4,4,6,6] ，分别获得 [20,20,30,30] 的收益。
{% endnote %}
排序ac
```java
public int maxProfitAssignment(int[] difficulty, int[] profit, int[] worker) {
    List<Pair<Integer, Integer>> jobs = new ArrayList<>();
    int N = profit.length, res = 0, i = 0, maxp = 0;
    for (int j = 0; j < N; ++j) jobs.add(new Pair<Integer, Integer>(difficulty[j], profit[j]));
    Collections.sort(jobs, Comparator.comparing(Pair::getKey));
    Arrays.sort(worker);
    for (int ability : worker) {
        while (i < N && ability >= jobs.get(i).getKey())
            maxp = Math.max(jobs.get(i++).getValue(), maxp);
        res += maxp;
    }
    return res;
}
```

### 493 Reverse Pairs 逆序对的个数 cd
如果 i < j and nums[i] > 2*nums[j].算一个逆序对
{% note %}
Input: [1,3,2,3,1]
Output: 2
{% endnote %}

```java
public static int ret;
public static int reversePairs(int[] nums) {
    ret = 0;
    mergeSort(nums, 0, nums.length-1);
    return ret;
}

public static void mergeSort(int[] nums, int left, int right) {
    if (right <= left) {
        return;
    }
    int middle = left + (right - left)/2;
    mergeSort(nums, left, middle);
    mergeSort(nums,middle+1, right);
    //count elements
    int count = 0;
    for (int l = left, r = middle+1; l <= middle;) {
        if (r > right || (long)nums[l] <= 2*(long)nums[r]) {
            l++;
            ret += count;
        } else {
            r++;
            count++;
        }
    }
    //sort
    Arrays.sort(nums, left, right + 1);
}

```




### 718 !!最长公共子串 最长公共子数组
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



#### 386 字典序数字 
dfs 112ms 71%
```
   1        2        3    ...
  /\        /\       /\
10 ...19  20...29  30...39   ....
```

```java
public List<Integer> lexicalOrder(int n) {
     List<Integer> rst = new ArrayList<>();
    for (int i = 1; i < 10; i++) {
        dfs(rst,n,i);
    }
    return rst;
}
private void dfs(List<Integer> rst,int n,int cur){
    if(cur>n)return;
    else{
        rst.add(cur);
        for (int i = 0; i <10 ; i++) {
            if(cur*10+i>n)return;
            dfs(rst,n,10*cur+i);
        }
    }
}
```


相关：
permutation的字典序
思想：字典序全排列算法：保证尽可能长的前缀不变，后缀慢慢增加
 abc 保证前面不变，后面增加一点点 -> acb ，cb不能增大了，->bac
 从右向左扫描 例如 321 是递增的 表示不能再增加
 从右向左扫描到第一次增大的位置，和右边比较大的数交换。1 2 3 扫描到2，和3交换。
 1 3 2 扫描到1降了，1和2交换 2 3 1  31不是最小后缀 变成2 1 3 

算法：
![lexpermu.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/lexpermu.jpg)
 1.从右想左 找到第一次下降位置
 2.用后缀中比当前位置大的最小数字交换
 3.保证后缀最小（翻转？）

###  4位25个字符的编码
假定一种编码的编码范围是a ~ y的25个字母，从1位到4位的编码，如果我们把该编码按字典序排序，形成一个数组如下： a, aa, aaa, aaaa, aaab, aaac, … …, b, ba, baa, baaa, baab, baac … …, yyyw, yyyx, yyyy 其中a的Index为0，aa的Index为1，aaa的Index为2，以此类推。 编写一个函数，输入是任意一个编码，输出这个编码对应的Index.

输入：baca
输出：16331

a开头的长度为4的编码一共有25^3个，长度为3有25^2个，长度为2有25个，长度为1有1个。
例：bcd
第一位是b所以处在第二大块，result += 1 \*  (25^3+25^2+25+1) 
第二位是c， result += 2 \*（25^2+25+1）+1
第三位是d， result += 3\* （25+1）+1  （加一是因为最前面有个空）
第四位是空，不管，因为空就是第一个
result = 17658

```java
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    String str = sc.next();
    int n = str.length();
    int rst = 0;
    if(n>0)
        rst += (str.charAt(0)-'a')*(25*25*25+25*25+25+1);
    if(n>1)
        rst += (str.charAt(1)-'a')*(25*25+25+1)+1;
    if(n>2)
        rst += (str.charAt(2)-'a')*(25+1)+1;
    if(n>3)
        rst += (str.charAt(3)-'a')+1;
    System.out.println(rst);
}
```

---
## 没有问题
### 1014 最佳观光组合
一对景点（i < j）组成的观光组合的得分为（A[i] + A[j] + i - j）
{% note %}
输入：[8,1,5,2,6]
输出：11
解释：i = 0, j = 2, A[i] + A[j] + i - j = 8 + 5 + 0 - 2 = 11
{% endnote %}
```java
public int maxScoreSightseeingPair(int[] A) {
    int n = A.length;
    int[] score = new int[n];
    score[0] = A[0];
    int rst = 0;
    for(int i = 1;i<n;i++){
        rst = Math.max(rst,A[i]+score[i-1]-i);
        score[i-1] =Math.max(socre[i-1],A[i]+i);
    }
    return rst;
}
```