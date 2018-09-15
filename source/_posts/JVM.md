---
title: JVM
date: 2018-04-23 21:21:18
tags:
category: [JVMlinux常用备注nginxredis配置]
---

27个点 内存占20G
堆内存-Xmx12m
https://www.jianshu.com/p/1b1c998c4448

### jstack 
https://toutiao.io/posts/1ogbep/preview
打印所有工作线程 包括析构Finalizer，JIT还有debug的
线程状态有6个


### javap 字节码指令
```shell
用法: javap <options> <classes>
其中, 可能的选项包括:
  -help  --help  -?        输出此用法消息
  -version                 版本信息
  -v  -verbose             输出附加信息
  -l                       输出行号和本地变量表
  -public                  仅显示公共类和成员
  -protected               显示受保护的/公共类和成员
  -package                 显示程序包/受保护的/公共类
                           和成员 (默认)
  -p  -private             显示所有类和成员
  -c                       对代码进行反汇编
  -s                       输出内部类型签名
  -sysinfo                 显示正在处理的类的
                           系统信息 (路径, 大小, 日期, MD5 散列)
  -constants               显示最终常量
  -classpath <path>        指定查找用户类文件的位置
  -cp <path>               指定查找用户类文件的位置
  -bootclasspath <path>    覆盖引导类文件的位置
```

JVM是基于栈的架构：指令短，指令数多
一般x86是基于寄存器的架构：指令长，指令集小

bytecode-viewerjava -XX:MaxHeapSize=734003200 -jar .\Bytecode-Viewer-2.9.11.jar 

jclasslib bytecode viewer




![suanfaGC](/images/suanfaGC.jpg)

### jstat 查看类加载/GC/JIT编译信息
[jstat官网](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jstat.html)



### jinfo 查看运行中的jvm参数
```shell
>jinfo -flag MaxHeapSize 1972
-XX:MaxHeapSize=734003200
>jinfo -flag ThreadStackSize <进程号>
```
打印进程Non-default参数（被赋值过的）
```shell
>jinfo -flags 1972
```
{% fold %}
```sh
Attaching to process ID 1972, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 25.144-b01
Non-default VM flags: -XX:CICompilerCount=3 -XX:InitialHeapSize=132120576 -XX:MaxHeapSize=734003200 -XX:MaxNewSize=244318208 -XX:MinHeapDeltaBytes=524288 -XX:NewSize=44040192 -XX:OldSize=88080384 -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseFastUnorderedTimeStamps -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC
Command line:  -Xmx700m -Djava.awt.headless=true -Djava.endorsed.dirs="" -Djdt.compiler.useSingleThread=true -Dpreload.project.path=D:/demo/algLearn -Dpreload.config.path=C:/Users/cecil/.IntelliJIdea2017.2/config/options -Dcompile.parallel=false -Drebuild.on.dependency.change=true -Djava.net.preferIPv4Stack=true -Dio.netty.initialSeedUniquifier=1077334432047011613 -Dfile.encoding=GBK -Djps.file.types.component.name=FileTypeManager -Duser.language=zh -Duser.country=CN -Didea.paths.selector=IntelliJIdea2017.2 -Didea.home.path=C:\Program Files\JetBrains\IntelliJ IDEA 2017.2.5 -Didea.config.path=C:\Users\cecil\.IntelliJIdea2017.2\config -Didea.plugins.path=C:\Users\cecil\.IntelliJIdea2017.2\config\plugins -Djps.log.dir=C:/Users/cecil/.IntelliJIdea2017.2/system/log/build-log -Djps.fallback.jdk.home=C:/Program Files/JetBrains/IntelliJ IDEA 2017.2.5/jre64 -Djps.fallback.jdk.version=1.8.0_152-release -Dio.netty.noUnsafe=true -Djava.io.tmpdir=C:/Users/cecil/.IntelliJIdea2017.2/system/compile-server/alglearn_d660bc04/_temp_ -Djps.backward.ref.index.builder=true -Dkotlin.incremental.compilation.experimental=true -Dkotlin.daemon.enabled -Dkotlin.daemon.client.alive.path="C:\Users\cecil\AppData\Local\Temp\kotlin-idea-4845382868272217760-is-running"
```

{% endfold %}

### jps
[jps官网](https://docs.oracle.com/javase/7/docs/technotes/tools/share/jps.html)
```shell
jps -l
5392 sun.tools.jps.Jps
1972 org.jetbrains.jps.cmdline.Launcher
6500
```

### JVM参数
1.`java -help`

#### XX参数(JVM调优和Debug)
1. Boolean类型
格式：`-XX:[+-]<name>` 启用或禁用name属性
启用CMS垃圾回收器
`-XX:+UseConcMarkSweepGC`
启用G1垃圾回收器
`-XX:+UseG1GC`

2. 非boolean kv类型
格式：`-XX:<name>=<value>`
GC最大停顿时间
`-XX:MaxGCPauseMillis=500`

##### `-Xmx` `-Xms`
`-Xms`等价于`-XX:InitialHeapSize`
`-Xmx`等价于`-XX:MaxHeapSize`
`-Xss`线程堆栈大小

#### X参数（非标准化参数）各个版本可能会变 不常用
java代码是解释执行的，JIT编译信息 即时编译 java代码转化成本地代码
`-Xint` 完全解释执行（不转换成本地代码
`-Xcomp` 第一次就编译成本地代码
`-Xmixed` 混合模式JVM自己决定是否本地代码
mixed mode:
```sh
java -version
java version "1.8.0_144"
Java(TM) SE Runtime Environment (build 1.8.0_144-b01)
Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, mixed mode)
```
解释模式：
```sh
java -Xint -version
java version "1.8.0_144"
Java(TM) SE Runtime Environment (build 1.8.0_144-b01)
Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, interpreted mode)
```
编译模式：
```sh
java -Xcomp -version
java version "1.8.0_144"
Java(TM) SE Runtime Environment (build 1.8.0_144-b01)
Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, compiled mode)
```

### 堆外内存

### 64位的JVM 寻址空间

### 类装载器
```java
/* 只有jvm能创建
 * Private constructor. Only the Java Virtual Machine creates Class objects.
 * This constructor is not used and prevents the default constructor being
 * generated.
 */
private Class(ClassLoader loader) {
    // Initialize final field for classLoader.  The initialization value of non-null
    // prevents future JIT optimizations from assuming this final field is null.
    classLoader = loader;
    }
```
1. 装载：（磁盘->内存）
1）取得类的二进制流：
装载器`ClassLoader` 读入java字节码装在到JVM
2）放到方法区
3）在堆中生成java.lang.Class对象 封装方法区的数据结构
2. 链接：
1.验证 符合jvm对字节码的要求
2.准备 为`static final`静态变量 分配内存，并初始化默认值。(还没生成对象)
3.解析 符号引用转换成指针or地址偏移量（直接引用）（内存中的位置）
3. 初始化：静态变量赋值（用户赋值）`<clint>`
    `lang.NoSuchFiledError`

最终结果是堆区的class对象，提供了访问方法区的接口（反射接口）

主动使用6种
1.创建类实例2.读写静态变量3.调用静态方法4.反射Class.forName 5.初始化类的子类 6.启动类
其它都是被动使用，都不会类初始化

jvm用软件模拟java字节码的指令集
jvm规范定义了：`returnAddress`数据类型 指向操作码的指针;
输出整数的二进制
```java
 public static void main(String[] args) {
        int a = 6;
        //0x80000000表示最高位为1的数字
        for(int i =0;i<32;i++){
            //取出a的第一位 //无符号右移( >>> )
            int t = (a&0x80000000>>>i)>>>(31-i);
            System.out.print(t);
        }
    }
```

`public native String intern();`运行期间放入常量池