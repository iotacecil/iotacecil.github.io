---
title: algBacktrack
date: 2019-03-07 21:35:31
tags: [alg]
categories: [算法备忘]
---
### ?90 有重复的subset[1,2,2,2]
1. 选不同的2得到{1,2}是重复的
2. 次序不同得到{1,2},{2,1}是重复的
先排序，再去重。

### 78 subset 数组的子集
```java
public List<List<Integer>> subsets(int[] nums) {
    List<List<Integer>> rst = new ArrayList<>();
    back(rst,new ArrayList<>(),nums,0);
    return rst;
    }
private void back(List<List<Integer>> rst,List<Integer> item,int[] nums,int index){
    rst.add(new ArrayList<>(item));
    for(int i =index;i<nums.length;i++){
        item.add(nums[i]);
        back(rst,item,nums,i+1);
        item.remove(item.size()-1);
    }
}
```
位运算迭代：
```java
public List<List<Integer>> subsets(int[] nums) {
    List<List<Integer>> rst = new ArrayList<>();
    int n = nums.length;
    for(int i = 0;i<(1<<n);i++){
        List<Integer> tmp = new ArrayList<>();
        for(int j = 0;j<n;j++){
            if(((i>>j)&1)==1){
                tmp.add(nums[j]);
            }
        }
        rst.add(tmp);
    }
    return rst;
}
```