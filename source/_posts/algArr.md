---
title: algArr
date: 2019-03-04 19:38:25
tags: [alg]
categories: [算法备忘]
---

### 299 Bulls and Cows 猜对了几个字符
{% note %}
A表示位置对+数值对，B表示位置不对。
Input: secret = "1123", guess = "0111"
Output: "1A1B"
{% endnote %}

关键：计数，如果secret当前字符的计数<0，表示在guess出现过，b++,然后再计数这个字符。注意对secret和guess的当前字符都判断是否之前出现过，分别计数b。

```java
public String getHint(String secret, String guess) {
    int bulls = 0;
    int cows = 0;
    int[] numbers = new int[10];
    for (int i = 0; i<secret.length(); i++) {
        if (secret.charAt(i) == guess.charAt(i)) bulls++;
        else {
            if (numbers[secret.charAt(i)-'0']++ < 0) cows++;
            if (numbers[guess.charAt(i)-'0']-- > 0) cows++;
        }
    }
    return bulls + "A" + cows + "B";
}
```

### 41 !First Missing Positive 数组中第一个不存在的正数
{% note %}
Input: [1,2,0]
Output: 3
{% endnote %}

不会 思路：用[0-n-1]存储数组中出现的[1-n]如果超出长度不计，再遍历一遍第一个没标记的
```java
public int firstMissingPositive(int[] nums) {
    int n = nums.length;
    if(n<1)return 1;
    int i = 0;
    while(i<n){
        if(nums[i]>0 && nums[i]-1<n && i!=nums[i]-1 && nums[nums[i]-1]!=nums[i] ){
            swap(nums,i,nums[i]-1);
        }
        else i++;
    }
    i = 0;
    while(i<n){
        if(i+1!=nums[i])break;
        i++;
    }
    return i+1;
    
}
private void swap(int[] arr,int i,int j){
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}
```

### 189 Rotate Array 旋转数组
{% note %}
Input: [1,2,3,4,5,6,7] and k = 3
Output: [5,6,7,1,2,3,4]
{% endnote %}
注意划分[0,k-1],[k,n-1]
```java
public void rotate(int[] nums, int k) {
    int n = nums.length;
    if(n<2 || k == 0)return;
    k %= n;
    reverse(nums,0,n-1);
    reverse(nums,0,k-1);
    reverse(nums,k,n-1);
    
}
private void reverse(int[] nums,int i,int j){
    while(i<j){
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
        i++;j--;
    }
}
```

### 277 Find the Celebrity (lintcode)
 Celebrity Problem 所有人都认识他但是他不认识所有人
方法1：找全是0的行，O(n^2)
方法2： 如果A认识B，则A肯定不是名人 O(N)；A不认识B，则A可能是名人，B肯定不是名人
A,B不认识，重新入栈A
![celebrity.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/celebrity.jpg)
A,C认识，入栈C
![celebrity2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/celebrity2.jpg)
![celebrity3.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/celebrity3.jpg)

方法3：双指针
```java
int findCele(int[][]Matrix){
    int n = Matrix.length;
    int a = 0;
    int b = n-1;
    while (a<b){
        if(Matrix[a][b]==1){
            a++;
        }
        else{
            b--;
        }
    }
    for (int i = 0; i <n ; i++) {
        //不是自己，但是别人不认识他，或者他认识别人
        if(i!=a&&Matrix[i][a]!=1||Matrix[a][i]==1)
            return -1;
    }
    return a;
}
```

### 80 !Remove Duplicates from Sorted Array II有序数组只保留每个2个不同元素
{% note %}
Given nums = [1,1,1,2,2,3],
length = 5
{% endnote %}
调了好久
```java
public int removeDuplicates(int[] nums) {
    int i = 0;
    for (int n : nums)
        if (i < 2 || n > nums[i-2])
            nums[i++] = n;
    return i;
}
```

### 26 ！Remove Duplicates from Sorted Array 有序数组只保留不同元素
{% note %}
Given nums = [1,1,2],
2
{% endnote %}
长度bug调了好久
```java
public int removeDuplicates(int[] nums) {
    int n = nums.length;
    if(n<2)return n;
    int cnt = 1;
    for(int i =1;i<n;i++){
        if(nums[i]-nums[i-1]>0){
            nums[cnt++] = nums[i];
        }
    }
    return cnt;
}
```

### 27 Remove Element
熟练

### 121 Best Time to Buy and Sell Stock 只能买卖一次 买卖股票的利润
> 输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。

能一次AC 熟练
```java
 public int maxProfit(int[] prices) {
    if(prices.length <1)return 0;
    // 之前最低
    int pre = prices[0];
    int rst = 0;
    for(int i = 1;i < prices.length;i++){
        rst = Math.max(rst,prices[i]-pre);
        pre = Math.min(pre,prices[i]);
    }
    return rst;
}
```