---
title: 面试卡片
date: 2018-12-25 15:34:13
tags: [面试卡片]
---
https://blog.csdn.net/jackfrued/article/details/44921941
https://github.com/randian666/algorithm-study
https://www.nowcoder.com/discuss/50571?type=2&order=0&pos=21&page=2
https://github.com/xuelangZF/CS_Offer/blob/master/Linux_OS/Signal.md
http://www.linya.pub/

https://www.nowcoder.com/discuss/50571?type=2&order=0&pos=21&page=2

https://www.nowcoder.com/discuss/111311

架构扫盲
https://github.com/doocs/advanced-java


## 1.数据库

mysql 的其他引擎
设计数据库表

### 1.数据库里的乐观锁和悲观锁
共享锁：其他事务可以读也可以获取共享锁，但是不能写
排他锁：其他事务不能获取共享锁
意向锁是表锁
意向共享锁（IS) ：某些行上加S锁 `SELECT ... LOCK IN SHARE MODE；`
意向排他锁（IX）：某些行上加X锁 `SELECT ... FOR UPDATE`

悲观锁：`select ... for update;` 
   主键明确&有结果行锁，无结果集（查空）无锁。 
   查询无主键或者不走索引`where id<>'66'` `like`，表索 。
   排他性的读写锁、两阶段锁是悲观锁
乐观锁：数据库`version`字段 MVCC是乐观锁。读多写少，购票、余票系统。

### 2.索引什么时候会失效
1）有or or中的每个列都要有索引
2）like 以%开头 
用覆盖索引index_all 只访问索引的查询
using index & using where：
查找使用了索引，但是需要的数据都在索引列中能找到，所以不需要回表查询数据
例如联合索引a,b一般不能单独用b的索引，但是count就能用

3）如果where=字符串 一定要加引号
4)如果数据太少还是全表扫描快就不用，如果查询的列太多，数据太多，会直接走主键全表扫描
5）is null或者is not null

### 3.Mysql 有哪些索引
数据结构

物理存储

逻辑角度


### 4.数据库隔离界别

### 5.mybatis和jdbc比有什么好处
mybatis分为哪3层
1)动态sql

持久层框架 

### 6.防止sql注入如何实现
`#{}` 会被替换成sql中的？调用PreparedStatement set进参数
`${}` 是替换值

字段名不一样，定义resultMap，id标签映射主键并设置column，其他列用result标签

写模糊查询不要写在sql，用`#{}`传入

### 7.分页原理：
物理分页：limit offset
逻辑分页

### 8.数据库索引INNDB的好处
事务，主键索引，外键
自增长列必须是主键，索引的第一个列，而且因为不是表锁要考虑并发增长。
innodb其实不是根据每个记录产生行锁的，根据页加锁，而且用位图。
innodb 意向锁（表锁、行锁）
，在为数据行加共享 / 排他锁之前，InooDB 会先获取该数据行所在在数据表的对应意向锁。

一致性非锁定读：读快照 多版本并发控制：read committed是最新快照，重复读是事务开始时的快照。通过undo完成的。

redo 保证事务的一致性、持久性。undo 保证事务的一致性（回滚）和MVCC多版本并发控制。

不走索引表锁。

myisam 缓冲池之缓存索引文件，不缓存数据。 索引和数据分文件。

### 脏读
脏页是最终一致性的，数据库实例内存和磁盘异步造成的。脏（数据）读违反了隔离性。

### 9.mysql日志文件（不是引擎）
binlog(逻辑日志，是sql）记录了数据库更改的所有操作。
有3种格式 Statement：sql语句。 row：记录行的更改情况，很占空间，而且对复制的网络开销也增加。mixed。
用于point-in-time恢复、主从复制
只有事务提交时写磁盘一次。

慢查询、查询、错误

数据完整性：记录每个页的更改物理情况
redo重做日志缓存，按一定频率写到重做日志文件 是innodb的。
事务进行中，缓存每秒写入一次文件。
内部xa事务
事务提交先写binlog再写reodlog也写入磁盘。

doublewrite：内存中的2M buffer，磁盘上共享表空间的128个页（2M）
在应用重做日志之前，需要通过副本还原页。页刷新都首先要放入doublewrite。

因为只有一个主键并且建了B+树，所以其他辅助索引的插入是离散的，所以，有insert buffer

#### mysql为什么可重复读
读已提交：事务读不会阻塞其他事务读和写，事务写会阻塞其他事务读和写。
可重复读：事务读会**阻塞其他事务事务写**但不阻塞读，事务写会阻塞其他事务读和写。

不可重复读重点在于update和delete，而幻读的重点在于insert。
幻读：虽然可重复读对第一次读到的数据加锁，但是插入还是可以的，就多了一行。

因为binlog的Statement以commit顺序
可重复读会对读取到的数据进行加锁（行锁），保证其他事务无法修改这些已经读过的数据，

MVCC
每个数据行会添加两个额外的隐藏列，分别记录这行数据何时被创建以及何时被删除，这里的时间用版本号控制

所有的SELECT操作无需加锁，因为即使所读的数据在下一次读之前被其他事务更新了

行锁会用gap锁锁住一个区间，阻止多个事务插入到同一范围内。是为了解决幻读问题。
一个事务select * from t where a>2 for update;对[2+)加锁，另一个事务插入5失败。

#### 主从复制
主节点创建线程发送binlog，读取binlog时会加锁。
从节点I/O线程接受binlog，保存在relaylog。
从节点SQL线程读取relaylog，并执行sql。完成数据一致性。

主节点会为每一个当前连接的从节点建一个binary log dump 进程，而每个从节点都有自己的I/O进程，SQL进程。


### 10.数据库最左匹配原理

### 11.数据库连接池的原理

---
## 2.网络 web服务器

### 1.一个端口的连接数太多
Linux中，一个端口能够接受tcp链接数量的理论上限是？无上限
client端的情况下，最大tcp连接数为65535

server端tcp连接4元组中只有remote ip（也就是client ip）和remote port（客户端port）是可变的，因此最大tcp连接为客户端ip数×客户端port数，对IPV4，不考虑ip地址分类等因素，最大tcp连接数约为2的32次方（ip数）×2的16次方（port数），也就是server端单机最大tcp连接数约为2的48次方。

server端，通过增加内存、修改最大文件描述符个数等参数，单机最大并发TCP连接数超过10万 是没问题的

有一个接口一下子快一下子慢
1）用户怎么排查
2）开发者怎么排查
如果是一个数据库接口

### 2.反爬虫
1）单个IP、session统计 对header user-agent、referer检测

### 3.7层模型是哪7层

### 4.http
如果输入163.com跳转到www.163
301 重定向

响应码
304 缓存验证有效，未命中回200，如果服务器对象已删除404

####  重定向的响应头为302，并且必须要有Location响应头；
服务器通过response响应，重定向的url放在response的什么地方？
后端在header里的设置的Location url
重定向可以用于均衡负载

### 5.nginx
qps一般多少 5w-10w
10 000 个非活动 HTTP 保持连接，占用大约 2.5MB 的内存。

nginx的负载均衡策略

### 6.Nginx是如何工作的？是如何配置的？
比Apache占用内存更少
tomcat nginx apache 区别
Apache和nginx是 Http静态服务器
tomcat 是 Servlet 的容器，处理动态资源。

### 7.正向代理和反向代理的区别
正向代理：隐藏了真实的请求客户端，服务端不知道真实的客户端是谁。需要你主动设置代理服务器ip或者域名进行访问，由设置的服务器ip或者域名去获取访问内容并返回。

反向代理：

其他web服务器有哪些

### 8.nodejs为什么快？
单进程，异步IO 事件驱动 超过5w
主进程现在只要专心处理一些与I/O无关的逻辑处理

 Java 中每开启一个线程需要耗用 1MB 的 JVM 内存空间用于作为线程栈

### 9.为什么是三次握手
三次握手的过程：
https://juejin.im/post/5a0444d45188255ea95b66bc
客户端 SYN=1+序号a ， 
服务端 SYN=1，ACK=1,序号b，ack=序号a+1, 
客户端 ACK = 1，序号=a+1,ack=b+1

信道不可靠, 但是通信双发需要就某个问题达成一致. 而要解决这个问题, 三次通信是理论上的最小值。

1）初始化序号 （来解决网络包乱序（reordering）问题），互相通知自己的序号。

2）为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误。
如果A发送2个建立链接给B，第一个没丢只是滞留了，如果不第三次握手只要B同意连接就建立了。
如果B以为连接已经建立了，就一直等A。所以需要A再确认。

首次握手隐患：服务器收到ACK 发送SYN-ACK之后没有回执，会重发SYN-ACK。产生SYN flood。
用`tcp_syncookies` 参数

### 10.拥塞控制的方法

快恢复：网络拥塞后ssthresh设为拥塞的一半，cwnd不是变成1再慢开始

### 11.快重传
当发送方连续收到了3个重复的确认响应的时候，就判断为传输失败，报文丢失，这个时候就利用快重传算法立即进行信息的重传。
拥塞控制主要通过【慢开始，快重传，快恢复和避免拥塞】来实现的。
快恢复 与快重传配合使用，当发送方接收到连续三个重复确认请求，为了避免网络拥塞，执行拥塞避免算法

### 11.可靠传输的方法
1.确认重传  
    1）超时重传 发送一个数据之后，就开启一个定时器，没收到对应的ACK，重传
    2）快重传 当接收方收到【乱序片段】时，需要重复发送ACK
2.数据校验
3.数据合理分片和排序
- UDP：IP数据报大于1500字节,大于MTU.这个时候发送方IP层就需要分片(fragmentation).把数据报分成若干片,使每一片都小于MTU.而接收方IP层则需要进行数据报的重组.这样就会多做许多事情,而更严重的是,由于UDP的特性,当某一片数据传送中丢失时,接收方便无法重组数据报.将导致丢弃整个UDP数据报.
- TCP会按MTU合理分片，接收方会缓存未按序到达的数据，重新排序后再交给应用层。
4、流量控制：当接收方来不及处理发送方的数据，能提示发送方降低发送的速率，防止包丢失。
5、拥塞控制：当网络拥塞时，减少数据的发送。


#### TCP滑动窗口window size 16bit位 可靠性+流量控制+拥塞控制
window 接收端告诉发送端自己还有多少缓冲区可以接收数据rwnd
option中还有一个窗口扩大因子

### 12.为什么四次分手
1)由于TCP连接是全双工的，因此每个方向都必须单独进行关闭。
    当一方完成它的数据发送任务后就能发送一个FIN来终止这个方向的连接。
    收到一个 FIN只意味着这一方向上没有数据流动，一个TCP连接在收到一个FIN后仍能发送数据。首先进行关闭的一方将执行主动关闭，而另一方执行被动关闭。


### 13.为什么要TIME_WAIT等2MSL  最长报文段寿命
1）可靠地实现TCP全双工连接终止。等最后一个ACK到达。
MSL是任何IP数据报的最长存活时间。
如果没收到ACK，则被动方重发FIN，再ACK正好是两个MSL。

2)让本连接持续时间内所有的报文都从网络中消失，下个连接中不会出现旧的请求报文。
为什么是2MSL是让某个方向上最多存活MSL被丢弃，另一个方向上的应答最多存活MSL被丢弃。


主动关闭方发送的最后一个 ack(fin) ，有可能丢失，这时被动方会重新发fin, 如果这时主动方处于 CLOSED 状态 ，就会响应 rst 而不是 ack。所以主动方要处于 TIME_WAIT 状态，而不能是 CLOSED 。
【rst】是一种关闭连接的方式。
如果另一端向我已经关闭的输入信道发送数据，操作系统就会向另一端发送一条RST。
如果现在已经发送了10条，这十条的相应还在操作系统缓冲区，对方RST会让我清空缓冲区，已缓存的未读相应丢失。

### 14.TIME_WAIT 和 CLOSE_WAIT
1）发送FIN变成FIN_WAIT1，然后收到对方ACK+FIN，发完ACK
2）FIN_WAIT1 收到ACK之后到FIN_WAIT2，然后收到FIN，发送ACK。如果最后一个ACK失败，重发FIN但是对方已关闭会得到RST，发送FIN方会报错。
这个状态等2MSL后就CLOSED
作用：让本连接持续时间内所有的报文都从网络中消失，下个连接中不会出现旧的请求报文。

HTTP长连接主动关闭的是server，TIME_WAIT可以修改参数解决。
`net.ipv4.tcp_tw_recycle = 1`可以快速回收TIME-WAIT

CLOSE_WAIT 被动关闭后没有释放连接，一般是代码写的有问题。

TCP连接状态书上一共11种

### 15.和UDP区别
1）无连接 不可靠 无序
2）广播
3）速度快 报头只有8字节 TCP是字节流 20字节（1行32位4字节)，数据分段TCP是无边界的，UDP面向报文，保留了边界。

### 16.ping命令原理
发送ICMP请求报文（类型8）一定会从host或者getway返回一个ICMP 响应报文(类型0)
发送一个32字节的测试数据，TTL经过一个路由器就-1. ping 127.0.0.1 TTL是128.

### 17.输入URL之后经历什么
1）查DNS，向DNS服务器发UDP包
2）IP包到网关需要知道网关的MAC地址，用ARP
3）DNS服务器会去查根据名服务器得到注册的域名服务器
4）得到IP给浏览器，浏览器，发TCP建立连接
5）接到重定向到Https，先对443端口握手
6）交换可用协议，约定随机数

### 18.HTTP 长连接怎么实现
HTTP管道是什么，客户端可以同时发出多个HTTP请求，而不用一个个等待响应
通过共享的TCP连接发起并发的HTTP请求。
http1.0的`Connection：keep-Alive` 如果有多个中间的代理服务器会有问题，因为虽然客户端和服务端明白长连接，但是中间代理不懂，会发送关闭等待服务器关闭。
http1.1 持久连接，如果要关闭，加`Connection:close`

### 19.http https
HTTP+ 加密 + 认证 + 完整性保护 =HTTPS
https的过程：
http先和ssl通信，再ssl和tcp通信。
在交换密钥环节使用【公开密钥】加密方式，
之后的建立通信交换报文阶段则使用【共享密钥】加密方式。

对称和非对称 随机码用来？

随机码用服务端的公钥加密，

![httphttps.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/httphttps.jpg)
http 有9种方法
![https2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/https2.jpg)

RSA:
两种方式：
1）全密文：用对方公钥加密，对方用私钥解密 
2）明文+印章（防抵赖）：用自己私钥签名，对方用公钥验签
使用AOP实现

### 20.网络编程的一般步骤

---
## 3.操作系统 

### 1.三态转换

### 2.进程间通信
套接字，管道，命名管道、邮件槽、远程过程调用、消息队列，共享内存，信号量,信号。

信号：异步的通知机制，用来提醒进程一个事件已经发生

信号是在软件层次上对中断机制的一种模拟。    

`trap -l`
`trap "" INT` 表明忽略SIGINT信号，按Ctrl+C也不能使脚本退出

https://github.com/xuelangZF/CS_Offer/blob/master/Linux_OS/IPC.md

管道只能两个进程
消息队列能多个进程

#### 管道 【随进程持续】：
1）单向 半双工：把一个程序的输出直接连接到另一个程序的输入
2）除非读端已经存在，否则写端的打开管道操作会一直阻塞
3）只能父子进程、兄弟进程
4）无格式字节流，需要事先约定数据格式。


###### 匿名管道：内存文件描述符（内核）。
1）`pipe(2)`系统调用时，这个函数会让系统构建一个匿名管道
2）这样在进程中就打开了两个新的，打开的文件描述符：父进程关闭管道读端，子进程关闭管道写端。
3）一般再fork一个子进程，然后通过管道实现父子进程间的通信。
4）通过只在【内存】（内核）中的文件描述符fd[0]表示读 fd[1]表示写。（父子进程分别关闭一端组合成父进程->子进程/子进程->父进程的管道）

##### 命名管道FIFO文件：提供一个路径名与之关联，以FIFO文件形式存在于【文件系统】
`mkfifo()`
可以通过文件的路径来识别管道，从而让没有亲缘关系的进程之间建立连接。
1)读管道程序 mkfifo创建管道文件，死循环read
2)写程序 打开管道文件写。

借助了文件系统的file结构和VFS的索引节点inode。过将两个file 结构指向同一个临时的VFS 索引节点，而这个VFS引节点又指向一个物理页面


管道和命名管道都是随进程持续的，而消息队列还有后面的信号量、共享内存都是随内核持续的

#### 消息队列（链表） msgget（同一台机器） 系统内核： （一种逐渐被淘汰的方式）
`msgid = msgget((key_t)1234, 0666 | IPC_CREAT); `msgget()msgrcv()
1）异步：消息队列本身是【异步】的，消息队列独立于进程存在。它允许接收者在消息发送很长时间后再取回消息
2）消息必须以`long int` 开头 , 接收程序可以通过消息类型有选择地接收数据。
3）可以同时通过发送消息，避免命名管道的同步和阻塞问题，不需要由进程自己来提供同步方法。

4）轮询：收者必须轮询消息队列，才能收到最近的消息。
5）优先级
6）与管道相比，消息队列提供了有格式的数据 【读写双方都需要`msgget`建立消息队列】
7）和信号相比，消息队列能够传递更多的信息

#### 共享内存`shmget` 最快但是无法解决同步
1）`shmget`创建一个 结构体大小的共享内存，有权限
2）`shmat` 映射到进程的地址空间。
3）读写的时候要用written标志防止两个进程同时读写 而且要把written变成原子操作
4）`shmdt`可以分离共享内存
```c
struct shared_use_st{
    int written;
    char text[2048];
};
```

同一个Linux机器的两个进程访问同一块共享内存，他们访问共享内存中的同一个对象的时候，指针相同吗？
可能相同也可能不同

#### 信号量`semget` 有权限
不是线程同步的posix信号量，是`SYSTEM V`信号量
信号量能解决 共享内存同步问题

### 3.进程的调度方式
1）


---
## 4.java基础
### 1.Java 类加载的过程
类加载的过程包括了【加载、验证、准备、解析、初始化】五个阶段
加载：堆中生成Class对象。静态存储结构（字面量和符号引用）放到运行时数据区。
验证：文件格式、元数据、字节码（数据流、控制流）、符号引用 验证
准备：分配内存，设初始值
解析：符号引用->直接引用
初始化

### 2.java8的新特性
1)接口默认方法
2）函数式接口、lambda表达式
3）方法引用
4）Stream流
5）Optional防空指针
6）Date/time LocalDate

### 3.Object有哪些方法
还有`getClass()` 和`finalize`
wait 方法必须在synchronized内用

### 4.JVM分哪几个区
虚拟机运行时数据区
1）程序计数器-多线程轮流切换并分配处理器执行时间，多线程切换后恢复到正确的执行位置。
2）虚拟机栈
3）本地方法栈

#### 介绍JVM堆和栈，有什么用
虚拟机栈：生命周期与线程相同。Java 方法执行的内存模型，局部变量表、返回地址、操作数栈、动态链接（？）

JVM结构
新生代有什么算法

### 5.Java内存分配策略
Java对象的内存分配主要是指在堆上分配（也有经过JIT编译后被拆散为标量类型并间接地在栈上分配的情况），对象主要分配在新生代的Eden区上，如果启动了本地线程分配缓冲，则将按线程优先在TLAB（Thread Local Allocation Buffer）上分配。

怎么把对象分配到老年代上

### 6.泛型的好处
泛型：向不同对象发送同一个消息，不同的对象在接收到时会产生不同的行为（即方法）；也就是说，每个对象可以用自己的方式去响应共同的消息。消息就是调用函数，不同的行为是指不同的实现（执行不同的函数）。
用同一个调用形式，既能调用派生类又能调用基类的同名函数。

### 7.方法的重载和重写都是实现多态的方式，
区别在于前者实现的是编译时的多态性，而后者实现的是运行时的多态性。

- 为什么不能根据返回类型来区分重载?
因为调用时不能指定类型信息，编译器不知道你要调用哪个函数。

虚函数是实现多态 "动态编联”的基础，C++中如果用基类的指针来析构子类对象，基类的析构要加`virtual`，不然不会调用子类的析构，会内存泄漏。

### 8.虚拟机如何实现多态
重载：静态分派
重写：动态分派


### 9.除了基本类型还有那些类能表示数字
包装类，高精度BigDecimal，原子类

### 10.垃圾收集器
CMS
G1

### 11.注解
`@Override`方法的作用：
1）准确判断是否覆盖成功 
2）抽象类中对方法签名进行修改，其实现类会马上编译报错。 


### 12.java的进程通信
JMI不同虚拟机的通信，通过JRMP协议通信

管道 Java中没有命名管道 
```java
// 启动子进程
ProcessBuilder pb = new ProcessBuilder("java", "com.test.process.T3"); 
Process p = pb.start(); 
// 或者
Runtime rt = Runtime.getRuntime(); 
Process process = rt.exec("java com.test.process.T3"); 
// 子进程的输出
BufferedInputStream in = new BufferedInputStream(p.getInputStream()); 
```

共享内存
nio有内存映射文件mmap 
https://cloud.tencent.com/developer/article/1031860
```java
RandomAccessFile raf = new RandomAccessFile("D:/a.txt", "rw"); 
FileChannel fc = raf.getChannel();  
// 核心 系统调用mmap
MappedByteBuffer mbb = fc.map(MapMode.READ_WRITE, 0, 1024); 
FileLock fl = fc.lock();//文件锁 
```

mmap和共享文件的区别
操作系统划分出一块内存来共多个进程共享使用
mmap需要把内容写回到文件，所以还需要与文件打交道；而SM则是完全的内存操作，不涉及文件IO，效率上可能会好很多。还有就是SM使用的系统调用是shmget和shmctl。

FileChannel 是将共享内存和磁盘文件建立联系的文件通道类。

信号量
```java
OperateSignal operateSignalHandler = new OperateSignal(); 
Signal sig = new Signal("SEGV");//SEGV 这个linux和window不同 
Signal.handle(sig, operateSignalHandler); 
public class OperateSignal implements SignalHandler{ 
    @Override 
    public void handle(Signal arg0) { 
    System.out.println("信号接收"); 
    } 
} 
```



### 10.线程池的运行流程，使用参数以及方法策略

运行流程：
1）如果运行的线程小于`corePollsize`，则创建新线程，即使其他事空闲的。
2）当线程池中线程数量>`corePollsize` 则只有当`workQueue`满才去创建新线程处理任务
3）如果没有空闲，任务封装成Work对象放到等待队列
4) 如果队列满了，用`handler`指定的策略 （5种）
`ctl` 状态值（高3位）和有效线程数（29位）

![threadpoll.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/threadpoll.jpg)

线程池的状态：
RUNNING： 能接受提交
SHUTDOWN: 不能提交，但是能处理。
STOP： 不接受提交也不处理 
TIDYING： 所有任务都已经终止 有效线程数为0
TERMINATED： 标识

一共有5种线程池：
1）fixed
2）cached 处理大量短时间工作任务 长期闲置的时候不会消耗资源
3）sigle 保证顺序执行多个任务
4）scheduled 定时、周期工作调度
最大线程数是Integer.MAX_VALUE，
空闲工作线程生存时间是0，
阻塞队列是DelayedWorkQueue，是堆
ScheduledFutureTask实现了Comparable接口，是按照任务执行的时间来倒叙排序的

5）`newWrokStealingPoll` 工作窃取

#### 如何优化线程池
怎么配置参数

## 5.分布式

### 1.zookeeper的应用场景
分布式协调 节点注册监听
分布式锁

### 2.XA事务 分布式事务
事务管理器（Mysql客户端）和资源管理器（Mysql数据库）之间用两阶段提交，等所有参与全局事务的都能提交再提交
用JAVA JTA API

### 3.微服务系统的最大挑战
数据一致性问题
1）多实例的并发访问、修改
2）不同请求之间的数据隔离
3）多服务的业务请求，原子性
4）回滚

## 6.数据结构
### 1.二叉平衡树的应用 红黑树原理
红黑树确保没有一条路径会比其他路径长出俩倍
AVL树是严格的平衡二叉树
如果应用场景中对插入删除不频繁，只是对查找要求较高，那么AVL还是较优于红黑树。
windows对进程地址空间的管理用到了AVL树

### 2.排序 希尔排序复杂度
当步长为1时，算法变为普通插入排序
已知最好n(log^2)n

### 3.最小生成树的两种算法
Prim算法，标记已选点，选标记点可达的最近点标记，直到标记完所有点。
把点划分为3类：不可达（不可选），可选，已选
复杂度：邻接矩阵O(v^2) 邻接表O(elog2v)

Kruskal算法，存在相同权值的边。
从权值最小的边开始遍历，直到图的点全部在一个连通分量中。
复杂度：

### 4.Hash碰撞的方法
1）开放地址法 开放地址法分： 线性探测法（会聚集）、平方探测、双散列
2）链地址法

不成功平均查找长度，要按照冲突解决方法查找到当前位置为空位置。最后/散列函数的mod（hash函数的分类个数）

## 7.框架
### 1.Spring容器初始化过程
ioc aop原理

#### 2.ioc怎么实现
构造函数、setter、注解

#### 3.Springboot的启动流程

#### 4.SpringMVC工作原理
1）servlet一共三个层次 
HttpServletBean:直接继承java的HttpServlet，将Servlet中的配置参数设置到相应的属性。

FrameworkServlet：初始化WebApplicationContext 抽象类静态方法 将不同类型请求合并到一个方法统一处理。还发布了一个事件。

DispatcherServlet:初始化9大组件
 doService方法保存redirect转发的参数和include的request快照。
 调用的doDispatch方法4步
  1）根据request找到handler（@RequestMapping）
  2）用mapper根据handler找到handlerAdapter 处理不同参数（不只是request和response）
  3）handlerAdapter处理，先执行拦截器。Last-Modified
  4）processDispatchResult处理View

### Spring 事务传播行为
7种类型的事务传播行为
1）Required ： 被调用的事务会合并到外围事务中，一起回滚
2）Supports：支持当前事务，如果没有事务，以非事务方式执行。
3）NESTED：外围无事务，各自事务不干扰，外围required，有Savepoint和父事务一起提交
4）MANDATORY：只能被一个父事务调用，不然异常
5）REQUIRES_NEW
6）NOT_SUPPORTED：如果B调用时B不支持，A事务会挂起
7）never：不能在事务中运行，会异常

## 8.并发
### 1.协程

#### 2.currentHashMap
https://blog.csdn.net/qq_33256688/article/details/79938886  
1.7之前是头插，1.8之后是尾插

不能为null

hashmap也是尾插
ConcurrentLinkedQueue
CountDownLatch，CyclicBarrier，线程池

### 3.CAS算法原理？优缺点？
https://juejin.im/post/5ba66a7ef265da0abb1435ae 
非阻塞算法：一个线程的失败或者挂起不会导致其他线程也失败或者挂起。
无锁算法：算法的每个步骤，都存在某个线程能执行下去。多个线程竞争CAS总有一个线程胜出并继续执行。

CAS 是实现非阻塞同步的计算机指令，它有三个操作数，内存位置，旧的预期值，新值，
对于多个状态变量的场景，通过`AtomicReference`包装这个对象，每次更新先获取旧值，再创建新值，用这两个值进行CAS原子更新。

#### CAS 实现原子操作的三大问题
1) ABA问题 `AtomicStampedReference` 不可变对象pair
2）循环CPU开销  JVM pause指令
3）多个共享变量 `AtomicReference`

AQS利用CAS原子操作维护自身的状态，结合LockSupport对线程进行阻塞和唤醒从而实现更为灵活的同步操作。

### 3.AQS
AQS的核心思想是基于volatile int state这样的一个属性同时配合Unsafe工具对其原子性的操作来实现对当前锁的状态进行修改。
`private volatile int state;`
`ReentrantLock`用来表示所有者重复获取该锁的次数
`Semaphore`表示剩余许可数量
`FutureTask`用于表示任务状态(现在FutureTask不用AQS了)但也是state

当线程尝试更改AQS状态操作获得失败时，会将Thread对象抽象成Node对象 形成CLH队列，LIFO规则。

### juc的锁
StampedLock多个读不互相阻塞，同时在读操作时不会阻塞写操作。


---
## 9.redis
### 1.redis高性能的原因
1）内存
2）单线程
3）网络请求io多路复用
“多路”指的是多个网络连接，“复用”指的是复用同一个线程。采用多路 I/O 复用技术可以让单个线程高效的处理多个连接请求（尽量减少网络 IO 的时间消耗），且 Redis 在内存中操作数据的速度非常快，也就是说内存内的操作不会成为影响Redis性能的瓶颈，主要由以上几点造就了 Redis 具有很高的吞吐量。


### 2.redis持久化
持久化方式：
1）快照 Mysql Dump和Redis RDB 2）写日志 Mysql Binlog Hbase Hlog Redis AOF

RDB是保存数据库中的键值对，AOF保存redis执行的命令。

#### RDB
RDB是压缩过的二进制文件,会生成临时文件，把老的RDB文件替换掉。
BGSAVE不会阻塞服务器进程，会创建子进程创建RBD文件。copy-on-write策略，但是父进程写入还会做副本 内存开销大。
触发机制：从节点全量复制主节点会生成RDB文件。 debug reload 、 shutdown。
缺点磁盘性能，宕机没快照的丢了。但是恢复速度快。

#### AOF
AOF更新频率通常比RDB高。
写【命令】先从redis 写到硬盘缓冲区 再根据3种策略（everysec每秒，always，no（操作系统自己刷)）fsync到硬盘AOF文件。
AOF会开子进程重写。

#### 主从复制
主从复制（副本）集群是为了解决多请求，读写分离，高可用，
分布式是为了解决一个请求的多个步骤。

redis主从同步的问题
redis集群一致性hash如何解决分布不均匀

数据是单向的。可以通过`slaceof` 或者配置方式`slave-read-only yes`实现。
进入redis用`info replication`可以查看主从状态

##### 全量复制
1）第一次是全量复制`full resync` master会`BGSAVE`。
2）从节点的数据全部清除`Flushing old data`，通过网络接受RDB文件，加载RDB文件到内存。
`info server |grep run` 
3）在同步期间master的写命令会单独记录，rdb同步完后通过偏移同步给slave。
可以看到redis实例的run_id。如果从复制的主节点的id发生变化，则需要全量复制。

![fullsync.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/fullsync.jpg)

##### 部分复制
`info replication` 可以看到master的偏移量`master_repl_offset`和slave的偏移量`slave_repl_offset`，主节点可以看到各个从节点的偏移量。
偏移量主比从大表示主写入了数据还没同步到从。
如果主从连接断了，先重连，从服务器发送runid和offset，主服务器发送buffer中的部分数据。

#### redis 高可用 sentinel


#### redis写失败怎么办


## 10.软工和测试
### 白盒测试是什么
### 怎么评价一个软件系统的好坏

## 11.设计模式
### 面向对象 和面向过程的区别
代码复用

对象的产生方式有
1）原型对象(prototype 原型链)为基础的 （所有对象都是实例）
2）基于类（Java)的对象模型。

---















### 10.线程同步的方法
互斥量(mutex) 

 读写锁 
 降级：获得写入锁能不能不释放获得读取锁。
 升级：一般不支持，因为两个读线程同时升级为写入锁，会死锁。

synchronized  
volatile
ThreadLocal
LinkedBlockingQueue

直接交接队列`SynchronousQueue`不使用缓存，没有空闲线程就开线程，需要限定好线程池最大数量。
atomic

### 10.1信号量 Semaphore ： 管理多线程竞争
例子：100个线程抢10个数据库连接。

### 10.2 Condition ： 线程通信 多个阻塞队列线程间通信
目的：Condition 可以在多线程中创建多个阻塞队列。
例子1：实现 【仓库数量>1】 的生产者消费者：
将生产者和消费者放入不同的阻塞队列，精准控制。
生产者判断full满就阻塞，加入商品后唤醒所有阻塞empty的消费者线程。

Condition
1）由Lock对象生成
2）`await` 会释放锁，阻塞。 `signal`能唤醒。 wait和notify只能建立一个阻塞队列。 

### 10.3锁
#### Lock ReentreantLock
1）可中断 2）可定时轮询 3）锁分段，每个链表节点用一个独立的锁，多线程能对链表的不同部分操作。
4）公平性
Sync继承AQS，
公平锁的实现机理在于每次有线程来抢占锁的时候，都会检查一遍有没有等待队列

5）可重入Thread.currentThread()
可重入是如何实现的？

6)业务锁
同一个账户的存钱、取钱业务应该先完整完成一次后才释放锁。
Lock可以跨方法锁对象：登录加锁，登出释放。
`tryLock`如果获取锁失败会立刻返回 false，不会阻塞。

#### Lock 和 syncronize的区别
异常机制区别

#### syncronize 可重入
对象头 Monitor(管程) entry set，wait set
https://blog.csdn.net/javazejian/article/details/72828483
正确说法：给调用该方法的【对象】加锁。在一个方法调用结束之前，其他线程无法得到这个对象的控制权。

缺点：只能实现方法级别的排他性，不能保证业务层面（多个方法）。

##### Synchronized的锁优化机制

#### `notify`和`wait`
放置在sychronized作用域中，wait会释放synchronized关联的锁阻塞，
实现存库为1的生产者消费者。


线程池 参数，常用的
callable

### 11.C++虚函数作用及底层实现
虚函数是使用虚函数表和虚函数表指针实现的。
虚函数表：一个类 的 虚函数 的 地址表：用于索引类本身及其父类的虚函数地址，如果子类重写，则会替换成子类虚函数地址。
虚函数表指针： 存在于每个对象中，指向对象所在类的虚函数表的地址。
多继承：存在多个虚函数表指针。

### 12.千万数据的表怎么优化
SQL优化：
1）超过500w要分表
  数据按照某种规则存储到多个结构相同的表中，例如按 id 的散列值、性别等进行划分
  水平切分的实现：
  Merge存储引擎允许将一组使用MyISAM存储引擎的并且表结构相同（即每张表的字段顺序、字段名称、字段类型、索引定义的顺序及其定义的方式必须相同）的数据表合并为一个表，方便了数据的查询。
```sql
CREATE TABLE log_merge(  
    dt DATETIME NOT NULL,  
    info VARCHAR(100) NOT NULL,  
    INDEX(dt)  
) ENGINE = MERGE UNION = (log_2004, log_2005, log_2006, log_2007)  
INSERT_METHOD = LAST;
```
2）Explain
3）减少查询列
4）减少返回的行 limit
5）拆分大的delete和insert，不然会一次锁住很多数据

### 13. 


### 15.基于比较的算法的最优时间复杂度是O(nlog(n))
因为n个数字全排列是n! 一次比较之后，两个元素顺序确定，排列数为 n!/2!
总的复杂度是O(log(n!)) 根据斯特林公式就等于O(nlog(n))


### 18 没有中序没办法确定二叉树
前序 根左右
后序 左右根
找不到左右的边界

### 19 redis动态字符串sds的优缺点
结构：1）len 2）free 3）buf数组
优点
1）以\0结尾，可以复用c string的库函数。
2）O(1)复杂度获取长度
3) **杜绝缓冲区溢出** （c如果没分配够空间就直接覆盖了)
4) 减少内存重分配（空间预分配和惰性空间释放）
5）二进制安全（可以存图片等特殊格式），c字符串中不能包含空字符。


### 20 数据库三范式
第一范式：列不可拆分 目的：列原子性 
第二范式：每个属性要【完全依赖】于主键，如果主键有多个候选键，属性
第三范式：非主键关键字段之间不能存在依赖关系，避免更新、插入、删除异常。每一列都要与主键直接相关。【消除传递依赖】。
    例子： 各种信息只在一个地方存储，不出现在多张表中。 如果成员表已经有部门编号，不应该有部门表中的部门名称。
BCNF：表的部分主键依赖于非主键部分 应该拆分。
第四范式：两个均是1：N的关系，当出现在一张表的时候，会出现大量的冗余。所以就我们需要分解它，减少冗余。

### 20 数据库 5约束
主键约束PRIMARY KEY - NOT NULL 和 UNIQUE 的结合。
唯一约束UNIQUE  默认值约束DEFAULT  非空约束NOT NULL 外键约束FOREIGN KEY CHECK （CHECK (P_Id>0)）

### 20 自然连接 NATURAL JOIN
columns with the same name of associate tables will appear once only.
自然连接是指关系R和S在所有公共属性(common attribute)上的等接(Equijoin). 但在得到的结果中公共属性只保留一次, 其余删除.

控制文件：Oracle服务器在启动期间用来标识物理文件和数据库结构的二进制文件

### 21 内存溢出OOM和内存泄漏memory leak
`jstat`

### 22 四种引用类型
强引用，软引用，弱引用，虚引用
软引用：内存不够二次回收
弱引用：回收 
弱引用应用：优惠券 `WeakHashMap<Coupan, <List<WeakReference <User>>>`
    `weakCoupanHM.put(coupan1,weakUserList);`
当某个优惠券（假设对应于coupan2对象）失效时，我们可以从coupanList里去除该对象，coupan2上就没有强引用了，只有weakCoupanHM对该对象还有个弱引用，这样coupan2对象能在下次垃圾回收时被回收，从而weakCoupanHM里就看不到了。

当某个用户（假设user1）注销账号时，它会被从List<User>类型的userList对象中被移除。
    


### 23 Java线程状态
New， Runnable， Timed Waiting， Waiting，Blocked，Terminated

### 24 生产者消费者问题（消费的是同一个东西） 1个互斥2个同步
P表示-1，V表示+1
事件关系：
1）互斥：缓冲区是临界资源，需要**互斥**访问
2）同步：缓冲区满，生产者等待消费者取 （先后顺序）
3）同步：缓冲区空，消费者等生产者生产 （先后）

信号量机制：一个关系一个信号量
1）互斥信号量初始化为1
2）缓冲区同步的信号量根据系统资源初始值设定
    1）生产者：空闲缓冲区数量 信号量初始值`empty = n`
    2）消费者：缓冲区产品数量 初始值`full = 0`
互斥信号量是在同一个进程之间操作的。
一前一后同步关系 ，两个信号量的PV操作在不同的进程

生产者：
```java
product(){
    while(1){
        P(empty)
        P(mutex)
        //放入缓冲区
        V(mutex)
        V(full)
    }
}
custom(){
    while(1){
        P(full)
        P(mutex)
        // 取出
        V(mutex)
        V(empty)
    }
}
```
![cuspro.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/cuspro.jpg)

注意点：
1）对于P操作 一定要先操作同步信号量再操作互斥信号量，不然互斥加锁然后同步阻塞 循环等待 就死锁了。 V操作顺序无所谓
2）生产和使用操作不要放到PV操作（临界区）里面，时间太多

### 25 多生产者 多消费者 （一个临界区，但是生产者和消费者有特定类型）
例子：只有一个盘子，父亲-儿子之间生产-消费 苹果，母亲-女儿之间生产-消费 橘子

关系：
1）互斥：盘子
2）同步：父亲儿子 消费-生产
3）同步：母亲女儿 消费-生产
4）同步：盘子空（事件） 之后 放入水果

事件信号量：
1）互斥1
2）盘子中的苹果 0
3) 盘子中的橘子 0
4）盘子中的剩余空间 1
![cuspromulti.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/cuspromulti.jpg)

注意：
1）如果盘子资源为1，不用加互斥，剩余空间就可以用来互斥了
2）如果盘子资源为2以上，不加互斥会数据覆盖

### 26 读者-写者问题 count计数器
1）允许多个读
2）只许一个写
3）完成写之前不允许读/写
4）写之前要没有读/写操作

关系：
1）互斥：写-写
2）互斥：写-读（第一个读进程要对文件加锁）(最后一个进程解锁)

信号量：
1）互斥 是否有进程在访问文件 `semaphore rw = 1`
2) 当前有几个读进程在访问 `int count = 0`
3）互斥count：隐藏3 `mutex = 1` 因为判断是不是第一个和计数不原子，所以判断+增加要加锁
![read-write.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/read-write.jpg)

问题：实际上是读优先。读进程太多会导致写进程饿死
改进：用信号量`semaphore w = 1;`
```java
semaphore rw = 1 // 文件互斥
int count = 0 // 读进程计数
semaphore mutex = 1 // count计数互斥
semaphore w = 1 // 写进程优先
writer(){
    while(1){
        P(w)
        P(rw)
        // 写文件
        V(rw)
        V(w)
    }
}
reader(){
    while(1){
        // 如果前一个读执行到释放w后，
        // w会被写抢走，下一个读会等待写完成
        P(w)
        // 用于count互斥访问
        P(mutex)
        if(count == 0)
            P(rw)
        count++
        V(mutex)
        // 写会抢走
        V(w)
        P(mutex)
        count--
        if(count == 0)
            V(rw)
        V(mutex)
    }
}
```
不是疯狂写优先。是读写公平的。先来先服务的。

### 27 哲学家问题 两个临界资源 防止死锁
5个哲学家 5个筷子 拿起左然后右吃饭
方法1：只允许4个人吃饭(初始值为4的信号量)
方法2：奇数号的先拿左边，偶数号的先拿右边
方法3：用一个信号量同时对拿左边拿右边加锁
![zexuemutex.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/zexuemutex.jpg)

### 28 银行家算法（避免死锁） 安全序列 不会死锁
手里有100亿钱，A要最多借70，B最多借40，C最多借50，借完了就会全部还回来。现在已经分别借了ABC一些，ABC其中一个再发起了一个请求，应不应该借？
银行家算法：每次分配资源之前，判断是否会进入不安全状态（可能会产生死锁（没钱借又拿不会钱）
![yinhang.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/yinhang.jpg)
找安全序列：
用剩余资源 遍历所有进程 还需资源，如果可以分配，则分配+拿回全部资源+加入安全序列+从遍历中移除，再从头遍历所有进程。
![yinhang2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/yinhang2.jpg)

### 29 死锁条件
死锁是指两个或两个以上的进程在执行过程中，因争夺资源而造成的一种互相等待的现象，若无外力作用，它们都将无法推进下去。
死锁的发生必须满足以下四个条件：
- 互斥条件：一个资源每次只能被一个进程使用。
- 请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放。
- 不剥夺条件：进程已获得的资源，在末使用完之前，不能强行剥夺。
- 循环等待条件：若干进程之间形成一种头尾相接的循环等待资源关系。

### 30 死锁处理策略
1）预防死锁 前面4个条件 2）避免死锁 银行家算法 3）死锁检测再解除
互斥条件：SPOOLing 技术，将打印机变成共享设备，加一个队列。
不剥夺条件：得不到就放弃自己的 或者直接抢
请求和保持条件：静态分配（进程运行前一次性分配全部资源）
循环等待条件：顺序资源分配法 对资源加编号 同类资源一次性分配完


### 31 页面置换算法
OPT：知道后面会访问什么。向之后看，之后最后出现/没出现的的先删除
缺页中断
页面置换（满了才换）
缺页率：缺页次数/请求次数
FIFO：Belady异常。
LRU：如果满了，将内存块中的数值向前找，最早出现的那个删除。
CLOCK：时钟置换算法，NRU最近未用算法。 循环队列。 访问位。


### 33 ajax的四个步骤
1)创建xhr对象
2)open方法参数：method，url，同步或异步
3)send
4)注册一个监听器`onreadystatechange` readyState=4和status200 获得响应`.responseText`

### 34 XSS攻击，跨站脚本攻击
网站没有对用户提交数据进行转义处理或者过滤不足的缺点，进而添加一些恶意的脚本代码（HTML、JavaScript）到Web页面中去，使别的用户访问都会执行相应的嵌入代码。
解决方法：
1）cookie设置成http Only 不让前端`document.cookie`拿到
2）对输入多做一些检查 对 html危险字符转义

CSRF 盗取用户cookie或者session伪造请求
1)每次提交加随机数token
2）检查referer

### 35 防止表单重复提交
1）submit方法最后把按钮disable掉
2）用token
3）重定向


### 38 IO模型

#### 阻塞和非阻塞：
阻塞IO：等待数据（收到一个完整的TCP包）和系统内核拷贝到用户内核都阻塞了。
非阻塞IO：内核数据没准备好直接返回错误，需要轮询。
非阻塞IO需要和IO通知机制一起使用。
I/O通知机制：1） I/O复用函数【向内核注册一组事件】，内核通过I/O复用函数把就绪事件通知给应用程序。 I/O复用函数本身是阻塞的，可以同时监听多个I/O事件。
2）SIGIO信号。

accept()为什么会阻塞？
即使用多线程，serverSocket.accept()询问操作系统的客户端连接accept()还是单线程的，系统级别的【同步】网络I/O模型。
阻塞，非阻塞是程序级别的，同步非同步时操作系统级别的。

多路复用IO模型：操作系统在一个端口上同时接受多个客户端I/O事件。
事件驱动IO。select阻塞轮询所有socket，可以同时处理多个连接，（连接数不高的话不一定比多线程阻塞IO好）优势不在于单个连接处理更快，在于能处理更多的连接。而且单线程执行，事件探测和事件响应在一起。
以上三个都属于同步IO，都会阻塞进程。
select/poll/epoll都需要等待读写时间就绪后读写，异步IO会把数据从内核拷贝到用户。
epoll是根据每个fd上面的callback函数实现的。而且有mmap内核空间和用户空间同处一块内存空间。

#### 如何理解 nio是同步非阻塞


### 边缘触发和水平触发
https://www.jianshu.com/p/7835726dc78b
边缘触发：即使有数据可读,但是没有新的IO活动到来,epoll也不会立即返回.
epoll默认是水平触发

Level信号只需要处于水平，就一直会触发；而edge则是指信号为上升沿或者下降沿时触发

Epoll事件分派接口可以表现为边沿前触发 (ET)和 水平触发(LT).这两个机制之间的区别可以描述如下。
ET模式只有在被监控文件描述符发生变化时才递交事件

#### 同步和异步
事件处理模式
Reactor模式实现同步I/O，处理I/O操作的依旧是产生I/O的程序
异步I/O 订阅-通知：立即返回，内核完成数据准备+拷贝数据之后发送给用户进程一个信号。
Proactor实现异步I/O，产生I/O调用的用户进程不会等待I/O发生，具体I/O操作由操作系统完成。
异步I/O需要操作系统支持，Linux异步I/O为AIO，Windows为IOCP。

### 39异常 Error 和 Exception的区别
1）都继承Throwable
2）Error是JVM负责的
3）分为：可检查和不可检查异常
不检查：RuntimeException 是程序负责的
检查：checked Exception 是编译器负责的
![ErrirException.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/ErrirException.jpg)

异常处理机制：
在堆上创建异常  try catch中有return之前都会先执行finally的return




### java进程间通信


java 线程通信
全局变量
2个线程之间的单向数据连接 NIO pipe 写sink 读source。
java线程同步的方法


### 41 什么时候对象会被回收？如果互相引用
http://blog.jobbole.com/109170/
强引用=null
引用计数算法 无法解决互相引用的情况。
所以用的是 **可达性分析算法**：判断对象的引用链是否可达。
如果循环引用，没有人指向这个环也会被回收。
从GC root（栈中的本地变量表中的对象、类（方法区）常量、静态属性保存的是对象……）


类回收：
ClassLoader已经被回收，Class对象没有引用，所有实例被回收。

资源管理，如果数据库连接对象被收回，但是没有调用close，数据库连接的资源不会释放，数据库连接就少一个了，要放在try()里。

#### full GC
1）System.gc()方法的调用
2）老年代空间
3）Minor GC后超过老年代可用空间



### 45 布隆过滤器
黑名单
如果数据量有8G，hash冗余要保证16G
构造：使用16/8 = 2G 可以表示16G个bit位。
set：用8个随机函数，得到0-16G中8个随机数，并将这8位设置为1。
get：同样用这8个随机函数，查看这8位是否都为1。

### 46 精确的接口限流。
/禁止重复提交：用户提交之后按钮置灰，禁止重复提交 
如果做到精确5秒里只能访问10次

漏桶法 流量整形
个固定容量的漏桶，按照常量固定速率流出水滴

令牌桶（对业务的峰值有一定容忍度）
固定容量令牌的桶，按照固定速率往桶里添加令牌


前端做还是后台做

大数据相关的

### 47 linux 怎么查询一个端口

### 48 操作系统 进程通信

进程和线程的区别
1）地址空间，打开的资源
2）通信，全局变量：线程通信要加锁
3）调度和切换：切换快。
4）进程不是可执行的实体

文件是进程创建的信息逻辑单元
每个进程有专用的线程表跟踪进程中的线程。和内核中的进程表类似。

#### 进程结构：代码段、数据段、堆栈段
代码段：多个进程运行同一个程序，可以使用同一个代码段。
数据段：全局变量、常量、静态变量。
栈：用于存放 【函数调用】，存放函数的 【参数】，函数内部的【局部变量】
PCB位于核心堆栈的底部。
进程组ID是一个进程的必备属性。

子进程：
当调用`fork`时，子进程完全复制了父进程地址空间的内容，包括：堆、栈、数据段，并和父进程共享代码段，因为代码段是只读的，不会被修改。
在Linux上，对于多进程，子进程继承了父进程的下列哪些？
A 进程地址空间
B 共享内存
C 信号掩码
D 已打开的文件描述符
E 以上都不是

子进程对数据段和堆、栈段的修改不会影响父进程。
“写时复制”：现在fork不会立刻复制，当子进程要修改的时候才会分配进程空间 并复制。

#### 创建一个守护进程
java守护线程JVM的垃圾回收、内存管理等线程都是守护线程。
Main退出，前台线程执行完毕，后台线程也直接结束了。生命周期


终端：系统与用户交互的界面，运行进程的终端被称为 【控制终端】。
控制终端关闭时，进程都会关闭，除了守护进程。
1）`fork()`一个子进程并退出父进程。
子进程拷贝了父进程的
【会话期、进程组、控制终端、工作目录、父进程的权限掩码、打开的文件描述符】。

2）在子进程中创建会话`setid()`让进程摆脱1）原会话2）进程组3）控制终端 的控制。

3）工作目录换成根目录`chdir("/")`
4）文件权限掩码设置成0 `umask(0)`
5）关闭所有打开的文件描述符


#### 僵尸进程
子进程退出，父进程没有调用wait，子进程的进程描述符仍然在系统中。父进程应该调用wait取得子进程的终止状态。
如果父进程退出，僵尸进程变成孤儿进程给init（1）进程，init会周期性调用wait清除僵尸进程。


### 49 线程之间什么是共享的
1）地址空间2）全局变量3）打开文件4）子进程5）即将发生的定时器6）信号与信号处理程序6）账户信息
线程试图实现：共享同一组资源的多个线程的执行能力


### 50 栈为什么要线程独立
一个栈帧只有最下方的可以被读写，处于工作状态，为了实现多线程，必须绕开栈的限制。
每个线程创建一个新栈。多个栈用空白区域隔开，以备增长。
每个线程的栈有一帧，供各个被调用但是还没有从中返回的过程使用。
该栈帧存放了相应过程的局部变量、方法参数、过程调用完成后的返回地址，线程私有不共享。
例如X调用Y，Y调用Z， 执行Z时，X和Y和X使用的栈帧会全部保存在堆栈中。
**每个线程有一个各自不同的执行历史。**

栈内存分配运算内置于处理器的指令集中，效率很高

运行时在模块入口时，数据区需求是确定的。
栈是编译器可以管理创建和释放的内容，堆需要GC
栈很少有碎片

#### 静态全局变量、静态局部变量
https://blog.csdn.net/hushpe/article/details/45396059
**static的最主要功能是隐藏，其次因为static变量存放在静态存储区，所以它具备持久性和默认值0。**

1.全局变量：源程序作用域。
所有未加static前缀的全局变量和函数都具有全局可见性，其它的源文件也能访问`extern`

2.静态全局变量：文件作用域。
如果加了static，就会对其它源文件隐藏。不能用extern导出。
例如在a和msg的定义前加上static，main.c就看不到它们了。利用这一特性可以在不同的文件中定义同名函数和同名变量，而不必担心【命名冲突】。
全局变量、静态全局变量存储在静态数据区。只有程序刚开始运行时唯一一次初始化。

3.静态局部变量：static局部变量只被初始化一次，下一次依据上一次结果值。
！！！ 单例模式！！！

作用域：作用域（可见性）仍为局部作用域，当定义它的函数或者语句块结束的时候，作用域随之结束。
```cpp
class Singleton
{
private:
    Singleton(){}
    Singleton(const Singleton &s);
    Singleton & operator = (const Singleton &s);
public:
    static Singleton * GetInstance()
    {
        static Singleton instance;   //局部静态变量
        return &instance;
    }

};
```
  注：当static用来修饰局部变量的时候，它就改变了局部变量的存储位置，从原来的栈中存放改为静态存储区。但是局部静态变量在离开作用域之后，并没有被销毁，而是仍然驻留在内存当中，直到程序结束，只不过我们不能再对他进行访问。
局部变量改变为静态变量后是改变了它的存储方式即改变了它的【生存期】。
把全局变量改变为静态变量后是改变了它的【作用域】，限制了它的使用范围。  

4.static函数作用域只在本文件
从原来的栈中存放改为【静态存储区】。但是局部静态变量在离开作用域之后，并没有被销毁，而是仍然驻留在内存当中，直到程序结束，只不过我们不能再对他进行访问。

可在当前源文件以外使用的函数，应该在一个头文件中说明，要使用这些函数的源文件要包含这个头文件.


静态存储区：内存在程序编译的时候就已经分配好
已经初始化过的全局变量在.data段，而未初始化的全局变量在.bss段。
.bss段不占用可执行文件的大小，而是在加载程序的时候由操作系统自动分配并初始化为0

#### 目标文件
用于二进制文件、可执行文件、目标代码、共享库和核心转储 的标准文件格式。
分为3种：
1）可重定位的目标文件 .o文件 .a静态库文件 未链接 可以经过链接生成可执行的目标文件和可被共享的目标文件。
没有程序进入点。
2）可执行的目标文件 链接处理之后的
3）可【共享】的目标文件 .so。 动态库文件。

#### java static
static方法不能被覆盖override：因为方法覆盖是运行时动态绑定的，static是编译时静态绑定的。

### Hashtable 和 HashMap的区别
Hashtable不允许键或者值是null

### ArrayList
每次扩容1.5倍
`int newCapacity = oldCapacity + (oldCapacity >> 1); `

### LinkedList
LinkedList比ArrayList更占内存，因为LinkedList为每一个节点存储了两个引用.

### Comparable和Comparator接口 区别
Comparable 是该类支持排序 实例具有内在的排序关系 不能跨越不同类型的对象比较
Comparator 是外部比较器，需要一个非标准的排序关系。有多个域，按不同的域排序。加了很多default方法。

### Enumeration接口和Iterator接口 的区别
Enumeration快
Iterator允许调用者删除底层集合里面的元素

### finalize 方法
JNI(Java Native Interface)调用non-Java程序（C或C++），finalize()的工作就是回收这部分的内存。

任何对象的finalize只会被调用一次

### final finally finalize的区别

### Exception和Error的区别

### 事务是什么
一个类里面有两个方法A和B，方法A有@Transaction，B没有，但B调用了A，外界调用B会不会触发事务？

### 51ThreadPoolExecutor 怎么实现的
1）线程池状态

ExecutorService 源码

### 52 Java多继承
https://juejin.im/post/5a903ef96fb9a063435ef0c8#heading-1
内部类:每个内部类都能独立地继承自一个（接口的）实现，内部类允许继承多个非接口类型.

socket编程

mq有几种模式
Binding:Exchange和Queue的虚拟连接

#### 接口和抽象类的区别
抽象类里面能不能有非抽象方法 能不能被重写

#### String不能被继承

重写和重载的区别

### 53 sb依赖注入控制反转。
IOC:控制反转
控制：Java Bean的生命周期（创建、销毁）
反转：容器管理依赖关系。
IOC是一种设计模式。将对象-对象关系解耦和对象-IOC容器-对象关系。容器管理依赖关系。依赖对象的获得被反转了。

IOC的实现方式：带参构造函数，setter，auto

依赖注入DI方式:把底层类作为参数传递给上层类，实现上层对下层的“控制”。
setter、接口、构造函数。
组件之间依赖关系由容器在运行期决定。
SpringBoot Autowired是自动注入，自动从spring的上下文找到合适的bean来注入


IOC容器初始化
1）Resource定位
2）载入：把定义的Bean表示成IOC的数据结构（不包括Bean依赖注入）
3）注册到容器的HashMap中

IOC容器通过和注解配置(`Controller`)
1）IOC容器就是`ApplicationContext` 可以通过web.xml或者加载xml或者文件用`application-context.xml`初始化。
2）定义bean 然后`getBean()`就获取了对象可以调用方法了
bean的作用域6种 默认是单例，多次`getBean`是同一个。`prototype`每次都是新的。
bean有创建和销毁的回调函数。
3）如果要用两个类的组合，一个类里需要`new`另一个类，这样那个类的构造参数都需要在这个类里面改，这样强耦合。所以这个外部对象应该用构造函数（强依赖）/setter（可选依赖（可配置的（颜色）））等方法注入。
    通过配置文件的方法，注入依赖的参数。


### Springboot的启动流程

### tomcat的启动流程

#### Spring 怎么解决循环引用
Spring容器整个生命周期内，有且只有一个对象，所以很容易想到这个对象应该存在Cache中，Spring为了解决单例的循环依赖问题，使用了三级缓存。
```java
/** Cache of singleton objects: bean name --> bean instance */
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<String, Object>(256);

/** Cache of singleton factories: bean name --> ObjectFactory */
private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<String, ObjectFactory<?>>(16);

/** Cache of early singleton objects: bean name --> bean instance */
private final Map<String, Object> earlySingletonObjects = new HashMap<String, Object>(16);
```
singletonFactories ： 单例对象工厂的cache 
earlySingletonObjects ：提前暴光的单例对象的Cache 
singletonObjects：单例对象的cache

#### AOP 面向切面编程 关注点分离，抽离业务逻辑


知识图谱 之间的关系 和结构存储neo4j
vue的特点
和react的比较

### 54 前后端跨域怎么实现
浏览器的同源策略导致了跨域。
1)JSONP 但是只能直接发get请求`<script src="http://127.0.0.1:8897"><script>`
2)`Access-Control-Allow-Origin':'*'`
3)nginx反向代理

XSS 跨站脚本攻击：篡改网页，注入恶意html脚本。
CSRF 跨站请求伪造（利用用户登陆态）
Cookie的 `SameSite`属性strict

###  55 cookies
1) 存储在客户主机
2）服务器产生
3）会威胁客户隐私
4）用于跟踪用户访问和状态

#### cookie有两种
会话cookie和持久cookie，设置了Discard或者没设置Expires或Max-Age就是会话cookie

服务器创建Session ID，cookie的值就是Session ID。 

cookie的实现
cookie加密

原本需要由web服务器创建会话的过程转交给Spring-Session进行创建，本来创建的会话保存在Web服务器内存中，通过Spring-Session创建的会话信息可以保存第三方的服务中，如：redis,mysql等

redis string
redis

### redis常用数据结构
string, hash,set,sorted set,list
```sh
redis> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
redis> GEODIST Sicily Palermo Catania
"166274.1516"
redis> GEORADIUS Sicily 15 37 100 km
1) "Catania"
redis> GEORADIUS Sicily 15 37 200 km
1) "Palermo"
2) "Catania"
redis> 
```

#### redis 有序集合
skiplist和dict会共享元素的成员和分值。
zset中的dict创建了一个从成员到分值的映射，程序可用O(1)的时间查找到【分值】(zscore)。
跳跃表实现zrank,zrange 还有查找全是logN



### 如果一个千万条数据的表怎么优化
数据库分片：
1）分片ID
2）无需分片的表

### 61 linux 
- 如何传文件 scp

- 如何查进程 
ps -ef |grep
如何在文件找查一个字符串
`grep 'abc' abc.txt`
`grep 'abc' abc*` 从abc开头的文件查找
参数`-o`只输出正则匹配的部分
参数`-v`输出不含正则的内容

遍历文件夹查找所有文件中的一个字符串的所有行
`grep -r "要查找的内容" ./`

文件夹大小：
`du -sh .`

如果grep不带文件就等输入

echo不支持标准输入

- 如何查找一个文件  find默认是递归查找的
`find ~ -name "abc.java`

sed 替换
awk 切片统计

终端 `/dev/tty`当前终端

vi： ZZ：命令模式下保存当前文件所做的修改后退出vi；

怎么调整top多久刷新，top间隔默认是多少


### netstat
列出所有tcp端口 `netstat -at`
显示pid和进程名`netstat -p`
可以查看所有套接字的连接情况

### top 可以查看到哪些指标
1： CPU 平均负载1min，5min,15min
在一段时间内CPU正在处理以及等待CPU处理的 【进程数】 之和。CPU使用队列的长度的统计信息。
2：进程、cpu状态、内存状态（系统内核控制的内存数）

打开的文件`lsof`

### String StringBuilder StringBuffer 
String 存在JVM哪里
1）一旦有一个用引号的字符串就会放到字符串常量池。
2）拼接创建的只在堆里。
3）堆里面创建新的字符串，用intern可以放【引用】到常量池（jdk1.7之前只只能放一个副本放到常量池）
方法区，方法区是JVM的一种规范。元空间MetaSpace和永久代PermGen都是方法区的实现。
原来在永久代里的字符串常量池移到了堆中。而且元空间替代了永久代。
本来永久代使用的是JVM内存，而元空间使用的是本地内存，字符串常量不会有性能问题（intern）和内存溢出。


### 序列化的性能



### 短链接

### 特征模型


### 归并排序



### 多线程归并排序

### 线程上下文类加载器
JNDI服务，使用线程上下文加载器，父类加载器请求子类加载器完成类加载。

OSGi自定义加载器，程序模块和它的类加载器一起替换掉。

### 运行时字节码生成 动态代理
动态代理：原始类和接口还未知的时候就确定了代理类的代理行为。
代理类与原始类脱离直接联系后，可以用于不同的应用场景。

jvm以byte数组为单位拼接出 传入接口的每个方法的实现，并且调用外部传入this的invoke方法，的字节码文件。

### RCU机制
http://blog.jobbole.com/107958/

### 分布式锁
1）互斥性：保证不同节点的线程之间互斥2）同一个节点同一个线程可重入3）支持超时防死锁
`for update`悲观锁 大并发不建议
数据库是各个服务进程的临界资源。如果已经下订单了还没减库存，但是没加锁就会脏读。

乐观锁：因为查询加行锁开销比较大，用版本号，查询出版本号之后update或者delete的时候需要判断当前的版本号和刚才读的是否一致，这样就不用`for update`

ZooKeeper是以Paxos算法为基础分布式应用程序协调服务。
锁过期强依赖于时间，但是ZK不需要依赖时间，依赖每个节点的Session。

#### redis分布式锁
流程1）`setnx(key,currenttime+timeout)`2)`expire(key)`3)业务执行完后`del(key)`
其他tomcat获取不到锁返回0流程
1）`get(key)`判断当前时间和value的时间，
2)如果key超时了可以先get再set`getset(key,currenttime+timeout)` 如果get的值是null或者和之前的锁一样（？）继续`expire(key)`走加锁流程...

### 分布式文件系统HDFS
1）每个文件拆分成很多小块128M（并行处理和负载均衡）.
2）文件以多副本存储（副本因子），高可用。
3）有一个节点存储着存储信息 1个Master，NameNode。N个Slave DataNode。

NameNode：1）处理客户端请求 文件系统的读写操作 2）元素据
DataNode：1）块的存储和操作 2）定期心跳

分布式文件系统一致性
HDFS 文件只能写1次 除了 append和truncate 而且不能多并发写。

节点失效
为什么本地文件系统不使用hash


### 2.25匹马，5个跑道，每个跑道最多能有1匹马进行比赛，最少比多少次能比出前3名？前5名？
5轮找出各组第一；5组第一跑一次，得出第一，只有前3的组可能是前3；最后一次A2, A3, B1, B2, C1参赛得出第二第三名。

### 13.100亿个整数，内存足够，如何找到中位数？内存不足，如何找到中位数？

### 分布式
1）均衡负载技术
均衡负载的算法有：随机 round roubin 一致性hash
2）容灾设计
3）高可用系统


#### rpc通信
jsonrpc没法区分int和long

#### 通信开销
加密和压缩




### JMM 内存模型
线程工作内存，保存主内存副本拷贝。线程对变量的所有读取、赋值都必须在工作内存完成，不能直接读写主内存变量。
处理并发过程中的原子性、可见性、有序性。

volatile变量定义了8种操作顺序的规则，能保证代码执行的顺序与程序顺序相同。保证long和double不被拆分。
定义了8个happen before原则
1）单线程控制流程序次序 2）管程 3）volatile 4）线程启动、5终止、6中断 7）对象finalize 8）传递性

#### 为什么要padding 
cache伪共享：多个线程读写同一个缓存行，volitale变量无关但是多个线程之间仍然要同步。
把热点数据隔离在不同的缓存行

#### 8个原子操作
主内存变量线程独占：
1）lock 线程独占，
同个线程可以lock多次，会清空工作内存中这个变量的值执行引擎use前要load assign
2）unlock 释放，之前会同步回主存

主内存->工作内存：
3）read 从主内存读入工作内存
4）load 将read的变量存入工作内存的变量副本

工作变量和执行引擎：
5）use 工作内存变量传递给执行引擎
6）assign 执行引擎赋值给工作变量

工作内存->主内存
7）store 工作内存传入主内存
8）write 将store的值放入主内存

### 快速失败fail-fast 和 安全失败 fail-safe
快速失败：迭代器遍历过程中，集合对象修改会改modCount，和expected不一样，报错。java.util包下的集合类都是 快速失败的。

安全失败：遍历是先拷贝在遍历。遍历过程中的修改不会影响迭代器，不会报错。java.util.concurrent包下都是安全失败。

---
## 秒杀项目相关
https://mp.weixin.qq.com/s/ktq2UOvi5qI1FymWIgp8jw
秒杀项目的请求流程
需求：秒杀地址隐藏，记录订单，减库存

### 1.下订单和减库存如何保持一致？
ACID强一致性，利用关系型数据库的强一致性，【订单表和库存表】放在一个关系型数据库事务，实时一致性。
高并发场景提高关系型数据库吞吐量和存储，应该吧库存和订单放入同一个数据库分片。
主从复制只能提高数据库读。
BASE思想：分布式事务拆分，每个步骤都记录状态，使用【写前日志】或者数据库来记住任务的执行状态，一般通过行级锁实现比写前日志更快。

###  2.缓存与数据库一致性
读请求和写请求串行化，串到一个内存队列里去。串行化就不会不一致。
先更新数据库再删除缓存。

![cacheone.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/cacheone.jpg)

缓存更新的时候加锁 防止大量请求直接访问数据库雪崩或者缓存不一致
![cacheupdate.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/cacheupdate.jpg)

### 3.更新数据库的同时为什么不是马上更新缓存而是删除缓存
更新数据库后更新缓存可能会因为多线程下导致写入脏数据（比如线程A先更新数据库成功，接下来要取更新缓存，接着线程B更新数据库，但B又更新了缓存，接着B的时间片用完了，线程A更新了缓存）  （？）

### 4.缓存穿透：数据库中没这个数据，缓存中也没有，数据库被大量查询
有很多种方法可以有效地解决缓存穿透问题，最常见的则是采用布隆过滤器，将所有可能存在的数据哈希到一个足够大的bitmap中，一个一定不存在的数据会被这个bitmap拦截掉，从而避免了对底层存储系统的查询压力。

哈希表槽位数（大小）的改变平均只需要对 K/n个关键字重新映射，其中K是关键字的数量， n是槽位数量。

1）查询结果为空的也缓存(命中不高 但是频繁更新的数据) 
2）对可能为空的key统一存放（命中不高 更新不频繁）

### 5.数据库乐观锁减库存
先查库存，在减库存的时候判断当前库存是否与读到的库存一样
乐观锁适用于读多写少，但是大并发写（？）

### 6.读写锁能不能用在大并发场景
1）读锁与写锁互相阻塞，读取/更新比较费时，出现更新或者读取线程被阻塞。
2）Copy on write ， 读请求读取旧值，更新完后原子替换掉，并且用引用计数，读取前+1，读完-1，直到没人在用酒对象再删除。问题是，获取对象和计数不是原子的，所以获取，计数+1应该用锁封装成一个原子操作。替换、计数-1也应该是原子操作。
3）无锁计数器

### 7.为什么要把页面放到redis中？
页面缓存，将整个页面手动渲染，加上所有vo，设定有效期1分钟，让用户1看到的是1分钟前的页面
详情页应该不能放（？）库存更新怎么办（？）
只是把页面商品信息放到了redis中

### 8.秒杀地址 + 接口限流
如果有很多手机账号，公不公平？
按收货地址（？）

### 9.如果订单表和库存表不在同一个数据库
除了分布式锁更轻量级的做法？消息队列-异步处理

### 10.为什么秒杀系统需要mq 秒杀排队系统
多redis扣库存
一旦缓存丢失需要考虑恢复方案。比如抽奖系统扣奖品库存的时候，初始库存=总的库存数-已经发放的奖励数，但是如果是异步发奖，需要等到MQ消息消费完了才能重启redis初始化库存，否则也存在库存不一致的问题。
需要一个分布式锁来控制只能有一个服务去初始化库存

### 11.为什么秒杀系统需要mq 秒杀排队系统
https://www.infoq.cn/article/yhd-11-11-queuing-system-design
1）削峰:减少瞬间流量。处理失败的消息退回队列，接收的下一条还是这个消息，这是因为消息传递不仅要保证一次且仅一次，还要保证顺序。
2）限流保证数据库不会挂掉，不然会影响其他服务。主要还是为了减少数据库访问 透这么多请求来数据库没有意义,会有大量锁冲突导致读请求会发生大量的超时。如果均成功再放下一批.
3）持久化:就算库存系统出现故障,消息队列也能保证消息的可靠投递,不会导致消息丢失。
4）订单和库存解耦. 
```
#从队列里每次取几个
spring.rabbitmq.listener.simple.prefetch= 1
# 消费失败会重新压入队列
spring.rabbitmq.listener.simple.default-requeue-rejected= true
```

异步下单：
异步下单的前提是确保进入队列的购买请求一定能处理成功。Redis天然是单线程的，其INCR/DECR操作可以保证线程安全。而且入队之前要对用户user+goodsId判重。
假设处理一个秒杀订单需要1s，而将秒杀请求（或意向订单/预订单）加入队列（或消息系统等）可能只需要1ms。异步化将用户请求和业务处理解耦

其他消息中间件

如何用redis list实现mq

### 12.消息中间件的作用
1）解耦 基于数据的接口层
2）冗余（持久化）
3）扩展性 解耦了 处理过程
4）削峰
5）降低进程耦合度
6）顺序消费
7）缓冲
8）异步通信


### 13.mq集群模式
Master-Slave模式
NetWork模式 两组Master-Slave模式

### 14.mq怎么实现的
https://tech.meituan.com/2016/07/01/mq-design.html
AMQP协议: 虚拟主机（virtual host），交换机（exchange），队列（queue）和绑定（binding）。一个虚拟主机持有一组交换机、队列和绑定.
broker(消息队列服务端)
1）数据流：例如producer发送给broker,broker发送给consumer,consumer回复消费确认，broker删除/备份消息等。 
2）RPC:两次RPC发送者把消息投递到服务端（broker），服务端再将消息转发一手到接收端，消费端最终做消费确认的情况是三次RPC。然后考虑RPC的高可用性，尽量做到无状态，方便水平扩展。 
3）消息堆积:存储消息，在合适的时机投递消息。
4）广播：我维护消费关系，可以利用zk/config server等保存消费关系。

生产者和消费者是完全解耦.
？因为保证可靠消费？这样redis预减的库存就真的减少到mysql里了？不用再同步回来（？
持久化？
消息队列时需要考虑到的问题，如RPC、高可用、顺序和重复消息、可靠投递、消费关系解析等
直接模式

### 15. mq的持久化