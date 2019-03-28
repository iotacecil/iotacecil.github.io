---
title: alg-stack-queue
date: 2019-03-25 18:56:29
tags: [alg]
categories: [算法备忘]
---
### 373 start和end数组 拼成[start,end] 求start+end最小的k个点对

### 226

### 224 Basic Calculator 有括号的计算器
{% note %}
Input: "(1+(4+5+2)-3)+(6+8)"
Output: 23
{% endnote %}
关键：三个变量一个栈。
遇到括号的时候把之前的值存入stack，一个无括号表达式保留一个rst，遇到符号改sign，用于下一个值的加减，遇到num的时候计算rst，最后一个数字要单独处理。

```java
public int calculate(String s) {
    Deque<Integer> stk = new ArrayDeque<>();
    int rst = 0;
    int num = 0;
    // 下一个数的符号
    int sign = 1;
    for (int i = 0; i <s.length() ; i++) {
        char c = s.charAt(i);
        if(c >= '0' && c <= '9'){
            num = num * 10 + (int)(c-'0');
        }else if(c == '+'){
            rst += sign*num;
            num = 0;
            sign = 1;
        }else if(c == '-'){
            rst += sign*num;
            num = 0;
            sign = -1;
            // 括号开始等于开启一个新的表达式逻辑
            // 并且最后存在rst里的只有括号前的值和括号前的符号
        }else if(c == '('){
            // 先放值再放符号
            stk.push(rst);
            stk.push(sign);
            // 括号开头第一个是正的
            sign = 1;
            // 关键
            rst = 0;
        }else if(c == ')'){
            // rst是当前括号中的表达式值
            rst += sign *num;
            num = 0;
            // 括号前的符号
            rst *= stk.pop();
            // 括号前表达式的值
            rst += stk.pop();
        }
    }
   if(num !=0)rst+=sign*num;
    return rst;
}
```

### 225 Implement Stack using Queues 用栈实现队列
熟练
{% fold %}
```java
class MyQueue {
    // 1 2 3
    Stack<Integer> in;
    Stack<Integer> out;
    /** Initialize your data structure here. */
    public MyQueue() {
       in = new Stack<>();
       out = new Stack<>();
    }
    // in: 1 2 3   pop()-> out:3 2 1-> 3 2   push(4)->
    /** Push element x to the back of queue. */
    public void push(int x) {
        in.push(x);
    }
    
    /** Removes the element from in front of queue and returns that element. */
    public int pop() {
        if(out.isEmpty()){
            while(!in.isEmpty()){
                out.push(in.pop());
            }
             return out.pop();
        }else return out.pop();
       
    }
    
    /** Get the front element. */
    public int peek() {
         if(out.isEmpty()){
            while(!in.isEmpty()){
                out.push(in.pop());
            }
             return out.peek();
        }else return out.peek();
    }
    
    /** Returns whether the queue is empty. */
    public boolean empty() {
        return in.isEmpty()&&out.isEmpty();
    }
}
```
{% endfold %}