---
title: es搜房网
date: 2019-01-07 19:27:02
tags: [项目流程]
category: [项目流程]
---
### Elasticsearch 搭建
不能以root启动
```shell
groupadd elasticsearch
useradd elasticsearch -g elasticsearch -p elasticsearch
chown  -R elasticsearch.elasticsearch *
su elasticsearch
```

安装es插件
```shell
wget https://github.com/mobz/elasticsearch-head/archive/master.zip
# 安装nodejs
sudo yum install nodejs
cd elasticsearch-head
npm install
# 两个进程跨域
cd elasticsearch-5.5.2
vim config/elasticsearch.yml
# 最后加 并且绑定ip
http.cors.enable: true
http.cors.allow-origin: "*"

## 启动es
./elasticsearch -d
## 启动head
npm run start
ps aux | grep ‘elastic’

sysctl -w vm.max_map_count=262144
```
改limit需要重启(?)





