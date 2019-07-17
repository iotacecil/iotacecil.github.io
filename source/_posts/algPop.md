---
title: 每日Review
date: 2018-10-11 11:13:55
tags:
categories: [算法备忘]
---
熟练度
https://docs.qq.com/sheet/DUGZ6cEtrUFJsSGxP

### 快速排序
插入排序好处：在线算法


### 92 区间反转链表
{% note %}
Input: 1->2->3->4->5->NULL, m = 2, n = 4
Output: 1->4->3->2->5->NULL
{% endnote %}

头插法
start = 2 翻转m-n条边

```java
1->2->3->4->5->NULL
/*
pre = 1
start = 2,next = 3
头插3：保存3，删除3，用dumy头插：修改3.next头插，dumy.next=3
2->4,3->2,1->3
0->1->3->2->4->5
start不变，next是4
头插4：
*/

public ListNode reverseBetween(ListNode head, int m, int n) {
    if(head == null || n == m)return head;
    ListNode dumy = new ListNode(0);
    dumy.next = head;
    ListNode pre = dumy;
    for (int i = 0; i <m-1 ; i++) {
        pre = pre.next;
    }
    ListNode start = pre.next;
    for (int i = 0; i <n-m ; i++) {
        ListNode next = start.next;
        start.next = next.next;
        next.next = pre.next;
        pre.next = next;
    }
    return dumy.next;
}
```

### 25 k个一组反转链表
{% note %}
Given this linked list: 1->2->3->4->5
For k = 2, you should return: 2->1->4->3->5
For k = 3, you should return: 3->2->1->4->5
{% endnote %}

```java
public ListNode reverseKGroup(ListNode head, int k) {
    int cnt = 0;
    ListNode cur = head;
    while(cur!=null && cnt <k){
        cur = cur.next;
        cnt++;
    }       
    if(cnt == k){
        // 4->3->5
         cur = reverseKGroup(cur,k);
        while(cnt-->0){
            ListNode next = head.next;
            head.next = cur;
            cur = head;
            head = next;
        }
        // 关键
        head = cur;
    }  
    return head;   
}
```

### 24 两个一组反转链表
{% note %}
Given 1->2->3->4, you should return the list as 2->1->4->3.
{% endnote %}

```java
public ListNode swapPairs(ListNode head) {
 if(head==null||head.next==null)return head;
    //保留第二个
    ListNode se = head.next;
    //第一个指向第三个，第三个也是同样修改方案返回头指针
    head.next = swapPairs(head.next.next);
    //第二个指向第一个
    se.next = head;
    //返回第二个当作头指针
    return se;
}
```

### 11 选两点容纳的水面积最大
{% note %}
Input: [1,8,6,2,5,4,8,3,7]
Output: 49
{% endnote %}

```java
public int maxArea(int[] height) {
    int n = height.length;
    int left = 0;
    int right = n-1;
    int rst = 0;
    while(left<right){
        int tmp = Math.min(height[left],height[right]) * (right-left);
        rst = Math.max(rst,tmp);
        if(height[left] >height[right])right--;
        else left++;
    }
    return rst;
}
```


### 146 LRU cache HashMap<Integer,DoubleLinkedList>
[Cache replacement policies](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU)
least recently used cache最近最少使用缓存
java:LinkedHashMap:
https://docs.oracle.com/javase/8/docs/api/java/util/LinkedHashMap.html#removeEldestEntry-java.util.Map.Entry-

双向链表+hashmap
{% fold %}
```java
public class LRUCache {
    //双向链表
    class DoubleLinkedNode{
        //和hashmap对应，用于日后扩容
        int key;
        int value;
        DoubleLinkedNode pre;
        DoubleLinkedNode next;
    }
    HashMap<Integer,DoubleLinkedNode> cache;
    int capacity;
    DoubleLinkedNode head;
    DoubleLinkedNode tail;
    //创建一个头节点

    //链表操作：
    //1. get/update中间的node移到链表最前面
    private void move2head(DoubleLinkedNode node){
        /**** star ****/
        this.remove(node);
        this.addNode(node);
    }
    //2. put1 头插
    private void addNode(DoubleLinkedNode node){
        node.pre = head;
        node.next = head.next;

        head.next.pre = node;
        head.next = node;
    }
    //3. put2 删除节点 (1删除中间的，移到最开头 2.删除尾巴)
    private void remove(DoubleLinkedNode node){
        DoubleLinkedNode pre = node.pre;
        DoubleLinkedNode next = node.next;
        pre.next = next;
        next.pre = pre;
    }
    //4.删除尾巴,
    private int removeTail(){
        DoubleLinkedNode pre = tail.pre;
        this.remove(pre);
        return  pre.key;

    }

    public LRUCache(int capacity) {
        cache = new HashMap<>();
        this.capacity = capacity;
        //创建一个头节点
        head = new DoubleLinkedNode();
        head.pre = null;
        //创建一个空尾巴
        tail = new DoubleLinkedNode();
        tail.next= null;

        head.next = tail;
        tail.pre = head;
    }

    public int get(int key) {
        DoubleLinkedNode node = cache.get(key);
        if(node == null)
            return -1;
        move2head(node);
        return node.value;
    }

    public void put(int key, int value) {
        DoubleLinkedNode node = cache.get(key);
        if(node == null) {
            //插入新值
            DoubleLinkedNode newNode = new DoubleLinkedNode();
            newNode.key = key;
            newNode.value = value;
            //1. 考虑容量剩余,满不满都要插入，但是满了要先删除
            if (capacity == 0) {
                //删除尾巴
                int deleteKey = removeTail();
                cache.remove(deleteKey);
                capacity++;
            }
            //2. 插入队列
            addNode(newNode);
            //3. 加入hash
            cache.put(key, newNode);
            capacity--;
        }else {
            node.value = value;
            move2head(node);
        }

    }
}
```
{% endfold %}

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
![reverselist2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/reverselist2.jpg)

空间是n
```java
public ListNode reverseList(ListNode head) {
    if(head == null || head.next == null)return head;
    ListNode second = reverseList(head.next);
    // 1->(second:7->6->5..->2)   (second:7->6->5..->2) ->1->null
    head.next.next = head;
    head.next = null;
    return second;
}
```

---

迭代空间是1：
![reverselist.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/reverselist.jpg)

三个指针pre（注意初始为null),cur,next(只用于cur跳跃),用cur控制结束，一个暂存三个赋值。
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

少一个指针 正确做法
```java
public ListNode reverseList(ListNode head) {
    if(head == null || head.next == null)return head;
   ListNode cur = null;
    while(head!=null){
        ListNode next = head.next;
        head.next = cur; 
        cur = head;
        head = next;
    }
    return cur;   
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