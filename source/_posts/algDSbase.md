---
title: 二叉树、链表基础操作
date: 2018-10-11 11:13:55
tags:
categories: [算法备忘]
---
### 二叉树

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