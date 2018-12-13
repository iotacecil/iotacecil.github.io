---
title: java8
date: 2018-06-06 14:18:51
tags:
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
### JDK9 Reactive Stream


### Optional
创建：
1. `of`工厂方法`Optional.of("abb");`
2. `ofNullable`:如果为空返回empty()空的optional`Optional.ofNullable("abb");`
3. `.empty()`

1. `isPresent`..

其它库Guava，Apache Commons Collections ,ambdaj

### `Collector.java`接口提供者
> <T> the type of input elements to the reduction operation
 <A> the mutable accumulation type of the reduction operation (often hidden as an implementation detail)
 <R> the result type of the reduction operation

```java
public interface Collector<T, A, R> {
    //container容器
    Supplier<A> supplier();
    //操作
    BiConsumer<A, T> accumulator();
    //并行计算
    BinaryOperator<A> combiner();
    //返回结果
    Function<A, R> finisher();
    Set<Characteristics> characteristics();
}
```

#### toList()
```java
public static <T>
  Collector<T, ?, List<T>> toList() {
    return new CollectorImpl<>((Supplier<List<T>>) ArrayList::new, List::add,
       (left, right) -> { left.addAll(right); return left; },
       CH_ID);
}
```

1.CH_ID:
```java
static final Set<Collector.Characteristics> CH_ID
    = Collections.unmodifiableSet(EnumSet.of(Collector.Characteristics.IDENTITY_FINISH));
```

2.Set<Characteristics> characteristics();
Collecter的特征
```java
enum Characteristics {
//可以并行处理
    CONCURRENT,
//一般true 是否保持原来的顺序
    UNORDERED,
    IDENTITY_FINISH
}
```

#### stream().collect()
```java
public final <R, A> R collect(Collector<? super P_OUT, A, R> collector) {
    A container;
    if (isParallel()
            && (collector.characteristics().contains(Collector.Characteristics.CONCURRENT))
            && (!isOrdered() || collector.characteristics().contains(Collector.Characteristics.UNORDERED))) {
        container = collector.supplier().get();
        BiConsumer<A, ? super P_OUT> accumulator = collector.accumulator();
        forEach(u -> accumulator.accept(container, u));
    }
    else {
        container = evaluate(ReduceOps.makeRef(collector));
    }
    return collector.characteristics().contains(Collector.Characteristics.IDENTITY_FINISH)
           ? (R) container
           : collector.finisher().apply(container);
}
```

### .`Collectors`
1..groupingBy(Apple::getColor))
```java
Map<Dish.Type, List<Dish>> collect = menu.stream().collect(Collectors.groupingBy(Dish::getType));
```

2.计算平均数
averaging[Int/Long/Double]都返回`<T> Collector<T, ?, Double>`
```java
Optional.ofNullable(menu.stream().collect(Collectors.averagingInt(Dish::getCalories))).ifPresent(System.out::println);
```

3.`.collectingAndThen`
附加返回值
```java
Optional.ofNullable(menu.stream().collect(Collectors.collectingAndThen(Collectors.averagingInt(Dish::getCalories),a->"The ave"+a))).ifPresent(System.out::println);
```
变成不可变对象
```java
List<Dish> collect = menu.stream().filter(d -> d.getType().equals(Dish.Type.MEAT)).collect(Collectors.collectingAndThen(Collectors.toList(), Collections::unmodifiableList));
```

4.计数
```java
Optional.of(menu.stream().collect(Collectors.counting())).ifPresent(System.out::println);
Optional.ofNullable(menu.stream().collect(Collectors.groupingBy(Dish::getType, Collectors.counting()))).ifPresent(System.out::println);
```

5.转化成TreeMap
```java
TreeMap<Dish.Type, Double> collect = menu.stream().collect(Collectors.groupingBy(Dish::getType, TreeMap::new, Collectors.averagingInt(Dish::getCalories)));

```

6.Summary
```java
public class IntSummaryStatistics implements IntConsumer {
    private long count;
    private long sum;
    private int min = Integer.MAX_VALUE;
    private int max = Integer.MIN_VALUE;}
```

```java
IntSummaryStatistics collect = menu.stream().collect(Collectors.summarizingInt(Dish::getCalories));
```

7.groupingByConcurrent
```java
ConcurrentSkipListMap<Dish.Type, Double> collect = menu.stream().collect(Collectors.groupingByConcurrent(Dish::getType, ConcurrentSkipListMap::new, Collectors.averagingInt(Dish::getCalories)));
```

8.Collector<CharSequence, ?, String> `joining()`
前面必须是CharSequence类型,join中还可添加delimiter分隔符
```java
String collect = menu.stream().map(Dish::getName).collect(Collectors.joining(","));
```
前后加上分隔符joining(",","Names[","]")
输出：
Names[pork,...,salmon]

另一种mapping方法
IDEA会提示可以使用map().collect()
```java
.collect(Collectors.mapping(Dish::getName, Collectors.joining(",")))
```

9.maxBy/minBy
获得卡路里最高的
```java
Optional<Dish> collect = menu.stream().collect(Collectors.maxBy(Comparator.comparingInt(Dish::getCalories)));
```

10.partitioningBy
```java
Map<Boolean, List<Dish>> collect = menu.stream().collect(Collectors.partitioningBy(Dish::isVegetarian));
```
输出是/不是水果的卡路里平均值
{false=530.0, true=387.5}
```java
Map<Boolean, Double> collect = menu.stream().collect(Collectors.partitioningBy(Dish::isVegetarian, Collectors.averagingDouble(Dish::getCalories)));
        Optional.ofNullable(collect).ifPresent(System.out::println);
```

11 .reducing 可以加入map 相当于map(::).reduce(0,(,)->)
```java
Integer collect = menu.stream().collect(Collectors.reducing(0, Dish::getCalories, (d1, d2) -> d1 + d2));
```

12 .summingDdouble
```java
Double collect = menu.stream().collect(Collectors.summingDouble(Dish::getCalories));
```

13 .toCollection(LinkedList::new)
```java
Optional.ofNullable(menu.stream().collect(Collectors.toCollection(LinkedList::new))).ifPresent(System.out::println);
//可以变成
Optional.ofNullable(new LinkedList<>(menu)).ifPresent(System.out::println);
```

### lambda
execute around 环绕执行模式
泛型限制public static `<T>` List<T> filter(List<T>, Predicate<T> p)

lambda访问lambda主体中的引用（实例变量，静态变量） 在堆中
外层变量 在栈中 局部变量是final的，访问的是原始变量的副本。

```java
list.sort(Comparator.comparing(Integer::intValue));

public interface Comparator<T> {
 public static <T, U> Comparator<T> comparing(
        Function<? super T, ? extends U> keyExtractor,
        Comparator<? super U> keyComparator)
{
    Objects.requireNonNull(keyExtractor);
    Objects.requireNonNull(keyComparator);
    return (Comparator<T> & Serializable)
        (c1, c2) -> keyComparator.compare(keyExtractor.apply(c1),
                                          keyExtractor.apply(c2));
}}
```

#### 比较器链

```java
list.sort(Comparator.comparing(Integer::intValue).reversed().thenComparing(Integer::byteValue));
```
泛型数组 需要知道类型`(Item item)`
```java
arr.sort(Comparator.comparing((Item item )-> item.value / item.weight).reversed());
```

#### 谓词复合`.negate()`,`.and()`,`.or()`

#### 函数符合

1.`andThen`
```java
//g(f(x))
Function<Integer,Integer> f = x->x+1;
Function<Integer,Integer> g = x->x*2;
Function<Integer,Integer> h = f.andThen(g);
int result = h.apply(1);//4
```

2.`compose`
```java
//f(g(x))
Function<Integer,Integer> f = x->x+1;
Function<Integer,Integer> g = x->x*2;
Function<Integer,Integer> h = f.compose(g);
int result = h.apply(1);//3
```

3.创建流水线
```java
class Letter{
    String addHeader(String text){return "From:";}
    String addFooter(String text){return "Kind regards";}
    String checkSpelling(String text){return text.replaceAll("labda","lambda");}
}
Fucntion<String,String> addHeader = Letter::addHeader;
Fucntion<String,String> pipeline = addHeader.
    addThen(Letter::checkSpelling).
    addThen(Letter::addFooter);
```

### 闭包：函数的实例，可以无限制地访问函数的非本地变量。
lambda作闭包不能修改局部变量内容，lambda在新线程运行。会造成线程不安全。栈在线程之间不共享，堆在线程间共享。

---


### Stream 高级迭代器
pipelining 流水线式操作，方法返回一个流，可以链式操作
Collection.java
根据核数划分
```java
default Stream<E> stream() {
    return StreamSupport.stream(spliterator(), false);
}
```
查看线程：jconsole
Finalizer是垃圾回收器的线程
测试代码：
{% fold %}
```java
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import static java.util.stream.Collectors.toList;

class Dish {
    private final String name;
    private final boolean vegetarian;
    private final int calories;
    private final Type type;

    public Dish(String name, boolean vegetarian, int calories, Type type) {
        this.name = name;
        this.vegetarian = vegetarian;
        this.calories = calories;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public boolean isVegetarian() {
        return vegetarian;
    }

    public int getCalories() {
        return calories;
    }

    public Type getType() {
        return type;
    }

    @Override
    public String toString() {
        return name;
    }
    public enum Type { MEAT, FISH, OTHER }
}
public class streamm {
    private static List<String> byStream(List<Dish> menu){
        return menu.parallelStream().filter(d->{
            try{
                Thread.sleep(10000);

            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return d.getCalories()<400;
        }).sorted(Comparator.comparing(Dish::getCalories)).map(Dish::getName).collect(toList());

    }

    public static void main(String[] args) {
        List<Dish> menu = Arrays.asList(
                new Dish("pork", false, 800, Dish.Type.MEAT),
                new Dish("beef", false, 700, Dish.Type.MEAT),
                new Dish("chicken", false, 400, Dish.Type.MEAT),
                new Dish("french fries", true, 530, Dish.Type.OTHER),
                new Dish("rice", true, 350, Dish.Type.OTHER),
                new Dish("season fruit", true, 120, Dish.Type.OTHER),
                new Dish("pizza", true, 550, Dish.Type.OTHER),
                new Dish("prawns", false, 300, Dish.Type.FISH),
                new Dish("salmon", false, 450, Dish.Type.FISH) );
        List<String> dishNamesByStream = byStream(menu);
        System.out.println(dishNamesByStream);
    }
}
```
{% endfold %}
线程：多了3个ForkJoinPool.commonPool-worker-1/2/3

#### intermediate 中间方法

1.`Stream<T> filter(Predicate<? super T> predicate);`:intermediate将流删选减少数量

```java
str.filter((s)->s.length()>4).forEach(System.out::println);
```

2.`<R> Stream<R> map(Function<? super T, ? extends R> mapper);` 投影：映射成数量相同的另一个新流 

```java
str.map(s -> s.toUpperCase()).forEach(System.out::print);
```

`IntStream mapToInt(ToIntFunction<? super T> mapper);` 产生一个intStream
`Stream<T> limit(long maxSize);` :intermediate 删掉后面

#### terminal的
`void forEach(Consumer<? super T> action);` : terminal的
`void forEachOrdered(Consumer<? super T> action);` :terminal
`<A> A[] toArray(IntFunction<A[]> generator);` :terminal
`Optional<T> reduce(BinaryOperator<T> accumulator);` :terminal
`boolean anyMatch(Predicate<? super T> predicate);` :terminal
求和，最大值`Optional<T> reduce(BinaryOperator<T> accumulator);)`
```java
Optional<String> opt = str.reduce((s1,s2)->s1+s2)
String res = opt.get();
```

#### 静态方法
builder,of,empty
1. `of`

```java
Stream<String>str = Stream.of("good","study","good");
str.forEach((strr)-> System.out.println(strr));
```

2. 合并两个Stream

```java
public static<T> Stream<T> of(T... values) {
        return Arrays.stream(values);
    }
```
其它操作
去重`distinct`
```java
str.distinct().forEach(System.out::print);
```
---

### 创建流
Collection可以创建流
通过文件创建
```java
private static Stream<String> createStream(){
    Path path = Paths.get("./src/java8/aaa");
    try(Stream<String> lines = Files.lines(path)) {
        lines.forEach(System.out::print);
        return lines;
    } catch (IOException e) {
       throw new RuntimeException();
    }
}
public static void main(String[] args) {
    Stream<String> s = createStream();
}
```

### 无限流
```java
private static Stream<Integer> createfromiterator(){
    Stream<Integer> stream = Stream.iterate(0,n->n+2).limit(100);
    return stream;
}
createfromiterator().forEach(System.out::println);
//输出0，2，..198
```
无限随机数
```java
private  static Stream<Double> fromgenerate(){
    return Stream.generate(Math::random);
}
fromgenerate().forEach(System.out::println);
```

fib:
```java
Stream.iterate(new int[]{0,1}, t->new int[]{t[1],t[0]+t[1]})
            .limit(20).map(t->t[0])
            .forEach(System.out::print);
```

### 扁平化
`flatMap`两个集合一起
```java
Stream<List<Integer>> ss=Stream.of(Arrays.asList(1,2,3),Arrays.asList(4,5));
ss.flatMap(list->list.stream()).forEach(System.out::print);
```

```java
String[] words = {"hello","word"};
//{h,e,l,l,o},{w,o,r,l,d}
Stream<String[]> stream = Arrays.stream(words).map(w->w.split(""));
Stream<String> stringStream = stream.flatMap(Arrays::stream);
```
{1,2,3},{3,4}->{[1,3],[1,4]...[3,4]}
```java
List<Integer> numbers1 = Arrays.asList(1,2,3);
List<Integer> numbers2 = Arrays.asList(3,4);
List<int[]> pairs = numbers1.stream().flatMap(i->numbers2.stream().map(j->new int[]{i,j})).collect(Collectors.toList());
pairs.forEach(ints -> {
    System.out.println(Arrays.toString(ints));
});
```
只返回[2,4],[3,3]加起来是%3=0
```java
List<int[]> pairs = numbers1.stream().flatMap(i->numbers2.stream()
    .filter(j->(i+j)%3==0)
    .map(j->new int[]{i,j})).collect(Collectors.toList());
```

### 查找匹配 
allMatch
find：
```java
Optional<Integer> first = stream.filter(i -> i % 2 == 0).findFirst();
int sum = intStream.filter(i -> i > 3).sum();
```
reduce:.reduce(Integer::max)
拆箱：节省内存
mapToInt:IntStream intStream = stream.mapToInt(i -> i.intValue());
```java
@FunctionalInterface
public interface ToIntFunction<T> {
    int applyAsInt(T value);
}
```
装箱：`.boxed()`,`.mapToObj()`
给一个数a求1-100里找一个数可以与a勾股定理sqrt(a^2+b^2)%1=0（sqrt后不带小数）
`.rangeClose(start,end)`生成start-end中的所有数字
`range(1,100)`是开区间 不包括结束值
```java
int a =9;
IntStream.rangeClosed(1, 100).filter(b -> Math.sqrt(a * a + b * b) % 1 == 0)
    .boxed()//IntStream的map只能每个元素返回另一个int 应该流中每个元素是数组（onj）
    .map(x -> new int[]{a, x, (int) Math.sqrt(x * x + a * a)})
    .forEach(r-> System.out.println("a="+r[0]+",b="+r[1]+",c"+r[2]));
```
a也需要自动生成
```java
Stream<int[]> stream1 = IntStream.rangeClosed(1, 100)
    .boxed()
    //把三元流扁平成一个流
    //第二个值生成的range从第一个数c开始，去重复(3,4,5)(4,3,5)
    .flatMap(c -> IntStream.rangeClosed(c, 100)
    .filter(b -> Math.sqrt(c * c + b * b) % 1 == 0)
    //创建了三元流
    .mapToObj(b -> new int[]{a, b, (int) Math.sqrt(a * a + b * b)}));
stream1.forEach(r-> System.out.println("a="+r[0]+",b="+r[1]+",c"+r[2]));

```
更紧凑的做法 只计算一次sqrt
```java
IntStream.rangeClosed(1,100).boxed()
.flatMap(a-> IntStream.rangeClosed(a,100).mapToObj(
    b->new double[]{a,b,Math.sqrt(a*a+b*b)})
    .filter(t->t[2]%1==0));
```

拼接字符串
效率不高，每次迭代都要新建String对象
reduce可以设置初始值
```java
String reduce = tras.stream()
  .map(tra -> tra.getTrader().getName())
  .distinct().sorted()
  .reduce("", (n1, n2) -> n1 + n2);
```
使用joining，内部用到StringBuilder
```java
String reduce = tras.stream()
  .map(tra -> tra.getTrader().getName())
  .distinct().sorted()
  .collect(joining());
```
找最大值最小值.stream().min(comparing(Transaction::getValue));