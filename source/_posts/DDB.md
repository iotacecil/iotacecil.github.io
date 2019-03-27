---
title: 数据库锁
date: 2018-03-16 15:31:34
tags:
categories: [数据库dockerHadoop微服务]
---
### 完全串行化的读,每次读都需要获得表级共享锁,读写相互都会阻塞
下面有关事务隔离级别说法正确的是?
正确答案: A B C D   你的答案: B C D (错误)
A串行读(Serializable):完全串行化的读,每次读都需要获得表级共享锁,读写相互都会阻塞
B未提交读(Read Uncommitted):允许脏读,也就是可能读取到其他会话中未提交事务修改 的数据
C提交读(Read Committed):只能读取到已经提交的数据
D可重复读(Repeated Read):在同一个事务内的查询都是事务开始时刻一致的

### where 子句中不能出现聚合函数（列函数）
以下哪个函数不能直接出现在SQL的WHERE子句中
正确答案: A B   你的答案: C (错误)
A.SUM
B.COUNT
C.ORDER BY
D.LIMIT
聚集函数也叫列函数，它们都是基于整列数据进行计算的，而where子句则是对数据行进行过滤的。
sql语句的执行顺序为

from子句

where 子句

group by 子句

having 子句

order by 子句

select 子句

### 关系型数据库和对象
表和类关联
行和对象关联
字段和属性关联

### B+树
数据库中，B+树的高度一般在2到3层。也就是说查找某一键值的记录，最多只需要2到3次IO开销。按磁盘每秒100次IO来计算，查询时间只需0.0.2到0.03秒

不确定：
100w个Integer B+树需要多少层

### inodb

后台AIO 线程数
```sql
mysql> show variables like 'innodb_%io_threads'\G
*************************** 1. row ***************************
Variable_name: innodb_read_io_threads
        Value: 4
*************************** 2. row ***************************
Variable_name: innodb_write_io_threads
        Value: 4
2 rows in set, 1 warning (0.01 sec)
```

读线程id小于写线程id
```sql
mysql> show engine innodb status\G;
FILE I/O
--------
I/O thread 0 state: wait Windows aio (insert buffer thread)
I/O thread 1 state: wait Windows aio (log thread)
I/O thread 2 state: wait Windows aio (read thread)
I/O thread 3 state: wait Windows aio (read thread)
I/O thread 4 state: wait Windows aio (read thread)
I/O thread 5 state: wait Windows aio (read thread)
I/O thread 6 state: wait Windows aio (write thread)
I/O thread 7 state: wait Windows aio (write thread)
I/O thread 8 state: wait Windows aio (write thread)
I/O thread 9 state: wait Windows aio (write thread)
```

磁盘最小单位扇区512字节
文件系统最小单位 块 4k
InnoDB最小单元 页 16k
指针大小在6字节
![innodb16k.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/innodb16k.jpg)
都是16的整数倍
```sql
mysql> show variables like 'innodb_page_size';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| innodb_page_size | 16384 |
+------------------+-------+
1 row in set, 1 warning (0.00 sec)
```

单个叶子节点（页）中的记录数=16K/1K=16。（这里假设一行记录的数据大小为1k，实际上现在很多互联网业务数据记录大小通常就是1K左右）。

那么现在我们需要计算出非叶子节点能存放多少指针，其实这也很好算，我们假设主键ID为bigint类型，长度为8字节，而指针大小在InnoDB源码中设置为6字节，这样一共14字节，我们一个页中能存放多少这样的单元，其实就代表有多少指针，即16384/14=1170。那么可以算出一棵高度为2的B+树，能存放1170*16=18720条这样的数据记录。

根据同样的原理我们可以算出一个高度为3的B+树可以存放：1170*1170*16=21902400条这样的记录。所以在InnoDB中B+树高度一般为1-3层，它就能满足千万级的数据存储。在查找数据时一次页的查找代表一次IO，所以通过主键索引查询通常只需要1-3次IO操作即可查找到数据。

隔离级别是对一致性的破坏。
事务之间的Happen-before关系：4种 【读写，写读，读读】，写写
1. 排他锁 排队：序列化读写 不需要冲突控制，无死锁
2. 排他锁：用n个队列，发生共享数据冲突就并行，不然就串行。对数据加锁，只允许一个线程访问。
3. 读写锁：读写分离。读可以并行（可重复读），写写、写读、读写依然串行。对于读多写少的应用性能提升并行度。针对读读、读写优化。
4. 读写锁的第二种（读已提交，不可重复读）：实现读后写并行。读锁可以被写锁升级。读锁->写锁。 写读还不能并行。
死锁：读写：事务1申请A的读锁，事务2也加读锁并行读A。当事务1想把A升级成写锁需要等2释放读锁。反过来2要等1释放读锁。`Update set A=A-1 where id=100`先读查where再写会死锁
U锁：先判断事务中的写操作，申请锁时把原来的读锁改写锁。事务2想要先read再update写A的时候就等待。

5. 读写锁第三种（读未提交）：把读锁去掉，读不加锁。写后读并行，写后的读可提前。但是可能会读到读的中间状态。

---
5.  mvcc多版本并发控制 本质：copy on write。每次写都是写一个新的数据，写在log里，不是原地更新。针对写读场景优化，例如：当前数据版本号v10,读版本号v5则去log里找v5的数据。在写操作加锁时，依然可以并发读。现在主流做法：实现写读、读读、读写不冲突。
当写>读 记录的日志很多 会增加延迟。

减小锁的覆盖范围：原地锁->MVCC多版本锁
增加锁上可并行的线程数：读写分离
- 有的数据库不能支持大事务原因在于写读冲突，读在外面等待。
6. 隔离性的扩展：SNAPSHOT 快照隔离级别：就是mvcc copy on write 无锁编程。
    快照读：读事务开始之前的版本。达到读未提交的并行度。保证读到一致性的数据。

悲观锁：数据加锁使线程bloking状态，等到等待的锁ok回到runnable状态。把寄存器的数据换成另一个线程，把缓存清空，cpu的cache清空，增加系统开销。适合并发争抢严重的场景。
乐观锁：

### 持久性<->延迟：
RAID Controller 保证一个操作写两个以上磁盘
group commit 组提交

mvcc：读应该读哪一个写之后的数据：逻辑时间戳(保证顺序) 说明事务内单元的先后
SCN(Oracle)
Trx_id（Innodb)

原子性：记录了undo操作，可以全部成功/失败

### 故障恢复：
1. 业务属性不匹配：记录事务前的数据
锁定bob、smith的账户->检查bob账户是否有100元-X不满足->回滚

### 死锁检测：碰撞检测/等锁超时

https://www.cloudera.com/developers/get-started-with-hadoop-tutorial.html
Fragmentation: process of partitioning the database into disjoint fragments
, Data allocation,  degree of replication 

事务(transaction)：对数据库进行读或写的一个操作序列.
mysql 中 myisam innodb


- LVM（逻辑卷）

### Hash 分片
1. round robin ：每次新+物理机$hash(key)mod(K+1)$都要重新分配，在线系统缺乏灵活性
    将物理机映射和数据分片映射由一个hash函数承担，机器个数K出现在映射函数中，紧耦合。
2. 虚拟桶 virtual buckets:虚拟桶作为数据分片，用hash映射；物理机映射采用表格

#### 3. 一致性哈希：和弦（chord）系统中提出。
- 哈希长度为5，哈希空间为32，节点映射到环的位置随机
![hash](\images\hash.jpg))
- 每个机器节点负责存储一段哈希空间的数据，N14存储6-14的数据；N5存储0-5，

##### 查询
1. N14接收到查询请求，Hash(key)=27,不在下一个节点20
2. 查找每个机器节点都有的路由表，找到小于27的最大节点N25（前趋）
    路由表存储距离$2^k$距离的节点($14+2^3<25<14+2^4$),路由表存储哈希空间长度条路由信息
3. 回1，29返回数据给14

##### 新节点
1. 查找后继
2. 更新前趋，新节点，后继的前趋后继信息
3. 将后继节点s上存储的数据分片迁移到新节点

##### 稳定性检测
当有多个新节点插入，新节点的前趋节点置空
1. 加入N8，将N8后继置N14，前趋置空
开始稳定性检测
1. 询问后继的前趋指向是N5 不是自己
2. N5不在N8和N14中间，通知后继修改前趋指向N8
3. N14中hash6-8的值迁移到N8 
完成稳定性检测
4. 对前趋N5稳定性检测
5. N5询问后继的前趋不是自己 ，N8介于自己和N14之间，N5修改后继
6. 完成检测 定期更新路由表

### CAP 一致性(多副本对外单副本) 可用性（延迟） 分区容忍性（网络分区现象仍工作）
改进：先识别网络分区，网络分区发生时记录每个分区的状态，执行各自操作，当分区恢复，融合产生新状态。P出现时每个分区经可能执行ACID
1. 数据无副本，发生网络分区现象or宕机数据不可访问，不满足P
2. 副本存储在不同机器上：
    1. 选择强一致性。数据同步前拒绝读，不能满足A可用信
    2. 选择可用性并不是最新数据，不满足C

### 幂等性：
反复执行多次和一次的效果相同。
$f(f(x))=f(x)$(取绝对值)
$f(x,x) = x$ max(x,x) =x ; a AND a = a

- 最终一致性:不一致窗口

### 一致性协议




#### 脏读

对象存储？？？


## 大数据日知录

