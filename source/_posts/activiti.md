---
title: activiti和项目整理
date: 2018-09-05 20:51:32
tags:
---
查看tomcat启动
`jps -mlv`
复制3个war包到tomcat webapp
`http://localhost:8080/activiti-app/`
admin test
`http://localhost:8080/activiti-admin`
admin admin

`git checkout -b bpmnLearn activiti-6.0.0`
`mvn clean test-compile`

### models-activiti-engine 包结构
cfg : 配置
compatibility : 兼容性
debug : 使用debug下的功能 看内部运行机制 可以看到更多log 
delegate ： 实现节点的类
event ： 节点的事件监听机制
form : 工作流的表单 节点的通用表单
history : 工作流跑完每个节点的记录 为保证运行时的速度 流程执行完的数据放到history
identity : 节点的权限认证
impl ： 实现 其他都是 概念定义 和 接口配置
logging : 打印上下文变量（？的日志 可以看到这条日志是在执行哪个流程的时候打印的
management : 管理相关的接口和api
parse : 解析流程文件的xml
query ： 查询接口 依赖mybatis
repository : 流程部署到数据库
runtime ： 执行过程中的api 执行完放到history
task ： 人工处理的节点
test : 单元测试 集成测试
其他异常类xxxException
其他xxxService

`resources` 目录 配置文件
META-INF.services里的文件 指定`ScriptEnginFactory`
org.activiti 里
    db：各种数据库脚本sql文件，对应mybatis的配置文件xml，数据库的properties文件(数据库方言)，db升级
    engine.impl 流程的logo misc 国际化文件

`test` 目录
单元测试
resource log4j的配置文件等


### Activiti 6.0 模块

#### 核心模块
activiti-engine 核心引擎
activiti-spring Spring 集成模块
activiti-spring-boot SpringBoot 集成模块 提供了stater和autoconfigure
activiti-rest 对外无状态 rest api 模块 方便为其他第三方提供服务
activiti-form-engine 表单引擎模块 方便自定义表单模型
activiti-Idap 集成Idap用户模块

### 依赖的模块
bpmn-converter 模型转换模块
process-validation 模型流程校验模块
image-generator xml绘制图形模块
dmn-api 决策标准
form-api 
form-model


### 启动models-activiti-app
```sh
cd D:\Activiti\modules\activiti-ui
mvn clen tomcat7:run
```
访问：http://localhost:9999/activiti-app/

### activiti-ui模块
activiti-app ： activiti集成发布的war工程 没有java代码 只有前端和依赖的jar包
以下都是jar包作为-app的依赖
activiti-app-conf ： 业务外的配置 数据源 集成的内容
activiti-app-logic ： ui实现的业务逻辑 
activiti-app-rest ： 提供rest api接口