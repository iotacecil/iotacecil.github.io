---
title: About CentOS
date: 2018-03-08 13:49:14
tags: [CentOS]
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



