---
title: java-Collection
date: 2018-04-28 18:55:55
tags:
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
## 集合框架
![collection.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/collection.jpg)
![collection2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/collection2.jpg)
1. 三大接口：`Iterator`,`Collection`,`Map`
2. 工具类：`Collections` `Arrays`

## Java提供的默认排序方法
1.`Arrays.sort()`
2.`Collections.sort()`（底层是调用 Arrays.sort()）

1.对于原始数据类型，目前使用的是所谓双轴快速排序（Dual-Pivot QuickSort），是一种改
进的快速排序算法，早期版本是相对传统的快速排序
`DualPivotQuicksort.java`
typically  faster than traditional (one-pivot) Quicksort implementations

### DualPivotQuicksort

2.对象数据类型 使用TimSort 归并和二分插入排序（binarySort）结合的优化排序算法
思路：
查找数据集中已经排好序的分区（这里叫 run），
然后合并这些分区来达到排序的目的。

#### Collections.sort->list::sort->Arrays.sort->TimSort.sort
`{1, 2, 3, 4, 5, 9,   7, 8, 10, 6}` 输出 6
`{9,8,7,6,5,4,  10}`输出6 并且`reverse(0,6)`->`[4, 5, 7, 6, 8, 9, 10]`
{% fold %}
```java 
private static <T> int countRunAndMakeAscending(T[] a, int lo, int hi,
                                                    Comparator<? super T> c) {
    assert lo < hi;
    int runHi = lo + 1;
    if (runHi == hi)
        return 1;
    // Find end of run, and reverse range if descending
    if (c.compare(a[runHi++], a[lo]) < 0) { // Descending
        while (runHi < hi && c.compare(a[runHi], a[runHi - 1]) < 0)
            runHi++;
        reverseRange(a, lo, runHi);
    } else {                              // Ascending
        while (runHi < hi && c.compare(a[runHi], a[runHi - 1]) >= 0)
            runHi++;
    }
    return runHi - lo;
}
private  void reverseRange(Object[] a, int lo, int hi) {
    hi--;
    while (lo < hi) {
        System.out.println(Arrays.toString(a));
        Object t = a[lo];
        a[lo++] = a[hi];
        a[hi--] = t;
    }
}
```
{% endfold %}


3.java8的` parallelSort` ForkJoin框架

---
## package java.util;里的常用类
![java_collections.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/java_collections.jpg)
- Vector,Arraylist,LinkedList implements **List**
- LinkedList implents **Queue**
- ***List,Queue,Set*** implememts Collection

### java9 of静态工厂不可变
Java 9 中，Java 标准类库提供了一系列的静态工厂方法，比如，List.of()、Set.of()，大大简
化了构建小的容器实例的代码量。不可变的，符合我们对线程安全的需求

## Vector ArryList LinkedList的区别
![collect.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/collect.jpg)

同：
1.都实现集合框架中的 List，有序集合。
2.都可以按照位置进行定位、添加或者删除的操作，都提供迭代器以遍历其内容。

不同：
1.Vector在扩容时会提高 1 倍，而 ArrayList 则是增加 50%。
vector:
```java
int newCapacity = oldCapacity + ((capacityIncrement > 0) ?capacityIncrement : oldCapacity);
```
2.只有Vector是线程安全的。

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
![doubleC.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/doubleC.jpg)
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



## Arrays.asList
String可以
```java
String[] ss = {"da","da"};
List<String> strings = Arrays.asList(ss);
```
基本数据类型不行
```java
int[] ss = {1,2};
List<int[]> ints1 = Arrays.asList(ss);
```
源码：基本数据类型
```java
public static <T> List<T> asList(T... a) {
    return new ArrayList<>(a);
}
```
## 泛型
### 泛型方法：
> 类型参数放在修饰符public static后，返回类型之前

1. 元素限定`<T extends AutoCloseable> void closeAll(ArrayList<T> elems)`确保Array的元素类型是AutoCloseable的子类；`extends`表示子类型、类型限定
- 多个限定`T extends Runnable & AutoCloseable`,只能有一个限定类，放在第一个，其它都是接口
2. Manager是Employee子类但`ArrayList<Manger>`不是`ArrayList<Employee>`子类
因为
```java
ArrayList<Manger> bosses = new ArrayList<>();
ArrayList<Employee> empls = bosses; //非法
empls.add(new Employee(...)); //可以在管理员列里添加普通成员
```
如果使用数组Manger[]和Employee[] 转型是合法的，但赋值会爆`ArrayStoreException`
> 如果不对ArrayList写操作，转换是安全的。可以用子类通配符

1. `<? extends Employee> staff`可以传Arraylist<Manager>
    1. staff.get(i)可以 可以将`<? extends Employee>`转成`Employee`
    2. staff.add(i)不行 不能将任何对象转成`<? extends Employee>`
2. 父类通配符`<? super Employee>`常用于函数式对象参数（用lambda调用）


### 泛型类型擦除
```java
List<String> l1 = new ArrayList<String>();
List<Integer> l2 = new ArrayList<Integer>();
//true
System.out.println(l1.getClass() == l2.getClass());
```
```java
List<Integer> l2 = new ArrayList<Integer>();
l2.add(1);
Method madd = l2.getClass().getDeclaredMethod("add",Object.class);
//[1, abc]
madd.invoke(l2,"abc");
```

### 泛型约束
3. 类型变量不能实例化 `T[] result = new T[n];`错误
    1. 以【方法引用】方式提供数组的构造函数`Sting[]::new`
    `IntFunction<T[]> constr` `T[] result = constr.apply(n)`
    2. 反射
    ```java
    public static <T> T[] repeat(int n,T obj,Class<T> c1){
    //编译器不知道类型，必须转换
    @SuppressWarnings("unchecked") 
    T[] result = (T[])java.lang.reflect.Array.newInstance(c1,n);
    for(int i=0;i<n;i++)result[i]=obj;
    return result;
    }
    ```
    调用`String[] greetings = repeat(10,"Hi",String.class);`
    3. 最简单的方法
    ```java
     public static <T> ArrayList<T> repeat(int n,T obj){
        ArrayList<T> result = new ArrayList<>();
        for(int i =0;i<n;i++) result.add(obj);
        return result;
    }
    ```
4. 泛型数组`Entry<String,Integer>[]`是合法的，但是初始化要@SuppressWarnings("unchecked")
正确方法：`ArrayList<Entry<String,Integer>>`

```java
//可以
List<Integer>[] gen = (List<Integer>[]) new ArrayList[10];
//可以
 List<Integer>[] graph=new ArrayList[numCourses];
```




## guava组件
1. `ImmutableList<String> ilist = ImmutableList.of("a","b");`不可变List
2. 过滤器
* 工具类`Lists`

```java
List<String> lit = Lists.newArrayList("aaa","ddd","bbb");
```
```java
Collection<String> cl =Collections2.filter(lit,(e)->e.toUpperCase().startsWith("a"));
```
3. 转换 (有问题)日期
```java
Set<Long> set = Sets.newHashSet(20170801L,20980320L,19950730L);
Collection<String> col = Collections2.transform(set,(e)->new SimpleDateFormat("yyyy-MM-dd").format(e));
```
4. 组合函数`Functions.compose(f1,f2)` 用google的`Function`

### 集合操作
1. 交集
`SetView<Integer> v1 = Sets.intersection(set, set2);`
2. 差集：只是1中没有在2中的元素
`.difference(s1,s2)`
3. 并集：把重复的只留一份

### `Mutiset`无序可重复 
```java
//输出[study, dayday, up, good x 2]
String[] sp = s.split(" ");
HashMultiset<String> hms = HashMultiset.create();
for(String str:sp){
    hms.add(str);}
```
获取次数
```java
 Set<String> ele = hms.elementSet();
for(String ss:ele){
    System.out.println(ss+":"+hms.count(ss));}
```

### `Multimap` Key 可以重复，一个键对应一个`Collection`
```java
//输出：
// 作者2 [书3]
// 作者1 [书2, 书1]
Multimap<String,String> mmap = ArrayListMultimap.create();
Map<String,String> map = new Hashtable<>();
map.put("书1","作者1");
map.put("书2","作者1");
map.put("书3","作者2");
Iterator<Map.Entry<String,String>> iter = map.entrySet().iterator();
while(iter.hasNext()){
    Map.Entry<String,String> entry = iter.next();
    mmap.put(entry.getValue(),entry.getKey());
}
for(String key:mmap.keySet()){
    Collection<String> value = mmap.get(key);
    System.out.println(key+" "+value);
}
```

### `BiMap` 双向map 键值都不能重复
`BiMap<String,String> map = HashBiMap.create();`
key和val可以反转`map.inverse()`

### 双键Map 行，列，值
`Table<String,String,Integer> table = HashBasedTable.create();`
获取条set`table.cellSet()`

## 多对多
拆分成两个一对多Student和Course生成StudentAndCourse
```java
class StudentAndCourse{
    private int id;
    private int cid;//添加在Course
    private int sid;//添加在Student
}
```

## Collections工具类
### 排序类：针对List（set不用排序）
1. `shuffle(list)`随机打乱
2. `reverse(list)`
3. `.sort()/(,Comparator c)`
4. `.swap`
    ```java
     public static void swap(List<?> list, int i, int j) {     
            final List l = list;
            l.set(i, l.set(j, l.get(i)));}
    ```
    ArrayList: set返回旧值
    ```java
    public E set(int index, E element) {
            rangeCheck(index);
            E oldValue = elementData(index);
            elementData[index] = element;
            return oldValue;
        }
    ```
5. `rotate(list,int)`i移动到(i+d)%size
    1. `rotate1(list, distance);` : 数组实现，并且长度小于100
        if (list instanceof `RandomAccess` ||`list.size()` < ROTATE_THRESHOLD)
        [leetcode的算法3](https://leetcode.com/problems/rotate-array/solution/)
    {% fold %}
    ![rotate.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/rotate.jpg)
    直接放在正确的位置上
    理解：把0位放到正确位置（distance)后，将这个位置继续当作0位，继续移动distance步，直到i回到0位
    ```java
     private static <T> void rotate1(List<T> list, int distance) {
            int size = list.size();
            if (size == 0)
                return;
            distance = distance % size;
            if (distance < 0)
                distance += size;
            if (distance == 0)
                return;
            /****以上得的了正确的distance size和distance有一个为零就不动***/
            for (int cycleStart = 0, nMoved = 0; nMoved != size; cycleStart++) {
                //size = 5
                T displaced = list.get(cycleStart);//1.得到[0]
                int i = cycleStart;
                do {
                    i += distance; //向前走3步
                    if (i >= size)
                        i -= size;//对长度取模
                    displaced = list.set(i, displaced);//2.赋值给[3],得到[3]的值
                    nMoved ++;//3.每位放一次一共执行size次同时退出for循环
                } while (i != cycleStart);
            }
        }
    ```
    {% endfold %}
    2. ```java
        reverse(list.subList(0, mid));
        reverse(list.subList(mid, size));
        reverse(list);```

### 查找
1. `binarySearch`,`max`,`min`(遍历compare/compareTo)
2. `fill(List,o)`填充 （遍历调用set）
3. `frequency(c,o)`c中与o相等元素数量（遍历equals)
4. `replaceAll(list,old,new)`遍历equals，set

### 同步重建，加上代码块的锁
只有vector/hashtable比较古老是安全的
1. `synchronizedList(list)`...

### 设置不可变的集合emptyXXX,singletonXXX,unmodifiableXXX
1. `EmptyList`防空指针
2. `UnmodifiableCollection`重写了add、remove等方法，直接抛异常
3. `singletonMap`size=1

### 其它
- `disjoint(,)`没有相同元素返回true
- `addAll(c,T...)`全部加入c
- `reverseOrder(Comparator<T> cmp)`返回比较器
```java 
//反转排序[5, 4, 3, 2, 1]       
Collections.sort(list,Collections.reverseOrder());
```




## Iterator
1. ListIterator
2. Enumeration Vector使用`public Enumeration<E> elements()`
```java
Enumeration<Integer> es = v.elements();
while(es.hasMoreElements()){
    System.out.println(es.nextElement());
}
```

### 迭代器设计模式
1.迭代器接口 2.迭代器的实现（用构造函数传入（3））3.抽象类 4.具体类（return new迭代器） 

## forEach jdk1.8
1. ArrayList:`public void forEach(Consumer<? super E> action)`
    `Consumer`接口：`void accept(T t);`
    ```java
    default void forEach(Consumer<? super T> action) {
        Objects.requireNonNull(action);
        for (T t : this) {
            action.accept(t);
        }
    }
    ```

---
## Map
![map.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/mapjpg)

1. 键值set`Set<Map.Entry<Integer,String>> enry = map.entrySet();`
2. 值`Collection<String> cl = map.values();`
3. `forEach(BiConsumer<? super K, ? super V> action)`
4. 权限查询`.containsKey()`
5. 遍历：
```java
for(Map.Entry<String,String> entry:map.entrySet()){}
```

### Map接口中的新方法
1. `getOrDefault(Object key, V defaultValue)`不存在返回默认值
```java
 return (((v = get(key)) != null) || containsKey(key))? v: defaultValue;
```
2. `V putIfAbsent(K key, V value)`不覆盖添加 原本的put覆盖并返回旧值
```java
V v = get(key);
if (v == null) {v = put(key, value);}
```
3. `boolean remove(Object key, Object value)`保证key和val都有
```java
 Object curValue = get(key);
if (!Objects.equals(curValue, value) ||
    (curValue == null && !containsKey(key))) {
    return false;
}
remove(key);
return true;```
4. `boolean replace(K key, V oldValue, V newValue)`
5. `V compute`对key位置上的kv对用BiFunction最后更新并返回计算后的值
`put(key, newValue);`
```java
map.compute(1,(k,v)->v+="1");
map.computeIfAbsent(5,(k)->"空空空");
```
6. `merge`
```java
map.merge(1,"222",(oldv,newv)->oldv+newv);
```

### TreeMap

### TreeSet
```java
// Dummy value to associate with an Object in the backing Map
    private static final Object PRESENT = new Object();
```

### HashMap 数组+链表+（链表长度达到8，会转化成红黑树）
不是同步的，支持 null 键和值

> Ideally, under random hashCodes, the frequency of nodes in bins follows a **Poisson distribution**with a parameter of about 0.5 on average for the default resizingthreshold of 0.75,
> 负载因子0.75的清空下，bin满足泊松分布(exp(-0.5) * pow(0.5, k) /factorial(k)). 
> 落在0的桶的概率有0.6


> 用树存储冲突hash when bins contain enough nodes to warrant use`TREEIFY_THRESHOLD = 8;`

1. 计算hash值 【扰动函数】
```java
static final int hash(Object key) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```
实验：
```java
int a = (65535<<2)+1;
//262141 111111111111111101
System.out.println(a+" "+Integer.toBinaryString(a));
//32是表长
int hash=a^(a>>>16);
//输出：11 反转最后两位 
//扰动(如果>65536，右移16位) 
//低16与高16位`^`,混合hash的高位低位
System.out.println(Integer.toBinaryString(a>>>16));
int index = (32-1)&hash;
/*
111111111111111110
11111//只取了低位
-------------
11110->30
*/
System.out.println(Integer.toBinaryString(hash));
System.out.println(Integer.toBinaryString(31));
System.out.println("-------------");
System.out.println(Integer.toBinaryString(index));
//262142 30
System.out.println(hash+" "+index);
```
2. `put(K key, V value) {return putVal(hash(key), key`
3. `putVal`
```java
 n = (tab = resize()).length;
 if ((p = tab[i = (n - 1) & hash]) == null)//n=length=16
            tab[i] = newNode(hash, key, value, null);
```
4. putVal如果Node链表太长
```java
 if (binCount >= TREEIFY_THRESHOLD - 1) //TREEIFY_THRESHOLD==8
    treeifyBin(tab, hash);//变成红黑树
```
`TreeNode<K,V> extends LinkedHashMap.Entry<K,V>`
65536(2^16)>>>16 ==1
1. ***table uses power-of-two masking***
- 为了用`&2^n-1`取模 2^n的table长不是素数很容易冲突
2. ***spreads the impact of higher bits downward**
* int类型自带hashCode范围-2147483648到2147483648
* `i = (n - 1) & hash` 插入位置 n-1=15是1111低位掩码高位归零
* int长32`>>>16`是int的高16位，低16与高16位`^`,混合hash的高位低位
{% note %}
`key1=0ABC0000 & (16-1) = 0`（8个16进制数，共32位）
`key2=0DEF0000 & (16-1) = 0`
hashcode的1位全集中在前16位。key相差很大的pair，却存放在了同一个链表
把hashcode的“1位”变得“松散”，比如，经过hash函数处理后，0ABC0000变为A02188B，0DEF0000变为D2AFC70
{% endnote %}


### Hashtable 数组加链表没用二叉树
数据结构一样的名字不同：
hashtable:`private transient Entry<?,?>[] table;` 默认大小11
hashmap: `transient Node<K,V>[] table;`

### LinkedHashMap 双重链表

## set
1. String、Path都有很好的hash函数
2. 顺序遍历集合`TreeSet`实现了`SortedSet`和`NavigableSet`接口
3. set的元素必须实现`Comparable`接口或者构造函数中有Comparator

### HashSet
1. HashMap实现,用空对象占位
```java
private transient HashMap<E,Object> map;
private static final Object PRESENT = new Object();
public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
```
2. 保持不重复 使用HashMap的 putVal
    1. 比较hashCode相同不一定是同一个对象，再比较equals
3. 重写放入hash的类的hashCode：

### LinkedHashSet 用链表记录插入的位置

### TreeSet 排序
1. 需要实现`Comparatable`或传入`Comparator`，会根据compare的值覆盖，去重
- `NavigableSet`使用元素自然顺序排序，or 用Comparator

---