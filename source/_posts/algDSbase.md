---
title: 二叉树、链表基础操作
date: 2018-10-11 11:13:55
tags:
categories: [算法备忘]
---

### 863 二叉树路径距离K步的node

### 124 二叉树中最大路径和

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


### 92反转从m到n的链表 一趟扫描




### 二叉树

### 872 叶子相似的树


### 236 最低的二叉树公共祖先LCA
方法1：找出两条从root开始的路径，返回路径不开始不相同的前一个点
27%空间两个array
{% fold %}
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    List<TreeNode> pathp = new ArrayList<>();
    List<TreeNode> pathq = new ArrayList<>();
   // if(!findPath(root,p,pathp)||!findPath(root,p,pathp))return 
    findPath(root,p,pathp);
    findPath(root,q,pathq);
    int i;
    for(i = 0;i<Math.min(pathp.size(),pathq.size());i++){
        if(pathp.get(i).val!=pathq.get(i).val)
            break;
    }
    return pathp.get(i-1);
}
private boolean findPath(TreeNode root,TreeNode node,List<TreeNode> path){
    if(root == null)return false;
    path.add(root);
    if(root.val == node.val)return true;
    if(root.left!=null&&findPath(root.left,node,path))return true;
    if(root.right!=null&&findPath(root.right,node,path))return true;
    path.remove(path.size()-1);
    return false;
}
```
{% endfold %}
方法二：只遍历一次树，这种方法如果其中一个q不在树中，会返会p,应该返回null
13%
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if(root==null)return null;
    if(root.val==p.val||root.val==q.val)return root;
    TreeNode left = lowestCommonAncestor(root.left,p,q);
    TreeNode right = lowestCommonAncestor(root.right,p,q);
    if(left!=null&&right!=null)return root;
    return left!=null?left:right;
}
```
这道题两个点都保证存在，可以absent的

终止条件`root==null|root==q||root=p`
1. 在左/右子树找p|q，两边都能找到一个值（因为值不重复） 则返回当前root
2. 如果左边没找到p|q，右边找到了p|q，最低的祖先就是找到的p|q，(因为保证p|q一定在树中)


### 235 BST的LCA
8.9%
```java
TreeNode lcaBST(TreeNode root,TreeNode p,TreeNode q){
    if(root== null)return null;
    if(root.val>p.val&&root.val>q.val)return lcaBST(root.left,p ,q );
    if(root.val<p.val&&root.val<q.val)return lcaBST(root.right,p ,q );
    return root;
}
```
优化1： 13% 9ms
```java
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if(root.val > p.val && root.val > q.val){
        return lowestCommonAncestor(root.left, p, q);
    }else if(root.val < p.val && root.val < q.val){
        return lowestCommonAncestor(root.right, p, q);
    }else{
        return root;
    }
}
```


### 222 完全二叉树的节点数
[83%](https://blog.csdn.net/jmspan/article/details/51056085)


### 110 判断树平衡 在计算高度时同时判断平衡只需要O(n)
```java
private boolean balance =true;
public boolean isbalance(TreeNode root){
    height(root);
    return balance;
}
private int height(TreeNode root){
    if(root==null) return 0;
    int left = height(root.left);
    int right = height(root.right);
    if(Math.abs(left-right)>1)balance = false;
    return Math.max(left,right)+1;
}
```

###  lc538 O(1)空间 线索二叉树 Morris Inorder(中序) Tree Traversal
#### Morris Inorder(中序) Tree Traversal
**先把每个中缀的前缀（左子树最右）指向中缀，遍历完后把这些链接都删除还原为 null**
1. 找root的前趋：root 的中序前趋是左子树(第一个左结点)cur的最右标记为pre， pre.right = root
```java
//找前趋
Node cur = root;
if(cur.left!=null){
    Node pre = current.left;
    while(pre.right!=null&&pre.right!=cur){
        pre=pre.right;
    }
}
```
```java
//创建链接：第一次到达这个最右的结点，cur的左边其实还有结点
if(pre.right==null){
  pre.right = cur;
  cur=cur.left;
}
```
2. 找root.left的前趋：cur向左（相当于新的root（1）的状态），找到cur的最右，标识成pre.right = cur
3. 当cur向左是null则找到中序遍历的第一个输出，cur向右
```java
if(cur.left==null){
    sout(current.val);
    current=current.right;}
```
4. 当cur的left==null并且右链接已经建立到上一层。cur移动到上一层，找到前趋pre就是右链接的cur.left。 把这个右链接(pre.right)删除，输出（中），然后继续向右（上）并删除这种从前趋right过来的线。
```java
//pre.right=cur
else if(pre.right!=null){
  pre.right = null;
  sout(cur.val);
  cur=cur.right;
}
```



### 671 ？？根的值<=子树的值的二叉树中的第二小元素
```
      2
  2       5
4   3(out)
```
1.dfs在set中加入所有节点，遍历set
```java
int min = root.val;
int ans = Long.MAX_VALUE;
for(int v:set){
    if(min<v&&v<ans)ans = v;
}
return ans<Long.MAX_VALUE?(int) ans:-1;
```
2.在dfs的时候只有node.val == root.val的时候表示这个分支需要继续遍历
```java
min = root.val;
int ans = Long.MAX_VALUE;
private dfs(TreeNode rote){
    if(root!=null){
        if(min<root.val&&root.val<ans)
            ans = root.val;
    }else if(min == root.val){
        dfs(root.left);
        dfs(root.right);
    }
}
```

### 145 后序遍历二叉树 
1.函数式编程 不用help函数（可变数组），复制数组

{% fold %}
```java
public List<Integer> post(TreeNode root){
    List<Integer> list = new ArrayList<>();
    if(root==null)return list;
    List<Integer> left = post(root.left);
    List<Integer> right = post(root.right);
    list.addAll(left);
    list.addAll(right);
    list.add(root.val);
    return list;
}
```
{% endfold %}

原理：
```python
rev_post(root):
    # 全部反过来刚好是后序遍历
    print(root->val);
    rev_post(root->right)
    rev_post(root->left)
reverse(rev_post(root));
```

方法1：
```java
public List<Integer> postorderTraversal(TreeNode root) {
    LinkedList<Integer> list = new LinkedList<>();
     if(root==null)return list;
    Deque<TreeNode> stack = new ArrayDeque<>();
    stack.push(root);
    while(!stack.isEmpty()){
        root = stack.pop();
        list.addFirst(root.val);
        if(root.left!=null)stack.push(root.left);
        //下一次poll出的是右子树
        if(root.right!=null)stack.push(root.right);
    }
    // 如果使用ArrayList 1%
    //Collections.reverse(list);
    return list;
}
```

### lt66 lc 144 二叉树前序遍历 分治方法
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

迭代： 效率和先入栈right再入栈左是一样的，只是为了扩展
![preorder.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/preorder.jpg)
```java
public List<Integer> preorderTraversal(TreeNode root) {
    List<Integer> rst = new ArrayList<>();
    if(root == null){
        return rst;
    }
    Deque<TreeNode> stack = new ArrayDeque<>();
    while (true) {
        while (root != null) {
            rst.add(root.val);
            if(root.right != null)
            stack.push(root.right);
            root = root.left;
        }
        if(stack.isEmpty())break;
        root = stack.pop();
    }
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

### lc 94 中序
```java
public List<Integer> inorderTraversal(TreeNode root) {
    List<Integer> rst = new ArrayList<>();
    if(root == null){
        return rst;
    }
    Deque<TreeNode> stack = new ArrayDeque<>();
    while(true){
        while(root != null){
            stack.push(root);
            root = root.left;
        }
        if(stack.isEmpty())
            break;
        root = stack.pop();
        rst.add(root.val);
        root = root.right;     
    }
    return rst;
}
```

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