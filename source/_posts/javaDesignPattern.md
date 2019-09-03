---
title: 设计模式
date: 2018-10-23 13:30:49
tags: [java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
### 桥接模式
解决多个变化维度

### 访问者模式
二次多态实现。对编译完的类结构添加新方法。
缺点是添加的Visitor接口必须知道原来的Element类有多少个子类



### 命令模式
封装命令为一个对象，发送者和消费者解耦
命令队列模式



依赖关系 虚线，指向被使用的 （参数关系、返回值）
![umlyilai.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/umlyilai.jpg)

关联关系 实线 一般是一个类中有另一个类的对象
![umlguanlian.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/umlguanlian.jpg)

继承关系 空心三角，指向父类（父类不知道子类）

组合关系，实心菱形 可以有基数
![umlzuhe.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/umlzuhe.jpg)

聚合关系 空心菱形 has a 独立生命周期 整体局部（大雁菱形-箭头大雁）
![umljuhe.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/umljuhe.jpg)

实现关系
![umlinterface.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/umlinterface.jpg)

简单工厂模式：不依赖具体的类，根据参数传入工厂返回具体类，并用泛型接收。
![pdfactory.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pdfactory.jpg)
例子 jdbc根据参数不一样创建不同的驱动

工厂方法：用泛型工厂调用具体的类的工厂 
![pdfactory2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pdfactory2.jpg)
至少添加类的时候不用改工厂








