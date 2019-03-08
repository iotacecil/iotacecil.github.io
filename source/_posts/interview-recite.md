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

### 1.泛型的好处
泛型：向不同对象发送同一个消息，不同的对象在接收到时会产生不同的行为（即方法）；也就是说，每个对象可以用自己的方式去响应共同的消息。消息就是调用函数，不同的行为是指不同的实现（执行不同的函数）。
用同一个调用形式，既能调用派生类又能调用基类的同名函数。

方法的重载和重写都是实现多态的方式，区别在于前者实现的是编译时的多态性，而后者实现的是运行时的多态性。

- 为什么不能根据返回类型来区分重载?
因为调用时不能指定类型信息，编译器不知道你要调用哪个函数。

虚函数是实现多态 "动态编联”的基础，C++中如果用基类的指针来析构子类对象，基类的析构要加`virtual`，不然不会调用子类的析构，会内存泄漏。

### 2.数据库索引INNDB的好处
事务，主键索引，外键
自增长列必须是主键，索引的第一个列，而且因为不是表锁要考虑并发增长。
innodb其实不是根据每个记录产生行锁的，根据页加锁，而且用位图。

意向锁。锁定对象分为几个层次，支持行锁、表锁同时存在。

一致性非锁定读：读快照 多版本并发控制：read committed是最新快照，重复读是事务开始时的快照。通过undo完成的。

redo 保证事务的一致性、持久性。undo 保证事务的一致性（回滚）和MVCC多版本并发控制。

行锁会用gap锁锁住一个区间，阻止多个事务插入到同一范围内。是为了解决幻读问题。
一个事务select * from t where a>2 for update;对[2+)加锁，另一个事务插入5失败。

不走索引表锁。

myisam 缓冲池之缓存索引文件，不缓存数据。 索引和数据分文件。

### 脏读
脏页是最终一致性的，数据库实例内存和磁盘异步造成的。脏（数据）读违反了隔离性。

### XA事务 分布式事务
事务管理器（Mysql客户端）和资源管理器（Mysql数据库）之间用两阶段提交，等所有参与全局事务的都能提交再提交
用JAVA JTA API

### 2.mysql日志文件（不是引擎）
binlog(逻辑日志，是sql）用于主从复制、慢查询、查询、错误
重做日志缓存，按一定频率写到重做日志文件 是innodb的。

因为只有一个主键并且建了B+树，所以其他辅助索引的插入是离散的，所以，有insert buffer

### 3.CAS算法原理？优缺点？
CAS 是实现非阻塞同步的计算机指令，它有三个操作数，内存位置，旧的预期值，新值，

AQS利用CAS原子操作维护自身的状态，结合LockSupport对线程进行阻塞和唤醒从而实现更为灵活的同步操作。

当线程尝试更改AQS状态操作获得失败时，会将Thread对象抽象成Node对象 形成CLH队列，LIFO规则。

### 4.为什么是三次握手
信道不可靠, 但是通信双发需要就某个问题达成一致. 而要解决这个问题, 三次通信是理论上的最小值。

1）初始化序号 （来解决网络包乱序（reordering）问题），互相通知自己的序号。

2）为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误。
如果A发送2个建立链接给B，第一个没丢只是滞留了，如果不第三次握手只要B同意连接就建立了。
如果B以为连接已经建立了，就一直等A。所以需要A再确认。

首次握手隐患：服务器收到ACK 发送SYN-ACK之后没有回执，会重发SYN-ACK。产生SYN flood。
用`tcp_syncookies` 参数

### 5.为什么四次分手
1)由于TCP连接是全双工的，因此每个方向都必须单独进行关闭。
    当一方完成它的数据发送任务后就能发送一个FIN来终止这个方向的连接。
    收到一个 FIN只意味着这一方向上没有数据流动，一个TCP连接在收到一个FIN后仍能发送数据。首先进行关闭的一方将执行主动关闭，而另一方执行被动关闭。


#### 为什么要TIME_WAIT等2MSL  最长报文段寿命
1）等最后一个ACK到达。如果没收到ACK，则被动方重发FIN，再ACK正好是两个MSL。
主动关闭方发送的最后一个 ack(fin) ，有可能丢失，这时被动方会重新发fin, 如果这时主动方处于 CLOSED 状态 ，就会响应 rst 而不是 ack。所以主动方要处于 TIME_WAIT 状态，而不能是 CLOSED 。
【rst】是一种关闭连接的方式。
2)让本连接持续时间内所有的报文都从网络中消失，下个连接中不会出现旧的请求报文。

#### TIME_WAIT 和 CLOSE_WAIT
1）发送FIN变成FIN_WAIT1，然后收到对方ACK+FIN，发完ACK
2）FIN_WAIT1 收到ACK之后到FIN_WAIT2，然后收到FIN，发送ACK
这个状态等2MSL后就CLOSED
作用：让本连接持续时间内所有的报文都从网络中消失，下个连接中不会出现旧的请求报文。

HTTP长连接主动关闭的是server，TIME_WAIT可以修改参数解决。
`net.ipv4.tcp_tw_recycle = 1`可以快速回收TIME-WAIT

CLOSE_WAIT 被动关闭后没有释放连接，一般是代码写的有问题。

TCP连接状态书上一共11种

#### 和UDP区别
1）无连接 不可靠 无序
2）广播
3）速度快 报头只有8字节


### 6.数据库最左匹配原理

### 7.http https
![httphttps.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/httphttps.jpg)
http 有9种方法
![https2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/https2.jpg)

RSA:
两种方式：
1）全密文：用对方公钥加密，对方用私钥解密 
2）明文+印章（防抵赖）：用自己私钥签名，对方用公钥验签
使用AOP实现

### 8.进程间通信
套接字，管道，命名管道、邮件槽、远程过程调用、消息队列，共享内存，信号量,信号。

信号：异步的通知机制，用来提醒进程一个事件已经发生

信号是在软件层次上对中断机制的一种模拟。    

`trap -l`
`trap "" INT` 表明忽略SIGINT信号，按Ctrl+C也不能使脚本退出

https://github.com/xuelangZF/CS_Offer/blob/master/Linux_OS/IPC.md

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

#### 消息队列 msgget（同一台机器） 系统内核（链表）： （一种逐渐被淘汰的方式）
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

#### 信号量`semget` 有权限
不是线程同步的posix信号量，是`SYSTEM V`信号量
信号量能解决 共享内存同步问题


### 9.线程池的运行流程，使用参数以及方法策略

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
5）`newWrokStealingPoll` 工作窃取

### 10.线程同步的方法
互斥量(mutex) 
条件变量(conditon) 允许线程阻塞和等待另一个线程发送信号
 读写锁 信号量
synchronized  ReenreantLock
volatile
ThreadLocal
LinkedBlockingQueue
atomic

### 11.C++虚函数作用及底层实现
虚函数是使用虚函数表和虚函数表指针实现的。
虚函数表：一个类 的 虚函数 的 地址表：用于索引类本身及其父类的虚函数地址，如果子类重写，则会替换成子类虚函数地址。
虚函数表指针： 存在于每个对象中，指向对象所在类的虚函数表的地址。
多继承：存在多个虚函数表指针。

### 2.25匹马，5个跑道，每个跑道最多能有1匹马进行比赛，最少比多少次能比出前3名？前5名？
5轮找出各组第一；5组第一跑一次，得出第一，只有前3的组可能是前3；最后一次A2, A3, B1, B2, C1参赛得出第二第三名。

### 13.100亿个整数，内存足够，如何找到中位数？内存不足，如何找到中位数？

### 14 单例模式
实现：私有静态指针变量指向类的唯一实例，并用一个公有静态方法获取该实例。
目的：保证整个应用程序的生命周期中的任何一个时刻，单例类的实例都只存在一个。

### 15.基于比较的算法的最优时间复杂度是O(nlog(n))
因为n个数字全排列是n! 一次比较之后，两个元素顺序确定，排列数为 n!/2!
总的复杂度是O(log(n!)) 根据斯特林公式就等于O(nlog(n))

### 16 快速排序
基本：
最普通的，每次取[0]作子集划分s1+[0]+s2,再递归两个子集。
最坏情况123456 O(n^2)
```java
private void qS(int[] arr,int left,int right){
        if(left>=right)return;
        int pivot = arr[right];
        // 因为保证i最后在左集合右边 用++i 
        // 所以初始化的时候边界都向外扩一格
        int i = left-1;int j = right;
        while (true){
            while (++i<=right && arr[i] < pivot);
            while (--j>=left && arr[j] > pivot);
            // 关键
            if(i < j){
                swap(arr,i , j);
            }
            else break;
        }
        // 把主元放到左集合右边
        swap(arr, i, right);
        qS(arr, left, i-1);
        qS(arr, i+1,right);
    }
```

注意1：
主元：1取头、中、尾的中位数比随机函数便宜。
用ifelse判断这三个数，1)把最小的放到左边2)把最大的放到右边3)把中间的数替换到最后位置上
`pivot = nums[n-1]`

然后用pivot划分子集，i从左开始，j从右开始,i最后停在j右边，交换`[i],[n-1]`，pivot放了正确的位置。

注意2：
如果有重复元素 如果11111，
1）重复元素也交换，最后pivot也会被换到中间，很等分nlogn。
2）不交换，i直接比较到最后，pivot还是在最后，变成n^2

注意3：
小规模数据集（N不到100可能还不如插入排序）
当递归的长度够小直接插入排序。

JDK `Arrays.sort()`中的根据阈值从merge，quick，insert，count sort中选一个
{% fold %}
```java
/**如果数组长度小于 this, Quicksort 优先于 merge sort.*/
private static final int QUICKSORT_THRESHOLD = 286;

/**如果数组长度小于 this , insertion sort 优先于 Quicksort.*/
private static final int INSERTION_SORT_THRESHOLD = 47;

/**如果Byte数组长度大于this, counting sort 优先于 insertion sort. */
private static final int COUNTING_SORT_THRESHOLD_FOR_BYTE = 29;

/** 如果short or char 数组长度大于 this, counting sort 优先于 Quicksort.*/
private static final int COUNTING_SORT_THRESHOLD_FOR_SHORT_OR_CHAR = 3200;

```
{% endfold %}

### 17 堆排序 不需要额外空间
堆（数组实现的完全二叉树）
左孩子是`(1+i<<1)` // 1+i<<2 奇数
右孩子是`(i+1)<<1` //偶数
父节点是`(i-1)>>1`

堆排序：
线性复杂度将数组调成最大堆O(n)，将堆顶和数组最后交换，堆规模-1，再调成最大堆。

```java
void heapSort(int[] arr){
    int s = arr.length;
    while (s>0) {
        s--;
        //swap(0,n-1)
        int rst = arr[0];
        int last = arr[s];
        arr[s] = rst;
        if (s != 0) {
            shifDown(arr, 0, last,s);
        }
    }
}
```

建堆方法1：
从上到下，每个新加的结点放在最右下，然后shiftUp每个 复杂度O(nlogn) (都可以做全排序了)
正确方法：
思路：
每个叶节点都成一个子堆，下滤操作能完成两个子堆的合并。

```java
private int poll(int[] arr){
    int s = arr.length - 1;
    int rst = arr[0];
    int last = arr[s];
    arr[s] = rst;
    if(s!=0){
        shifDown(arr, 0,last,arr.length);
    }
    return rst;
}
//down不会超过树的高度 所以O(logn)
private void shifDown(int[] arr,int i,int x,int len){
    int s = len;
    int half = s >>>1;
    while (i < half){
        int child = 1 + (i<<1);
        int el = arr[child];
        int rc = child+1;
        if(rc < s && arr[child] < arr[rc]){
            el = arr[rc];
            child = rc;
        }
        // 大顶堆，如果比叶子都大，下面已经是有序堆了，就完成了
        if(x >= el){
            break;
        }
        arr[i] = el;
        i = child;
    }
    arr[i] = x;
}
// log(n)
private void shifUp(int[] arr,int i,int x){
    while (i>0){
        int parent = (i-1)>>>1;
        int e = arr[parent];
        if(e >= x)break;
        // 下移父节点
        arr[i] = e;
        i = parent;
    }
    arr[i] = x;
}
void heapify(int[] arr){
    for (int i = (arr.length >>> 1) - 1; i >= 0; i--)
        shifDown(arr,i, arr[i],arr.length);
}
```

复杂度：
复杂度每个节点只需要比较的长度最多是这个节点到叶子的高度（而不是在树中的深度）。O(N)的
因为二叉树越底层节点越多。深度越高节点越多，所以上滤复杂度高。

从右下开始依次下滤，所有叶子节点都不用下滤。
如果全堆大小为n，内部节点最后一个的idx是`(n/2)-1`
例子：一共9个节点 各层1，2，4，2个。最后一个内部节点是3，它的右边和下面都是叶子。

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
第二范式：每个属性要完全依赖于主键
第三范式：非主键关键字段之间不能存在依赖关系，避免更新、插入、删除异常。每一列都要与主键直接相关。【消除传递依赖】。各种信息只在一个地方存储，不出现在多张表中
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
1）互斥条件2）不可剥夺条件3）请求和保持条件4）循环等待条件

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

### 32 递归冒泡排序
```java
public void bubblesort(int[] array,int n) {
    if (n == 1)
        return;
    if (array == null || array.length == 0)
        return;
    for (int i = 0; i < n - 1; i++) {
        if (array[i] > array[i + 1]) {
            swap(array,i,i+1);
        }
    }
    bubblesort(array, n - 1);
}
```
### 33 ajax的四个步骤
1)创建xhr对象
2)open方法参数：method，url，同步或异步
3)send
4)注册一个监听器`onreadystatechange` readyState=4和status200 获得响应`.responseText`

### 34 XSS攻击，跨站脚本攻击
网站没有对用户提交数据进行转义处理或者过滤不足的缺点，进而添加一些恶意的脚本代码（HTML、JavaScript）到Web页面中去，使别的用户访问都会执行相应的嵌入代码。
解决方法：
1）cookie设置成http Only 不让前端`document.cookie`拿到
2）对输入多做一些检查

### 35 防止表单重复提交
1）submit方法最后把按钮disable掉
2）用token
3）重定向

### 36 重定向的响应头为302，并且必须要有Location响应头；
服务器通过response响应，重定向的url放在response的什么地方？
后端在header里的设置的Location url
重定向可以用于均衡负载

### 37 二分
2.[0,len) 保持len取不到 
[0]:l=0,r=1,l++,while(l==r)的时候应该结束
好处：len就是长度[a,a+len)，[a,b)+[b,c)=[a,c),[a,a)是空的
```java
int l = 0,r = n;
while(l<r){
    int mid = l+(r-l)/2;
    if(arr[mid]==target)return mid;
    if(arr[mid]>target){
        //在左边，边界为取不到的数
        r=mid;//[l,mid)
    }else{
        //左闭又开
        l = mid+1;//[mid+1,r)
    }
}
//如果l==r [1,1)表示空的
return -1;
```

### 38 IO模型
阻塞IO：等待数据（收到一个完整的TCP包）和系统内核拷贝到用户内核都阻塞了。
非阻塞IO：内核数据没准备好直接返回错误，需要轮询。
多路复用IO模型：事件驱动IO。select阻塞轮询所有socket，可以同时处理多个连接，（连接数不高的话不一定比多线程阻塞IO好）优势不在于单个连接处理更快，在于能处理更多的连接。而且单线程执行，事件探测和事件响应在一起。
以上三个都属于同步IO，都会阻塞进程。
select/poll/epoll都需要等待读写时间就绪后读写，异步IO会把数据从内核拷贝到用户。
epoll是根据每个fd上面的callback函数实现的。而且有mmap内核空间和用户空间同处一块内存空间。
异步IO：立即返回，内核完成数据准备+拷贝数据之后发送给用户进程一个信号。

### 39异常 Error 和 Exception的区别
1）Error是JVM负责的
2）RuntimeException 是程序负责的
3）checked Exception 是编译器负责的
![ErrirException.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/ErrirException.jpg)

异常处理机制：
在堆上创建异常  try catch中有return之前都会先执行finally的return


### 40 线程安全的单例模式
懒加载
同步 double checked locking 
只希望在第一次创建 实例的时候进行同步
创建对象分为3个步骤：
1）分配内存
2）初始化对象
3）obj指向内存地址
关键：（2）、（3）会被重排序（因为理论上单线程不会有错，而且能提高性能），导致obj不未空，但还没初始化，所以volatile禁止重排序。
Volatile变量规则。对一个volatile修饰的变量，对他的写操作先行发生于读操作

```java
public class LazySingle(){
    private volatile static LazySingle obj = null;
    private LazySingle(){}
    public static getInstance(){
        if(obj == null){
            // 1.只有一个线程能进来
            synchronized(LazySingle.class){
                if(obj == null){
                    obj = new LazySingle();}}}
        return obj;
}}
```

方法2：静态内部类

java进程间通信


java 线程通信
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
    

### 42  2进制字符串转16进制
```java
 String b2h(String bins){
    int n = bins.length();
    String hexs = "0123456789abcdf";
    StringBuilder sb = new StringBuilder();
    //0101 n =4
    while (n>=4){
        int idx = (bins.charAt(n - 1) - '0') +
                ((bins.charAt(n - 2) - '0') * 2) +
                ((bins.charAt(n - 3) - '0') * 4) +
                ((bins.charAt(n - 4) - '0') * 8);
        System.out.println(n);
        sb.append(hexs.charAt(idx));
        n-=4;
    }
    int last = 0;int cnt = 0;
    while (n>0){
        last += (bins.charAt(n-- - 1) - '0')*(1<<(cnt++));
    }
    sb.append(hexs.charAt(last));
    return sb.reverse().toString();
}
```

### 43 十进制转2进制
没有oj过
```java
public String D2Bin(int de){
    StringBuilder sb = new StringBuilder();
    while (de != 0){
        sb.insert(0,de&1);
        de >>>= 1;
    }
    return sb.toString();
}
```

### 44 编辑距离
1）定义`dp[n][m]`表示从s1的前n个字符->s2的前m个字符最少的编辑距离。
2）加一个：[n-1][m]+1
   减一个: [n][m-1]+1
   变一个:[n-1][m-1] +1 
   相等：[n-1][m-1]
```java
public int minDistance(String word1, String word2) {
    int n = word1.length();
    int m = word2.length();
    int[][] dp = new int[n+1][m+1];
    for(int i =0;i<=n;i++){dp[i][0] = i;}
    for(int i =0;i<=m;i++){dp[0][i] = i;}
    for(int i =1;i<=n;i++){
        for(int j = 1;j<=m;j++){
            if(word1.charAt(i-1) == word2.charAt(j-1)){
                dp[i][j] = dp[i-1][j-1];          
            }else {
                dp[i][j] = Math.min(Math.min(dp[i-1][j]+1,dp[i][j-1]+1),dp[i-1][j-1]+1);
            }
        }
    }
    return dp[n][m];
}
```

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
子进程对数据段和堆、栈段的修改不会影响父进程。
“写时复制”：现在fork不会立刻复制，当子进程要修改的时候才会分配进程空间 并复制。

#### 创建一个守护进程
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
子进程推出，父进程没有调用wait，子进程的进程描述符仍然在系统中。父进程应该调用wait取得子进程的终止状态。
如果父进程退出，僵尸进程变成孤儿进程给init（1）进程，init会周期性调用wait清除僵尸进程。


### 49 线程之间什么是共享的
1）地址空间2）全局变量3）打开文件4）子进程5）即将发生的定时器6）信号与信号处理程序6）账户信息
线程试图实现：共享同一组资源的多个线程的执行能力


### 50 栈为什么要线程独立
一个栈帧只有最下方的可以被读写，处于工作状态，为了实现多线程，必须绕开栈的限制。每个线程创建一个新栈。多个栈用空白区域隔开，以备增长。
每个线程的栈有一帧，供各个被调用但是还没有从中返回的过程使用。
该栈帧存放了相应过程的局部变量、过程调用完成后的返回地址。
例如X调用Y，Y调用Z， 执行Z时，X和Y和X使用的栈帧会全部保存在堆栈中。
每个线程有一个各自不同的执行历史。

运行时在模块入口时，数据区需求是确定的。
栈是编译器可以管理创建和释放的内容，堆需要GC
栈很少有碎片

### 51ThreadPoolExecutor 怎么实现的
1）线程池状态

### 52 Java多继承
内部类:每个内部类都能独立地继承自一个（接口的）实现，内部类允许继承多个非接口类型.

socket编程

mq有几种模式
Binding:Exchange和Queue的虚拟连接


### 40 sb依赖注入控制反转。
IOC是一种设计模式。将对象-对象关系解耦和对象-IOC容器-对象关系。容器管理依赖关系。依赖对象的获得被反转了。

依赖注入DI方式:把底层类作为参数传递给上层类，实现上层对下层的“控制”。setter、接口、构造函数。组件之间依赖关系由容器在运行期决定。
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


知识图谱 之间的关系 和结构存储neo4j
vue的特点
和react的比较

### 38 前后端跨域怎么实现
浏览器的同源策略导致了跨域。
1)JSONP 但是只能直接发get请求`<script src="http://127.0.0.1:8897"><script>`
2)`Access-Control-Allow-Origin':'*'`
3)nginx反向代理

XSS 跨站脚本攻击：篡改网页，注入恶意html脚本。
CSRF 跨站请求伪造（利用用户登陆态）
Cookie的 `SameSite`属性strict

### cookies
1) 存储在客户主机
2）服务器产生
3）会威胁客户隐私
4）用于跟踪用户访问和状态

redis string
redis
### 为什么要把页面放到redis中？
页面缓存，将整个页面手动渲染，加上所有vo，设定有效期1分钟，让用户1看到的是1分钟前的页面
详情页应该不能放（？）库存更新怎么办（？）
只是把页面商品信息放到了redis中
redis常用数据结构
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

秒杀项目的请求流程

### 缓存与数据库一致性
读请求和写请求串行化，串到一个内存队列里去。串行化就不会不一致。
先更新数据库再删除缓存。

### 为什么秒杀系统需要mq 秒杀排队系统
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

### mq集群模式
Master-Slave模式
NetWork模式 两组Master-Slave模式

### mq怎么实现的
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

linux 
如何传文件 scp
如何查进程 
ps -ef |grep
如何在文件找查一个字符串
`grep 'abc' abc.txt`
`grep 'abc' abc*` 从abc开头的文件查找
参数`-o`只输出正则匹配的部分
参数`-v`输出不含正则的内容

如果grep不带文件就等输入

echo不支持标准输入

如何查找一个文件  find默认是递归查找的
`find ~ -name "abc.java`

sed 替换
awk 切片统计

终端 `/dev/tty`当前终端

列出所有tcp端口 `netstat -at`
显示pid和进程名`netstat -p`

打开的文件`lsof`

String StringBuilder StringBuffer 
String 存在JVM哪里
1）一旦有一个用引号的字符串就会放到字符串常量池。
2）拼接创建的只在堆里。
3）堆里面创建新的字符串，用intern可以放【引用】到常量池（jdk1.7之前只只能放一个副本放到常量池）
方法区，方法区是JVM的一种规范。元空间MetaSpace和永久代PermGen都是方法区的实现。
原来在永久代里的字符串常量池移到了堆中。而且元空间替代了永久代。
本来永久代使用的是JVM内存，而元空间使用的是本地内存，字符串常量不会有性能问题（intern）和内存溢出。

### syncronize 可重入
对象头 Monitor entry set，wait set
https://blog.csdn.net/javazejian/article/details/72828483
线程池 参数，常用的
callable

two sum
如果数字在最后怎么优化
如果有序two sum怎么做
three sum

### TCP滑动窗口window size 16bit位 可靠性+流量控制+拥塞控制
window 接收端告诉发送端自己还有多少缓冲区可以接收数据rwnd
option中还有一个窗口扩大因子

### 二维数组搜索
```java
public boolean searchMatrix(int[][] matrix, int target) {
    int n = matrix.length;
    if(n <1)return false;
    int m = matrix[0].length;
    if(m<1)return false;
    int x = 0; int y = m-1;
    while(x < n && y >=0){
        if(matrix[x][y] == target)return true;
        if(target > matrix[x][y])x++;
        else if(target < matrix[x][y])y--;
    }
    return false;
}
```

### 矩阵旋转90度 lc 48
逆时针：第一步交换主对角线两侧的对称元素，第二步交换第i行和第n-1-i行，即得到结果。 如果是顺时针， 第一步交换对角线两侧的对称元素，第二步交换第i行和第n-1-i行，即得到结果。
```java
public void rotate(int[][] matrix) {
   int n = matrix.length;  
    for(int i = 0;i<n;i++){
        for(int j = i+1;j<n;j++){
            if(i!=j){
                int tmp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = tmp;  
            }            
        }
    }
    for(int i =0;i<n;i++){
        for(int j = 0;j<n/2;j++){
           int tmp = matrix[i][j];
            matrix[i][j] = matrix[i][n-1-j];
            matrix[i][n-1-j] = tmp;
        }
    }
}
```

### 短链接

### 特征模型


### 归并排序

### 缓存穿透
有很多种方法可以有效地解决缓存穿透问题，最常见的则是采用布隆过滤器，将所有可能存在的数据哈希到一个足够大的bitmap中，一个一定不存在的数据会被这个bitmap拦截掉，从而避免了对底层存储系统的查询压力。

哈希表槽位数（大小）的改变平均只需要对 K/n个关键字重新映射，其中K是关键字的数量， n是槽位数量。