---
title: 操作系统+内存知识
date: 2018-03-05 20:43:15
tags: [os,memory]
category: [cpp学习操作系统]
---

### 程序访问文件的方式
1.利用操作系统内核缓冲区
2.直接IO：不经过内核缓冲区，数据库系统。缓存由应用程序实现。
![directio.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/directio.jpg)
3.同步4.异步
5.内存映射。内存与磁盘共享，减少从内核到用户缓存的数据复制。

### 文件描述符
`FileDescriptor.sync()`可以将操作系统缓冲强制刷新到物理磁盘。

### 从磁盘读取文件的过程
![filereadprocess.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/filereadprocess.jpg)


### 块特殊文件
块特殊文件和字符特殊文件的基本差别是什么？

答：块特殊文件包含被编号的块，每一块都可以独立地读取或者写入。而且可以定位于任何块，并且开始读出或写入。这些对于字符特殊文件是不可能的。

### lseek
有一个文件，其文件描述符是fd，内含下列字节序列：3，1，4，1，5，9，2，6，5，3，5。有如下系统调用：
lseek(fd,3,SEEK_SET);
read(fd,&buffer,4);
其中lseek调用寻找文件中的字节3。在读取操作完成之后，buffer中的内容是什么？
答：包含字节：1，5，9，2.


### 中断和陷入
陷阱是由程序造成的，并且与它同步。如果程序一而再地被运行，陷阱将总在指令流中相同的位置的精确发生。而中断则是由外部事件和其他时钟造成的，不具有重复性。

### 流水线 指令数
一台计算机有一个四级流水线，每一级都花费相同的时间执行其工作，即1ns。这台机器每秒可执行多少条指令？
答：从管道中每纳秒出现一条指令。意味着该机器每秒执行十亿条指令。它对于管道有多少个阶段不予理睬，即使是10-阶段管道，每阶段1nsec，也将执行对每秒十亿条指令。因为无论哪种情况，管道末端输出的指令数都是一样的。

### 4级存储 读取平均时间
假设一个计算机系统有高速缓存、内存（RAM）以及磁盘，操作系统用虚拟内存。读取缓存中的一个词需要2ns，RAM需要10ns，硬盘需要10ms。如果缓存的命中率是95%，内存的是（缓存失效时）99%，读取一个词的平均时间是多少？
答：平均访问时间 = 2ns * 0.95 + 10ns *0.99 *(1-0.95) + 10ms * (1-0.99) *(1-0.95) = 5002.395ns .


### 内核态
下面哪一条指令只能在内核态使用？

a 禁止所有的中断
b 读日期-时间时钟
c 设置日期-时间时钟
d 改变存储器映像

选择 a、c、d

### 扇区读取时间？ 寻道时间+旋转延迟+传输时间
一个255GB大小的磁盘有65535个柱面，每个柱面255个扇区。每个扇区512字节。这个磁盘有多少盘片和磁头？假设平均寻道时间为11ms,平均旋转延迟为7ms,读取速度100MB/s,计算从一个扇区读取400kb需要的平均时间。

磁头数= 255 GB /（65536 * 255 * 512）= 16 
盘片数量= 16/2 = 8 
读取操作完成的时间是寻道时间+旋转延迟+传输时间。 寻道时间为11 ms，旋转延迟为7 ms，传输时间为4 ms，因此平均传输时间为22 ms。

---

假设一个10MB的文件在磁盘连续扇区的同一个轨道上（轨道号：50）。磁盘的磁头臂此时位于第100号轨道。要想从磁盘上找回这个文件，需要多长时间？ 假设磁头臂从一个柱面移动到下一个柱面需要1ms，当文件的开始部分存储在的扇区旋转到磁头下需要5ms，并且读的速率是100MB/s。

找到文件需要的时间=1 * 50 ms (移动到50轨道号的时间) + 5 ms (旋转到文件开始部分存储在的扇区的时间) + 10/100 * 1000 ms (读取10MB的时间) = 155 ms



### cache行的原因
4.为了使用高速缓存，主存被划分为若干cache行，同城每行长32或64字节。每次缓存一整个cache行，每次缓存一整行而不是一个字节或一个字，这样的优点是什么？

经验证据表明，存储器访问表现出引用局部原则，即如果读取某一个位置，则接下来访问这个位置的概率非常高，尤其是紧随其后的内存位置。 因此，通过缓存整个缓存行，接下来缓存命中的概率会增加。 此外，现代的硬件可以将32或64字节块整个传输到高速缓存行，比单个字节读取，总共读32或64字节的速度要快得多。

---

进程从运行状态进入就绪状态的原因可能是?
正确答案: D   你的答案: B (错误)
A被选中占有处理机
B等待某一事件
C等待的事件已发生
D时间片用完

---

假设某一虚拟存储系统采用先进先出（FIFO）页面淘汰算法，有一个进程在内存中占3页（开始时内存为空），当访问如下页面序列号后1,2,3,1,2,4,2,3,5,3,4,5,6会产生()次缺页
6
注意：缺页定义为所有内存块最初都是空的，所以第一次用到的页面都产生一次缺页。


### 多道程序：多道宏观上并行微观上串行
充分利用CPU。减少CPU等待时间。

- 分时操作系统：可以人机交互 以时间片为单位轮流为各个用户/作业服务。

### 链接 文件共享



下列关于链接描述，错误的是
正确答案: B   你的答案: A (错误)
A硬链接就是让链接文件的i节点号指向被链接文件的i节点
B**硬链接和符号连接都是产生一个新的i节点**
C链接分为硬链接和符号链接
D硬连接不能链接目录文件

https://www.ibm.com/developerworks/cn/linux/l-cn-hardandsymb-links/index.html#fig2

![softlink.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/softlink.jpg)
链接为 Linux 系统解决了文件的共享使用，还带来了隐藏文件路径、增加权限安全及节省存储等好处。
```sh
# 查找 软链接
[root@localhost ~]# find -lname wordcount.sh
./wdc.link

# 查找硬链接
[root@localhost ~]# find -samefile wordcount.sh
./wordcount.sh
./wdc
```

#### VFS Linux的文件系统
![vfs.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/vfs.jpg)

1.网络文件系统，如 nfs、cifs 等；
2.磁盘文件系统，如 ext4、ext3 等；
3.特殊文件系统，如 proc、sysfs、ramfs、tmpfs 等。

实现以上这些文件系统并在 Linux 下共存的基础就是 Linux VFS（Virtual File System 又称 Virtual Filesystem Switch），即虚拟文件系统。
VFS 作为一个通用的文件系统，抽象了文件系统的四个基本概念：
**文件、目录项 (dentry)、索引节点 (inode) 及 挂载点**
其在内核中为用户空间层的文件系统提供了相关的接口。

VFS 实现了 open()、read() 等系统调并使得 cp 等用户空间程序可跨文件系统。VFS 真正实现了上述内容中：在 Linux 中除进程之外一切皆是文件。

Linux VFS 存在四个基本对象：
超级块对象 (superblock object)、索引节点对象 (inode object)、目录项对象 (dentry object) 及文件对象 (file object)。

> 超级块对象代表一个已安装的文件系统；
> 索引节点对象代表一个文件；
> 目录项对象代表一个目录项，如设备文件 event5 在路径 /dev/input/event5 中，其存在四个目录项对象：/ 、dev/ 、input/ 及 event5。
> 文件对象代表由进程打开的文件。

1超级块2索引节点3目录项4文件对象 与 进程 及 磁盘文件 间的关系:
![d_inode.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/d_inode.jpg)

其中 d_inode 即为硬链接。为文件路径的快速解析，Linux VFS 设计了目录项缓存（Directory Entry Cache，即 dcache）。

#### innode
**移动或重命名文件 不影响inode**

![filename.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/filename.jpg)

文件都有文件名与数据，这在 Linux 上被分成两个部分：用户数据 (user data) 与元数据 (metadata)。
- 用户数据，即文件数据块 (data block)，数据块是记录文件真实内容的地方；
- 元数据则是文件的附加属性，如文件大小、创建时间、所有者等信息。在 Linux 中，元数据中的 inode 号（inode 是文件元数据的一部分但其并不包含文件名，inode 号即索引节点号）才是文件的唯一标识而非文件名。
```shell
[root@localhost ~]# ls -i workcount.sh 
8705899 workcount.sh
[root@localhost ~]# stat workcount.sh
  文件："workcount.sh"
  大小：117        块：8          IO 块：4096   普通文件
设备：fd00h/64768d Inode：8705899     硬链接：1
权限：(0777/-rwxrwxrwx)  Uid：(    0/    root)   Gid：(    0/    root)
环境：unconfined_u:object_r:admin_home_t:s0
最近访问：2018-08-09 20:39:34.052284568 +0800
最近更改：2018-08-09 20:35:25.159457149 +0800
最近改动：2018-08-09 20:39:28.363357082 +0800
创建时间：-
```

#### 索引节点 VFS/ext4 innode 
索引节点结构存在于系统内存及磁盘，其可区分成 VFS inode 与实际文件系统的 inode。


#### VFS 中的 inode 与 inode_operations 结构体

VFS inode 作为实际文件系统中 inode 的抽象，定义了结构体 inode 与其相关的操作 inode_operations（见内核源码 include/linux/fs.h）。

i_count i_nlink
每个文件存在两个计数器：i_count 与 i_nlink，即引用计数(i_count 用于跟踪文件被访问的数量)与硬链接计数。
i_count 用于跟踪文件被访问的数量

```c
struct inode { 
   ... 
   const struct inode_operations   *i_op; // 索引节点操作
   unsigned long           i_ino;      // 索引节点号
   atomic_t                i_count;    // 引用计数器
   unsigned int            i_nlink;    // 硬链接数目
   ... 
} 
 
struct inode_operations { 
   ... 
   int (*create) (struct inode *,struct dentry *,int, struct nameidata *); 
   int (*link) (struct dentry *,struct inode *,struct dentry *); 
   int (*unlink) (struct inode *,struct dentry *); 
   int (*symlink) (struct inode *,struct dentry *,const char *); 
   int (*mkdir) (struct inode *,struct dentry *,int); 
   int (*rmdir) (struct inode *,struct dentry *); 
   ... 
}
```

#### ext4 inode
i_links_count 不仅用于文件的硬链接计数，也用于目录的子目录数跟踪（目录并不显示硬链接数
```sh
struct ext4_inode { 
   ... 
   __le32  i_atime;        // 文件内容最后一次访问时间
   __le32  i_ctime;        // inode 修改时间
   __le32  i_mtime;        // 文件内容最后一次修改时间
   __le16  i_links_count;  // 硬链接计数
   __le32  i_blocks_lo;    // Block 计数
   __le32  i_block[EXT4_N_BLOCKS];  // 指向具体的 block 
   ... 
};
```


#### 硬链接 ： 一个 inode 号对应多个文件名，则称这些文件为硬链接。
硬链接就是同一个文件使用了多个别名,有共同的inode
硬链接可由命令 link 或 ln 创建
```sh
[root@localhost ~]# stat wdc
  文件："wdc"
  大小：117        块：8          IO 块：4096   普通文件
设备：fd00h/64768d Inode：8705899     硬链接：2
权限：(0777/-rwxrwxrwx)  Uid：(    0/    root)   Gid：(    0/    root)
环境：unconfined_u:object_r:admin_home_t:s0
最近访问：2018-08-09 20:39:34.052284568 +0800
最近更改：2018-08-09 20:35:25.159457149 +0800
最近改动：2018-12-10 09:37:11.206523214 +0800
```
硬链接是有着相同 inode 号仅文件名不同的文件

>- 文件有相同的 inode 及 data block；
> - 只能对已存在的文件进行创建；
> - 不能交叉文件系统进行硬链接的创建；
> - 不能对目录进行创建，只可对文件创建；
> - 删除一个硬链接文件并不影响其他有相同 inode 号的文件。

#### 跨文件系统不能创建
inode 号仅在各文件系统下是唯一的，当 Linux 挂载多个文件系统后将出现 inode 号重复的现象.
```sh
[root@localhost /]# df -i --print-type
文件系统                类型        Inode 已用(I)  可用(I) 已用(I)% 挂载点
/dev/mapper/centos-root xfs      15828992  188789 15640203       2% /
devtmpfs                devtmpfs   123919     370   123549       1% /dev
tmpfs                   tmpfs      126938       1   126937       1% /dev/shm
tmpfs                   tmpfs      126938     548   126390       1% /run
tmpfs                   tmpfs      126938      16   126922       1% /sys/fs/cgroup
/dev/sda1               xfs        524288     326   523962       1% /boot
/dev/sdb1               ext3      1048576      77  1048499       1% /data
```

#### 目录不能硬链接
硬链接不能对目录创建是受限于文件系统的设计
Linux 文件系统中的目录均隐藏了两个个特殊的目录：当前目录（.）与父目录（..）。查看这两个特殊目录的 inode 号可知其实这两目录就是两个硬链接。
若系统允许对目录创建硬链接，则会产生目录环。
```sh
[root@localhost /]# ls -aliF /mnt
总用量 0
4213723 drwxr-xr-x.  2 root root   6 4月  11 2018 ./
     64 dr-xr-xr-x. 19 root root 274 9月  15 15:12 ../
```

#### inode用完 但磁盘还有剩余
Linux 系统存在 inode 号被用完但磁盘空间还有剩余的情况。 

---

#### 软连接(符号链接）： 文件用户数据块中存放的内容是另一文件的路径名的指向
```sh
[root@localhost ~]# ln -s wordcount.sh wdc.link
[root@localhost ~]# ls -li

9063386 lrwxrwxrwx. 1 root root        12 12月 10 09:56 wdc.link -> wordcount.sh
8705899 -rwxrwxrwx. 2 root root       117 8月   9 20:35 wordcount.sh

```

软链接就是一个普通文件，只是数据块内容有点特殊。软链接有着自己的 inode 号以及用户数据块。因此软链接的创建与使用没有类似硬链接的诸多限制：

> - 软链接有自己的文件属性及权限等；
> -可对不存在的文件或目录创建软链接；
> -软链接可交叉文件系统；
> -软链接可对文件或目录创建；
> -创建软链接时，链接计数 i_nlink 不会增加；
> -删除软链接并不影响被指向的文件，但若被指向的原文件被删除，则相关软连接被称为死链接（即 dangling link，若被指向路径文件被重新创建，死链接可恢复为正常的软链接）




### tasklet 软中断
软中断必须设计为可重入的函数（允许多个CPU同时操作），因此也需要使用自旋锁来保其数据结构。

### 备份算法

rdiff 原理
rsync增量传输算法原理

### 安全序列

https://www.nowcoder.com/ta/nine-chapter?query=&asc=true&order=&page=3
### 软中断 和 硬中断
中断和异常是随机发生、自动处理、可恢复的。
![inter.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/inter.jpg)
- 中断： 操作系统 是中断（事件）驱动的
中断引入是为了支持CPU和外部设备并行操作：cpu启动输入输出设备后，设备独立工作，cpu处理其他任务。当输入/输出完成，向CPU发送中断。
- 异常： cpu执行指令时自身出现的问题。（算术溢出、地址越界、陷入指令）
异常分3类：陷入，故障，终止
![inter.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/inter.jpg)
事件的发生改变了处理器的控制流：
- cpu暂停正在执行的程序，
- 保留现场，
- 自动转去执行相应事件的处理程序，
- 完成后返回断点，继续执行被打断的程序。

硬件：中断/异常响应：捕获中断/异常请求，响应，交给特定处理程序 。
软件：中断/异常处理程序：识别中断/异常类型 并完成处理。

中断响应： 发现中断、接受中断的过程。由中断硬件部件完成。
处理器控制部件中有 中断寄存器。

CPU在每条指令执行周期的最后，会扫描 中断寄存器。
中断硬件会将触发内容规定变法送入PSW程序状态字相应位，称 中断编码。硬件会去查中断向量表，调出中断处理程序。
![interrupt.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/interrupt.jpg)

中断向量表：操作系统设计好的
一条中断向量是一个内存单元。存放：中断处理程序入口地址和程序运行时所需的处理机状态字。
Linux中断向量表0~255个中断向量c
![linuxvector.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/linuxvector.jpg)

![interreact.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/interreact.jpg)

中断处理程序： 软件提前设置好，硬件执行
1. 保存相关寄存器信息
2. 分析中断/异常的具体原因
3. 执行处理程序
4. 回复现场，返回被打断的程序

I/O中断处理程序分两类处理：
正常结束，唤醒等待的程序，或者继续IO
出现错误：重新执行失败IO，直到判断为硬件故障

![intererror1.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/intererror1.jpg)
（硬件）CPU 切换到内核态 在系统栈保留上下文 PC,PSW。
![intererror2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/intererror2.jpg)

X86处理器
中断：硬件信号。
异常：指令执行引发。 系统调用：用户态到内核态的唯一入口。
![x86inter.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/x86inter.jpg)

中断控制器:硬件中断信号->中断向量 引发CPU中断

实模式没有CPU状态的转换。现在一般我们是在保护模式。叫中断描述符表。用门(gate)

#### 保护模式：
>用来增强多工和系统稳定度，像是 内存保护，分页 系统，以及硬件支援的 虚拟内存

实模式下的各种代码段、数据段、堆栈段、中断服务程序仍然存在，统称为“数据段”
引入描述符来描述各种数据段，所有的描述符均为8个字节（0-7)，由第5个字节说明描述符的类型，类型不同，描述符的结构也有所不同。描述符表是一张地址转换函数表。

描述符数据结构表示中断向量。
![x86inter2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/x86inter2.jpg)
![x86inter3.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/x86inter3.jpg)
中断描述符表(IDT)通过IDTR寄存器获得IDT的地址
段选择符是索引，显示是GDT表还是LDT表，还有特权级，用索引查全局描述符表（GDT），得到段描述符，得到段基地址+偏移量 = 中断服务程序入口地址

要做特权级检查，要切换堆栈，用户态进内核态，堆栈指针到内核态
硬件压栈，保存上下文，如果异常产生了硬件出错码 保存在栈中。
![x86inter4.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/x86inter4.jpg)

#### 系统调用：操作系统功能调用 //todo
每个操作系统都提供几百种系统调用（进程控制、进程通信、文件使用、目录操作、设备管理、信息维护）

应用程序可以直接使用系统调用，但是一般都是通过C函数库/API接口使用系统调用。
内核函数是系统调用的处理程序 经过封装，提供到了C库函数和API接口。
 



https://www.polarxiong.com/archives/%E8%AF%BB-%E7%A8%8B%E5%BA%8F%E5%91%98%E7%9A%84%E8%87%AA%E6%88%91%E4%BF%AE%E5%85%BB-%E7%9A%84%E6%80%BB%E7%BB%93.html
### 伙伴系统：Linux内存分配方案，空闲块链表
伙伴：如果需要的空间s需要`2^(n-1)<s<2^n`则空间/2，两个叫伙伴。
![huoban.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/huoban.jpg)

伙伴分割与合并（每次分割小的空闲块，系统中始终保持大的空闲快）
![huoban2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/huoban2.jpg)

### 内存管理方案
装载单位： 进程
1.单一连续区域:只有一个进程在内存
![memoryalloc.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/memoryalloc.jpg)

2.固定分区：内存分区，每个分区只装1个进程，进程在各个分区排队
![memoryalloc2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/memoryalloc2.jpg)

3.可变分区：内存按需分配给进程
外碎片：进程和进程之间的空隙
![memoryalloc3.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/memoryalloc3.jpg)
memory compaction:在内存移动程序，合并空闲区域
进程IO时不能移动。

#### 进程进入内存不是连续区域，而是进入内存若干个不连续区域。
//todo
https://www.coursera.org/lecture/os-pku/ji-ben-nei-cun-guan-li-fang-an-2-p4N0u
1.页式
![pagememory.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pagememory.jpg)
如果是32位的计算机,如果页面大小4k,0~11 12位为偏移
![pagememory2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pagememory2.jpg)
 页表项记录了逻辑页号 到页框号的一个映射关系
 每个进程都有一张页表，页表放在内存，一个进程上CPU之后 这个进程的页表的起始地址要推送到某一个寄存器
 页表的起始地址在哪个数据结构？
用 bitmap 位图管理物理内存


### Windows API让cpu使用率划出一条直线
一个时钟周期可以执行多少条指令？ CPU流水线？
CPU每个时钟周期可以执行两条以上代码
2.4Ghz主频则1秒可以执行2.4G\*2行汇编指令
10毫秒接近Windows调度时间片，1毫秒会导致线程频繁被唤醒挂起
资源管理器大约是1秒更新一次
4核cpu一个线程死循环占用大概是25%
`SetThreadAffinityMask()`


https://hit-alibaba.github.io/interview/basic/arch/Concurrency.html
### IO多路复用
http://www.cnblogs.com/Anker/archive/2013/08/14/3258674.html

### 磁盘驱动
https://my.oschina.net/manmao/blog/746492

1. 移动磁头到磁道
2. 转动磁盘到扇区
3. 磁生电和内存读，电生磁 内存写

总线倒用技术DMA 扇区和内存

![dictuse.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/dictuse.jpg)

算出柱面磁头扇区和读写的缓冲区直接out

抽象1：通过盘块号 操作系统 计算出柱面磁头扇区CHS


### 磁盘调度算法
电梯调度算法？
```cpp
#include<iostream>
#include<cstdio>
#include<algorithm>
#include<cmath>
using namespace std;
const int maxn = 100;
int n, now, s, sum, nnow, everage, p[maxn], b[maxn], sp[maxn], lenp[maxn];
//显示结果
void show()
{
    sum = 0;
    cout <<"        被访问的下一磁道号     移动距离（磁道数）\n";
    for(int i = 0;i < n; ++i)
    {
        printf("                 %3d                  %3d\n", sp[i], lenp[i]);
        sum += lenp[i];
    }
    cout <<"        平均寻道长度： "<<(double)sum/n <<"\n";
}
//先来先服务
void FCFS()
{
    for(int i = 0;i < n; ++i)
    {
        sp[i] = p[i];
        if(i)   lenp[i] = abs(sp[i-1] - sp[i]);
        else    lenp[i] = abs(now  - sp[i]);
    }
}
//最短寻道优先
void SSTF()
{
    nnow = now;
    int fl[maxn] = {0};
    for(int i = 0;i < n; ++i)
    {
        int minx = 999999, pp;
        for(int j = 0;j < n; ++j)
        {
            if(!fl[j] && abs(nnow - p[j]) < minx)
            {
                minx = abs(nnow - p[j]);
                pp = j;
            }
        }
        sp[i] = p[pp];
        lenp[i] = minx;
        nnow = p[pp];
        fl[pp] = 1;
    }
}
//扫描算法
bool cmp(int a, int b)
{
    return a > b;
}
void SCAN()
{
    nnow = now;
    int aa[maxn], bb[maxn], ak = 0, bk = 0;
    for(int i = 0;i < n; ++i)
    {
        if(p[i] < nnow) aa[ak++] = p[i];
        else bb[bk++] = p[i];
    }
    sort(aa, aa+ak,cmp);
    sort(bb, bb+bk);
    int i = 0;
    for(int j = 0;j < bk; ++j)
    {
        sp[i] = bb[j];
        lenp[i++] =  bb[j] - nnow;
        nnow = bb[j];
    }
    for(int j = 0;j < ak; ++j)
    {
        sp[i] = aa[j];
        lenp[i++] = nnow - aa[j];
        nnow = aa[j];
    }
}
//循环扫描算法
void CSCAN()
{
    nnow = now;
    int aa[maxn], bb[maxn], ak = 0, bk = 0;
    for(int i = 0;i < n; ++i)
    {
        if(p[i] < nnow) aa[ak++] = p[i];
        else bb[bk++] = p[i];
    }
    sort(aa, aa+ak);
    sort(bb, bb+bk);
    int i = 0;
    for(int j = 0;j < bk; ++j)
    {
        sp[i] = bb[j];
        lenp[i++] =  bb[j] - nnow;
        nnow = bb[j];
    }
    for(int j = 0;j < ak; ++j)
    {
        sp[i] = aa[j];
        lenp[i++] = abs(aa[j] - nnow);
        nnow = aa[j];
    }
}
int main()
{
    xbegin:
        cout<<"请输入被访问的总磁道数：  ";
        cin >> n;
        if(n <= 0 ||  n > 100)
        {
            cout <<"输入不合法，请重新输入！\n";
            goto xbegin;
        }
    nowCD:
        cout <<"请输入当前磁道： ";
        cin >> now;
        if(now < 0)
        {
            cout <<"磁道不存在，请重新输入！";
            goto nowCD;
        }
    pCD:
        cout <<"请按顺序输入所有需要访问的磁道：";
        for(int i = 0;i < n; ++i) cin >> p[i];
        for(int i = 0;i < n; ++i)
        {
            b[i] = p[i];
            if(p[i] < 0)
            {
                cout <<"输入中有不存在的磁道，请重新输入！\n";
                goto pCD;
            }
        }
    serve:
        cout <<"  1、先来先服务算法（FCFS）\n";
        cout <<"  2、最短寻道优先算法（SSTF）\n";
        cout <<"  3、扫描算法（SCAN）\n";
        cout <<"  4、循环扫描算法（CSCAN）\n";
        cout <<"请输入所用磁盘调度的算法： ";
        cin >> s;
        if(s < 1 || s > 4)
        {
            cout <<"输入有误，请重新输入！\n";
            goto serve;
        }
    work:
        for(int i = 0;i < n; ++i) p[i] = b[i];
        if(s == 1) FCFS();
        else if(s == 2) SSTF();
        else if(s == 3) SCAN();
        else CSCAN();
        show();
    xend:
        char ch;
        cout <<"重新选择算法或重新输入数据？（输入Y选择算法，输入y重新输入数据）: ";
        cin >> ch;
        if(ch == 'Y') goto serve;
        else if(ch == 'y') goto xbegin;
        else cout <<"程序结束，谢谢使用！\n";
    return 0;
}

```

https://www.shiyanlou.com/courses/115
### 进程调度
![diaodushiji.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/diaodushiji.jpg)
就绪队列改变->重新调度
进程调度的时机4个：
1.进程正常/错误终止
2.创建新进程/等待进程->就绪
3.进程从运行->阻塞（等待）
4.进程从运行->就绪（时间片到）
重新调度的时机：内核对 【中断/陷入（异常）/系统调用】等处理之后【返回用户态】需要重新调度。

调度程序从就绪队列里选择进程可以是刚刚被暂停的，也可以是新的进程，新的就发生进程切换。
![processchange.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/processchange.jpg)
新的进程上cpu要用自己的地址空间
![contentstep.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/contentstep.jpg)


高速缓存：刚才执行进程的指令和数据
TLB存放了进程的页表表项

新的进程的指令、数据、表项也要放入高速缓存和TLB

### 调度算法
![diaodumetric.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/diaodumetric.jpg)


### FC: Fibre Channel
集群的磁盘阵列通过驱动接口同步磁盘块

1.获得linux文件的访问次数
2.获得文件和磁盘块的映射


### 银行家算法
https://blog.csdn.net/yaopeng_2005/article/details/6935235
条件：
1.固定进程数
2.每个进程预先申请最大需要资源数量
3.不能申请比系统可用资源总数还多的资源
4.进程等待资源时间有限
5.进程用完会还
数据结构：
n：进程数
m：资源类数量
`Avaliable[1..m]`
`Max[1..n,1..m]`每个进程对某一资源最大需求量
`Allocation[1..n,1..m]`当前进程分配到的 资源
`Need[1..n,1..m]`当前进程还需要多少资源
`Request[1..n,1..m]`本次申请多少资源

系统状态：
当前可用资源的数量`Work[1..m]=Available`
`Finish[1..n]=False`
//to-do
遍历查找进程i：`Finish[i]==false&Need[i]<=Work`



Linux IO模式及 select、poll、epoll详解
https://segmentfault.com/a/1190000003063859
### 为什么要用反码
0如果是正数000...0
0如果是负数100...0
-1:原码：10..01->反码11..10->补码11...11
用反码0->正数反码是本身000
用补码0->11...1(符号位不变)+1->0..0

而且符号位可以参与运算。

### 内核缓冲区？

### 运行时重定位，进程血环根据pcb切换换基地址

因为进程在执行时可以换入换出内存，基地址不一样，所以每次找到空闲内存，将空闲基地址写到pcb。
每次取出指令放到cpu的IR执行一条指令都要地址翻译：因为执行过程中会有上下文切换，pcb基址放到基址寄存器（cpu)，执行完switch进程时基地址寄存器写回pcb。
进程切换，将当前pcb的基地址更新给基址寄存器

### 程序分段
一个程序会将主程序、变量、函数等在内存中是分段存放，都从自己的0地址开始存放。
放入内存时是分段放入，这样每一段，比如动态数组、栈可以很方便扩容。
所以定位的基地址是 <段号，段内偏移>:move [es:bx],ax
段： cs代码寄存器，ds数据寄存器 ss栈寄存器 es扩展段寄存器
PCB需要记录每个段的基地址和长度
假设cs是0段
![pcbduan.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pcbduan.jpg)

GDT表 根据cs查GDT表
jmpi0,8
操作系统内核的段表是GDT表
每个进程的段表是LDT表

流程：
1.程序分成多个段，每个段在内存中找到空闲基址
2.将基址写到LDT表，LDT表赋给PCB，PC指针设为初始地址，每次执行都查LDT表找物理地址。

### 管程：一种同步机制
用一种数据结构管理共享资源，并且提供一组操作过程
- 进程与管程：
  进程只能通过管程提供的过程间接访问管程中的数据结构。
- 管程是**互斥**进入的 ！编译器保证(???)
- 管程通过 条件变量+wait/notify操作解决**同步**问题。可以让进程/线程在条件变量上 等待（同时释放管程使用权，允许其他线程进入管程），也可以唤醒等待的线程/进程。

多个进程同时在管程里出现：
a进入管程，wait并释放，b进入，唤醒a，则同时两个进程。
三种解决方案：
1.并发pascal：规定唤醒作为管程中最后一个可执行操作->唤醒完了这个进程就出管程
2.Hoare：a（被唤醒的）先执行，b等待
![hoare.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/hoare.jpg)
- 入口等待队列：在管程外等待的
- 如果进入管程的发现资源不够不能操作（生产者想insert，但是缓冲区(资源)满了)则进程wait进入不同的条件变量队列。释放，并让入口等待队列的进入管程。
- 后进入的进程p发现资源够了会signal条件变量队列中的进程q。
- p唤醒q，p进入紧急等待队列(比入口等待队列优先级高)，q进程从条件变量队列中出来继续执行
![hoarecondition.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/hoarecondition.jpg)
- 条件变量 c链：条件变量队列
可以用信号量和pv操作构造管程。
用管程解决生产者消费者问题：
![pcp.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pcp.jpg)

 hoare的缺点：2次额外的进程切换

3.MESA：a等待(本来在条件变量等待，现在在另一个队列等待)，b继续
从hoare的signal->notify
- notify(x) x是条件变量，x条件变量队列上的进程得到通知，发信号的继续执行。
问题：不能保证将来x条件还成立 所以notify的进程上cpu执行还要重新检查条件
- 用while取代if
![mesa.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/mesa.jpg)
改进：给条件队列等待+计时器，自动变成就绪态(因为被调度的时候还是会检查条件)
改进：broadcast 释放所有等待条件变量的进程

### Pthread互斥(lock操作互斥量)同步(wait/signal条件变量)
pthread线程库实现条件变量的signal 是mesa管程的语义
![pthread.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pthread.jpg)
![condition_wait.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/condition_wait.jpg)

### 进程通信
信号量和管程不能多处理器，也不能传大量信息（大数组）
1. 消息传递
发送进程准备好消息，但是发送进程只能在自己的地址空间，不能去接收进程的地址空间操作，必须靠操作系统的消息缓冲区。
![messagesend.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/messagesend.jpg)
1)发送进程准备好消息，调用send
2)内核，操作系统复制消息,将消息放到接受进程pcb消息队列队尾
3)接收进程上cpu执行到receive
4)陷入内核，操作系统复制消息到接受进程地址空间

用p,v操作实现send原语

### 共享内存
![sharememory.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/sharememory.jpg)
1.物理地址空间映射到2个进程内地址空间
2.通过读者写问题的方法解决互斥问题

### 管道通信PIPE
![PIPE.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/PIPE.jpg)

### linux，windows常用通信机制
![osipc.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/osipc.jpg)

### 屏障barrier
一组线程完成任务到达汇合点再继续

### CPU型进程和IO型进程的调度
![virtualRR.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/virtualRR.jpg)
IO型进程让出CPU进入等待队列，从等待->就绪不是进入原来的就绪队列，而是进入辅助队列。调度算法首先从辅助队列里选择进程，直到辅助队列为空，去就绪队列选进程。

### 磁盘IO的代价主要是查找时间（磁头找到柱面）
减少磁头查找的时间就把数据放在同一个盘块里。
b树每个节点（关键字个数）不超过一个磁盘块。中序遍历扫库
每次查找关键字，从树根读一个节点到内存，直到找到，层数就是读入内存的次数。
内存查找是有序表
包含n个关键字，高度为h（树根为0）,最小度数为t的B树

$ h< log_t{(n+1)/2} $ 树根2只有2个孩子


B+树只要遍历叶子节点就能实现整棵树的遍历。 VSAM虚拟存储存取法。支持range-query。
B\*树，非叶子节点加上了兄弟指针。

R树，多维B树，解决经纬度查询。Minimal Bounding Rectangle算法。从叶子节点开始表示一个空间，越往上表示的空间越大。


### 并行和并发的区别
并发：进程的执行是间断的。
并行parallelism是并发concurrency的特例/子集。
并发是一种逻辑结构的设计模式。并发是指逻辑上可以并行，并行是物理运行状态。
编写一个多线程/进程的并发程序，没有多核处理器就不能并行。
并行的两个进程一定是并发的。



### 文件/网络句柄handle 所有进程共有
进程是容器 进程无法共享内存，通信通过TCP/IP端口实现/其它操作系统的方案
线程：没有独立的地址空间，栈
线程：PC指向进程的内存 
缓冲区溢出：用户名过长没有判断就放进内存，写入程序的内存部分
TLS：Thread local strategy 线程的独立内存

### 虚拟内存
![virtualmemory.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/virtualmemory.jpg)

### 缺页中断
MMU访问虚拟内存时，这页虚拟内存还没有分配物理内存。向cpu发出缺页中断。cpu初始化物理页的内容分配，在进程页表添加映射。
`int n = *p`当p所指向的地址在虚拟内存中，不是将p的值复制给内存，而是将p所在的虚拟内存的分页放入物理内存

### 内存虚拟化方案
1. 影子页表(shadow Page Table) VMM(KVM)在宿主机内核中保存 虚拟机虚拟地址到宿主机物理地址。代价在于保持影子页表和虚拟机页表同步
2. EPT两次页表查找 不用同步。

### 可执行文件格式
![eltfile.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/eltfile.jpg)
通过`file` 查看文件类型

### 进程的虚地址空间
C语言指针的大小位数与虚拟空间的位数相同
0x000000000062FE44
```cpp
#include<stdio.h>
int main(){
    int i =0;
    int *p = &i;
    printf("0x%p",p);
    return 0;}
```
进程访问了非法地址windows"进程因非法操作需要关闭"，linux "Segmentation fault"

### Linux内存布局
![linuxmem.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/linuxmem.jpg)
windows默认将高2G分配给内核.Linux默认1G
栈：函数调用上下文
可执行文件映像 装载器
共享库 装载地址在linux2.6挪到了靠近栈的0xbfxxxxxx

### 栈
`ulimit –s` 8M
esp栈顶 esb活动记录（帧指针(frame pointer))不随函数执行变化，用于定位数据，函数返回时恢复
![foo1.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/foo1.jpg)
1. 设置好ebp esp栈指针后 
2. 开辟栈空间，保存ebx（基地址(base)寄存器） esi, edi（源/目标索引寄存器"(source/destination index)）三个寄存器
3. 将开辟出的空间初始化为0xCC
4. 通过eax（累加器"(accumulator)）返回
5. 恢复5个寄存器
6. ret返回
> ECX 是计数器(counter), 是重复(REP)前缀指令和LOOP指令的内定计数器。

```cpp
int main(){char p[12];}
```
0xCCCC（即两个连续排列的0xCC）的汉字编码就是烫，所以0xCCCC如果被当作文本就是“烫”。
如果一个指针变量的值是0xCCCCCCCC就是没初始化

### 堆
原因：1.栈上数据在函数返回时被释放，无法将数据传递函数外。2.全局变量无法动态产生。

#### malloc的实现
程序向操作系统申请堆空间，由程序运行库自己管理。
linux两种堆空间分配的系统调用
1. `int brk(void* end_data_segment)` 设置进程数据段的结束地址,
2. `mmap()`与windows的`VirtualAlloc`相似
    - 起始地址和大小必须是系统页的整数倍
    ```cpp
    void *mmp(void *start,size_t length,int prot,int flags,int fd,off_t offset);
    ```
    flag映射类型（文件映射/匿名映射） 匿名映射可以作为堆空间
    小于128k会在现有堆空间中分配，大于则使用mmap申请匿名空间
    + 用mmap实现malloc
    ```cpp
    void *malloc(size_t nbytes){
        void* ret = mmap(0,nbytes,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,0,0);//可读可写，匿名
        if(ret == MAP_FAILED)return 0;
        return ret;
    }
    ```
mmap申请空间不能超过 空闲内存+空闲swap空间

### windows 虚拟地址空间
[虚拟地址空间](https://msdn.microsoft.com/zh-cn/library/windows/hardware/hh439648.aspx)
windows 每个线程默认栈大小1M
`NTDLL.DLL`堆管理器API
windows的堆不是向上增长

### 堆分配算法
1. 空闲链表pre,next并有4个字节存储大小
2. 位图，划分成大小相同的块。用2位11表示head，10表示body，00表示空闲
    int32个字节，2个字节表示一个块的状态，假设1M堆，一块128字节=>1M/128=8K个块
    8K/(32/2)=512个int的数组存储
    Head表示已分配区的头
![heep.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/heep.jpg)
3. 对象池


1. io指令至少是没io的10^6倍
并发：一个cpu上程序交替执行
只有一个cpu只能执行一个进程
进程：运行中的程序

[内存原理](http://www.pceva.com.cn/article/223-2.html)

### cpp返回对象的临时对象
1. 输出： 经过了两次构造函数1次拷贝到栈上临时对象，1次拷贝到返回值
ctor（create）
ctor 
before return //已经被优化了，本来之后会输出copy ctor
operator=  
dtor
dtor（销毁）
{% fold %}
```cpp
#include<iostream>
using namespace std;
struct cpp_obj{
    cpp_obj(){
        cout<<"ctor\n";
    }
    cpp_obj(const cpp_obj& c){
        cout<<"copy ctor\n";
    }
    cpp_obj& operator=(const cpp_obj& rhs){
        cout<<"operator=\n";
        return *this;
    }
    ~cpp_obj(){
        cout<<"dtor\n";
    }
};
cpp_obj return_test(){
    cpp_obj b;
    cout<<"before return\n";
    return b; //return cpp_obj() 
}
int main(){
    cpp_obj n;
    n = return_test();
    return 0;
}
```
{% endfold %}

### 汇编寄存器 gcc hellow.c ->./a.out
1. 预编译：`gcc -E .\bigthingg.c -o .\bigthingg.i` 展开宏
2. 编译：链接生成汇编 `gcc -S hello.i -o hello.s`
3. 汇编`gcc -c hello.s -o hello.o`
4. 链接`ld`....
![registers.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/registers.jpg) 
[64位汇编寄存器](http://abcdxyzk.github.io/blog/2012/11/23/assembly-args/)

### 虚拟内存

CPU通过地址总线可以访问连接在地址总线上的所有外设，包括物理内存、IO设备等等，但从CPU发出的访问地址并非是这些外设在地址总线上的物理地址，而是一个虚拟地址，由MMU将虚拟地址转换成物理地址再从地址总线上发出.
CPU中含有一个被称为内存管理单元（Memory Management Unit, MMU）的硬件，它的功能是将虚拟地址转换为物理地址。MMU需要借助存放在内存中的页表来动态翻译虚拟地址，该页表由操作系统管理。
虚拟内存空间被组织为一个存放在硬盘上的M个连续的字节大小的单元组成的数组。
页表是一个元素为页表条目（Page Table Entry, PTE）的集合，有效位代表这个虚拟页是否被缓存在物理内存中。
处理缺页异常`do_page_fault()`

### inode
文件读取磁盘的最小单位是多个扇区sector组成的 块block。一般4kb,8个sector
inode：文件系统的数据结构，文件元信息
查看inode`stat example.txt`

### 系统调用、POSIX、C库、系统命令和内核函数
- POSIX（Portable Operating System Interface of UNIX，可移植操作系统接口）标准
基于UNIX的可移植 操作系统标准
- 内核提供的每个系统调用在C库中都具有相应的封装函数。
> 比如malloc函数和free函数都是通过brk系统调用来扩大或缩小进程的堆栈，execl、execlp、execle、 execv、execvp和execve函数都是通过execve系统调用来执行一个可执行文件。
![cposix](\images\cposix.jpg))
-系统命令位于C库的更上层，是利用C库实现的可执行程序，比如最为常用的ls、cd等命令。
`$trace pwd` pwd调用了那些系统调用
---

- 2类寄存器：用户可见/控制和状态 寄存器
- ？？3种I/O操作技术：可编程：处理器忙；中断驱动：；直接存储访问DMA
- 空间局部性 ： 更大的缓冲块，存储器控制逻辑+预处理
- 多道： 交错进程
- 进程状态： 执行上下文；
> 操作系统信息不允许被进程直接访问

> 上下文包括操作系统管理进程以及处理器正确执行进程所需要的所有信息，包括各种处理器寄存器的内容，如程序计数器和数据寄存器。它还包括操作系统使用的信息，如进程优先级以及进程是否在等待特定I/O事件的完成。

- 虚地址指的是存在于虚拟内存中的地址，它有时候在磁盘中有时候在主存中。
- 实地址指的是主存中的地址。

- ??单体内核和微内核

- os维护信息表： 内存,I/O,文件，进程
- 进程控制块：标识，？？处理器状态，进程控制信息
- 陷阱： 当面进程的错误or异常
- 中断例子： 时钟，I/O，内存失效

- 线程模式切换：？包含状态信息少

#### 第4章 线程、对称多处理和微内核

#### 第7章 内存管理
- 内存管理 ：
    - 重定位进程->就绪进程池->处理器利用率
    - **运行**时内存保护
    - 进程共享内存
- 内部碎片、外部碎片：数据<分区->浪费；？动态分区，分区外存储空间变多。
- 页： 进程和磁盘划分块；帧：主存划分块；一页装入一帧。
- 段： 长度可变

#### 第8章    虚拟内存

#### 第10章    多处理器和实时调度

#### 第11章   I/O管理和磁盘调度


