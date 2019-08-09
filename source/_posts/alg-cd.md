---
title: 面试高频题
date: 2019-05-29 20:39:39
tags: [alg]
categories: [算法备忘]
---
https://corvo.myseu.cn/2018/02/01/2018-02-01-%E9%9D%A2%E8%AF%95%E6%99%BA%E5%8A%9B%E9%A2%98%E7%9B%AE/

### 相同URL
十亿=1G
a,b两个文件各有50亿Url，url64字节，4G内存找相同url
1.估算一个文件320G
2.遍历文件a用hash函数把文件拆成500-1000个，每个320-640M 如果hash不均匀继续hash
3.同样拆分b文件
4.相同的url一定在相同的hash文件序号里，已经可以读入内存了。

### 高频词
1G大小文件，每个词16字节，内存1M，最高频100个词


### ！974 和整除k的子数组个数
{% note %}
Input: A = [4,5,0,-2,-3,1], K = 5
Output: 7
Explanation: There are 7 subarrays with a sum divisible by K = 5:
`[4, 5, 0, -2, -3, 1], [5], [5, 0], [5, 0, -2, -3], [0], [0, -2, -3], [-2, -3]`
{% endnote %}

1)用前缀和可以快速得到区间和
`P = [0,4,9,9,7,4,5]`,
2）如果`(sums[i] - sums[j]) % K == 0`，说明sums[i]和sums[j]都是K的倍数，所以得出sums[i] % K == sums[j] % K
例如：%K ==0的位置 [0]和[6] 得到子数组`[4, 5, 0, -2, -3, 1]`
同余的如果有4个，两两组合的位置数有C(4,2)=6

注意：presum为负数的时候，取模应该`(p % K + K) % K`
-1 % 5 = -1, but we need the positive mod 4
例如presum[1] = -1  presum[4] = 4
```java
public int subarraysDivByK(int[] A, int K) {
    int n = A.length;
    int rst = 0;
    int[] presum = new int[n+1];
    //[1]-[0] = pre[0:1)
    for(int i =0;i<n;i++){
        presum[i+1] = presum[i]+A[i];
    }
    int[] mod = new int[K];
    for(int p:presum){
        mod[((p%K)+K)%K]++;
    }
    for(int c:mod){
        rst += (c*(c-1))/2;
    }
    return rst;
}
```

### 670 最大交换 交换数字中两位得到的最大值
{% note %}
输入: 2736
输出: 7236
解释: 交换数字2和数字7。
{% endnote %}
预处理一遍记录0-9每个数字最后出现的位置
从左到右遍历每个数字，查9-0位置在这个数字之后的数字，return交换 


### 516 最长回文子序列
```java
public static int longestPalindromeSubseq(String s) {
    int[][] dp = new int[s.length()][s.length()];

    for (int i = s.length() - 1; i >= 0; i--) {
        dp[i][i] = 1;
        for (int j = i+1; j < s.length(); j++) {
            if (s.charAt(i) == s.charAt(j)) {
                dp[i][j] = dp[i+1][j-1] + 2;
            } else {
                dp[i][j] = Math.max(dp[i+1][j], dp[i][j-1]);
            }
        }
    }
    return dp[0][s.length()-1];
}
```

### 非递归全排列
```java
List<List<Integer>> permute(int[]num){
   List<List<Integer>> rst = new LinkedList<>();
    rst.add(new LinkedList<>());
    for(int n:num){
        int size = rst.size();
        while (size-->0){
            List<Integer> tmp = rst.get(0);
            rst.remove(0);
            for (int i = 0; i <=tmp.size() ; i++) {
                List<Integer> t = new LinkedList<>(tmp);
                t.add(i,n);
                rst.add(t);
            }
        }
    }
    return rst;
}
```

### 快速排序非递归
```java
private  void quicksort(int[] arr,int left,int right){
    Deque<Integer> stk = new ArrayDeque<>();
    if (left<=right){
        stk.push(right);
        stk.push(left);
        while (!stk.isEmpty()) {
            int l = stk.pop();
            int r = stk.pop();
            if(l>=r)continue;
          //  int pivot = arr[r];
            int i = l-1;int j = r;
            while (true){
                while (++i < j && arr[i] <= arr[r]);
                while (--j > i && arr[j] >= arr[r]);
                if(i>=j)break;
                else {
                    swap(arr,i,j);
                }
            }
            swap(arr,i,r);
            stk.push(i-1);stk.push(l);
            stk.push(r);stk.push(i+1);
        }
    }
}
```


### 173 二叉搜索树最小值迭代器 中序遍历
用 next() 将返回二叉搜索树中的下一个最小的数。
next() 和 hasNext() 操作的时间复杂度是 O(1)，并使用 O(h) 内存，其中 h 是树的高度。
```java
class BSTIterator {
Deque<TreeNode> stk;
private void pushleft(TreeNode root){
    while(root!=null){
        stk.push(root);
        root = root.left;
    }
}
public BSTIterator(TreeNode root) {
    stk = new ArrayDeque<>();
    pushleft(root);
}

/** @return the next smallest number */
public int next() {
    TreeNode top = stk.pop();
    if(top.right!=null){
        pushleft(top.right);
    }
    return top.val;
}

/** @return whether we have a next smallest number */
public boolean hasNext() {
    return !stk.isEmpty();
}
}
```

### 卡特兰数
https://blog.csdn.net/u014097230/article/details/44244793
递归式如下：h(n)= h(0)\*h(n-1)+h(1)\*h(n-2) + ... + h(n-1)h(0) (其中n>=2，h(0) = h(1) = 1) 该递推关系的解为：h(n)=C(2n,n)/(n+1) (n=1,2,3,...)
h(0)=1,h(1)=1,h(2)=2,h(3)=5,h(4)=14,h(5)=42

#### hdu 1134 2n个人围城一圈,两两握手,没有交叉，问有多少种方式。
第一个人可以和第2,4,6，..，2（n-1），2n，即必须保证和他握手的那个人两边是偶数，
即为：h(n)=h(0)\*h(n-1)+h(1)\*h(n-2)+...+h(n-1)\*h0=(4\*n-2)/(n+1) \*h(n-1),h(0)=1,h(1)=1.

#### hdu 1133 找零排队
有2n个人排成一行进入剧场。入场费5元。其中只有n个人有一张5元钞票，另外n人只有10元钞票，剧院无其它钞票，问有多少中方法使得只要有10元的人 买 票，售票处就有5元的钞票找零？(将持5元者到达视作将5元入栈，持10元者到达视作使栈中某5元出栈)

#### 不同形状的二叉树个数
先去一个点作为顶点,然后左边依次可以取0至N-1个相对应的,右边是N-1到0个,两两配对相乘,就是
h(0)*h(n-1) + h(2)*h(n-2) +  + h(n-1)h(0)=h(n))（能构成h（N）个）。

### 一个圆，被分成N个部分，用K种颜色给每个部分上色，要求相邻区域颜色不能相同。有多少种上色方案？
https://www.cnblogs.com/ranjiewen/p/8539095.html

### 一个环，有n个点, 问从0点出发，经过k步回到原点有多少种方法
k=1  0种
k=2  2种
d(k, j)表示从点j 走k步到达原点0的方法数
d(k, j) = d(k-1, j-1) + d(k-1, j+1);
由于是环的问题， j-1, j+1可能会超出 0到n-1的范围，因此，我们将递推式改成如下
d(k, j) = d(k-1, (j-1+n)%n) + d(k-1, (j+1)%n);

### 杨氏矩阵 nxn个数字放入nxn的杨氏矩阵
1 2 3 4

2x2

1 2   1 3   
3 4   2 4






### 星期计算 吉姆拉尔森
指定日期（Y年M月D日）的星期（W），可以先用公式①计算出当年元旦的星期，再计算距离当年元旦的天数，得到以下公式：
W = ( Y – 1 +（Y – 1）/ 4 –（Y – 1）/ 100 +（Y – 1）/ 400 +Days) % 7
 例如：计算2001年3月5日是星期几（W表示）？
Days = 31（1月）+ 28（2月）+ 4（3月）= 64
 W = [ 2001（Y）-1 +（2001 / 4 – 2001 / 100 + 2001 / 400）+ Days] % 7= 1
即2001年3月5日是星期二

### 约瑟夫环问题
https://www.nowcoder.com/questionTerminal/f78a359491e64a50bce2d89cff857eb6

### 毒药问题
有16瓶水，其中只有一瓶水有毒，小白鼠喝一滴之后一小时会死。请问最少用（） 只小白鼠，在1小时内一定可以找出至少14瓶无毒的水？
https://www.nowcoder.com/questionTerminal/a09c0eecbf684b0cba2ad0be32b7988e?orderByHotValue=1&difficulty=00001&mutiTagIds=134&page=2&onlyReference=false

问题：找14瓶无毒的，只有一瓶有毒的，可以有2瓶不知道有毒没毒。
二进制每个老鼠喝一位


#### n个圆能把平面分成几个
思路：
当n-1个圆时，区域数为f(n-1).那么第n个圆就必须与前n-1个圆相交，则第n个圆被分为2（n-1）段线段，增加了2（n-1）个区域。 
则： f(n) = f(n-1)+2(n-1) = f(1)+2+4+……+2(n-1) = n(n-1)+2



#### 458 毒药
1000个水桶，1个有毒药，喝了15分钟死，一小时内搞清哪个有毒最少需要多少只猪
5只 
4个水桶，1个有毒药，喝了15分钟死，30分钟搞清哪个有毒最少需要多少只猪
2只 2轮

假设有 n 只水桶，猪饮水中毒后会在 m 分钟内死亡，你需要多少猪（x）就能在 p 分钟内找出 “有毒” 水桶？这 n 只水桶里有且仅有一只有毒的桶。
思路：2只猪可以把桶放成一个二维的矩形，每一轮2只确定一行和一列，找到一个坐标。
如果3只猪，可以把桶放成三维X X X ，用三只每一轮确定一个位置。

1 2
3 4
第一轮喝 1，2 另一个1，3，都死说明1，不然说明2或者3.不死说明4.

1  2  3
4  5  6
7  8  9

第一轮1 2 3， 另一个 1，4 ，7
三只猪，测两次，可以测27桶

求数组的维度，我们知道了数组的总个数，所以要尽量增加数组的长宽，尽量减少维度。

数组的长宽其实都是测试的次数+1（因为全部测完了都没发生，下一轮不用测肯定在），所以我们首先要确定能测的次数，通过总测试时间除以毒发时间，再加上1就是测试次数。
$$log_{T+1}(N)$$

```java
public int poorPigs(int buckets, int minutesToDie, int minutesToTest) {
    return (int)Math.ceil(Math.log(buckets)/Math.log(minutesToTest / minutesToDie + 1));
}
```

正常思路：
如果2只，4个桶，一轮
都不喝0,A喝1，B喝2，AB喝3，
00      01    10     11
有x个猪可以表示2^x个状态。
如果有t次尝试，用t位二进制去表示bucket。

如果8个桶，15分钟死，有40分钟
可以测试2轮，用3位二进制表示桶
Math.log(8, 3).ceil

### 石子合并 tc
一堆有x个石子的石子堆和一堆有y个石子的石子堆合并将得到一堆x+y个石子的石子堆，这次合并得分为x\*y，当只剩下一堆石子的时候游戏结束。 最大得分多少。
{% note %}
3
1 2 3
{% endnote %}
2 + [3 3] = 2+9 =11
[1,7]+6 = 7+6 = 11
其实与顺序无关

### 316 !!删除重复字母，输出字典序最小的（按原顺序） pdd
{% note %}
Input: "bcabc"
Output: "abc"
{% endnote %}

关键：visit标记已经在栈中的直接跳过
ccabbc,如果之前标记过的visit被pop了，之后的c还是能正常入栈的。
```java
 public String removeDuplicateLetters(String s) {
        int[] ch = new int[26];
        int n = s.length();
        for(char c : s.toCharArray()){ 
            ch[c-'a']++;
        }
        Deque<Character> stk = new ArrayDeque<>();
        boolean[] visited = new boolean[26];
        for(int i = 0;i<s.length();i++){
                        

            char cur = s.charAt(i);
            ch[cur-'a']--;
            
            if(visited[cur-'a'])continue;
            while(!stk.isEmpty() && ch[stk.peek()-'a']>0 && cur<stk.peek()){
        char tmp = stk.pop();
             visited[tmp-'a'] = false;                                                                   
            }
            stk.push(cur);
            visited[cur-'a'] = true;
    
            
        }
        StringBuilder sb = new StringBuilder();
        for(Character c:stk){
            sb.insert(0,c);
        }
        
        return sb.toString();
    }
```

### 539 判断4点是否是正方形
{% note %}
输入: p1 = [0,0], p2 = [1,1], p3 = [1,0], p4 = [0,1]
输出: True
{% endnote %}



```java
public static double dist(int[] p1, int[] p2) {
    return (p2[1] - p1[1]) * (p2[1] - p1[1]) + (p2[0] - p1[0]) * (p2[0] - p1[0]);
}
public static boolean validSquare(int[] p1, int[] p2, int[] p3, int[] p4) {
    int[][] p={p1,p2,p3,p4};
    Arrays.sort(p, (l1, l2) -> l2[0] == l1[0] ? l1[1] - l2[1] : l1[0] - l2[0]);
    return dist(p[0], p[1]) != 0 && dist(p[0], p[1]) == dist(p[1], p[3]) && dist(p[1], p[3]) == dist(p[3], p[2]) && dist(p[3], p[2]) == dist(p[2], p[0])   && dist(p[0],p[3])==dist(p[1],p[2]);
}
```

思路：4个点两两的距离，一共C42=6, 其中有4条是正方形的边长，2条是对角线。
简化一点，从1个点出发3条边，有2条边长，一条对角线，可以不用判断面积，对角线是边的根号2倍，平方就是2倍
边界条件，多个点是重叠的情况，
面积法不好，面积越界
```java
public boolean validSquare(int[] p1, int[] p2, int[] p3, int[] p4) {
    int[] dis = new int[6];
    int[][] points = new int[4][2];
    points[0] = p1;
    points[1] = p2;
    points[2] = p3;
    points[3] = p4;
    int cnt = 0;
    for(int i = 0;i<3;i++){
        for(int j = i+1;j<4;j++){
            int dis2 = (points[i][0]-points[j][0])*(points[i][0]-points[j][0]) + (points[i][1]-points[j][1])*(points[i][1]-points[j][1]);
            dis[cnt++] = dis2;
        }
    }
    Arrays.sort(dis);
    return dis[0]>0&&dis[0]*2 ==dis[5];
}
```

### 判断D点是否在三角形内
设线段端点为从 A(x1, y1)到 B(x2, y2), 线外一点 P(x0，y0)，
判断该点位于有向线 A→B 的那一侧。 
a = ( x2-x1, y2-y1) 
b = (x0-x1, y0-y1) 
a x b = | a | | b | sinφ (φ为两向量的夹角) 
| a | | b |  ≠ 0 时， a x b  决定点 P的位置 
所以  a x b  的 z 方向大小决定 P位置 
(x2-x1)(y0-y1) – (y2-y1)(x0-x1)  > 0   左侧 
(x2-x1)(y0-y1) – (y2-y1)(x0-x1)  < 0   右侧 
(x2-x1)(y0-y1) – (y2-y1)(x0-x1)  = 0   线段上 

思路，计算边AB,BC,CA 顺时针的边和 点D的叉积是不是都>=0
```java
// AB:（B.x-A.x，B.y-A.y)
// AC: (C.x-A.x，C.y-A.y)
double Product(point A, point B,point C){
    return (B.x - A.x)*(C.y-A.y)-(C.x-A.x)*(B.y-A.y);
}
boolean isIn(point A,point B,point C,point D){
    if(Product(A, B, D) >= 0 && Product(B, C, D) >=0 && Product(C,A,D) >=0){
        return true;
    }
    return false;
}
```

### lc84直方图中的最大矩形poj2559 
{% note %}
Input: [2,1,5,6,2,3]
Output: 10
{% endnote %}

栈：比当前i高的未来都会入栈，而之前比i高的都会出栈计算出结果，而且栈中之前的肯定都矮，也就是说，i如果是栈中唯一元素，宽度一定可以延伸到数组最左。
技巧：-1，每次计算宽度的时候，先pop，宽度的左端点是栈的peek(),比栈顶小的左边位置
```java
public int largestRectangleArea(int[] heights) {
    Deque<Integer> stk = new ArrayDeque<>();
    int n = heights.length;
    int rst = 0;
    stk.push(-1);
    for(int i =0;i<n;i++){
        while(stk.peek()!=-1 && heights[i]<=heights[stk.peek()] ){
            int h = heights[stk.pop()];
            int left = stk.peek();
            int w = i-1-left;
            rst = Math.max(rst,w*h);
        }
        stk.push(i);
    }
    
    while(stk.peek()!=-1){
        int h = heights[stk.pop()];
        int left = stk.peek();
        int w = n-1-left;
        rst = Math.max(rst,w*h); 
    }
    return rst;
}
```


挑战p335
思路：以当前位置的高度为最终高度，如果左右比当前值更大，则这个矩形宽可以左右扩展。
定义
L[i] 找到以当前高度最大矩形的左边界，就是比hi更高的最左位置
R[i] 右边界，比hi更高的最右
        0 1 2 3 4 5
height [2,1,5,6,2,3]
left   [0,0,2,3,2,5]
right  [0,5,3,3,5,5]
rst    [2,6,10,6,8,3]
递增栈 保持栈顶是挡住比当前hi小的元素的下标
```java
public int largestRectangleArea(int[] h) {
    int rst = 0;
    int n = h.length;
    int[] stk = new int[n];
    int[] L = new int[n];
    int[] R = new int[n];
    int t = 0;
    for (int i = 0; i <h.length ; i++) {
        while (t>0 && h[stk[t-1]]>=h[i])t--;
        L[i] = t ==0?0:(stk[t-1] + 1);
        stk[t++] = i;
    }
    t = 0;
    for (int i = n-1; i >=0 ; i--) {
        while (t>0 && h[stk[t-1]]>=h[i])t--;
        R[i] = t ==0?n-1:(stk[t-1]-1);
        stk[t++] = i;
    }
    for(int i = 0;i<n;i++){
        rst = Math.max(rst,h[i]*(R[i]-L[i]+1));
    }
    return rst;
}
```


### 15 3sum a + b + c = 0
> Given array nums = [-1, 0, 1, 2, -1, -4],
A solution set is:
[
  [-1, 0, 1],
  [-1, -1, 2]
]

关键：去重技巧
```java
//75%
public List<List<Integer>> threeSum(int[] num) {
    Arrays.sort(num);
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i <num.length-2; i++) {
        //关键去重
        if(i==0||(i>0&&num[i]!=num[i-1])){
            int lo = i+1,hi=num.length-1,sum = 0-num[i];
            //关键
            while (lo<hi){
                if(num[lo]+num[hi] == sum){
                    res.add(Arrays.asList(num[i],num[lo],num[hi]));
                    //去重
                    while (lo<hi&&num[lo]==num[lo+1])lo++;
                    while (lo<hi&&num[hi]==num[hi-1])hi--;
                    lo++;hi--;
                }else if(num[lo]+num[hi]<sum)lo++;
                else hi--;
            }
        }
      }
      return res;
}
```

### 215 Kth Largest Element in an Array
{% note %}
Input: [3,2,1,5,6,4] and k = 2
Output: 5
{% endnote %}

用快排用头中尾的中位数最快。
找第k个最大，就是找下标为k = len-k = 4的数字

```java
public int findKthLargest(int[] nums, int k) {
        int n = nums.length;
        int h = n-1;
        int l = 0;
        //l=0,h=0
        while(l<h){
            // 从大到小排序 
            // 每次拿l试试能放到第几个上
            int mid = piv(nums,l,h);
            if(mid==k-1)return nums[mid];
            // k=1 return 2
            else if(mid >k-1){
                h = mid-1;
            }else l = mid+1;
        }
        return nums[l];
        
    }
    //3 2 1 5 4
    //  4     2
    //  4 5 1 2
    //5 4 3 1 2  return 2  
    private int piv(int[] nums,int l,int h){
        //i=0,j=1
        int i = l;int j = h+1;
        int p = nums[l];
        while(true){ 
            //左大 右小
            while(++i<j && nums[i]>=p);
            while(--j>i && nums[j]<=p);

                if(i>=j)break;
                else swap(nums,i,j);
        }
        swap(nums,j,l);
        return j;
    }
```


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

迭代头插
```java
public ListNode reverseKGroup(ListNode head, int k) {
    ListNode dumy = new ListNode(0);
    dumy.next = head;
    ListNode pre = dumy;
    while(true){
        ListNode fontk = pre;
        for(int i =0;i<k;i++){
            fontk = fontk.next;
            if(fontk == null)return dumy.next;
        }
        ListNode last = pre.next;

        for(int i =0;i<k-1;i++){
            ListNode next = last.next;
            last.next = next.next;
            next.next = pre.next;
            pre.next = next;
        }
        pre = last;

    }
}
```



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

### 124 二叉树最大路径和
{% note %}
输入: [1,2,3]
       1
      / \
     2   3
输出: 6
{% endnote %}
```java
int max = Integer.MIN_VALUE;
public int maxPathSum(TreeNode root) {
    maxhelp(root);     
    return max;
}

private int maxhelp(TreeNode root){
    if(root == null)return 0;
    //int t1 = maxPathSum(root.left)+maxPathSum(root.right)+root.val;
    int left =  Math.max(0,maxhelp(root.left));
    int right =  Math.max(0,maxhelp(root.right));
    // 每个点汇总一下有左右的情况是不是更大,注意左右一定正的，如果root是负，left或right的最大值再上次递归已经记录了
    max = Math.max(max,root.val+left+right);
    // 选择大的一条路径向上递归
    return Math.max(left,right)+root.val;
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
{% note %}
输入: [2,3,1,1,4]
输出: 2
解释: 跳到最后一个位置的最小跳跃数是 2。
     从下标为 0 跳到下标为 1 的位置，跳 1 步，然后跳 3 步到达数组的最后一个位置。
{% endnote %}
```java
public int jump(int[] nums) {
    int end = 0;
    int maxPosition = 0; 
    int steps = 0;
    for(int i = 0; i < nums.length - 1; i++){
        //找能跳的最远的
        maxPosition = Math.max(maxPosition, nums[i] + i); 
        if( i == end){ //遇到边界，就更新边界，并且步数加一
            end = maxPosition;
            steps++;
        }
    }
    return steps;
}
```

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



### 栈逆序
2个递归O(n^2)，主递归
1.把栈底放到栈顶{1,2,3,4,5}->{5,1,2,3,4}保存一下栈顶元素，后4个元素递归
```java
public int[] reverseStackRecursively(int[] stack, int top) {
       if(top==0)return stack;
       move_bottom_to_top(stack, top);
       int peek = stack[--top];

       reverseStackRecursively(stack,top );
       stack[top++] = peek;

       return stack;
    }
```
2.移动到栈顶的递归O（N）：先保存栈顶1，递归假设后面已经移动成了{5,2,3,4}，1和栈顶5交换
```java
private void move_bottom_to_top(int[] stk,int top){
    if(top==0)return;
    int peek = stk[top - 1];
    top--;
    if(top>0){
        move_bottom_to_top(stk, top);
        int top2 = stk[--top];
        stk[top++] = peek;
        stk[top++] = top2;
    }else {
        stk[top++] = peek;
    }
}
```

---
## 问题不大

### 

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