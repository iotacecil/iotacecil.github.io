---
title: 每日Review
date: 2018-10-11 11:13:55
tags:
categories: [算法备忘]
---
### 946 栈顺序
{% note %}
Input: pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
Output: true
{% endnote %}
```java
public boolean validateStackSequences(int[] pushed, int[] popped) {
     Deque<Integer> stk = new ArrayDeque<>();
    int i = 0;
    for (int p : pushed) {
        stk.push(p);
        while (!stk.isEmpty() && stk.peek() == popped[i]) {
            stk.pop();
            ++i;
        }
    }
    return stk.isEmpty();
}
```

### 206反转链表
空间是n
```java
public ListNode reverseList(ListNode head) {
    if(head == null || head.next == null)return head;
    ListNode second = reverseList(head.next);
    // 注意 不是second.next 因为second永远是最后一个 5，5->4,5->4->3
    // 而head.next肯定是second链表的最后一个非null的5,4,3..
    head.next.next = head;
    head.next = null;
    return second;
}
```
---
迭代空间是1：
三个指针pre,cur,next,用cur控制结束，一个暂存三个赋值。
```java
public ListNode reverseList(ListNode head) {
    if(head == null || head.next == null)return head;
    ListNode prev = null;
    ListNode curr = head;
    while(curr != null){
        ListNode next = curr.next;
        curr.next = prev;
        prev = curr;
        curr = next;
    }
    return prev;
}
```

python
```python
def reverseList(self, head):
        cur,prev = head,None
        while cur:
            cur.next,prev,cur = prev,cur,cur.next
        return prev
```


转成栈浪费空间并且代码复杂

### 24 Swap Nodes in Pairs 两个一组反转链表
{% note %}
Given 1->2->3->4, you should return the list as 2->1->4->3.
{% endnote %}

### 141链表环检测
空间O(1) 快慢指针：快指针走2步，慢指针走一步，当快指针遇到慢指针
最坏情况，快指针和慢指针相差环长q -1步
{% fold cpp练习 %}
```java
class Solution{
    public:
    bool hasCycle(ListNode *head) {
        auto slow = head;
        auto fast = head;
        while(fast){
            if(!fast->next)return false;
            fast = fast->next->next;
            slow = slow->next;
            if(fast == slow) return true;
        }
        return false;
    }
};
```
{% endfold %}

### 142 环起始于哪个node
![loops.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/loops.jpg)
1->2->3->4->5->6->7->3 meet:6
a: 从head到环 
b：快指针走了两次的环内距离(慢指针到环起点的距离)
c: 慢指针没走完的环内距离
已知快指针走的距离是slow的两倍
慢=a+b  快=a+2b+c
则a=c
从len(head - 环起点) == 慢指针没走完的环距离
**head与慢指针能在环起点相遇。**
```java
if(slow==fast){
    while(head!=slow){
        head=head.next;
        slow=slow.next;
    }
    return slow;
}
```