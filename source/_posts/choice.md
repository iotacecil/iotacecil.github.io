---
title: 单选题记录
date: 2018-12-25 15:34:13
tags: [面试卡片]
---
### 1.类加载
父类的静态成员初始化>父类的静态代码块>子类的静态成员初始化>子类的静态代码块>父类的代码块>父类的构造方法>子类的代码块>子类的构造方法

```java
public class Test {
 public static void main(String[] args) {
        System.out.println(Test2.a);
    }
}
class Test2{
    public static final String a=new String("JD");
    static {
        System.out.print("OK");
    }
}

答案：输出OKJD
```

```java
public class Test {
 public static void main(String[] args) {
        System.out.println(Test2.a);
    }
}
class Test2{
    public static final String a="JD";
    static {
        System.out.print("OK");
    }
}
答案：输出 JD
```

《java虚拟机》p213 
B中的常量，编译时通过【常量传播优化】直接存储到了Test类的常量池里，Test和B类的关系没有了。
```java
public class Test {
    public static void main(String[] args) {
        System.out.print(B.c);
    }
}
class A {
    static {
        System.out.print("A");
    }
}
class B extends A{
    static {
       System.out.print("B");
    }
    public final static String c = "C";
}
答案 C
```

《java虚拟机》P212
静态字段c，只有直接定义这个字段的类才会被初始化。
通过子类来引用父类中定义的静态字段，只会触发父类初始化，不会触发子类。
```java
public class Test {
    public static void main(String[] args) {
        System.out.print(B.c);
    }
}
class A {
    public static String c = "C";
    static {
        System.out.print("A");
    }
}
class B extends A{
    static {
        System.out.print("B");
    }
}
答案 AC
```

### 2.多线程
下面哪个行为被打断不会导致InterruptedException：（ ）？
A Thread.join
B Thread.sleep
C Object.wait
D CyclicBarrier.await
E Thread.suspend
他的回答： A (错误)
正确答案： E

如果抛出 InterruptedException 意味着一个方法是阻塞方法

如何在多线程中避免发生死锁？

正确答案 : ABCD您的答案 : BCD
A允许进程同时访问某些资源。
B允许进程强行从占有者那里夺取某些资源。
C进程在运行前一次性地向系统申请它所需要的全部资源。
D把资源事先分类编号，按号分配，使进程在申请，占用资源时不会形成环路。


下列关于线程调度的叙述中,错误的是(  )

正确答案 : C您的答案 : B
A调用线程的sleep()方法,可以使比当前线程优先级低的线程获得运行机会
B调用线程的yeild()方法,只会使与当前线程相同优先级的线程获得运行机会
C具有相同优先级的多个线程的调度一定是分时的
D分时调度模型是让所有线程轮流获得CPU使用权


下列关于线程调度的叙述中，错误的是（）。
A调用线程的sleep()方法，可以使比当前线程优先级低的线程获得运行机会
B调用线程的yeild()方法，只会使与当前线程相同优先级的线程获得运行机会
C当有比当前线程的优先级高的线程出现时，高优先级线程将抢占CPU并运行
D一个线程由于某些原因进入阻塞状态，会放弃CPU
E具有相同优先级的多个线程的调度一定是分时的
F分时调度模型是让所有线程轮流获得CPU使用权
正确答案：B C E
---

### 3. 进程线程
以下关于进程和线程的描述中，正确的一项是（ ）
A 一个进程就是一个独立的程序
B 进程间是互相独立的，同一进程的各线程间也是独立的，不能共享所属进程拥有的资源
C 每个线程都有自己的执行堆线和程序计数器为执行上下文
D 进程的特征包括动态性、并发性、独立性、同步性

他的回答： A (错误)
正确答案： C

#### 资源
某系统中有4个并发进程，多需要同类资源5个，试问该系统无论怎样都不会发生死锁的最少资源数是


---

### 4. 字符串
```java
public class Main {
    public static void main(String[] args) {
        String s1 = "abc";
        String s2 = "abc";
        System.out.println(s1 == s2);
        String s3 = new String("abc");
        System.out.println(s1 == s3);
    }
}
```
答案 true false

```java
String str1 = "cityu";
String str2 = new String("cityu");
String str3 = "city"+new String("u");
System.out.println(str1==str2);
System.out.println(str1==str3);
System.out.println(str2==str3);
```
答案 false false false

str2是引用，在栈，引用的内容先在常量池，再复制到堆，str2的引用是堆的地址。
str1是对常量池的引用

```java
String str1 = "cityu";
String str2 = new String("cityu");
String str3 = "city"+new String("u");
System.out.println(str1==str2.intern());
System.out.println(str1==str3.intern());
System.out.println(str2==str3.intern());
```
答案 true true true

intern会去查找常量池

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

### 5.设计模式

Java数据库连接库JDBC用到哪种设计模式?
A 生成器
B 桥接模式
C 抽象工厂
D 单例模式
他的回答： C (错误)
正确答案： B

#### 桥接模式：通过组合建立两个类之间的联系 ，而不是继承
抽象与实现分离，可以独立变化，而且各自可以继承扩展。
应用场景
一个类存在两个或多个独立变化的维度，需要独立进行扩展,防止类爆炸。
多个银行多种账户
![bridge.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/bridge.jpg)

```java
Bank icbcBank = new ICBCBank(new DepositAccount());
Account icbcAccount = icbcBank.openAccount();
```

JDBC:
DriverManager 和 具体的Driver 之前是桥接。
**所谓的抽象部分(JDBC API)与它的实现部分(JDBC Driver)分离**
`Driver` 和其mysql等数据库实现是 实现类。
`DriverInfo` 里注入(`registerDriver`)了Driver

Driver 中的静态块在调用`Class.forName`会调用Manager的静态方法register将Driver包装成DriverInfo注入。

JDBC通过 `DriverManager` 对外提供数据库的统一`getConnection`接口, 
返回的`Connection`也有不同的数据库实现类。`registerDriver`会找到真正的实现类。


抽象工厂：
数据库连接的`Connection`、`Statement`接口. 用于获取同一类的产品族。
mybatis的`SqlSessionFactory`构建session对象。

---

### 6.try catch
```java
public class Main {
    public static void main(String[] args) {
        System.out.print(fun1());
    }
    public static String fun1() {
        try {
            System.out.print("A");
            return fun2();
        } finally {
            System.out.print("B");
        }
    }
    public static String fun2() {
        System.out.print("C");
        return "D";
    }
}

执行以上程序后，输出结果正确的是？

正确答案 : C您的答案 : A
A ABCD
B ACDB
C ACBD
D 不确定
```

能单独和 finally 语句一起使用的块是
A try
B throws
C throw
D catch
他的回答： C (错误)
正确答案： A

throw 要用在try catch中
---


### 7. 复杂度
下面一段代码的时间复杂度是
```c
if ( A > B ) {
    for ( i=0; i<N; i++ )
    for ( j=N*N; j>i; j-- )
        A += B;
}
else {
    for ( i=0; i<N*2; i++ )
    for ( j=N*2; j>i; j-- )
        A += B;
}
```
A O(n)
B O(n的2次方)
C O(n的3次方)
D O(nlog2n).
他的回答： B (错误)
正确答案： C


关于递归法的说法不正确的是（ ）

正确答案 : D您的答案 : C
A程序结构更简洁 
B占用CPU的处理时间更多
C要消耗大量的内存空间，程序执行慢，甚至无法执行
D递归法比递推法的执行效率更高

### 8. 算法
若串S=”UP！UP！JD”，则其子串的数目
33
37
39
35

答案B

若字符串的长度为n,则子串的个数就是[n*(n+1)/2]+1个，重复的子串也考虑

包含1个字符的子串共n个； 包含2个字符的子串共n-1个； 包含3个字符的子串共n-2个； 包含4个字符的子串共n-3个； 包含n个字符的子串共1个； 空串1个； 子串个数共：1+2+3+……+n+1=n(n+1)/2+1；

子集数，串只能是相邻字符组成

如果不考虑重复字符串:
去掉长度为1的重复字符串一共 U P ! 都出现了2次 -3
去掉长度为2的重复字符串一共 UP P! 都出现了2次 -2
去掉长度为3的重复字符串一共 UP! 都出现了2次 -1

```java
public class Test {
    static int cnt = 0;
    public static void main(String[] args) {
        fib(7);
        System.out.println(cnt);
    }
    static int fib(int n) {
        cnt++;
        if (n == 0)
            return 1;
        else if (n == 1)
            return 2;
        else
            return fib(n - 1) + fib(n - 2);
    }
}
```
cnt(n)=cnt(n-1)+cnt(n-2)+1
f(0) 1次 f(1) 1次
f(2)=f(0)+f(1)+1=3
f(3)=f(1)+f(2)=1+1+3=5
f(4)=f(2)+f(3)=1+3+5=9
f(5)=f(4)+f(3)=1+9+5=15
f(6)=f(5)+f(4)=1+15+9=25
f(7)=f(6)+f(5)=25+15+1=41


#### 数据结构
广义表(((a,b,c),d,e,f))的长度是 
1
长度：去掉一层括号剩下的是几部分。 
深度：去掉几层括号可以到最后一部分.

以下序列中不可能是一棵二叉查找树的后序遍历结构的是:
A 1,2,3,4,5
B 3,5,1,4,2
C 1,2,5,4,3
D 5,4,3,2,1

B 无法找到一个合理的划分点，来组成二叉查找树 

一棵非空的二叉树的先序遍历序列与后序遍历序列正好相反，则该二叉树一定满足?

正确答案 : C您的答案 : D
A所有的结点均无左孩子
B所有的结点均无右孩子
C只有一个叶子结点
D是一棵满二叉树

具有7个顶点的【有向图】至少应有多少条边才可能成为一个强连通图?

正确答案 : B您的答案 : A
A 6 B 7 C 8 D 12
有向图强连通：从任何一点出发都可以回到原处，每个节点至少要一条出路(单节点除外)至少有n条边，正好可以组成一个环
最多n(n-1) 最少n

---

### 8.网络

#### nagle 算法

设置tcp的哪个socket参数会影响了 nagle算法？
正确答案: D 
TCP_MAXSEG
TCP_KEEPALIVE
TCP_SYNCNT
TCP_NODELAY

TCP/IP希望每次都能够以MSS尺寸的数据块来发送数据。Nagle算法就是为了尽可能发送大块数据,避免网络中充斥着许多小数据块.


一个提供NAT服务的路由器在转发一个源IP地址为10.0.0.1、目的IP地址为131.12.1.1的IP分组时，可能重写的IP分组首部字段是
Ⅰ.TTL
Ⅱ.片偏移量
Ⅲ.源IP地址
Ⅳ.目的IP地址

答案1，2，3
在路由器的分组转发过程中，间接转发时，源IP地址随着路由器的变化在不停变化，生存时间（TTL）每跳过一个路由器减1，片偏移量和偏移标志、首部检验和也可能发生变化。但目的IP地址始终不会变化。

查看系统内存如下：
    [@server ~]# free -g
    total used free shared buffers cached
    Mem: 15 5 9 0 0 2
    -/+ buffers/cache: 3 12
    Swap: 0 0 0
那么程序实际可使用内存有多少

HTTP中的POST和GET在下列哪些方面有区别?(  )

正确答案 : ABCDE您的答案 : ADE
A数据位置B明文密文C数据安全D长度限度E应用场景

### 9.数据库 SQL
sql中，可以用来替换DISTINCT的语句是（ ）


mysql数据库中一张user表中,其中包含字段A,B,C,字段类型如下:A:int,B:int,C:int根据字段A,B,C按照ABC顺序建立复合索引idx_A_B_C,以下查询语句中使用到索引idx_A_B_C的语句有哪些？

正确答案 : ABD您的答案 : AB
Aselect *from user where A=1 and B=1
Bselect *from user where 1=1 and A=1 and B=1
Cselect *from user where B=1 and C=1
Dselect *from user where A=1 and C=1

对于满足SQL92标准的SQL语句:
```sql
select foo,count(foo)from pokes 
where foo>10 group by foo having count (*)>5 
order by foo 
```
其执行顺序应该是?

正确答案 : A您的答案 : B
A FROM->WHERE->GROUP BY->HAVING->SELECT->ORDER BY
B FROM->GROUP BY->WHERE->HAVING->SELECT->ORDER BY
C FROM->WHERE->GROUP BY->HAVING->ORDER BY->SELECT
D FROM->WHERE->ORDER BY->GROUP BY->HAVING->SELECT

### 10. shell


Shell 脚本（shell script），是一种为 shell 编写的脚本程序。现有一个test.sh文件，且有可执行权限，文件中内容为：
```shell
#!/bin/bash
aa='Hello World !'
```
请问下面选项中哪个能正常显示Hello World !
sh test.sh >/dev/null 1 && echo $aa
./test.sh >/dev/null 1 && echo $aa
bash test.sh >/dev/null 1 && echo $aa
. ./test.sh >/dev/null 1 && echo $aa / source test.sh >/dev/null 1 && echo $aa
答案D
ABC都是开子shell，不影响当前环境中的变量
. ./test.sh等于source ./test.sh直接影响当前环境下的变量

在linux系统中,有一个文件夹里面有若干文件,通常用哪个命令可以获取这个文件夹的大小:

正确答案 : B您的答案 : B
Als -h Bdu -sh Cdf -h Dfdish -h

### 11. 操作系统
下列有关软连接描述正确的是

正确答案 : C您的答案 : D
A与普通文件没什么不同，inode 都指向同一个文件在硬盘中的区块
B不能对目录创建软链接
C保存了其代表的文件的绝对路径，是另外一种文件，在硬盘上有独立的区块，访问时替换自身路径D不可以对不存在的文件创建软链接

- 软链接有自己的文件属性及权限等；
-**可对不存在的文件或目录创建软链接**；
-软链接可交叉文件系统；
-软链接可对文件或目录创建；
-创建软链接时，链接计数 i_nlink 不会增加；
-删除软链接并不影响被指向的文件，但若被指向的原文件被删除，则相关软连接被称为死链接（即 dangling link，若被指向路径文件被重新创建，死链接可恢复为正常的软链接）
---

下列关于链接描述，错误的是
正确答案: B   你的答案: A (错误)
A硬链接就是让链接文件的i节点号指向被链接文件的i节点
B**硬链接和符号连接都是产生一个新的i节点**
C链接分为硬链接和符号链接
D硬连接不能链接目录文件

硬链接是有着相同 inode 号仅文件名不同的文件

- 文件有相同的 inode 及 data block；
- 只能对已存在的文件进行创建；
- 不能交叉文件系统进行硬链接的创建；
- 不能对目录进行创建，只可对文件创建；
- 删除一个硬链接文件并不影响其他有相同 inode 号的文件。

以下关于linux操作系统中硬链接和软链接的描述,正确的是?

正确答案 : B您的答案 : D
A硬链接和软链接指向的inode的编号是一样的
B可以建立一个空文件的软链接
Clinux操作系统可以对目录进行硬链接
D硬链接指向inode节点

### 12. linux
Linux文件权限一共10位长度(例如drwxrwxrwx)，分成四段，第三段表示的内容是:
正确答案: C   你的答案: B (错误)
A文件类型
B文件所有者的权限
C文件所有者所在组的权限
D其他用户的权限

`-rw-r--r--`10位权限 （r4 w2 x1 读写执行权限 -没有权限 rwx7r-x5r-x5）设计成2的幂次因为不会歧义
`rw-`u所有者权限
`r--`g所属组
`r--`其他人


### 13. 引用
下面有关值类型和引用类型描述正确的是（）？

正确答案 : ABC您的答案 : ABCD
A值类型的变量赋值只是进行数据复制，创建一个同值的新对象，而引用类型变量赋值，仅仅是把对象的引用的指针赋值给变量，使它们共用一个内存地址。
B值类型数据是在栈上分配内存空间，它的变量直接包含变量的实例，使用效率相对较高。而引用类型数据是分配在堆上，引用类型的变量通常包含一个指向实例的指针，变量通过指针来引用实例。
C引用类型一般都具有继承性，但是值类型一般都是封装的，因此值类型不能作为其他任何类型的基类。
D值类型变量的作用域主要是在栈上分配内存空间内，而引用类型变量作用域主要在分配的堆上。

跟作用域没关系

### 14. 泛型
JVM p251
```java
public class Test {
    public static void main(String[] args) {
        Test t = new Test();
        t.method(null);
    }
    public void method(Object o){
        System.out.println("Object");
    }
    public void method(String s){
        System.out.println("String");
    }
}
```
答案： String
方法重载，编译期间静态分派 如果输入一个char去匹配
1）先安全转型
char->int>long>float->double
不会匹配到byte和short 因为转型不安全
2）在自动装箱
Character，不会转成Integer
3）然后转型成父类
如果有多个父类，按继承关系，从下往上。如果实现了多个接口，优先级是一样的，不写明编译器报错。
4）可变长参数(char... arg)的优先级最低，而且不会转型成int了

注意重载时是通过静态类型（左边）而不是实际类型（右边）为依据，并且静态类型在编译期可知。

### cpp
以下代码输出什么?
```cpp
int a =1,b =32 ;
printf("%d,%d",a<<b,1<<32);
```
执行`a<<b`时，编译器会先将b与31进行and操作，以限制左移的次数小于等于31。
b&31=0，则`a<<b=1`
执行1<<32时，编译器直接执行算术左移的操作。

具有相同类型的指针类型变量p与数组a,不能进行的操作是:

正确答案 : D您的答案 : C
A `p=a;`
B `*p=a[0];`
C `p=&a[0];`
D `p=&a;`

A C是一样的

C++中构造函数和析构函数可以抛出异常吗?

正确答案 : C您的答案 : B
A都不行B都可以C只有构造函数可以D只有析构函数可以

开发C代码时,经常见到如下类型的结构体定义:
```cpp
typedef struct list_t{
struct list_t *next;
struct list_t *prev;
char data[0];
}list_t;
```
最后一行`char data[0];`的作用是?

正确答案 : AB您的答案 : B
A方便管理内存缓冲区B减少内存碎片化C标识结构体结束D没有作用

很容易构造出变成结构体，如缓冲区，数据包等等
构造缓冲区就是方便管理内存缓冲区,减少内存碎片化,它的作用不是标志结构体结束,而是扩展

### 行测 数学
由A地到B地,中间有一段扶梯,总路程和扶梯长度是固定的,为赶时间全程都在行走(包含扶梯上),中途发现鞋带松了,需要停下来绑鞋带.请问在扶梯上绑鞋带和在路上绑鞋带两种方式比较(  )

正确答案 : B您的答案 : C
A路上绑鞋带,全程用时短
B扶梯上绑鞋带,全程用时短
C用时一样
D和扶梯长度,绑鞋带具体用时有关


将7723810的各位数字打乱排序,可组成的不同的7位自然数的个数是?

正确答案 : B您的答案 : B
A1080
B2160
C3240
D4320
E5040

共有7的阶乘（5040）种排列，然后0在首位的排列有6的阶乘（720）种，数字中有两个7，所以结果在除以2，（5040-720）/2=2160.