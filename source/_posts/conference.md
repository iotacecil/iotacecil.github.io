---
title: ICSOC NASAC 会议记录
date: 2018-11-14 15:31:21
tags: [会议记录]
---
需求、设计与演化质量
特约报告 移动Web软件系统体验质量解析与优化


---

数据集
http://www.ntu.edu.sg/home/gaocong/datacode.htm

《eTOUR: A Two-Layer Framework for Tour Recommendation with Super-POIs》
https://link.springer.com/chapter/10.1007/978-3-030-03596-9_55#Sec3
大景点（large-scale POI）：
例如 外滩 有多个出口，里面包含了很多小景点的情况。希望对小景点内也有路径，而不是直接经过它。

先把大景点当一个，然后内景点的路径动态适应外路径。。
Outer Model
Local search
GRASP .Greedy Randomized Adaptive Search Procedure[3]
内景点DFS 剪枝：剩余时间/重复节点

数据集 爬百度地图的北京和杭州的

可用的参考文献：
《Personalized multi-period tour recommendations》：
foursquare的数据集分成了6类 66个小类
多天的行程规划 每个POI有时间窗。
用taba search和启发式的算法。
评价的时候用了Transport time/Service time/Waiting time


---

《E-Tourism: Mobile Dynamic Trip Planner》
