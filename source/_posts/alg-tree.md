---
title: alg-tree
date: 2019-03-29 14:44:55
tags: [alg]
categories: [算法备忘]
---
### 114 Flatten Binary Tree to Linked List
{% note %}
```
in:
    1
   / \
  2   5
 / \   \
3   4   6
out:
1
 \
  2
   \
    3
     \
      4
       \
        5
         \
          6
```
{% endnote %}
用一个全局变量保存右边flatten好的根节点，移动到当前flatten节点的右边。
后序遍历，并且先右节点再左节点。
```java
TreeNode prev = null;
public void flatten(TreeNode root) {
    if(root == null)return;
    flatten(root.right);
    flatten(root.left);
    root.right = prev;
    root.left = null;
    prev = root;
}
```


### 513. Find Bottom Left Tree Value
{% note %}
Input:
```
    1
   / \
  2   3
 /   / \
4   5   6
   /
  7
```
Output:
7
{% endnote %}

```java
public int findBottomLeftValue(TreeNode root) {
    Deque<TreeNode> que = new ArrayDeque<>();
    que.add(root);
    int rst = root.val;
    while(!que.isEmpty()){
        int size = que.size();
        rst = que.peek().val;
        while(size-- >0){
            TreeNode tmp = que.poll();
            if(tmp.left!=null)que.add(tmp.left);
            if(tmp.right!=null)que.add(tmp.right);
        }
    }
    return rst;
}
```

