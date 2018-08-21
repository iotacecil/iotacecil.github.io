---
title: 操作系统+内存知识
date: 2018-03-05 20:43:15
tags: [os,memory]
---
https://hit-alibaba.github.io/interview/basic/arch/Concurrency.html
### IO多路复用
http://www.cnblogs.com/Anker/archive/2013/08/14/3258674.html

### 磁盘驱动
https://my.oschina.net/manmao/blog/746492

1. 移动磁头到磁道
2. 转动磁盘到扇区
3. 磁生电和内存读，电生磁 内存写

总线倒用技术DMA 扇区和内存

![dictuse](/images/dictuse.jpg)

算出柱面磁头扇区和读写的缓冲区直接out

抽象1：通过盘块号 操作系统 计算出柱面磁头扇区CHS


### 磁盘调度算法
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
![diaodushiji.jpg](/images/diaodushiji.jpg)
就绪队列改变->重新调度
进程调度的时机4个：
1.进程正常/错误终止
2.创建新进程/等待进程->就绪
3.进程从运行->阻塞（等待）
4.进程从运行->就绪（时间片到）
重新调度的时机：内核对 【中断/陷入（异常）/系统调用】等处理之后【返回用户态】需要重新调度。

调度程序从就绪队列里选择进程可以是刚刚被暂停的，也可以是新的进程，新的就发生进程切换。
![processchange.jpg](/images/processchange.jpg)
新的进程上cpu要用自己的地址空间
![contentstep.jpg](/images/contentstep.jpg)


高速缓存：刚才执行进程的指令和数据
TLB存放了进程的页表表项

新的进程的指令、数据、表项也要放入高速缓存和TLB

### 调度算法
![diaodumetric.jpg](/images/diaodumetric.jpg)


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
![pcbduan](/images/pcbduan.jpg)

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
![hoare.jpg](/images/hoare.jpg)
- 入口等待队列：在管程外等待的
- 如果进入管程的发现资源不够不能操作（生产者想insert，但是缓冲区(资源)满了)则进程wait进入不同的条件变量队列。释放，并让入口等待队列的进入管程。
- 后进入的进程p发现资源够了会signal条件变量队列中的进程q。
- p唤醒q，p进入紧急等待队列(比入口等待队列优先级高)，q进程从条件变量队列中出来继续执行
![hoarecondition.jpg](/images/hoarecondition.jpg)
- 条件变量 c链：条件变量队列
可以用信号量和pv操作构造管程。
用管程解决生产者消费者问题：
![pcp](/images/pcp.jpg)

 hoare的缺点：2次额外的进程切换

3.MESA：a等待(本来在条件变量等待，现在在另一个队列等待)，b继续
从hoare的signal->notify
- notify(x) x是条件变量，x条件变量队列上的进程得到通知，发信号的继续执行。
问题：不能保证将来x条件还成立 所以notify的进程上cpu执行还要重新检查条件
- 用while取代if
![mesa](/images/mesa.jpg)
改进：给条件队列等待+计时器，自动变成就绪态(因为被调度的时候还是会检查条件)
改进：broadcast 释放所有等待条件变量的进程

### Pthread互斥(lock操作互斥量)同步(wait/signal条件变量)
pthread线程库实现条件变量的signal 是mesa管程的语义
![pthread](/images/pthread.jpg)
![condition_wait.jpg](/images/condition_wait.jpg)

### 进程通信
信号量和管程不能多处理器，也不能传大量信息（大数组）
1. 消息传递
发送进程准备好消息，但是发送进程只能在自己的地址空间，不能去接收进程的地址空间操作，必须靠操作系统的消息缓冲区。
![messagesend.jpg](/images/messagesend.jpg)
1)发送进程准备好消息，调用send
2)内核，操作系统复制消息,将消息放到接受进程pcb消息队列队尾
3)接收进程上cpu执行到receive
4)陷入内核，操作系统复制消息到接受进程地址空间

用p,v操作实现send原语

### 共享内存
![sharememory.jpg](/images/sharememory.jpg)
1.物理地址空间映射到2个进程内地址空间
2.通过读者写问题的方法解决互斥问题

### 管道通信PIPE
![pipe.jpg](/images/PIPE.jpg)

### linux，windows常用通信机制
![osipc.jpg](/images/osipc.jpg)

### 屏障barrier
一组线程完成任务到达汇合点再继续

### CPU型进程和IO型进程的调度
![virtualRR](/images/virtualRR.jpg)
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
![virtualmemory.jpg](/images/virtualmemory.jpg)

### 缺页中断
MMU访问虚拟内存时，这页虚拟内存还没有分配物理内存。向cpu发出缺页中断。cpu初始化物理页的内容分配，在进程页表添加映射。
`int n = *p`当p所指向的地址在虚拟内存中，不是将p的值复制给内存，而是将p所在的虚拟内存的分页放入物理内存

### 内存虚拟化方案
1. 影子页表(shadow Page Table) VMM(KVM)在宿主机内核中保存 虚拟机虚拟地址到宿主机物理地址。代价在于保持影子页表和虚拟机页表同步
2. EPT两次页表查找 不用同步。

### 可执行文件格式
![eltfile](/images/eltfile.jpg)
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
![linuxmem](/images/linuxmem.jpg)
windows默认将高2G分配给内核.Linux默认1G
栈：函数调用上下文
可执行文件映像 装载器
共享库 装载地址在linux2.6挪到了靠近栈的0xbfxxxxxx

### 栈
`ulimit –s` 8M
esp栈顶 esb活动记录（帧指针(frame pointer))不随函数执行变化，用于定位数据，函数返回时恢复
![foo](/images/foo1.jpg)
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
![heep](/images/heep.jpg)
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
![registers.jpg](/images/registers.jpg) 
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
![cposix](\images\cposix.jpg)
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


