---
title: webflux
date: 2018-08-30 16:41:13
tags:
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
## 函数式编程 lambda+Stream
### 外部迭代 内部迭代
外部：for循环
内部迭代
求和
```java
int sum = IntStream.of(nums).sum();
```

惰性求值

求int数组最小值
```java
IntStream.of(new int[]{1,2,3,4,5}).min().getAsInt();
```
改成并行：新建线程池，拆分数组，归并
```java
IntStream.of(test).parallel().min().getAsInt();
```
{% fold %}
```java
Random random = new Random(1024);
int[] test = new int[1<<10];
for (int i = 0; i <test.length ; i++) {
    test[i] = random.nextInt(1<<10);
}
long start1 = System.currentTimeMillis();
IntStream.of(test).min().getAsInt();
long end1 = System.currentTimeMillis();
//44
System.out.println(end1-start1);
long start = System.currentTimeMillis();
IntStream.of(test).parallel().min().getAsInt();
long end = System.currentTimeMillis();
//3
System.out.println(end-start);
```
{% endfold %}

lambda：
```java
Object ok = new Runnable() {
    @Override
    public void run() {
        System.out.println("ok");
    }
};
new Thread((Runnable)ok).start();

new Thread(()->System.out.println("ok")).start();
Object target3 = (Runnable)()->System.out.println("ok");
new Thread((Runnable)target3);
```
4种写法
```java
@FunctionalInterface
interface interface1{
    int doubleNum(int i);
}
interface1 i1 = (i)->i*2;
interface1 i2 = i->i*2;

interface1 i3 = (int i)->i*2;
interface1 i4 = (int i)->{return i*2;};
```


```java
//输入int返回String
interface IMoneyFormat{
    String format(int i);
}
class MyMoney{
    private final int money;
    public MyMoney(int money){
        this.money = money;
    }
    public void printMoney(IMoneyFormat moneyFormat){
        System.out.println("存款："+moneyFormat.format(this.money));
    }
}
MyMoney me = new MyMoney(99999);
//存款：99,999
me.printMoney(i->new DecimalFormat("#,###").format(i));
```
使用JDK8带的函数接口`Function`
```java
public void printMoneyJDK8(Function<Integer,String> moneyFormat){
    System.out.println("存款："+moneyFormat.apply(this.money));
}
 me.printMoneyJDK8(i->new DecimalFormat("#,###").format(i));
```

好处：链式操作
```java
Function<Integer,String> moneyFormat = i->new DecimalFormat("#,###").format(i);
//存款：RMB99,999
me.printMoneyJDK8(moneyFormat.andThen(s->"RMB"+s));
```

### 级联表达式和科里化//todo

### 类型推断2-13 //todo

### ::方法引用
1. 用::将方法名称与类/对象分隔开
1.类::实例方法 
```java
BiFunction<Dog,Integer,Integer> eatFunc = Dog::eat;
System.out.println("还有"+eatFunc.apply(new Dog(),2 ));
```
2.类::静态方法 `Integer::valueOf`
```java
class Dog{
    //消费者：输入Dog，输出void
    public static void Bark(Dog dog){
        System.out.println("bark");
    }
}
Consumer<Dog> consumer = Dog::Bark;
consumer.accept(new Dog());
```
3. 对象::实例方法 `list::add`
静态方法和成员方法的区别：静态方法没有this
**JDK默认会将当前实例传给非静态方法，叫this，位置必须第一个。**
java里都是传值而不是引用 所以不会空指针
```java
IntUnaryOperator eat = dog::eat;
dog=null;
System.out.println("还剩下"+eat.applyAsInt(3));
```
```java
class Dog{
    private int food = 10;
    //函数：输入int，输出int
    public int eat(Dog this,int num){
        System.out.println("eat:"+num+"kg");
        this.food-=num;
        return this.food;
    }
}
IntUnaryOperator eat = dog::eat;
System.out.println("还剩下"+eat.applyAsInt(3));
```
4. 类::构造方法 `ArrayList::new`
提供者：输入空，输出是实例
```java
Supplier<Dog> supplier = Dog::new;
```
方法：带参构造函数，输入是int,输出是实例
```java
Function<Integer,Dog> dog2 = Dog::new;
```

### 四大核心函数式接口
{% qnimg lambdainterface.jpg %}
1. `Consumer` 消费者 接收一个值消费掉`list.forEach` 接收T返回void
```java
Consumer<String> consumer = s-> System.out.println(s);
consumer.accept("等待输出");
```
2. `Function<T,R>` 接收一个参数返回一个结果
```java
public static String str(String str,Function<String,String> f){
    return f.apply(str);
}
String s = str("functionnnntest",(str)-> str.toUpperCase());
```
    `BiFunction<T, U, R>` `R apply(T t, U u);`
3. `Supplier`::`T get();`不传参数返回结果
```java
public static List<Integer> getNumber(int num,Supplier<Integer> sup){
    List<Integer> list = new ArrayList<>();
    for(int i =0;i<num;i++){
        list.add(sup.get());}
    return list;}
List<Integer> list = getNumber(10,()->(int)(Math.random()*100));
```
4. `Predicate`::`boolean test(T t);`断言
```java
Predicate<Integer> predicate = i->i>0;
//true
System.out.println(predicate.test(9));  
```

过滤器保留有L的单词
```java
private static void predicate(){}
private static List<String> filter(List<String>list,Predicate<String> prd){
    List<String> res=new ArrayList<>();
    for(String s:list){
        if(prd.test(s))res.add(s);
    }
    return res;
}
List<String> words = Arrays.asList("LL","LB","EE");
//[LL, LB]
List<String> sig = filter(words,(d)->d.contains("L"));
```

有一些自带的类型接口，不用写泛型,优先使用
```java
IntPredicate predicateint = i->i>0;
IntConsumer intConsumer = System.out::println;;
```

### Lambda：函数作为方法的参数
当接口只有一个抽象方法，函数式接口，不会生成class
1. 内部类写法
```java
interface Ido{ public void doo(String thing);}
class IdoImp implements Ido{
    public void doo(String thing){
        System.out.println(thing+"adfadfa");}}
//main
IdoImp idoimp = new IdoImp();
idoimp.doo("thing");
```
2. Lambda写法
```java
interface Ido{ public void doo(String thing);}
Ido ido = (thing)-> System.out.println(thing+"doooooo");
```
3. 比较对象
`Comparator<Integer> c = (x,y)->Integer.compare(x,y);`

4. 方法引用
```java
Arrays.sort(strings,String::compareToIgnoreCase);
Arrays.sort(strings,(x,y)->x.compareToIgnoreCase(y));
System.out.println(Arrays.toString(strings));
```
- ArrayList 打印全部元素
`list.forEach(x->sout(x))`
`list.forEach(System.out::println)`
