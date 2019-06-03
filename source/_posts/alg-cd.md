---
title: 国内公司面试高频题
date: 2019-05-29 20:39:39
tags: [alg]
categories: [算法备忘]
---
### 726 化学式中各原子的数量
{% note %}
输入: 
formula = "K4(ON(SO3)2)2"
输出: "K4N2O14S4"
解释: 
原子的数量是 {'K': 4, 'N': 2, 'O': 14, 'S': 4}。
{% endnote %}

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

### 460 LFU Cache cd tx 
最不经常使用LFU缓存。最近最少使用的将被删除
{% note %}
{% endnote %}
难点：put如何在O(1)找到访问频率最少的kv删掉，如果频次相同，把时间戳最远的删掉。
注意：每次get/put修改堆中元素的排序指标并堆不会自动重排，要删除再插入。并且注意用堆不是O（1）
正确做法：3个hashMap


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



### 386 字典序数字 todo
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
