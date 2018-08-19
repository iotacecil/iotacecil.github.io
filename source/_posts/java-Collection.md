---
title: java-Collection
date: 2018-04-28 18:55:55
tags:
---
# 集合框架
![java_collections](/images/java_collections.jpg)
![collection](/images/collection.jpg)
![collection2](/images/collection2.jpg)
1. 三大接口：`Iterator`,`Collection`,`Map`
2. 工具类：`Collections` `Arrays`

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
    ![rotate](/images/rotate.jpg)
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

## Optional
创建：
1. `of`工厂方法`Optional.of("abb");`
2. `ofNullable`:如果为空返回empty()空的optional`Optional.ofNullable("abb");`
3. `.empty()`

1. `isPresent`..


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
1. 键值set`Set<Map.Entry<Integer,String>> enry = map.entrySet();`
2. 值`Collection<String> cl = map.values();`
3. `forEach(BiConsumer<? super K, ? super V> action)`
4. 权限查询`.containsKey()`

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

### HashMap 数组+链表+（链表长度达到8，会转化成红黑树）
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