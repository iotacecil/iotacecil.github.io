---
title: produbbo
date: 2019-03-01 14:49:47
tags:
category: [项目流程]
---

### Dubble: Java RPC框架
1)面向接口的远程调用 2）智能容错和负载均衡 3）服务注册和发现

RPC：
远程过程调用协议 ，C/S模式，通过网络。
生产者：注册发布接口
消费者：订阅调用接口
注册中心：Zookeeper

消费者向注册中心订阅，会收到注册中心的通知notify
![dubbomodel.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/dubbomodel.jpg)

