---
title: cpp
date: 2018-04-23 08:59:30
tags:
---
### MS-MPI
https://blog.csdn.net/u011514451/article/details/50675222


编译期常量constexpr

### static_cast
强制类型转换

### 拓扑排序
![topu](/images/topu.jpg)

### 树结构review
树结构是为了对vector(数组)和list(链表)的静态操作(search)和动态操作(insert,remove)效率的平衡。

1. 任何树，边数(e)=所有顶点度数之和=顶点总数(n)-1 意义：边数与顶点数是同阶的O(n)可以拿顶点数做复杂度的参照
2. 路径长度复杂度以边数定义会简化算法描述
3. 数和无环和连通的关系：1.无环连通图，2.极小连通图，3.极大无环图 结论：1.任一节点v与【根】存在【唯一】路径，记作path(v)
4. 路径(path (from root) to v)、节点、子树(subtree (rooted at) v)是等价类，互相指代
    结论：v的深度:depth(v)=|path(v)| 树根深度为0
    树是半线性结构：前驱(父节点)是唯一的，后继不唯一，图则都不唯一。
    叶子节点中深度最大的为(子)树的高度$height(v) + depth(v) <= height(T)$,单个节点高度为0，空树高度为-1。

#### 树存储结构
1.`rank[n],data[n],parent[n]`,空间O(n)
 时间：
    1. 访问父节点`parent()` O(1) 
    2. `root()`一直沿着`parent[]`到-1 O(n),可以将根放在`rank[0]`变成O(1)
    3. 但是找长子O(n)遍历`rank[i]`的parent 兄弟节点也是O(n)
2. 将`parent[]`变成指针`child[n]`，指向子节点，子节点的查找效率是度数，但是查找parent变成O(n)
3. 保留parent[n]也添加child[n]保证了parent和child的查找速度，但是child指向的list可能是O(n)
4. 儿子兄弟法 可以用二叉树表示所有的树

#### 二叉树
1. 每一层$2^k$个节点
2. 树的节点数 $h< n<2^{h+1}$
3. 为简化算法思考，为叶子节点加上2个子节点(null)，将每个节点补齐度为2
```
BinNode:
lchild parent rchild
        data
height npl(左氏堆) color
size
```

1. 插入左/右孩子
```cpp
//data和父节点
template <typename T> BinNodePosi(T) BinNode<T>:: insertAsRC(T const &e)
{ return lchild = new BinNode(e,this);}
return rchild = new BinNode(e,this);
```
2. 计算后代数量O(n)
```cpp
template <typename T>
int BinNode<T>:: size(){
    int s = 1;//本身
    if(lChild) s+=lChild.size();
    if(rChild) s+=rChild.size();
    return s;
}
```
3. BinTree模板类
```c++
template <typename T> class BinTree{
    protected:
        int _size;
        //树根节点的位置
        BinNodePosi(T) _root;
        //各种二叉树对高度的定义和更新的方法不同
        virtual int updateHeight(BinNodePosi(T) x);
        //更新了一个节点之后更新所有祖先的高度
        void  updateHeightAbove(BinNodePosi(T) x);
    public:
        int size() const {return _size;}//规模
        bool empty() const {return !_root;}//判空
        BinNodePosi(T) root() const {return _root;}//树根
}
```
4. 高度更新(最深叶节点path)
```cpp
//使用宏定义 空树 h=-1
#define stature(p) ((p)?(p)->height:-1);
int BinTree<T> ::updateHeight(BinNodePosi(T) x){
    return x->height = 1+max(stature(x->lChild),stature(x->rChild));
}
```
    更新了x节点的高度，x的父节点们的高度也高更新O(n=depth(x))
    ```cpp
    template<typename T>
    void BinTree<T>:: updateHeightAbove(BinNodePosi(T) x){
        while(x){
            updateHeight(x);x= x->parent;
        }
    }
    ```
5. 节点插入
```cpp
template <typename T> BinNodePosi(T)
BinTree<T> ::insertAsRC(BinNodePosi(T) x,T const &e){
    _size++;
    x->insertAsRC(e);
    updateHeightAbove(x);
    return x->rChild;
}
```

####  6. 先序遍历$T(n) =O(1)+T(a)+T(n-a-1) =O(n)$
问题是每个递归帧虽然是O(1)但是每个帧差很大，而且是尾递归能用栈优化
```cpp
template <typename T,typename VST>
void traverse(BinNodePosi(T) x,VST &visit){
    if(!x)return;
    visit(x->data);
    traverse(x->lChild,visit);
    traverse(x->rChild,visit);
}
```

##### 迭代版本1：
```cpp
template <typename T,typename VST>
void traPre_v1(BinNodePosi(T) x,VST & visit){
    //存放位置（引用）
    Stack<BinNodePosi(T)> s;
    if(x)s.push(x);
    while(!s.empty()){
        x = s.pop();visit(x->data);
        if(HasRChild(*x))s.push(x->rChild);
        if(HasLChild(*x))s.push(x->lChild);
    }
}
```
先放入栈右子树再入栈左子树。不能推广到中序、后序遍历
```java
while(!s.empty()){
    x=s.pop();visit(x);
   if(root.right!=null)stack.push(root.right);
    if(root.left!=null) stack.push(root.left);
}
```

##### 迭代版本2：
1. 沿着左孩子下行，到左侧空了之后向上遍历刚才没访问的右子树
![pretrav](/images/prestack.jpg)
```cpp
template <typename T,typename VST>
static void visitAlongLeftBranch(
    BinNodePosi(T) x,
    VST & visit,
    Stack <BinNodePosi(T)> &s)
{   //3.pop出的x是null
    while(x){
        visit(x->data);
        //1. 如果x是叶子，右节点是null也push了
        s.push(x->rChild);
        x=x->lChild;
    }
}
```
主算法
```cpp
template <typename T,typename VST>
void trapRE_v2(BinNodePosi(T) x,VST& visit){
    Stack <BinNodePosi(T)> S;
    while(true){
        visitAlongLeftBranch(x,visit,S);
        if(s.empty())break;
        //进入了以x为根节点的子树
        //2. x是叶子节点右指针null
        x = s.pop();
    }
}
```

#### 中序遍历O(n)
1.不是尾递归
2.一直向左，到左边没有了visit，再访问右子树，回到原来左链上的上个节点访问并继续右子树
左侧链上的每个节点是一个阶段，都是相同的，上一个节点访问的时候可以当下一个节点不存在
![midtrav](/images/midtrav.jpg)
将所有左节点入栈，最后弹出访问并访问右子树
```cpp
template <typename T>
static void goAlongLeftBranch(BinNodePosi(T) x,Stack <BinNodePosi(T)> &S){
    //O(n)但是所有左侧链的长度合在一起也是O(n) 每个节点只入栈一次
    while(x){S.push(x);x=x->lChild;}
}
template <typename T,typename V> 
void traIn_v2(BinNodePosi(T) x,V& visit){
    Stack <BinNodePosi(T)> S;
    while(true){
        goAlongLeftBranch(x,S);
        if(S.empty())break;
        //x的左子树为空
        x = S.pop();
        //O(n)
        visit(x->data);
        //进入右子树分支
        x = x->rChild;
    }
}
```
![intravstack](/images/intravstack.jpg)

#### 层次遍历
```cpp
template <typename T> template <typename Vst >
void BinNode<T>::travLevel(VST & visit){
    Queue<BinNodePosi(T)> Q;
    //根
    Q.enqueue(this);
    while(!Q.empty()){
        BinNodePosi(T) x = Q.dequeue();
        visit(x->data);
        //先进先出
        if(HasLChild(*x)) Q.enqueue(x->lChild);
        if(HasRChild(*x)) Q.enqueue(x->rChild);
    }
}
```

#### [先序|后序]+中序可以还原唯一的二叉树
先序[r][L][R]
中序[L][r][R]
左右子树为空不会有歧义

而先序和后序无法分别到底是左子树还是右子树
先序 [r][L] 右空
     [r][R] 左空
后序 [L][r] 右空
     [R][r] 左空

每个节点的度是0或2的真二叉树可以由先序，后序还原。左右子树同时为空/非空
![preback](/images/preback.jpg)

### 图 
1. 简单路径：不含重复顶点

### 欧拉图：一笔画 所有边
经过所有顶点、所有边的**闭路径**（边不重复，允许顶点重复）

欧拉路径：
经过所有顶点，所有边的路径（边不重复，顶点重复） 不是闭路径（不需要回到原地）。

欧拉图判定条件：
无向图：G是连通的，所有顶点的度都是偶数。
有向图：G弱连通，每个顶点的出度和入度相等

欧拉路径判定条件：
无向图：G连通，恰有两个顶点的度是奇数。从一个奇数顶点出发，到另一个奇数度顶点结束。
有向图：G连通，恰两个顶点出度入度不相等，其实于出度多1的终结与入度多1的。

### 哈密顿图 所有顶点
一条经过所有顶点的回路（不要求经过所有边）

哈密顿通路：经过所有顶点的通路，不要求回路

充分条件：
满足： 是哈密顿图


### resigter 寄存器变量
存放在寄存器中，调用时直接从寄存器中取出参加运算。

### 对象像指针`*`,`->`
#### 智能指针 包装类修改指针的行为 像一个指针
->会对作用到的结果一直作用下去
`operator*()` `operator -> ()` 写法固定

#### 迭代器 包括智能指针，++,--

### 对象像函数()


### 转换函数
当编译器遇到要把该类转换成double类型时，调用double

### explicit 用在构造函数前
non-explicit-one-argument 可以把4转换成fraction
用了explicit不能自动调用构造函数转型

委托：delegation,空心菱形表示有。又称Composition by reference 生命周期不同步 handle/body(impl)
组合：实心菱形 生命周期同步
组合是part在内，继承是base在内

### cpp继承有三种 java只有public不用写
继承的base class的构造函数必须是virtual不然西沟就不会先子类再base
```cpp
struct ListNode:public _list_node_base{};
```

#### 虚函数
成员函数有3种
```cpp
class Shap{
//纯虚函数 所有子类必须重新定义
virtual void draw() const = 0;
//可以重新定义
virtual void error(const std::string& msg);
//不让子类override
int objId() const;
};
```

### delegation+继承
组合模式（文件/文件夹）
原型模式，继承框架类，将自己定义的新类加入框架让框架调用 静态方法要在类外给内存

### .h头文件写法
conplex.h
```cpp
#ifndef __COMPLEX__
#define __COMPLEX__
...
#endif
```

### 语法制导翻译：类型检查/中间代码生成
向文法的产生式附加一些规则（或程序片段）
语法分析过程时相应的程序片段会被执行。
在语法分析的过程中结合语义动作。

#### 语法指导定义 上下文无关文法和属性及规则集合。
规则：语义规则 和产生式相关联。
属性与文法相关联


1. splice
2. `emplace_front`
3. map:`find`找到第一个相等的元素
4. iterator :`.cend()`容器最后面
5. 把vector中的一个元素移动到最前面
```cpp
//it->second map中的值，指向结点的指针
list.splice(list.begin(),list,it->second);
```
1. 查找vector中的最大最小元素`*max_element(first,end)`
2. `multiset`和set在c++里是有序的，是红黑树，用`*set.rbegin()`可以获得最大值
  `.erase()`会遍历删除所有相同的元素，`.equal_range()`限定范围
```cpp
multiset<int> s;
s.insert(5);
s.insert(5);
s.insert(5);
//只删除了第一个5
s.erase(s.equal_range(5).first);
```
3. c++ 的deque：用指针取头尾的连续存储
4. `advance(it,5)`将迭代器移动5次，迭代器`*it`指向第6个元素
1. `dummy`标记[0]元素??????
1. vector1.swap(v2) 与另一个vector交换数据
1. `unordered_set` 拉链法hash表
2. #include读 hash-include
3. ; 读semicolon
4. `auto` 类型由编译器自动推断
5. `explicit` 禁止隐式转换
6. 成员初始化列表语法
7. 继承关系：
    1. 共有继承：is a == is a kind of关系不可逆  香蕉是一种水果，水果不是香蕉
    2. has a 午餐包括水果
    3. is like a 律师像鲨鱼
    4. is implemented as a 栈用数组实现
    5. uses a 计算机可以使用打印机使用友元通信
8. 多态：派生类使用基类的方法；方法行为随上下文，取决于调用该方法的对象。
    - 在派生类中重新定义基类方法
    - 虚方法:根据引用/指针指向的对象 的类型选择方法.派生类回重新定义的方法，在基类中应为虚的。
    - 派生通过 作用域解析运算符 调用基类方法
9. 虚函数原理：
- 每个对象由隐藏成员，是虚函数表（virtual function table） `_vtbl`,所有虚函数的地址表
10. 例程
11. fprintf 
    
