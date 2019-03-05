---
title: algBitMap
date: 2019-03-04 10:10:31
tags: [alg]
categories: [算法备忘]
---
### 260 Single Number III 两个数字只出现一次，其它出现2次
{% note %}
Input:  [1,2,1,3,2,5]
Output: [3,5]
{% endnote %}

### 137 Single Number II 所有数字都出现3次，只有一个出现1次
{% note %}
Input: [0,1,0,1,0,1,99]
Output: 99
{% endnote %}

三进制不进位加法
不会
```java
public int singleNumber(int[] A) {
    int ones = 0, twos = 0;
    for(int i = 0; i < A.length; i++){
        ones = (ones ^ A[i]) & ~twos;
        twos = (twos ^ A[i]) & ~ones;
    }
    return ones;
}
```


### 190 Reverse Bits 逆序二进制位
{% note %}
Input: 00000010100101000001111010011100
Output: 00111001011110000010100101000000
{% endnote %}
不熟练
```java
public int reverseBits(int n) {
  int rst = 0;
  for(int i = 0;i<32;i++){
        rst <<= 1;
        rst  += (n>>>i)&1;  
    }
    return rst;
}
```

### 191 Number of 1 Bits 十进制数int有几个二进制1
{% note %}
Input: 00000000000000000000000000001011
Output: 3
Explanation: The input binary string 00000000000000000000000000001011 has a total of three '1' bits.
{% endnote %}
熟练
```java
public int hammingWeight(int n) {
    int cnt =0;
    while(n!=0){
        n = n&(n-1);
        n>>>=1;
        cnt++;
    }
    return cnt;
}
```

### 268 Missing Number 0-n个数字放进长度n-1的数组，少了哪个
{% note %}
Input: [3,0,1]
Output: 2
{% endnote %}

熟练 位运算
```java
public int missingNumber(int[] nums) {
    int n = nums.length;
    int rst = n;
    for(int i =0;i<n;i++){
        rst ^= i^nums[i];
    }
    return rst;
}
```

### 89 !Gray Code 格雷编码
两个连续的数值仅有一个位数的差异。
{% note %}
Input: 2
Output: [0,1,3,2]
Explanation:
00 - 0
01 - 1
11 - 3
10 - 2
{% endnote %}

不会
`G(i) = i^ (i/2)`
```java
public List<Integer> grayCode(int n) {
   List<Integer> rst = new ArrayList<>();
    for(int i =0;i<(1<<n);i++){
        rst.add(i^(i>>>1));
    }
    return rst;
}
```

回溯？
```java
int num = 0;
public List<Integer> grayCodeBack(int n) {
    List<Integer> rst = new ArrayList<>();
    backtrack(rst, n );
    return rst;
}

private void backtrack(List<Integer> rst,int n){
    if(n ==0){
        rst.add(num );
        return;
    }
   else{
        backtrack(rst, n-1);
        num ^= (1<< n-1);
        backtrack(rst, n-1);
    }
}
```


### 338 !Counting Bits 数1-num各数分别有几个1
{% note %}
Input: 2
Output: [0,1,1]
{% endnote %}

不会
0 1 1 2 2 3 
0 1 2 3 4 5
如果偶数，f[n] = f[n/2] 如果奇数f[n] = f[n/2]+1
```java
public int[] countBits(int num) {
    int[] cnt = new int[num+1];
    for(int i = 0;i<num+1;i++){
        cnt[i] = cnt[i/2] + i%2;
    }
    return cnt;
}
```


### 371 !!Sum of Two Integers 不用加减求和
{% note %}
Input: a = 1, b = 2
Output: 3
{% endnote %}

不会x2
```java
public int getSum(int a, int b) {
    int rst = a^b;
    int carry = (a&b)<<1;
    if(carry!=0)return getSum(rst,carry);
    return rst;
}
```

### 201 ！Bitwise AND of Numbers Range 闭区间所有数字的与
{% note %}
输入: [0,1]  [m,n]
输出: 0
{% endnote %}

不会
公共左边的部分。去掉n最右边的1,直到n<=m
```java
public int rangeBitwiseAnd(int m, int n) {
    while(m<n) n = n & (n-1);
    return n;
}
```

### 393. ！UTF-8 Validation
{% note %}
```
   Char. number range  |        UTF-8 octet sequence
      (hexadecimal)    |              (binary)
   --------------------+---------------------------------------------
   0000 0000-0000 007F | 0xxxxxxx
   0000 0080-0000 07FF | 110xxxxx 10xxxxxx
   0000 0800-0000 FFFF | 1110xxxx 10xxxxxx 10xxxxxx
   0001 0000-0010 FFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
```
data = [197, 130, 1], 表示 8 位的序列: 11000101 10000010 00000001.
返回 true 。
这是有效的 utf-8 编码，为一个2字节字符，跟着一个1字节字符。
{% endnote %}

不会
思路：先确定第一个int应该后面带几个10开头的，然后数后面能不能-到0.
```java
public boolean validUtf8(int[] data) {
    int cnt = 0;
    for(int d :data){
        if(cnt == 0){
            if((d >> 5)==0b110)cnt = 1;
            else if((d >> 4) == 0b1110)cnt = 2;
            else if((d >> 3) == 0b11110) cnt = 3;
            else if((d >> 7) == 1)return false;
        }else {
            if((d >> 6)!=0b10)return false;
            cnt--;
        }
    }
    return cnt == 0;
}
```

### 318 ！Maximum Product of Word Lengths 字符串数组中不共享字符的字符串长度的乘积
{% note %}
find the maximum value of length(word[i]) * length(word[j])
输入: ["abcw","baz","foo","bar","xtfn","abcdef"]
输出: 16 
解释: 这两个单词为 "abcw", "xtfn"。
{% endnote %}

不会
思路：每个字符串表示成一个26位的int，如果这两个int & 是0，表示没有重合的位。
```java
public int maxProduct(String[] words) {
    int n = words.length;
    int[] map = new int[n];
    for(int i =0;i<n;i++){
        for(char c : words[i].toCharArray()){
            map[i] |= (1<<(c-'a'));
        }
    }
    int max = 0;      
    for(int i =0;i<n-1;i++){
        for(int j = i+1;j < n;j++){
            if((map[i] & map[j]) == 0){
                max = Math.max(max,words[i].length() * words[j].length());
            }
        }
    }
    return max;
}
```


### 136 Single Number 都出现2次，数组中只出现一次的数字
{% note %}
Input: [4,1,2,1,2]
Output: 4
{% endnote %}
方法2：数学：都出现2次 没想到
$$2(a+b+c)-(a+a+b+b+c)$$ 
`2*sum(set(list))-sum(list)`

方法1：异或 0^12=12,12^12=0 位运算比较熟练
```java
public int singleNumber(int[] nums) {
    int rst = nums[0];
    for(int i = 1;i<nums.length;i++){
        rst ^= nums[i];           
    }
    return rst;
}
```

### 389 Find the Difference 两个字符串打乱后多余的字符
{% note %}
String t is generated by random shuffling string s and then add one more letter at a random position.
Input:
s = "abcd"
t = "abcde"
Output:
e
{% endnote %}

位运算：
'b'异或两次同一个字符，会回到原来的。
异或自己变成0，再异或一个其它字符就是赋值。
```java
public char findTheDifference(String s, String t) {
    int n = t.length();
    char c = t.charAt(n - 1);
    for (int i = 0; i < n - 1; ++i) {
        c ^= s.charAt(i);
        c ^= t.charAt(i);
    }
    return c;
}
```

正常做法：熟练
{% fold %}
```java
public char findTheDifference(String s, String t) {
    int[] cnt = new int[26];
    for(int i =0;i<t.length();i++){
        if(i < s.length())
        cnt[s.charAt(i)-'a']++;
        cnt[t.charAt(i)-'a']--;
    }
    for(int i =0;i<26;i++){
        if(cnt[i] < 0)return (char)(i+'a');
    }
    return ' ';
}
```
{% endfold %}