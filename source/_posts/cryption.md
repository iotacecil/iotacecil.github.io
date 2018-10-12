---
title: 加密
date: 2018-03-27 16:40:55
tags: [加密]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
# 安全

## 基于角色->属性的加密算法 外边缘计算的加密算法

## java MD
MD家族长128，MD2,MD5 JDK有实现 MD4（电驴)Bouncy Castle

# 报文摘要：固定长度的摘要 类似消息验证码MAC
关键：找到两段内容不同而摘要相同的数据在计算上是不可能的

## 消息验证码MAC：计算过程用了密钥`javax.crypto.Mac`
1. 数据用散列函数计算出消息验证码HMAC
2. 消息验证码加载原始数据后
3. 用密钥对整个数据加密后传输

# 数字签名`security.Signature` 用于验证身份
A要验证B的身份：
1. B用私钥对消息加密发送给A
2. A用公钥解密

# SSL协议
1. 身份验证（钓鱼网站）数字签名证书
2. 数据窃取：数据传输加密
3. 数据串改：数据+消息验证码，接收者完整性验证
流程
1. 客户端向服务器确认SSL协议和加密算法。（可请求验证服务器身份）
2. 服务器 发送数字签名给客户端 也可以向客户端验证身份
3. 客户端用私钥对自己的数字证书加密发送给服务器。生成[数据传输]用的密钥，用服务器的公钥加密发送给服务器。（数据传输是对称加密，客服端和服务器使用相同密钥）
4. 服务端验证完客户端身份，切换到数据传输直到关闭。

## 数字证书=身份信息+公钥。被信任机构的私钥加密，浏览器公钥验证证书合法。

# HTTPS

# RSA
- 非对称加密算法：
	1. 甲方获取乙方的公钥，然后用它对信息加密。
	2. 乙方得到加密后的信息，用私钥解密。
1. n = a*b(a，b质数) n->二进制位数为密钥长度（1024）
2. 计算n的欧拉函数φ(n)
3. 选择65537 or 其它小于φ(n)并与φ(n)互质的整数e
4. 计算e对φ(n)的【模反元素】d
`ex + φ(n)y = 1`求解数对x,y中的x
[扩展欧几里得](https://zh.wikipedia.org/wiki/%E6%89%A9%E5%B1%95%E6%AC%A7%E5%87%A0%E9%87%8C%E5%BE%97%E7%AE%97%E6%B3%95)
5. (n,e)为公钥(n,d)为私钥
- 当n被因式分解，d可以算出 被破解

# AES

# 安全漏洞
Network-Doc
- **http请求**
1. Referer 防止CSRF漏洞
- **http响应**
2. 302 跳转 Location:跳转地址
3. Set-Cookie:颁发凭证
---
Application 查看Cookie
- BOM
1. document.cookie 添加cookie document.cookie="aaaa"
2. window.location.href获取页面URL
3. window.navigator.userAgent 获取浏览器信息
4. window.open("http://baidu.com") 打开页面
---
- XSS漏洞测试
prompt(,)提示弹窗
---
- WEB服务架构
![javaee](\images\javaee.jpg)
---
- SQL
1. union 连接两个select 不显示重复的；union all
2. socket路径：show global variables like 'socket';
---
> 客户端：XSS(跨站脚本注入):CSRF(跨站请求伪造) 点击劫持，URL跳转
> 服务端：SQL注入 命令注入 文件类操作

#### XSS漏洞：Cross Site Script
存储型 反射型 DOM型
- **存储型**
1. `<img src="#" onerror="alert()">`写在评论框，发送给后台 图片加载失败触发onerror事件
2. XSS 脚本存储在数据库中

- **反射型** 后端写入
url的参数中 `?name = <image src = @ onerror= alert()>`
- **DOM**型
`window.location.hash`url的hash中`#`后面的值填到innerHTML

#### CSRF（XSRF）
用已登录身份以用户名义非法操作
`<body onload = "sbm()"`页面加载自动提交表单
`smt(){ .getbyID("id").submit()`调用表单提交
form表单提交有明显页面跳转，将恶意页面用iframe嵌入 width,height=0
防止触发查看源代码： `view-source:url`

#### 点击劫持 UI覆盖攻击
用iframe设置height,width:100%,opaocity:0;z-index=2;
将iframe上的提交按钮隐藏在页面按钮之下

#### url页面跳转
META跳转 等待5秒后跳转
?url = 短链接
```js
<meta http-equiv = "Refresh" content = "5;url<?php echo $url?>"
```

#### SQL注入
mysql注释`-- `
闭合、注释 where name = 'admin`'--` and passwd = ''
数据和代码未分离
- union
1. 查看mysql版本 2. 用户名和密码

#### DOS命令
1. `net user`用户名
2. 