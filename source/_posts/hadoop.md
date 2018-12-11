---
title: hadoop
date: 2018-08-09 21:35:43
tags:
categories: [数据库dockerHadoop微服务]
---
split 是mapreduce中的最小计算单元一般和hdfs的blocksize 是一一对应的/

以下哪个调度器是hadoop的默认调度器
正确答案: B   你的答案: C (错误)
A调度器Capacity Scheduler
B调度器FIFO
C资源调度器 Resource Scheduler
D调度器Fair Scheduler

---

Hadoop HDFS Client端上传文件到HDFS上的时候下列不正确的是
正确答案: A C D   你的答案: A B (错误)
A.数据经过NameNode传递给DataNode
B.数据副本将以管道的方式依次传递
C.Client将数据写到一台DataNode上，并由Client负责完成Block复制工作
D.当某个DataNode失败，客户端不会继续传给其它的DataNode

A:Client 向 NameNode 发起文件写入的请求。NameNode 根据文件大小和文件块配置情况，返回给 Client 它所管理部分 DataNode 的信息。Client 将文件划分为多个 Block，根据 DataNode 的地址信息，按顺序写入到每一个DataNode 块中。


Mapper.java
模板模式
```java
public void run(Context context) throws IOException, InterruptedException {
    setup(context);
    try {
      while (context.nextKeyValue()) {
        map(context.getCurrentKey(), context.getCurrentValue(), context);
      }
    } finally {
      cleanup(context);
    }
  }
```
重写方法
```java
/**
* Called once for each key/value pair in the input split. Most applications
* should override this, but the default is the identity function.
*/
@SuppressWarnings("unchecked")
protected void map(KEYIN key, VALUEIN value, 
                 Context context) throws IOException, InterruptedException {
context.write((KEYOUT) key, (VALUEOUT) value);
}
```