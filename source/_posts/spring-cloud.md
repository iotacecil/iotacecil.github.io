---
title: spring-cloud
date: 2018-05-08 16:17:37
tags:
categories: [数据库dockerHadoop微服务]
---
分布式：节点之间如何通信
微服务：按业务划分模块

`@EnableEurekaServer`

## 静态文件用Nginx+Lua实现高性能网关

## 文件服务器 FastDFS


## zk客户端 curator
解决watcher注册一次就失效
分布式锁

## docker

## ZooKeeper
1.安装jdk到/usr/ 安装zookeeper到/usr/local/
2.`cp zoo_sample.cfg zoo.cfg`
tickTime 时间单元 session超时等
initLimit=N 集群 初始化链接时间 表示是tickTime的N倍
syncLimit=N 主发送给从 的请求应答时间长度（心跳）表示是tickTime的N倍

dataDir=/usr/zookeeper/dataDir
dataLogDir=/usr/zooKeeper/dataLogDir
并创建dataDir和dataLogDir

回到/bin 启动服务器
`./zkServer.sh start`

启动客户端`./zkCli.sh` 链接成功后 
1. help显示命令
2. `ls2 /`和`stat /`一样 
![zid](/images/zid.png)
ctime创建时间
pZxid 子节点id
cversion子节点的变化

### 创建
创建结点 `create /iznode inode-data`
查看`get /iznode`
创建临时结点`create /iznode/tmp inode-data`
ephemeralOwner可以看出是不是临时结点 客户端关闭后，超时后，临时结点会自动删除
创建顺序结点`create -s /iznode/sec seq-data`会自动在名字后面加序列号

### set和delete
`set /iznode 123 1`添加乐观锁123 版本号+1

### watch
`get /iznode watch`

