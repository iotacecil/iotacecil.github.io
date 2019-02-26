---
title: 面试卡片
date: 2018-12-25 15:34:13
tags: [面试卡片]
---

https://github.com/randian666/algorithm-study
https://www.nowcoder.com/discuss/50571?type=2&order=0&pos=21&page=2
### 1.泛型的好处
泛型：向不同对象发送同一个消息，不同的对象在接收到时会产生不同的行为（即方法）；也就是说，每个对象可以用自己的方式去响应共同的消息。消息就是调用函数，不同的行为是指不同的实现（执行不同的函数）。
用同一个调用形式，既能调用派生类又能调用基类的同名函数。

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

初始化序号，互相通知自己的序号。

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
第一范式：列不可拆分 目的：列原子性
第二范式：每个属性要完全依赖于主键
第三范式：每一列都要与主键直接相关。【消除传递依赖】。各种信息只在一个地方存储，不出现在多张表中
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


#### 37 sb依赖注入控制反转。
IOC是一种设计模式。将对象-对象关系解耦和对象-IOC容器-对象关系。容器管理依赖关系。依赖对象的获得被反转了。

依赖注入DI方式setter、接口、构造函数。组件之间依赖关系由容器在运行期决定。
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
XSS 跨站脚本攻击
CSRF 跨站请求伪造（利用用户登陆态）
Cookie的 `SameSite`属性strict

redis string
redis
为什么要把页面放到redis中？
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

如何用redis list实现mq

### mq怎么实现的
AMQP协议: 虚拟主机（virtual host），交换机（exchange），队列（queue）和绑定（binding）。一个虚拟主机持有一组交换机、队列和绑定.
生产者和消费者是完全解耦.
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