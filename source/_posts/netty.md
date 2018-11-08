---
title: netty
date: 2018-06-04 09:32:40
tags:
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
自治：无主从关系
边缘部分：端系统
核心部分：路由器

链路带宽： 主机发送数据的速率
传播速率: 2 x 10^8  200m / us 
吞吐量： 单位时间内 通过 信道，接口的数据量 （小于带宽）
时延：发送（传输）/传播/排队/处理
时延带宽积bit:某段链路现在有多少bit 传播时延(s) x 带宽
利用率：有数据通过的时间


### select模型
1. 一个进程打开fd（文件描述符）有限1024/2048？ （最大并发数）
`FD_SETSIZE` 在哪
2. 每次select调用会扫描所有fd
3. 内核拷贝fd的消息到用户空间

### epoll
https://segmentfault.com/a/1190000003063859
https://www.cnblogs.com/xiehongfeng100/p/4636118.html
最大打开的文件数量（并发量）
`cat /proc/sys/fs/file-max`


### mui文档
http://dev.dcloud.net.cn/mui/util/
http://www.html5plus.org/doc/zh_cn/webview.html

### 阻塞与非阻塞是线程访问资源是否就绪的一种处理方式

### 同步和异步 数据访问的机制 数据处理完毕后会通知线程

{% qnimg IOs.jpg %}

### 同步阻塞BIO
一个线程一个连接，用线程池 伪异步io

### NIO 同步非阻塞IO
一个server一个selector多路复用器，是一个单线程，client注册到selector，每个client创建一个channel（双向通道），数据读写都会到缓冲区buffer，非堵塞地读取buffer
客户端增加不会影响selector性能

同步表示要Selector主动轮询channel数据准备好没有
异步是等人通知

### AIO 异步非阻塞IO NIO2.0
在NIO原有基础上，读写的返回类型是Feature对象，Feature有事件监听,等待通知回调

### Netty三种线程模型
Reactor线程模型 
1. 单线程模型 一个NIO线程处理所有请求
2. 多线程模型，一组NIO县城处理IO操作，reactor线程池
3. 主从线程模型，两个线程池，一组用于接收请求，一组用于处理IO

{% qnimg handler.jpg %}

### HTTP服务器
主从模型
```java
public class HelloServer {
    public static void main(String[] args) throws InterruptedException {
        //主线程组
        EventLoopGroup parentGroup = new NioEventLoopGroup();
        //从线程组
        EventLoopGroup childGroup = new NioEventLoopGroup();
        //启动类
        try {
            ServerBootstrap serverBootstrap = new ServerBootstrap();
            //设置主从线程组和双向通道和child的处理器
            serverBootstrap.group(parentGroup, childGroup)
                    .channel(NioServerSocketChannel.class)
                    .childHandler(new HelloServerInitializer());
            //启动server 同步方式
            ChannelFuture channelFuture = serverBootstrap.bind(8088).sync();
            //监听
            channelFuture.channel().closeFuture().sync();
        }finally {
            parentGroup.shutdownGracefully();
            childGroup.shutdownGracefully();
        }
    }
}
```
初始化child线程的处理器pipLine
```java
public class HelloServerInitializer extends ChannelInitializer<SocketChannel>{
    @Override
    protected void initChannel(SocketChannel channel) throws Exception {
        //获得管道
        ChannelPipeline pipeline = channel.pipeline();
        pipeline.addLast("HttpServerCodec",new HttpServerCodec());
        pipeline.addLast("customHandler",new CustomHandler());
    }
}
```
添加自定义的http处理拦截
```java
//入站拦截
public class CustomHandler extends SimpleChannelInboundHandler<HttpObject> {
    @Override
    protected void channelRead0(ChannelHandlerContext ctx, HttpObject msg) throws Exception {
        //从上下文对象里获得当前channel
        System.out.println(msg.toString());
        System.out.println("--------------");
        Channel channel = ctx.channel();
        //发送了两次，因为有个图标的请求
        //没加路由，所有所有访问8088的请求都会被拦截
        if(msg instanceof HttpRequest){
            //远程地址
            System.out.println(channel.remoteAddress());
            //消息big-endian buffer
            ByteBuf content  = Unpooled.copiedBuffer("hello netty", CharsetUtil.UTF_8);
            //Connection: keep-alive 1.1默认开启
            FullHttpResponse response = new DefaultFullHttpResponse(HttpVersion.HTTP_1_1,
                    HttpResponseStatus.OK,content);
            //数据类型
            response.headers().set(HttpHeaderNames.CONTENT_TYPE,"text/plain");
            //长度bytes
            response.headers().set(HttpHeaderNames.CONTENT_LENGTH,content.readableBytes());
            //写到缓冲区再刷到客户端
            ctx.writeAndFlush(response);
        }
    }
}
```
测试`curl 192.168.3.100:8088`
```
--------------
DefaultHttpRequest(decodeResult: success, version: HTTP/1.1)
GET / HTTP/1.1
User-Agent: curl/7.29.0
Host: 192.168.3.100:8088
Accept: */*
--------------
/192.168.3.109:58586
--------------
EmptyLastHttpContent
--------------
```

生命周期 curl每次发送完会关闭 没有长链接
重写`SimpleChannelInboundHandler`的方法
```
handlerAdded
channelRegistered
channelActive
--------------
DefaultHttpRequest(decodeResult: success, version: HTTP/1.1)
GET / HTTP/1.1
User-Agent: curl/7.29.0
Host: 192.168.3.100:8088
Accept: */*
--------------
/192.168.3.109:58588
--------------
EmptyLastHttpContent
--------------
channelReadComplete
channelReadComplete
channelInactive
channelUnregistered
handlerRemoved
```

### 实时通信
ajax轮询、Long pull、websocket

### 零拷贝
java读文件:
io流->缓冲区->java堆
netty NIO直接开辟新的堆内存 从io流直接到堆

### 实现一个简单的协议
{% qnimg protocolUtil.jpg %}
1.客户端request请求协议
```java
public class Request {
    //编码
    private byte encode;
    //指令
    private String command;
    //命令长度
    private int commandLength;
}
```
2.服务器response响应
```java
public class Response {
    private byte encode;
    private int responseLength;
    //响应内容
    private String response;
}
```
3.Server:
```java
ServerSocket server = new ServerSocket(4567);
while(true){
    Socket client = server.accept();

    //客户端数据通过协议解码Request
    InputStream input = client.getInputStream();
    Request request = ProtocolUtil.readRequest(input);
    OutputStream output = client.getOutputStream();

    //封装response,根据客户端请求回应hello或者再见
    Response response = new Response();
    response.setEncode(Encode.UTF8.getValue());
    if(request.getCommand().equals("HELLO")){
        response.setResponse("hello!");
    }else{
        response.setResponse("bye bye!");
    }
    response.setResponseLength(response.getResponse().length());

    //通过协议发送
    ProtocolUtil.writeResponse(output, response);
    client.shutdownOutput();
}
```
4.编码类1字节长度：
```java
public enum Encode {

    GBK((byte)0), UTF8((byte)1);
    
    private byte value = 1;
    
    private Encode(byte value){
        this.value = value;
    }
    
    public byte getValue(){
        return value;
    }}
```

5.Client端：
```java
Request request = new Request(Encode.UTF8.getValue(),"HELLO","HELLO".length());
Socket client = new Socket("127.0.0.1",4567);
OutputStream output = client.getOutputStream();

//通过协议发送
ProtocolUtil.writeRequest(output, request);

//读取服务响应
InputStream input = client.getInputStream();
Response response = ProtocolUtil.readResponse(input);
client.shutdownOutput();
```
6.协议实现对socket流的编码解码：
`InputStream->Request->OutputStream`

`InputStream->Response->OutputStream`

```java
public class ProtocolUtil {
    //1.read解码request
    public static Request readRequest(InputStream input) throws IOException{
       //1字节编码
        byte[] encodeByte = new byte[1];
        input.read(encodeByte);
        byte encode = encodeByte[0];
        
        //4个字节是命令的长度
        byte[] commandLengthBytes = new byte[4];
        input.read(commandLengthBytes);
        int commandLength = ByteUtil.bytes2Int(commandLengthBytes);
        
        //读命令
        byte[] commandBytes = new byte[commandLength];
        input.read(commandBytes);
        String command = "";
        command = new String(commandBytes,Encode.GBK.getValue() == encode?"GBK":"UTF8");
        
        //封装返回
        return new Request(encode,commandLength,command);
    }

    //3.发送请求给服务端
    public static void writeRequest(OutputStream output,Request request) throws IOException{
        //注意read和write的字节顺序要相同
        output.write(request.getEncode());
        output.write(ByteUtil.int2ByteArray(request.getCommandLength()));
        output.write(request.getCommand().getBytes(Encode.GBK.getValue() == request.getEncode()?"GBK":"UTF8"));
        output.flush();
    }
    public static Response readResponse(InputStream input) throws IOException{
        //...
    }
    public static void writeResponse(OutputStream output,Response response) throws IOException{//...
    }
}
```
读取写入响应长度的byte<->int
java是大端字节序
> TCP/IP协议规定了在网络上必须采用网络字节顺序，也就是大端模式。对于char型数据只占一个字节，无所谓大端和小端。而对于非char类型数据，必须在数据发送到网络上之前将其转换成大端模式。

`ByteOrder.nativeOrder()`LITTLE_ENDIAN小端
Big-endian：将高序字节存储在起始地址（高位编址）
```
低地址                                            高地址
---------------------------------------------------->
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| byte[0]=12 |      34    |     56      |     78    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
Little-endian：将低序字节存储在起始地址（低位编址）
```
低地址                                            高地址
---------------------------------------------------->
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| byte[0]=78 |      56    |     34      |     12    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

4位大端数据转换{0,0,0,1}<->1
```java
public static int bytes2Int(byte[] bytes) {
    System.out.println(Arrays.toString(bytes));
    int num = bytes[3] & 0xFF;  
    num |= ((bytes[2] << 8) & 0xFF00);  
    num |= ((bytes[1] << 16) & 0xFF0000);  
    num |= ((bytes[0] << 24) & 0xFF000000);
    return num;
    } 

public static byte[] int2ByteArray(int i) {   
    byte[] result = new byte[4];   
    result[0] = (byte)((i >> 24) & 0xFF);
    result[1] = (byte)((i >> 16) & 0xFF);
    result[2] = (byte)((i >> 8) & 0xFF); 
    result[3] = (byte)(i & 0xFF);
    return result;
    }
```
利用http协议实现rpc

### 序列化比较 
用字节数组流

#### Hessian
hessian-4.0.7.jar
`Object`->`HessianOutput(ByteArrayOutputStream)`->`.write(Objcet)`->`.toByteArray()`
`HessianInput(ByteArrayInputStream())`->`.readObject()`
```java
Person zhangsan = new Person("zhangsan");
//序列化 object->outputStream
ByteArrayOutputStream bos = new ByteArrayOutputStream();
HessianOutput hot = new HessianOutput(bos);
hot.writeObject(zhangsan);
byte[] zhangsanByte = bos.toByteArray();

//反序列化
ByteArrayInputStream ips = new ByteArrayInputStream(zhansanByte);
HessianInput hin = new HessianInput(ips);
Person person = (Person)hi.readObject();
```

#### Java自带的序列化
`ObjectOutputStream(ByteArrayOutputStream)`->`writeObject`0>`.toByteArray()`
```java
Person zhangsan = new Person("zhangsan");
//序列化 写到字节数组流->写到对象流
ByteArrayOutputStream os = new ByteArrayOutputStream();
ObjectOutputStream out = new ObjectOutputStream(os);
out.writeObject(zhangsan);
byte[] zhangsanByte = os.toByteArray();
//反序列化
ByteArrayInputStream is = new ByteArrayInputStream(zhansanByte);
ObjectInputStream in = new ObjectInputStream(is);
Person person = (Person)in.readObject();
```

#### jackson序列化 字符串流
jackson-all-1.7.6.jar
```java
//序列化
String personJson = null;
ObjectMapper mapper = new ObjectMapper();
StringWriter sw = new StringWriter();
JsonGenerator gen = new JsonFactory().createJsonGenerator(sw);
mapper.writeValue(gen, person);
gen.close();
personJson = sw.toString();
//反序列化
Person zhangsan = (Person)mapper.readValue(personJson, Person.class);
```

#### xml xstream-1.4.4.jar
```xml
<pppp>
  <name>zhangsan</name>
  <age>18</age>
  <address>hangzhou,china</address>
  <birth>2018-08-25 11:17:03.450 UTC</birth>
</pppp>
```

```java
//将person对象序列化为XML
XStream xStream = new XStream(new DomDriver());
//设置Person类的别名
xStream.alias("pppp", Person.class);
String personXML = xStream.toXML(person);

//将XML反序列化还原为person对象
Person zhangsan = (Person)xStream.fromXML(personXML);
```

### 基于tcp的服务调用
{% qnimg tcprpc.jpg %}

服务接口
```java
public interface SayHelloService{
    public String sayHello(String str);
}
```

Consumer
```java
//调用的接口名称
String interfaceName = SayHelloService.class.getName();
//调用的方法
Method method = SayHelloService.class.getMethod("sayHello", java.lang.String.class);
//传给服务端方法的参数
Object[] arguments = {"hello"};
Socket socket = new Socket("127.0.0.1", 1234);
//接口名，方法名，参数类型，参数 传到服务器
ObjectOutputStream output = new ObjectOutputStream(socket.getOutputStream());
output.writeUTF(interfaceName); 
output.writeUTF(method.getName()); 
output.writeObject(method.getParameterTypes());  
output.writeObject(arguments);  

//接收远程方法的结果
ObjectInputStream input = new ObjectInputStream(socket.getInputStream()); 
Object result = input.readObject();
```

Provider
```java
//所有对外提供的服务注册到map里
private static Map<String,Object> services = new HashMap<String,Object>();
static{
    services.put(SayHelloService.class.getName(), new SayHelloServiceImpl());
}
//main
ServerSocket server = new ServerSocket(1234);
while(true) {  
    Socket socket = server.accept();
    ObjectInputStream input = new ObjectInputStream(socket.getInputStream());
    //接口名称
    String interfaceName = input.readUTF(); 
    //方法名称
    String methodName = input.readUTF();  
     //参数类型
    Class<?>[] parameterTypes = (Class<?>[])input.readObject(); 
    //参数对象
    Object[] arguments = (Object[])input.readObject();  

    //执行方法
    Class interfaceClass = Class.forName(interfaceName);
    //实现的具体类
    Object service = service.get(interfaceName);
    Method method = interfaceClass.getMethod(methodName,parameterTypes);
    Objcet result = method.invoke(service,arguments);
    ObjectOutputStream output = new ObjectOutputStream(socket.getOutputStream());
    output.writeObject(result);
}
```
具体实现类
```java
public class SayHelloServiceImpl implements SayHelloService {
    @Override
    public String sayHello(String str) {
        if(helloArg.equals("hello")){
            return "hello";
        }else{
            return "bye bye";
        }}}
```
报错初始化堆空间不够`-Xmx3550m`

### 基于HTTP的RPC
{% qnimg httprpc.jpg %}
servlet-api.jar
jackson-all-1.7.6.jar
httpcore4.2.4.jar
httpclient-4.2.5.jar
commons-logging-1.1.1.jar

接口
```java
public interface BaseService {
    public Object execute(Map<String,Object> args);
}
```

实现：
```java
public class SayHelloService implements BaseService{

    public Object execute(Map<String, Object> args) {
        //request.getParameterMap() 取出来为array,此处需要注意
        String[] helloArg = (String[]) args.get("arg1");
        
        if("hello".equals(helloArg[0])){
            return "hello";
        }else{
            return "bye bye";
        }}}
```

消费者：
```java
public class ServiceConsumer extends HttpServlet{

}
```


### 排队延迟
> 路由器必须检测分组的首部，以确定出站路由，并且还可
能对数据进行检查，这些都要花时间。由于这些检查通常由硬件完成，因此相应的
延迟一般非常短，但再短也还是存在。最后，如果分组到达的速度超过了路由器的
处理能力，那么分组就要在入站缓冲区排队。数据在缓冲区排队等待的时间，当然
就是排队延迟。
{% qnimg bufferbloat.jpg %}

### 光纤RTT 应用必须在几百  ms 之内响应。
{% qnimg RTT.jpg %}
> 在软件交互中，哪怕 100~ 200 ms 左右的延迟，我们中的大多数人就会感觉到“拖拉”；如果超过了 300  ms 的
门槛，那就会说“反应迟钝”；而要是延迟达到 1000  ms（1s）这个界限，很多用户
就会在等待响应的时候分神，有人会想入非非，有人恨不得忙点别的什么事儿。

带宽：
通过波分复用（WDM，Wavelength-Division  Multiplexing）技术，光纤可以同时传
输很多不同波长（信道）的光
到 2010 年初，研究人员已经可以在每个信道中耦合 400 多种波长的光线，最大容
量可达 171  Gbit/s，而一条光纤的总带宽能够达到 70  Tbit/s 

### TCP fast open TFO
{% qnimg TFO.jpg %}
每个 ACK 分组都会携带相应的最新 接收窗口大小rwnd 值，以便两端动态调整数据流速，使之适应发送端和接收端的容量及处理能力。
{% qnimg scalling.jpg %}

### RARP
无盘工作站，没有存储，无法记录自己的IP地址，用物理地址向服务器查询自身IP地址。

数据链路层、网络层、传输层在内核空间中实现（内核缓冲区）
应用层在用户空间

### 子网掩码
https://blog.csdn.net/yinshitaoyuan/article/details/51782330

{% qnimg zwym.jpg %}
{% qnimg zwhf.jpg %}
得到子网的网络地址
{% qnimg wldz.jpg %}

每个子网络能容纳500台主机，它的子网掩码是多少？
500->111110100 一共9位
子网掩码255.255.255.255从后向前的9位变成0
（11111111.11111111.11111110.00000000）255.255.254.0。

3、利用子网掩码计算最大有效子网数

A类IP地址，子网掩码为255.224.0.0，它所能划分的最大有效子网数是多少？

①将子网掩码转换成二进制表示11111111.11100000.00000000.00000000

②统计一下它的网络位共有11位

③A类地址网络位的基础数是8，二者之间的位数差是3

④最大有效子网数就是2的3次方，即最多可以划分8个子网络。



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

{% qnimg backlog.jpg %}

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
