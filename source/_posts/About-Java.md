---
title: About Java
date: 2018-03-02 21:18:51
tags: [java,Thread,SpringBoot]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
### 用静态工厂方法替代构造器
```java
public static Boolean valueOf(boolean b){
    return b?Boolean.TRUE:Boolean.FALSE;
}
```
1.对于特定参数的构造函数返回的特定对象，能有*名字*.（而不是用不同参数类型顺序的构造器）
2.缓存调用重复对象。实例受控类。客户端就能用==不用equals。
3.API隐藏实现类。Collections的集合接口有32个便利实现，不可修改、同步集合等。这些对象的类都是私有类。`EnumSet` 没有公有构造器，只有静态工厂方法，根据元素大小返回两种类。
```java
public static <E extends Enum<E>> EnumSet<E> noneOf(Class<E> elementType) {
    Enum<?>[] universe = getUniverse(elementType);
    if (universe == null)
        throw new ClassCastException(elementType + " not an enum");

    if (universe.length <= 64)
        return new RegularEnumSet<>(elementType, universe);
    else
        return new JumboEnumSet<>(elementType, universe);
}
```

服务提供者框架：
http://www.importnew.com/27291.html
JDBC：
服务Service接口：Connection 提供者实现的
```java
public interface Connection  extends Wrapper, AutoCloseable {
    Statement createStatement() throws SQLException;
    PreparedStatement prepareStatement(String sql)
        throws SQLException;
    void commit() throws SQLException;
    void setAutoCommit(boolean autoCommit) throws SQLException;
}
```


提供者Provider注册API方法 DriverManager.registerDriver

服务访问API方法：DriverManger.get Connection

可选：服务提供者接口:Driver

静态广场方法的管用名：`valeOf`,`of`,`getInstance`, `newInstance`,`getType`,`newTye`


### 多个构造器参数
重叠构造器：重新1、2、3参数的构造方法，不可行。
```java
public class NurtitionFacts{
    private final int servingSize; // require
    private final int fat;        //  optional
    private final int sodium;     //  optional
}
```

JavaBeans模式：无参构造器创建对象，然后setter方法。缺点：线程不安全。构造过程分成了几个调用，构造过程中JavaBeans可能不一致，而且不能做成变成不可变对象。
```java
private final int ser = -1;
// 不行
public void setSer(int ser){
    this.ser = 1;
}
```
Builder模式：



### 0.1奇偶性
用==1 判断会有负数的问题，正确写法
```java
boolean isOdd(int i){
    i % 2 !=0;
    (i & 1) != 0
}
```

### 0.3长整除
```java
final long MICROS_PER_DAY = 24 * 60 * 60 *1000 *1000;
final long MICROS_PER_DAY3 = 24l * 60 * 60 *1000 *1000;
final long MICROS_PER_DAY2 = 86400000000l;
final long MILLIS_PER_DAY = 24*60*60*1000;
System.out.println(MICROS_PER_DAY/MILLIS_PER_DAY);//5
System.out.println(MICROS_PER_DAY3/MILLIS_PER_DAY);//1000
System.out.println(MICROS_PER_DAY2/MILLIS_PER_DAY);//1000
```

第一行报错：计算溢出。计算过程完全以int运算执行的，完成运算后才提升到long。

### 0.4 long字面量 一定要用大写L
```java
System.out.println(12345+5432l);//会看成1
```

### 0.5 十六进制int扩展成long的高位
```java
//cafebabe （第33位丢了）
System.out.println(Long.toHexString(0x100000000L+0xcafebabe));
```
左边是long 右边是32位int，十六进制32位int ，c的高位为1，负数，扩展为补1（F）
```java
//0xcafebabe被提升成0xffffffffcafebabe 等于十进制数‭-889275714‬
System.out.println(Long.toHexString(0xcafebabe));
    1111111 
  0xffffffffcafebabeL 
+ 0x0000000100000000L 
--------------------- 
  0x00000000cafebabeL 
```

改正
```java
System.out.println(Long.toHexString(0x100000000L+0xcafebabeL));
```

### 0.6 转型的零扩展和符号位扩展
```java
//65536
System.out.println((int)(char)(byte)-1);
```
1 转byte是只取低8位1111 1111 还是-1，
2 byte->（符号扩展）char是无符号16位 扩展成16个1
3 char扩展都是零扩展 就是16个1 65536
没有符号位扩展：
```java
int i = c & 0xffff; 
```
如果byte转char不希望符号位扩展
```java
char c = (char) (b & 0xff); 
```

### 0.7


### 创建泛型数组
从List分`ArrayList`和`LinkedList`根据结构，根据元素的类型又可以分`String/Int`的ArrayList，乘法组合数量太多。

`(E[]) new Object[n];`

E 到底是什么属于对象的一部分 不是类的一部分
`new Node<Integer>(value);`

### `toArray(new String[0])`
官方推荐写法
https://docs.oracle.com/javase/tutorial/collections/interfaces/collection.html
Otherwise, a new array is allocated with the runtime type of the specified array and the size of this list.
如果指定的数组能容纳该 collection，则返回包含此 collection 元素的数组。否则，将根据指定数组的运行时类型和此 collection 的大小分配一个新数组。这里给的参数的数组长度是0，因此就会返回包含此 collection 中所有元素的数组，并且返回数组的类型与指定数组的运行时类型相同。


### BinarySearch
`Arrays.binarySearch()` method returns index of the search key, if it is contained in the array, 
else it returns (-(insertion point) - 1).

### 多态
- Java中除了static方法和final方法（private方法本质上属于final方法，因为不能被子类访问）之外，其它所有的方法都是动态绑定
- 构造函数并不具有多态性，它们实际上是static方法，只不过该static声明是隐式的。因此，构造函数不能够被override。
- 在父类构造函数内部调用具有多态行为的函数将导致无法预测的结果，因为此时子类对象还没初始化，此时调用子类方法不会得到我们想要的结果。
```java
class Glyph {
    void draw() {
        System.out.println("Glyph.draw()");
    }
    Glyph() {
        System.out.println("Glyph() before draw()");
        draw();
        System.out.println("Glyph() after draw()");
    }
}

class RoundGlyph extends Glyph {
    private int radius = 1;
    RoundGlyph(int r) {
        radius = r;
        System.out.println("RoundGlyph.RoundGlyph(). radius = " + radius);
    }
    void draw() {
        System.out.println("RoundGlyph.draw(). radius = " + radius);
    }
}

public class PolyConstructors {
    public static void main(String[] args) {
        new RoundGlyph(5); }
}
```
输出：
{% note %}
Glyph() before draw()
RoundGlyph.draw(). radius = 0
Glyph() after draw()
RoundGlyph.RoundGlyph(). radius = 5
{% endnote %}


### 序列化字段
静态变量不管是否被transient修饰，均不能被序列化

Java中，对象的序列化可以通过实现两种接口来实现，若实现的是Serializable接口，则所有的序列化将会自动进行，若实现的是Externalizable接口，则没有任何东西可以自动序列化，需要在writeExternal方法中进行手工指定所要序列化的变量，这与是否被transient修饰无关。

Shape和Circle两个类的定义。在序列化一个Circle的对象circle到文件时，下面哪个字段会被保存到文件中？ (  )
```java
class Shape {
       public String name;
}

class Circle extends Shape implements Serializable{
       private float radius;
       transient int color;
       public static String type = "Circle";
}
```
{% note %}
A name
B radius
C color
D type
答案：B
{% endnote %}


### 抽象类
```java
public abstract class MyClass {

     public int constInt = 5;
     //add code here
     public void method() {
     }
}
```
{% note %}
A public abstract void method(int a);
B constInt = constInt + 5;
- 变量可以初始化或不初始化但不能初始化后在抽象类中重新赋值或操作该变量（只能在子类中改变该变量）。

C public int method();
- 普通方法一定要实现

D public abstract void anotherMethod() {} 
- 抽象类中的抽象方法（加了abstract关键字的方法）不能实现。

答案：A
{% endnote %}

接口中定义的变量默认是public static final 型，且必须给其初值，所以实现类中不能重新定义，也不能改变其值。抽象类中的变量默认是 friendly 型，其值可以在子类中重新定义，也可以在子类中重新赋值。

### 静态块构造块
```java
class HelloA {

    public HelloA() {
        System.out.println("HelloA");
    }
    
    { System.out.println("I'm A class"); }
    
    static { System.out.println("static A"); }

}

public class HelloB extends HelloA {
    public HelloB() {
        System.out.println("HelloB");
    }
    
    { System.out.println("I'm B class"); }
    
    static { System.out.println("static B"); }
    
    public static void main(String[] args) { 
　　　　 new HelloB(); 
　　 }

}
```

{% note %}
static A
static B
I'm A class
HelloA
I'm B class
HelloB
{% endnote %}

对象的初始化顺序：
（1）类加载之后，按从上到下（从父类到子类）执行被static修饰的语句；
（2）当static语句执行完之后,再执行main方法；
（3）如果有语句new了自身的对象，将从上到下执行构造代码块、构造器。

---

### IO用法
要从文件"file.dat"中读出第10个字节到变量c中,下列哪个方法适合? （）
A `FileInputStream in=new FileInputStream("file.dat"); in.skip(9); int c=in.read();`

B `FileInputStream in=new FileInputStream("file.dat"); in.skip(10); int c=in.read();`

C `FileInputStream in=new FileInputStream("file.dat"); int c=in.read();`

D `RandomAccessFile in=new RandomAccessFile("file.dat"); in.skip(9); int c=in.readByte();`

D语法错 应该
```java
RandomAccessFile in = new RandomAccessFile("file.dat", "r");
in.skipBytes(9);
int c = in.readByte();
```
---

### case 没有break
```java
public static int getValue(int i) {
        int result = 0;
        switch (i) {
        case 1:
            result = result + i;
        case 2:
            result = result + i * 2;
        case 3:
            result = result + i * 3;
        }
        return result;
    }
```
A0                    B2                    C4                     D10

答案：D

解析：注意这里case后面没有加break，所以从case 2开始一直往下运行。

---

### 初始化
```java
import java.io.*;
import java.util.*;

public class foo{
    public static void main (String[] args){
        String s;
        System.out.println("s=" + s);
    }
}
```
A 代码得到编译，并输出“s=”
B 代码得到编译，并输出“s=null”
C 由于String s没有初始化，代码不能编译通过
D 代码得到编译，但捕获到 NullPointException异常
答案：C
解析：Java中所有定义的基本类型或对象都必须初始化才能输出值。

---

### 引用和值传递
```java
public class Example {

    String str = new String("good");

    char[] ch = { 'a', 'b', 'c' };

    public static void main(String args[]) {

        Example ex = new Example();

        ex.change(ex.str, ex.ch);

        System.out.print(ex.str + " and ");

        System.out.print(ex.ch);

    }

    public void change(String str, char ch[]) {

        str = "test ok";

        ch[0] = 'g';

    }
}
```
A、 good and abc

B、 good and gbc

C、 test ok and abc

D、 test ok and gbc 
答案：B

---

### 创建对象
15. 不通过构造函数也能创建对象吗（）

A 是     B 否

答案：A

解析：Java创建对象的几种方式（重要）：

(1) 用new语句创建对象，这是最常见的创建对象的方法。
(2) 运用反射手段,调用java.lang.Class或者java.lang.reflect.Constructor类的newInstance()实例方法。
(3) 调用对象的clone()方法。
(4) 运用反序列化手段，调用java.io.ObjectInputStream对象的 readObject()方法。

(1)和(2)都会明确的显式的调用构造函数 ；(3)是在内存上对已有对象的影印，所以不会调用构造函数 ；(4)是从文件中还原类的对象，也不会调用构造函数。

---


我们知道 Java 已经支持所谓的可变参数（varargs），但是官方类库还是提供了一系列特定参数长度的方法，看起来似乎非常不优雅，为什么呢？
这其实是为了最优的性能，JVM在处理变长参数的时候会有明显的额外开销，如果你需要实现性能敏感的 API，也可以进行参考。

### 反编译
`javap -v xx.class`

---

以下说法中正确的有
正确答案: A D   你的答案: A B D (错误)
A.StringBuilder是线程不安全的
B.HashMap中，使用 get(key)==null可以判断这个HashMap是否包含这个key(key存在，值是null)
C.Java类可以同时用abstract和final声明
D.volatile关键字不保证对变量操作的原子性

---

Java 中堆和栈有什么区别?
正确答案: A B   你的答案: A B D (错误)
A.堆是整个JVM共享的
B.栈是每个线程独有的
C.栈是整个JVM共享的
D.对象可以分配在堆上也可以分配在栈上

### PermGen Space
`-XX:PermSize`，表示程序启动时，JVM 方法区的初始化最小尺寸参数；
`-XX:MaxPermSize`，表示程序启动时，JVM 方法区的初始化最大尺寸参数。

Java 8中，永久代被彻底移除，取而代之的是另一块与堆不相连的本地内存——元空间（Metaspace）,‑XX:MaxPermSize 参数失去了意义，取而代之的是-XX:MaxMetaspaceSize。

方法区（method area）只是JVM规范中定义的一个概念，用于存储类信息、常量池、静态变量、JIT编译后的代码等数据，具体放在哪里，不同的实现可以放在不同的地方。而永久代是Hotspot虚拟机特有的概念，是方法区的一种实现，别的JVM都没有这个东西。



内存溢出错误。更具体的说，是指方法区（永久代）内存溢出！
java.lang.OutOfMemoryError: PermGen Space表示
正确答案: C   你的答案: A (错误)
Java heap内存已经用完
Java 堆外内存已经用完
Java 类对象(class)存储区域已经用完
Java 栈空间已经用完

### 强引用、软引用、弱引用、幻象引用

![references.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/references.jpg)

```java
public abstract class Reference<T> {
    /**
     * Returns this reference object's referent.  If this reference object has
     * been cleared, either by the program or by the garbage collector, then
     * this method returns <code>null</code>.
     *
     * @return   The object to which this reference refers, or
     *           <code>null</code> if this reference object has been cleared
     */
    public T get() {
        return this.referent;
    }
}
```
对于软引用、弱引用之类，垃圾收集器可能会存在二次确认的问题，以保证处于弱引用状
态的对象，没有改变为强引用。

如果我们错误的保持了强引用（比如，赋值给了 static 变量），那么对象可能就没有机
会变回类似弱引用的可达性状态了，就会产生内存泄漏。

幻象引用（因为 get 永远返回 null），如果对象还没有被销毁，都可以通过 get 方法获取
原有对象。这意味着，利用软引用和弱引用，我们可以将访问到的对象，重新指向强引用，也就
是人为的改变了对象的可达性状态

#### SoftReference
让对象豁免一些垃圾收集，只有当 JVM 认为内存不足时，才会去试图回收软引用指向的对象。
are cleared at the discretion（斟酌） of the garbage collector in response to memory demand.  
软引用通常用来实现内存敏感的缓存，如果还有空闲内存，就可以暂时保留缓存，当内存不足时清理掉，这样就保证了使用缓存的同时，不会耗尽内存。
Soft references are most often used to implement memory-sensitive caches.

#### WeakReference
下面关于Java中weak reference的说法，哪个是正确的?
正确答案: B   你的答案: B (正确)
Weak reference指向的对象不会被GC回收。
Weak reference指向的对象可以被GC回收。
Weak reference 指向的对象肯定会被GC回收
Weak reference 指向的对象如果被回收，那么weak reference会收到通知

维护一种非强制性的映射关系，如果试图获取时对象还在，就使用它，否则重现实例化。它同样是很多缓存实现的选择。
Weak references are most often used to implement canonicalizing mappings

#### 幻象引用
幻象引用，有时候也翻译成虚引用，你不能通过它访问对象。幻象引用仅仅是提供了一种确
保对象被 finalize 以后，做某些事情的机制

### 引用队列 ReferenceQueue
创建各种引用并关联到响应对象时，可以选择是否需要关联引用队列，JVM 会在特定时机将引用 enqueue 到队列里。
幻象引用，get 方法只返回 null，如果再不指定引用队列，基本就没有意义了。




### final、finally、 finalize

#### final
final 修饰的 class 代表不可以继承扩展.避免 API 使用者更改基础功能
final 的变量是不可以修改的.，利用final 可能有助于 JVM 将方法进行内联(现代高性能 JVM（如 HotSpot）判断内联未必依赖final 的提示)，可以改善编译器进行条件编译的能力.
final 的方法也是不可以重写的（override）

##### final 并不等同于 immutable
```java
 final List<String> strList = new ArrayList<>(); 
 strList.add("Hello"); 
 strList.add("world");   
 //List.of 方法创建的本身就是不可变 List，会抛运行异常
 List<String> unmodifiableStrList = List.of("hello", "world"); 
 unmodifiableStrList.add("again"); 
```

#### `finalize`
finalize 是基础类 java.lang.Object 的一个方法.保证对象在被垃圾收集前完成
特定资源的回收. JDK 9 开始被标记为deprecated.

无法保证 finalize 什么时候执行，执行的是否符合预期。使用不当会影响
性能，导致程序死锁、挂起等。


#### post-mortem
Java 平台目前在逐步使用 java.lang.ref.Cleaner 来替换掉原有的 finalize 实现。
Cleaner 的实现利用了幻象引用（Phantom Reference），这是一种常见的所谓 post-mortem 清理机制。

每个 Cleaner 的操作都是独立的，它有自己的运行线程，所以可以避免意外死锁等问题。

为自己的模块构建一个 Cleaner，然后实现相应的清理逻辑

#### 幻象引用定制资源收集
MySQL JDBC driver 之一的 ysql-connector-j，就利用了幻象引用机制。
幻象引用也可以进行类似链条式依赖关系的动作，比如，进行总量控制的场景，保证只有连接被关闭，相应资源被回收，连接池才能创建新的连接。

代码如果稍有不慎添加了对资源的强引用关系，就会导致循环引用关系，前面提到的
MySQL JDBC 就在特定模式下有这种问题，导致内存泄漏。

```java
public class CleaningExample implements AutoCloseable { 
    // A cleaner, preferably one shared within a library 
    private static final Cleaner cleaner = <cleaner>; 
    static class State implements Runnable {  
        State(...) { 
            // initialize State needed for cleaning action 
     } 
        public void run() { 
            // cleanup action accessing State, executed at most once 
        } 
    } 
    private final State; 
    private final Cleaner.Cleanable cleanable 
    public CleaningExample() { 
        this.state = new State(...); 
        this.cleanable = cleaner.register(this, state); 
    } 
    public void close() { 
        cleanable.clean(); 
    } 
}         
```

上面的示例代码中，将 State 定义
为 static，就是为了避免普通的内部类隐含着对外部对象的强引用，因为那样会使外部对象无法
进入幻象可达的状态。

#### finally不会被执行的特例
```java
try { 
  // do something 
  System.exit(1); 
} finally{ 
  System.out.println(“Print from finally”); 
} 
```

### `Exception` `Error` 运行时异常 
![Exceptions.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/Exceptions.jpg)

尽量不要捕获类似 `Exception` 这样的通用异常,`Thread.sleep()` 应该抛出` InterruptedException`

`Exception` 和 `Error` 都 继承`Throwable`

#### Throwable 
Throwable类型的实例才可以被抛出（throw）或者捕获（catch），它是异常处理机制的基本组成类型。
Only objects that are instances of this（`Throwable`) class (or one of its subclasses) are thrown by the **Java Virtual Machine
** or can be thrown by the Java throw statement.

only this class or one of its subclasses can be the argument type in a **catch** clause. 

#### 已检查的异常
Throwable and any subclass of Throwable that is not also a subclass of either RuntimeException or Error are regarded as **checked exceptions**.
checked exceptions 可检查异常应该捕获
不检查异常（运行时异常）：` NullPointerException` `ArrayIndexOutOfBoundsException`

Java 语言的 Checked Exception 也许是个设计错误:
1. Checked Exception 的假设是我们捕获了异常，然后恢复程序。但是，其实我们大多数情况
下，根本就不可能恢复。Checked Exception 的使用，已经大大偏离了最初的设计目的。
2. Checked Exception 不兼容 functional 编程，如果你写过 Lambda/Stream 代码，相信深
有体会。


#### 异常 Exception 和 Error
Java 每实例化一个 Exception，都会对当时的栈进行快照，这是一个相对比较重的操作
A throwable contains a snapshot of the execution stack of its thread at the time it was created.
```java
public class Throwable
/**
 * Native code saves some indication of the stack backtrace in this slot.
 */
private transient Object backtrace;
```
Error 不需要捕获`OutOfMemoryError`

#### chained exception facility wrapped exception
让下层抛出的抛出物向外传播是不好的设计，因为它通常与上层提供的抽象无关。

#### 反应式编程（Reactive Stream）
因为其本身是异步、基于事件机制的，所以出现异常情况，决不能简单抛出去；另外，由于代码
堆栈不再是同步调用那种垂直的结构，这里的异常处理和日志需要更加小心，我们看到的往往是
特定 executor 的堆栈，而不是业务方法调用关系。

---

### 生成闭区间`[0,1]`浮点数?

### Maven 目录隔离

### Lombok：通过注解精简代码
https://projectlombok.org/
Lombok会把javac编译的AST放到Lombok Processor交给不同的Handler处理，输出修改AST，javac继续解析生成字节码文件。
关键注解 of是白名单 exclude黑名单
`@Data(包括get/set/toString/EqualsAndHashCode) @Getter @Setter`

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class Category {
    private Integer id;

    private Integer parentId;

    private String name;

    private Boolean status;

    private Integer sortOrder;

    private Date createTime;

    private Date updateTime;

}
```

`@NoArgsConstructor`无参构造器
`@AllArgsConstructor`无参构造器
`@ToString(exclude = "column")`
`@EqualsAndHashCode(exclude = "column")`
`@Sl4j @Log4j`

### java 反编译
http://jd.benow.ca/

RESTful API 设计参考文献列表
https://github.com/aisuhua/restful-api-design-references

### ajax复杂对象传递给spring boot
ajax里必须要`contentType:"application/json;charset=utf-8"`因为默认是`application/x-www-form-urlencoded`

### Gson类中有泛型类的反射原理

### JavaEE规范

### 设计模式

#### 里氏替换 长方形和正方形
当把父类替换成子类，程序运行的和期望不一样。
如果正方形继承长方形，当对长方形的resize方法里有一个判断长宽是否相等的条件，正方形会死循环。
正确方法：长方形正方形都实现这个接口。注意没有set方法，所以长方形和正方形的resize是不通用的。写resize方法只能传入长方形类。防止继承泛滥。
```java
public interface Quadrangle{
    long getWidth();
    long getLength();
}
```

子类重载父类方法，入参要比父类的入参更宽松！
```java
public class Child extends Base{
    // 重写
    @Override
    public void method(HashMap map){
        super.method(map);
    }
    // 重载 比父类的入参更宽松 
    // 当使用Child.method(hashmap);的时候不会被调用
    public void method(Map map){

    }
}
```

后置条件：子类实现父类的抽象方法返回值要比父类更严格



#### 组合/聚合复用原则 db的Connect类
```java
public abstract class DBConnection{
    public abstract String getConnection();
}
```
```java
public class MysqlConnection extends DBConnection{
    @Override
    public String getConnection(){
        return "mysql数据库连接";
    }
}
```
```java
public class Dao{
    // 可以通过set/构造方法注入
    private DBConnection dbConnection;
    public void addProduct(){
        String conn = dbConnection.getConnection();
    }
}
```




### 数据库设计原则
1 实体聚合原则
2 不用外键
3 减少中间表设计





Objcet 的源码

### Maven 报错No plugin found for prefix 'tomcat7
找到Maven的setting：
```xml
<pluginGroups>
  <pluginGroup>org.apache.tomcat.maven</pluginGroup>
</pluginGroups>
```

### HTTP服务的性能测试图表

### snowflake

### 获取当前目录 System.getProperty()参数大全
`System.out.println(System.getProperty("user.dir"));`

### StringUtils源码学习

### forEach 反编译是迭代器

### modCount在线程不安全的迭代器里会抛异常

### `UnsupportedOperationException`
>从Arrays.asList()转化过来的List的不支持add()和remove()方法，这是由于从Arrays.asList()返回的是返回java.util.Arrays$ArrayList，而不是ArrayList。Arrays$ArrayList和ArrayList都是继承AbstractList，add() 和remove()等方法在AbstractList中默认throw UnsupportedOperationException而不做任何操作。ArrayList重写这些方法对List进行操作，而Arrays$ArrayList却没有重写add()和 remove()等方法，所以对从Arrays.asList()转化过来的List进行add()和remove()会出现UnsupportedOperationException异常。

Arrays.asList返回的是Arrays的内部类java.util.Arrays.ArrayList 该类继承了AbstractList但是并没有实现所有的方法，和java.util.ArrayList还是有区别的。 AbstractList的add方法：

`res.add(new ArrayList<>(Arrays.asList(num[i],num[lo],num[hi])));`

### 求`int[]`最大值的正确写法
`int maxa = Arrays.stream(arr).max().getAsInt();`

### List remove的index不能是Integer
```java
public boolean remove(Object o) {
    if (o == null) {
        for (int index = 0; index < size; index++)
            if (elementData[index] == null) {
                fastRemove(index);
                return true;
            }
    } else {
        for (int index = 0; index < size; index++)
            if (o.equals(elementData[index])) {
                fastRemove(index);
                return true;
            }
    }
    return false;
}
```

### String的字典序比较
{% fold %}
```java
/**
 * Compares two strings lexicographically.

 * The comparison is based on the Unicode value of each character in
 * the strings. 

  The result is * a negative integer if this {@code String} object
 * lexicographically precedes the argument string.
 */
public int compareTo(String anotherString) {
    int len1 = value.length;
    int len2 = anotherString.value.length;
    int lim = Math.min(len1, len2);
    char v1[] = value;
    char v2[] = anotherString.value;

    int k = 0;
    while (k < lim) {
        char c1 = v1[k];
        char c2 = v2[k];
        if (c1 != c2) {
            return c1 - c2;
        }
        k++;
    }
    return len1 - len2;
}
```
{% endfold %}

### replace和replaceAll都是全部替换
```java
public String replaceAll(String regex, String replacement) {
    return Pattern.compile(regex).matcher(this).replaceAll(replacement);
}

/**
 * Replaces each substring of this string that matches the literal target
 * sequence with the specified literal replacement sequence. The
 * replacement proceeds from the beginning of the string to the end, for
 * example, replacing "aa" with "b" in the string "aaa" will result in
 * "ba" rather than "ab".
 *
 * @param  target The sequence of char values to be replaced
 * @param  replacement The replacement sequence of char values
 * @return  The resulting string
 * @since 1.5
 */
public String replace(CharSequence target, CharSequence replacement) {
    return Pattern.compile(target.toString(), Pattern.LITERAL).matcher(
            this).replaceAll(Matcher.quoteReplacement(replacement.toString()));
}
```

### hashset的实现
`static final` 静态类对象 所有实例共享

```java
private transient HashMap<E,Object> map;

// Dummy value to associate with an Object in the backing Map
private static final Object PRESENT = new Object();
public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
public boolean remove(Object o) {
    return map.remove(o)==PRESENT;
}
public Iterator<E> iterator() {
    return map.keySet().iterator();
}
```

### 二进制
`System.out.println(0b101);`//二进制:5  （0b开头的）
`System.out.println(011);` //八进制9

### `List<String>` 2 `String[]`
> [Ljava.lang.Object; cannot be cast to [Ljava.lang.String;

`rst.toArray(new String[rst.size()]);`

http://wiki.jikexueyuan.com/project/java-enhancement/java-thirtysix.html
### 二维数组clone
```java
this.mat = new int[matrix.length][];
    for (int i = 0; i < matrix.length; i++) {
        this.mat[i] = matrix[i].clone();
    }
```

### ThreadLocal

### Timer





### 打印整数的二进制表示
0x8000000 表示100000...0

```java
int a = -6;
for(int i =0;i<32;i++){
    //取第一位，右移
    int t = (a&0x8000000>>>i)>>>(31-i);
    out(t);
}
```

### System.exit
结束一个jvm。 状态0是正常退出
```java
//非零是异常
by convention, a nonzero status code indicates abnormal termination.
public static void exit(int status)
```

### forEach： ConcurrentModificationException
报错代码：
```java
for(List<Integer> list :subsets) {
    List<Integer> before = new ArrayList<>(list);
    before.add(i);
    //subsets的大小在不断增加！终止不了
    subsets.add(before);
}
```
at java.util.ArrayList$Itr.checkForComodification(ArrayList.java:901)
```java
final void checkForComodification() {
    if (modCount != expectedModCount)
        throw new ConcurrentModificationException();
}
```
> Iterator 是工作在一个独立的线程中，并且拥有一个 mutex 锁。 Iterator 被创建之后会建立一个指向原来对象的单链索引表，当原来的对象数量发生变化时，这个索引表的内容不会同步改变，所以当索引指针往后移动的时候就找不到要迭代的对象，所以按照 fail-fast 原则 Iterator 会马上抛出 java.util.ConcurrentModificationException 异常。
所以 Iterator 在工作的时候是不允许被迭代的对象被改变的。

>在使用迭代器遍历的时候，如果使用ArrayList中的remove(int index) remove(Object o) remove(int fromIndex ,int toIndex) add等方法的时候都会修改modCount，在迭代的时候需要保持单线程的唯一操作，如果期间进行了插入或者删除，就会被迭代器检查获知，从而出现运行时异常



### 被动加载和主动加载
final static List<Dish> menu = Arrays.asList{} 
import static A.menu;
A类不会被初始化 不会占用任何内存
去掉final变成主动加载


### 位运算取模只要5个CPU周期 %至少26个CPU周期

### Character
1. 内部静态类做cache

```java
private static class CharacterCache {
    private CharacterCache(){}
    static final Character cache[] = new Character[127 + 1];
    static {
        for (int i = 0; i < cache.length; i++)
            cache[i] = new Character((char)i);
    }
}
public static Character valueOf(char c) {
    if (c <= 127) { // must cache
        return CharacterCache.cache[(int)c];
    }
    return new Character(c);
}
```

2.
```java
int digit(char ch, int radix) {
 return digit((int)ch, radix);
}
```
当radix基数大于传入的数字，返回-1，只能传入小于radix的数字


`@FunctionalInterface`适合用lambda表达式

### JIN
```java
System.loadLibrary("NativeMath");
//中的sqrt c++实现
#include<math.h>
JNIEXPORT jdouble JNICALL Java_包名_sqrt(JNIEnv *env,jobject obj,jdouble value){
    return sqrt(value);
}
```

### 回调(控制反转)与代理
回调:
{% fold %}
```java
interface  ICallBack{
    public void callBack();

}
class Caller{
    public void call(ICallBack callBack){
        System.out.println("start");
        callBack.callBack();
        System.out.println("end");
    }
}

public class callbackk {
    public static void main(String[] args) {
        Caller call = new Caller();
        call.call(new ICallBack() {
            @Override
            public void callBack() {
                System.out.println("这个叫回调");
            }
        });

    }
    }
```
{% endfold %}

线程Thread是回调者，Runnable回调接口
```java
new Thread(new Runnable(){
    @Override
    public void run(){
    }
}).start();
```

观察者模式/回调函数


### 事件处理机制

### RPC基于TCP/IP的会话层协议

set的contain时间复杂度是O(1),list的contain时间复杂度是O(n)
chrome的source根据域名不同存放资源 可以打断点调试

丢失精度一定要用`BigDecimal`的string构造器
`devide(b,2,BigDecimal.Round_HALF_UP)`保留两位小数四舍五入
guaga:String->list
`Splitter.on(",").splitToList("a,b,c");`

### simditor

[1.8中文API](https://blog.fondme.cn/apidoc/jdk-1.8-google/)

- 全文搜索引擎[Lucene](https://www.chedong.com/tech/lucene.html)

![access.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/access.jpg)

### Charactor.isLetterOrDigit()

### MD5增加复杂度salt

### UUID
重置密码之前：验证完密码问题则写入token
```java
String Token = UUID.randomUUID().toString();
//放入本地缓存 防止空，放个前缀`token_`
TokenCache.setKey("token_"+username,forgetToken);
```
生成的是一个永远不会重复的字符串
把token放到本地cache中设置有效期

#### Guava中的本地缓存`LoadingCache`
调用链模式没有顺序
```java
//TokenCache::
private static LoadingCache<String,String> localCache =
 CacheBuilder.newBuilder()
 .initialCapacity(1000)//缓存的初始化容量1000
 .maximumSize(10000)//缓存的最大容量，超过则会使用LRU（最少使用）算法移除
 .expireAfterAccess(12,TimeUnit.HOURS)//有效期12个小时
 .build(new CacheLoader<String,String>(){
    //默认数据加载，调用get时，key没有命中，则调用这个
    @Override
    public String load(String s) throws Exception{
        //防空指针
        return "null";
    }
 });
public static void setKey(String key,String value){
    localCache.put(key,value);
}
public static String getKey(String key){
    String value = null;
    try{
    value = localCache.get(key);
    if("null".equals(value))return null;
     return value;
    }catch (...){}
    return null;
}
```

### joda.time
字符串->Date()
```java
DateTimeFormatter df = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
DateTime dt = df.parseDateTime("2015-04-20 2:2:2");
return dt.toDate();
```


### `CollectionUtils.isEmpty(List)`

### 枚举：限制取值 封装响应编码ResponseCode
扩展的时候加枚举对象
```java
public enum ResponseCode {
    SUCCESS(0,"SUCCESS"),
    ERROR(1,"ERROR"),
    NEED_LOGIN(10,"NEED_LOGIN"),
    ILLEGAL_ARGUMENT(2,"ILLEGAL_ARGUMENT");
    private final int code;
    private final String desc;
    ResponseCode(int code,String desc){
        this.code = code;
        this.desc = desc;
    }
    public int getCode(){
        return code;
    }
    public String getDesc(){
        return desc;
    }
}
```
用法 在response对象里：
```java
@JsonIgnore
public boolean isSuccess(){
    //0
    return this.status== ResponseCode.SUCCESS.getCode();
}
```

```c
enum color{
    //枚举的3个实例化对象 外部不允许定义新的color对象
    green,red,yellow
}
color coenum;
coenum = color.red;
color[] values = color.values();
```

#### EnumSet<color>
```java
EnumSet<color> set = EnumSet.allOf(color.class);
```

#### EnumMap<color,String>
```java
EnumMap<color,String> map = new EnumMap<color, String>(color.class);
map.put(color.red,"red");
```

#### 构造方法（私有）
```java
enum Color{
    red(10),green(20),yellow;
    private int color;
    private Color(){
        System.out.println("无参构造器");
    }
    private Color(int color){
        this.color = color;
        System.out.println("有参构造器"+color);
    }
}
```
当用`Color.red`时，会调用3次构造器创建red,green,yellow三个对象

### 实现接口添加方法
```java
public int getColor(){
    return color;
}
//输出0 Color.red.getColor输出10
Color.yellow.getColor();
```
也可以单独定义方法

### 添加抽象方法，每个对象要都实现

`.getBytes('iso8859-1')`以iso编码读
`new String(,"gb2312")`
静态代码块：用staitc声明，jvm加载类时执行，仅执行一次

`printf("%n")`总是输出正确的平台特定行分隔符，所以它是跨平台的



### 内部类
1. 方法内部类只能在方法内实例化，并且不能使用方法内的非final变量
方法结束局部变量弹栈，但内部类对象可能需要对象回收 比方法生命周期长。
用final在类加载会放入常量池，
jdk1.8开始不需要final 编译器自动final，所以不能改变
2. 静态内部类 能使用外部类的静态成员和方法 不用new外部类也能访问
3. 使用内部类可以使用多继承
4. 优先选择静态内部类(防止内存泄漏)

原因：因为java里传参是传值
![finalnoname.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/finalnoname.jpg)
在里面引用外面的参数，外面的参数不应该被修改。不然里面变量和外面变量就会有二义性。
如果是传引用
![refnoname.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/refnoname.jpg)
两个会同时修改不会有二义性

### 适配器
安卓开发中常用，用A接口的子类转换B接口的子类

### 代理模式与AOP
与模板方法不同：代理是控制对象 模板是延迟到子类定义操作，定义骨架

### 工厂方法模式：
定义一个 **创建对象的接口**
让类的实例化推迟到实现这个接口的子类中进行。
依赖注入

### 策略模式和依赖倒置原则（面向接口编程）

### 模板方法（设计模式） 权限管理 算法骨架
不改变算法的结构，重新定义算法的特定步骤
{% fold %}
```java
package javacoretest;
abstract class BaseManager{
    public void action(String username,String method){
        if("admin".equals(username)){
            execute(method);
        }
        else{
            System.out.println("没有权限");
        }
    }
    public abstract void execute(String Method);
}
//延迟到子类实现ClassManager...子类有不同的实现
class UserManager extends BaseManager{
    @Override
    public void execute(String method){
        if("add".equals(method)) System.out.println("添加");
        else if("del".equals(method)) System.out.println("删除");
    }
}
public class Templete {
    public static void main(String[] args) {
        UserManager um = new UserManager();
        um.action("admin","add");
    }
}
```
{% endfold %}



### MD5密码处理
{% fold %}
```java
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class MD5demo {
    //数据库 所以密码只能重置不能查看
    private static String savePassWord ="pmq7VoTEWWLYh1ZPCDRujQ==";
    public static void main(String[] args) {
        System.out.println(login("admin123456"));
    }
    private static boolean login(String password){
        if(savePassWord.equals(md5(password))){
            return true;
        }else {
            return false;
        }
    }
    private static String md5(String password){
        try {
            MessageDigest md = MessageDigest.getInstance("md5");
            byte[] bytes = md.digest(password.getBytes("UTF-8"));
            String str = Base64.getEncoder().encodeToString(bytes);
            return str;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }
}
```
{% endfold %}

### 位运算应用
1. 判断奇偶：`a&1 = 0` 偶数 `a&1 = 1` 奇数
2. 取模`a & (2^n - 1)`
```java
System.out.println(999999&7);
System.out.println(999999%8);//相等
```
3. `&00001111`是取get后4位
4. `|00001111`是set后4位为1
5. `^00001111`是翻转后4位

### java8时间
LocalDate LocalTime LocalDateTime

### 国际化
`ResourceBundle`



`simpledateformat`???

[抗锯齿](https://blog.csdn.net/u013467442/article/details/40628121)


### 异常
e.getMassage()
printStackTrace();调用堆栈

### char 和 byte
- c++的char 8位，1字节。无byte。`typedef unsigned char byte;`
- java byte

- 静态方法没有this引用
- 包：保证类名的唯一性
- 工厂方法：返回一个类的新实例的静态方法

### 数组
用Arraylist 因为内部管理数组，自动创建内部数组转移元素 扩容。
- 泛型类，自动装箱、自动拆箱
- new ArrayList<>(Arrays.asList()) //[]->ArrayList `asList`固定长度 不支持add

### 输入输出
1. int.next() 读取空格分割的单词
2. ？？？？？读取密码用Console
> `javaw` runs Java code without association with current terminal/console (which is useful for GUI applications),there is no associated console window System.console() returns null.空指针异常
3. 格式化字符串 System.out.printf("%8.2f",1000.0/3.0);

- (Integer).intValue()
- Object.clone()
`protected native Object clone() throws CloneNotSupportedException;`浅拷贝，子类只能调用被保护的clone自己
- `Cloneable`接口是空的。
> 实现了Cloneable只是标识 惯例重写Object.clone() 定义成public
```java
public A clone() throws CloneNotSupportedException
```
在没有实现Cloneable接口的实例上调用Object的clone方法会导致引发异常CloneNotSupportedException。
- 标记接口（tagging interface): 空的。使用目的：可以用instanceof Cloneable检查
- ??enum toString的逆方法是valueOf
- super不是对象的引用。不能赋值给对象变量，是只是编译器调用超类方法的关键字
- sout(char[]) √
> char数组的打印有点特殊，int数组打印是打印出来一个地址，而char数组是打印数组里的内容。

> 如果重写了equals方法，请一并重写hashCode方法
- 重写类的equals方法->支持List
- 重写+hashCode方法->支持Set(HashMap,HashSet,LinkedHashMap,ConcurrentHashMap)
- (obj **instanceof** Person)

- 8种基本类型，其它都是对象（引用类型）-> 包装类型


| 整型 | byte short int long | 
| ------| ------ | ------ |
| 浮点 | float double |
| 字符型 | char |
| 逻辑型 |boolean|
- 方法体里声明的基本数据类型在栈内存里
- 基本数据类型来说，赋值（=号）就相当于拷贝了一份值
- 当执行到new这个关键字，会在堆内存分配内存空间，并把该内存空间的地址赋值给arr1

#### 注解 @interface
##### 元注解
- 注解只有一个成员，成员必须取名value（）
- 没有成员 标识注解
- @Target（{}）作用域
- @Retention（）生命周期
- @Inherited 允许继承

#### Thread
线程共享 `*代码`和`数据空间`
线程由独立的`运行栈`和`*程序计数器`

#### 线程的概念模型
- 虚拟cpu，在THREAD类中
- 将代码和数据传给thread类

#### 线程体
方法run()中的代码

#### 构造线程的方法
- 定义线程类，重写run方法，通过start启动
```java
publc class FactorialThreadTester{
    public static void main(String[] args){
        System.out.println("main thread starts");
        FactorialThread thread = new FactorialThread(10);
        thread.start();
        System.out.println("main thread ends");
        }
        }
```
- runable

>主方法main中创建一个新线程会等main执行完后再new
- 互斥锁 保证同一时刻有且只有一个线程在操作共享数据

#### 解决端口占用
```bash
 netstat -ano | findstr 80 //列出进程极其占用的端口，且包含 80  
 tasklist | findstr 2000 //端口号
 taskkill -PID <进程号> -F //强制关闭某个进程 
```

---

5. HashMap 在并发执行 put 操作时会引起死循环，导致 CPU 利用率接近100%。因为多线程会导致 HashMap 的 Node 链表形成环形数据结构，一旦形成环形数据结构，Node 的 next 节点永远不为空，就会在获取 Node 时产生死循环。

- ***忽略序列化***private **transient** String passwd;生命周期仅存于调用者的内存中而不会写到磁盘里持久化

> - final变量经常和static关键字一起使用，作为常量
> - final也可以声明方法。方法前面加上final关键字，代表这个方法不可以被子类的方法重写，只能被继承
> - final的类无法被继承
> - `public void setLength(final int size)`表示不能修改size的值 。对象则不能改变引用

类不能多继承，抽象类的方法可以不实现
接口可以多继承

- InterruptedException:

#### 如何使HashMap线程安全的
```java
 Map<,> ht = new Hashtable<>();
 Map<,> sy = new Collections.synchronizedMap(new HashMap<,>())
 Map<,> concurr = new ConcurrentHashMap<>();
```
 **CHM（ConcurrentHashMap)性能最佳***

 - Hashtable使用public `synchronized`阻塞，保证线程安全


- .mf 是bean的JAR清单



#### 迭代文件
```java
try(DirectoryStream<Path> entries = files.newDirectoryStream(dir)){
	for(Path entry : entries){
	}
}
```


#### Map的方法
put putAll

```java 
@Native public static final int   MAX_VALUE = 0x7fffffff;
```
0x7fffffff是补码表示的Integer的最小值(-2^31)和最大值(2^31-1),int是4字节。
- String内部是通过char数组表示，数组的长度在Java中限制为一个int型所能表示的最大值
- 最小值 Math.min(,)
- substring(,)前闭后开

> in-place 原地算法 删除重复元素 用!=略过并用unique的覆盖








