---
title: cpp
date: 2018-04-23 08:59:30
tags:
category: [cpp学习操作系统]
---
### 有符号和无符号
```cpp
#include<stdio.h>
int main(void){
    unsigned int a = 1;
    signed int b = -3;
    int c;
    (a+b>0)?(c=1):(c=0);
    printf("%d",c);
    return 0;
}
```
答案 1
无符号号整数和有符号整数相加，有符号整数转化为无符号整数.


### 赋值兼容规则也适用于多重继承的组合
赋值兼容规则是指在需要【基类对象】的任何地方都可以使用【公有派生类的对象】来替代。
通过公有继承，派生类得到了基类中除构造函数、析构函数之外的所有成员，而且所有成员的访问控制属性也和基类完全相同。这样，公有派生类实际就具备了基类的所有功能，凡是基类能解决的问题，公有派生类都可以解决。

赋值兼容规则中所指的替代包括以下的情况： 
- 派生类的对象可以赋值给基类对象。
- 派生类的对象可以初始化基类的引用。
- 派生类对象的地址可以赋给指向基类的指针。

### 库文件
中间目标文件(`.obj`,`.o`的打包叫 库文件 `.lib`,`.a`

### 链接
在所有目标文件中寻找函数实现。

### makefile
`target:prerequisites`
target 中一个或多个 依赖于 preprequisites 中的文件，
如果 preprequisites 有一个比target新，command就执行。

### const int
给出以下定义，下列哪些操作是合法的？
1
2
const char *p1 = “hello”;
char *const p2 = “world”;
正确答案: A   你的答案: B (错误)
p1++;
p1[2] = ‘w’;
p2[2] = ‘l’;
p2++;
即 const在*的左边不能改变字符串常量的值，故B错；
const在*的右边不能改变指针的指向，故D错；
若要修改其值，应该改为char str []= "world";
"hello"这样声明的字符串是存储在只读存储区的，不可修改，所以B,C都错误



正确答案: A B C   你的答案: A C E (错误)
const int a; //const integer
int const a; //const integer
int const \*a; //a pointer which point to const integer
const int \*a; //a const pointer which point to integer
int const \*a; // a const pointer which point to integer
```
p是一个常量指针，指向一个普通变量
int *const p;  /* p is a const pointer to int */

p是一个常量指针，指向一个常量
const int *const p;  /* p is a const pointer to int const */
int const *const p;  /* p is a const pointer to const int */
```

### ！！inline 错2次
`static inline` 如果不加static，则表示该函数有可能会被其他编译单元所调用，所以一定会产生函数本身的代码。所以加了static，一般可令可执行文件变小。编译时不会为内联函数单独建立一个函数体。

关于c++的inline关键字,以下说法正确的是()
正确答案: D   你的答案: B/C (错误)
A使用inline关键字的函数会被编译器在调用处展开
- 编译器有权忽略这个请求，比如：若此函数体太大，则不会把它作为内联函数展开的。

B头文件中可以包含inline函数的声明
- 头文件中不仅要包含 inline 函数的声明，而且必须包含定义，且在定义时必须加上 inline 

C可以在同一个项目的不同源文件内定义函数名相同但实现不同的inline函数
-  inline 函数可以定义在源文件中，但多个源文件中的同名 inline 函数的实现必须相同。

D定义在Class声明内的成员函数默认是inline函数
- 类内的成员函数，默认都是 inline 的。

D优先使用Class声明内定义的inline函数
E优先使用Class实现的内inline函数的实现
- 不管是 class 声明中定义的 inline 函数，还是 class 实现中定义的 inline 函数，不存在优先不优先的问题，因为 class 的成员函数都是 inline 的，加了关键字 inline 也没什么特殊的。

---

### ！！指针 错两次
```c
main()
{
    char*a[]={"work","at","alibaba"};
    char**pa=a;
    pa++;
    printf("%s",*pa);
}
```
正确答案: A   你的答案: C (错误)
at // 因为pa还是指向最外层的数组
atalibaba
ork
orkatalibaba
编译错误


---

错第二次
```c
struct st
{
    int *p;
    int i;
    char a;
};
int sz=sizeof(struct st);
```
如下C程序,在64位处理器上运行后sz的值是什么?
正确答案: C   你的答案: B (错误)
24
20
**16**
14
13
12
1.struct的对齐原则，必须是其内部最大成员的"最宽基本类型成员"的整数倍.不足的要补齐?
此处指针先占用8字节。int占用4字节，满足要求不用补齐，char占用一个字节，同时总的字节数必须满足8的倍数即16

第二次错
---
```cpp
#include <iostream>       
#include <vector>
using namespace std;
int main(void)
{
    vector<int>array;
    array.push_back(100);
    array.push_back(300);
    array.push_back(300);
    array.push_back(300);
    array.push_back(300);
    array.push_back(500);
    vector<int>::iterator itor;
    for(itor=array.begin();itor!=array.end();itor++)
    {
        if(*itor==300)
        {
            itor=array.erase(itor);
        }
    }
    for(itor=array.begin();itor!=array.end();itor++)
    {
            cout<<*itor<<"";
    }
  return 0;
}
```
下面这个代码输出的是()
正确答案: C   你的答案: F (错误)
100 300 300 300  300 500
100 3OO 300 300 500
100 300 300 500
100 300 500
100 500
程序错误

`vector::erase()：`从指定容器删除指定位置的元素或某段范围内的元素 
如果是删除指定位置的元素时： 
**返回值是一个迭代器，指向删除元素下一个元素;** 

--- 

循环语句whlie(int i=0 )i--;的循环次数是0

### 静态方法？
```cpp
有如下类的定义：
class Constants
{  
public: static double GetPI(void){return 3.14159;}
};  
Constants constants;
下列各组语句中，能输出3.14159的是：
cout<<Constants::GetPI();和
cout<<constants.GetPI();
```

### 静态成员
下面关于一个类的静态成员描述中,不正确的是()
正确答案: C   你的答案: E (错误)
A静态成员变量可被该类的所有方法访问
B该类的静态方法只能访问该类的静态成员函数
C该类的静态数据成员变量的值不可修改
D子类可以访问父类的静态成员
E静态成员无多态特性

多态性是要通过指针或者引用才能体现出来的


### 构造函数
？构造函数的工作是在**创建/声明对象**时自动执行的。

错误：
构造函数可以对静态数据成员进行初始化

### 默认参数
C++语言中，对函数参数默认值描述正确的是：
在设定了参数的默认值后，该参数后面定义的所有参数都必须设定默认值

错误：
函数参数的默认值只能设定一个
函数参数必须设定默认值

### 拷贝构造函数
通过使用另一个同类型的对象来初始化新创建的对象。
对拷贝构造函数的描述正确的是：
正确答案: B D
A该函数名同类名，也是一种构造函数，该函数返回自身引用
B**该函数只有一个参数，必须是对某个对象的引用**
C每个类都必须有一个拷贝初始化构造函数，如果类中没有说明拷贝构造函数，则编译器系统会自动D**成一个缺省拷贝构造函数，作为该类的保护成员
拷贝初始化构造函数的作用是将一个已知对象的数据成员值拷贝给正在创建的另一个同类的对象**


编译器可以跳过拷贝构造函数，直接创建对象

以下代码共调用多少次拷贝构造函数：
```cpp
Widget f(Widget u)
{  
   Widget v(u);
   Widget w=v;
   return w;
}
main(){
    Widget x;
    Widget y=f(f(x));
}
```
正确答案: 7

[字符串 长度 缓冲区溢出](http://redisbook.com/preview/sds/different_between_sds_and_c_string.html)

### 字符串 长度O（N）
> C 字符串并不记录自身的长度信息， 所以为了获取一个 C 字符串的长度， 程序必须遍历整个字符串， 对遇到的每个字符进行计数， 直到遇到代表字符串结尾的空字符为止， 这个操作的复杂度为 O(N) 。

### 字符串缓冲区溢出
`char *strcat(char *dest, const char *src);`
> C 字符串不记录自身的长度， 所以 strcat 假定用户在执行这个函数时， 已经为 dest 分配了足够多的内存， 可以容纳 src 字符串中的所有内容， 而一旦这个假定不成立时， 就会产生缓冲区溢出。

假设程序里有两个在**内存**中紧邻着的 C 字符串 s1 和 s2 ， 其中 s1 保存了字符串 "Redis" ， 而 s2 则保存了字符串 "MongoDB"

执行`strcat(s1, " Cluster");` 会把s2覆盖掉
![stringoverflow.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/stringoverflow.jpg)


### `emplace_back()`和`push_back()`
emplace_back()更节省空间
边集`<u,v,cost>`->邻接表
```cpp
unordered_map<int,vector<pair<int,int> > > g_;
for(const auto& e: flights){
    g_[e[0]].emplace_back(e[1],e[2]);
}
```


### 大端小端
union的存放顺序是所有成员都从低地址开始存放
一般操作系统都是小端，而通讯协议是大端的。
常见文件的字节序
```
Adobe PS – Big Endian
BMP – Little Endian
DXF(AutoCAD) – Variable
GIF – Little Endian
JPEG – Big Endian
MacPaint – Big Endian
RTF – Little Endian
```
```cpp
#include<bits/stdc++.h>
bool IsBigEndian2()
{
    union NUM
    {   //低地址
        int a;
        char b;
    }num;
    num.a = 0x1234;
    if( num.b == 0x12 )
    {
        return true;
    }
    return false;
}
bool IsBigEndian()
{
    //8bit的char
    int a = 0x1234; 
    //通过将int强制类型转换成char单字节，通过判断起始存储位置。即等于 取b等于a的低地址部分
    char b =  *(char *)&a; 
    if( b == 0x12)
    {
            std::cout<<b;
        return true;
    }
    return false;
}
```


### `#include<pthread.h>`
https://sourceware.org/pthreads-win32/ 
pthreads-w32-2-9-1-release.zip
include:
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.14.26428\include
lib:C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.14.26428\lib
dll:x86
C:\Windows\SysWOW64
dll:x64
C:\Windows\System32
```cpp
#include <pthread.h>
#pragma comment(lib,"pthreadVC2.lib")
```
编译错误C2011 “timespec”:“struct”类型重定义
可修改pthread.h文件，在
```cpp
#if !defined( PTHREAD_H )
#define PTHREAD_H
下面加上一行宏定义
#define HAVE_STRUCT_TIMESPEC
```
可以解决“timespec”:“struct”类型重定义错误

1 4 0
0 10 15 20
10 0 35 25
15 35 0 30
20 25 30 0
并行tsp
```cpp
```


### MS-MPI
https://blog.csdn.net/u011514451/article/details/50675222


编译期常量constexpr

### static_cast
强制类型转换

### 拓扑排序
![topu.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/topu.jpg)

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
![prestack.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/prestack.jpg)
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
        if(S.empty())break;
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
![midtrav.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/midtrav.jpg)
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
![intravstack.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/intravstack.jpg)

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
![preback.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/preback.jpg)

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
    
