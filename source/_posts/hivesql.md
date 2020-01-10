---
title: Hive Sql
date: 2018-12-25 15:34:13
tags: [数据库]
---
1. group by 和count distinct
select count(t.order_no) from (select order_no from order_snap group by order_no) t;
原理 shuffle到一个reducer的数据太大


https://www.zhihu.com/question/60581895

2. sort by 和 order by



