---
title: alg-greedy
date: 2019-03-21 18:59:20
tags: [alg]
categories: [算法备忘]
---

<<<<<<< HEAD
### 316 !!!Remove Duplicate Letters 删掉重复字符保证原顺序的   最小字典序 1081 不同字符的最小子序列
去除字符串中重复的字母，使得每个字母只出现一次。需保证返回结果的字典序最小（要求不能打乱其他字符的相对位置）。
{% note %}
输入: "cbacdcbc"
输出: "acdb"
{% endnote %}
=======

### 316 Remove Duplicate Letters 删掉重复字符保证原顺序的   最小字典序
>>>>>>> refs/remotes/origin/hexo-edit

### 122 买卖任意次数的股票
{% note %}
Input: [7,1,5,3,6,4]
Output: 7
Explanation: Buy on day 2 (price = 1) and sell on day 3 (price = 5), profit = 5-1 = 4. Then buy on day 4 (price = 3) and sell on day 5 (price = 6), profit = 6-3 = 3.
{% endnote %}

熟练
只要后一天涨就买。

```java
public int maxProfit(int[] prices) {
    int n = prices.length;
    int rst = 0;
    for(int i = 1;i<n;i++){
        if(prices[i]-prices[i-1]>0){
            rst += prices[i]-prices[i-1];
        }
    }
    return rst;
}
```

### 45. Jump Game II
{% note %}
Input: [2,3,1,1,4]
Output: 2
{% endnote %}

```java
public int jump(int[] nums) {
    int cur = 0;
    int cnt = 0;
    int max = nums[0];
    for(int i = 0;i<nums.length;i++){
        if(cur<i){
            cur=max;
            cnt++;
        }
        max = Math.max(max,i+nums[i]);
    }
    return cnt;
}
```

### 41克以下的宝石
（可能是41克以下不包括41克的任意重量），
他只能携带一个天平和【四个砝码】去称重，请问他会携带哪些重量的砝码？
A1 3 9 27
B1 10 20 30 40
C1 4 16 32
D1 3 10 21

3、9、27可以组成3的倍数，多一克可以加1，少一克可以减1 选A
带了四个砝码，即可以用四个进制位表示。设进制数为n，那么n^0+n^1+n^2+n^3>=40。用等比数列的公式可以求得n=3。所以四个砝码分别是1(3^0)、3(3^1)、9(3^2)、27(3^3)。选A


德·梅齐里亚克的砝码问题
https://baike.baidu.com/item/%E5%BE%B7%C2%B7%E6%A2%85%E9%BD%90%E9%87%8C%E4%BA%9A%E5%85%8B%E7%9A%84%E7%A0%9D%E7%A0%81%E9%97%AE%E9%A2%98
40磅的砝码，由于跌落在地而碎成4块.后来，称得每块碎片的重量都是整磅数，而且可以用这4块来称从1至40磅之间的任意整数磅的重物.
问这4块砝码碎片各重多少？

### lg1658
现在你手上有N种不同面值的硬币，每种硬币有无限多个。为了方便购物，你希望带尽量少的硬币，但要能组合出1到X之间的任意值。
{% note %}
20 4
1 2 5 10

5
{% endnote %}
**如果已经凑出x以内的数(1)，枚举a[i]找到<=x+1的最大数则1-x+a[i]都可以凑出**

从1开始凑，然后凑2，用面值最大的(1,2)凑。
然后可以凑到的最大值为3，下面凑4，用面值最大的(1,2,2)凑。
当前可以凑到最大值是5，下次凑6，用面值最大的(1,2,2,5)凑。
当前可以凑到的最大为10,下次凑11，用面值最大的(1,2,2,5,10)凑。
可以凑的的总数>20 ok

```java
Arrays.sort(coins);
if(coins[0]!=1) System.out.println(-1);
else{
    int cnt = 0;
    //凑最大面值
    int sum = 0;
    while (sum < x){
        int i;
        // 关键
        for (i =n-1; i>=0  ; i--) {
            if (coins[i] <= sum + 1) break;
        }
            cnt++;
            sum+=coins[i];
    }
    System.out.println(cnt);
}
```

