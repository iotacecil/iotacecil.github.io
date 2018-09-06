---
title: ToDoAgain
date: 2018-09-03 14:44:31
tags:
categories: [算法备忘]
---
### 34 二分查找数字的first+last idx？？？？？？
> Input: nums = [5,7,7,8,8,10], target = 8
> Output: [3,4]

二分查找获取最左/右边相等的
```java
//获取最右
while(i<j){
 int mid = (i+j)/2+1;
 if(nums[mid]>target)j = mid-1;
 //找到了继续向右找
 else i =mid;}
rst[1]=j;
```

### 5只猴子分桃，每次拿走一个正好分成5堆，问桃子数

### !543树中两点的最远路径，自己到自己0
> [4,2,1,3]路径长度3

![lc545](/images/lc545.jpg)
将每个点试当成转折点,在更新左右最长高度的同时更新rst = Max(rst,l+r);

### ！！687树中值相等的点的路径长

### !!!114原地将二叉树变成链表
1.入栈迭代40%
    1. 先入栈右子树，再入栈左子树，更新右节点为栈顶。
    2. 将当前左子树变成null。下一次循环cur是栈顶（原左子树）
2. 后序遍历 递归6%
```java
pre = null;
flat(root.right);
flat(root.left);
root.right = pre;
root.left = null;
pre = root;
```

### 438 Anagrams in a String 滑动窗口`Arryas.equals`
> Anagrams 字母相同，顺序不同的单词 连续
> s: "cbaebabacd" p: "abc" 
> Output:[0, 6] 输出起始位置

[Sliding Window algorithm](https://leetcode.com/problems/find-all-anagrams-in-a-string/discuss/92007/Sliding-Window-algorithm-template-to-solve-all-the-Leetcode-substring-search-problem.)
![anagram](/images/anagram.jpg)
![anagram2](/images/anagram2.jpg)
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

### ！！！！76 最小的子串窗口 很重要的题


### ！5 最长回文串
http://windliang.cc/2018/08/05/leetCode-5-Longest-Palindromic-Substring/
!!反转做法不行:abcxyzcba -> abczyxcba ->相同的abc并不是回文
!! 不能用LCS
“cba”是“abc”的 reversed copy
中心扩展法：回文的中心有奇数：n个，偶数：n-1个位置
会输出靠后的abab->输出bab
```java
int len;
public String longestPalindrome(String s) {
    if(s==null||s.length()<2)return s;
    len = s.length();
    int start = 0;int end = 0;
    // int max = 0;
    for(int i =0;i<len;i++){
        //"babad" ->"bab" ->i =1 len = 3   
        //"cbbd" -> "bb" ->i=1 len = 2
        int len1 = help(s,i,i);//奇数扩展
        int len2 = help(s,i,i+1);//偶数扩展
        int max = Math.max(len1,len2);
        if(max>end-start){
            start = i - (max-1)/2;//去掉中间那个左边长度的一半
            end = i+max/2;//右边长度的一半
        }//end-start= i+max/2-i+(max-1)/2 = max-1/2
    }
    return s.substring(start,end+1);     
    
}
private int help(String s,int left,int right){
    while(left>=0&&right<len&&s.charAt(left)==s.charAt(right)){
        left--;
        right++;
        
    }
    return right-left-1;
}
```
#### Manacher's 算法 O(n)
https://algs4.cs.princeton.edu/53substring/Manacher.java.html
前缀/

#### 回文树
`next[i][c]` 编号为i的节点表示的回文串两边添加c后变成的回文串编号。
`fail[i]`节点i失配后
`cnt[i]`

### K-D tree

### 快速排序的各种优化
https://algs4.cs.princeton.edu/23quicksort/

### 前序中序构造二叉树
A BDEG CF
DBGE A CF
```java
public TreeNodeT<Character> createTree(String preOrder,String inOrder){
    if(preOrder.isEmpty())return null;
    char rootVal = preOrder.charAt(0);
    int leftLen = inOrder.indexOf(rootVal);
    TreeNodeT<Character> root = new TreeNodeT<Character>(rootVal);
    root.left = createTree(
            preOrder.substring(1,1+leftLen),
            inOrder.substring(0,leftLen));

    root.right = createTree(
            preOrder.substring(1+leftLen),
            inOrder.substring(leftLen+1));
    return root;
}
```

### 106 中序+后序建树

### 698 将数组分成sum相等的k份

### ？？？有100个帽子，每个人有几顶，问每个人戴出来都不一样有多少种

### 239
Monotonic queue 前后可以修改o(1)，并且可以随机访问
维护一个单调递减的序列，读一个窗口输出单调队列的first

### 818 A加速，R掉头并减速，到指定位置最少需要多少条指令

### 15 3sum=0 荷兰国旗写法3指针
1p：从0~len-2，3个数的和 右边至少留两个数 sum=0-nums[i]转化成2sum问题
去重：当num[i]=num[i-1]:continue
另外两个指针从1p往后从len-1往前。
去重：预判：nums[low]=nums[low+1]:low++;nums[high]=nums[high-1]:high--;

### ?3 连续最长不重复子序列
两指针i从左向右遍历到最后
j指示i之前不重复的最高位置。
i-j+1为当前最长结果

### ?409 string中字符组成回文串的最大长度
1.开int[128]，直接用int[char]++计数
2.奇数-1变偶数&(~1)
3.判断奇数(&1)>0

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
### 139 word break
1.状态：boolean[n+1]长度为i的前缀能否由字典组成
2.初始值：[0]=true 空字符串
3.转移方程if(dp[i]==true&&dic.contains(sub(i,i+j))) dp[i+j]=true
4.结果

```java
f[0]=true;
for(int i =1;i<s.length();i++){
    for(int j=0;j<i;j++){
        if(f[j]&&dic.contains(s.substring(j,i))){
            f[i]=true;
            break;
        }
    }
}
return f[s.length()];
```

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

### 45 ?jump game最少跳跃次数
1.在本次可跳跃的长度范围内如果不能达到len-1则表示一定要跳跃
2.BFS

