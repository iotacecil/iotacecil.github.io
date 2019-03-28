---
title: algBacktrack
date: 2019-03-07 21:35:31
tags: [alg]
categories: [算法备忘]
---
### 139 word break 用字典中的此能否拆分字符串
{% note %}
输入: s = "applepenapple", wordDict = ["apple", "pen"]
输出: true
解释: 返回 true 因为 "applepenapple" 可以被拆分成 "apple pen apple"。
     注意你可以重复使用字典中的单词。
{% endnote %}

**memory方法1：用set记录不能划分的位置**
**memory方法2：用set记录划分过的单词**

9ms 77%

```java
public boolean wordBreak(String s, List<String> wordDict) {
    Set<String> set = new HashSet<>();
    HashSet<String> wd = new HashSet<>(wordDict);
    return canBreak(s,wd,set);
}
private boolean canBreak(String s,Set<String> wordDict,Set<String> set){
   if(s.isEmpty()){
       return true;
   }
    if(set.contains(s)){
        return false;
    }
    set.add(s);
   for(String word : wordDict){
       if(s.startsWith(word) && canBreak(s.substring(word.length()), wordDict, set)){
           return true;
       }
   }
    return false;
}
```


1.状态：boolean[n+1]长度为i的前缀能否由字典组成
2.初始值：[0]=true 空字符串
3.转移方程if(dp[i]==true&&dic.contains(sub(i,i+j))) dp[i+j]=true
4.结果

6ms 88%
```java
public boolean wordBreak(String s, List<String> wordDict) {
    int n = s.length();
    boolean[] cb = new boolean[n+1];
    cb[0] = true;
    for(int k = 1;k < n + 1;k++){
        for(int st = 0;st < k;st++){
        if(cb[st] && wordDict.contains(s.substring(st,k))){
            cb[k] = true;
            break;
        }
        }
    }
    return cb[n];
}
```


### 90 有重复的subset[1,2,2,2]
1. 选不同的2得到{1,2}是重复的
2. 次序不同得到{1,2},{2,1}是重复的
先排序，再去重。
关键：`i!=idx` 当[2,2]idx+1那次不应该被去重

```java
public List<List<Integer>> subsetsWithDup(int[] nums) {
    Arrays.sort(nums);
    List<List<Integer>> rst = new ArrayList<>();
    dfs(new ArrayList<>(),rst,nums,0);
    return rst;
}
private void dfs(List<Integer> tmp,List<List<Integer>> rst,int[] nums,int idx){
    rst.add(new ArrayList<>(tmp));
    for(int i = idx;i<nums.length;i++){
        if(i!=idx && nums[i] == nums[i-1])continue;
        tmp.add(nums[i]);
        dfs(tmp,rst,nums,i+1);
        tmp.remove(tmp.size()-1);
    }
}
```

还有一种迭代计数的方法//todo

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
        // 易错 i+1不是idx+1
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