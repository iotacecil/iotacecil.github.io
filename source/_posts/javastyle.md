---
title: java风格练习
date: 2018-03-07 14:18:24
tags: [java]
category: java
---
### String
String+" "原来的string还是在的 要等垃圾回收
必用方法：
1.`char[] toCharArray()`
```java
 public char[] toCharArray() {
    // Cannot use Arrays.copyOf because of class initialization order issues
    char result[] = new char[value.length];
    System.arraycopy(value, 0, result, 0, value.length);
    return result;
}
```

---
2.`String(char[]value)` //offset,count
```java
    public String(char value[]) {
        this.value = Arrays.copyOf(value, value.length);
    }
```

---
3.每个字节对应的ASCII码
```java
Arrays.toString(str.getBytes())
```
---
4.`startsWith(String prefix,int toffset)`指定位置开始是否是prefix开头
5.`str.replaceAll("[0-9]","*")`,`str.replaceAll("\\d","*")`
6.拆分返回String[]`System.out.println(Arrays.toString(c1.split("\\d",4)));`
7.静态方法`valueOf()`转换各种类型为String

---
```java
final String b = "b";//变成了常量
String b1=b+"1";//编译期确定 =>String b2="b1" ==b1
```

```java
private static String getString(){//方法在运行期才能确定
    return "c";}
main{
final String c= getString();//加不加final都false 方法一定在运行期确定
String c1=c+1;
String c2="c1";
System.out.println(c1==c2);//不等
}
```

---
#### 源码：
1.final 的常量只能定义时赋值或在【默认】构造器里赋值一次
```java
private final char value[];
public String(String original) {
    this.value = original.value;//将常量池中的值赋值给新创建的String
    this.hash = original.hash;
}
```

---
### Object
1.`finalize` 对象被回收时调用 不建议重写
2.`public final native Class<?> getClass();` 获取对象的方法区的类信息

`Math.abs(Integer.MIN_VALUE+10085)`=-2147473563

---
### DecimalFormat
保留两位小数System.out.println(`new DecimalFormat("0.00").format(pi)`);
百分比`new DecimalFormat("#.##%").format(pi)`

---
### StringBuffer
```java
String c = a+b+1;//常量变量相加会产生5个对象 编译器会优化
String d = "a"+1+2+"b";//常量相加只有一个对象
```
---
```java
StringBuffer sb = new StringBuffer(32);
sb.append(a).append(b).append(1);//解决常量变量相加 产生3个对象
sb.toString();
```

---
### StringBuilder
`javap -c `查看编译后的指令
1.`String a ="a"+1;`会生成builder加入a1
2.`String b = a+"b";`执行一次append
```java
String c=null;
for(i in 5){
    c+=i;//会创建5个StringBuilder 应该用append拼接
}
```

---
### clone 不用创建过程 不用重新计算对象的大小
必须重写 
```java
@Override
public Object clone(){
    TreeNode newT = null;
    try{
        newT = (TreeNode)super.clone();
    }catch (CloneNotSupportedException e){
        e.printStackTrace();
    }
    return newT;
}
```

---
### Comparable<T> Comparator
1.Arrys.sort:底层实现
```java
Comparable pivot = (Comparable) a[start];
if (pivot.compareTo(a[mid]) < 0)
```
2.Comparator面向对象，对修改关闭对扩展开放
新建类
```java
xxxComparator implements Comparator<T>{
    compare(T o1,T o2){}
}```
sort传入比较器
`Arrays.sort(t1,new xxxComparator())`

---
### System
1.时间
```java
Date nowtime  = new Date(System.currentTimeMillis());
DateFormat df = new SimpleDateFormat("HH:mm:ss");
String now = df.format(nowtime);
```
2.`.exit()`退出JVM
3.当前工作目录`System.getProperty("user.dir")`
    os.name/os.version/user.name/user.home/java.home/java.version
4.安卓加载三方类库`System.loadLibrary`

---
### Runtime 不new靠静态方法获取对象
1. `Runtime rt = Runtime.getRuntime();`
可用处理器数量`rt.availableProcessors()`
jvm总内存数`rt.totalMemory()`
jvm空间内存`rt.freeMemory()`
jvm最大可用内存`rt.maxMemory()`
2. 执行命令行命令
`rt.exec("notepad")`

---
### vector 
1.ArrayListhe和Vector在用法上完全相同`addElement(Object obj)`和`add(Object obj)`没什么区别
```java
  public synchronized void addElement(E obj) {
    modCount++;
    ensureCapacityHelper(elementCount + 1);
    elementData[elementCount++] = obj;
}
```
```java
  public synchronized boolean add(E e) {
    modCount++;
    ensureCapacityHelper(elementCount + 1);
    elementData[elementCount++] = e;
    return true;
}
```
> Vector里有一些功能重复的方法,这些方法中方法名更短的是属于后来新增的方法.更长的是原先vector的方法.而后来ArrayList是作为List的主要实现类.

线程同步不应该使用Vector 应该使用
`java.util.concurrent.CopyOnWriteArrayList`

---
### `class Stack<E> extends Vector<E>`
> Deque 接口及其实现提供了 LIFO 堆栈操作的更完整和更一致的 set

`Deque<Integer> stack = new ArrayDeque<Integer>();`
`LinkedList<E> implements List<E>, Deque<E>,`

---
### ArrayDeque循环数组
https://github.com/CarpenterLee/JCFInternals/blob/master/markdown/4-Stack%20and%20Queue.md

`head`指向首端第一个有效元素，`tail`指向尾端第一个可以插入元素的空位

---
#### void addFirst(E e)
```java
 elements[head = (head - 1) & (elements.length - 1)] = e;//越界处理
 if (head == tail) doubleCapacity();
```
1.head前有空位 2.head是0，加到最后，如果最后是tail则扩容：
1. **elements.length必需是2的指数倍，elements - 1就是二进制低位全1**
2. 跟head - 1相与之后就起到了**【取模】**的作用
3. 当head-1=-1;相当于对其取相对于elements.length的补码(正数就是本身)

```java
int head = 10;
int length = 8;
//8->1000 ;7->0111;10-1=9->1001 ;->1
head = (head - 1) & (length - 1);
```

---
#### addLast
```java
elements[tail] = e;
if ( (tail = (tail + 1) & (elements.length - 1)) == head) doubleCapacity();
```

---
#### void doubleCapacity()
`System.arraycopy`
```java
native void arraycopy(Object src, //原数组 
    int  srcPos,//原数组起始位置
    Object dest, //目标数组
    int destPos, //起始
    int length); //长度
```
![doubleC](/images/doubleC.jpg)
```java
int p = head;
int n = elements.length;
int r = n - p; // head右边元素的个数
//复制右半部分，对应上图中绿色部分
System.arraycopy(elements, p, a, 0, r);
//复制左半部分，对应上图中灰色部分
System.arraycopy(elements, 0, a, r, p);
```

---
### pollFirst()删除并返回Deque首端(head)元素
{% fold %}
```java
 public E pollFirst() {
    int h = head;
    @SuppressWarnings("unchecked")
    E result = (E) elements[h];
    // Element is null if deque empty
    if (result == null)
        return null;
    elements[h] = null;     // Must null out slot
    head = (h + 1) & (elements.length - 1);
    return result;
}
```
{% endfold %}

---
#### pollLast()
`int t =(tail-1)&(element.length-1);`

---
#### E peekFirst()&E peekLast 返回但步删除
---
### LinkedList 双向链表
`Queue queue = new LinkedList();`
内部静态类Node

---
### map
遍历：
```java
for(Map.Entry<String,String> entry:map.entrySet()){}
```

---
[java那些事](https://zhuanlan.zhihu.com/p/28016098)
[ava API: Holder 对象](https://www.ibm.com/support/knowledgecenter/zh/SSS28S_8.2.0/API/api_reference_holder_objects_java-filter_java.html)
1. 1000_000编译器会直接删除_
2. 十六进制p表示指数
3. $专门出现在自动产生的变量名中
4. 方法外声明常量 static final （因为和对象无关，声明成类变量）
5. 负数小心用%
6. 浮点寄存器优化 strictfp修饰符
7. (int).. cast操作符警告 用Math.toIntExact会异常（越界or丢精度）

8. java不允许对象使用操作符 必须调用方法
9. input.split("\\s+")以空格分割
10. 在null上调用方法会空指针异常，所以与字面量比较要将文字串放前`"word".equals(word)`
- code point 有效的unicode值

---
### Random
1. (1L << 48) - 1

---
### Integer
```java
Integer i3 =100;Integer i4= 100;
i3==i4;//(true)同一个对象
```
> 享元模式：共享对象 将1字节以内的数缓存

- IntegerCache缓存数组 为避免重复创建对象
- private static 内部静态类 只能在该类中访问,static用来做缓存
`new Integer(2)==new Integer(2)` false
`Integer.valueOf(2)==Integer.valueOf(2)` true 变成1000的时候因为缓存不一样
`Integer.valueOf(2).intValue()==2` true
`new Integer(2).equals(new Integer(2))` true

```java
//缓存-128到127之间的值
 cache = new Integer[(high - low) + 1];
            int j = low;
            for(int k = 0; k < cache.length; k++)
                cache[k] = new Integer(j++);

```

---
```java
Integer i3 =1000;Integer i4= 1000;
i3==i4;//(false)new了两个对象
```
```java
 public static Integer valueOf(int i) {
        if (i >= IntegerCache.low && i <= IntegerCache.high)
            return IntegerCache.cache[i + (-IntegerCache.low)];
            //没用cache返回了新对象
        return new Integer(i);
    }
```

**结论：Integer要用equals**
-  char2int: b.charAt(i--)-'0'; 

---
### StringBuilder
1. `StingBuilder`线程不安全
2. 连接大量字符串 .append .toString()

---
### StringBuffer
1. 线程安全
public `synchronized` StringBuffer append(String str) 
-  CharSequence字符序列类

---
### euqals
- 没有实现equals的类：继承Object

```java
public boolean equals(Object obj) {
	//是否指向同一对象，equal和==相同
        return (this == obj);
    }
    ```
- Integer的实现

```java
public boolean equals(Object obj) {
	//判断类型
        if (obj instanceof Integer) {
    //？？强制转型
            return value == ((Integer)obj).intValue();
        }
        return false;
    }
public int intValue() {
        return value;
    }
```

- String实现

```java
public boolean equals(Object anObject) {
	//指向引用
        if (this == anObject) {
            return true;
        }
        //类型 写法注意！！
        if (anObject instanceof String) {
            String anotherString = (String)anObject;
            int n = value.length;
            //长度？？可以调用private的value
            if (n == anotherString.value.length) {
                char v1[] = value;
                char v2[] = anotherString.value;
                int i = 0;
                while (n-- != 0) {
                    if (v1[i] != v2[i])
                        return false;
                    i++;
                }
                return true;
            }
        }
        return false;
    }
```

### ArrayList
> fianl修饰的变量，JVM也会提前给我们初始化好。???

```java
//变量
private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};
transient Object[] elementData;

//构造函数，避免反复创建无用数组 指向同一个缓存Object[]数组
this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
if (initialCapacity == 0) {
    this.elementData = EMPTY_ELEMENTDATA;}

```
---
- `.add(e)`
1. 创建Object数组，并拷贝 ->ensureCapacityInternal(size+1) 
->ensureExplicitCapacity(size+1);
->grow(size+1)->Arrays.copyOf
->new Object[newLength]，System.arraycopy
2. elementData[size++] = e;
- object的长度为10，size为逻辑长度，不是数组长度，`minCapacity = Math.max(DEFAULT_CAPACITY=10, minCapacity`
- 第一次扩容：就一个元素，在堆内存中占了10个位置
- 之后扩容：`int newCapacity = oldCapacity + (oldCapacity >> 1);`//>>=/2
---
- `.remove(index)`

1.将index+1后的numMoved个元素从index开始复制obj->obj
```java
System.arraycopy(elementData, index+1, elementData, index,
                             numMoved); 
```
2.长度-1，最后一个null `elementData[--size] = null;`

---
- `.romove(Object o)` 循环查找o==null！=null->fastremove(index)(基本同上)

```java
//当o！=null,按List规范重写equal!!
if(o.equal(elementData[index])){
	fastRemove(index)
}

```

---
### Arrays
- `@SuppressWarnings("unchecked")`编译器消除警告
	- unchecked:执行了未检查的转换时的警告，例如当使用集合时没有用泛型 (Generics) 来指定集合保存的类型。
- Arrays.

---

### native
> native是由操作系统实现的，C/C++实现，java去调用。

- `Arrays.copyOf->System.arraycopy(org,0,copy,0,len)`

---
### Java8 
- default方法：接口内部有方法实现；实现两个接口有同名default名字冲突->报错

---
### package java.util;里的常用类
- Vector,Arraylist,LinkedList implements **List**
- LinkedList implents **Queue**
- ***List,Queue,Set*** implememts Collection

---
### Arraylist和Vector的区别
> 1. Vector是线程安全的，ArrayList不是线程安全的。
> 2. ArrayList在底层数组不够用时在原来的基础上扩展0.5倍，Vector是扩展1倍(可以改增量）。

vector:
```java
int newCapacity = oldCapacity + ((capacityIncrement > 0) ?capacityIncrement : oldCapacity);
```
> 加锁和释放锁,在单线程的环境中，Vector效率要差很多。

- 和ArrayList和Vector一样，同样的类似关系的类还有HashMap和HashTable，StringBuilder和StringBuffer，后者是前者线程安全版本的实现。

---
### synchronized JVM实现