---
title: About Java
date: 2018-03-02 21:18:51
tags: [java,Thread,SpringBoot]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
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


### 对象头8字节
前4保存对象hash(3)，锁状态(1)
后4存储对象所属类的引用。

数组还有4字节保存数组大小。


### java内存
https://algs4.cs.princeton.edu/14analysis/
http://yueyemaitian.iteye.com/blog/2034305
https://blog.csdn.net/zhxdick/article/details/52003123

#### object
object overhead 16+int 4 padded到4的倍数(`-XX:-UseCompressedOops:`)
如果用压缩则`-XX:+UseCompressedOops: mark/4 + metedata/8 + 4 = 16 `
默认是启动压缩的
![javaobj.jpg](/images/javaobj.jpg)
> Objects. To determine the memory usage of an object, we add the amount of memory used by each instance variable to the overhead associated with each object, typically 16 bytes. Moreover, the memory usage is typically padded to be a multiple of 8 bytes (on a 64-bit machine).

#### padding
This can waste some memory but it speeds up memory access and garbage collection.

#### reference
// todo
引用类型是内存地址，8字节
2*ref(8)+enclosing(8)+16head = 40
非静态有encolsing instance？
指针的大小在bit模式下或64bit开启指针压缩下默认为4byte
 UseCompressOops开启和关闭，对对象头大小是有影响的，开启压缩，对象头是4+8=12byte；关闭压缩，对象头是8+8=16bytes。
`java -Xmx31g -XX:+PrintFlagsFinal |findstr Compress`
```
uintx CompressedClassSpaceSize     = 1073741824     {product}
bool UseCompressedClassPointers    := true          {lp64_product}
bool UseCompressedOops             := true          {lp64_product}
```
![javarefer.jpg](/images/javarefer.jpg)
> References. A reference to an object typically is a memory address and thus uses 8 bytes of memory (on a 64-bit machine).

#### arrays
![javaarr.jpg](/images/javaarr.jpg)
> Arrays. Arrays in Java are implemented as objects, typically with extra overhead for the length. An array of primitive-type values typically requires 24 bytes of header information (16 bytes of object overhead, 4 bytes for the length, and 4 bytes of padding) plus the memory needed to store the values.

基本类型 16的obj head+4(len)+4padding = 24 +存的类型\*长度

#### string
char[] ref(8)+int(4)+head(16)+padding->32+char[](arrayschar(24))=56+2N
![javastr.jpg](/images/javastr.jpg)


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

![access](/images/access.jpg)

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
![finalnoname.jpg](/images/finalnoname.jpg)
在里面引用外面的参数，外面的参数不应该被修改。不然里面变量和外面变量就会有二义性。
如果是传引用
![refnoname.jpg](/images/refnoname.jpg)
两个会同时修改不会有二义性

### 适配器
安卓开发中常用，用A接口的子类转换B接口的子类

### 代理模式与AOP
与模板方法不同：代理是控制对象 模板是延迟到子类定义操作，定义骨架

### 工厂模式 依赖注入

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








