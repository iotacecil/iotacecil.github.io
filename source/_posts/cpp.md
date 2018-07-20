---
title: cpp
date: 2018-04-23 08:59:30
tags:
---
### resigter 寄存器变量
存放在寄存器中，调用时直接从寄存器中取出参加运算。

### STL
![STL](/images/STL.jpg)

分配器Allocator支持容器，处理容器的内存。
容器Containers数据和算法Algorithms操作分开。不是OO设计，是模板编程。
迭代器是泛化指针 是容器和算法的桥梁。
仿函数Functors

### 容器
1 Sequence Containers:
    Array\vector\deque\list循环双端链表\forwardlist单向链表
2 Associative Container:Set\Multiset,Map\Multimap
3 unordered Containers:
    HashTable:Separate Chaning。

### array
```cpp
array<long,50000> c;
////0x47a20数组在内存中起始的地址
c.data();
int compareLongs(const void*a,const void*b){
    return(*(long*)a-*(long*)b);
}
//排序
qsort(c.data,50000,sizeof(long),compareLongs);
//二分查找
long* pItem = (long*)bsearch(&target,c.data(),50000,sizeof(long),compareLongs);
```

### vecotr

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
....
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
    
