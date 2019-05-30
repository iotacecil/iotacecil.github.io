---
title: alg-cd
date: 2019-05-29 20:39:39
tags: [alg]
categories: [算法备忘]
---
### 440 字典序的第k小
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
