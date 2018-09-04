---
title: mySQL
date: 2018-04-08 18:48:55
tags:
categories: [数据库dockerHadoop微服务]
---
## mybatis逆向工程`generatorConfig.xml`

`explain`执行计划 ：select,update,insert,replace,delete

## 分区
`show plugins;`
可以看到partition 则可以分区。逻辑上一个表，物理上多个文件中。
在create table的最后加上`partition by hash(id) partitions 4`
`.frm`存储表数据
`.ibd`inndb数据文件
分区之后`.ibd`会有好几个

hash分区 利用表中的int列或者`by hash(UNIX_TIMESTAMP(login_time))`将timestamp转成int
range分区 log推荐使用 日期/时间 查询的时候包含分区键 适合定期清理历史数据
```sql
partition by range(id)(
    partition p0 values less than(10000),
    partition p1 values less than(20000),
    partition p3 values less than maxvalue);
```
list分区 按枚举
```sql
partition by list(type)(
    partition p0 values in (1,3,5,7,9),
    partition p1 values in (2,4,6,8));
```

到了新的一年添加分区
```sql
alter table t1 add partition (partition p4 values less than(2018));
```
删除分区
```sql
alter table t1 drop partition p0;
```
归档新建一个和t1结构相同的 非分区表t2 .一般迁移后删除分区，切换归档表的存储引擎
分区表只能查询不能写 分区表梗适合用mysam引擎
```sql
alter table t1 exchange partition p0 with table t2;
#--drop之后切换引擎
alter table t2 ENGINE=ARCHIVE;
```

password用char(32)
`timestamp on update CURRENT_TIMESTAMP`字段会在表被修改时自动更新

## Mybatis
1. mybatis-3-config.dtd: 可以用`<properties>`导入配置文件
在`<mappers>`里可以用`<package>`导入整个有mapper.xml的文件夹
2. mybatis-3-mapper.dtd
`<typeAliases>`中添加`<package>`自动扫描包，将类名作为别名

`PageHelper.orderBy("price desc")`按价格降序（sql中的order by 之后的格式）

### mysql like通配符
`%` 任意多个字符

### ER图
矩形：实体
特化：自顶向下继承设计
概化：底向上
菱形：联系集：把多对多变成1对多 用虚线连接联系集的属性
    双线：全参与：表示在联系集中的参与度`<advisor>`=student表示每个学生都要有导师，
双边菱形：表示弱实体集和它依附的实体集。当弱实体集里放入依赖的实体集的id，则不需要联系集
![weeken](/images/weeken.jpg)

椭圆：属性
角色：<先修课联系集>和[课程]的联系通过course_id和prereq_id角色标识区分
派生属性：可以通过其它属性计算得到
复合型属性应该拆分成2个属性
多值型（一个老师对应多个电话）应该用另一个(id,phone)(1,phone1)(1,phone2)每个属性映射到单行
映射基数：1：1，1：n,n:1,n:n
基数约束：`导师<-<advisor>-学生` 
    一对一：箭头从关系指向实体：导师<-`<advisor>` 一名学生只有一名导师 
     一对多：没有箭头表示多端，有箭头表示“一”端 `<advisor>`-学生 一名老师可以有多名学生。
`导师 0..* <advisor> 1..1 学生` 参与的上限..下限，0表示老师参与的下线是0，不是全参与，是半参与。

天然的三元关系 导师 项目 学生 通过一个联系集不能拆分成2个二元关系。


1. 什么时候作为实体:instructor/ins-phone/phone三张表什么时候作为属性instructor(phone)
- 只对名字和单值（不是多值（对应多个电话））感兴趣则为属性：性别。
- 一个对象除了名字意外，还有其它属性要描述则定义成实体：电话、住址、部门。

2. 是实体集还是用联系集（对象之间的动作）：考虑映射的基数
customer-`<loan>`-branch 但是当要表示一个客户在一个银行里多笔贷款
customer-`<borrow>`-loan(实体)-`<Loan-bra>`-branch
客户与贷款多对多，贷款对支行一对多。

3. 用属性student(supervisior-id,supervisior-name)还是用联系集`<stu-sub>`,`<stu-class>`

innodb有索引组织表

IP地址字符串转int
`INET_ATON('255,255,255,255')`=4292967295(无符号int最大值)
`INET_NTOA('4292967295')`='255,255,255,255'
`Varchar(255)`utf-8汉字3个字节 总共765字节
避免使用`TEXT`64k,`BLOB` 可以用varchar  mysql内存映射表不持支，所以排序只能用磁盘映射表

timestamp只能存到2038年01-19

`decimal`精确浮点类型

预编译语句 每次执行只需要传递参数 节省带宽
```sql
prepare stmt1 from 'select sqrt(pow(?,2)+pow(?,2)) as hypotenuse';
set @a=3;
set @b=4;
execute stmt1 using @a,@b;
deallocate prepare stmt1
```

将`where date(ctime)="20160901"`改成`where ctime>='20160901 and ctime<'20160902`可以使用索引

第三范式 不存在 传递函数依赖关系 名字可以决定分类；分类可以决定分类描述 则存在非关键字段 分类描述 对名称的依赖

范围查询会使联合索引失效 要把范围查询的表放到索引右侧
使用`leftjoin`/`not exists`代替 `not in`（会使索引失效

索引列的循序 区分度(列中唯一值数量/总行数)高的放在联合索引左边
不使用外键 外键用于数据参照完整性（数据一致性）但是降低写性能，可以用其它方式保证一致性 但是要在表之间的关联键上建立索引

## 慢查询
开启慢查询日志 SQL监控
```sql
show variables like 'slow_query_log';
```
记录没有使用索引的sql
log_queries_not_using_indexes 变量
```sql
show variables like '%log%';
set global log_queries_not_using_indexe=on;
set long_query_time = 1;
```
long_query_time超过多少秒之后的查询记录在日志中
查看慢查询日志的位置
```sql
show variables like 'slow%';
```

### 慢查询分析工具mysqldumpslow

### `count(1)`和`count(*)`和`count(*)`
count(1)比`count（*）`效率高一些
```sql
create table t(id int);
insert into t value(1),value(2),(null);
select count(*),count(id),count(1) from t;
```

| `count(*)` | `count(id)` | `count(1)` | 
| ------| ------ | ------ |
| 3 | 2 | 3 |


#### 内置类型
now()

#### 数据类型
1. `int(11)`和`int(21)`都占4个字节，区别在于补零位数
```sql
create table t(a int(11) zerofill, b int(21) zerofill);
insert into t values (1, 1);
select * from t;
```
2. `char`和`varchar`存储字符数。
    1. char 存储255个字符，varchar根据类型计算字符数，上限是65535个字节
    2. char会自动补空，varchar<=255用一个字节>255用两个字节存储长度length
    3. 

`desc` 查看表结构

#### mysql join
1. `inner join`内连接，两张表的公共部分 数据库会先在每个表里先查条件再生成笛卡儿积
`select a.name from a A inner join b B on A.name =B.name;`
2. `left outer join`左外连接，以左表为基础 内链接当左表中查询条件是null的时候被忽略，外连接则有
![left_join](/images/left_join.jpg)
用左外连接查询只存在A中不存在B中的where B.Key is NULL (优化not in不会使用索引)
![left_only_join](/images/left_only_join.jpg)
`select * from b left outer join a on a.name =b.name where a.Id is null;`
3. `right outer join`
`select * from a right outer join b on a.name =b.name where a.Id is null;`
4. `full join`
![full_join](/images/full_join.jpg)

### `count(*),min(p.'price') group by p."id","name"`

### 数据库
Myisam表锁 -> Innodb 行锁 从大锁到小锁提升并行度
MyISAM引擎不持支事务，优点是读写快,列存储5.5之前的默认
Innodb支持事务ACID 行级锁，高并发场景好
1. JDBC
`static final String JDBC_DRIVER="com.mysql.jdbc.Driver";`
    1. close放在finally里，保证执行
    2. 防止空指针异常 
    ```java
   finally{
            if(conn!=null)conn.close();
            if(stmt!=null)stmt.close();
            if(rs!=null) rs.close();
        }
    ```
2. 游标：读取记录太多，内存放不下。DB_URL:`useCursorFetch=true`
    1. ```java
    static final String DB_URL ="jdbc:mysql://localhost/scraping?characterEncoding=utf8&useCursorFetch=true&useSSL=true";```
    2. `ptmt=conn.prepareStatement(sql);` 
        每次从服务器端取回记录的数量`ptmt.setFetchSize(1);` 
        `rs = ptmt.executeQuery();`
3. 流方式:记录中存在大字段内容：博文。读一条记录内存可能放不下。
    变成二进制流读取小区间
    1. `InputStream in = ResultSet.getBinaryStream("blog")`
    2. 在外部生成一个文件，每次读取一行输出到外部文件
```java
File f = new File(FILE_URL);
OutputStream out = null;
out = new FileOutputStream(f);
int tmp = 0;
while((tmp= in.read)!==-1)out.write(tmp);
in.close();
out.close();
```

#### 连接池
1. `DriverManager.getConnection`流程
客户端利用密码种子和自己保存的数据库密码按加密算法得到`加密密码`
![JDBC_conn](/images/JDBC_conn.jpg)
2. 每个线程使用数据库连接后不销毁，每个请求从连接池中【租借】连接
3. 数据库服务器端处理请求时要分配资源，请求结束后被释放。服务器设置最大并发连接数。抛toomanyConnection异常。应在客户端中实现业务线程排队获取数据库连接。

#### DBCP
是一组jar包：`commons-dbcp,jar`,`commons-pool.jar`,`commons-logging.jar`
1. dbcp重写了Connection的close方法，把销毁数据库连接改成了归还给连接池
```java
public static void dbpoolInit(){
    db = new BasicDataSource();
    db.setUrl(DB_URL);
    db.setDriverClassName(JDBC_DRIVER);
    db.setUsername(USER);
    db.setPassword(PASSWORD);
    db.setMaxTotal(2);
}
```
4. 优化连接池
    1. 提高第一次访问数据库的速度，在连接池中预制一定数量的连接`.setInitialSize(1)`
    2. `.setMaxTotal()`设置客户端的最大连接数，超过的不创建新连接，而是进入等待队列
    3. `.setMaxWaitMillis()`设置最大等待时间
    4. `.setMaxIdel()`空闲连接数的最大值，超过则销毁
    5. `setMinIdel()`空闲数低于则创建，建议于`MaxIdel`相同
5. DBCP定期检查，服务端会自动关闭空闲连接，连接池可能租借失效的连接
    1. 定期检查连接池中连接的空闲时间 开启`.setTestWhileIdel(True)`
    2. 应该销毁的最小空闲时间`.setMinEvictableIdleTimeMillis()`
    3. 检查的时间间隔,应小于服务器自动关闭连接的时间（Mysql 8小时)`.setTimeBetweenEvictionRunsMillis()`
6. Mysql `show processlist;`查看连接数

### 防范SQL注入`'--`
1. 参数化sql  `conn.prepareStatement(sql)`传入格式化sql,需要传入的参数用？占位
```sql
Select * from user where userName = ? And password=?
```
2. 传入参数`ptmt.setString(1,username)` 参数位置从左往右1开始
3. 数据库权限、封装数据库异常
4. mysql `AES_ENCRYPT/AES_DECRYPT`string加密/解密
---

### 事务：单个逻辑工作单元执行的一系列操作，逻辑工作单元满足ACID(原子、一致、隔离、持久) ，并发控制的基本单位。
```java
try{
Connection.setAutoCommit(false)//开启事务
Connection.commit()//提交事务
Connection.rollback()//事务回滚
}catch(SQLException e){
    if(Connection!=null)Connection.rollback()
}
```

#### 检查点
```java
Savepoint sp = Connection.setSavepoint();
Connection.rollback(sp);
```

#### 事务的隔离级别
- **脏读**：一个事务读取了一个事务未提交的更新
![zangdu](/images/zangdu.jpg)
- 不可重复读：同一个事务，两次读取值不一样。
- 幻读：同一个事务，两次读取行记录数目不一样。插入了新记录
![geli](/images/geli.jpg)
| 隔离级别 | 脏读 | 可重复读 | 幻读 |
| ------| ------ | ------ | ------ |
| 读未提交 | √ |  X | √ |
| 读提交 | X | X | √ |
| 可重复读 | X  | √ | √ |
| 串行化 | X | √ | X |

1. 读未提交：允许脏读
2. 读提交：不允许脏读，可以不可重复读
3. 重复读：可能出现幻读。 MySQL的事务隔离级别。
```sql
set
```
4. 串行化：最高隔离级别，所有事务串行执行，不能幻读。
- 设置和获取事务隔离级别
```java
Connection.getTransactionIsolation()
Connection.setTransactionIsolation()
```

#### MySQL的锁
1. 排他锁X：与任何锁都冲突，等待。（写锁）
2. 共享锁S：多个事务共享一把锁。其它事务不会被阻塞。（读锁）
加锁方式
1. 外部加锁：SQL语句
    1. 共享 `select * from table lock in share mode`
    2. 排他 `select * from table for update`
2. 内部自动加锁
3. 加锁粒度和策略：表锁table lock：开销少；行锁（row lock): innoDB 

MySQL所有的select读都是快照读。存储引擎Innodb实现了多版本控制（MVCC)，不加锁快照读。
所以一个事务内部保证select数据一致要外部加锁
- MVCC 在每行记录后面保存两个隐藏的列：行创建时间，过期时间。通过版本号记录时间，每开始新的事务，系统版本递增。
1. Update 对行加排他锁X
- 分析MySQL处理死锁：`show engine innodb status`

### Mybatis 底层基于JDBC
1. SqlSessionFactory实例能将对象操作转换成数据库操作
事务管理器`transactionManager type = "jdbc`
`dataSource`驱动、url、用户名、密码
2. 对象类、操作接口
3. 映射文件`<mapper namespace = "操作接口">`
4. 将映射文件加载到配置文件`<mappers><mapper resource="">`
5. 测试
```java
public static void main(String[] args) {    
     // 1. 声明配置⽂文件的⺫⽬目录渎职   
     String resource = "confAnnotation.xml";    
     // 2. 加载应⽤用配置⽂文件   
     InputStream is = HelloMyBatisAnnotation.class.getClassLoader().getResourceAsStream(resource); 
     // 3. 创建SqlSessonFactory   
     SqlSessionFactory sessionFactory = new SqlSessionFactoryBuilder()  
             .build(is);    
     // 4. 获取Session    
     SqlSession session = sessionFactory.openSession(); 
     try {  
             // 5. 获取操作类（接口）    
        GetUserInfo getUserInfo = session.getMapper(GetUserInfo.class); 
             // 6. 完成查询操作   
         User user = getUserInfo.getUser(11);   
         System.out.println(user.getId() + " " + user.getUserName() + " " + user.getCorp()); 
         } finally {    
             // 7.关闭Session 
             session.close();   
         }  
     }  
```
- 在操作接口上用注解@select

#### ResultMap
1. 构造方法 mapper.xml
```xml
<resultMap id="UserMap" type="com.micro.profession.mybatis.resultMapTest.User">
     <constructor>  
         <idArg column="userId" javaType="int" />   
         <arg column="userName" javaType="String" />    
         <arg column="corp" javaType="String" />    
     </constructor> 
     <collection>
        <association>
        </association>
    </collection>
 </resultMap>
```








