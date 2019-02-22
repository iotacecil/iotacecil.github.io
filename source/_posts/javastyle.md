---
title: java风格练习
date: 2018-03-07 14:18:24
tags: [java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
### BigInteger
`numberOfTrailingZeros` 二进制末尾0的个数 用时27
比`>>=2`，`while(i&1==0)`快很多 用时172
```java
public static int numberOfTrailingZeros(int i) {
    // HD, Figure 5-14
    int y;
    if (i == 0) return 32;
    int n = 31;
    y = i <<16; if (y != 0) { n = n -16; i = y; }
    y = i << 8; if (y != 0) { n = n - 8; i = y; }
    y = i << 4; if (y != 0) { n = n - 4; i = y; }
    y = i << 2; if (y != 0) { n = n - 2; i = y; }
    return n - ((i << 1) >>> 31);
}
```


### LinkedHashMap:LRU的写法
```java
@param  accessOrder the ordering mode 
true for  access-order访问顺序, 
false for insertion-order插入顺序
public LinkedHashMap(int initialCapacity,
                         float loadFactor,
                         boolean accessOrder)
```



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

### 字符串存储 紧凑字符串
Java 中的 char 是两个 bytes 大小.
Java 9 中，引入了 `Compact Strings` 的设计，对字符串进行了大刀阔斧的改进。将数据
存储方式从 char 数组，改变为一个 byte 数组加上一个标识编码的所谓 coder，并且将相关字
符串操作类都进行了修改。所有相关的 Intrinsic 之类也都进行了重写，以保证没有任何
性能损失。

字符串也出现了一些能力退化，比如最大字符串的大小。
原来 char 数组的实现，字符串的最大长度就是数组本身的长度限制，但是替换成 byte 数组，
同样数组长度下，存储能力是退化了一倍的！ 理论中的极限。

#### 编码
`getBytes()/String (byte[] bytes)` 等都是隐含着使用平台默认编码

### 字符串拼接
在 JDK 8 中，字符串拼接操作会自动被 javac 转换为 StringBuilder 操作.
JDK 9 里面则是因为 Java 9 为了更加统一字符串操作优化，提供了 StringConcatFactory，作
为一个统一的入口。


#### StringBuffer
1. 线程安全
public `synchronized` StringBuffer append(String str) 
-  CharSequence字符序列类

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
#### StringBuilder
1. `StingBuilder`线程不安全
2. 连接大量字符串 .append .toString()

`javap -c `查看编译后的指令
1.`String a ="a"+1;`会生成builder加入a1
2.`String b = a+"b";`执行一次append
```java
String c=null;
for(i in 5){
    c+=i;//会创建5个StringBuilder 应该用append拼接
}
```


### 字符串缓存
String 在 Java 6 以后提供了 intern() 方法，目的是提示 JVM把相应字符串缓存起来，以备重复使用。在我们创建字符串对象并调用 intern() 方法的时候，如果已经有缓存的字符串，就会返回缓存里的实例，否则将其缓存起来。

- 一般使用 Java 6 这种历史版本，并不推荐大量使用intern，为什么呢？
被缓存的字符串是存在所谓 PermGen 里的，也就是臭名昭著的“永久代”，这个空间是很有限的，也基本不会被 FullGC 之外的垃圾收
集照顾到。所以，如果使用不当，就会OOM。

- 在后续版本中，这个缓存被放置在堆中，这样就极大避免了永久代占满的问题，甚至永久代在
JDK 8 中被 MetaSpace（元数据区）替代了。而且，默认缓存大小也在不断地扩大中，从最初
的 1009，到 7u40 以后被修改为 60013。
```java
-XX:+PrintStringTableStatistics
```

- Intern 是一种显式地排重机制，但是它也有一定的副作用，因为需要开发者写代码时明确调
用，一是不方便，每一个都显式调用是非常麻烦的；另外就是我们很难保证效率，应用开发阶段
很难清楚地预计字符串的重复情况，有人认为这是一种污染代码的实践。

-  Oracle JDK 8u20 之后，推出了一个新的特性，也就是 G1 GC 下的字符串排重。它是
通过将相同数据的字符串指向同一份数据来做到的，是 JVM 底层的改变，并不需要 Java 类库
做什么修改。

使用下面参数开启，并且记得指定使用 G1 GC：
`-XX:+UseStringDeduplication`


jdk1.8
```java
// "a"只要出现了就放到常量池
String s = new String("a");
// 已经放不进常量池了
s.intern();
String s2 = "a";
//false
System.out.println(s==s2);
String s3 = new String("a")+new String("a");
// 放的是引用
s3.intern();
String s4 = "aa";
//true
System.out.println(s3==s4);
```
![stringintern.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/stringintern.jpg)


#### JVM的 Intrinsic
在运行时，字符串的一些基础操作会直接利用 JVM 内部的 Intrinsic机制，往往运行的就是特殊优化的本地代码，而根本就不是 Java 代码生成的字节码。
`-XX:+PrintCompilation -XX:+UnlockDiagnosticVMOptions -XX:+PrintInlining `

Intrinsic 机制 ： 
利用 native 方式hard-coded的逻辑，算是一种特别的内联，很多优化还是需要直接使用特定的 CPU 指令.


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
}
```
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

### Character也有cache
```java
private static class CharacterCache {
    private CharacterCache(){}

    static final Character cache[] = new Character[127 + 1];

    static {
        for (int i = 0; i < cache.length; i++)
            cache[i] = new Character((char)i);
    }
}
//This method will always cache values in the range '\u0000' to '\u007F', inclusive,
public static Character valueOf(char c) {
    if (c <= 127) { // must cache
        return CharacterCache.cache[(int)c];
    }
    return new Character(c);
}
```

---
### Integer

#### SIZE,BYTES常量 为了统一整数的位数
Java 语言规范里面，不管是 32 位还是 64 位环境，开发者无需担心数据的位数差异。
```java
// Bit twiddling

/**
 * The number of bits used to represent an {@code int} value in two's
 * complement binary form.
 *
 * @since 1.5
 */
@Native public static final int SIZE = 32;

/**
 * The number of bytes used to represent a {@code int} value in two's
 * complement binary form.
 *
 * @since 1.8
 */
public static final int BYTES = SIZE / Byte.SIZE;
```

#### 缓存
缓存机制并不是只有 Integer 才有，同样存在于其他的一些包装类
缓存上限值实际是可以根据需要调整的，JVM 提供了参数设置：
`-XX:AutoBoxCacheMax=N `
- Boolean，缓存了 true/false 对应实例，确切说，只会返回两个常量实例
Boolean.TRUE/FALSE。
- Short，同样是缓存了 -128 到 127 之间的数值。
- Byte，数值有限，所以全部都被缓存。
- Character，缓存范围 '\u0000' 到 '\u007F'。

```java
Integer i3 =100;Integer i4= 100;
i3==i4;//(true)同一个对象
```
> 享元模式：共享对象 将1字节以内的数缓存

- Java 5 中新增了静态工厂方法 valueOf，在调用它的时候会利用一
个缓存机制，带来了明显的性能改进。
按照 Javadoc，这个值默认缓存是 -128 到 127 之间。

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

{% fold %}
```java
/**
 * Cache to support the object identity semantics of autoboxing for values between
 * -128 and 127 (inclusive) as required by JLS.
 *
 * The cache is initialized on first usage.  The size of the cache
 * may be controlled by the {@code -XX:AutoBoxCacheMax=<size>} option.
 * During VM initialization, java.lang.Integer.IntegerCache.high property
 * may be set and saved in the private system properties in the
 * sun.misc.VM class.
 */

private static class IntegerCache {
    static final int low = -128;
    static final int high;
    static final Integer cache[];

    static {
        // high value may be configured by property
        int h = 127;
        String integerCacheHighPropValue =
            sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
        if (integerCacheHighPropValue != null) {
            try {
                int i = parseInt(integerCacheHighPropValue);
                i = Math.max(i, 127);
                // Maximum array size is Integer.MAX_VALUE
                h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
            } catch( NumberFormatException nfe) {
                // If the property cannot be parsed into an int, ignore it.
            }
        }
        high = h;

        cache = new Integer[(high - low) + 1];
        int j = low;
        for(int k = 0; k < cache.length; k++)
            cache[k] = new Integer(j++);

        // range [-128, 127] must be interned (JLS7 5.1.7)
        assert IntegerCache.high >= 127;
    }

    private IntegerCache() {}
}
```
{% endfold %}

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

#### 自动装箱 / 自动拆箱是发生在什么阶段
自动装箱是一种语法糖。保证不同的写法在运行时等价，它们发生在**编译**阶段，也就是生成的字节码是一致的。

javac 替我们自动把装箱转换为 `Integer.valueOf()`，把拆箱替换为
`Integer.intValue()`

#### 性能优化
建议避免无意中的装箱、拆箱行为，尤其是在性能敏感的场合，创建 10 万个 Java 对
象和 10 万个整数的开销不是一个数量级的，不管是内存使用还是处理速度，光是对象头的空
间占用就已经是数量级的差距了。

- 使用原始数据类型、数组甚至本地代码实现等，在性能极度敏感的场景往往具有比较大的优势



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


---


### native
> native是由操作系统实现的，C/C++实现，java去调用。

- `Arrays.copyOf->System.arraycopy(org,0,copy,0,len)`

---
### Java8 
- default方法：接口内部有方法实现；实现两个接口有同名default名字冲突->报错

---

### synchronized JVM实现

### 泛型和原始数据类型
Java 的对象都是引用类型，
如果是一个 **原始数据类型数组**，它在内存里是一段连续的内存，
而**对象数组**则不然，数据存储的是引用，对象往往是分散地存储在堆的不同位置。

导致了数据操作的低效，尤其是无法充分利用现代 CPU 缓存机制。


### java对象的内存结构
对象在内存中存储的布局可以分为3块区域：对象头（Header）、实例数据（Instance Data）和对齐填充（Padding）。

#### 对象头8字节
1. Mark Word:标记位 4字节：第一部分用于存储对象自身的运行时数据，如哈
希码（HashCode）、GC分代年龄、锁状态标志、线程持有的锁、偏向线程ID、偏向时间戳
等，这部分数据的长度在32位和64位的虚拟机（未开启压缩指针）中分别为32bit和64bit，
官方称它为"Mark Word"。 



前4保存对象hash(3)，锁状态(1)
后4存储对象所属类的引用。

数组还有4字节保存数组大小。

#### Integer 
1. Mark Word:标记位 4字节，类似轻量级锁标记位，偏向锁标记位等。 
2. Class对象指针:4字节，指向对象对应class对象的内存地址。 
3. 对象实际数据:对象所有成员变量。 
4. 对齐:对齐填充字节，按照8个字节填充。 
 
Integer占用内存大小，4+4+4+4=16字节。


#### java内存

https://algs4.cs.princeton.edu/14analysis/
http://yueyemaitian.iteye.com/blog/2034305
https://blog.csdn.net/zhxdick/article/details/52003123

#### object
object overhead 16+int 4 padded到4的倍数(`-XX:-UseCompressedOops:`)
如果用压缩则`-XX:+UseCompressedOops: mark/4 + metedata/8 + 4 = 16 `
默认是启动压缩的
![javaobj.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/javaobj.jpg)
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
![javarefer.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/javarefer.jpg)
> References. A reference to an object typically is a memory address and thus uses 8 bytes of memory (on a 64-bit machine).

#### arrays
![javaarr.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/javaarr.jpg)
> Arrays. Arrays in Java are implemented as objects, typically with extra overhead for the length. An array of primitive-type values typically requires 24 bytes of header information (16 bytes of object overhead, 4 bytes for the length, and 4 bytes of padding) plus the memory needed to store the values.

基本类型 16的obj head+4(len)+4padding = 24 +存的类型\*长度

#### string
char[] ref(8)+int(4)+head(16)+padding->32+char[](arrayschar(24))=56+2N
![javastr.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/javastr.jpg)