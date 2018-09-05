---
title: redis
date: 2018-09-05 13:59:20
tags:
---
### 4.搭建redis服务器

```shell
cd /usr/local
tar -zvxf 
yum -y install gcc gcc-c++ libstdc++-devel
make MALLOC=libc
yum install tcl
make test
vi tests/integration/replication-2.tcl 1000->10000
make install
redis-server
vi redis.conf
    bind 127.0.0.1->0.0.0.0所有ip都能访问
    :/dae
    daemonize yes 允许后台执行
redis-server ./redis.conf
#Redis version=4.0.2, bits=64, commit=00000000, modified=0, pid=10217, just started
ps -ef |grep redis
#root     10218     1  0 10:42 ?        00:00:00 redis-server 0.0.0.0:6379
redis-cli
#给redis加密码
vi redis.conf
    :/requirepass
     # requirepass foobared -> requirepass 123456
#重启
redis-cli
    shutdown save
    exit
ps -ef | grep redis
redis-server ./redis.conf
redis-cli
    auth 123456
# 变成系统服务
cd utils
./install_server.sh
# 配置文件位置
    /usr/local/redis-4.0.2/redis.conf
# log位置
    /usr/local/redis-4.0.2/redis.log
# data位置
    /usr/local/redis-4.0.2/data
# 可执行文件路径
chkconfig --list |grep redis
# redis_6379        0:关 1:关 2:开 3:开 4:开 5:开 6:关
systemctl status redis_6379
systemctl stop redis_6379
systemctl start redis_6379
ps -ef |grep redis
# 改服务名
vi /etc/init.d/redis_6379
# ！打开防火墙
firewall-cmd --zone=public --add-port=6379/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-ports
```

### 查看配置
`config get *`

### 常用API



`keys *` 查询所有的键，会遍历所有的键值，复杂度O(n)
`dbsize` 查询键总数，直接获取redis内置的键总数变量，复杂度O(1)
`exists key` 存在返回1，不存在返回0 O(1)

`ttl` 命令可以查看键hello的剩余过期时间，单位：秒（>0剩余过期时间；-1没设置过期时间；-2键不存在）
`expire key seconds` 当超过过期时间，会自动删除，key在seconds秒后过期
`persist key` 去掉过期时间

`type key` 如果键hello是字符串类型，则返回string；如果键不存在，则返回none

所有key都是字符串



### epoll实现
