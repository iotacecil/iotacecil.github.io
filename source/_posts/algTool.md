---
title: algTool 正则
date: 2018-10-09 19:16:41
tags: [alg]
categories: [算法备忘]
---
### 判断小括号匹配
```java
public boolean isValid(String s){
    int cnt = 0;
    for (int i = 0; i < s.length() ; i++) {
        char c = s.charAt(i);
        if(c == '('){
            cnt++;
        }
        if(c ==')' && cnt-- == 0){
            return false;
        }
    }
    return cnt == 0;
}
```

### 459 一个字符串是不是由一个子串重复构成的
>输入: "abab"
>输出: True

```java
public boolean repeatedSubstringPattern(String str) {
    //This is the kmp issue
     return str.matches("(.+)\\1+");
}
```


### 65 Valid Number 常用判断是否是小数整数，带e的浮点数
https://blog.csdn.net/mrzhangjwei/article/details/53409967
//1.65%非常慢
```java
public boolean isNumber(String s) {
  s = s.trim();
  if (s.length() == 0 || s.equals("e")  || s.equals(".")) return false;
  return isFloating(s) || isRegular(s);
}

// parses non-floating point literals
private boolean isRegular(String s) {
  return (s.matches("[+-]?[0-9]+[.]?[0-9]*") || s.matches("[+-]?[0-9]*[.]?[0-9]+"));
}

// parses floating point literals as defined here: http://en.cppreference.com/w/cpp/language/floating_literal
private boolean isFloating(String s) {
  //first one enforces an number after ., the second one enforces a number before .
  // we want to make sure there's at least one number present.
  return (s.matches("[+-]?[0-9]*[.]?[0-9]+[eE][-+]?[0-9]+[f]?") || s.matches("[+-]?[0-9]+[.]?[0-9]*[eE][-+]?[0-9]+[f]?"));
}

//4%
public boolean isNumber(String s) {
    if (s.trim().length()==0) return false;
    String regexp = "^(\\+|-)?([0-9]+(\\.[0-9]*)?|\\.[0-9]+)(e(\\+|-)?[0-9]+)?$";
    return s.trim().replaceAll(regexp,"").length()==0;

}
```

### 无向图 弗洛伊德算法 扩充全部最短路径
```java
// 读取无向图 cost矩阵
//[i][i] = 0 没有路径是inf
map = new int[n][n];
for (int i = 0; i < n; i++) {
    Arrays.fill(map[i], inf);
    map[i][i] = 0;
}
//path 只保留最短
for (int i = 1; i <= m; i++) {
    u = nextInt();
    v = nextInt();
    val = nextInt();
    map[v][u] = map[u][v] = Math.min(map[u][v], val);
}
//弗洛伊德
for (int k = 0; k < n; k++)
for (int i = 0; i < n; i++) {
    //可去
    if (map[i][k] == inf)
        continue;
    for (int j = 0; j < n; j++) {
        //可去
        if (map[k][j] == inf)
            continue;
        map[j][i] = map[i][j] = Math.min(map[i][j], map[i][k]
                + map[k][j]);
    }
}
```

### 最大公约数gcd 复杂度O(log(max(a,b)))
```java
public static long gcd(long a, long b) {
    return (b == 0) ? a : gcd(b, a % b);
}
```


### 素数


### 正确二分查找的写法
first/last po
```java
int binarySearch(int[] A,int target){
    if(A.length==0){
        return -1;
    }
    int start = 0;
    int end = A.length-1;
    int mid;
    while(start+1<end){
        mid = start + (end-start) / 2;
        if(A[mid]==target){
            //find last
            //start = mid;
            end = mid;
        }else if(A[mid]<target){
            start = mid;
        }else{
            end = mid;
        }
    }
    //find last 先判断end的if
    if(A[start] == target){
        return start;
    }
    if(A[end] == target){
        return end;
    }
    return -1;
}
```
1.查找范围是 [0,len-1]
[0]：l=0,r=1-1，while(l==r)的时候应该继续
```java
int l = 0,r=n-1;
while(l<=r){
    int mid = l+(r-l)/2;
    if(arr[mid]==target){
        return mid;
    }
    else if(arr[mid]<target){
        l=mid+1;//
    }
    else{
        r=mid-1;
    }
}
//如果l>r
return -1;
```
2.[0,len) 保持len取不到 
[0]:l=0,r=1,l++,while(l==r)的时候应该结束
好处：len就是长度[a,a+len)，[a,b)+[b,c)=[a,c),[a,a)是空的
```java
int l = 0,r = n;
while(l<r){
    int mid = l+(r-l)/2;
    if(arr[mid]==target)return mid;
    if(arr[mid]>target){
        //在左边，边界为取不到的数
        r=mid;//[l,mid)
    }else{
        //左闭又开
        l = mid+1;//[mid+1,r)
    }
}
//如果l==r [1,1)表示空的
return -1;
```

### lt 458 lastIndexOf
```java
public int lastPosition(int[] nums, int target) {
    if(nums==null||nums.length<1)return -1;
    int i = 0, j = nums.length-1;
    while(i<=j){
        int mid = (i+j)/2;
        if(nums[mid]>target)j = mid-1;
        //找到了继续向右找
        else i =mid+1;
    }
    if(j<0)return-1;
    if(nums[j]==target) return j; 
        return -1;
}
```

### 34 二分查找数字的first+last idx
> Input: nums = [5,7,7,8,8,10], target = 8
> Output: [3,4]
> Input: nums = [5,7,7,8,8,10], target = 6
Output: [-1,-1]

二分查找获取最左/右边相等的

```java
public int[] searchRange(int[] a, int k) {
    if(a==null||a.length<1)return new int[]{-1,-1};
    int first = lowerBound(a, k);
    if(first==a.length||a[first]!=k)return new int[]{-1,-1};
    int last = upper_bound(a, k);
    last = last==-1||a[last]!=k?-1:last;
    return new int[]{first,last};
}
```

### lower_bound lc35
二分搜索
lowerBound 
```java
/*
    满足ai>=k条件的最小i
* nums[index] >= target, min(index)
*/
public static int lowerBound(int[] nums, int target) {
    if (nums == null || nums.length == 0) return -1;
    int lb = -1, ub = nums.length;
    while (lb + 1 < ub) {
        int mid = lb + (ub - lb) / 2;
        if (nums[mid] >= target) {
            ub = mid;
        } else {
            lb = mid;
        }
    }
    return ub;
}
```

upper_bound
ai<=k 的最大i
```java
public static int upper_bound(int[] a,int k){
    if (a == null || a.length == 0) return -1;
    int lb = -1,ub = a.length;
    while (ub - lb > 1) {
        int mid = (lb+ub)/2;
        if(a[mid]<=k){
            lb = mid;
        }else
            ub = mid;
    }
    return lb;
}
```

### java快速io
```java
import java.io.*;
int test = nextInt();
out.println("Case #" + ttt + ":");
out.println(ans);

out.flush();
out.close();

static BufferedReader br = new BufferedReader(new InputStreamReader(
        System.in));
static StreamTokenizer in = new StreamTokenizer(br);
static PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));

static String next() throws IOException {
    in.nextToken();
    return in.sval;
}

static char nextChar() throws IOException {
    in.nextToken();
    return in.sval.charAt(0);
}

static int nextInt() throws IOException {
    in.nextToken();
    return (int) in.nval;
}

static long nextLong() throws IOException {
    in.nextToken();
    return (long) in.nval;
}

static float nextFloat() throws IOException {
    in.nextToken();
    return (float) in.nval;
}

static double nextDouble() throws IOException {
    in.nextToken();
    return in.nval;
}
```
