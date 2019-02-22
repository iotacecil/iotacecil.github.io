---
title: 单选题记录
date: 2018-12-25 15:34:13
tags: [面试卡片]
---

下面哪个行为被打断不会导致InterruptedException：（ ）？
A Thread.join
B Thread.sleep
C Object.wait
D CyclicBarrier.await
E Thread.suspend
他的回答： A (错误)
正确答案： E

如果抛出 InterruptedException 意味着一个方法是阻塞方法

---

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

能单独和 finally 语句一起使用的块是
A try
B throws
C throw
D catch
他的回答： C (错误)
正确答案： A

throw 要用在try catch中
---

以下关于进程和线程的描述中，正确的一项是（ ）
A 一个进程就是一个独立的程序
B 进程间是互相独立的，同一进程的各线程间也是独立的，不能共享所属进程拥有的资源
C 每个线程都有自己的执行堆线和程序计数器为执行上下文
D 进程的特征包括动态性、并发性、独立性、同步性

他的回答： A (错误)
正确答案： C

---

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


一个提供NAT服务的路由器在转发一个源IP地址为10.0.0.1、目的IP地址为131.12.1.1的IP分组时，可能重写的IP分组首部字段是
Ⅰ.TTL
Ⅱ.片偏移量
Ⅲ.源IP地址
Ⅳ.目的IP地址

查看系统内存如下：
    [@server ~]# free -g
    total used free shared buffers cached
    Mem: 15 5 9 0 0 2
    -/+ buffers/cache: 3 12
    Swap: 0 0 0
那么程序实际可使用内存有多少


sql中，可以用来替换DISTINCT的语句是（ ）