---
title: busyman Notes
date: 2018-03-21 13:59:49
tags: [java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
signature???
方法签名就由方法名+形参列表构成

## 并行
1. 计算很长数组的总和
```java
long sum = IntStream.of(a).parallel().sum();
```

## Stream
1. 统计一本书中的长单词
    \PL
    {% qnimg pl.jpg %}
    拆分单词
    ```java
    String contents = new String(Files.readAllBytes(Paths.get(""),StandardCharsets.UTF_8));
    List<String> words = Arrays.asList(contents.split("\PL+"));
    ```
    stream代替迭代 
    ```java
    long count = aaa.stream().filter(w->w.length()>12).count();
    System.out.println(count);
    ```
2. 所有单词转换成小写
```java
Stream<String> lower = words.stream().map(String::toLowerCase);
```
3. 每个单词的第一个字母
```java
Stream<String> first = words.stream().map(s->s.substring(0,1));
```

### 创建流
1. 集合->流：Collection.stream()
2. 数组->流：Stream.of
3. Arrays.stream(array,from,to)

### 方法
1. `Stream<Stream<String>>`用`.flatMap(lambda)`
2. `.limit(int)`前int N个元素；`.skip(n)`丢弃前n个元素；`.concat(stream,stream)`拼接流
3. `.distinct()`删除重复元素
4. `Optional`防止空指针引用，对null封装默认值

### 收集
1. `toArray`
2. `stream.collect(Collectors.toList/toSet/toCollection(TreeSet::new))`
3. 收集一个国家的语言`Map<String,List<Local>>'`处理相同键
    1. 分类函数：`.collect(Collectors.groupingBy(Local::getCountry))`
    2. 当分类函数是布尔值`.partitioningBy(l->l.getLanguage().equal("en"));`
    3. groupingBy可以针对`List<Local>`加下游收集器参数`toSet()`等
4. 求一个流所有字符串总长度,reduce要求(T,T)->T返回值和参数 类型一样
累加器函数：`(total,word)->total+word` reduce并行所以最后total要汇总（注意线程安全）
```java
int result = aaa.stream().reduce(0,(total,word)->total+word.length(),
    (total1,total2)->total1+total2);
```
映射到一个数字流
```java
int m2i=aaa.stream().mapToInt(String::length).sum();
```

### 避免装箱，基本类型流
1. byte\short\char\boolean使用`IntStream.of(1,2,3,4)`和Arrays.stream

### 并行流
1. 不能使用`paralineStream.forEach` forEach中的函数会在多个线程中并发执行，更新共享的数组
1. 按长度将字符串进行分组并计数
```java
Map<Integer,Long> shortWordCount = aaa.parallelStream()
    .filter(s->s.length()<10)
    .collect(groupingBy(String::length,counting()));
```
并发收集
```java
Map<Integer,List<String>> result = aaa.parallelStream()
    .collect(Collectors
        .groupingByConcurrent(String::length));
```
值是次数
```java
Map<Integer,Long> result = aaa.parallelStream()
    .collect(Collectors
        .groupingByConcurrent(String::length,counting()));
```


### Properities
```java
Properties st = new Properties();
st.put("",);
try(OutputStream out = Files.newOutputStream(path)){
    st.store(out,"name");
}
```

### EnumSet
EnumSet没有公共构造函数，使用静态工厂方法构造EnumSet：
```java
enum Weekday{MONDAY};
Set<Weekday> alwarys = EnumSet.allof(Weekday.class);
```
EnumMap指定[键]类型
```java
EnumMap<Weekday,String> personInChange = new EnumMap<>(Weekday.class);
```

### BitSet用户标识位序列 第i个位置位1表示i在集合内

### 栈、队列等
1. 栈
没有Stack接口，有Stack类，避免使用。
使用`ArrayDeque<String> stack = new ArrayDeque<>();`
2. 优先队列和作业调度
`PriorityQueue<Job> jobs = new PriorityQueue<>();`
容纳实现了Comparable的类

> WeakHashMap:当键的唯一引用来自哈希表条目，删除键/值

### 视图 KeySet、values、asList方法生成视图
1. 范围range 任何子列表的添加删除都会影响原先列表
```java
List<String> st = ;
List<String> nextfive = st.subList(5,10);
```
 有序集合通过上下界 输出[1,2]
```java
 TreeSet<String> words = new TreeSet<>();
words.addAll(Arrays.asList(new String[]{"1","2","3","4","5","6"}));
SortedSet<String> asOnly = words.subSet("1","3");
System.out.println(asOnly);
```
轻量级创建map类型的属性
```java
Collections.emptyMap()
System.out.println(Collections.singletonMap("id","222"));
```
- 检查视图，检查错误类型（堆污染）,监视ArrayList<String>
```java
List<String> strings = Collections.checkedList(new ArrayList<>(),String.class);
```
- 不要使用Collections的同步视图，并发使用util.concurrent的数据结构


### 迭代器
`Iterator<String> iter= coll.iterator()`
- `coll.removeIf(e->e fulfill the condition`
- `iter.remove()`移除最后一个访问的元素，不是指向元素，不能两次连用remove


## 异常
{% qnimg throwable.jpg %}
1. 已检查错误：可提前预知 IOException。
`Integer.parseInt(str)`检查str是否是整数是可能的
    - 覆盖方法时，不能抛出比父类方法中声明更多的已检查异常
    - `@throws`异常注释文档化
    - 实现了`AutoCloseable`/`Closeable`的类
        `try(PrintWriter out = new PrintWriter("out.txt")`{}保证了out.close()必会调用，替换finally{in.close()}因为close可能异常
    - ·`ex.getSuppressed()`捕获了主要异常时检测得到第二个异常
    - 可以catch到已检查异常后连接到未检查异常
    - 检测非空值```java
    public void process(String directions){
        this.directions = Object.requireNonNull(directions,"空指针");
    }
    ```
    会抛出空指针异常

### Logger代替print：7种级别
默认会记录INFO及更高级别。CONFIG/FINE/FINER.FINEST对用户无意义
```java
Logger.getGlobal().info(()->ex.getMessage());
Logger logger = Logger.getLogger("com.Logger");
```
log输出到文件用户文件夹下java`n`.log
```java
FileHandler handler = new FileHandler();
logger.addHandler(handler);
```
2. 未检查：逻辑错误：NullPointerExcepter
`Class.forName(str)`不可能知道类能否成功加载。


## 接口
2. 要使用子类的方法，强制cast，先检查类型
```java
if (a instanceof B){
	B b = (B)a;
}
```
3. Collection/AbstractCollection/Collections,Path/Paths
4.  default Stream<E> stream() 接口中添加了，为了保持兼容以前版本，写了默认方法

### Comparable 接口
1. 返回不一定是1,-1,0；
- 当两个大负数相减可能变正，用Integer.compare()
- 浮点数 Double.compare()
- Arrays.sort()可以对Comparable对象数组进行排序

### Comparator 接口
不能更改String的compareTO,创建一个Comparator实现类。
1. 创建Comparator<String> comp 对象=new 实现了接口的对象();
2. 在Comparator对象上调用.compare(,)
3. compare方法不是静态方法！ （？？？）
4. Arrays.sort(obj,new Comparatorobj)

### Runable 接口
1. `A implements Runnable{run(){}}`
2. new Thread(A).start

### UI回调
1. EventHandler<ActionEvent>

## lambda表达式
> 带有自由变量值的代码块是闭包。捕获闭合作用域中变量值

- lambda中只能引用值不变的量，不能捕获变量，也不能改变
```java
for(int i =0;i<n;i++){
	new Thread( ()-> sout(i) ).start(); //报错
}
```
- `for(Sting arg:args)`中的变量是final的，作用域是单个迭代 可以捕获；每个底碟会创建新的arg变量；for(i)的作用域是整个循环。

1. 只有一个抽象方法的接口对象，函数式接口
2. 将lambda表达式放入类型为函数式接口的变量中，转化成接口的实例
3. ArrayList removeIf(Predictae) //e->e==null
`removeIf(Object::isNull)`
```java
  default boolean removeIf(Predicate<? super E> filter) {
        Objects.requireNonNull(filter);
        boolean removed = false;
        final Iterator<E> each = iterator();
        while (each.hasNext()) {
            if (filter.test(each.next())) {
                each.remove();
                removed = true;
            }
        }
        return removed;
    }
```


### 函数式接口
`@FunctionalInterface` 单个方法的接口

### 高阶函数：返回函数的函数
#### 1. Comparator
1. `public static <T, U> Comparator<T> comparing(
            Function<? super T, ? extends U> keyExtractor,
            Comparator<? super U> keyComparator)`
- key提取器将类型T映射到可比较的类型
- `comparingDouble`避免装箱
- `nullsLast``nullsFirst`避免null抛出异常
- `naturalOrder()`适合实现了`Comparable`的类
2. thenComparing
---
- 局部内部类，实现接口的类。
- 方法中的类，可以接受方法中的值，不需要构造函数和存储在实例变量中。

- 匿名
---

### 继承和反射
- 代理对象实现接口，将所有方法路由到一个handler
- super() 因为子类不能访问父类的私有变量，所有要通过父类的构造函数初始化。


