---
title: alg-greedy
date: 2019-03-21 18:59:20
tags: [alg]
categories: [算法备忘]
---
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

思路：
1.从左向右扫，把所有上升序列设置成从1开始的递增糖数
2.从右向左扫，更新右边向左边的递增糖数。
```java
public int candy(int[] ratings) {
    int n = ratings.length;
    int[] nums = new int[n];
    nums[0] = 1;
    for(int i = 1;i<n;i++){
        // 1 2 3 4
        if(ratings[i-1] < ratings[i]){
            nums[i] = nums[i-1]+1;
        }else nums[i]  = 1;
    }
    for(int i = n-1;i>0;i--){
        if(ratings[i-1] > ratings[i]){
            nums[i-1] = Math.max(nums[i] + 1, nums[i-1]); 
        }
    }
    int rst = 0;
    for(int num:nums){
        rst += num;
    }
    return rst;
}
```