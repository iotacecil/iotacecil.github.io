---
title: netty
date: 2018-06-04 09:32:40
tags:
---
### 子网掩码

![zwym](/images/zwym.jpg)
![zwhf](/images/zwhf.jpg)
得到子网的网络地址
![wldz](/images/wldz.jpg)



以太网 Frame帧
IP packet 分组（不是分片
TCP segment 分节
应用层 message消息

### NIO:Reactor模式 
reactor对所有客户端的socket套接字做事件处理，派发到不同的线程。

### AIO:Proactor模式
动作完成后调用handler

---
### 网络计时Timekeeping
时间：一天86400秒 365天 假设70年 精度为10位有效数字
时钟：振荡器oscillator(14.318MHz+计数器counter
<the science of time keeping>
Timestamp时间点。是指针 不能相加 只能相减。
算中间时间：T1+(T2-T1)/2
Time interval 是int
时间的一阶导是频率二阶导是jitter
tsc cpu内部的周期计数器 现在不随cpu频率变化。
cpu频率以G 10^9 能精度到1ns

NTP网络时间同步 基于UDP
算出时间差error:[(T4+T1)-(T2+T3)]/2后调整offset和frequency 
连续调整 避免时钟跳变。如果时间差小于128ms 缓慢调下去。
频率跳变时间会阶越效应

当同一个ip后面多个服务器，没有session会发到不同的服务器上
NTP在服务端有两个误差，1从网卡内核到用户进程接收计时 2用户进程开始发送计时到内核网卡发出。两个时间可能不对称。

以太网最小帧长64字节 
ip20字节 udp 8字节 tcp头20字节tcp还有时间戳option12字节
ip-tcp52字节


---
TCP close发送太早可能发生RST分解。连接重置。
netcat光发，不接收响应，ttcp接收到服务器ack再发第二个包

---
本机测试从/dev/zero读取1G的速度
`nc -l 5000 >/dev/null &`
`dd if = /dev/zero bs = 1M count = 1000 |nc localhost 5000`
用io重定向测试本地文件传输速度
`time nc localhost 5001 < file.file`
用irb计算 10^10(1G)/9.4(s)/10^6 = M/s 得到磁盘性能 第二次time会快很多因为已经在缓存里了
监测数据`nc -l 50001 |pv -W > /dev/null` pv的单位是二进制，dd用的十进制
---
文件->tcp->文件`dd |nc,nc -l >/dev/null`6次用户与内核间拷贝 
1. /dev/zero->dd 
2. dd->pipe 
3. pipe->nc
4. nc->TCP
5. TCP->服务端nc 
---

`sysctl -A |grep range`本机端口范围
### TCP自连接
1发起链接时会从`ipv4.ip_local_port_range`中选择临时端口号
2向服务器发送SYN
TCP的同时打开，3000端口无进程监听，但是tcp链接打开了3000端口，当作有监听，形成自连接

### pipelining数，连发n个收一个ack
用阻塞编程 有上限，超过会收不到ack

### TTCP tcp实现的检测性能
muduo 用非阻塞的muduo库写的ttcp.cc
`stream->setNoDelay(true)` 不用等ack发送


### Epoll 可扩展I/O时间通知特性
比旧的POSIX select和poll系统调用性能更好。epoll是linux非阻塞网络编程的事实标准。
Linux下：
将NioEventLoopGroup换成`EpollEventLoopGroup`
NioServerSocketChannel.class换成`EpollServerSocketChannel.class`


回调方法：指向已经被提供给另一个方法的 方法的引用
---
`OutboundHandler`出站：从客户端到服务端 ：链尾取到链头
`Inbound` 入站：链头取到链尾
handler添加到pipline时会被分配一个ChannelHandler`Context`表示绑定。
1.直接写道channel中，从Pipeline尾端开始流动
2.写到handler关联的Context对象 从从pipeline从下一个handler开始流动

ChannelHandler的三个子类：编码器，解码器 SimpleC..Inbound..
---
### netty
Ioc 好莱坞原则
Reactor模型 应用向中间人注册回调(event handler)  中间人轮询，IO就绪后中间人产生事件，通知handler处理。

第三种reactor模型，将reactor分两部分。mainReactor负责监听server socket的链接（外部client的链接）
subReactor 负责读写网络数据。

netty支持单线程、多线程、主从reactor模型。

### 创建2个线程组
多个线程 线程内串行化 避免线程竞争 无锁

![tcp](/images/backlog.jpg)

1. 操作系统维护TCP 的SYN队列 将网络请求插入队列，返回SYN/ACK 两次握手 半链接（SYN_RCVD) （主reactor）
2. 第三次握手，收到ACK请求，操作系统将SYN队列中的请求转移到ACCEPT队列（阻塞队列）全链接(ESTABLISHED) （子reacotr）
3. 服务器上的应用队列监听阻塞队列（ACCEPT) 
accept+SYN队列=backlog长度
syn长度：/proc/sys/net/ipv4/tcp_max_syn_backlog =1024
accept长度：/proc/sys/net/core/somaxconn =128

### 引导 构建netty的配置
服务端
```java
serverBootstrap.group(pgroup,cgroup).channel(NioSocketChannel.class)
.option(ChannelOption.SO_RCVBUF,32*1024)//接收缓存大小
```
客户端引导`Bootstrap` 连接到主机和端口
服务端引导`ServerBootstrap` 绑定一个本地端口
客户端只需一个EventLoopGroup
客户端需要2个，管理两组不同的Channel。
1. `ServerChannel`绑定本地端口并监听 连接请求创建channel
2. 第二组处理传入客户端连接的channel 给channel分配eventloop

Netty的buffer有两个指针，读写指针互不影响，NIO只有一个指针要flip
directByteBuf堆外 零拷贝

客户端 写给服务端
```java
//直接把字节数组包装成buffer
ctx.writeAndFlush(Unpooled.wrappedBuffer("响应".getBytes()));
```

服务器端读取
```java
try{
ByteBuf buf =(ByteBuf)msg;
byte[] responseData = new byte[buf.readableBytes()];
buf.readBytes(responseData);
}finally{
    ReferenceCountUtil.release(msg);
}
```
---
### Netty阻塞io服务端
```java
EventLoopGroup group = new OioEventLoopGroup();
try {
    ServerBootstrap b = new ServerBootstrap();
    b.group(group)
    .channel(OioServerSocketChannel.class)
    .localAddress(new InetSocketAddress(port))
    //用于回调
    .childHandler(new ChannelInitializer<SocketChannel>() {
        @Override
        public void initChannel(SocketChannel ch)
                throws Exception {
                ch.pipeline().addLast(
                    new ChannelInboundHandlerAdapter() {
                        @Override
                        public void channelActive(
                                ChannelHandlerContext ctx)
                                throws Exception {
                            ctx.writeAndFlush(buf.duplicate())
                                    .addListener(
                                            ChannelFutureListener.CLOSE);
                                }
                            });
                }
            });
    ChannelFuture f = b.bind().sync();
    f.channel().closeFuture().sync();
}
```
### 非阻塞服务端
```java
NioEventLoopGroup group = new NioEventLoopGroup();
try {
    ServerBootstrap b = new ServerBootstrap();
    b.group(group).channel(NioServerSocketChannel.class)
            .localAddress(new InetSocketAddress(port))
            ...
        }
```

客户端：
```java
public void start()
throws Exception {
EventLoopGroup group = new NioEventLoopGroup();
try {
    Bootstrap b = new Bootstrap();
    b.group(group)
        .channel(NioSocketChannel.class)
        .remoteAddress(new InetSocketAddress(host, port))

        .handler(new ChannelInitializer<SocketChannel>() {
            @Override
            public void initChannel(SocketChannel ch)
                throws Exception {
                    //Pipeline为handler编排顺序
                ch.pipeline().addLast(
                    //自定义的handler
                     new EchoClientHandler());
            }
        });
    ChannelFuture f = b.connect().sync();
    f.channel().closeFuture().sync();
} finally {
    group.shutdownGracefully().sync();
}
}
```
