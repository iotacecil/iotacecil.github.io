---
title: concurrent并发多线程
date: 2018-04-13 08:46:51
tags: [java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
### redis 10w OPS


### Disruptor

### PV和QPS估计
每天300w PV 80%会在24小时的20%的时间里
$3000 000\*0.8)/(86400\*0.2*)=139(QPS)$
如果一台机器QPS是58，则需要139/58=3台机器



### 并发模型
1.进程&线程Apache C10K问题
2.异步非阻塞 Nginx Libevent Nodejs 回调复杂度高
3.协程Golang Erlang Lua



TreeMap是非线程安全的。
跳表：
数据大时性能高于红黑树
```java
private transient volatile HeadIndex<K,V> head;
static final class HeadIndex<K,V> extends Index<K,V> {
    final int level;
    HeadIndex(Node<K,V> node, Index<K,V> down, Index<K,V> right, int level) {
        super(node, down, right);
        this.level = level;
    }
}

static final class Node<K,V> {
    final K key;
    volatile Object value;
    volatile Node<K,V> next;}

static class Index<K,V> {
        final Node<K,V> node;
        final Index<K,V> down;
        volatile Index<K,V> right;}
```

### ConcurrentMap的实现类
`ConcurrentSkipListMap`跳表 redis的实现方法
```java
ConcurrentSkipListMap<Dish.Type, Double> collect = menu.stream().collect(Collectors.groupingByConcurrent(Dish::getType, ConcurrentSkipListMap::new, Collectors.averagingInt(Dish::getCalories)));
```

### 线程池`ThreadPoolExecutor`
```java
private final BlockingQueue<Runnable> workQueue;
```
工作队列（阻塞队列）

### 保护性暂时挂起模式


### 不可变对象模式
#### 不可变对象
如果对象作为key放入HashMap，对象状态变化导致HashCode变化，会导致同样的对象作为Key，get不到相关联的值。 所以不可变对象适合作为Key。
电信服务商的路由表

#### 模式应用：CopyOnWriteArrayList
对集合加锁：不适合插入删除操作比遍历多的集合。
`CopyOnWriteArrayList` 应用了不可变对象模式。
不用锁的遍历安全。适用于遍历操作比添加删除频繁的场景。
源码：加添元素时会复制
```java
Object[] newElements = Arrays.copyOf(elements,len+1);
newElements[len] = e;
setArray(newElements);
```


> 线程池中线程数量过多，会竞争浪费事件再上下文切换。
> 线程池大小与处理器利用率之比：
> $N_{threads}=N_{CPU}处理器核数\*U_{CPU}期望的cpu利用率（0-1）\*(1+W/C等待时间与计算时间的比率)$
> 

### Stream在背后引入Fork/join框架

### Future接口
目标：实现并发，充分利用cpu的核，最大化程序吞吐量，避免因为等待远程服务返回/数据库查询。阻塞线程。
对计算结果的建模，返回一个运算结果的引用给调用方。
```java
ExecutorService executor = Executors.newCachedThreadPool();
        Future<Double> future = executor.submit(new Callable<Double>() {
            @Override
            public Double call() throws Exception {
                //异步操作
                return doSomeLongComputation();
            }
        });
        //异步操作运行同时也能执行
        doSomeThingElse();
```

### Fork/Join
工作窃取算法

发布对象：可以得到成员变量引用
对象溢出：内部类

### AQS 两个node的队列

### 多个CPU缓存一致性 MESI缓存一致性！！！

![mesi](/images/mesi.jpg)

4种数据状态，4种状态转换的cpu操作。
M（Modified)被修改：只缓存在该CPU的缓存中，被修改，与主存不一致。写回主存
Exlusive独享：缓存行只在该CPU的缓存中，未被修改，与主存一致。其它CPU读取内存时变成S状态。被修改则变成M。
Share共享：该缓存行被多个CPU缓存，且与主存相同。当一个CPU修改时其它CPU的变成I。
Invaild无效。

`local read`读本地缓存中数据`local write`写本地缓存
`remote read`读取内存数据 `remote write`写回主存

#### Cache伪共享
X86 cpu的cache line长64字节如果有一对象有成员变量long a,b,c(共24字节）
则可能加载在一个cache line中。
当 CPU1：线程1和cpu2：线程2 都从内存中读取这个对象放入自己的cache line1和2。
当线程1写a则2上的cache line变成Invalid，当2要读b需要重新从内存中读。
**本来无关的两个线程，并行变成串行。**
- 解决方法：
将a,b分到不同的cache line 采用`@Contended`

---
###  NUMA架构：内存分割，被CPU私有化：一致性协议MESIF：目录表

### message pack
[msgpack](https://msgpack.org/)

---
## 并发模拟
1. PostMan-runner选中测试的接口iteration(并发多少次)delay(每次延迟多少)
2. 安装apahce服务器bin下的`ab -n 1000 -c 50 http://localhost:8080/test`
 本次测试请求总数1000次，同时并发数50

```json
 并发量
Concurrency Level:      50 
整个测试所用的时间
Time taken for tests:   0.667 seconds 
完成的请求数
Complete requests:      1000 
失败请求数
Failed requests:        0 
所有响应数据长度总和，包括http头信息和正文数据长度，不包括http请求信息的长度
Total transferred:      136000 bytes 
所有正文数据长度
HTML transferred:       4000 bytes 
吞吐率（与并发数相关）=Complete requests:/Time taken for tests
Requests per second:    1498.52 [#/sec] (mean) 
用户平均请求等待时间
Time per request:       33.366 [ms] (mean) 
服务器平均请求等待时间
Time per request:       0.667 [ms] (mean, across all concurrent requests) 
单位时间从服务器获取的数据长度=Total transferred/Time taken for tests
Transfer rate:          199.02 [Kbytes/sec] received 
```
3. JMeter 
    1. 添加线程组File-Test Plan-Add-Threads- Thread Group
    用户数：50
    虚拟用户增长时长(Ramp-Up Period): 1 
    Loop Count循环次数：一个虚拟用户做多少次测试 20（共1000次）
    2. 添加实例请求 add Sanper HttpRequest
    3. 添加监听器 图形结果、查看结果树
    4. Option 打开Logviewer
{% fold %}
Throughput吞吐量
![jmeter](/images/jmeter.jpg)
![viewtree](/images/viewtree.jpg)
{% endfold %}

### 用代码并发模拟
```java
ExecutorService executorService = Executors.newCachedThreadPool();
//同时的并发数
final Semaphore semaphore = new Semaphore(threadTotal);
//请求完之后统计结果 传入请求总数
final CountDownLatch countDownLatch = new CountDownLatch(clientTotal);
for (int i = 0; i < clientTotal ; i++) {
        executorService.execute(() -> {
            try {//超过了并发数add会被阻塞
                semaphore.acquire();
                add();
                semaphore.release();
            } catch (Exception e) {
                log.error("exception", e);
            }//闭锁 每执行完一次-1
            countDownLatch.countDown();
        });
    }//保证闭锁到0再执行
    countDownLatch.await();
    executorService.shutdown();
    log.info("count:{}", count);
}
```
通常与线程池一起使用
> 同步器Semaphore信号量 阻塞线程 控制同一时间请求并发量
- 适合控制并发数
- Semaphore(int count)创建count个许可的信号量

每个线程：
```java
//public void run
semaphore.acquire();//获取1/num个许可证
semaphore.release();//释放许可
```
Semphore（2）则
A,B,C三个线程，A执行完后C才能开始执行。

---
> CountDownLatch()计数栓:必须发生指定数量的事件后才可以继续使用
阻塞线程，直到满足某种条件线程再继续执行,计数值（count）实际上就是闭锁需要等待的线程数量

* 适合保证线程执行完再做其它处理
![countdown](/images/countdown.jpg)
* 调用await()方法的线程会被挂起，它会等待直到count值为0才继续执行

```java
void run(){}
//主线程必须在启动其他线程后立即调用CountDownLatch.await()方法
CountDownLatch.await();}//等待锁存器
```
- 线程必须引用闭锁对象，因为他们需要通知CountDownLatch对象，他们已经完成了各自的任务。这种通知机制是通过 CountDownLatch.countDown()方法来完成的；每调用一次这个方法，在构造函数中初始化的count值就减1。

```java
//倒计时为0执行
main{
    new CountDownLatch(3);
    CountDownLatch.countDown();//触发事件
}
    ```
**面试题**
解释一下CountDownLatch概念?
CountDownLatch 和CyclicBarrier的不同之处?
给出一些CountDownLatch使用的例子?
CountDownLatch 类中主要的方法?

---




---

汇编 jne有条件跳转 jmp无条件跳转
进程-详细-设置相关性：分配到指定cpu执行，开的线程只在指定的执行
java会把线程直接映射到操作系统

![threadstate](/images/threadstate.jpg)

`javac xxx.java`->.class
`javap -c -v xxx` 查看虚拟机字节码



### Condition
```java
private Condition sufficientFunds;
if (accounts[from] < amount)
    //将该线程放到等待集
    sufficientFunds.await();
try{////最后。账户发生变化，重新检查余额
     sufficientFunds.signalAll();
}
```

### synchronized
java每个对象有内部锁。并且该锁有一个内部条件
```java
while (accounts[from] < amount)wait();
notifyAll();
```
- final 匿名内部类中只能使用final？



### 阻塞队列

### CAS(compareAndSwap)
`AtomicReference<V>`模板，可以封装任何
对数据加上时间戳解决ABA过程状态敏感问题（充值10，20，花费10
`if (money.compareAndSet(m, m + 20, timestap, timestap + 1))`
`Pair<V> current = pair;`
第i个元素在数组中的偏移量
```java
private static long byteOffset(int i) {
        return ((long) i << shift) + base;//左移2，00乘4
    }
```
1. shift = 31 - `Integer.numberOfLeadingZeros(scale);` 29个前导0->shift=2
    前导零：数字转换成二进制数后前面0的个数
2. 数组当中每个元素有多宽：int scale = `unsafe.arrayIndexScale(int[].class);` 4
3. private static final int `base = unsafe.arrayBaseOffset(int[].class);` int的话4个byte

静态工厂方法

`casPair`使用cas的方式更新

### 1. `.start`开启新线程调用run  `.run`不开启新线程
两种创建方法1.传入一个runnable对象 2.覆盖run
Thread:
```java
public Thread(Runnable target) {
    init(null, target, "Thread-" + nextThreadNum(), 0);
}
```
```java
 @Override
    public void run() {
        if (target != null) {
            target.run();
        }
    }
```

### 2. stop不建议使用，会释放所有的锁（monitor）
1. 实例方法`.interrupt()`在run()中处理
  ```java
  public void run(){
    while(true){
        if(Thread.currentTread().isInterrupted()){break;}
    }
    Thread.yeild();
  }
  ```
2. 用`Thread.sleep(2000)`异常处理 sleep会释放cpu时间片，不释放监视器所有权。让给其它线程
  在外部对这个sleep的线程中断会抛出异常
  `.isInterrupted`方法可以清除中断状态
```java
 while(true){
        if(Thread.currentTread().isInterrupted()){break;}
    }
try{
    Thread.sleep(2000);
}catch(InterruptedException e){
    //设置中断状态，抛出异常后会清除中断标记位
    Thread.currentTread.interrupt();
}
    Thread.yeild();
  }
```
3. 用自定义标记抛出异常


### 3. suspend & resume 已弃用
> If the target thread holds a lock on the monitor protecting a critical system resource when it is suspended, no thread can access this resource until the target thread is resumed.
> If the thread that would [resume] the target thread attempts to lock thismonitor prior to calling resume, deadlock results.  Such  deadlocks typically manifest themselves as "frozen" processes.

线程2resume线程1发生在线程1suspend之前，当线程1suspend之后没办法resume，导致线程1资源冻结。
{% fold 测试代码点击显/隐内容 %}
```java
package learnThr;

public class learnThread {
    public static Object u = new Object();
    static ChangeObjectThread t1 = new ChangeObjectThread("t1");
    static ChangeObjectThread t2 = new ChangeObjectThread("t2");

    public static class ChangeObjectThread extends Thread{
        public ChangeObjectThread(String name){
            super.setName(name);
        }
        @Override
        public void run(){
            //加锁
            synchronized (u){
                Thread.currentThread().suspend();
            }
        }
    }
    public static void main(String[] args)throws InterruptedException{
        t1.start();
        Thread.sleep(100);
        t2.start();
        t1.resume();
        t2.resume();
        t1.join();
        t2.join();
    }
}

```
![suspend](/images/suspend.jpg)
{% endfold %}


###  yield & join
`A.join(0)`等待A结束后执行 用wait实现
join实现
> As a thread terminates the `this.notifyAll` method is invoked.
> It is recommended that applications not use `wait`, `notify`, or`notifyAll`on `Thread` instances.不要在Thread实例上使用，会影响系统API

wait该线程释放监视器所有权。 在同步方法中使用
虚拟机实现notifyAll，在Object上。结束时会唤醒所有等待线程。
```java
 if (millis == 0) {
            while (isAlive()) {
                wait(0);
            }
        }
```

### 守护线程`t.setDaemon(true);`
虚拟机不会管守护线程是否存在，直接退出。

### 优先级
```java
high.setPriority(Thread.MAX_PRIORITY);
low.setPriority(Thread.MIN_PRIORITY);
```




### wait & notify
-`Object.wait()` 线程等待在当前对象上
> The current thread must own this object's monitor.
> releases ownership of this monitor and waits until another thread notifies

-`Object.notify()`通知等待在这个线程上的对象 随机唤醒一个
> Wakes up `a single thread `that is waiting on this object's monitor.

```java
synchronized (object) { object.wait();}
synchronized (object) { object.notify();}
```
## 同步
1. synchronized独占加锁


## java.util.concurrent 并发工具包
3. CyclicBarrier(int num)等待多个线程到达预定点
2. 执行器
3. 并发集合
4. Frok/Join框架：并行
5. atomic包：不需要锁即可完成并发环境变量使用的原子性操作
6. locks包
