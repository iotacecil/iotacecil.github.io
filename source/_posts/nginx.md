---
title: 'nginx'
date: 2018-04-02 13:18:31
tags:
category: [JVMlinux常用备注nginxredis配置]
---

# Nginx
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



