---
title: 数据库相关
date: 2019-03-28 10:18:54
tags:
---
### 内存表
内存表会把表结构存放在磁盘上，把数据放在内存中。

### 临时表` CREATE TEMPORARY TABLE`
临时表只在当前连接可见，当关闭连接时，Mysql会自动删除表并释放所有空间。
临时表默认的是MyISAM

### innodb自增id在内存
1、一张表，里面有ID自增主键，当insert了17条记录之后，删除了第15,16,17条记录，再把Mysql重启，再insert一条记录，这条记录的ID是18还是15 ？
(1)如果表的类型是MyISAM，那么是18
因为MyISAM表会把自增主键的最大ID记录到数据【文件】里，重启MySQL自增主键的最大ID也不会丢失
（2）如果表的类型是InnoDB，那么是15
InnoDB表只是把自增主键的最大ID记录到【内存】中，所以重启数据库或者是对表进行OPTIMIZE操作，都会导致最大ID丢失

#### 自增id重复
插入过了17，删除之后插入又是17
MySQL采用执行类似select max(id)|1 from t1;方法来得到AUTO_INCREMENT。而这种方法就是造成自增id重复的原因。