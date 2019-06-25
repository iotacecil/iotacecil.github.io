---
title: 'Nginx/Http/HSTS'
date: 2018-04-02 13:18:31
tags: [网络]
category: [网络]
---
对于Http1.1协议，如果响应头中的Transfer-encoding为chunked传输，则表示body是流式输出，body会被分成多个块，每块的开始会标识出当前块的长度，此时，body不需要通过content-length来指定，客户端会接收数据直到服务端主动断开连接

### 浏览器缓存
### Cache-control（秒）/Pragma 
Pragma : http1.0用的
Cache-control 优先级比Expires高
![httpcachepramgma.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/httpcachepramgma.jpg)
指定缓存多少秒 和服务端时间无关。

### Expires:日期 带时区的时间
是服务端时间
浏览器发出请求之前检查页面这个字段，过期了重新发请求。

### Last-Modified/Etag
服务器在响应中返回Last-Modified。浏览器会在请求头加if-Modified-Since，如果缓存是最新的 返回304.

Etag：服务器为每个页面分配编号。用编号区分这个页面是否最新。

### dns域名解析10步
1.浏览器缓存
2.操作系统hosts
3.LDNS  SPA
4.Root Server
5.主域名服务器(gTLD) 顶级域名服务器 .com/.cn 全球只有13台左右
6.LDNS向gTLD查询
7.gTDL 找到域名的 Name Server（注册的）
8.Name Server 返回ip和TTL给LDNS。
9.LDNS缓存 并设置TTL
10.用户拿到ip并设置TTL保存在本地。

一般都到域名的注册服务器去解析，一般都会CNAME到CDN的DNS负载均衡服务器

### JVM在InetAddress类也会缓存DNS结果
InetAddress解析域名 必须是单例模式

### CDN = 镜像+cahce+整体均衡负载
目标：可扩展 安全 可靠 响应 执行

https://imququ.com/post/my-nginx-conf-for-wpo.html

## nginx.conf
下列有关Nginx配置文件nginx.conf的叙述正确的是
正确答案: A D   你的答案: A B C D (错误)
Anginx进程数设置为CPU总核心数最佳
B虚拟主机配置多个域名时，各域名间应用逗号隔开(空格？)
C.sendfile on;表示为开启高效文件传输模式，对于执行下载操作等相关应用时，应设置为on
D设置工作模式与连接数上限时，应考虑单个进程最大连接数(最大连接数=连接数*进程数）

#### sendfile 零拷贝 实际上是 Linux2.0+以后的推出的一个系统调用
sendfile 是一个系统调用，直接在内核空间完成文件发送，不需要先 read 再 write，没有上下文切换开销。不过需要注意的是，sendfile 是将 in_fd 的内容发送到 out_fd 。而 in_fd 不能是 socket ， 也就是只能文件句柄。 

当 Nginx 是一个静态文件服务器的时候，开启 SENDFILE 配置项能大大提高 Nginx 的性能。

当 Nginx 是作为一个反向代理来使用的时候，SENDFILE 则没什么用了，因为 Nginx 是反向代理的时候。 in_fd 就不是文件句柄而是 socket，此时就不符合 sendfile 函数的参数要求了。

http://xiaorui.cc/2015/06/24/%E6%89%AF%E6%B7%A1nginx%E7%9A%84sendfile%E9%9B%B6%E6%8B%B7%E8%B4%9D%E7%9A%84%E6%A6%82%E5%BF%B5/
1.系统调用sendfile()通过 DMA把硬盘数据拷贝到 kernel buffer，然后数据被 kernel直接拷贝到另外一个与 socket相关的 kernel buffer。这里没有 user mode和 kernel mode之间的切换，在 kernel中直接完成了从一个 buffer到另一个 buffer的拷贝。
2、DMA 把数据从 kernelbuffer 直接拷贝给协议栈，没有切换，也不需要数据从 user mode 拷贝到 kernel mode，因为数据就在 kernel 里。

在传统的文件传输方式（read、write/send方式），具体流程细节如下：

调用read函数，文件数据拷贝到内核缓冲区
read函数返回，数据从内核缓冲区拷贝到用户缓冲区
调用write/send函数，将数据从用户缓冲区拷贝到内核socket缓冲区
数据从内核socket缓冲区拷贝到协议引擎中
在这个过程当中，文件数据实际上是经过了四次拷贝操作： 硬盘—>内核缓冲区—>用户缓冲区—>内核socket缓冲区—>协议引擎

### HTTP
以下有关Http协议的描述中，正确的有
正确答案: A B C   你的答案: B C D (错误)
A.post请求一般用于修改服务器上的资源，对发送的消息数据量没有限制，通过表单方式提交
B.可以通过206返回码实现断点续传
C.HTTP1.1实现了持久连接和管线化操作以及主动通知功能，相比http1.0有大福性能提升
D.HTTP返回码302表示永久重定向，需要重新URI

http/1.1 字符串传输
持久链接：一个tcp链接里可以发送很多http请求。减少三次握手次数。
pipeline:
添加了host：

《Web性能权威指南》
![http2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/http2.jpg)
>是通过支持请求与响应的多路复用来减少延迟，通过压缩 HTTP
首部字段将协议开销降至最低，同时增加对请求优先级和服务器端推送的支持。

> 它改变了客户端与服务器之间交换数据的方式。
> 为实现宏伟的性能改进目标，HTTP  2.0 增加了新的二进制分帧数据层

![http2connect.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/http2connect.jpg)

> HTTP  2.0 通信都在一个连接上完成，这个连接可以承载任意数量的双向数据流。
> 每个数据流以消息的形式发送，而消息由一或多个帧组成，这些帧可以乱序发送，然后再根据每个帧首部的流标识符重新组装。

![http22.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/http22.jpg)

![sendrecv.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/sendrecv.jpg)
> HTTP 消息分解为独立的帧，交错发送，然后在另一端重新组装是 HTTP  2.0 最
重要的一项增强。

![http2better.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/http2better.jpg)

> http2:：浏览器可以在发现资源时立即分派请求，指定每个流的优先级，让服务器决定最优的响应次序。这样请求就不必排队了，既节省了时间，也最大限度地利用了每个连接。 

> 每个来源一个链接:，所有HTTP 2.0 连接都是持久化的，而且客户端与服务器之间也只需要一个连接即可。

![http2tcp.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/http2tcp.jpg)

http2：分帧传输二进制传输（不用连续）
信道复用 同一个链接多个请求
一个tcp链接并发http请求，不用等前一个请求接收到之后再发送。
server push推送。以前要先解析html再发送请求css/js。现在请求html就获取。

nginx开启http2 开启https才能http2
ALPN转称http1.1传给服务器
```json
server{
  listen 443 http2;
  server_name test.com;
  http2_push_preload on;
}
```
nodejs
```javascript
if(request.url === '/'){
  response.writeHead(200,{
    'Content-Type':'text/html',
    'Connection':'close',
    //http2的push
    'Link':'</test.jpg>;as=image;rel=preload'
  })
}
```
协议变成h2
`chrome://net-internals/#http2` 看pushed和 claimed 使用1个push到30个push的区别
https的握手过程


[http2性能测试](http2.akamai.com/demo/http2-lab.html)


## 1. 环境
1. 基本库
`yum -y install gcc gcc-c++ autoconf pcr^Cpcre-devel make automake`
2. 工具
`yum -y install wget httpd-tools vim`
3. 确认yum源可用
`yum list|grep gcc`
4. 关闭iptables规则
`iptables -L` `iptables -F`
5. 停用selinux
`getenforce`   `setenforce 0`
6. cd /opt mkdir

重启 `nginx -s reload`

## IO多路复用  使用epoll模型
[Linux文件描述符](https://blog.csdn.net/cywosp/article/details/38965239)
- <font color=HotPink>文件描述符（file descriptor<font>
> 是内核为了高效管理已被打开的文件所创建的索引，其是一个非负整数（通常是小整数），用于指代被打开的文件，所有执行I/O操作的系统调用都通过文件描述符。
`sysctl -a|grep fs.file-max`系统级别的最大打开文件数
`ulimit -n` 单个进程最大打开文件数

每一个文件描述符会与一个打开文件相对应，不同的文件描述符也会指向同一个文件。

`rpm -ql nginx` rpm包有哪些配置文件
/usr/share/nginx/html

## HSTS（HTTP Strict-Transport-Security）
* 是Web安全策略机制（web security policy mechanism）
[HSTS：](https://www.jianshu.com/p/caa80c7ad45c)
![https.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/https.jpg)
> 1. **建立起HTTPS连接之前存在一次明文的HTTP请求和重定向**（上图中的第1、2步），使得攻击者可以以中间人的方式劫持这次请求，从而进行后续的攻击，例如窃听数据，篡改请求和响应，跳转到钓鱼网站等。
- 
![jack_https.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/jack_https.jpg)
> 攻击者直接劫持了HTTP请求，并返回了内容给浏览器，根本不给浏览器同真实网站建立HTTPS连接的机会

- 当用户让浏览器发起HTTP请求时，浏览器将其转换为HTTPS请求，直接略过上述的HTTP请求和重定向，从而使得中间人攻击失效，规避风险。
![htps.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/htps.jpg)
1. HSTS 响应 Header：让浏览器得知，在接下来的一段时间内，当前域名只能通过HTTPS进行访问，并且在浏览器发现当前连接不安全的情况下，强制拒绝用户的后续访问要求。
`Strict-Transport-Security: <max-age=>[; includeSubDomains][; preload]`
> - max-age是必选参数，是一个以秒为单位的数值，它代表着HSTS Header的过期时间，通常设置为1年，即31536000秒。
> - ncludeSubDomains是可选参数，如果包含它，则意味着当前域名及其子域名均开启HSTS保护。
> - preload是可选参数，只有当申请将自己的域名加入到浏览器内置列表的时候才需要使用到它

- 对于启用了浏览器HSTS保护的网站，如果浏览器发现当前连接不安全，它将仅仅警告用户，而不再给用户提供是否继续访问的选择
2. 第一次访问：Preload List：
> 在浏览器里内置一个列表，只要是在这个列表里的域名，无论何时、何种情况，浏览器都只使用HTTPS发起连接。这个列表由Google Chromium维护，FireFox、Safari、IE等主流浏览器均在使用。

### nginx: hsts
`add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;`
> 一旦浏览器接收到HSTS Header（假如有效期是1年），但是网站的证书又恰好出了问题，那么用户将在接下来的1年时间内都无法访问到你的网站，直到证书错误被修复，或者用户主动清除浏览器缓存。**先将max-age的值设置小一些**



