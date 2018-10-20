---
title: java秒杀
date: 2018-10-16 21:18:11
tags:
category: [项目流程]
---

### 1.前后台json格式
实现效果，在Controller调用静态方法：
    成功：`Result.success(data);` 成功时只返回数据
    异常：`Result.error(CodeMsg);` 包括code和msg
```java
class Result<T> {
    private int code;
    private String msg;
    private T data;
    /**
     * 成功时候的调用
     * */
    public static <T> Result<T> success(T data){
        return new  Result<T>(data);
    }

    /**
     * 失败时候的调用
     * */
    public static <T> Result<T> error(CodeMsg cm){
        return new  Result<T>(cm);
    }
    // 构造函数private 不被外部调用，外部只能使用2个静态方法
    // 失败构造
    private Result(CodeMsg cm) {
        if(cm  == null) {
            return;
        }
        this.code = cm.getCode();
        this.msg = cm.getMsg();
    }
    //成功构造
    private Result(T data) {
        this.code = 0;
        this.msg = "success";
        this.data = data;
    }
}
```
controller中测试：
```java
@Controller
//@RequestMapping("/demo")
public class DemoController {
    @RequestMapping("/hello")
    @ResponseBody
    public Result<String> hello() {
        return Result.success("hello");
       // return new Result(0, "success", "hello");
    }
    @RequestMapping("/helloError")
    @ResponseBody
    public Result<String> helloError() {
        return Result.error(CodeMsg.SERVER_ERROR);
        //return new Result(500102, "XXX");
    }
}
```

封装错误信息类，用于生成各种各样的错误信息（枚举类？）
//后面很难改 不要用枚举
//外部只能调用静态变量
```java
public class CodeMsg {
    private int code;
    private String msg;
    
    //通用异常
    public static CodeMsg SUCCESS = new CodeMsg(0, "success");
    public static CodeMsg SERVER_ERROR = new CodeMsg(500100, "服务端异常");
    //登录模块 5002XX
    
    //商品模块 5003XX
    
    //订单模块 5004XX
    
    //秒杀模块 5005XX
    
    //私有
    private CodeMsg(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }
}
```

{% fold %}
```java
public enum  CodeMsg {
    SUCCESS(0,"success"),
    SERVER_ERROR(500100,"服务端异常");
    private final int code;
    private final String msg;
    private CodeMsg( int code,String msg ) {
        this.code = code;
        this.msg = msg;
    }
    public int getCode() {
        return code;
    }
    public String getMsg() {
        return msg;
    }
}
```
{% endfold %}

测试：
访问`http://localhost:8080/hello`
`{"code":0,"msg":"success","data":"hello,imooc"}`
访问：`http://localhost:8080/helloError`
`{"code":500100,"msg":"服务端异常","data":null}`


### 2.添加页面模板 配置文件配置项
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#common-application-properties
`/resources/aplication.properties`
```proerties
spring.thymeleaf.cache=false
spring.thymeleaf.content-type=text/html
spring.thymeleaf.enabled=true
spring.thymeleaf.encoding=UTF-8
spring.thymeleaf.mode=HTML5
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
```
controller返回页面
```java
@RequestMapping("/hel")
public String  thymeleaf(Model model) {
    //写入model的属性可以在页面中取到
    model.addAttribute("name", "名字");
    //找的是prefix+hello+sufix ->/templates/hello.html
    return "hello";
}
```
`/resources/templates/hello.html`
```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>hello</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<p th:text="'hello:'+${name}" ></p>
</body>
</html>
```

### 3. Mybatis
http://www.mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure/

```
mybatis.type-aliases-package=package.model
#下划线转驼峰
mybatis.configuration.map-underscore-to-camel-case=true
mybatis.configuration.default-fetch-size=100
mybatis.configuration.default-statement-timeout=3000
# 配置文件扫描 接口类和xml
mybatis.mapperLocations = classpath:package/dao/*.xml
```
数据源druid
```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>1.3.1</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.0.5</version>
</dependency>
```
```
# druid
spring.datasource.url=jdbc:mysql://10.1.18.133:3306/maiosha?useUnicode=true&characterEncoding=utf-8&allowMultiQueries=true&useSSL=false
spring.datasource.username=root
spring.datasource.password=root
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
spring.datasource.filters=stat
spring.datasource.maxActive=2
spring.datasource.initialSize=1
spring.datasource.maxWait=60000
spring.datasource.minIdle=1
spring.datasource.timeBetweenEvictionRunsMillis=60000
spring.datasource.minEvictableIdleTimeMillis=300000
spring.datasource.validationQuery=select 'x'
spring.datasource.testWhileIdle=true
spring.datasource.testOnBorrow=false
spring.datasource.testOnReturn=false
spring.datasource.poolPreparedStatements=true
spring.datasource.maxOpenPreparedStatements=20
```
新建数据库并添加user表 
ID:int(11) name:varchar(255)
添加数据 1 小明
新建`/domain/User`对象
```java
public class User {
    private int id;
    private String name;
    //get/set
}
```
新建`/dao/UserDao`层interface UserDao
```java
@Mapper
public interface UserDao { 
    @Select("select * from user where id = #{id}")
    public User getById(@Param("id")int id  );
}
```
写service
```java
@Service
public class UserService {  
    @Autowired
    UserDao userDao;

    public User getById(int id) {
         return userDao.getById(id);
}
```
添加到controller
```java
@Controller
@RequestMapping("/demo")
public class SampleController {
    @Autowired
    UserService userService;
    @RequestMapping("/db/get")
    @ResponseBody
    public Result<User> dbGet() {
        User user = userService.getById(1);
        return Result.success(user);
    }
}
```
访问： http://localhost:8080/demo/db/get
返回： {"code":0,"msg":"success","data":{"id":1,"name":"小明"}}

测试事务：数据库中已经有id=1的数据，连插入id=2，id=1的数据，如果能回滚就行
dao:
```java
@Mapper
public interface UserDao {
    
    @Select("select * from user where id = #{id}")
    public User getById(@Param("id") int id);
    //添加Insert方法
    @Insert("insert into user(id, name)values(#{id}, #{name})")
    public int insert(User user);
    
}
```
service:
```java
//注解注释掉 报错但插入了id=2
@Transactional
public boolean tx() {
    //整体在一块（一个事务）
    User u1= new User();
    u1.setId(2);
    u1.setName("2222");
    userDao.insert(u1);
    // 这条失败上面也不会插入
    User u2= new User();
    u2.setId(1);
    u2.setName("11111");
    userDao.insert(u2);
    return true;
}
```
controller:
```java
@RequestMapping("/db/tx")
@ResponseBody
public Result<Boolean> dbTx() {
    userService.tx();
    return Result.success(true);
}
```
测试：
访问：`http://localhost:8080/demo/db/tx`
数据完整性错误，但是2没有被插入
```
Whitelabel Error Page
This application has no explicit mapping for /error, so you are seeing this as a fallback.

Tue Oct 16 22:27:57 CST 2018
There was an unexpected error (type=Internal Server Error, status=500).
### Error updating database. Cause: com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException: Duplicate entry '1' for key 'PRIMARY' ### The error may involve com.cloud.miaosha.dao.UserDao.insert-Inline ### The error occurred while setting parameters ### SQL: insert into user(id, name)values(?, ?) ### Cause: com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException: Duplicate entry '1' for key 'PRIMARY' ; SQL []; Duplicate entry '1' for key 'PRIMARY'; nested exception is com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException: Duplicate entry '1' for key 'PRIMARY'
```



### 5.集成Redis
https://github.com/xetorthio/jedis
```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
</dependency>

<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.38</version>
</dependency>
```
配置：
```
redis.host=10.1.18.133
redis.port=6379
redis.timeout=3
redis.password=123456
redis.poolMaxTotal=10
redis.poolMaxIdle=10
spring.redis.pool.max-wait=3
```
新建redis包
配置类`RedisConfig`
```java
@Component
//获取配置文件 配置里的前缀 
@ConfigurationProperties(prefix="redis")
public class RedisConfig {
    private String host;
    private int port;
    private int timeout;//秒
    private String password;
    private int poolMaxTotal;
    private int poolMaxIdle;
    private int poolMaxWait;//秒
}
```
#### Service
通过service提供Redis的get/set
```java
@Service
public class RedisService{
    @Autowired
    JedisPool jedisPool;
    public<T> T get(String key,Class<T> clazz){
        Jedis jedis = jedisPool.getResource();
    }
    @Autowired
    RedisConfig redisConfig;
    @Bean
    public JedisPool JedisFactory(){
        JedisPoolConfig poolConfig = new JedisPoolConfig();
        poolConfig.setMaxIdle(redisConfig.getPoolMaxIdle());
        poolConfig.setMaxTotal(redisConfig.getPoolMaxTotal());
        poolConfig.setMaxWaitMillis(redisConfig.getPoolMaxWait() * 1000);
        //redis默认16个库，从0库开始
        JedisPool jp = new JedisPool(poolConfig, redisConfig.getHost(), redisConfig.getPort(),redisConfig.getTimeout()*1000, redisConfig.getPassword(), 0);
        return jp;
    }
}
```

查看源码找JedisPool中的timeout是什么单位
redis 默认6个库从0开始
```java
JedisPool jp = new JedisPool(poolConfig, redisConfig.getHost(), redisConfig.getPort(),redisConfig.getTimeout()*1000, redisConfig.getPassword(), 0);
//JedisPool.java
public JedisPool(final GenericObjectPoolConfig poolConfig, final String host, int port,int timeout, final String password, final int database) {
    this(poolConfig, host, port, timeout, password, database, null);
}
//this
public JedisPool(final GenericObjectPoolConfig poolConfig, final String host, int port,final int connectionTimeout, final int soTimeout, final String password, final int database,
  final String clientName, final boolean ssl, final SSLSocketFactory sslSocketFactory,
  final SSLParameters sslParameters, final HostnameVerifier hostnameVerifier) {
super(poolConfig, new JedisFactory(host, port, connectionTimeout, soTimeout, password,
    database, clientName, ssl, sslSocketFactory, sslParameters, hostnameVerifier));
}
```
JedisFactory
```java
public JedisFactory(final String host, final int port, final int connectionTimeout,
  final int soTimeout, final String password, final int database, final String clientName,
  final boolean ssl, final SSLSocketFactory sslSocketFactory, final SSLParameters sslParameters,
  final HostnameVerifier hostnameVerifier) {
this.hostAndPort.set(new HostAndPort(host, port));
//找用到connect time的地方
this.connectionTimeout = connectionTimeout;
this.soTimeout = soTimeout;
this.password = password;
this.database = database;
this.clientName = clientName;
this.ssl = ssl;
this.sslSocketFactory = sslSocketFactory;
this.sslParameters = sslParameters;
this.hostnameVerifier = hostnameVerifier;
}
//connectionTimeout用的地方PooledObject类
final Jedis jedis = new Jedis(hostAndPort.getHost(), hostAndPort.getPort(), connectionTimeout,
        soTimeout, ssl, sslSocketFactory, sslParameters, hostnameVerifier);
//Jedis.java
public Jedis(final String host, final int port, final int connectionTimeout, final int soTimeout,
  final boolean ssl, final SSLSocketFactory sslSocketFactory, final SSLParameters sslParameters,
  final HostnameVerifier hostnameVerifier) {
super(host, port, connectionTimeout, soTimeout, ssl, sslSocketFactory, sslParameters,
    hostnameVerifier);
}
//super BinaryJedis.java
public BinaryJedis(final String host, final int port, final int connectionTimeout,
  final int soTimeout, final boolean ssl, final SSLSocketFactory sslSocketFactory,
  final SSLParameters sslParameters, final HostnameVerifier hostnameVerifier) {
client = new Client(host, port, ssl, sslSocketFactory, sslParameters, hostnameVerifier);
//timeout的地方是Client
client.setConnectionTimeout(connectionTimeout);
client.setSoTimeout(soTimeout);
}
//Connection.java
socket.connect(new InetSocketAddress(host, port), connectionTimeout);
socket.setSoTimeout(soTimeout);
//Socket.java
//!!!毫秒
@param timeout the specified timeout, in milliseconds.
public synchronized void setSoTimeout(int timeout) throws SocketException {
    if (isClosed())
        throw new SocketException("Socket is closed");
    if (timeout < 0)
      throw new IllegalArgumentException("timeout can't be negative");

    getImpl().setOption(SocketOptions.SO_TIMEOUT, new Integer(timeout));
}
```
所以回到最开始`redis.timeout=3`是秒
```java
JedisPool jp = new JedisPool(poolConfig, redisConfig.getHost(), redisConfig.getPort(),redisConfig.getTimeout()*1000, redisConfig.getPassword(), 0);
```
//Client.java 
{% fold %}
```java
//Client.java
public Client(final String host, final int port, final boolean ssl,
  final SSLSocketFactory sslSocketFactory, final SSLParameters sslParameters,
  final HostnameVerifier hostnameVerifier) {
super(host, port, ssl, sslSocketFactory, sslParameters, hostnameVerifier);
}
//super->BinaryClient.java
public BinaryClient(final String host, final int port, final boolean ssl,
  final SSLSocketFactory sslSocketFactory, final SSLParameters sslParameters,
  final HostnameVerifier hostnameVerifier) {
super(host, port, ssl, sslSocketFactory, sslParameters, hostnameVerifier);
}
//super->Connection.java
public Connection(final String host, final int port, final boolean ssl,
  SSLSocketFactory sslSocketFactory, SSLParameters sslParameters,
  HostnameVerifier hostnameVerifier) {
this.host = host;
this.port = port;
this.ssl = ssl;
this.sslSocketFactory = sslSocketFactory;
this.sslParameters = sslParameters;
this.hostnameVerifier = hostnameVerifier;
}
```
{% endfold %}

修改上面Service 加上释放连接池的代码
查看Jedis的close方法源码
```java
public void close() {
if (dataSource != null) {
  if (client.isBroken()) {
    //不关掉 返回到连接池
    this.dataSource.returnBrokenResource(this);
  } else {
    this.dataSource.returnResource(this);
  }
} else {
  client.close();
}
}
```
##### set方法BeanToStrnig
用fastjson将bean对象变成string
```java
public <T> boolean set(String key,T value){
    Jedis jedis = null;
    try{
        jedis = jedisPool.getResource();
        String str = beanToString(value);
        if(str == null||str.length()<=0)return false;
        jedis.set(key,str);
        return true;
        }finally{
            returnToPool(jedis);
        }
}
```
```java
//任意类型转化成字符串
import com.alibaba.fastjson.JSON;
private <T> String beanToString(T value){
    //2. 添加空判断
    if(value == null)return null;
    //3. 如果是数字，字符串，Long
    Class<?> clazz = value.getClass();
    if(clazz == int.class || clazz == Integer.class) {
         return ""+value;
    }else if(clazz == String.class) {
         return (String)value;
    }else if(clazz == long.class || clazz == Long.class) {
        return ""+value;
    }else {
        return JSON.toJSONString(value);
    }
}
```

#### get方法 StringToBean
```java
@Service
public class RedisService{
    @Autowired
    JedisPool jedisPool;
    @SuppressWarnings("unchecked")//屏蔽警告
    private <T> T stringToBean(String str,Class<T> clazz){
        //1. 参数校验
        if(str == null || str.length() <= 0 || clazz == null) {
             return null;
        }
        //2 如果是int，string，Long
        if(clazz == int.class || clazz == Integer.class) {
             return (T)Integer.valueOf(str);
        }else if(clazz == String.class) {
             return (T)str;
        }else if(clazz == long.class || clazz == Long.class) {
            return  (T)Long.valueOf(str);
        }else {
            //fastJson 只支持了bean类型 其他List类型要再写
            return JSON.toJavaObject(JSON.parseObject(str), clazz);
        }

    }
    public<T> T get(String key,Class<T> clazz){
        Jedis jedis = null;
        try{
        jdeis = jedisPool.getResource();
        //2.get的逻辑：get是String类型，需要的是T类型
        String value =  jedis.get(key);
        T t = stringToBean(value,clazz);
        return t;
        //1. 添加关闭代码
        }finally{
            returnToPool(jedis);
        }
    }
    private void returnToPool(Jedis jedis){
        if(jedis != null) {
             jedis.close();
         }
    }
    @Autowired
    RedisConfig redisConfig;
    @Bean
    public JedisPool JedisFactory(){
        JedisPoolConfig poolConfig = new JedisPoolConfig();
        poolConfig.setMaxIdle(redisConfig.getPoolMaxIdle());
        poolConfig.setMaxTotal(redisConfig.getPoolMaxTotal());
        poolConfig.setMaxWaitMillis(redisConfig.getPoolMaxWait() * 1000);
        //redis默认16个库，从0库开始
        JedisPool jp = new JedisPool(poolConfig, redisConfig.getHost(), redisConfig.getPort(),redisConfig.getTimeout()*1000, redisConfig.getPassword(), 0);
        return jp;
    }
}
```
#### controller get测试:
127.0.0.1:6379> auth 123456
OK
127.0.0.1:6379> set key1 1
OK
```java
@Autowired
RedisService redisService;
@RequestMapping("/redis/get")
@ResponseBody
public Result<String> redisGet() {

    String  name  = redisService.get("key1", String.class);
    return Result.success(name);
}
```
报错：jedispoll循环引用 空指针
> [redis.clients.jedis.JedisPool]: Circular reference involving containing bean 'redisService' - consider declaring the factory method as static for independence from its containing instance. Factory method 'JedisFactory' threw exception; nested exception is java.lang.NullPointerException

因为Service里注入了pool
```java
@Autowired
JedisPool jedisPool;
```
但是 JedisPool是实例方法 创建这个Bean需要RedisSevice
```java
@Bean
public JedisPool JedisFactory()
```

所以独立出`JedisPool`
```java
@Service
public class RedisPoolFactory {
    @Autowired
    RedisConfig redisConfig;
    @Bean
    public JedisPool JedisFactory(){
    JedisPoolConfig poolConfig = new JedisPoolConfig();
    poolConfig.setMaxIdle(redisConfig.getPoolMaxIdle());
    poolConfig.setMaxTotal(redisConfig.getPoolMaxTotal());
    poolConfig.setMaxWaitMillis(redisConfig.getPoolMaxWait() * 1000);
    //redis默认16个库，从0库开始
    JedisPool jp = new JedisPool(poolConfig, redisConfig.getHost(), redisConfig.getPort(),redisConfig.getTimeout()*1000, redisConfig.getPassword(), 0);
    return jp;
}
```
#### controller set测试:
```java
@RequestMapping("/redis/set")
@ResponseBody
public Result<Boolean> redisSet() {
    User user  = new User();
    user.setId(1);
    user.setName("1111");
    redisService.set("key3",user);//UserKey:id1
    return Result.success(true);
}
```
127.0.0.1:6379> get key3
"{\"id\":1,\"name\":\"1111\"}"

#### 模板模式`[接口<-抽象类<-实现类]`：封装缓存key，加上前缀 
优化：将key加上Prefix，按业务模块区分缓存的key
`KeyPrefix` 接口 `BasePrefix` 抽象类 `UserKey` `OrderKey`等模块实现类
效果：在不同的controllor模块调用service时传入模块ID
controller使用:classname+prefix+key
redis效果：`7) "UserKey:id1"`
`UserKey.getById`
```java
 @RequestMapping("/redis/get")
    @ResponseBody
    public Result<User> redisGet() {
        User  user  = redisService.get(UserKey.getById, "1", User.class);
        return Result.success(user);
    }
    
    @RequestMapping("/redis/set")
    @ResponseBody
    public Result<Boolean> redisSet() {
        User user  = new User();
        user.setId(1);
        user.setName("1111");
        //UserKey:id1
        redisService.set(UserKey.getById,"1",user);
        return Result.success(true);
    }
```
接口：
```java
public interface KeyPrefix(){
    //有效期
    public int expireSeconds();
    //前缀
    public String getPrefix(); 
}
```
实现的`抽象类` 防止被创建
```java
public abstract class BasePrefix implements KeyPrefix{
    private int expireSeconds;
    private String prefix;
    //0表示永不过期
    public BasePrefix(String prefix) {//0代表永不过期
        this(0, prefix);
    }
    public int expireSeconds(){
        return expireSeconds;
    }
    //用类名当前缀
    public String getPrefix(){
        String className = getClass().getSimpleName();
        return className+":"+perfix;
    }
}
```

实现类：用户key
```java
public class UserKey extends BasePrefix{
    //私有 防实例化
    private UserKey(String prefix){super(prefix);}
    public static UserKey getById = new UserKey("id");
    public static UserKey getByName = new UserKey("name");
}
```
实现类：订单key
```java
public class OrderKey extends BasePrefix
```

修改Service中的get和set

```java
/**
 * 获取单个对象
 */
public<T> T get(Prefix prefix,String key,Class<T> clazz){
    Jedis jedis = null;
    try{
        jedis = jedisPool.getResource();
        //真正写到数据库的key
        String prefixKey = prefix.getPrefix()+key;
        String value =  jedis.get(prefixKey);
        T t = stringToBean(value,clazz);
        return t;
    }finally{
        returnToPool(jedis);
    }
}
```
添加失效时间
127.0.0.1:6379> expire key1 3
(integer) 1
```java
public <T> boolean set(KeyPrefix prefix,String key,T value){
    Jedis jedis = null;
    try{
        jedis = jedisPool.getResource();
        String str = beanToString(value);
        if(str == null||str.length()<=0)return false;
        String prefixKey = prefix.getPrefix()+key;
        int expire = prefix.expireSeconds();
        //永不过期
        if(expire<=0){
            jedis.set(prefixKey,str);

        }else{
            jedis.setex(prefixKey,expire,str);
        }
        return true;
    }finally{
        returnToPool(jedis);
    }
}
```
setex:
等于set+expire命令
```java
public String setex(final String key, final int seconds, final String value) {
    checkIsInMultiOrPipeline();
    client.setex(key, seconds, value);
    return client.getStatusCodeReply();
  }
```

#### 添加其他API:
127.0.0.1:6379> exists key1
(integer) 1
```java
public <T> boolean exists(KeyPrefix prefix, String key) {
 Jedis jedis = null;
 try {
     jedis =  jedisPool.getResource();
     String prefixKey = prefix.getPrefix()+key;
    return  jedis.exists(prefixKey);
 }finally {
      returnToPool(jedis);
 }
```
127.0.0.1:6379> incr key1
(integer) 2
127.0.0.1:6379> incr key1
(integer) 3
127.0.0.1:6379> set key222 fdafda
OK
127.0.0.1:6379> incr key222
(error) ERR value is not an integer or out of range

incr
```java
public <T> Long incr(KeyPrefix prefix, String key) {
     Jedis jedis = null;
     try {
         jedis =  jedisPool.getResource();
        //生成真正的key
         String realKey  = prefix.getPrefix() + key;
        return  jedis.incr(realKey);
     }finally {
          returnToPool(jedis);
     }
}
```
127.0.0.1:6379> incr key1
(integer) 5
127.0.0.1:6379> decr key1
(integer) 4

decr
```java
public <T> Long decr(KeyPrefix prefix, String key) {
     Jedis jedis = null;
     try {
         jedis =  jedisPool.getResource();
        //生成真正的key
         String realKey  = prefix.getPrefix() + key;
        return  jedis.decr(realKey);
     }finally {
          returnToPool(jedis);
     }
}
```

### 6.实现登陆 数据库设计 2次MD5 JSR303参数校验 全局异常 分布式session
数据库设计
```sql
create table `miaosha_user`(
  `id` bigint(20) not null comment '用户ID，手机号',
  `nickname` varchar(256) not null,
  `password` varchar(32) default null comment 'MD5(md5+salt)+salt',
  `salt` varchar(10) default null,
  `head` varchar(128) default null comment '头像',
  `register_date` datetime default null comment '注册时间',
  `last_login_date` datetime default null comment '上次登录时间',
  `login_cnt` int(11) default '0' comment '登陆次数',
  primary key (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

用户端先MD5(明文+固定salt)
服务端存再一次md5(明文+随机salt)
```xml
<dependency>
    <groupId>commons-codec</groupId>
    <artifactId>commons-codec</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.6</version>
</dependency>
```
新建util包使用apacheMD5加密
前端第一次salt是可以看到的 隐藏只能activeX控件之类的
```java
import org.apache.commons.codec.digest.DigestUtils;
public static String md5(String src){
    return DigestUtils.md5Hex(src);
}
//添加一个salt
//前端form表单提交上来的密码
//一次加密"123456"-> 26718c17fe0b7862a27dd7dc1b532f29
public static String inputPassFormPass(String inputPass){
    String passsalt = salt.charAt(0)+salt.charAt(2)+inputPass+salt.charAt(5);
    return md5(passsalt);
}
//第二次加密，放入数据库
public static String formPassToDBPass(String formPass, String salt) {
    String toDB = ""+salt.charAt(0)+salt.charAt(2) + formPass +salt.charAt(5) + salt.charAt(4);
    return md5(toDB);
}
//两次合并成1次
public static String inputPassToDbPass(String inputPass, String saltDB) {
    String formPass = inputPassToFormPass(inputPass);
    String dbPass = formPassToDBPass(formPass, saltDB);
    return dbPass;
}
public static void main(String[] args) {
    //c996054adec06904c675b89aa68de2ec
    System.out.println(inputPassToFormPass("123456"));
    //bef054e9b1abb70963943f32b41a3f6d
    System.out.println(formPassToDBPass(inputPassToFormPass("123456"), "secondsalt"));
```

在controller添加path
```java
@Controller
@RequestMapping("/login")
public class LoginController {

    private static Logger log = LoggerFactory.getLogger(LoginController.class);
@RequestMapping("/login")
    public String toLogin() {
        return "login";
    }
}
```

##### 登陆页面 用bootstrap的css，jq的表单验证，layer的弹窗，md5加密

登陆html页面引入：
```html
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>登录</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!-- jquery -->
    <script type="text/javascript" th:src="@{/js/jquery.min.js}"></script>
    <!-- bootstrap -->
    <link rel="stylesheet" type="text/css" th:href="@{/bootstrap/css/bootstrap.min.css}" />
    <script type="text/javascript" th:src="@{/bootstrap/js/bootstrap.min.js}"></script>
    <!-- jquery-validator -->
    <script type="text/javascript" th:src="@{/jquery-validation/jquery.validate.min.js}"></script>
    <script type="text/javascript" th:src="@{/jquery-validation/localization/messages_zh.min.js}"></script>
    <!-- layer -->
    <script type="text/javascript" th:src="@{/layer/layer.js}"></script>
    <!-- md5.js -->
    <script type="text/javascript" th:src="@{/js/md5.min.js}"></script>
    <!-- common.js -->
    <script type="text/javascript" th:src="@{/js/common.js}"></script>
</head>
```
bootstrap+jquery验证:
{% fold %}
```html
<!-- 50%宽度 居中 margin: 0 auto -->
<form name="loginForm" id="loginForm" method="post"  style="width:50%; margin:0 auto">
    <h2 style="text-align:center; margin-bottom: 20px">用户登录</h2> 
    <div class="form-group">
        <div class="row">
            <label class="form-label col-md-4">请输入手机号码</label>
            <div class="col-md-5">
                <input id="mobile" name = "mobile" class="form-control" type="text" placeholder="手机号码" required="true"  minlength="11" maxlength="11" />
            </div>
            <div class="col-md-1">
            </div>
        </div>
    </div>
    
    <div class="form-group">
            <div class="row">
                <label class="form-label col-md-4">请输入密码</label>
                <div class="col-md-5">
                    <input id="password" name="password" class="form-control" type="password"  placeholder="密码" required="true" minlength="6" maxlength="16" />
                </div>
            </div>
    </div>
    
    <div class="row">
                <div class="col-md-5">
                    <button class="btn btn-primary btn-block" type="reset" onclick="reset()">重置</button>
                </div>
                <div class="col-md-5">
                    <button class="btn btn-primary btn-block" type="submit" onclick="login()">登录</button>
                </div>
     </div>
</form>
```
{% endfold %}
jquery validate:
http://www.runoob.com/jquery/jquery-plugin-validate.html
```js
function login(){
    // 在键盘按下并释放及提交后验证提交表单
    $("#loginForm").validate({
        submitHandler:function(form){
            //如果成功 异步提交表单
            doLogin()
        }
    })
```
使用ajax异步提交
```js
function doLogin(){
    //每次提交loading框
    g_showLoading()
    //md5加密密码 与后台规则一样
    var inputpwd = $("#password").val()
    var str = salt.charAt(0)+salt.charAt(2)+inputpwd+salt.charAt(5)
    //123456->c996054adec06904c675b89aa68de2ec
    var password = md5(str)

    $.ajax({
        url:"/login/do_login",
        type:"POST",
        data:{
            mobile:$("#mobile").val(),
            password:password
        },
        success:function(data){
            //无论成功失败都关闭框
            layer.closeAll();
            console.log("login")
            console.log(password)
 /* {code: 0, msg: null, data: "登录成功"} */
            if(data.code==0){
                layer.msg("成功")
                console.log(data)
            }else{
                console.log("打印后端返回的错误信息")
                layer.msg(data.msg);
            }
        },
        error:function(){
            layer.closeAll()
        }
    })
}
```
layer.js弹窗
http://layer.layui.com/
common.js
```js
function g_showLoading(){
    var idx = layer.msg('处理中...', {icon: 16,shade: [0.5, '#f5f5f5'],scrollbar: false,offset: '0px', time:100000}) ;  
    return idx;
}
```
在js中设置salt
```js
var g_passsword_salt="abcd1234"
```

#### 参数校验
在controller 验证手机号之后
再调用Service 用手机号查询dao数据库里面的密码，与前端传的密码做比较。
页面参数用vo封装。

后台添加vo接收前端数据的类：
```java
public class LoginVo {
    private String mobile;
    private String password;
}
```
添加controller：
添加errormessage
CodeMsg.java
```java
//登录模块 5002XX
public static CodeMsg SESSION_ERROR = new CodeMsg(500210,"Session不存在或者已经失效");
public static CodeMsg PASSWORD_ERROR = new CodeMsg(500211,"登陆密码不能为空");
public static CodeMsg MOBILE_EMPTY = new CodeMsg(500212,"手机号不能为空");
public static CodeMsg SESSION_ERROR = new CodeMsg(500210,"Session不存在或者已经失效");
public static CodeMsg PASSWORD_EMPTY = new CodeMsg(500211,"登陆密码不能为空");
public static CodeMsg MOBILE_EMPTY = new CodeMsg(500212,"手机号不能为空");
public static CodeMsg MOBILE_ERROR = new CodeMsg(500213,"手机号格式错误");
public static CodeMsg MOBILE_NOT_EXIST = new CodeMsg(500214,"手机号不存在");
public static CodeMsg PASSWORD_ERROR = new CodeMsg(500215,"密码错误");
```


```java
//添加log 可以查看前端传过来的form数据是什么
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
private static Logger log = LoggerFactory.getLogger(LoginController.class);
@RequestMapping("/do_login")
@ResponseBody
public Result<Boolean> doLogin(LoginVo loginVo) {
    log.info(loginVo.toString());
        //参数校验
    String password = loginVo.getPassword();
    String mobile = loginVo.getMobile();
    if(StringUtils.isEmpty(mobile)){
        return Result.error(CodeMsg.MOBILE_EMPTY);
    }
    if(StringUtils.isEmpty(password)){
        return Result.error(CodeMsg.PASSWORD_EMPTY);
    }
    if(!ValidatorUtil.isMobile(mobile))
        return Result.error(CodeMsg.MOBILE_ERROR);
    }
```
正则手机号
手机号验证类ValidatorUtil.java
```java
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang3.StringUtils;
public class ValidatorUtil {
    private static final Pattern mobile_pattern = Pattern.compile("^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$");
    public static boolean isMobile(String str){
        if(StringUtils.isEmpty(str)){
            return false;
        }
        Matcher m = mobile_pattern.matcher(str);
        return m.matches();
    }
    public static void main(String[] args) {
        //true
            System.out.println(isMobile("18912341234"));
        //false
            System.out.println(isMobile("12345678900"));
    }
}
```
新建与数据库关联的domain对象
```java
public class MiaoshaUser {
    //bigint
    private Long id;
    private String nickname;
    private String password;
    private String salt;
    private String head;
    private Date registerDate;
    private Date lastLoginDate;
    private Integer loginCount;
}
```
新建dao,通过id找用户
```java
@Mapper
public interface MiaoshaUserDao{
    @Select（"select * from miaosha user where id = #{id}")
    public MiaoshaUser getById(@Param("id") long id);
    @Insert("insert into user(id, name)values(#{id}, #{name})")
    public int insert(User user);

}
```

service获取用户及登陆:
```java
@Service
public class MiaoshaUserService{
    @Autowired
    MiaoshaUserDao miaoshaUserDao;
    public MiaoshaUser getById(long id) {
        return miaoshaUserDao.getById(id);
    }
    public CodeMsg login(LoginVo loginVo){
        if(loginVo == null) {
            throw CodeMsg.SERVER_ERROR;
        }
        String mobile = loginVo.getMobile();
        String formPass = loginVo.getPassword();
        //数据库查询手机号
        MiaoshaUser user = getById(Long.parseLong(mobile));
        if(user == null) {
            //用户/手机号不存在
            throw new CodeMsg.MOBILE_NOT_EXIST;
        }
        //数据库中的密码,salt
        String dbPass = user.getPassword();
        String saltDB = user.getSalt();
        //用前端密码+数据库salt是否等于数据库密码
        String gassDBpass = MD5Util.formPassToDBPass(formPass, saltDB);
        if(!calcPass.equals(dbPass)) {
            throw CodeMsg.PASSWORD_ERROR;
        }
        return CodeMsg.SUCCESS;
    }
}
```
在controller中注入
```java
@Autowired
MiaoshaUserService userService;

@RequestMapping("/do_login")
@ResponseBody
public Result<String> doLogin(LoginVo loginVo) {
    //..参数校验
    //登录
    CodeMsg code = userService.login(loginVo);
    if(code.getCode()==0)return Result.success("登录成功");
    else return Result.error(code);
```

### 7.JSR303参数校验+全局异常
不是每个controller的方法里都要写参数校验，而是把参数校验放到vo类上，在controller只要打注解

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

在controller要校验的实体前打`@Valid`
```java
public Result<String> doLogin(@Valid  LoginVo loginVo)
```
在实体类加注解
```java
public class LoginVo {
@NotNull
@Length(min=32)
private String password;
```

#### 自定义注解
对手机号添加自定义验证注解
新建`validator`包,新建`IsMobile.java`
参考`java.validation.constrains`里的`NotNull`,
必须的，添加
来自`Constraint.java`的注释：
```java
Each constraint annotation must host the following attributes:
    String message() default [...]; which should default to an error message key made of the fully-qualified class name of the constraint followed by .message. For example "{com.acme.constraints.NotSafe.message}"
    Class<?>[] groups() default {}; for user to customize the targeted groups
    Class<? extends Payload>[] payload() default {}; for extensibility purposes
```

```java
@Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER })
@Retention(RUNTIME)
@Documented
// 注解实现类
@Constraint(validatedBy = {IsMobileValidator.class})
public @interface IsMobile{
    //不能为空
    boolean required() default true;
    //默认信息
    String message() default "手机号码格式错误";

    Class<?>[] groups() default { };

    Class<? extends Payload>[] payload() default { };
}
```

#### 注解实现类
新建类`IsMobileValidator`并在`@interface`里添加`@Constraint(validatedBy = {IsMobileValidator.class})`

```java
public @interface Constraint {
    Class<? extends ConstraintValidator<?, ?>>[] validatedBy();
}
```

创建类<注解,检测的类型>，用上之前创建的ValidatorUtil
```java
public class MobileValidator implements ConstraintValidator<IsMobile,String> {
    //成员变量，接收注解定义
    private boolean required = false;
    @Override
    public void initialize(IsMobile constraintAnnotation) {
        //初始化方法里可以获取注解对象
    required = constraintAnnotation.required();
    }
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if(required){
            //初始化获取注解 传的值 如果是必须的，判断是否合法
            return ValidatorUtil.isMobile(value);
        }else//如果不是必须的
            if(StringUtils.isEmpty(value)){
            return true;

        }else{
            return ValidatorUtil.isMobile(value);
            }
    }
}
```
在LoginVo上加上
```java
@NotNull
@Mobile(required = true,message = "手机号错")
private String mobile;
```
返回controller的doLogin可以删掉之前的非空检验参数校验
```java
@RequestMapping("/do_login")
@ResponseBody
public Result<String> doLogin(@Valid  LoginVo loginVo) {
    log.info(loginVo.toString());
    // 登录
    CodeMsg code = userService.login(loginVo);
    // 如果有异常会给异常controller处理
    return Result.success("登录成功");
}
```
可以得到完整错误信息 绑定异常
![error](/images/errormsg.jpg)


#### 异常处理
错误处理新建exception包
添加`@ControllerAdvice` 和controller是一样的 
```java
@ControllerAdvice
@ResponseBody
public class BindExceptionHandler {
    // 拦截所有异常
    @ExceptionHandler(Exception.class)
    public Result<String> bindexp(HttpServletRequest request,Exception e){
        // 刚刚手机号错报的绑定异常
        if(e instanceof BindException){
            BindException ex = (BindException) e;
            List<ObjectError> errors = ex.getAllErrors();
            ObjectError objectError = errors.get(0);
            String defaultMessage = objectError.getDefaultMessage();
            return Result.error(CodeMsg.BIND_ERROR.fillArgs(defaultMessage));

        }else{
            //通用异常
            return Result.error(CodeMsg.SERVER_ERROR);
        }
    }
}
```

#### 定义传参的错误信息
可传递参数的错误信息，原来定义的枚举类不能new 所以不用枚举了
`CodeMsg.BIND_ERROR.fillArgs(msg)`
```java
public class  CodeMsg {
    private  int code;
    private  String msg;
    private CodeMsg( int code,String msg ) {
        this.code = code;
        this.msg = msg;
    }
    //通用的错误码
    public static CodeMsg SUCCESS = new CodeMsg(0, "success");
    public static CodeMsg SERVER_ERROR = new CodeMsg(500100, "服务端异常");
    // 绑定异常
    public static CodeMsg BIND_ERROR = new CodeMsg(500101, "参数校验异常：%s");
    //登录模块 5002XX
    public static CodeMsg SESSION_ERROR = new CodeMsg(500210, "Session不存在或者已经失效");
    public static CodeMsg PASSWORD_EMPTY = new CodeMsg(500211, "登录密码不能为空");
    public static CodeMsg MOBILE_EMPTY = new CodeMsg(500212, "手机号不能为空");
    public static CodeMsg MOBILE_ERROR = new CodeMsg(500213, "手机号格式错误");
    public static CodeMsg MOBILE_NOT_EXIST = new CodeMsg(500214, "手机号不存在");
    public static CodeMsg PASSWORD_ERROR = new CodeMsg(500215, "密码错误");
    //参数校验异常：%s
    public CodeMsg fillArgs(Object... args) {
        int code = this.code;
        // this 关键
        String message = String.format(this.msg,args);
        return new CodeMsg(code,message);
    }
}
```
测试：200返回`{"code":500101,"msg":"参数校验异常：手机号错","data":null}`

##### 定义系统全局异常
业务模块`MiaoshaUserService`中的`public CodeMsg login(LoginVo loginVo)`方法，不应该返回CodeMsg，应该定义系统全局异常(业务异常)
```java
public class GlobalException extends RuntimeException{

    private static final long serialVersionUID = 1L;
    
    private CodeMsg cm;
    
    public GlobalException(CodeMsg cm) {
        super(cm.toString());
        this.cm = cm;
    }//get
}
```
`MiaoshaUserService.java`
修改业务代码直接抛异常而不是返回CodeMsg
```java
// 返回业务含义的 登陆 true false
public boolean login(LoginVo loginVo){
    if(loginVo == null){
        throw new GlobalException( CodeMsg.SERVER_ERROR);
    }
    String mobile = loginVo.getMobile();
    String formPass = loginVo.getPassword();
    MiaoshaUser user = getById(Long.parseLong(mobile));
    if(user == null) {
        //用户/手机号不存在
        throw new GlobalException( CodeMsg.MOBILE_NOT_EXIST);
    }
    //数据库中的密码,salt
    String dbPass = user.getPassword();
    String saltDB = user.getSalt();
//      用前端密码+数据库salt是否等于数据库密码
    String calcPass = MD5Util.formPassToDBPass(formPass, saltDB);
    log.info(calcPass);
    log.info(dbPass);
    if(!calcPass.equals(dbPass)) {
        throw new GlobalException( CodeMsg.PASSWORD_ERROR);
    }
    return true;
}
```
添加全局异常处理,注意合并成一个异常处理，不要覆盖
// todo 应该先小异常还是先大异常
```java
@ControllerAdvice
@ResponseBody
public class GlobalExceptionHandler {
    @ExceptionHandler(value=Exception.class)
    public Result<String> exceptionHandler(HttpServletRequest request, Exception e){
        e.printStackTrace();
        if(e instanceof GlobalException) {
            GlobalException ex = (GlobalException)e;
            return Result.error(ex.getCm());
        }else if(e instanceof BindException) {
            BindException ex = (BindException)e;
            List<ObjectError> errors = ex.getAllErrors();
            ObjectError error = errors.get(0);
            String msg = error.getDefaultMessage();
            return Result.error(CodeMsg.BIND_ERROR.fillArgs(msg));
        }else {
            return Result.error(CodeMsg.SERVER_ERROR);
        }
    }
}
```
修改controllor中service的返回值，异常已经处理了，不用返回值
```java
userService.login(loginVo);
return Result.success("登录成功");
```

### 8.分布式Session
1.容器session同步 比较复杂
2.登陆成功后生成token(sessionID)写到cookie传递给客户端，客户端每次访问上传cookie

新建生成ID的类
用uuid，原生UUID带‘-’，去掉
```java
public class UUIDUtil {
    public static String uuid() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
```
service中login比对密码正确后，生成token，并写到`redis`中

在service中引入`redisService`，设置cookie中的token name
```java
// cookie key
public static final String COOKI_NAME_TOKEN = "token";
@Autowired
RedisService redisService;
public boolean login( HttpServletResponse response,@Valid LoginVo loginVo) {
    if(loginVo == null) {
        System.out.println("loginvonull");
        throw new GlobalException(CodeMsg.SERVER_ERROR);
    }
    String mobile = loginVo.getMobile();
    String formPass = loginVo.getPassword();
    //判断手机号是否存在

    MiaoshaUser user = getById(Long.parseLong(mobile));
    if(user == null) {
        throw new GlobalException(CodeMsg.MOBILE_NOT_EXIST);
    }
    //验证密码
    String dbPass = user.getPassword();
    String saltDB = user.getSalt();
    String calcPass = MD5Util.formPassToDBPass(formPass, saltDB);
    if(!calcPass.equals(dbPass)) {
        throw new GlobalException(CodeMsg.PASSWORD_ERROR);
    }
    //生成cookie
    String token = UUIDUtil.uuid();
    redisService.set(MiaoshaUserKey.token, token, user);
    Cookie cookie = new Cookie(COOKI_NAME_TOKEN,token);
    // 有效期 与redis中session有效期保持一致
    cookie.setMaxAge(MiaoshaUserKey.token.expireSeconds());
    // 网站根目录
    cookie.setPath("./");
     //写到response要HttpResponse
    response.addCookie(cookie);
    return true;
}
```

在`\redis\`新建`MiaoshaUserKey`
```java
public class MiaoshaUserKey extends BasePrefix{
    public MiaoshaUserKey(String prefix) {
            super(prefix);
    }
    public static tokenKey token = new tokenKey("tk");
}
```

修改login controller 里也要添加`HttpServletResponse response`
```java
@RequestMapping("/do_login")
@ResponseBody
public Result<String> doLogin(HttpServletResponse response,@Valid  LoginVo loginVo) {
    log.info(loginVo.toString());
     userService.login(response,loginVo);
    return Result.success("登录成功");
}
```

#### 登录成功跳转页
```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>商品列表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<p th:text="'hello:'+${user.nickname}" ></p>
</body>
</html>
```
创建新的controller类
```java
@Controller
@RequestMapping("/goods")
public class GoodsController {
    @RequestMapping("/to_list")
    public String list(Model model,MiaoshaUser user) {
        return "goods_list";
    }
}
```
login.html ajax成功后跳转
```js
$.ajax({
    url: "/login/do_login",
    type: "POST",
    data:{
        mobile:$("#mobile").val(),
        password: password
    },
    success:function(data){
        layer.closeAll();
        if(data.code == 0){
            layer.msg("成功");
            window.location.href="/goods/to_list";
        }else{
            layer.msg(data.msg);
        }
    },
    error:function(){
        layer.closeAll();
    }
});
```
