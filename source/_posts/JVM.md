---
title: JVM
date: 2018-04-23 21:21:18
tags:
---
### 堆外内存

### 64位的JVM 寻址空间

## 类装载器
1. 装载：
1.取得类的二进制流：
装载器`ClassLoader` 读入java字节码装在到JVM
2.转为方法区的数据结构
3.在堆中生成对象
2. 链接：
1.验证
2.准备 `static final` 在准备阶段赋值，static被赋值0
3.解析 符号引用转换成指针or地址偏移量（直接引用）（内存中的位置）
3. 初始化`<clint>`
    `lang.NoSuchFiledError`


jvm用软件模拟java字节码的指令集
jvm规范定义了：`returnAddress`数据类型 指向操作码的指针;
输出整数的二进制
```java
 public static void main(String[] args) {
        int a = 6;
        //0x80000000表示最高位为1的数字
        for(int i =0;i<32;i++){
            //取出a的第一位 //无符号右移( >>> )
            int t = (a&0x80000000>>>i)>>>(31-i);
            System.out.print(t);
        }
    }
```

`public native String intern();`运行期间放入常量池