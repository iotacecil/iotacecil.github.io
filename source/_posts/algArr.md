---
title: algArr
date: 2019-03-04 19:38:25
tags: [alg]
categories: [算法备忘]
---
### 229 Majority Element II
找到所有出现次数超过 ⌊ n/3 ⌋ 次的数字
{% note %}
Input: [3,2,3]
Output: [3]
{% endnote %}

### !!!169 众数 Boyer-Moore Voting Algorithm 
{% note %}
Input: [3,2,3]
Output: 3
{% endnote %}
关键：计数变量
```java
public int majorityElement(int[] nums) {
    int rst = 0;
    int cnt =0;
    for(int num:nums){
        if(cnt == 0){
            rst = num;
        } 
        if(rst != num){
            cnt--;
        }else{
            cnt++;
        }    
    }
    return rst;
}
```

{% fold %}
1.hashmap,直到有计数>n/2 break->return 11%
2.随机数44% 因为一半以上都是这个数，可能只要循环两边就找到了
```java
public int majorityElement(int[] nums){
    Random random = new Random(System.currentTimeMillis());
    while(true){
        int idx = random.nextInt(nums.length);
        int choose = nums[idx];
        int cnt = 0;
        for(int num:nums){
            if(num==cur&&++cnt>nums.length/2)return num;
        }
    }
}
```
3.39% 计算用每个数字的每一位投票，1的个数>n/2则为1 
```java
public int majorityElement(int[] nums){
    int n = nums.length;
    int rst =0;
    int mask =0;
    for(int i=0;i<32;i++){
        mask = 1<<i;
        int cnt =0;
        for(int num:nums){
            if((num&mask)!=0)cnt++;
        }
        if(cnt>n/2)rst|=mask;
    }
    return rst;
}
```

#### 4.moore voting 在线算法92%
```java
public int majorityElement(int[] nums){
    //假设就是第一个数
    int maj = nums[0];
    int cnt=0;
    for(int num:nums){
        //第一个数就cnt=1
        if(num==maj)cnt++;
        else if(--cnt==0){
            //等于0 从头开始做
            cnt=1;
            maj = num;
        }
    }
    return maj;
}
```
**优化100%**
每次取两个不同的数删除，最后剩下的返回
{% fold %}
```java
class Solution {
    public int majorityElement(int[] nums) {
        if(nums==null)return -1;
        int res=0;
        int count=0;
        for(int e : nums){
            if(count==0){
                res=e;
            }
                if(res!=e){
                    count--;//删除这个数
                }
                else count++;
        }
        return res;
    }
}
```
{% endfold %}

5.排序取中间的数
6.C++专有 部分排序
```cpp
int majorityElement(vector<int> & nums){
    nth_element(nums.begin(),nums.begin()+nums.size()/2,nums.end());
    return nums[nums.size()/2];
}
```
7.分治???
{% endfold %}

### 119 ！Pascal's Triangle II 帕斯卡三角形的第k行
{% note %}
Input: 3
Output: [1,3,3,1]
{% endnote %}
不会


### 118 Pascal's Triangle
{% note %}
Input: 5
Output:
```
[
     [1],
    [1,1],
   [1,2,1],
  [1,3,3,1],
 [1,4,6,4,1]
]
```
{% endnote %}

```java
public List<List<Integer>> generate(int numRows) {
    List<List<Integer>> rst = new ArrayList<>();
    for(int i = 0;i<numRows;i++){
        List<Integer> row = new ArrayList<>();
        row.add(1);
        for(int j = 1;i>1&&j<i;j++){
            row.add(rst.get(i-1).get(j-1)+rst.get(i-1).get(j));
        }
        if(i>0)row.add(1);
        rst.add(row);
    }
    return rst;
}
```

### 134 ！Gas Station 环形加油站出发点
找到一个起点可以获得gas[i]汽油，到下一个花费cost[i]可以遍历完所有加油站回到起点的点。
{% note %}
Input: 
gas  = [1,2,3,4,5]
cost = [3,4,5,1,2]
Output: 3
{% endnote %}

AC但是方法不对
前段总的余量为负，即油不够用，要想有解，那么后段油量应该为正，此时才可能有解.

反之，如果前段就为正了，那么显然可以直接选择前面的点为起点；

如果整段加起来都是负的，那么无解

```java
public int canCompleteCircuit(int[] gas, int[] cost) {
   int sum = 0;int total = 0;int rst = 0;
    for(int i = 0;i<gas.length;i++){
        sum += (gas[i]-cost[i]);       
        if(sum<0){
            total +=sum;
            rst = i+1;
            sum = 0;
        }     
    }
    total +=sum;
    return total>=0?rst:-1;
}
```

### 299 !Bulls and Cows 猜对了几个字符
{% note %}
A表示位置对+数值对，B表示位置不对。
Input: secret = "1123", guess = "0111"
Output: "1A1B"
{% endnote %}

关键：计数，如果secret当前字符的计数<0，表示在guess出现过，b++,然后再计数这个字符。
注意对secret和guess的当前字符都判断是否之前出现过，分别计数b。

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