---
title: spring-cloud zk
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

## k8s 容器编排工具

## ZooKeeper
1.安装jdk到/usr/ 安装zookeeper到/usr/local/
`vi /etc/profile` 
```sh
export ZOOKEEPER_HOME=/usr/local/zookeeper-3.4.8
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH:$ZOOKEEPER_HOME/bin
```

2.
`cd conf/`
`cp zoo_sample.cfg zoo.cfg`
tickTime 时间单元 session超时等
initLimit=N 用于集群 从从节点连接并同步到主节点 的初始化链接时间 表示是tickTime的N倍
syncLimit=N 主发送给从 的请求应答时间长度（心跳）表示是tickTime的N倍

```sh
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir= /usr/local/zookeeper3.4.8/dataDir
dataLogDir=/usr/local/zookeeper3.4.8/logDir

# the port at which the clients will connect
clientPort=2181
```
并创建dataDir和dataLogDir

`cd ../bin `启动服务器
```sh
[root@localhost bin]# ./zkServer.sh
ZooKeeper JMX enabled by default
Using config: /usr/local/zookeeper-3.4.8/bin/../conf/zoo.cfg
Usage: ./zkServer.sh {start|start-foreground|stop|restart|status|upgrade|print-cmd}

```
`./zkServer.sh start/restart/stop`

启动客户端`./zkCli.sh` 链接成功后 
```sh
[zk: localhost:2181(CONNECTED) 0] help
ZooKeeper -server host:port cmd args
    stat path [watch]
    set path data [version]
    ls path [watch] #某个路径下的目录列表
    delquota [-n|-b] path
    ls2 path [watch]
    setAcl path acl
    setquota -n|-b val path
    history 
    redo cmdno
    printwatches on|off
    delete path [version]
    sync path
    listquota path
    rmr path
    get path [watch]
    create [-s] [-e] path data acl
    addauth scheme auth
    quit 
    getAcl path
    close 
    connect host:port
```
#### ls
```sh
[zk: localhost:2181(CONNECTED) 2] ls /
[zookeeper]
[zk: localhost:2181(CONNECTED) 3] ls /zookeeper
[quota]
[zk: localhost:2181(CONNECTED) 4] ls /zookeeper/quota
[]
```

zk 的作用
1.M/S节点选举->高可用
2.同步配置文件到所有服务器
3.发布订阅MQ
4.分布式锁
5.集群管理，保证数据强一致性

#### ls2 /
```sh
[zk: localhost:2181(CONNECTED) 0] ls2 /
[zookeeper]
cZxid = 0x0
ctime = Thu Jan 01 08:00:00 CST 1970
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x0
cversion = -1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 1
```

#### stat /
```sh
[zk: localhost:2181(CONNECTED) 1] stat /
cZxid = 0x0
ctime = Thu Jan 01 08:00:00 CST 1970
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x0
cversion = -1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 0
numChildren = 1
```

#### get /
```sh
[zk: localhost:2181(CONNECTED) 2] get /
 #数据 当前为空
cZxid = 0x0 ## 创建了之后zk给它分配的id
ctime = Thu Jan 01 08:00:00 CST 1970 #创建时间
mZxid = 0x0
mtime = Thu Jan 01 08:00:00 CST 1970
pZxid = 0x0 #子节点id
cversion = -1 #子节点的变化
dataVersion = 0 #数据版本号
aclVersion = 0 # 权限
ephemeralOwner = 0x0
dataLength = 0
numChildren = 1 # 子节点有几个
```

{% qnimg zid.png %}

#### Session 的基本原理
一个C/S连接存在一个会话，
会话有超时时间
心跳结束 session过期

session 临时节点znode被抛弃

心跳机制：C向S发送ping

#### create
```sh
[zk: localhost:2181(CONNECTED) 3] crete
ZooKeeper -server host:port cmd args
    stat path [watch]
    set path data [version]
    ls path [watch]
    delquota [-n|-b] path
    ls2 path [watch]
    setAcl path acl
    setquota -n|-b val path
    history 
    redo cmdno
    printwatches on|off
    delete path [version]
    sync path
    listquota path
    rmr path
    get path [watch]
    create [-s] [-e] path data acl
    addauth scheme auth
    quit 
    getAcl path
    close 
    connect host:port

```
创建结点 `create /iznode inode-data`
查看`get /iznode`
```sh
[zk: localhost:2181(CONNECTED) 4] create /iznode inode-data
Created /iznode
[zk: localhost:2181(CONNECTED) 5] get /iznode
inode-data
cZxid = 0x4
ctime = Sat Sep 15 15:30:32 CST 2018
mZxid = 0x4
mtime = Sat Sep 15 15:30:32 CST 2018
pZxid = 0x4
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 10
numChildren = 0
```
创建临时结点`create -e /iznode/tmp inode-data`
```sh
[zk: localhost:2181(CONNECTED) 6] create -e /iznode/tmp inode-data
Created /iznode/tmp
[zk: localhost:2181(CONNECTED) 7] get /iznode
inode-data
cZxid = 0x4
ctime = Sat Sep 15 15:30:32 CST 2018
mZxid = 0x4
mtime = Sat Sep 15 15:30:32 CST 2018
pZxid = 0x5
cversion = 1
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 10
numChildren = 1
[zk: localhost:2181(CONNECTED) 8] get /iznode/tmp
inode-data
cZxid = 0x5
ctime = Sat Sep 15 15:31:33 CST 2018
mZxid = 0x5
mtime = Sat Sep 15 15:31:33 CST 2018
pZxid = 0x5
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x165dc14dc590001 #临时节点
dataLength = 10
numChildren = 0
```
ephemeralOwner可以看出是不是临时结点 客户端关闭后，超时后，临时结点会自动删除
`ctrl-C`关闭客户端再打开 还有 因为时效还在 等一下再get就没了
```sh
[zk: localhost:2181(CONNECTED) 2] get /iznode/tmp
inode-data
cZxid = 0x5
ctime = Sat Sep 15 15:31:33 CST 2018
mZxid = 0x5
mtime = Sat Sep 15 15:31:33 CST 2018
pZxid = 0x5
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x165dc14dc590001
dataLength = 10
numChildren = 0
[zk: localhost:2181(CONNECTED) 3] get /iznode/tmp
Node does not exist: /iznode/tmp
```
创建顺序结点`create -s /iznode/sec seq-data`会自动在名字后面加序列号
```sh
[zk: localhost:2181(CONNECTED) 4] create -s /iznode/sec seq-data
Created /iznode/sec0000000001
[zk: localhost:2181(CONNECTED) 5] create -s /iznode/sec seq-data
Created /iznode/sec0000000002
[zk: localhost:2181(CONNECTED) 6] create -s /iznode/sec seq-data
Created /iznode/sec0000000003
```


### set `set path data [version]`和delete
`set /iznode 123 1`添加乐观锁123 版本号+1
```sh
[zk: localhost:2181(CONNECTED) 9] set /iznode newnewnew
cZxid = 0x4
ctime = Sat Sep 15 15:30:32 CST 2018
mZxid = 0xb
mtime = Sat Sep 15 15:36:04 CST 2018
pZxid = 0xa
cversion = 5
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 9
numChildren = 3
[zk: localhost:2181(CONNECTED) 10] get /iznode
newnewnew
cZxid = 0x4
ctime = Sat Sep 15 15:30:32 CST 2018
mZxid = 0xb
mtime = Sat Sep 15 15:36:04 CST 2018
pZxid = 0xa
cversion = 5
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 9
numChildren = 3
```

set 添加版本号 乐观锁
```sh
[zk: localhost:2181(CONNECTED) 11] set /iznode newnewnew 1
cZxid = 0x4
ctime = Sat Sep 15 15:30:32 CST 2018
mZxid = 0xc
mtime = Sat Sep 15 15:37:19 CST 2018
pZxid = 0xa
cversion = 5
dataVersion = 2
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 9
numChildren = 3
[zk: localhost:2181(CONNECTED) 12] set /iznode newnewnew 1
version No is not valid : /iznode
```

delete
```sh
[zk: localhost:2181(CONNECTED) 17] ls /iznode            
[sec0000000003, sec0000000001, sec0000000002]
[zk: localhost:2181(CONNECTED) 18] delete /iznode/sec0000000003
[zk: localhost:2181(CONNECTED) 19] ls /iznode                  
[sec0000000001, sec0000000002]
[zk: localhost:2181(CONNECTED) 20] get /iznode
newnewnew
cZxid = 0x4
ctime = Sat Sep 15 15:30:32 CST 2018
mZxid = 0xc
mtime = Sat Sep 15 15:37:19 CST 2018
pZxid = 0xe
cversion = 6
dataVersion = 2
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 9
numChildren = 2

```

### watch
对node的操作都会触发watcher
```sh
stat path [watch]
get path [watch]
```

```sh
[zk: localhost:2181(CONNECTED) 10] create /iwatch2 145
Created /iwatch2
[zk: localhost:2181(CONNECTED) 11] get /iwatch2 watch 
145
cZxid = 0x14
ctime = Sat Sep 15 15:50:03 CST 2018
mZxid = 0x14
mtime = Sat Sep 15 15:50:03 CST 2018
pZxid = 0x14
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 3
numChildren = 0
[zk: localhost:2181(CONNECTED) 12] delete /iwatch2

WATCHER::

WatchedEvent state:SyncConnected type:NodeDeleted path:/iwatch2
```
乐观锁：当节点数据变化版本号会累加

子节点watch
```sh
[zk: localhost:2181(CONNECTED) 15] create /iwatch/abc 88
Created /iwatch/abc
[zk: localhost:2181(CONNECTED) 16] ls /iwatch watch
[abc]
[zk: localhost:2181(CONNECTED) 17] delete /iwatch/abc

WATCHER::

WatchedEvent state:SyncConnected type:NodeChildrenChanged path:/iwatch
```

```sh
[zk: localhost:2181(CONNECTED) 18] ls /iwatch watch
[]
[zk: localhost:2181(CONNECTED) 19] create /iwatch/xyz 999

WATCHER::

WatchedEvent state:SyncConnected type:NodeChildrenChanged path:/iwatch
Created /iwatch/xyz
[zk: localhost:2181(CONNECTED) 20] set /iwatch/xyz newnew999
cZxid = 0x18
ctime = Sat Sep 15 15:53:27 CST 2018
mZxid = 0x19
mtime = Sat Sep 15 15:53:46 CST 2018
pZxid = 0x18
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 9
numChildren = 0
[zk: localhost:2181(CONNECTED) 21] get /iwatch/xyz watch
newnew999
cZxid = 0x18
ctime = Sat Sep 15 15:53:27 CST 2018
mZxid = 0x19
mtime = Sat Sep 15 15:53:46 CST 2018
pZxid = 0x18
cversion = 0
dataVersion = 1
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 9
numChildren = 0
[zk: localhost:2181(CONNECTED) 22] set /iwatch/xyz newne888 

WATCHER::

WatchedEvent state:SyncConnected type:NodeDataChanged path:/iwatch/xyz
cZxid = 0x18
ctime = Sat Sep 15 15:53:27 CST 2018
mZxid = 0x1a
mtime = Sat Sep 15 15:54:25 CST 2018
pZxid = 0x18
cversion = 0
dataVersion = 2
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 8
numChildren = 0
```

#### watcher使用场景：统一资源配置

### ACL access control lists 权限控制
```sh
setAcl path acl
getAcl path
addauth scheme auth
```

```sh
[zk: localhost:2181(CONNECTED) 3] create /iznode/abc aaa
Created /iznode/abc
[zk: localhost:2181(CONNECTED) 4] getAcl /iznode/abc    
'world,'anyone
: cdrwa
```
`[scheme:id:permissions]`权限列表
{% qnimg zkacl.jpg %}
c 创建
r 读
w 写
d 删除
a admin权限 不加要super
```sh
[zk: localhost:2181(CONNECTED) 5] setAcl /iznode/abc/ world:anyone:crwa
Command failed: java.lang.IllegalArgumentException: Path must not end with / character
[zk: localhost:2181(CONNECTED) 6] setAcl /iznode/abc world:anyone:crwa 
cZxid = 0x1d
ctime = Sat Sep 15 15:59:43 CST 2018
mZxid = 0x1d
mtime = Sat Sep 15 15:59:43 CST 2018
pZxid = 0x1d
cversion = 0
dataVersion = 0
aclVersion = 1
ephemeralOwner = 0x0
dataLength = 3
numChildren = 0
[zk: localhost:2181(CONNECTED) 7] getAcl /iznode/abc                   
'world,'anyone
: crwa
[zk: localhost:2181(CONNECTED) 8] create /iznode/abc/xyz 123
Created /iznode/abc/xyz
[zk: localhost:2181(CONNECTED) 9] delete /iznode/abc/xyz
Authentication is not valid : /iznode/abc/xyz
```

#### digest
用户名密码SHA1+BASE64
```sh
[zk: localhost:2181(CONNECTED) 17] create /names nnn                            
Created /names
[zk: localhost:2181(CONNECTED) 19] create /names/zhangsan zhangsan
Created /names/zhangsan
[zk: localhost:2181(CONNECTED) 14] addauth digest username:pw
[zk: localhost:2181(CONNECTED) 20] setAcl /names/zhangsan auth:username:pw:cdrwa
cZxid = 0x27
ctime = Sat Sep 15 16:10:09 CST 2018
mZxid = 0x27
mtime = Sat Sep 15 16:10:09 CST 2018
pZxid = 0x27
cversion = 0
dataVersion = 0
aclVersion = 1
ephemeralOwner = 0x0
dataLength = 8
numChildren = 0
[zk: localhost:2181(CONNECTED) 21] getAcl /names/zhangsan                       
'digest,'username:cP33D+25T3/l/dheCyIBuhZjI40=
: cdrwa

```

#### ip设置一个网段的权限
```sh
[zk: localhost:2181(CONNECTED) create /names/ip ip                              
Created /names/ip
[zk: localhost:2181(CONNECTED) 23] setAcl /names/ip ip:10.1.18.11:cdrwa
cZxid = 0x29
ctime = Sat Sep 15 16:13:47 CST 2018
mZxid = 0x29
mtime = Sat Sep 15 16:13:47 CST 2018
pZxid = 0x29
cversion = 0
dataVersion = 0
aclVersion = 1
ephemeralOwner = 0x0
dataLength = 2
numChildren = 0
[zk: localhost:2181(CONNECTED) 24] getAcl /names/ip                    
'ip,'10.1.18.11
: cdrwa
[zk: localhost:2181(CONNECTED) 25] get /names/ip
Authentication is not valid : /names/ip
```

### super 用户
`vi zkServer.sh`
/nohup
加上
```sh
 nohup "$JAVA" "-Dzookeeper.log.dir=${ZOO_LOG_DIR}" "-Dzookeeper.root.logger=${ZOO_LOG4J_PROP}" "-Dzookeeper.DigestAuthenticationProvider.superDigest=username:cP33D+25T3/l/dheCyIBuhZjI40="\
    -cp "$CLASSPATH" $JVMFLAGS $ZOOMAIN "$ZOOCFG
```

对应jar包
`org.apache.zookeeper.server.auth`

重启
`./zkServer.sh restart`
```sh
[zk: localhost:2181(CONNECTED) 3] getAcl /names/ip
'ip,'10.1.18.11
: cdrwa
[zk: localhost:2181(CONNECTED) 4] addauth digest username:pw
[zk: localhost:2181(CONNECTED) 5] ls /names/ip  
```

#### acl使用场景：开发/测试人员环境分离

### Four Letter Words
`yum install nc`
```sh
[root@localhost bin]# echo stat | nc 10.1.18.133 2181
Zookeeper version: 3.4.8--1, built on 02/06/2016 03:18 GMT
Clients:
 /10.1.18.133:38240[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/1/11
Received: 25
Sent: 24
Connections: 1
Outstanding: 0
Zxid: 0x2d
Mode: standalone
Node count: 15
[root@localhost bin]# echo ruok | nc 10.1.18.133 2181
imok
[root@localhost bin]# echo dump | nc 10.1.18.133 2181
SessionTracker dump:
Session Sets (0):
ephemeral nodes dump:
Sessions with Ephemerals (0):
```
创建临时节点
```sh
create -e /name/tmp-dump 123
```
dump
```sh
[root@localhost ~]# echo dump | nc 10.1.18.133 2181
SessionTracker dump:
Session Sets (3):
0 expire at Sat Sep 15 16:37:30 CST 2018:
0 expire at Sat Sep 15 16:37:40 CST 2018:
1 expire at Sat Sep 15 16:37:50 CST 2018:
    0x165dc54602f0001
ephemeral nodes dump:
Sessions with Ephemerals (0):
[root@localhost ~]# echo dump | nc 10.1.18.133 2181
SessionTracker dump:
Session Sets (4):
0 expire at Sat Sep 15 16:38:30 CST 2018:
0 expire at Sat Sep 15 16:38:40 CST 2018:
0 expire at Sat Sep 15 16:38:42 CST 2018:
1 expire at Sat Sep 15 16:38:50 CST 2018:
    0x165dc54602f0001
ephemeral nodes dump:
Sessions with Ephemerals (1):
0x165dc54602f0001: #可以看到临时节点的目录
    /names/tmp-dump
```

#### conf
```sh
[root@localhost ~]# echo conf | nc 10.1.18.133 2181
clientPort=2181
dataDir=/usr/local/zookeeper-3.4.8/dataDir/version-2
dataLogDir=/usr/local/zookeeper-3.4.8/logDir/version-2
tickTime=2000
maxClientCnxns=60
minSessionTimeout=4000
maxSessionTimeout=40000
serverId=0

```
#### cons
```sh
[root@localhost ~]# echo cons | nc 10.1.18.133 2181
 /10.1.18.133:38260[0](queued=0,recved=1,sent=0)
 /0:0:0:0:0:0:0:1:37946[1](queued=0,recved=33,sent=33,sid=0x165dc54602f0001,lop=PING,est=1537000478725,to=30000,lcxid=0x3,lzxid=0x31,lresp=1537000778393,llat=0,minlat=0,avglat=1,maxlat=15)
```

#### 健康信息
```sh
[root@localhost ~]# echo mntr | nc 10.1.18.133 2181
zk_version  3.4.8--1, built on 02/06/2016 03:18 GMT
zk_avg_latency  1
zk_max_latency  15
zk_min_latency  0
zk_packets_received 76
zk_packets_sent 75
zk_num_alive_connections    2
zk_outstanding_requests 0
zk_server_state standalone
zk_znode_count  16
zk_watch_count  0
zk_ephemerals_count 1
zk_approximate_data_size    237
zk_open_file_descriptor_count   29
zk_max_file_descriptor_count    4096
```

#### watch数量
```sh
[root@localhost ~]# echo wchs | nc 10.1.18.133 2181
0 connections watching 0 paths
Total watches:0
```

### zk 集群搭建
1.伪分布式 端口号不一样 ip一样的
` cp zookeeper-3.4.8 zookeeper2 -rf`
`vi zoo.cfg`