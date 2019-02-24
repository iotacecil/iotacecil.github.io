---
title: 面试卡片
date: 2018-12-25 15:34:13
tags: [面试卡片]
---
https://www.nowcoder.com/discuss/50571?type=2&order=0&pos=21&page=2
### 1.泛型的好处
泛型：向不同对象发送同一个消息，不同的对象在接收到时会产生不同的行为（即方法）；也就是说，每个对象可以用自己的方式去响应共同的消息。消息就是调用函数，不同的行为是指不同的实现（执行不同的函数）。
用同一个调用形式，既能调用派生类又能调用基类的同名函数。

虚函数是实现多态 "动态编联”的基础，C++中如果用基类的指针来析构子类对象，基类的析构要加`virtual`，不然不会调用子类的析构，会内存泄漏。

### 2.数据库索引INNDB的好处
事务，主键索引

### 3.CAS算法原理？优缺点？

### 4.为什么是三次握手
信道不可靠, 但是通信双发需要就某个问题达成一致. 而要解决这个问题, 三次通信是理论上的最小值。

为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误。
如果A发送2个建立链接给B，第一个没丢只是滞留了，如果不第三次握手只要B同意连接就建立了。
如果B以为连接已经建立了，就一直等A。所以需要A再确认。

### 5.为什么四次分手
1)由于TCP连接是全双工的，因此每个方向都必须单独进行关闭。
当一方完成它的数据发送任务后就能发送一个FIN来终止这个方向的连接。
收到一个 FIN只意味着这一方向上没有数据流动，一个TCP连接在收到一个FIN后仍能发送数据。首先进行关闭的一方将执行主动关闭，而另一方执行被动关闭。
2)让本连接持续时间内所有的报文都从网络中消失，下个连接中不会出现旧的请求报文。

### 6.数据库最左匹配原理

### 7.http https
![httphttps.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/httphttps.jpg)

### 8.进程间通信
套接字，管道，消息队列，共享内存，信号量,信号。

### 9.线程池的运行流程，使用参数以及方法策略
运行流程：

一共有5种线程池

### 10.线程同步的方法

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
第一范式：列不可拆分
第二范式：每个属性要完全依赖于主键
第三范式：消除传递依赖。各种信息只在一个地方存储，不出现在多张表中
BCNF：

### 21 内存溢出OOM和内存泄漏memory leak


### 22 四种引用类型
强引用，软引用，弱引用，虚引用

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


### 32 
个人介绍
sb依赖注入控制反转
知识图谱 之间的关系 和结构存储neo4j
vue的特点
和react的比较

前后端跨域怎么实现

redis string
redis
为什么要把页面放到redis中？
redis常用数据结构

如何用redis list实现mq

mq怎么实现的
消息队列时需要考虑到的问题，如RPC、高可用、顺序和重复消息、可靠投递、消费关系解析等

linux 
如何传文件 scp
如何查进程 
如何在文件找查一个字符串

String StringBuilder StringBuffer 
String 存在JVM哪里
syncronize
线程池 参数，常用的
callable

two sum
如果数字在最后怎么优化
如果有序two sum怎么做
three sum