---
title: About CentOS
date: 2018-03-08 13:49:14
tags: [CentOS]
---
### centos装python3
```sh
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
yum -y install epel-release
yum install python-pip
wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz
#解压
xz -d Python-3.6.4.tar.xz
tar -xf Python-3.6.4.tar

#进入解压后的目录，依次执行下面命令进行手动编译
./configure prefix=/usr/local/python3
make && make install
#将原来的链接备份
mv /usr/bin/python /usr/bin/python.bak

#添加python3的软链接
ln -s /usr/local/python3/bin/python3.6 /usr/bin/python

#测试是否安装成功了
python -V
vi /usr/bin/yum
把#! /usr/bin/python修改为#! /usr/bin/python2

vi /usr/libexec/urlgrabber-ext-down
把#! /usr/bin/python 修改为#! /usr/bin/python2
```

### visualbox扩容
全局工具-虚拟硬盘
`df -lh` 查看磁盘使用
删掉一个docker
`docker images`
`docker ps -a`
`docker stop j1`
`docker rm j1`
`docker rmi d23bdf5b1b1b`

如果有图形界面可以安装分区工具？
```sh
yum install epel-release
yum install gparted
```

1. 新建硬盘 新建分区
```sh
fdisk -l
fdisk /dev/sda
    n #...一直回车
    p #查看
    w #保存
reboot
fdisk -l
```
   设备 Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    16777215     7339008   8e  Linux LVM
/dev/sda3        16777216    67108863    25165824   83  Linux

2. 创建卷 合并卷
```sh
pvcreate  /dev/sda3
vgcreate sda333 /dev/sda3
vgscan
  Reading volume groups from cache.
  Found volume group "sda333" using metadata type lvm2
  Found volume group "centos" using metadata type lvm2
vgmerge centos sda333
df -h
文件系统                 容量  已用  可用 已用% 挂载点
/dev/mapper/centos-root  6.2G  5.7G  526M   92% /
devtmpfs                 485M     0  485M    0% /dev
tmpfs                    496M     0  496M    0% /dev/shm
tmpfs                    496M  6.8M  490M    2% /run
tmpfs                    496M     0  496M    0% /sys/fs/cgroup
/dev/sdb1                 16G  227M   15G    2% /data
/dev/sda1               1014M  129M  885M   13% /boot
tmpfs                    100M     0  100M    0% /run/user/0
```
3. 调整逻辑卷大小
```sh
lvextend -l+100%FREE /dev/mapper/centos-root
  Size of logical volume centos/root changed from <6.20 GiB (1586 extents) to 30.19 GiB (7729 extents).
  Logical volume centos/root successfully resized.
lvs
  LV   VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root centos -wi-ao----  30.19g                                                    
  swap centos -wi-ao---- 820.00m  
xfs_growfs /dev/mapper/centos-root
df -lh
文件系统                 容量  已用  可用 已用% 挂载点
/dev/mapper/centos-root   31G  5.7G   25G   19% /
devtmpfs                 485M     0  485M    0% /dev
tmpfs                    496M     0  496M    0% /dev/shm
tmpfs                    496M  6.8M  490M    2% /run
tmpfs                    496M     0  496M    0% /sys/fs/cgroup
/dev/sdb1                 16G  227M   15G    2% /data
/dev/sda1               1014M  129M  885M   13% /boot
tmpfs                    100M     0  100M    0% /run/user/0
```



`ip -br addr` ip太多VB显示不下

---

1. perf 监视java程序上下文切换情况 windows perfmon性能监视器
2. JDK自带的jvisualvm、jstack

1. 修改主机名`cat /ect/hostname`
2. 查找命令`which ls`
3. `ll`
4. `tty`终端
5. `/dev/zero` 零设备文件 `/dev/null`回收站 `/dev/random` 产生随机数
6. `useradd tmpuser`会在home下创建用户文件夹
7. `df -h` 查看存储容量
    `du -sh /usr` 80%的空间占用是/usr
8. `tree -L 1`树型显示一层 `yum -y install tree`
9. 创建文件`touch /home/{f1,f2}`用集合创建两个文件{1..20}范围
10. `copy -v`-v, --verbose  explain what is being done
11. `wc -l /var/log/messages`显示文件行数 `head` `tail`查看头尾 `less`分页显示
12. `grep 'root' /etc/passwd`在文件中用正则查找关键字的行
13. `ll -a >list.txt`重定向到文件

### 7种文件类型（-文件 d目录 l软链接）
`-rw-r--r--`10位权限 （r4 w2 x1 读写执行权限 -没有权限 rwx7r-x5r-x5）设计成2的幂次因为不会歧义
`rw-`u所有者权限
`r--`g所属组
`r--`其他人

#### chmod [] 模式 文件名 修改权限
`chmod u+x,g+w xxx.avi`赋予执行
`chmod u=rwx file`
所有人`chmod a=rwx file`
`chomd 777 fild`

### RPM
[查找文件](www.rpmfind.net)

r:读(cat,more head,tail) 目录(ls)
w:写，追加(vi,echo 111>file)但是不能删除 删除是上一级的权限
    目录(touch新建目录，rm，mv，cp)
x： 对目录可以(cd) 
目录的最高权限是x，文件最高权限是w


### 运行java
java xxx.class要在`/etc/profile`加入CLASSPATH=.:$JAVA_HOME/jre/lib/ext:
`source /etc/profile`

### 文件系统 FHS文件层次结构标准
## 颜色
- 黄色：表示设备文件
- 浅蓝色：链接（快捷方式）

/usr(Unix Software Resource)软件/usr里面放置的数据属于可分享的与不可变动的(shareable, static) 相当于C:/windows
    /usr/local相当于c:/program
/opt三方协力软件
/etc配置文件
/var系统运作相关
/proc 进程：系统内存的映射
/selinux：防火墙


`ls -lh` 查看文件属性
`pwd` 当键目录
`ls -al --full-time`完整显示文件修改时间

```sh
# 查看 cpu 型号
sudo dmidecode -s processor-version
# 查看 cpu 个数
grep 'physical id' /proc/cpuinfo | sort -u | wc -l
# 查看核心数
grep 'core id' /proc/cpuinfo | sort -u | wc -l
# 查看线程数
grep 'processor' /proc/cpuinfo | sort -u | wc -l
```

fork 启动后台进程
环境变量`vi /etc/profile`
- 软连接：

- 零拷贝：文件传输只通过内核空间传输给socket

- vi
1. :q!
2. 备份：cp server.xml server.xml.bak



