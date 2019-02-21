---
title: 面试卡片
date: 2018-12-25 15:34:13
tags: [面试卡片]
---
https://www.nowcoder.com/discuss/50571?type=2&order=0&pos=21&page=2
1.泛型的好处
泛型：向不同对象发送同一个消息，不同的对象在接收到时会产生不同的行为（即方法）；也就是说，每个对象可以用自己的方式去响应共同的消息。消息就是调用函数，不同的行为是指不同的实现（执行不同的函数）。
用同一个调用形式，既能调用派生类又能调用基类的同名函数。

虚函数是实现多态 "动态编联”的基础，C++中如果用基类的指针来析构子类对象，基类的析构要加`virtual`，不然不会调用子类的析构，会内存泄漏。

2.数据库索引INNDB的好处
事务，主键索引

3.CAS算法原理？优缺点？

4.为什么是三次握手
信道不可靠, 但是通信双发需要就某个问题达成一致. 而要解决这个问题, 三次通信是理论上的最小值。

为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误。
如果A发送2个建立链接给B，第一个没丢只是滞留了，如果不第三次握手只要B同意连接就建立了。
如果B以为连接已经建立了，就一直等A。所以需要A再确认。

5.为什么四次分手
1)由于TCP连接是全双工的，因此每个方向都必须单独进行关闭。
当一方完成它的数据发送任务后就能发送一个FIN来终止这个方向的连接。
收到一个 FIN只意味着这一方向上没有数据流动，一个TCP连接在收到一个FIN后仍能发送数据。首先进行关闭的一方将执行主动关闭，而另一方执行被动关闭。
2)让本连接持续时间内所有的报文都从网络中消失，下个连接中不会出现旧的请求报文。

6.数据库最左匹配原理

7.http https
![httphttps.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/httphttps.jpg)

8.进程间通信
套接字，管道，消息队列，共享内存，信号量,信号。

9.线程池的运行流程，使用参数以及方法策略
运行流程：

一共有5种线程池

10.线程同步的方法

11.C++虚函数作用及底层实现
虚函数是使用虚函数表和虚函数表指针实现的。
虚函数表：一个类 的 虚函数 的 地址表：用于索引类本身及其父类的虚函数地址，如果子类重写，则会替换成子类虚函数地址。
虚函数表指针： 存在于每个对象中，指向对象所在类的虚函数表的地址。
多继承：存在多个虚函数表指针。

12.25匹马，5个跑道，每个跑道最多能有1匹马进行比赛，最少比多少次能比出前3名？前5名？
5轮找出各组第一；5组第一跑一次，得出第一，只有前3的组可能是前3；最后一次A2, A3, B1, B2, C1参赛得出第二第三名。

13.100亿个整数，内存足够，如何找到中位数？内存不足，如何找到中位数？

14 单例模式
实现：私有静态指针变量指向类的唯一实例，并用一个公有静态方法获取该实例。
目的：保证整个应用程序的生命周期中的任何一个时刻，单例类的实例都只存在一个。

15.基于比较的算法的最优时间复杂度是O(nlog(n))
因为n个数字全排列是n! 一次比较之后，两个元素顺序确定，排列数为 n!/2!
总的复杂度是O(log(n!)) 根据斯特林公式就等于O(nlog(n))

16 快速排序
基本：
最普通的，每次取[0]作子集划分s1+[0]+s2,再递归两个子集。
最坏情况123456 O(n^2)
```java
private void qS(int[] arr,int left,int right){
        if(left>=right)return;
        int pivot = arr[right];
        // 因为保证i最后在左集合右边 用++i 
        // 所以初始化的时候边界都向外扩一格
        int i = left-1;int j = right;
        while (true){
            while (++i<=right && arr[i] < pivot);
            while (--j>=left && arr[j] > pivot);
            if(i < j){
                swap(arr,i , j);
            }
            else break;
        }
        // 把主元放到左集合右边
        swap(arr, i, right);
        qS(arr, left, i-1);
        qS(arr, i+1,right);
    }
```

注意1：
主元：1取头、中、尾的中位数比随机函数便宜。
用ifelse判断这三个数，1)把最小的放到左边2)把最大的放到右边3)把中间的数替换到最后位置上
`pivot = nums[n-1]`

然后用pivot划分子集，i从左开始，j从右开始,i最后停在j右边，交换`[i],[n-1]`，pivot放了正确的位置。

注意2：
如果有重复元素 如果11111，
1）重复元素也交换，最后pivot也会被换到中间，很等分nlogn。
2）不交换，i直接比较到最后，pivot还是在最后，变成n^2

注意3：
小规模数据集（N不到100可能还不如插入排序）
当递归的长度够小直接插入排序。

JDK `Arrays.sort()`中的根据阈值从merge，quick，insert，count sort中选一个
{% fold %}
```java
/**如果数组长度小于 this, Quicksort 优先于 merge sort.*/
private static final int QUICKSORT_THRESHOLD = 286;

/**如果数组长度小于 this , insertion sort 优先于 Quicksort.*/
private static final int INSERTION_SORT_THRESHOLD = 47;

/**如果Byte数组长度大于this, counting sort 优先于 insertion sort. */
private static final int COUNTING_SORT_THRESHOLD_FOR_BYTE = 29;

/** 如果short or char 数组长度大于 this, counting sort 优先于 Quicksort.*/
private static final int COUNTING_SORT_THRESHOLD_FOR_SHORT_OR_CHAR = 3200;

```
{% endfold %}

17 堆排序 不需要额外空间
堆（数组实现的完全二叉树）
左孩子是`(1+i<<1)` // 1+i<<2 奇数
右孩子是`(i+1)<<1` //偶数
父节点是`(i-1)>>1`

堆排序：
线性复杂度将数组调成最大堆O(n)，将堆顶和数组最后交换，堆规模-1，再调成最大堆。

```java
void heapSort(int[] arr){
    int s = arr.length;
    while (s>0) {
        s--;
        //swap(0,n-1)
        int rst = arr[0];
        int last = arr[s];
        arr[s] = rst;
        if (s != 0) {
            shifDown(arr, 0, last,s);
        }
    }
}
```

建堆方法1：
从上到下，每个新加的结点放在最右下，然后shiftUp每个 复杂度O(nlogn) (都可以做全排序了)
正确方法：
思路：
每个叶节点都成一个子堆，下滤操作能完成两个子堆的合并。

```java
private int poll(int[] arr){
    int s = arr.length - 1;
    int rst = arr[0];
    int last = arr[s];
    arr[s] = rst;
    if(s!=0){
        shifDown(arr, 0,last,arr.length);
    }
    return rst;
}
//down不会超过树的高度 所以O(logn)
private void shifDown(int[] arr,int i,int x,int len){
    int s = len;
    int half = s >>>1;
    while (i < half){
        int child = 1 + (i<<1);
        int el = arr[child];
        int rc = child+1;
        if(rc < s && arr[child] < arr[rc]){
            el = arr[rc];
            child = rc;
        }
        // 大顶堆，如果比叶子都大，下面已经是有序堆了，就完成了
        if(x >= el){
            break;
        }
        arr[i] = el;
        i = child;
    }
    arr[i] = x;
}
// log(n)
private void shifUp(int[] arr,int i,int x){
    while (i>0){
        int parent = (i-1)>>>1;
        int e = arr[parent];
        if(e >= x)break;
        // 下移父节点
        arr[i] = e;
        i = parent;
    }
    arr[i] = x;
}
void heapify(int[] arr){
    for (int i = (arr.length >>> 1) - 1; i >= 0; i--)
        shifDown(arr,i, arr[i],arr.length);
}
```

复杂度：
复杂度每个节点只需要比较的长度最多是这个节点到叶子的高度（而不是在树中的深度）。O(N)的
因为二叉树越底层节点越多。深度越高节点越多，所以上滤复杂度高。

从右下开始依次下滤，所有叶子节点都不用下滤。
如果全堆大小为n，内部节点最后一个的idx是`(n/2)-1`
例子：一共9个节点 各层1，2，4，2个。最后一个内部节点是3，它的右边和下面都是叶子。



18 没有中序没办法确定二叉树
前序 根左右
后序 左右根
找不到左右的边界