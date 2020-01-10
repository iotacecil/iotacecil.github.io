---
title: alg-tree
date: 2019-03-29 14:44:55
tags: [alg]
categories: [算法备忘]
---
### 297 序列化/反序列化二叉树
```java
private static final String spliter = ",";
 private static final String NN = "X";

 public String serialize(TreeNode root){
     StringBuilder sb = new StringBuilder();
      buildString(root,sb);
     return sb.toString();
 }

 private void buildString(TreeNode node,StringBuilder sb){
     if(node == null){
         sb.append(NN).append(spliter);
     }else{
         sb.append(node.val).append(spliter);
         buildString(node.left,sb);
         buildString(node.right,sb);
     }
 }

 public TreeNode deserialize(String data){
     Deque<String> nodes = new LinkedList<>();
     nodes.addAll(Arrays.asList(data.split(spliter)));
     return buildTree(nodes);
 }

 private TreeNode buildTree(Deque<String> nodes){
     String val = nodes.remove();
     if(val.equals(NN))return null;
     else{
         TreeNode node = new TreeNode(Integer.valueOf(val));
         node.left = buildTree(nodes);
         node.right = buildTree(nodes);
         return node;
     }
 }
```

### 652 重复子树

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

