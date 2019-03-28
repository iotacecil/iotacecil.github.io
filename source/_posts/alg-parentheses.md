---
title: 括号相关
date: 2019-03-27 19:58:00
tags: [alg]
categories: [算法备忘]
---
### 301 ！！！Remove Invalid Parentheses 删除无效括号
删除数量最少的所有正确可能
{% note %}
输入: "(a)())()"
输出: ["(a)()()", "(a())()"]
{% endnote %}

### 241 !!! Different Ways to Add Parentheses 给运算表达式加括号改变优先级
{% note %}
输入: "2-1-1"
输出: [0, 2]
解释: 
((2-1)-1) = 0 
(2-(1-1)) = 2
{% endnote %}

本质是wrod break

### ？？？括号串达到匹配需要最小的逆转次数
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

### !!! 32 Longest Valid Parentheses 字符串中最长有效括号子串
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