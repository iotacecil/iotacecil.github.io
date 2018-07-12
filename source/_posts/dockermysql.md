---
title: dockermysql
date: 2018-07-05 13:20:56
tags:
---
### redis 高速缓存集群



### docker mysql集群
[PXC](https://hub.docker.com/r/percona/percona-xtradb-cluster/)
防火墙?

1. 拉镜像
   ```bash
   docker pull percona/percona-xtradb-cluster
   docker load <pxc.tar.gz```
2. 改名
```bash
   docker images
   docker tag docker.io/precona/percona-xtradb-cluster pxc
   docker rmi docker.io/precona/percona-xtradb-cluster```
3. 创建容器要先划分Docker内部网段 docker自带的是172.17.0.x
```bash
   docker network create net1 / docker network create --subnet=172.18.0.0/24 net1
   docker network insepct net1
   docker network rm net1
   ```
4. 业务数据映射到宿主机，pxc不能直接用目录映射要用docker卷
```bash
   docker volume create v1
   docer inspect v1 #//var/lib/docker/volumes/v1/_data
   docker volume rm v1
   ```
5. 创建pxc容器 `-d` 后台运行 `-t` 交互界面 `-p` 端口映射 `-v` 路径映射 `-e` 启动参数
	`XTRABACKUP_PASSWORD=abc123456` 数据库同步用的密码
	`--preivileged` 最高权限 
	`--ip` 内部网段中分到的ip地址
 > 注意：容器创建很快，但是mysql初始化可能要2min以上，能连接到一个后再创建第二个
   
```cmd
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -v v1:/var/lib/mysql --privileged --name=node1 --net=net1 --ip 172.18.0.2 pxc

docker run -d -p 3307:3306 -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1  -v v2:/var/lib/mysql --privileged --name=node2 --net=net1 --ip 172.18.0.3 pxc

docker run -d -p 3308:3306 -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1  -v v3:/var/lib/mysql --privileged --name=node3 --net=net1 --ip 172.18.0.4 pxc

docker run -d -p 3309:3306 -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1  -v v4:/var/lib/mysql --privileged --name=node4 --net=net1 --ip 172.18.0.5 pxc

docker run -d -p 3310:3306 -e MYSQL_ROOT_PASSWORD=abc123456 -e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 -e CLUSTER_JOIN=node1  -v v5:/var/lib/mysql --privileged --name=node5 --net=net1 --ip 172.18.0.6 pxc
```
6.用navicat连接5个数据库在db1`create schema test1;` 刷新，其他节点也更新了。


### 负载均衡 Haproxy请求转发器
nginx 支持http协议负载均衡，最近才支持TCP/IP
[haproxy配置](https://zhangge.net/5125.html)
![junheng](/images/junheng.jpg)
1. `docker pull haproxy`
2. 在宿主机创建配置文件 
   `mkdir /home/soft/haproxy/`
   `touch /home/soft/haproxy/haproxy.cfg`
```yml
global
	#工作目录
	chroot /usr/local/etc/haproxy
	#日志文件，使用rsyslog服务中local5日志设备（/var/log/local5），等级info
	log 127.0.0.1 local5 info
	#守护进程运行
	daemon

defaults
	log	global
	mode	http
	#日志格式
	option	httplog
	#日志中不记录负载均衡的心跳检测记录
	option	dontlognull
    #连接超时（毫秒）
	timeout connect 5000
    #客户端超时（毫秒）
	timeout client  50000
	#服务器超时（毫秒）
    timeout server  50000

#监控界面	
listen  admin_stats
	#监控界面的访问的IP和端口
	bind  0.0.0.0:8888
	#访问协议
    mode        http
	#URI相对地址
    stats uri   /dbs
	#统计报告格式
    stats realm     Global\ statistics
	#登陆帐户信息
    stats auth  admin:abc123456
#数据库负载均衡
listen  proxy-mysql
	#访问的IP和端口
	bind  0.0.0.0:3306  
    #网络协议
	mode  tcp
	#负载均衡算法（轮询算法）
	#轮询算法：roundrobin
	#权重算法：static-rr
	#最少连接算法：leastconn
	#请求源IP算法：source 
    balance  roundrobin
	#日志格式
    option  tcplog
	#在MySQL中创建一个没有权限的haproxy用户，密码为空。Haproxy使用这个账户对MySQL数据库心跳检测
    option  mysql-check user haproxy
    server  MySQL_1 172.18.0.2:3306 check weight 1 maxconn 2000  
    server  MySQL_2 172.18.0.3:3306 check weight 1 maxconn 2000  
	server  MySQL_3 172.18.0.4:3306 check weight 1 maxconn 2000 
	server  MySQL_4 172.18.0.5:3306 check weight 1 maxconn 2000
	server  MySQL_5 172.18.0.6:3306 check weight 1 maxconn 2000
	#使用keepalive检测死链
    option  tcpka  
   ```
   `bind  0.0.0.0:3306` 表示任何ip地址都可以访问3306端口
   如果有应用向3306端口发数据库请求，会被转发给具体的pxc数据库实例

3. haroxy 端口3306 映射到宿主机4002 ，后台监控8888映射到4001 
   可以手动分配haroxy的ip地址，docker也会自动分配
   ```shell
   docker run -it -d -p 4001:8888 -p 4002:3306 
     -v /home/soft/haproxy:/usr/local/etc/haproxy 
     --name h1 --privileged --net=net1 haproxy
   ```
   进入容器
   ```shell
   docker exec -it h1 bash
   haproxy -f /usr/local/etc/haproxy/haproxy.cfg
```
   在mysql创建haproxy用户 haproxy中间件用这个账号登陆数据库，发心跳检测
   `%`表示ip都可以用这个账号登陆mysql数据库 密码为空
   ```sql
   create user 'haproxy'@'%' identified by '';
   ```

4. 登陆 http://192.168.3.109:4001/dbs 看监控画面
   `docker stop node1`
   可以看到MySQL_1变红色
   用navicat连接haproxy
   192.168.3.109:4002 root:abc123456
   向haproxy使用的sql都会均匀分发给真实的mysql实例，然后同步

### haproxy双机热备 
1. 虚拟ip linux一个网卡可以定义多个ip地址，可以把ip地址分配给对应的程序
   在两个haproxy容器中部署keepalived抢占一个虚拟ip172.18.0.15,抢到的叫主服务器，没抢到的叫备服务器，有心跳检测，检测到主服务器挂了就抢占ip
![doubleha](\images\doubleha.jpg)
   1.1. 进入容器 
   `docker exec -it h1 bash`
   harpoxy是用Ubuntu创建的 所以要用apt-get
   `apt-get update` #可能要换源 安装vim 不是vi
   `apt-get install keepalived`

   1.2. keepalived配置文件/etc/keepalived/keepalived.conf
   `state:MASTER/BACKUP`为主/备服务器 抢占虚拟IP,备用不会抢。都master都抢占，没抢到的自动变成salve
   `interface:`虚拟ip写到docker的网卡里,eth0局域网里看不见的，后续虚拟ip映射到局域网的虚拟ip
   `virtual_router_id：`0-255之间 虚拟路由ip
   `priority` 权重，优先抢占
   `advert_int: `心跳检测间隔
   `authentication` 心跳检测的账号密码
   `virtual_ipaddress` 虚拟ip
   ```yml
   vrrp_instance  VI_1 {
    state  MASTER
    interface  eth0
    virtual_router_id  51
    priority  100
    advert_int  1
    authentication {
        auth_type  PASS
        auth_pass  123456
    }
    virtual_ipaddress {
        172.18.0.201
    }
   }
   ```

   启动keepalived:
   `service keepalived start`
   `exit`
   宿主机 ping 172.18.0.201
   
2. 在宿主机安装keepalived把宿主机ip映射到docker的虚拟ip
{% fold %}
```conf
vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
       	192.168.99.150
    }
}

virtual_server 192.168.99.150 8888 {
    delay_loop 3
    lb_algo rr 
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 172.18.0.201 8888 {
        weight 1
    }
}

virtual_server 192.168.99.150 3306 {
    delay_loop 3
    lb_algo rr 
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 172.18.0.201 3306 {
        weight 1
    }
}
```
{% endfold %}

### 数据库热备份
冷备份mysql dump
热备份LVM要锁表 XtraBackup不锁表
`docker stop/rm node1`
`docker volume create backup`

```shell
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=abc123456 
-e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 
-v v1:/var/lib/mysql -v backup:/data --privileged 
-e CLUSTER_JOIN=node2 --name=node1 --net=net1 --ip 172.18.0.2 pxc
```

1. 全量备份 在PXC容器中安装XtraBackup
```shell
docker exec -it --user root node1 bash
apt-get update
apt-get install percona-xtrabackup-24
innobackupex --user=root --password=abc123456 /data/backup/full
#备份在/data/backup/full/2018-07-05_04-54-31/xtrabackup_info
exit
docker inspect backup
```
2. 恢复 冷还原 1解散PXC集群，2删除节点，3创建新的节点并还原，4创建其他节点，并同步 重建集群
```shell
docker stop node1 node2 node3 node4 node5
docker rm node1 node2 node3 node4 node5
docker volume rm v1 v2 v3 v4 v5
docker volume create v1

docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=abc123456 
-e CLUSTER_NAME=PXC -e XTRABACKUP_PASSWORD=abc123456 
-v v1:/var/lib/mysql -v backup:/data --privileged 
--name=node1 --net=net1 --ip 172.18.0.2 pxc

docker exec -it node1 bash
rm -rf /var/lib/mysql/*
innobackupex --user=root --password=abc123456 --apply-back /data/backup/full/2018-07-05_04-54-31

innobackupex --user=root --password=abc123456 --copy-back /data/backup/full/2018-07-05_04-54-31

exit
docker stop node1
docker start node1
```





