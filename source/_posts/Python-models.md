---
title: Python modules
date: 2018-03-08 10:50:38
tags:
---
### deque GIL线程安全的 list不安全
copy：shallow copy 浅拷贝 id不一样。
看起来隔离了，但是如果deque里[2]是一个可变对象list，拷贝的是索引

深拷贝：
```python
import copy
user_deque2 = copy.deepcopy(user_deque)
```

### 多线程
1. global interpreter lock 全局解释器锁，
python线程对应c中的线程
一次只有一个线程在一个cpu上
同一时刻只有一个线程在一个cpu上执行字节码。
无法将多个线程映射到多个cpu上，并发受限

2. 同时修改global变量的两个线程会不安全
    py2和3不同。
    按字节码行数/时间片，会释放全局解释器锁。io操作也会释放

#### Condition 条件变量
两层锁：底层调用wait释放就能acquire。wait分配放入等待队列的锁，等notify。
实现了`__enter__`和`__exit__`可以用with语句 
`wait`：
1. 获得waitter锁
2. 放到Condition的waiters双端队列里
3. 会释放Condition的锁
`notify`:从waiters队列弹出一个，释放waiter锁

#### Semaphore控制进入数量

### socket
AF_IPX：linux进程间通信

SOCK_DGRAM：UDP

服务端`.bind(("0.0.0.0",8888))`而不是127.0.0.1（本机局域网ip访问不到）
客户端直接访问`.connect(('127.0.0.1',8888))`并且`send("".encode("utf-8"))`
send的时候一定要发送byte类型

### socket模拟http请求
```python
client = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
client.connect((host,80))
client.sent("GET {} HTTP/1.1\r\nHost: {}\r\nConnection:close\r\n\r\n"
    .format(path,host).encode("utf8"))
```

### 装饰器
1. LEGB：
	1. encloseing函数内部与内嵌函数之间 【闭包】

#### 装饰器与AOP

- reload


	
#### 1. 函数元数据
```python
def f():
    cc = 2
    return lambda kk:cc**kk #不会因为f退出以后lambda访问不到a
g = f()
g.__closure__[0].cell_contents
### 输出2 可以访问到cc
```

#### 2. nonlocal
嵌套的def中。允许修改修改嵌套作用域变量。
把信息和回调函数联系起来：lambda or __call__

1. timeout 是闭包内的一个自由变量，在setTimeout中
`timeout = k `会创建本地timeout.
`nonlocal`声明嵌套作用域下的变量
2. 可修改参数的装饰器 为包裹函数添加一个属性函数，修改自由变量
```python
from functools import wraps
import time
import logging
def warn(timeout):
    def decorator(func):
        def wrapper(*args,**kargs):
            start = time.time()
            res = func(*args,**kargs)
            used = time.time() -start
            if used >timeout:
                msg = '%s:%s>%s' % (func.__name__,used,timeout)
                logging.warn(msg)
            return res
	        #作为wrapper的一个属性 
	        def setTimeout(k):
	            nonlocal timeout
	            timeout = k
	        # 可以被调用
	        wrapper.setTimeout = setTimeout
        return wrapper
    return decorator
```
测试：
```python
from random import randint
@warn(1.5)
def test():
    print('int test')
    while randint(0,1):
        time.sleep(0.5)
test.setTimeout(1)
for _ in range(30):
    test()
```

#### py2中没有nonnocal
不能修改变量的引用，将timeout实现成一个可变对象
```python
def warn(timeout):
	timeout = [timeout]
		...
		def setTimeout (k):
			timeout[0]=k
```

### hashable
> 不可哈希的元素有：list、set、dict
> 可哈希的元素有：int、float、str、tuple
- unhashable type: 'set' ，`dicc = {set([1]):222}` set 不能当字典键 用frozenset
```python
#输出交集
    if item&frozenset(['2']):
        print item
    if item.intersection('2'):
        print item

```

### frozenset
不可变 存在hash值 没用add\remove
将集合作为字典的键值
dict.update()
- 求并
```python
a =frozenset([3])
b =frozenset([2])
list=[]
list.append(a|b)
list
Out[12]: [frozenset({2, 3})]
```

- `s.issuperset(t)` 测试是否 t 中的每一个元素都在 s 中  

- Python虚拟机是单线程（GIL）只有I/O密集型才能发挥Py的并发行，计算密集型值需要轮询。
>  配置utf-8输出环境
reload(sys)
sys.setdefaultencoding('utf-8')

### string
`splitlines()` 按照行('\r', '\r\n', \n')分隔
`splitlines(True)`保留换行符

#### 内置函数 
```python
row = [p == '+' for p in line.split()[0]]#转换成T,F序列
#对一个区间更改值
row[i:j]=[not p for p in row[i:j]]
all(row)
#如果iterable的所有元素不为0、''、False或者iterable为空，all(iterable)返回True，否则返回False；

```
- 返回对象的内存地址。 id(a)==id(b)
- issubclass(AA,A) AA是否是A的子类
- python的=是引用 a=1,a=2 右值是int对象 id(a)改变
#### 数字
`'{0:o},{1:x},{2:b}'.format(64,64,64)`
八进制、16进制、2进制

#### enumerate 偏移值(index,value)
`for (offset,item) in enumerate('apple'):print(item,offset)`
help(enumerate)

#### 模块
import sys
sys.path #模块搜索路径
1. roload
#### copy
[python3 copy源码分析](https://blog.wqlin.me/2017/05/01/python-copy-and-deepcopy/)
- immutable类型: int,float,complex |string tuple frozen set
- mutable: `list,dict,set,byte arry` **copy使用各自的copy函数**
```python 
copy.py
d[list] = list.copy
d[dict] = dict.copy
d[set] = set.copy
d[bytearray] = bytearray.copy
```
- a= (1,2,[3]) tuple中的list可变 
`a[1]=10` id(a) list的地址空间不变

```python
x= [[1,2,3]] 
y= x.copy(x)//y=copy.deepcopy(x)
```
-  `.copy(x)` 浅
id(x)!=id(y) id(x[0])==id(y[0])

- `.deepcopy(x)` 深
id(x[0])==id(y[0])递归调用

#### 生成器
1. `g = (x * x for x in range(10))`
2. 每次调用next()遇到下一个yield返回

#### 运算符重载
1. `__getattr__` 点号运算 `__getattribute__`属性获取
2. `__getitem__` 列表解析、元组赋值，map、for循环，索引、分片运算；L[::]分片是L(slice(,,)分片对象)的语法糖，getitem接收了slice对象
3. `__get/setslice__`已移除
4. `__iter__` 迭代环境优先尝试iter

#### 读文件
1. 读文件的最佳方式`for line in open()`,readlines将整个文件加载到内存
2. while True：line = f.readline()比迭代器的for慢，因为迭代器以C语言速度运行，while循环版本通过py虚拟机运行python字节码
##### 迭代
1. for循环开始时，通过iter内置函数从迭代对象获得一个迭代器。返回的对象有__next__方法。
2. 文件对象就是自己的迭代器。有自己的next方法
3. iter()启动迭代
#### 注解
#### 内置作用域
- import builtins dir(builtins)
前一半是内置的异常，后一半是内置的函数
- LEGB法则python将最后扫描B模块 所以不需要导入

#### global
```python
b=0
def update(item):
	global w
```
- 在函数和类中对全局变量赋值，必须在该函数或者类中声明该变量为全局变量，否则经过赋值操作后，变量为本地变量。

#### 第二章
1. .pyc保存py编译后的字节码（不是二进制码，py特定）
2. PVM 虚拟机 py引擎编译得到的代码

- pandas.Series是以时间戳为索引的
- 差分计算series.diff()切片

滞后观察（lag observation）列以及预测观察（forecast observation）
resample 重采样、频率推断、生成固定频率日期范围
#### matplotlib动画

#### lambda 匿名函数
返回函数对象

#### 列表解析
##### map
ord()返回单个字符的ASCII整数编码
- `map(f,list)`将传入的函数依次作用到序列的每个元素，并把结果作为新的list返回。
- reduce把一个函数作用在一个序列[x1, x2, x3...]上，这个函数必须接收两个参数，reduce把结果继续和序列的下一个元素做累积计算
`reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)`
```python
res = list(map(ord,'spam'))
res = [ord(x) for x in 'spam']
#res =[115, 112, 97, 109]

[line.rstrip() for line in open('file').readlines()]
list(map((lambda line:line.rstrip()),open('file')))
#['aaa','bbb']

listoftuple=[('bob',35,'mgr'),('amy',40,'dev')]
list(map(lambda row:row[1]),listoftuple)
#[35,40]

#自己实现map 
def mymap(func,*seqs):
	res=[]
	for args in zip(*seqs):
	# *args 参数传递语法 可以收集多个序列
		res.append(func(*args))
	return res
def mymap(func,*seqs):
	return [func(*args) for args in zip(*seqs)]

```
- reduce:累积求和:sum(list)string2int


##### zip
zip是map的一个基本嵌套操作
```python
list[zip([1,2,3],[2,3,4,5])]
#[(1,2),(2,3),(3,4)]
```
- 列表中是表；元组为行，列是元组中的元素

__cmp__已经移除
```python
def tester(start):
	state = start #赋值过
	def nested(lasted):
		nonlocal state #允许改变 必须已经在def作用域中赋值过
		print(label,state)
		state+=1
	return nested
F= tester(0)
F('abc') #abc 0
#每次调用F state都会+1
```
##### 用函数属性实现nonlocal??
P440
```python
def tester(start):
	def nested(label):

```

#### __call__让类看起来是一个可调用的函数
```python
class tester:
	def __init__(self,start):
		self.state =  start
	def __call__(self,lable):
		print(label,self,state)
		self.state+=1
M = tester(99)
M('juice')#juice 99
#每次调用M state+1
```

#### operator
1. b=operator.itemgetter(1) 获取对象的1索引
2. b(a) 获取 list a 的1索引
3. operator.itemgetter 定义了一个函数，作用到对象上获取值
4. 与sorted一起用：sorted(dict,key = lambda x:x.values())按字典的values排序
	- 按二维list中子元素的第三项排序 key = lambda student:student[2]/key = operator.itemgetter(2) 
	- operator.itemgetter(1,2) 第二项和第三项


#### panda 坑
`data = pd.read_csv('.\a.csv', parse_dates=['Month'], index_col='Month',date_parser=dateparse)`
- Only booleans, lists, and dictionaries are accepted for the 'parse_dates' parameter `parse_dates=['Date']` instead of `parse_dates='Date'`
