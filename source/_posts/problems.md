---
title: problems
date: 2018-03-09 08:39:10
tags: [git,hexo]
category: [JVMlinux常用备注nginxredis配置]
---
### windows bat定时自动提交
```sh
schtasks  /create  /tn  autoPush /tr  "cmd /c
D:\iotacecil.github.io\pushBlog\_pushBlog.bat"  /sc  DAILY /st  10:31:
00
# _pushBlog.bat
call D:
call cd D:\iotacecil.github.io

call hexo g -d
call git fetch
call git merge
call git add .
call git commit -m"windows自动提交定时任务"
call git push
#pause
# call chcp 437
```

### javaC 编码
错误: 编码GBK的不可映射字符
    //todo 鍐欑殑鐪熸槸闅剧湅 娓呴啋浜嗗啀鍐?
Linux下为UTF-8编码，javac编译gbk编码的java文件时，容易出现“错误: 编码UTF8的不可映射字符”解决方法是添加encoding 参数：javac -encoding gbk WordCount.java


Windows下为GBK编码，javac编译utf-8编码的java文件时，容易出现“错误: 编码GBK的不可映射字符”解决方法是添加encoding 参数：javac -encoding utf-8 WordCount.java



javac -encoding UTF-8 xxx.java
idea ctrl+Q document


git config --global gui.encoding utf-8 


GC overhead limit exceeded

0x7fffffff指的不是单个数组的字间，而是整个用户态程序的寻址空间

32位的处理器的地址长度是32位,所以他能表示大最大地址是 2^32， 指针表示的是地址，所以指针也是32位的， 但是 windows 对内存做了分区, 进程可用的内存地址范围是 0x00010000 ~ 0x7FFFFFFF，

虚拟机traceroute超时没回应

不要把xshell的ctrl-c变成复制，不然没办法结束程序

IBM的文档总是跳转登录页面，左上角禁用js。

tampermonkey一直在向//cr-input.mxpnl.net发请求 

---
- fallthrough 是什么
idea提示代码过长怎么办？


### docker toolo安装
1. vb环境变量后面要加'\'
2. 获取不到ip 等
3. 加速器DaoCloud 要在etc/docker/deamon.json里去掉最后的逗号 并且要`service docker restart`

### netty in action>>
`The POM for nia:utils:jar:2.0-SNAPSHOT is missing, no dependency information available`
`mvn install -pl utils`

1. java ASM
1. # coding=UTF-8
1. IDEA Push failed: Failed with error: fatal: Could not read from remote repository
`IDEA->setting->git -> ssh executable ->native`

2. PYDEVD_LOAD_VALUES_ASYNC=True;
-  disable "Show command line afterwards" 
https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000749030-How-to-stop-interactive-console-running
3. Intel MKL FATAL ERROR: Cannot load mkl_intel_thread.dll.
4. hexo markdown的坑小胡子语法两个大括号会报错！！！！二维数组！！

5. windows 启动zookeeper Server闪退；环境变量里要设置JAVA_HOME变量

