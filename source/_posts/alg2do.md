---
title: ToDoAgain
date: 2018-09-03 14:44:31
tags:
categories: [算法备忘]
---
### 37 数独
```java
public void solveSudoku(char[][] board){
    if(board == null || board.length == 0)
        return;
    solve(board);
}
private boolean solve(char[][] board){
    for (int i = 0; i < board.length; i++) {
        for (int j = 0; j < board[0].length ; j++) {
            if(board[i][j] == '.'){
                for(char c = '1';c<='9';c++){
                    if(isValid(board,i,j,c)){
                        board[i][j] = c;
                        if(solve(board))return true;
                        else board[i][j] = '.';
                    }
                }
                return false;
            }
        }
    }
    return true;
}

private boolean isValid(char[][] board,int row,int col,char c){
    for (int i = 0; i <9 ; i++) {
        if(board[i][col] == c)return false;
        if(board[row][i] == c)return false;
        if(board[3*(row/3) + i/3][3*(col/3)+i%3]==c)return false;
    }
    return true;
}
```

### 239 滑动窗口最大值 不会x4
{% note %}
```
Input: nums = [1,3,-1,-3,5,3,6,7], and k = 3
Output: [3,3,5,5,6,7] 
Explanation: 

Window position                Max
---------------               -----
[1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
```
{% endnote %}
思路1：左右扫描：把数组按k划分
A = [2,1,3,4,6,3,8,9,10,12,56], w=4
2, 1, 3, 4 | 6, 3, 8, 9 | 10, 12, 56| 最后一组可能不足k个
left_max[] = 2, 2, 3, 4 | 6, 6, 8, 9 | 10, 12, 56
right_max[] = 4, 4, 4, 4 | 9, 9, 9, 9 | 56, 56, 56
sliding-max(i) = max{right_max(i), left_max(i+w-1)}
sliding_max = 4, 6, 6, 8, 9, 10, 12, 56

---

### 138
https://leetcode.com/problems/copy-list-with-random-pointer/solution/

### poj3617构造最小字典序

```java
/**
 * 不断取Min(S头/尾)放到T末尾
 * 相等：判断下一个字符希望先用到小的字符
 * 可以的操作：
 * 从S头删除一个加到T尾
 * 从S尾删除一个加到T尾
 *
 * @param S ACDBCB
 * @return 构造字典序尽可能小的字符串T ABCBCD
 */
public static String BestCowLine(String S){
      int a = 0,b = S.length()-1;
      StringBuilder sb = new StringBuilder();
      while (a<=b){
          //关键
          boolean left = false;
          //a+i<b关键
          for (int i = 0; a+i <= b ; i++) {
              if(S.charAt(a+i)<S.charAt(b-i)){
                  left = true;
                  break;
              }else if(S.charAt(a+i)>S.charAt(b-i)){
                  left = false;
                  break;
              }
          }
          if(left)sb.append(S.charAt(a++));
          else sb.append(S.charAt(b--));
      }
      return sb.toString();
  }
```


### 818 A加速，R掉头并减速，到指定位置最少需要多少条指令
>当车得到指令 "A" 时, 将会做出以下操作： position += speed, speed *= 2。

>当车得到指令 "R" 时, 将会做出以下操作：如果当前速度是正数，则将车速调整为 speed = -1 ；否则将车速调整为 speed = 1。  (当前所处位置不变。)

例如，当得到一系列指令 "AAR" 后, 你的车将会走过位置 0->1->3->3，并且速度变化为 1->2->4->-1。

>输入: 
target = 3
输出: 2
解释: 
最短指令列表为 "AA"
位置变化为 0->1->3




### 464 博弈
A,B玩家轮流从1-10中选数组加到同一个total，让total先大于11的赢.B肯定赢。
1.计算1-n个数的permutation，并判断每个赢的可能性复杂度(n!)
2.因为1,2...和2,1...是一样的，所以可以降为$2^n$
状态压缩

1. 子状态，m个数state[m+1]表示visited
2. 记忆化递归key是子状态，`Arrays.toString(state)`
3. 遍历state中还是0的没选的数，
    如果d-i选这个数赢了或者另一个人递归d-i的子问题不能赢，
    更新map中这个state为true，可以先state[i]=0回溯return true到之前的选择(上一层递归)
    ```java
    if(d-i<0||!canwin(d-i,hmap)){
        hmap.put(key,true);
        state[i]=0;
        return true;
    }
    ```
    如果对方赢了，不选这个state[i]=0，继续尝试循环中其它state
   如果所有的state都试过了也不行，说明当前子问题
   `hamp.put(key,false)`,`return false`

优化19ms：用二进制存一个int表示状态 用`byte[i<<M+1]`记忆化
```java
int byte[] m_;
m = new byte[1<<M+1];
```
遍历M个数
```java
if(state&(1<<i)>0)continue;
if(!canwin(d-i,state|(1<<i))){
    m_[state]=1;
    return true;
}
```
出循环，表示这个状态不行
```java
m_[state]=-1;
return false;
```
- 优化2：如果用byte[1<<M] 遍历0~M ,`canwin(d-i+1,state|(1<<i))`只需要15ms

1左移i位`int mask=1<<i`表示选这个数的状态
如果`(mask&visited)==0`表示没使用过这个数
另一个玩家能不能赢的state：`mask|visited` 在visited（上一个状态）的基础将i位也置1

---


### 486 两个人只能从list的两端取数，预测最后谁摸到的点数sum高
https://leetcode.com/problems/predict-the-winner/solution/
{3，9，1，2}
1. 二维数组dp：`[i][j]`只用右上三角表示两个人都从list取1个数，2个数，3个数到list长能获得的最大差值
1. 填对角线，如果两个人只剩下一个数为3：{A取3，B取0}，剩下9：{A取9，B取0}...
2. 如果剩下2个数，剩下{3,9}`[1][2]`：{A取9，B剩下{3}回到1的情况}...
3. 如果剩下3个数，剩下{3,9,1}`[1][3]`:{A取3,B剩下{9,1}即表格`[2][3]`的情况}
4. 剩下4个数，填`[1][4]`即为答案

递归：但是会有很多重复计算复杂度$2^n$
比如让对手选[3,9,1]后，自己选[9,1]和[3,9]/让对手选[9,1,2]后，自己选[9,1]和[1,2]
[9,1]被计算了两次。可以进行存储
```java
//最大的分数差
int dif(int[] nums,int left,int right){
    //如果长度为1，获得的差值就是这个数
    if(left==right)return nums[left];
    //选一个数之后 交给对手用相同策略选
    return max(nums[left]-dif(nums,left+1,right),nums[right]-dif(nums,left,right+1));
}
```
用一维数组存储key是`left*len+right`
{% fold %}
```java
int[] m;
int len =0;
public boolean PredictTheWinner(int[] nums) {
    this.len = nums.length;
    if(len==1)return true;
    this.m= new int[len*len];
  return help(nums,0,len-1)>=0;
}
private int help(int[] nums,int l,int r){
    if(l==r)return nums[l];
    int index = l*len+r;
    if(m[index]>0)return m[index];
    m[index]=Math.max(nums[l]-help(nums,l+1,r),nums[r]-help(nums,l,r-1));
    return m[index];
}
```
{% endfold %}

#### lt 1470 
> 1号玩家先取。问最后谁将获胜。 他们只能从数组的两头进行取数，且一次只能取一个。
> 若1号玩家必胜或两人打成平局，返回1，若2号玩家必胜，返回2。
> 如果数组长度是偶数 先手必胜只要return 1就行了

```java
public int theGameOfTakeNumbers(int[] arr) {
   if(dif(arr,0,arr.length-1)>=0)return 1;
   else return 2;
}
private int dif(int[] nums,int left,int right){
    if(left<right)return 0;
    if(left==right)return nums[left];
    return Math.max(nums[left]-dif(nums,left+1,right),nums[right]-dif(nums,left,right-1));
}
```

#### lc 877
> 偶数堆石子排成一行，每堆都有正整数颗石子 piles[i] 
> 输入： [5,3,4,5]

先手可以拿1+3 或者2+4 对手反之拿2+4或者1+3，所以先手选大的那个肯定赢。
递归同上 77% 
可以加一个`memo[l][r]` 从2^n->n^2 因为l和r一共有n^2个子问题

dp ：
```java
public boolean stoneGame(int[] piles) {
    int n = piles.length;
    int[][] dp = new int[n][n];
    //left=i,right=i的子问题
    for (int i = 0; i <n ; i++) {
        dp[i][i] = piles[i];
    }
    //长度为[2,n]的子问题
    for (int i = 2; i <=n ; i++) {
        for (int l = 0; l <n-i+1 ; l++) {
            int r = i+l-1;
            //[l+1][r]的长度比[l][r]小 已经计算过了
            dp[l][r] = Math.max(piles[l]-dp[l+1][r],piles[r]-dp[l][r-1]);
        }
    }
    return dp[0][n-1]>0;
}
```
子问题是 长度-1的dp 降维
```java
public boolean stoneGameDP1D(int[] piles) {
    int n  = piles.length;
    int[] dp = piles.clone();
    for (int i = 2; i <=n ; i++) {
        for (int l = 0; l<n-i+1 ; l++) {
            //dp[i] 还没有更新,都是长度i-1的值
            dp[i] = Math.max(piles[l]-dp[i+1],piles[l+i-1]-dp[i] );
        }
    }
    return dp[0]>0;
}
```

### ??Convert BST to Greater Tree
[17ms 66% Reverse Morris In-order Traversal](https://leetcode.com/problems/convert-bst-to-greater-tree/solution/)
{% fold %}
```java
 public TreeNode convertBST(TreeNode root) {
     int sum = 0;
     TreeNode cur = root;
     while(cur!=null){
         //最右 
         if(cur.right==null){
             sum+=cur.val;
             cur.val=sum;
             cur=cur.left;
         }else{
             //找前继，键link
             TreeNode pre = cur.right;
             //一直向左
             while(pre.left!=null&&pre.left!=cur){
                 pre=pre.left;
             }
            //找到了pre 联立链接
             if(pre.left== null){
                pre.left = cur;
                cur=cur.right;
             }
             //右边没了，并且左连接向上
             else{
                 pre.left=null;
                 sum+=cur.val;
                 cur.val= sum;
                 cur=cur.left;           
             }
         }
         
     }
        return root;
    }
```
{% endfold %}

正常做法递归中序 15ms 99%
```java
public TreeNode convertBST(TreeNode root) {
if(root==null)return root;
convertBST(root.right);
sum+=root.val;
root.val=sum;
convertBST(root.left);
return root;
}
```


### lc393 判断合法UTF8编码

### 287 数组中重复元素


### 网络流
https://algs4.cs.princeton.edu/64maxflow/
https://www.geeksforgeeks.org/minimum-cut-in-a-directed-graph/
1. 最小割 st-cut 去掉这几条边，源点S和终点T就会被分为两个不相交的set，S到不了T。这种边集的最小值
断掉两点间的通信的最小代价。
2. 最大流max-flow 边的流量小于capacity。每个点的入流和出流相等。除了源点S和终点T。求源点/终点能发出/接收的最大值。

其实可以是一个问题。

#### Ford-fulkerson算法
1 先假设每条边的当前流量是0/capacity
2 找到S到T的路径，并最大化这条路径上的空的边的当前流量 
3 继续找路径，如果可以通过一条边的反向到达T，经过的是一条边的反向流，则减少这条边逆向流过去。
4 每条边到达正向包和或者负向为0 不能remove from backward edge

#### flow value lemma :最小cut上的流量 == 最大网络流
flow <= capacity of cut
max flw == min cut

#### 已知最大流(cur/capacity) 求cut
从S点 正向走最不满的正向流。走最满的逆向流，满正向流和空逆向流当作不存在。

#### 如何找augmenting path BFS
如果容量都是integer
number of augemntation <= maxflow value 每次增加至少1

查找
![trie.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/trie.jpg)
插入
![tirinsert.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/tirinsert.jpg)

---

### 786 数组中可能组成的分数排序后第k大的是哪个组合
数组长度2000 n^2的算法是超时
> A = [1, 2, 3, 5], K = 3
> Output: [2, 5]
Explanation:
The fractions to be considered in sorted order are:
1/5, 1/3, 2/5, 1/2, 3/5, 2/3.
The third fraction is 2/5.

`M[i][j]=A[i]/A[j]`肯定在右上角最小
```
1/2 1/3 1/5 
-   2/3 2/5
-   -   3/5
```
1 查比0.5小有1/2,1/3,2/5 大于3个 r =0.5
2 查比0.25小的有1/5 l=0.25
3 查比0.375小的有1/3,1/5 l=0.375
4 查比0.475小的正好3个



### ！？？？95 输出全部不同的BST
[1~n]组成的BST
```
1.......k...n
       / \
[1~k-1]  [k+1,n] 与上一层的构建过程是一样的
```



### 287 数组中只有1个重复元素 返回元素

> containing n + 1 integers where each integer is between 1 and n (inclusive)

不用set，空间降为O(1)
将数组的数字想象成链表，找环
> 1 4 6 6 6 2 3

慢指针走`num[slow]`
快指针走`num[num[fast]]`

慢指针会在环与head指针相遇
```java
public int findDuplicate(int[] nums) {
// use only constant, O(1) extra space
    int slow = nums[0];
    int fast = nums[0];
    do{
        slow = nums[slow];
        fast =  nums[nums[fast]];
    }while(slow != fast);
    
    int head = nums[0];
    while(head!=slow){
        head= nums[head];
        slow = nums[slow];
    }
    return head;
}
```




### lt848 加油站之间的最小距离


### 719
>输入：
nums = [1,3,1]
k = 1
输出：0 
解释：
所有数对如下：
(1,3) -> 2
(1,1) -> 0
(3,1) -> 2
因此第 1 个最小距离的数对是 (1,1)，它们之间的距离为 0。

方法2：二分查找，找到最小的距离m，至少有k个pair距离<=m。


方法1：350ms排序后找到max，建立max+1个桶对diff计数，最后遍历桶到k<=0
```java
public int smallestDistancePair(int[] nums, int k) {
    int n = nums.length;
        Arrays.sort(nums);
        int max = nums[nums.length - 1];
        int[] bucket = new int[max+1];
        for(int i =0;i<n-1;i++){
            for(int j = i+1;j<n;j++){
                int idx = nums[j]-nums[i];
                bucket[idx]++;
            }
        }
        for(int i =0;i<bucket.length;i++){
            k -=bucket[i];
            if(k<=0){
                return i;
            }
        }
        return -1;
    }
```





### 5只猴子分桃，每次拿走一个正好分成5堆，问桃子数



### ！！687树中值相等的点的路径长



### 438 Anagrams in a String 滑动窗口`Arryas.equals`
> Anagrams 字母相同，顺序不同的单词 连续
> s: "cbaebabacd" p: "abc" 
> Output:[0, 6] 输出起始位置

[Sliding Window algorithm](https://leetcode.com/problems/find-all-anagrams-in-a-string/discuss/92007/Sliding-Window-algorithm-template-to-solve-all-the-Leetcode-substring-search-problem.)
![anagram.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/anagram.jpg)
![anagram2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/anagram2.jpg)
16ms 50%
```java
public List<Integer> findAnagrams(String s, String p) {
    List<Integer> rst = new ArrayList<>();
    int[] ch = new int[26];
    int wcn = p.length();
    for(char c:p.toCharArray()){
        ch[c-'a']++;
    }
    int[] window = new int[26];
    for (int i = 0; i <s.length() ; i++) {
        if(i>=wcn){
            --window[s.charAt(i-wcn)-'a'];
        }
        window[s.charAt(i)-'a']++;
        if(Arrays.equals(window, ch)){
            rst.add(i-wcn+1);
        }
    }
    return rst;
}
```





#### 回文树
`next[i][c]` 编号为i的节点表示的回文串两边添加c后变成的回文串编号。
`fail[i]`节点i失配后
`cnt[i]`

### K-D tree

### 快速排序的各种优化
https://algs4.cs.princeton.edu/23quicksort/



### 106 中序+后序建树



### ？？？有100个帽子，每个人有几顶，问每个人戴出来都不一样有多少种






### 15 3sum=0 荷兰国旗写法3指针
1p：从0~len-2，3个数的和 右边至少留两个数 sum=0-nums[i]转化成2sum问题
去重：当num[i]=num[i-1]:continue
另外两个指针从1p往后从len-1往前。
去重：预判：nums[low]=nums[low+1]:low++;nums[high]=nums[high-1]:high--;

### poj2406 字符串周期 power string
https://my.oschina.net/hosee/blog/661974
http://poj.org/problem?id=2406
abcd 1
aaaa 4
ababab 3

### 459 判断字符串有重复模式 KMP
kmp89% todo


### !!!3 连续最长不重复子序列

32%
用set维护一个`[i,j)`窗口，不重复则窗口向右扩展，重复则窗口右移。
```java
public int lengthOfLongestSubstring(String s){
    int n = s.length();
    Set<Character> set = new HashSet<>();
    int ans = 0,i=0,j=0;
    while(i<n&&j<n){
        if(!set.contains(s.charAt(j))){
            set.add(s.charAt(j++));
            ans = Math.max(ans,j-i);
        }
        else set.remove(s.charAt(i++));
    }  
    return ans;
}
```
优化： todo
`int[26]` for Letters 'a' - 'z' or 'A' - 'Z'
`int[128]` for ASCII
`int[256]` for Extended ASCII

### 659 数组

### 413 数组划分 能组成的等差数列个数
> A = [1, 2, 3, 4]
> 返回: 3, A 中有三个子等差数组: [1, 2, 3], [2, 3, 4] 以及自身 [1, 2, 3, 4]。

### 725链表划分成k份子集

### lt886 判断凸包
https://www.lintcode.com/problem/convex-polygon/description




### ！30 字典中单词连续出现在字符串中的位置 AC自动机（？
加入字典的常用写法`dict.put(word,dict.getOrDefault(word,0)+1)`
{% fold %}
```java
class Solution {
public List<Integer> findSubstring(String s, String[] words) {
    List<Integer> res = new ArrayList<Integer>();
    int n = s.length(), m = words.length, k;
    if (n == 0 || m == 0 || (k = words[0].length()) == 0)
        return res;

    HashMap<String, Integer> wDict = new HashMap<String, Integer>();

    for (String word : words) {
        if (wDict.containsKey(word))
            wDict.put(word, wDict.get(word) + 1);
        else
            wDict.put(word, 1);
    }

    int i, j, start, x, wordsLen = m * k;
    HashMap<String, Integer> curDict = new HashMap<String, Integer>();
    String test, temp;
    for (i = 0; i < k; i++) {
        curDict.clear();
        start = i;
        if (start + wordsLen > n)
            return res;
        for (j = i; j + k <= n; j += k) {
            test = s.substring(j, j + k);

            if (wDict.containsKey(test)) {
                if (!curDict.containsKey(test)) {
                    curDict.put(test, 1);

                    start = checkFound(res, start, wordsLen, j, k, curDict, s);
                    continue;
                }

                // curDict.containsKey(test)
                x = curDict.get(test);
                if (x < wDict.get(test)) {
                    curDict.put(test, x + 1);

                    start = checkFound(res, start, wordsLen, j, k, curDict, s);
                    continue;
                }

                // curDict.get(test)==wDict.get(test), slide start to
                // the next word of the first same word as test
                while (!(temp = s.substring(start, start + k)).equals(test)) {
                    decreaseCount(curDict, temp);
                    start += k;
                }
                start += k;
                if (start + wordsLen > n)
                    break;
                continue;
            }

            // totally failed up to index j+k, slide start and reset all
            start = j + k;
            if (start + wordsLen > n)
                break;
            curDict.clear();
        }
    }
    return res;
}

public int checkFound(List<Integer> res, int start, int wordsLen, int j, int k,
        HashMap<String, Integer> curDict, String s) {
    if (start + wordsLen == j + k) {
        res.add(start);
        // slide start to the next word
        decreaseCount(curDict, s.substring(start, start + k));
        return start + k;
    }
    return start;
}

public void decreaseCount(HashMap<String, Integer> curDict, String key) {
    // remove key if curDict.get(key)==1, otherwise decrease it by 1
    int x = curDict.get(key);
    if (x == 1)
        curDict.remove(key);
    else
        curDict.put(key, x - 1);
}
}
```
{% endfold %}



---
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

### 45 ??????jump game最少跳跃次数
超时递归（？
递归终止条件是from==end，如果有0不可达
{% fold %}
```java
public int minJumpRecur(int[] arr){
    int n = arr.length;
    memo = new int[n][n];
    return jump(arr, 0, n-1);
}
int[][] memo;
private int jump(int[] steps,int from,int end){
//        System.out.println(from+" "+end);
    if(from==end)return 0;
    //不可达
    if(memo[from][end]!=0)return memo[from][end];
    if(steps[from]==0)return Integer.MAX_VALUE;
    int min = Integer.MAX_VALUE;
    //当前可以到达的范围是[from,from+step[from]]
    for(int i = from+1;i<=end&&i<=from+steps[from];i++){
        int jumps = jump(steps,i , end);
        if(jumps!=Integer.MAX_VALUE&&jumps+1<min){
            min = jumps+1;
            memo[from][end] = min;
        }
    }
    return min;
}
```
{% endfold %}
1.在本次可跳跃的长度范围内如果不能达到len-1则表示一定要跳跃//不懂
```java
public int jump(int[] nums) {
    if(nums==null||nums.length<2)return 0;
    int res = 0;
    int curMax = 0;
    int maxNext = 0;
    //i=0,max = 2 i==cur ->res++,cur = max=2
    //i=1,max = max(2,4)=4, i!=cur
    //i=2,max = max(4,3)=4, i==cur res++,cur = max=4
    //i=3,max = max(4,4)=4, i!=cur break
    //不需要走到i=4,max = max(4,4+4)=8,i==cur res++,cur=max
    for (int i = 0; i < nums.length-1; i++) {
        maxNext = Math.max(maxNext,i+nums[i] );
        if(i==curMax){
          res++;
          curMax = maxNext;
        }
    }
    return res;
}
```
2.!!!BFS
```java
public int jumpBFS(int[] nums){
    if(nums==null||nums.length<2)return 0;
    int level = 0;
    int cur = 0;
    int max =0;
    int i =0;
    //cur-i+1=1,level++; i<=cur,i++,max = 2;cur = 2;
    //cur=2,i=1;level++; i<=2,i++,max = 4,max>=n-1 return 2;
    while (cur-i+1>0){
        level++;
        for(;i<=cur;i++){
            max = Math.max(max,nums[i]+i);
            if(max>=nums.length-1)return level;
        }
        cur = max;
    }
    return 0;
}
```

