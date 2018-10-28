---
title: 二叉树、链表基础操作
date: 2018-10-11 11:13:55
tags:
categories: [算法备忘]
---

### 23 k个链表merge
正确解法：分治8ms 96% 复杂度kNlogk
每次合并2个，需要2n,第一次有k/2对用mergeTwo.第一次的复杂度是 kn
总共有log k 次迭代，总的复杂度 kn log k
```java
public ListNode mergeKLists(ListNode[] lists) {
   if(lists.length ==0)return null;
    if(lists.length == 1) return lists[0];
    if(lists.length == 2){
        return mergeTwoLists(lists[0],lists[1] );
    }
    int mid = lists.length / 2;
    ListNode[] sub1 = new ListNode[mid];
    ListNode[] sub2 = new ListNode[lists.length - mid];
    for (int i = 0; i < mid; i++) {
        sub1[i] = lists[i];
    }
    for (int i = mid; i <lists.length; i++) {
        sub2[i-mid] =  lists[i];
    }
    ListNode listNode1 = mergeKLists(sub1);
    ListNode listNode2 = mergeKLists(sub2);
    return mergeTwoLists(listNode1, listNode2);
}
```
其他同样有nk log k的 用堆 heapify logk,从堆中取nk次最小

解法2： 86ms全部先放在一起，排序，再遍历组成一个链表
复杂度 knlog(kn) + kn
```java
 public ListNode mergeKLists(ListNode[] lists) {
   List<ListNode> all = new ArrayList<>();

    for(ListNode node : lists){
       while (node!=null){
            all.add(node);
            node = node.next;
        }
    }
    all.sort((l1,l2)->l1.val-l2.val);
    ListNode tmp = new ListNode(-1);
    ListNode pre = tmp;
    for(ListNode node :all){
        pre.next = node;
        pre = pre.next;
    }
    return tmp.next;
}
```

暴力解每次向后合并一个 309 ms
复杂度： 有k个链表，平均长度n
第一次最长比较(n+n)次， 第二次合并最差比较(2n+n)次....直到最后一步k-1个链表合并后和最后一个链表合并(k-1)n+n
复杂度(k^2 n)
```java
public ListNode mergeKLists(ListNode[] lists) {
    if(lists == null || lists.length <1){
        return null;
    }
    if(lists.length == 1){
        return lists[0];
    }
    ListNode tmp = lists[0];
    for(int i =1;i<lists.length;i++){
        tmp = mergeTwoLists(tmp,lists[i]);
    }
    return tmp;
}
```

### 21 链表merge
递归todo
```java
public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
   ListNode tem_head = new ListNode(-1);
   ListNode pre = tem_head;
   while (l1 != null && l2 != null){
       if(l1.val < l2.val){
         pre.next = l1;
         l1 = l1.next;
       }else{
           pre.next = l2;
           l2 = l2.next;
       }
       pre = pre.next;
   }
   if(l1!=null){
       pre.next = l1;
   }
   if(l2!=null){
       pre.next =l2;
   }
   return tem_head.next;
}
```

### 24两个一组交换链表

#### 创建链表    
list->nodelist 会stackOverflow
```java
Node create(List<Integer> data){
    Node first = new Node(data.get(0));
    Node sub = create(data.subList(1,data.size()));
    first.next=sub;
    return first;
}
```
---
迭代：
```java
Node pre = null;
Node head =null;
for(1 to size){
    Node node = new Node(i);
    if(pre!=null){
        pre.next =node;
    }else{
        head = node;
    }
    pre = node;
}
return head;
```

#### 链表DELETE_IF
```java

```

### 92反转从m到n的链表 一趟扫描


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
三个指针pre,cur,next
```java
Npublic ListNode reverseList(ListNode head) {
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


转成栈浪费空间并且代码复杂

### 二叉树

### lt66二叉树前序遍历 分治方法
分治方法，返回值 适合多线程
```java
public List<Integer> preorderTraversal(TreeNode root) {
    List<Integer> rst = new ArrayList<>();
    if(root == null){
        return rst;
    }
    // Divide
    List<Integer> left = preorderTraversal(root.left);
    List<Integer> right = preorderTraversal(root.right);
    // Conquer
    rst.add(root.val);
    rst.addAll(left);
    rst.addAll(right);
    return rst;
}
```

一般方法，返回值void 用的返回值在参数里
{% fold %}
```java
public List<Integer> preorderTraversal(TreeNode root) {
   List<Integer> rst = new ArrayList<>();
   helper(root,rst);
   return rst;
}
private void helper(TreeNode root,List<Integer> rst){
    if(root == null){
        return;
    }
    rst.add(root.val);
    helper(root.left,rst);
    helper(root.right,rst);
}
```
{% endfold %}

### !!!114原地将二叉树变成链表
1.入栈迭代40%
    1. 先入栈右子树，再入栈左子树，更新右节点为栈顶。
    2. 将当前左子树变成null。下一次循环cur是栈顶（原左子树）
2. 后序遍历 递归6%
```java
pre = null;
flat(root.right);
flat(root.left);
root.right = pre;
root.left = null;
pre = root;
```

### 前序中序构造二叉树
A BDEG CF
DBGE A CF
```java
public TreeNodeT<Character> createTree(String preOrder,String inOrder){
    if(preOrder.isEmpty())return null;
    char rootVal = preOrder.charAt(0);
    int leftLen = inOrder.indexOf(rootVal);
    TreeNodeT<Character> root = new TreeNodeT<Character>(rootVal);
    root.left = createTree(
            preOrder.substring(1,1+leftLen),
            inOrder.substring(0,leftLen));

    root.right = createTree(
            preOrder.substring(1+leftLen),
            inOrder.substring(leftLen+1));
    return root;
}
```

### 二叉树深度
```java
public int maxDepth(TreeNode root) {
     if(root== null)return 0;
    return Math.max(maxDepth(root.left),maxDepth(root.right))+1;
}
```
dfs1 用map存储每个node的深度
```java
public int maxDepth(TreeNode root) {
    if (root == null) {
        return 0;
    }
    Map<TreeNode, Integer> depthMap = new HashMap<>();
    depthMap.put(root, 1);
    int maxDepth = 1;
    Stack<TreeNode> stack = new Stack<>();
    stack.push(root);
    while (!stack.isEmpty()) {
        root = stack.pop();
        int depth = depthMap.get(root);
        maxDepth = Math.max(maxDepth, depthMap.get(root));
        if (root.right != null) {
            depthMap.put(root.right, depth + 1);
            stack.push(root.right);
        }
        if (root.left != null) {
            depthMap.put(root.left, depth + 1);
            stack.push(root.left);
        }
        depthMap.remove(root);
    }
    return maxDepth;
}
```
dfs:
```java
public static int maxDepthDFS(TreeNode root) {
    if(root==null)return 0;
    Deque<TreeNode> stack = new ArrayDeque<>();
    Deque<Integer> value = new ArrayDeque<>();
    stack.push(root);
    value.push(1);
    int max = 0;
    while (!stack.isEmpty()){
        TreeNode node = stack.pop();
        int tmp = value.pop();
        max = Math.max(tmp, max);
        if(node.left!=null){
            stack.push(node.left);
            value.push(tmp+1);
        }
        if(node.right!=null){
            stack.push(node.right);
            value.push(tmp+1);
        }

    }
    return max;
}
```

bfs
```java
public static int maxDepth(TreeNode root) {
   if(root == null)return 0;
    Deque<TreeNode> que = new LinkedList<>();
    que.add(root);
    int cnt = 0;
    while (!que.isEmpty()){
        int size = que.size();
        while (size-->0){
            TreeNode cur = que.poll();
            if(cur.left!=null)que.add(cur.left);
            if(cur.right!=null)que.add(cur.right);
        }
        cnt++;
    }
    return cnt;
}
```