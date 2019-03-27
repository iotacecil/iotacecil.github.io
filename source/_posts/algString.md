---
title: algString
date: 2019-03-05 21:19:21
tags: [alg]
categories: [算法备忘]
---
## 括号

### 20 Valid Parentheses
{% note %}
Input: "()[]{}"
Output: true
{% endnote %}
```java
public boolean isValid(String s) {
    Deque<Character> stk = new ArrayDeque<>();
    for(char c : s.toCharArray()){
        if(!stk.isEmpty()&& ((stk.peek() == '{' && c == '}') ||
                (stk.peek() == '[' && c == ']') ||
                (stk.peek() == '(' && c == ')'))){

                stk.pop();
        }else{
            stk.push(c);
        }
    }
    return stk.isEmpty();
}
```

### 22 Generate Parentheses 生成n对匹配的括号 （卡特兰数）
{% note %}
For example, given n = 3, a solution set is:
```
[
  "((()))",
  "(()())",
  "(())()",
  "()(())",
  "()()()"
]
```
{% endnote %}
注意加左括号和右括号是两个分支，不是if else的关系
```java
public List<String> generateParenthesis(int n) {
    List<String> rst = new ArrayList<>();
    gene(rst,"",n,n);
    return rst;
}
private void gene(List<String> rst,String tmp,int left,int right){
    if(left == 0 && right == 0){
        rst.add(tmp);
        return;
    }
    // ( left = 2 right = 3 
    if(left >0){
        gene(rst,tmp+"(",left-1,right);
    }
    if(right > 0 && left<right){
        gene(rst,tmp+")",left,right-1);
    }
}
```

还有一种迭代的
https://leetcode.com/problems/generate-parentheses/discuss/10127/An-iterative-method.
```
f(0): ""

f(1): "("f(0)")"

f(2): "("f(0)")"f(1), "("f(1)")"

f(3): "("f(0)")"f(2), "("f(1)")"f(1), "("f(2)")"

So f(n) = "("f(0)")"f(n-1) , "("f(1)")"f(n-2) "("f(2)")"f(n-3) ... "("f(i)")"f(n-1-i) ... "(f(n-1)")"
```


### 32 Longest Valid Parentheses 字符串中最长有效括号子串
{% note %}
Input: ")()())"
Output: 4  "()()"
{% endnote %}

思路:遇到(，把位置入栈，遇到)，弹出一个(位置，栈顶一定是这个“)”匹配的"("的最左非匹配位置。初始非匹配位置为-1
```java
public int longestValidParentheses(String s) {
    Deque<Integer> stk = new ArrayDeque<>();
    stk.push(-1);
    int rst = 0;
    for(int i = 0;i<s.length();i++){
        char c = s.charAt(i);
        if(c == '('){
            stk.push(i);
        }else if(c == ')'){
                stk.pop();
                if(stk.isEmpty())
                    stk.push(i);
                else {
                    rst = Math.max(rst,i-stk.peek());
                }
            }
        }
    return rst;
}
```

正确方法：
从左向右扫一遍，累计"("数量和")"数量，当两者相等，更新最大长度，当")"数量超过"("数量，清零。再从右往左扫一遍更新max。

相似题目：
135 按分数分糖最少数量

```java
public int longestValidParentheses(String s) {
    int left = 0, right = 0, maxlength = 0;
    for (int i = 0; i < s.length(); i++) {
        if (s.charAt(i) == '(') {
            left++;
        } else {
            right++;
        }
        if (left == right) {
            maxlength = Math.max(maxlength, 2 * right);
        } else if (right >= left) {
            left = right = 0;
        }
    }
    left = right = 0;
    for (int i = s.length() - 1; i >= 0; i--) {
        if (s.charAt(i) == '(') {
            left++;
        } else {
            right++;
        }
        if (left == right) {
            maxlength = Math.max(maxlength, 2 * left);
        } else if (left >= right) {
            left = right = 0;
        }
    }
    return maxlength;
}
```


### 括号串达到匹配需要最小的逆转次数
{% note %}
Input:  exp = "}}}{"
Output: 2 
{% endnote %}

将匹配的括号都去掉，`{`的个数是m=3，`}`的个数是n=3
m/3+n/2 = 2+1=3
![minbracket.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/minbracket.jpg)
```java
private int minReversal(String s){
    int len = s.length();
    if((len&1)!=0)return -1;
    Deque<Character> que = new ArrayDeque<>();
    int n=0;
    for(int i=0;i<s.length();i++){
        char c = s.charAt(i);
        if(c=='}'&&!s.isEmpty()){
            if(que.peek()=='{')que.pop();
            else {
                que.push(c);
            }
        }
    }
    int mn = que.size();
    while (!que.isEmpty()&&que.peek()=='{'){
        que.pop();
        n++;
    }
    //当m+n是偶数的时候ceil(n/2)+ceil(m/2)=
    return (mn/2+n%2);
}
```


### 241 Different Ways to Add Parentheses 给运算表达式加括号改变优先级
{% note %}
输入: "2-1-1"
输出: [0, 2]
解释: 
((2-1)-1) = 0 
(2-(1-1)) = 2
{% endnote %}

### 301 Remove Invalid Parentheses


### 459 Repeated Substring Pattern 子串重复N次 S = N\*T
{% note %}
Input: "ababab"
Output: True
Explanation: It's the substring "ab" 3次.
{% endnote %} 
abcabc abcabc -> b|c[abcabc]a|b
```java
public boolean repeatedSubstringPattern(String str) {
    String s = str + str;
    return s.substring(1, s.length() - 1).contains(str);
}
```


### 151. Reverse Words in a String
{% note %}
Input: "  hello world!  "
Output: "world! hello"
{% endnote %}

### 115 Distinct Subsequences 计算在S的子序列中T出现的次数
{% note %}
Input: S = "rabbbit", T = "rabbit"
Output: 3
{% endnote %}
关键：dp初始化T长度为0的时候匹配数量是1 
dp[i][j] S[0,i)和T[0,j)的匹配数量
```java
public int numDistinct(String s, String t) {
    int n = s.length();
    int m = t.length();
    int[][] dp = new int[n+1][m+1];
    // 当t=”“
    for (int i = 0; i <=n ; i++) {
        dp[i][0] = 1;
    }
    for (int i = 1; i <=n ; i++) {
        for (int j = 1; j <=m ; j++) {
            if(s.charAt(i-1) == t.charAt(j-1)){
                dp[i][j] = dp[i-1][j-1] + dp[i-1][j];
            }else
                dp[i][j] = dp[i-1][j];
        }
    }
    return dp[n][m];
}
```


### 392 Is Subsequence 判断是否是子序列
{% note %}
Example 1:
s = "abc", t = "ahbgdc"
Return true.
{% endnote %}
```java
public boolean isSubsequence(String s, String t) {
    int n1 = s.length();
    int n2 = t.length();
    int p1 = 0;
    int p2 = 0;
    while(p1<n1){
        while(p2<n2 && s.charAt(p1) != t.charAt(p2))p2++;
        if(p2 >= n2)return false;
        if(s.charAt(p1) == t.charAt(p2)){
            // 注意p2也要++
            p2++;  p1++;
        }
    }
    return p1>=n1;
}
```

### 344. Reverse String 逆转char数组
{% note %}
Input: ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]
{% endnote %}
熟练
```java
public void reverseString(char[] s) {
    int j = s.length-1;
    int i = 0;
    while(i<j){
        char tmp = s[j];
        s[j] = s[i];
        s[i] =tmp;
        i++;j--;
    }
}
```

### 383 Ransom Note 从str2中选字符可以组成str1
{% note %}
canConstruct("aa", "ab") -> false
canConstruct("aa", "aab") -> true
{% endnote %}
熟练
{% fold %}
```java
public boolean canConstruct(String str1, String str2) {
    int[] cnt = new int[26];
    int n = str1.length();
    int m = str2.length();
    if(n>m)return false;
    for(int i = 0;i<m;i++){
        cnt[str2.charAt(i)-'a']++;
        if(i<n)
        cnt[str1.charAt(i)-'a']--;
    }
    for(int i:cnt){
        if(i <0)return false;
    }
    return true;
}
```
{% endfold %}

### 387. First Unique Character in a String 第一个不同的字符位置
{% note %}
s = "leetcode"
return 0.
{% endnote %}
思路：扫描两遍字符串找到频率为1的直接return
较熟练
```java
public int firstUniqChar(String s) {
    int freq [] = new int[26];
    for(int i = 0; i < s.length(); i ++)
        freq [s.charAt(i) - 'a'] ++;
    for(int i = 0; i < s.length(); i ++)
        if(freq [s.charAt(i) - 'a'] == 1)
            return i;
    return -1;
}
```

### 58. Length of Last Word 最后一个单词的长度
{% note %}
Input: "Hello World"
Output: 5
{% endnote %}
注意空字符的坑
```java
public int lengthOfLastWord(String s) {
    int cnt =0;
    for(int i = s.length()-1;i>=0;i--){
        if(cnt >0 && s.charAt(i) ==' ')return cnt;
        else if(s.charAt(i)!=' ')cnt++;
    }
    return cnt;
}
```

### 14. Longest Common Prefix 字符串数组最长前缀
{% note %}
Input: ["flower","flow","flight"]
Output: "fl"
{% endnote %}

```java
public String longestCommonPrefix(String[] strs) {
    if(strs == null || strs.length == 0)    return "";
    String pre = strs[0];
    int i = 1;
    while(i < strs.length){
        while(strs[i].indexOf(pre) != 0)
            pre = pre.substring(0,pre.length()-1);
        i++;
    }
    return pre;
}
```

有bug要调
{% fold %}
```java
public String longestCommonPrefix(String[] strs) {
    if(strs.length<1)return "";
    int minlen = Integer.MAX_VALUE;
    for(String s:strs){
        minlen = Math.min(minlen,s.length());
    }
    for(int i =1;i<strs.length;i++){
        if(!strs[i-1].substring(0,minlen).equals(strs[i].substring(0,minlen))){
         minlen--;
         i=0;
        }
    }
    return strs[0].substring(0,minlen);
}
```
{% endfold %}

### 28字符串indexOf匹配暴力 Substring Search
{% note %}
Input: haystack = "hello", needle = "ll"
Output: 2
{% endnote %}
```java
public int strStr(String str1, String str2) {      
    for(int i =0;;i++){
        for(int j = 0;;j++){        
            if(j == str2.length())return i;
             if(i+j == str1.length())return -1;
            if(str1.charAt(i+j)!=str2.charAt(j)){
                break;
            }
        }
    }
}
```

各种字符串匹配算法
http://www-igm.univ-mlv.fr/~lecroq/string/
![strstrbest.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/strstrbest.jpg)
https://algs4.cs.princeton.edu/53substring/
![backup.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/backup.jpg)
方法1是维持一个pattern长度的buffer
![substring.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/substring.jpg)
流的情况下 没有backup
```
ADA B RAC
ADA[C]R i-=j
 ADACR
```

#### !!!Boyer-Moore 74% 5ms 亚线性
alg4
1.构建right表示target中字符的最右位置是NEEDLE
![boyerright.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/boyerright.jpg)
2.source从左到右扫描，target从右向左
如果出现不匹配T是target里没有的，i到j+1
如果出现不匹配N是target里的，则用right，将target里N的位置和它对齐
![boyerright2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/boyerright2.jpg)
当前j=3,right['N'] = 0,skip=3
第三种情况，至少保证i不能回退
![boyer3.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/boyer3.jpg)

```java
 public int strStr(String source, String target) {
    if(source.length()<target.length())return -1;
        if(target==null||target.length()==0)return 0;
        int R = 256;
        int[] right = new int[R];
        for (int c = 0; c < R; c++)
        right[c] = -1;
        for (int j = 0; j < target.length(); j++)
            right[target.charAt(j)] = j;
        int m = target.length();
        int n = source.length();
        int skip;
        for (int i = 0; i <= n - m; i += skip) {
            skip = 0;
            for (int j = m-1; j >= 0; j--) {
                if (target.charAt(j) != source.charAt(i+j)) {
                    skip = Math.max(1, j - right[source.charAt(i+j)]);
                    break;
                }
            }
            if (skip == 0) return i;
        }
        return -1;
}
```

#### RabinKarp 31% 8ms 线性
![rabin-karp.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/rabin-karp.jpg)
![ranbinmod.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/ranbinmod.jpg)

正确性：
![kbright.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/kbright.jpg)
线性求mod
```java
//    private long longRandomPrime(){
//        BigInteger prime = BigInteger.probablePrime(31,new Random());
//        return prime.longValue();
//    }
int R = 256;
long q;

private long hash(String key, int m) {
    long h = 0;
    for (int j = 0; j < m; j++)
        h = (R * h + key.charAt(j)) % q;
    return h;
}
    //变成拉斯维加斯算法
private boolean check(String source,String target, int i) {
    for (int j = 0; j <target.length() ; j++)
        if (target.charAt(j) != source.charAt(i + j))
            return false;
    return true;
}
public  int searchRabinKarp(String source,String target){
    if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int R = 256;
    int m = target.length();
    int n = source.length();
    long RM = 1;
    q = 1877124611;//保证不冲突
    for (int i = 1; i <=m-1 ; i++) {
        RM = (R * RM) % q;
    }
    long patHash = hash(target,m);
    long txtHash = hash(source, m);
   
    //一开始就匹配成功
    if ((patHash == txtHash) && check(source,target, 0))
        return 0;

    // check for hash match; if hash match, check for exact match
    for (int i = m; i < n; i++) {
        // Remove leading digit, add trailing digit, check for match.
        txtHash = (txtHash + q - RM*source.charAt(i-m) % q) % q;
        txtHash = (txtHash*R + source.charAt(i)) % q;

        // match
        int offset = i - m + 1;
        if ((patHash == txtHash) && check(source, target,offset))
            return offset;
    }

    // no match
    return -1;

}
```


#### 暴力 O（MN）
双指针
i的位置是txt已匹配过的最后位置
15% 13ms
```java
public int strStr(String source, String target) {
    if(source.length()<target.length())return -1;
    if(source==null||source.length()==0)return 0;
    int i,N = source.length();
    int j,M = target.length();
    for (i = 0,j=0; i <N&&j<M ; i++) {
        if(source.charAt(i)==target.charAt(j))j++;
        else{
            i-=j;
            j=0;
        }
    }
    if(j==M)return i-M;
    else return -1;
}
```

按indexOf简化 43% 7ms
```java
public int strStr(String source, String target) {
if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int lens = source.length();
    int tar = target.length();
    char[] targetArr = target.toCharArray();
    char[] sourceArr = source.toCharArray();
    char first = targetArr[0];
    int max = lens-tar;
    for (int i = 0; i <= max ; i++) {
        if(sourceArr[i]!=first){
            while (++i<=max&&sourceArr[i]!=first);
        }
        if(i<=max){
            int j = i+1;
            int end = j+tar-1;
            for (int k = 1; j <end&&sourceArr[j]==targetArr[k] ; k++,j++) ;
            if(j == end)return i;
        }
    }
    return -1;
}
```

java `indexOf`实现
- 最长公共前缀：indexOf
73% 5ms
```java
public int strStr(String source, String target) {
   return indexOf( source.toCharArray(),0,source.length(),target.toCharArray(),0,target.length(),0);
}
```

{% fold %}
```java
/*
@param source:左值（被查找）
@param count长度
*/
 static int indexOf(char[] source, int sourceOffset, int sourceCount,
            char[] target, int targetOffset, int targetCount,
            int fromIndex) {
        // 查找位置>=左值长度
        if (fromIndex >= sourceCount) {
            //traget空？返回左值长度
            return (targetCount == 0 ? sourceCount : -1);
        }
        if (fromIndex < 0) {
            fromIndex = 0;
        }
        // 右值为0，返回查找位置
        if (targetCount == 0) {
            return fromIndex;
        }

        char first = target[targetOffset];
        //最后一个匹配的下标，至少减去右值的长度
        int max = sourceOffset + (sourceCount - targetCount);

        for (int i = sourceOffset + fromIndex; i <= max; i++) {
            /* Look for first character. */
            if (source[i] != first) {
                while (++i <= max && source[i] != first);
            }

            /* Found first character, now look at the rest of v2 */
            if (i <= max) {
                int j = i + 1;
                int end = j + targetCount - 1;
                for (int k = targetOffset + 1; j < end && source[j]
                        == target[k]; j++, k++);

                if (j == end) {
                    /* Found whole string. */
                    return i - sourceOffset;
                }
            }
        }
        return -1;
    }
```
{% endfold %}
 
### KMP-Knuth-Morris-Pratt 适合查找自我重复的字符串 线性的M倍

给定的一个长度为N的字符串str,查找长度为P(P<N)的字符串在str中的出现次数.下面的说法正确的是()
正确答案: D   你的答案: D (正确)
不存在比最坏时间复杂度O(NP)好的算法
不存在比最坏时间复杂度O(N^2)好的算法
不存在比最坏时间复杂度O(P^2)好的算法
存在最坏时间复杂度为O(N+P)的算法
存在最坏时间复杂度为O(log(N+P))的算法
以上都不对

KMP匹配算法 时间复杂度为O（N+P）

基于DFA
![DFA.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/DFA.jpg)
用一个dfa[][]记录j回退多远
1对target构建dfa
构造DFA的时间是O（MR）的，可以对每个状态设置一个匹配/非匹配去掉R
9ms 24%
```java
public static int serachByKMP(String source,String target){
    if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int M = target.length();
    int N = source.length();
    int[] dfa = new int[M];
    int k = 0;
    dfa[0] =0;
    //For the pattern “AAACAAAAAC”,
    //lps[] is [0, 1, 2, 0, 1, 2, 3, 3, 3, 4]
    for (int i = 1; i < M; i++) {
        while (k>0&&target.charAt(k)!=target.charAt(i))
            k = dfa[k-1];
        if(target.charAt(k)==target.charAt(i)){
            k++;
        }
        dfa[i]=k;
    }
    int q = 0;
    //[0, 0, 0, 1, 0]
    //"mississippi", 
    // "issip"     q=4 i=5 dfa[3]=1
    // "issip"     q=1 i=5
    //    "issip" 
    for (int i = 0; i <N ; i++) {
        while(q>0&&target.charAt(q)!=source.charAt(i))
            q = dfa[q-1];
        if(target.charAt(q)==source.charAt(i))
            q++;
        if(q==M)
            return i-M+1;
    }
    return -1;
}
```
![dfaconstruction.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/dfaconstruction.jpg)
![KMPDFA.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/KMPDFA.jpg)
2.对source遍历一遍dfa
12.44% 39ms
```java
public int strStr(String source, String target) {
 if(source.length()<target.length())return -1;
    if(target==null||target.length()==0)return 0;
    int R = 256;
    int M = target.length();
    int[][] dfa = new int[R][M];
    //构建DFA
    dfa[target.charAt(0)][0] =1;
    for(int X = 0,j=1;j<M;j++){
        for (int c = 0; c < R; c++)
            dfa[c][j] = dfa[c][X];//复制上一列匹配失败
        dfa[target.charAt(j)][j] = j+1;//更新匹配成功
        X = dfa[target.charAt(j)][X];//重启状态
    }
    //模拟一遍DFA
    int i,j,N = source.length();
    for (i = 0,j=0; i  < N&&j< M; i++) {
        j = dfa[source.charAt(i)][j];
    }
    if(j==M) return i-M;
    else return -1;
}
```
文本串T某个前缀的后缀是模式串P的前缀。取最长的后缀。
1 子序列 不连续 2 字串 连续
KMP:getIndexOf
d之前【最长前缀】和【最长后缀】的匹配长度
(abcabc)d 前缀：(a->ab->abc->...->abcab) 后缀:(c->bc->abc->...->bcabc)
所以最长匹配是3：abc,记录在d位置上
int[]next =  f("abcabcd")={-1,0,0,1，2，3}
关键加速求解匹配
