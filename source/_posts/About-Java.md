---
title: About Java
date: 2018-03-02 21:18:51
tags: [java,Thread,SpringBoot]
category: java
---


String+" "原来的string还是在的 要等垃圾回收
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

2.```java
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

### StringUtils
`.isBlank(" ")`true

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

### 四大核心函数式接口
1. `Consumer` 消费者 接收一个值消费掉`list.forEach` 接收T返回void
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
private static void predicate(){}
private static List<String> filter(List<String>list,Predicate<String> prd){
    List<String> res=new ArrayList<>();
    for(String s:list){
        if(prd.test(s))res.add(s);
    }
    return res;
}
List<String> sig = filter(words,(d)->d.contains("L"));
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

### 内部类
1. 方法内部类只能在方法内实例化，并且不能使用方法内的非final变量
方法结束局部变量弹栈，但内部类对象可能需要对象回收 比方法生命周期长。
用final在类加载会放入常量池，
jdk1.8开始不需要final 编译器自动final，所以不能改变
2. 静态内部类 能使用外部类的静态成员和方法 不用new外部类也能访问
3. 使用内部类可以使用多继承
4. 优先选择静态内部类(防止内存泄漏)

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

String像数组一样取值 .charAt(i)
- 
```java 
@Native public static final int   MAX_VALUE = 0x7fffffff;
```
0x7fffffff是补码表示的Integer的最小值(-2^31)和最大值(2^31-1),int是4字节。
- String内部是通过char数组表示，数组的长度在Java中限制为一个int型所能表示的最大值
- 最小值 Math.min(,)
- substring(,)前闭后开

> in-place 原地算法 删除重复元素 用!=略过并用unique的覆盖

- 最长公共前缀：indexOf
> if else语句中，是不能直接用break和continue的???

```java
//[2]不一样
 if (source[i] != first) {
 	//[3]也不一样，
                while (++i <= max && source[i] != first);
            } 	
     //直到下一个匹配的继续for中内容
```
```java
/*
@param source:左值（被查找）
@param count长度
*/
 static int indexOf(char[] source, int sourceOffset, int sourceCount,
            char[] target, int targetOffset, int targetCount,
            int fromIndex) {
        // 查找位置>=左值长度
        if (fromIndex >= sourceCount) {
        	//traget空？返回左值长度
            return (targetCount == 0 ? sourceCount : -1);
        }
        if (fromIndex < 0) {
            fromIndex = 0;
        }
        // 右值为0，返回查找位置
        if (targetCount == 0) {
            return fromIndex;
        }

        char first = target[targetOffset];
        //最后一个匹配的下标，至少减去右值的长度
        int max = sourceOffset + (sourceCount - targetCount);

        for (int i = sourceOffset + fromIndex; i <= max; i++) {
            /* Look for first character. */
            if (source[i] != first) {
            	// 跳过这次循环？
                while (++i <= max && source[i] != first);
            }

            /* Found first character, now look at the rest of v2 */
            if (i <= max) {
                int j = i + 1;
                int end = j + targetCount - 1;
                for (int k = targetOffset + 1; j < end && source[j]
                        == target[k]; j++, k++);

                if (j == end) {
                    /* Found whole string. */
                    return i - sourceOffset;
                }
            }
        }
        return -1;
    }
```






