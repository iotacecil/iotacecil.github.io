---
title: cppSTL
date: 2018-08-12 19:14:53
tags:
category: [cpp学习操作系统]
---
### 操作符重载
https://en.cppreference.com/w/cpp/language/operators
> 不能重载的操作符 operators :: (scope resolution), . (member access), .* (member access through pointer to member), and ?: (ternary conditional) cannot be overloaded.

链表的迭代器：重定义了所有指针的操作
```cpp
template<typename _Tp>
struct _List_iterator
{
  typedef _List_iterator<_Tp>                _Self;
  typedef _List_node<_Tp>                    _Node;

  typedef ptrdiff_t                          difference_type;
  typedef std::bidirectional_iterator_tag    iterator_category;
  typedef _Tp                                value_type;
  typedef _Tp*                               pointer;
  typedef _Tp&                               reference;

  _List_iterator()
  : _M_node() { }

  explicit
  _List_iterator(__detail::_List_node_base* __x)
  : _M_node(__x) { }

  // Must downcast from _List_node_base to _List_node to get to _M_data.
  reference
  operator*() const
  { return static_cast<_Node*>(_M_node)->_M_data; }

  pointer
  operator->() const
  { return std::__addressof(static_cast<_Node*>(_M_node)->_M_data); }

  _Self&
  operator++()
  {
_M_node = _M_node->_M_next;
return *this;
  }

  _Self
  operator++(int)
  {
_Self __tmp = *this;
_M_node = _M_node->_M_next;
return __tmp;
  }

  _Self&
  operator--()
  {
_M_node = _M_node->_M_prev;
return *this;
  }

  _Self
  operator--(int)
  {
_Self __tmp = *this;
_M_node = _M_node->_M_prev;
return __tmp;
  }

  bool
  operator==(const _Self& __x) const
  { return _M_node == __x._M_node; }

  bool
  operator!=(const _Self& __x) const
  { return _M_node != __x._M_node; }

  // The only member points to the %list element.
  __detail::_List_node_base* _M_node;
};
```

### 源码位置 generic programming
\devcpp\MinGW64\lib\gcc\x86_64-w64-mingw32\4.8.1\include\c++\bits
数据list/deque/vector和方法algorithm分开
全局函数`::sort(c.begin(),c.end());`通过iterator/泛化指针作为接口

stl_algobase：
```cpp
template<typename _Tp>
inline const _Tp&
min(const _Tp& __a, const _Tp& __b)
{
  // concept requirements
  __glibcxx_function_requires(_LessThanComparableConcept<_Tp>)
  //return __b < __a ? __b : __a;
  if (__b < __a)
return __b;
  return __a;
}
```

```cpp
template<typename _Tp, typename _Compare>
inline const _Tp&
max(const _Tp& __a, const _Tp& __b, _Compare __comp)
{
  //return __comp(__a, __b) ? __b : __a;
  if (__comp(__a, __b))
return __b;
  return __a;
}
```

list不用全局sort 因为全局sort要求传入的指针是randomaccess
stl_algobase：
```cpp
template<typename _RandomAccessIterator>
    inline void
    sort(_RandomAccessIterator __first, _RandomAccessIterator __last){
        ...
        if (__first != __last)
    {
      std::__introsort_loop(__first, __last,
                std::__lg(__last - __first) * 2);
      std::__final_insertion_sort(__first, __last);
    }
    }
```

### 模板
1.类模板
在class前加`template<typename T>`
2.函数模板 写typename和class功能相同
```cpp
template<class T>
inline
const T& min(const T& a,const T& b){
    return b<a?b:a;
}
```
3.成员模板

### operator new()/malloc()
operator new 调用malloc
newop.cpp
```cpp
oid *__CRTDECL operator new(size_t count) _THROW1(_STD bad_alloc)
{   // try to allocate size bytes
void *p;
while ((p = malloc(count)) == 0)
    if (_callnewh(count) == 0)
        {   // report no memory
        static const std::bad_alloc nomem;
        _RAISE(nomem);
        }
return (p);
}
```

### STL
{% qnimg STL.jpg %}

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
不能改变大小
milli-seconds : 11
array.size()= 500000
array.front()= 41
array.back()= 29794
数组起点的内存位置
array.data()= 0x49c040
{% fold %}
```cpp
#include<array>
#include<iostream>
#include<ctime>
#include<cstdlib>
using namespace std;
const long ASIZE  =   500000L;
array<long,ASIZE> c;
long get_a_target_long()
{
long target=0;
    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    return target;
}
int compareLongs(const void* a, const void* b)
{
  return ( *(long*)a - *(long*)b );
}
int main(){
clock_t timeStart = clock();
for(long i =0;i<ASIZE;++i){
    c[i]=rand();
}
cout << "milli-seconds : " << (clock()-timeStart) << endl;  //
cout << "array.size()= " << c.size() << endl;       
cout << "array.front()= " << c.front() << endl; 
cout << "array.back()= " << c.back() << endl;   
cout << "array.data()= " << c.data() << endl;   
//二分查找
qsort(c.data(), ASIZE, sizeof(long), compareLongs);
long* pItem = (long*)::bsearch(&target, (c.data()), ASIZE, sizeof(long), compareLongs); 
if (pItem != NULL)
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;
}
```
{% endfold %}

### vector
milli-seconds : 6326
vector.max_size()= 2305843009213693951
vector.size()= 1000000
vector.front()= 41
vector.back()= 12679
vector.data()= 0x33c5040
vector.capacity()= 1048576

target (0~32767): 654
target:654
std::find(), milli-seconds : 1
found, 654
bsearch(), milli-seconds : 1387
found, 654
{% fold %}
```cpp
#include <vector>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <ctime> 
#include <algorithm>    //sort()
using namespace std;
string get_a_target_string()
{
long target=0;
char buf[10];

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    snprintf(buf, 10, "%d", target);
    return string(buf);
}
int compareStrings(const void* a, const void* b)
{
  if ( *(string*)a > *(string*)b )
        return 1;
  else if ( *(string*)a < *(string*)b )
        return -1;  
  else          
        return 0;  
}
int main(){
vector<string> c;   
char buf[10];
            
clock_t timeStart = clock();                                
for(long i=0; i< 1000000; ++i)
{
    try {
        snprintf(buf, 10, "%d", rand());
        c.push_back(string(buf));           
    }
    catch(exception& p) {
        cout << "i=" << i << " " << p.what() << endl;   
             //曾經最高 i=58389486 then std::bad_alloc
        abort();
    }
}
cout << "milli-seconds : " << (clock()-timeStart) << endl;  
cout << "vector.max_size()= " << c.max_size() << endl;  //1073747823
cout << "vector.size()= " << c.size() << endl;      
cout << "vector.front()= " << c.front() << endl;    
cout << "vector.back()= " << c.back() << endl;  
cout << "vector.data()= " << c.data() << endl;
cout << "vector.capacity()= " << c.capacity() << endl << endl;  
string target = get_a_target_string();
cout<<"target:"<<target<<endl;
     timeStart = clock();       
     //find的查找速度 
auto pItem = find(c.begin(), c.end(), target);                      
cout << "std::find(), milli-seconds : " << (clock()-timeStart) << endl;     

if (pItem != c.end())
    cout << "found, " << *pItem << endl;
else
    cout << "not found! " << endl;  
//二分查找的速度
timeStart = clock();        
sort(c.begin(),c.end());                        
string* pItem2 = (string*)::bsearch(&target, (c.data()), 
                               c.size(), sizeof(string), compareStrings); 
cout << "bsearch(), milli-seconds : " << (clock()-timeStart) << endl; 
   
if (pItem2 != NULL)
    cout << "found, " << *pItem2 << endl << endl;
else
    cout << "not found! " << endl << endl;  
return 0;
}
```
{% endfold %}

### List
milli-seconds : 5165
list.size()= 1000000
list.max_size()= 768614336404564650
list.front()= 41
list.back()= 12679
target (0~32767): 554
//find循序查找用时
std::find(), milli-seconds : 2
found, 554
//容器内的sort用时
c.sort(), milli-seconds : 2098
{% fold %}
```cpp
#include <list>
#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <algorithm> //find()
#include <iostream>
#include <ctime> 

using namespace std;
string get_a_target_string()
{
long target=0;
char buf[10];

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    snprintf(buf, 10, "%d", target);
    return string(buf);
}
int main(){

list<string> c;     
char buf[10];
clock_t timeStart = clock();
for(long i=0; i< 1000000; ++i)
{
    try {
        snprintf(buf, 10, "%d", rand());
        c.push_back(string(buf));       
    }
    catch(exception& p) {
        cout << "i=" << i << " " << p.what() << endl;   
        abort();
    }
}
cout << "milli-seconds : " << (clock()-timeStart) << endl;      
cout << "list.size()= " << c.size() << endl;
cout << "list.max_size()= " << c.max_size() << endl;    //357913941
cout << "list.front()= " << c.front() << endl;  
cout << "list.back()= " << c.back() << endl;

string target = get_a_target_string();
//find循序查找  
timeStart = clock();        
auto pItem = find(c.begin(), c.end(), target);                      
cout << "std::find(), milli-seconds : " << (clock()-timeStart) << endl;   
if (pItem != c.end())
    cout << "found, " << *pItem << endl;
else
    cout << "not found! " << endl;  
//排序用时
timeStart = clock();  
//容器的sort      
c.sort();                       
cout << "c.sort(), milli-seconds : " << (clock()-timeStart) << endl;      
return 0;
}
```
{% endfold %}

### 单向链表
没有push_back(太慢)只有push_front
只能得到第一个元素不能得到最后
milli-seconds : 5716
forward_list.max_size()= 1152921504606846975
forward_list.front()= 12679
target (0~32767): 3443
std::find(), milli-seconds : 2
found, 3443
c.sort(), milli-seconds : 2155
{% fold %}
```cpp
#include <forward_list>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <algorithm> //find()
#include <iostream>
#include <ctime> 
using namespace std;
string get_a_target_string()
{
long target=0;
char buf[10];

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    snprintf(buf, 10, "%d", target);
    return string(buf);
}
int main(){

forward_list<string> c;     
char buf[10];
            
clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            c.push_front(string(buf));                      
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;  
    cout << "forward_list.max_size()= " << c.max_size() << endl;  //536870911
    cout << "forward_list.front()= " << c.front() << endl;  


string target = get_a_target_string();  
    timeStart = clock();            
auto pItem = find(c.begin(), c.end(), target);  
    cout << "std::find(), milli-seconds : " << (clock()-timeStart) << endl;    
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
        
    timeStart = clock();        
    c.sort();                       
    cout << "c.sort(), milli-seconds : " << (clock()-timeStart) << endl;
return 0;
}
```
{% endfold %}

### deque
gnuC的，不是c++11的,用法与forward_list相同
slist:
milli-seconds : 5096
slist.max_size()= 18446744073709551615
slist.front()= 12679
target (0~32767): 33
std::find(), milli-seconds : 4
found, 33
c.sort(), milli-seconds : 1228
```cpp
#include <ext\slist>
__gnu_cxx::slist<string> c;
```

### deque
分段连续
{% qnimg deque.jpg %}
milli-seconds : 6119
deque.size()= 1000000
deque.front()= 41
deque.back()= 12679
deque.max_size()= 2305843009213693951
target (0~32767): 354
std::find(), milli-seconds : 3
found, 354
sort(), milli-seconds : 1551
{% fold %}
```cpp
#include <deque>
//#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <algorithm> //find()
#include <ctime> 
using namespace std;
string get_a_target_string()
{
long target=0;
char buf[10];

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    snprintf(buf, 10, "%d", target);
    return string(buf);
}
int main(){

deque<string> c;    
char buf[10];
clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            c.push_back(string(buf));                       
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;      
    cout << "deque.size()= " << c.size() << endl;
    cout << "deque.front()= " << c.front() << endl; 
    cout << "deque.back()= " << c.back() << endl;   
    cout << "deque.max_size()= " << c.max_size() << endl;   //1073741821    
    
string target = get_a_target_string();  
    timeStart = clock();            
auto pItem = find(c.begin(), c.end(), target);  
    cout << "std::find(), milli-seconds : " << (clock()-timeStart) << endl; 
    
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
        
    timeStart = clock();        
    sort(c.begin(), c.end());                       
    cout << "sort(), milli-seconds : " << (clock()-timeStart) << endl;      
return 0;
}
```
{% endfold %}

#### 容器适配器stack/queue用deque实现 push,pop
没有iterator，没有find，不然就可以改变中间的值
stack：
milli-seconds : 5545
stack.size()= 1000000
stack.top()= 12679
stack.size()= 999999
stack.top()= 17172
```cpp
stack<string> c;
```
queue:
milli-seconds : 4943
queue.size()= 1000000
queue.front()= 41
queue.back()= 12679
queue.size()= 999999
queue.front()= 18467
queue.back()= 12679
```cpp
queue<string> c;
c.front();
c.back();
```

### multiset 可以当成关联数据库
放进去的时候就排序了，红黑树
标准库的find和容器的find
milli-seconds : 7833
multiset.size()= 1000000
multiset.max_size()= 461168601842738790
target (0~32767): 23489
std::find(), milli-seconds : 124
found, 23489
c.find(), milli-seconds : 0
found, 23489
{% fold %}
```cpp
#include <set>
//#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <ctime> 
#include <algorithm> //find()
using namespace std;
string get_a_target_string()
{
long target=0;
char buf[10];

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    snprintf(buf, 10, "%d", target);
    return string(buf);
}
int main(){

multiset<string> c;     
char buf[10];       
clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            c.insert(string(buf));                  
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;  
    cout << "multiset.size()= " << c.size() << endl;    
    cout << "multiset.max_size()= " << c.max_size() << endl;    //214748364
string target = get_a_target_string();  
    {
    timeStart = clock();
auto pItem = find(c.begin(), c.end(), target);  //比 c.find(...) 慢很多 
    cout << "std::find(), milli-seconds : " << (clock()-timeStart) << endl;     
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
    }
    
    {
    timeStart = clock();        
auto pItem = c.find(target);  //比std::find(...)快很多                          
    cout << "c.find(), milli-seconds : " << (clock()-timeStart) << endl;         
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
    }   
return 0;
}
```
{% endfold %}

### multimap `c.insert(pair<long,string>(i,buf));  `
milli-seconds : 6038
multimap.size()= 1000000
multimap.max_size()= 384307168202282325
target (0~32767): 293283
c.find(), milli-seconds : 0
found, value=8239
{% fold %}
```cpp
#include <map>
#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <ctime> 
using namespace std;
long get_a_target_long()
{
long target=0;

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    return target;
}
int main(){

multimap<long, string> c;   
char buf[10];
            
clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            //multimap 不可使用 [] 做 insertion 
            c.insert(pair<long,string>(i,buf));                         
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;  
    cout << "multimap.size()= " << c.size() << endl;
    cout << "multimap.max_size()= " << c.max_size() << endl;    //178956970 
    
long target = get_a_target_long();      
timeStart = clock();    
//迭代器    
auto pItem = c.find(target);                                
    cout << "c.find(), milli-seconds : " << (clock()-timeStart) << endl;     
    if (pItem != c.end())
        cout << "found, value=" << (*pItem).second << endl;
    else
        cout << "not found! " << endl;   
return 0;
}
```
{% endfold %}

### unordered_multiset(hashtable)不是红黑树是hash表
milli-seconds : 5832
unordered_multiset.size()= 1000000
unordered_multiset.max_size()= 768614336404564650
unordered_multiset.bucket_count()= 1056323
unordered_multiset.load_factor()= 0.94668
unordered_multiset.max_load_factor()= 1
unordered_multiset.max_bucket_count()= 768614336404564650
bucket #33 has 36 elements.
bucket #37 has 41 elements.
bucket #79 has 16 elements.
target (0~32767): 555
std::find(), milli-seconds : 81
found, 555
c.find(), milli-seconds : 0
found, 555
{% fold %}
```cpp
#include <unordered_set>
#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <algorithm> //find()
#include <ctime> 
using namespace std;
string get_a_target_string()
{
long target=0;
char buf[10];

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    snprintf(buf, 10, "%d", target);
    return string(buf);
}
int main(){

unordered_multiset<string> c;   
char buf[10];
            
clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            c.insert(string(buf));                      
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;      
    cout << "unordered_multiset.size()= " << c.size() << endl;
    cout << "unordered_multiset.max_size()= " << c.max_size() << endl; 
    cout << "unordered_multiset.bucket_count()= " << c.bucket_count() << endl;  
    cout << "unordered_multiset.load_factor()= " << c.load_factor() << endl;    
    cout << "unordered_multiset.max_load_factor()= " << c.max_load_factor() << endl;    
    cout << "unordered_multiset.max_bucket_count()= " << c.max_bucket_count() << endl;              
    for (unsigned i=1; i< 120; ++i) {
        if(c.bucket_size(i)!=0)
        cout << "bucket #" << i << " has " << c.bucket_size(i) << " elements.\n";
    }                   
                
string target = get_a_target_string();  
    {
    timeStart = clock();
auto pItem = find(c.begin(), c.end(), target);  //比 c.find(...) 慢很多 
    cout << "std::find(), milli-seconds : " << (clock()-timeStart) << endl; 
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
    }
 
    {
    timeStart = clock();    
//容器内    
auto pItem = c.find(target);                           
    cout << "c.find(), milli-seconds : " << (clock()-timeStart) << endl;     
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
    }   
     
     return 0;
}
```
{% endfold %}

### unordered_multimap
milli-seconds : 6266
unordered_multimap.size()= 1000000
unordered_multimap.max_size()= 768614336404564650
target (0~32767): 42342
c.find(), milli-seconds : 0
found, value=9100
{% fold %}
```cpp
#include <unordered_map>
#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <ctime> 
using namespace std;

long get_a_target_long()
{
long target=0;

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    return target;
}
int main(){
unordered_multimap<long, string> c;     
char buf[10];
            
clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            //multimap 不可使用 [] 進行 insertion 
            c.insert(pair<long,string>(i,buf));
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;      
    cout << "unordered_multimap.size()= " << c.size() << endl;  
    cout << "unordered_multimap.max_size()= " << c.max_size() << endl;
    
long target = get_a_target_long();      
    timeStart = clock();        
auto pItem = c.find(target);                                
    cout << "c.find(), milli-seconds : " << (clock()-timeStart) << endl;         
    if (pItem != c.end())
        cout << "found, value=" << (*pItem).second << endl;
    else
        cout << "not found! " << endl;      
return 0;
}                                                            
```
{% endfold %}

### set 红黑树
放了1000000但是只有32768大小，0~32767
milli-seconds : 6963
set.size()= 32768
set.max_size()= 461168601842738790
target (0~32767): 3
std::find(), milli-seconds : 4
found, 3
c.find(), milli-seconds : 0
found, 3
{% fold %}
```cpp
#include <set>
#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <ctime> 
#include <algorithm> //find()
using namespace std;
string get_a_target_string()
{
long target=0;
char buf[10];

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    snprintf(buf, 10, "%d", target);
    return string(buf);
}
int main(){

set<string> c;      
char buf[10];

clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            c.insert(string(buf));                      
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;      
    cout << "set.size()= " << c.size() << endl;
    cout << "set.max_size()= " << c.max_size() << endl;    //214748364
        
string target = get_a_target_string();  
    {
    timeStart = clock();
auto pItem = find(c.begin(), c.end(), target);  //比 c.find(...) 慢很多 
    cout << "std::find(), milli-seconds : " << (clock()-timeStart) << endl;     
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
    }
    
    {
    timeStart = clock();        
auto pItem = c.find(target);     
    cout << "c.find(), milli-seconds : " << (clock()-timeStart) << endl;         
    if (pItem != c.end())
        cout << "found, " << *pItem << endl;
    else
        cout << "not found! " << endl;  
    }                           
}   
```
{% endfold %}

### map 可以用[]自动变成一个pair `c[i] = string(buf);`
milli-seconds : 6843
map.size()= 1000000
map.max_size()= 384307168202282325
target (0~32767): 4
c.find(), milli-seconds : 0
found, value=19169
{% fold %}
```cpp
#include <map>
#include <stdexcept>
#include <string>
#include <cstdlib> //abort()
#include <cstdio>  //snprintf()
#include <iostream>
#include <ctime> 
#include <algorithm> //find()
#include <ctime> 
using namespace std;
long get_a_target_long()
{
long target=0;

    cout << "target (0~" << RAND_MAX << "): ";
    cin >> target;
    return target;
}

int main(){

map<long, string> c;    
char buf[10];
            
clock_t timeStart = clock();                                
    for(long i=0; i< 1000000; ++i)
    {
        try {
            snprintf(buf, 10, "%d", rand());
            c[i] = string(buf);                     
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "milli-seconds : " << (clock()-timeStart) << endl;  
    cout << "map.size()= " << c.size() << endl; 
    cout << "map.max_size()= " << c.max_size() << endl;     //178956970
    
long target = get_a_target_long();      
    timeStart = clock();        
auto pItem = c.find(target);                                
    cout << "c.find(), milli-seconds : " << (clock()-timeStart) << endl;         
    if (pItem != c.end())
        cout << "found, value=" << (*pItem).second << endl;
    else
        cout << "not found! " << endl;  
        return 0;
    }
```
{% endfold %}

### unordered_set/map
```cpp
unordered_set<string> c;
c.insert(string(buf));  
unordered_map<long, string> c;  
c[i] = string(buf);
```

GNU C以前用`hash_set`,`hash_map`,`hash_multiset`,`hash_multimap`
`#include <ext\hash_set>`
```cpp
#include <ext\hash_map>
__gnu_cxx::hash_multimap<long, string> c;   
```

### GNUC的分配器 VC里名字不一样
(1) `std::allocator`  
how many elements: 1000000
a lot of push_back(), milli-seconds : 4975
(2) `malloc_allocator`  
how many elements: 1000000
a lot of push_back(), milli-seconds : 4768
(3) `new_allocator`  
how many elements: 1000000
a lot of push_back(), milli-seconds : 4790
(4) `__pool_alloc`  内存池
how many elements: 1000000
a lot of push_back(), milli-seconds : 7357
(5) `__mt_alloc`  多线程
how many elements: 1000000
a lot of push_back(), milli-seconds : 4881
(6) `bitmap_allocator`
how many elements: 1000000
a lot of push_back(), milli-seconds : 7420
{% fold %}
```cpp
#include <list>
#include <stdexcept>
#include <string>
#include <cstdlib>      //abort()
#include <cstdio>       //snprintf()
#include <algorithm>    //find()
#include <iostream>
#include <ctime> 
#include <ext\array_allocator.h>
#include <ext\mt_allocator.h>
#include <ext\debug_allocator.h>
#include <ext\pool_allocator.h>
#include <ext\bitmap_allocator.h>
#include <ext\malloc_allocator.h>
#include <ext\new_allocator.h>  
using namespace std;
int main(){
     
    //不能在 switch case 中宣告，只好下面這樣.               //1000000次 
    list<string, allocator<string>> c1;                     //3140
    list<string, __gnu_cxx::malloc_allocator<string>> c2;   //3110
    list<string, __gnu_cxx::new_allocator<string>> c3;      //3156
    list<string, __gnu_cxx::__pool_alloc<string>> c4;       //4922
    list<string, __gnu_cxx::__mt_alloc<string>> c5;         //3297
    list<string, __gnu_cxx::bitmap_allocator<string>> c6;   //4781 
    int choice;
long value;     

    cout << "select: "
         << " (1) std::allocator "
         << " (2) malloc_allocator "
         << " (3) new_allocator "
         << " (4) __pool_alloc "
         << " (5) __mt_alloc "
         << " (6) bitmap_allocator ";
    
    cin >> choice;
    if ( choice != 0 ) {
        cout << "how many elements: ";
        cin >> value;       
    }
            
char buf[10];           
clock_t timeStart = clock();                                
    for(long i=0; i< value; ++i)
    {
        try {
            snprintf(buf, 10, "%d", i);
            switch (choice) 
            {
                case 1 :    c1.push_back(string(buf));  
                            break;
                case 2 :    c2.push_back(string(buf));  
                            break;      
                case 3 :    c3.push_back(string(buf)); 
                            break;      
                case 4 :    c4.push_back(string(buf));  
                            break;      
                case 5 :    c5.push_back(string(buf));      
                            break;      
                case 6 :    c6.push_back(string(buf));  
                            break;              
                default: 
                    break;      
            }                   
        }
        catch(exception& p) {
            cout << "i=" << i << " " << p.what() << endl;   
            abort();
        }
    }
    cout << "a lot of push_back(), milli-seconds : " << (clock()-timeStart) << endl;      
    return 0;
}
```
{% endfold %}
可以直接使用allocate 但是不要用 小分配用malloc 大分配用容器
```cpp
__gnu_cxx::bitmap_allocator<int> alloc6;    
p = alloc6.allocate(3);  
alloc6.deallocate(p,3);  
```
