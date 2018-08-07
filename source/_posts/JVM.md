---
title: JVM
date: 2018-04-23 21:21:18
tags:
---
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

## 类装载器
1. 装载：
1.取得类的二进制流：
装载器`ClassLoader` 读入java字节码装在到JVM
2.转为方法区的数据结构
3.在堆中生成对象
2. 链接：
1.验证
2.准备 `static final` 在准备阶段赋值，static被赋值0
3.解析 符号引用转换成指针or地址偏移量（直接引用）（内存中的位置）
3. 初始化`<clint>`
    `lang.NoSuchFiledError`


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