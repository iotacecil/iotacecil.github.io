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



### 4.集成Redis
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

### 5.实现登陆 数据库设计 2次MD5 JSR303参数校验 全局异常 分布式session
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
  `login_count` int(11) default '0' comment '登陆次数',
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

#### 登陆页面 用bootstrap的css，jq的表单验证，layer的弹窗，md5加密

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

### 6.JSR303参数校验+全局异常
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
![errormsg.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/errormsg.jpg)


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

### 7.分布式Session
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
    // 网站根目录 注意不是 ./
    cookie.setPath("/");
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
注意语法
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

测试：登录后可以显示:hello:null
查看do_login的response
`Set-Cookie: token=1701f466f2904a568aa364d6992828eb; Max-Age=0; Expires=Thu, 01-Jan-1970 00:00:10 GMT; Path=./`

因为`Max-Age=0`所以to_list没有上传cookie
给cookie设置默认有效期
`MiaoshaUserKey.java`

```java
public class MiaoshaUserKey extends BasePrefix{

    public static final int TOKEN_EXPIRE = 3600*24 * 2;

    // 构造函数里加上过期时间
    public MiaoshaUserKey(int expireSeconds,String prefix) {
        super(expireSeconds,prefix);
    }
    // 调用构造函数
    public static MiaoshaUserKey token = new MiaoshaUserKey(TOKEN_EXPIRE,"tk");

```

测试：do login的response
`Set-Cookie: token=38407e1482e246519727d0041bbd781c; Max-Age=172800; Expires=Tue, 23-Oct-2018 11:07:50 GMT; Path=/`
tolist 里会带着
`Cookie: token=38407e1482e246519727d0041bbd781c`


public方法一定要做参数校验

实现用token从redis中得到MiaoshaUser
```java
public MiaoshaUser getByToken( String token) {
    if(StringUtils.isEmpty(token)) {
        return null;
    }
    return redisService.get(MiaoshaUserKey.token, token, MiaoshaUser.class);
    }
```

controller：
有的手机端会放到参数里传不在cookie里。设置优先级
```java
@RequestMapping("/to_list")
public String toLogin(Model model,
                      @CookieValue(value = MiaoshaUserService.COOKI_NAME_TOKEN,required = false)String cookieToken,
                      @RequestParam(value = MiaoshaUserService.COOKI_NAME_TOKEN,required = false)String paramToken) {
    if(StringUtils.isEmpty(cookieToken)&& StringUtils.isEmpty(paramToken)){
        System.out.println("没获取到");
        return "login";
    }

    String token = StringUtils.isEmpty(paramToken)?cookieToken:paramToken;
    System.out.println("获取到了token");
    MiaoshaUser user = userService.getByToken(token);
    System.out.println("获取到了用户");
    System.out.println(user);
    model.addAttribute("user",user);
    return "goods_list";
}
```

#### session内登陆时延长有效期
每次response里都有set-cookie

把生成cookie的代码独立成一个方法：
```java
private void addCookie(HttpServletResponse response, String token,MiaoshaUser user) {
    redisService.set(MiaoshaUserKey.token, token, user);
    Cookie cookie = new Cookie(COOKI_NAME_TOKEN, token);
    cookie.setMaxAge(MiaoshaUserKey.token.expireSeconds());
    cookie.setPath("/");
    response.addCookie(cookie);
}
```

每次token->User的时候重新对response更新cookie 

```java
public MiaoshaUser getByToken(HttpServletResponse response, String token) {
    if(StringUtils.isEmpty(token)) {
        return null;
    }
    MiaoshaUser user = redisService.get(MiaoshaUserKey.token, token, MiaoshaUser.class);
//      延长有效期
    if(user != null) {
        addCookie(response,token,user);
    }
    return user;
}
```

在controller加response

#### 判断登陆session的代码独立出来，Controller只传入一个User
新建包config 
`WebConfig.java`
controller中的参数通过框架回调`WebMvcConfigurerAdapter`的`addArgumentResolvers` 赋值
```java
@Configuration
public class WebConfig  extends WebMvcConfigurerAdapter {
    
    @Autowired
    UserArgumentResolver userArgumentResolver;
    
    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
        argumentResolvers.add(userArgumentResolver);
    }
    
}
```

实现`HandlerMethodArgumentResolver` 解析
```java
@Service
public class UserArgumentResolver implements HandlerMethodArgumentResolver {

    @Autowired
    MiaoshaUserService userService;
    
    public boolean supportsParameter(MethodParameter parameter) {
        // 获取参数类型 是User类型才会做resolveArgument
        Class<?> clazz = parameter.getParameterType();
        return clazz==MiaoshaUser.class;
    }

    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
        HttpServletResponse response = webRequest.getNativeResponse(HttpServletResponse.class);

        // 浏览器不同 token可能在cookie里也可能在参数里
        String paramToken = request.getParameter(MiaoshaUserService.COOKI_NAME_TOKEN);
        String cookieToken = getCookieValue(request, MiaoshaUserService.COOKI_NAME_TOKEN);
        if(StringUtils.isEmpty(cookieToken) && StringUtils.isEmpty(paramToken)) {
            return null;
        }
        String token = StringUtils.isEmpty(paramToken)?cookieToken:paramToken;
        return userService.getByToken(response, token);
    }

    /**
     * 遍历request里的所有cookie 找到对应那个的value
     * @param request
     * @param cookiName
     * @return
     */
    private String getCookieValue(HttpServletRequest request, String cookiName) {
        Cookie[]  cookies = request.getCookies();
        for(Cookie cookie : cookies) {
            if(cookie.getName().equals(cookiName)) {
                return cookie.getValue();
            }
        }
        return null;
    }

}
```

可以删掉controller里检测登陆的代码：
```java
@RequestMapping("/to_list")
public String toLogin(Model model,MiaoshaUser user) {
    model.addAttribute("user",user);
    return "goods_list";
}
```

完成分布式session

---

### 8.商品列表详情页 秒杀功能
秒杀商品表、秒杀订单表 要独立，因为变化大
新建数据库
```sql
create table `goods`(
  `id` bigint(20) not null AUTO_INCREMENT comment '商品ID',
  `goods_name` varchar(16) not null comment '商品名称',
  `goods_title` varchar(64) default null comment '商品标题',
  `goods_img` varchar(64) default null comment'商品图片',
  `goods_detail` longtext comment '商品详情介绍',
  `goods_price` decimal(10,2) default '0.00' comment '商品单价',
  `goods_stock` int(11) default '0' comment '商品库存，-1表示没有限制',

  primary key (`id`)
)ENGINE=InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET=utf8;

create table `miaosha_order`(
  `id` bigint(20) not null AUTO_INCREMENT ,
  `user_id` BIGINT(20) not null comment '用户ID',
  `order_id` BIGINT(20) default null comment '订单ID',
  `goods_id` BIGINT(20) default null comment'商品ID',

  primary key (`id`)
)ENGINE=InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET=utf8;


create table `miaosha_goods`(
  `id` bigint(20)  not null AUTO_INCREMENT comment '秒杀商品表',
  `goods_id` BIGINT(20) DEFAULT null comment '商品id',
  `miaosha_price` DECIMAL(10,2) default '0.00' comment '秒杀',
  `stock_count` INT(11) default null comment'库存数量',
  `start_date` DATETIME DEFAULT  NULL comment '秒杀开始时间',
  `end_date` DATETIME DEFAULT  NULL comment '秒杀结束时间',

  primary key (`id`)
)ENGINE=InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET=utf8;


create table `order_info`(
  `id` bigint(20) not null AUTO_INCREMENT ,
  `user_id` BIGINT(20) not null comment '用户ID',
  `goods_id` BIGINT(20) default null comment '商品ID',
  `delivery_addr_id` BIGINT(20) default null comment'收获地址ID',
  `goods_name` VARCHAR(16) DEFAULT  NULL comment '冗余商品名称',
  `goods_count` INT(11) DEFAULT '0' comment '商品数量',
  `goods_price` DECIMAL(10,2) DEFAULT '0.00' comment '商品单价',

  `order_channel` TINYINT(4) DEFAULT '0' comment '1pc,2android,3ios',
  `status` TINYINT(4) DEFAULT '0' comment '订单状态，0新建未支付，1已支付，3已收货，4已退款，5已完成',
  `create_date` DATETIME DEFAULT NULL comment '订单创建时间',
  `pay_date` DATETIME DEFAULT NULL comment '支付时间',

  primary key (`id`)
)ENGINE=InnoDB AUTO_INCREMENT = 12 DEFAULT CHARSET=utf8;
```

建立对应的domain对象
```java
public class Goods {
    private Long id;
    private String goodsName;
    private String goodsTitle;
    private String goodsImg;
    private String goodsDetail;
    private Double goodsPrice;
    private Integer goodsStock;
    }
public class MiaoshaGoods {
    private Long id;
    private Long gooddsId;
    private Integer stockCount;
    private Date startDate;
    private Date endDate;
}
public class OrderInfo {
    private Long id;
    private Long userId;
    private Long goodsId;
    private Long deliveryAddrId;
    private String goodsName;
    private Integer goodsCount;
    private Double goodsPrice;
    private Integer orderChannel;
    private Integer status;
    private Date createDate;
    private Date payDate;
}
public class MiaoshaOrder {
    private Long id;
    private Long userId;
    private Long orderId;
    private Long goodsId;
}
```

创建`GoodsService.java`和对应的`GoodsDao`

查找商品希望同时查找到miaosha_goods中的秒杀信息
建立vo
```java
public class GoodVo extends Goods{
    private Double miaoshaPrice;
    private Integer stockCount;
    private Date startDate;
    private Date endDate;
```
dao
```java
@Mapper
public interface GoodsDao {

    /**
     * 查找商品信息和秒杀信息(库存和秒杀时间)
     */
    @Select("select g.*,mg.miaosha_price,mg.stock_count,mg.start_date,mg.end_date  from miaosha_goods mg left join goods g on mg.goods_id = g.id")
    public List<GoodVo> listGoodsVo();
}
```
service: 显示商品列表
```java
@Service
public class GoodsService {
    @Autowired
    GoodsDao goodsDao;

    public List<GoodVo> listGoodsVo(){
        return goodsDao.listGoodsVo();
    }
}
```

controller 中添加到页面
```java
@Autowired
GoodsService goodsService;

@RequestMapping("/to_list")
public String toLogin(Model model,MiaoshaUser user) {
    model.addAttribute("user",user);

    // 秒杀商品列表
    List<GoodVo> goodVos = goodsService.listGoodsVo();
    model.addAttribute("goodsList",goodVos);

    return "goods_list";
}
```
在goods_list.html 添加遍历 在static下放img/iphoneX.png 数据库img存img/iphoneX.png
```html
<div class="panel panel-default">
    <div class="panel-heading">秒杀商品列表</div>
    <table class="table" id="goodslist">
        <tr><td>商品名称</td><td>商品图片</td><td>商品原价</td><td>秒杀价</td><td>库存数量</td><td>详情</td></tr>
        <tr  th:each="goods,goodsStat : ${goodsList}">
            <td th:text="${goods.goodsName}"></td>
            <td ><img th:src="@{${goods.goodsImg}}" width="100" height="100" /></td>
            <td th:text="${goods.goodsPrice}"></td>
            <td th:text="${goods.miaoshaPrice}"></td>
            <td th:text="${goods.stockCount}"></td>
            <td><a th:href="'/goods/to_detail/'+${goods.id}">详情</a></td>
        </tr>
    </table>
</div>
```

测试：http://localhost:8080/goods/to_list 可以看到表格


#### 商品详情页 倒计时
为了防止数据库中id连号被遍历，一般使用`snowflake`算法

html里`/goods/to_detail/'+${goods.id}`

根据商品ID查询单个goodVO信息 并显示当前时间和秒杀时间的倒计时
controller:
```java
@RequestMapping("/to_detail/{goodsId}")
public String detail(Model model,MiaoshaUser user,
                     @PathVariable("goodsId")long goodsId) {
    model.addAttribute("user", user);

    GoodVo goods = goodsService.getGoodsVoByGoodsId(goodsId);
    model.addAttribute("goods", goods);

    long startAt = goods.getStartDate().getTime();
    long endAt = goods.getEndDate().getTime();
    long now = System.currentTimeMillis();
    // 0：没开始 2：结束 1：进行中
    int miaoshaStatus = 0;
    // 倒计时
    int remainSeconds = 0;
    if(now < startAt ) {//秒杀还没开始，倒计时
        miaoshaStatus = 0;
        remainSeconds = (int)((startAt - now )/1000);
    }else  if(now > endAt){//秒杀已经结束
        miaoshaStatus = 2;
        remainSeconds = -1;
    }else {//秒杀进行中
        miaoshaStatus = 1;
        remainSeconds = 0;
    }
    model.addAttribute("miaoshaStatus", miaoshaStatus);
    model.addAttribute("remainSeconds", remainSeconds);
    return "goods_detail";
}
```

service 和dao 显示商品详情
```java
public GoodVo getGoodsVoByGoodsId(long goodsId) {
        return goodsDao.getGoodsVoByGoodsId(goodsId);
    }
@Select("select g.*,mg.miaosha_price,mg.stock_count,mg.start_date,mg.end_date  from miaosha_goods mg left join goods g on mg.goods_id = g.id where g.id = #{goodId}" )
GoodVo getGoodsVoByGoodsId( long goodsId);
```
商品详情html：
```html
<div class="panel panel-default">
  <div class="panel-heading">秒杀商品详情</div>
  <div class="panel-body">
    <span th:if="${user eq null}"> 您还没有登录，请登陆后再操作<br/></span>
    <span>没有收货地址的提示。。。</span>
  </div>
  <table class="table" id="goodslist">
    <tr>  
        <td>商品名称</td>  
        <td colspan="3" th:text="${goods.goodsName}"></td> 
     </tr>  
     <tr>  
        <td>商品图片</td>  
        <td colspan="3"><img th:src="@{${goods.goodsImg}}" width="200" height="200" /></td>  
     </tr>
     <tr>  
        <td>秒杀开始时间</td>  
        <td th:text="${#dates.format(goods.startDate, 'yyyy-MM-dd HH:mm:ss')}"></td>
        <td id="miaoshaTip">    
            <input type="hidden" id="remainSeconds" th:value="${remainSeconds}" />
            <span th:if="${miaoshaStatus eq 0}">秒杀倒计时：<span id="countDown" th:text="${remainSeconds}"></span>秒</span>
            <span th:if="${miaoshaStatus eq 1}">秒杀进行中</span>
            <span th:if="${miaoshaStatus eq 2}">秒杀已结束</span>
        </td>
        <td>
            <form id="miaoshaForm" method="post" action="/miaosha/do_miaosha">
                <button class="btn btn-primary btn-block" type="submit" id="buyButton">立即秒杀</button>
                <input type="hidden" name="goodsId" th:value="${goods.id}" />
            </form>
        </td>
     </tr>
     <tr>  
        <td>商品原价</td>  
        <td colspan="3" th:text="${goods.goodsPrice}"></td>  
     </tr>
      <tr>  
        <td>秒杀价</td>  
        <td colspan="3" th:text="${goods.miaoshaPrice}"></td>  
     </tr>
     <tr>  
        <td>库存数量</td>  
        <td colspan="3" th:text="${goods.stockCount}"></td>  
     </tr>
  </table>
</div>
```

倒计时：`<span id="countDown" th:text="${remainSeconds}"></span>秒</span>`
设置隐藏域保留`remainSeconds`(controller添加的) 这样`miaoshaStatus`是1或者2 js也能取到时间
```html
<input type="hidden" id="remainSeconds" th:value="${remainSeconds}" />
<span th:if="${miaoshaStatus eq 0}">秒杀倒计时：<span id="countDown" th:text="${remainSeconds}"></span>秒</span>
```

js判断remainSeconds 三种情况，设置标签颜色和倒计时
```js
$(function(){
    countDown();
});

function countDown(){
    var remainSeconds = $("#remainSeconds").val();
    var timeout;
    if(remainSeconds > 0){//秒杀还没开始，倒计时
        $("#buyButton").attr("disabled", true);
        timeout = setTimeout(function(){
            $("#countDown").text(remainSeconds - 1);
            $("#remainSeconds").val(remainSeconds - 1);
            countDown();
        },1000);
    }else if(remainSeconds == 0){//秒杀进行中
        $("#buyButton").attr("disabled", false);
        if(timeout){
            clearTimeout(timeout);
        }
        $("#miaoshaTip").html("秒杀进行中");
    }else{//秒杀已经结束
        $("#buyButton").attr("disabled", true);
        $("#miaoshaTip").html("秒杀已经结束");
    }
}
```


测试：http://localhost:8080/goods/to_detail/1

#### 秒杀功能
用表单提交 传递的参数是商品id
```html
<form id="miaoshaForm" method="post" action="/miaosha/do_miaosha">
    <button class="btn btn-primary btn-block" type="submit" id="buyButton">立即秒杀</button>
    <input type="hidden" name="goodsId" th:value="${goods.id}" />
</form>
```

添加秒杀模块的Error Message
```java
public static CodeMsg MIAO_SHA_OVER = new CodeMsg(500500, "无库存");
public static CodeMsg REPEATE_MIAOSHA = new CodeMsg(500501, "不能重复秒杀");
```
业务逻辑：
1. 判断登陆 -> 登陆页面
2. 判断商品库存 -> 秒杀失败
3. 判断用户是否已经秒杀过该商品 ->秒杀失败 //todo 如果可以买好几件？
4. 事务：减库存 下单 加入秒杀订单 -> 订单详情页
定义`OrderService` 用于查询用户订单是否已经买过这个商品

添加秒杀失败页面：
```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>秒杀失败</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
秒杀失败：<p th:text="${errmsg}"></p>
</body>
</html>
```

新建`MiaoshaController`
```java
@Controller
@RequestMapping("/miaosha")
public class MiaoshaController {

    @Autowired
    GoodsService goodsService;
    
    @Autowired
    OrderService orderService;
    
    @Autowired
    MiaoshaService miaoshaService;
    
    @RequestMapping("/do_miaosha")
    public String list(Model model, MiaoshaUser user,
                       @RequestParam("goodsId")long goodsId) {
        model.addAttribute("user", user);
        // 没登陆
        if(user == null) {
            return "login";
        }
        //判断库存
        GoodVo goods = goodsService.getGoodsVoByGoodsId(goodsId);
        int stock = goods.getStockCount();
        if(stock <= 0) {
            model.addAttribute("errmsg", CodeMsg.MIAO_SHA_OVER.getMsg());
            return "miaosha_fail";
        }
//      从用户订单查询是否已经对这个物品下过单了
        MiaoshaOrder order = orderService.getMiaoshaOrderByUserIdGoodsId(user.getId(), goodsId);
        if(order != null) {
            model.addAttribute("errmsg", CodeMsg.REPEATE_MIAOSHA.getMsg());
            return "miaosha_fail";
        }
        //1.减库存 2.下订单 3.写入秒杀订单 这三步是一个是事务
        OrderInfo orderInfo = miaoshaService.miaosha(user, goods);
        model.addAttribute("orderInfo", orderInfo);
        model.addAttribute("goods", goods);
        return "order_detail";
    }
}
```

查订单 查询用户是否已经秒杀过该商品
dao: 用 用户id和商品id 查询对应的订单
```java
@Mapper
public interface OrderDao {
    
    @Select("select * from miaosha_order where user_id=#{userId} and goods_id=#{goodsId}")
    public MiaoshaOrder getMiaoshaOrderByUserIdGoodsId(@Param("userId") long userId, @Param("goodsId") long goodsId);
    }
```

OrderService: controller 里判断是不是非null
```java
@Service
public class OrderService {
    
    @Autowired
    OrderDao orderDao;
    // 根据用户ID和商品ID查找相应订单
    public MiaoshaOrder getMiaoshaOrderByUserIdGoodsId(long userId, long goodsId) {
        return orderDao.getMiaoshaOrderByUserIdGoodsId(userId, goodsId);
    }
}
```

定义`MiaoshaService` 用于对1.减库存 2.下单 3.加入秒杀订单 包装成事务
```java
@Service
public class MiaoshaService {
    @Autowired
    GoodsService goodsService;

    @Autowired
    OrderService orderService;

    /**
     * 输入用户和商品 返回订单
     * @param user
     * @param goods
     * @return
     */
    @Transactional
    public OrderInfo miaosha(MiaoshaUser user, GoodVo goods) {

        //减库存 下订单 写入秒杀订单
        goodsService.reduceStock(goods);
        //order_info maiosha_order
        return orderService.createOrder(user, goods);
    }
}
```

1. 减少库存：查找miaosha商品ID并更新数据库：

更新：通过GoodVo更新goods信息
要通过GoodsDao更新数据库，一般不引入其他Service，所以引入`GoodsService`
同理写订单不是调用OrderDao 而是 OrderService

减少库存的sql
```java
@Update("update miaosha_goods set stock_count = stock_count - 1 where goods_id = #{goodsId}")
    public int reduceStock(MiaoshaGoods g);
```
GoodsService:
```java
@Service
public class GoodsService {
    @Autowired
    GoodsDao goodsDao;

    // 商品列表
    public List<GoodVo> listGoodsVo(){
        return goodsDao.listGoodsVo();

    }
    // 商品详情
    public GoodVo getGoodsVoByGoodsId(long goodsId) {
        return goodsDao.getGoodsVoByGoodsId(goodsId);
    }
    // 减库存
    public void reduceStock(GoodVo goods) {
        MiaoshaGoods g = new MiaoshaGoods();
        g.setId(goods.getId());
        goodsDao.reduceStock(g);
    }
}
```

2. 下单（生成订单）：生成订单Info
`OrderServece`
根据User，GoodVo 拼成OrderInfo
```java
Service
public class OrderService {
    
    @Autowired
    OrderDao orderDao;

    // 根据用户ID和商品ID查找相应订单
    public MiaoshaOrder getMiaoshaOrderByUserIdGoodsId(long userId, long goodsId) {
        return orderDao.getMiaoshaOrderByUserIdGoodsId(userId, goodsId);
    }

    // 根据用户和商品信息创建订单信息
    @Transactional
    public OrderInfo createOrder(MiaoshaUser user, GoodVo goods) {
        OrderInfo orderInfo = new OrderInfo();
        orderInfo.setCreateDate(new Date());
        orderInfo.setDeliveryAddrId(0L);
        orderInfo.setGoodsCount(1);
        orderInfo.setGoodsId(goods.getId());
        orderInfo.setGoodsName(goods.getGoodsName());
        orderInfo.setGoodsPrice(goods.getMiaoshaPrice());
        orderInfo.setOrderChannel(1);
        orderInfo.setStatus(0);
        orderInfo.setUserId(user.getId());
        // 数据库insert order表
        long orderId = orderDao.insert(orderInfo);
        MiaoshaOrder miaoshaOrder = new MiaoshaOrder();
        miaoshaOrder.setGoodsId(goods.getId());
        miaoshaOrder.setOrderId(orderId);
        miaoshaOrder.setUserId(user.getId());
        // 数据库 miaoshaOrder表
        orderDao.insertMiaoshaOrder(miaoshaOrder);
        return orderInfo;
    }
    
}
```
Dao 插入两个订单并且有返回值
```java
@Mapper
public interface OrderDao {
    // 用户id+商品id查找miaosha表订单信息
    @Select("select * from miaosha_order where user_id=#{userId} and goods_id=#{goodsId}")
    public MiaoshaOrder getMiaoshaOrderByUserIdGoodsId(@Param("userId") long userId, @Param("goodsId") long goodsId);
    // 创建订单
    @Insert("insert into order_info(user_id, goods_id, goods_name, goods_count, goods_price, order_channel, status, create_date)values("
            + "#{userId}, #{goodsId}, #{goodsName}, #{goodsCount}, #{goodsPrice}, #{orderChannel},#{status},#{createDate} )")
    @SelectKey(keyColumn="id", keyProperty="id", resultType=long.class, before=false, statement="select last_insert_id()")
    public long insert(OrderInfo orderInfo);
    // 创建秒杀订单
    @Insert("insert into miaosha_order (user_id, goods_id, order_id)values(#{userId}, #{goodsId}, #{orderId})")
    public int insertMiaoshaOrder(MiaoshaOrder miaoshaOrder);
    
}
```

新建订单详情页：
```html
<div class="panel panel-default">
  <div class="panel-heading">秒杀订单详情</div>
      <p th:text="${orderInfo.getId()}"></p>
  <table class="table" id="goodslist">
        <tr>  
        <td>商品名称</td>  
        <td th:text="${goods.goodsName}" colspan="3"></td> 
     </tr>  
     <tr>  
        <td>商品图片</td>  
        <td colspan="2"><img th:src="@{${goods.goodsImg}}" width="200" height="200" /></td>  
     </tr>
      <tr>  
        <td>订单价格</td>  
        <td colspan="2" th:text="${orderInfo.goodsPrice}"></td>  
     </tr>
     <tr>
            <td>下单时间</td>  
            <td th:text="${#dates.format(orderInfo.createDate, 'yyyy-MM-dd HH:mm:ss')}" colspan="2"></td>  
     </tr>
     <tr>
        <td>订单状态</td>  
        <td >
            <span th:if="${orderInfo.status eq 0}">未支付</span>
            <span th:if="${orderInfo.status eq 1}">待发货</span>
            <span th:if="${orderInfo.status eq 2}">已发货</span>
            <span th:if="${orderInfo.status eq 3}">已收货</span>
            <span th:if="${orderInfo.status eq 4}">已退款</span>
            <span th:if="${orderInfo.status eq 5}">已完成</span>
        </td>  
        <td>
            <button class="btn btn-primary btn-block" type="submit" id="payButton">立即支付</button>
        </td>
     </tr>
      <tr>
            <td>收货人</td>  
            <td colspan="2">XXX  18812341234</td>  
     </tr>
     <tr>
            <td>收货地址</td>  
            <td colspan="2">北京市昌平区回龙观龙博一区</td>  
     </tr>
  </table>
</div>
```

访问：http://localhost:8080/goods/to_detail/1 会发送post带着goodId token里有用户
http://localhost:8080/miaosha/do_miaosha 完成秒杀


### 10.JMeter测试QPS压测 打成war包放到tomcat服务器上
https://jmeter.apache.org/
1 压测商品列表页 
QPS说法：并发在1000的时候网站的QPS是1000或者500
TPS 每秒钟完成了20笔订单
`D:\apache-jmeter-5.0\bin\jmeter.bat`
TestPlan-右键-ADD-thread group
Number of Thread ： 10  线程数
Ramp-Up Period ： 10 用10秒把10个线程都启动起来

默认配置
对线程组右键-add-Config Element -Http request default
添加http和IP和端口

对线程组右键-add-sample-http请求
不用填 http ip 端口
方法get，path：/goods/to_list

对线程组右键-add-Listener-Aggregate Report
也可以添加 Graph Results

![jmetermiaosha.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/jmetermiaosha.jpg)
Average 平均花费时间 10ms
Throughput 可以当作qps 表示一秒能处理11.5个请求
添加监听器 View Results in Table
先把监听器都右键清空
![Jmetertable.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/Jmetertable.jpg)
报错空指针 修改位置：
`UserArgumentResolver.java`
```java
private String getCookieValue(HttpServletRequest request, String cookiName) {
        Cookie[]  cookies = request.getCookies();
        // 添加空指针判断
        if(cookies == null || cookies.length <= 0){
            return null;
        }
        for(Cookie cookie : cookies) {
            if(cookie.getName().equals(cookiName)) {
                return cookie.getValue();
            }
        }
        return null;
    }
```
线程数1000的情况下 只有 35每秒qps
![onekjmeter.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/onekjmeter.jpg)
打开数据库服务器的top
10000个线程 大概因为虚拟机所以压榨主机需要的更多 照理说应该load average会超过1
多核cpu负载超过表示很多进程在等待

压测用户对象
新建http request
path：/user/info
添加参数：token：ca5be550941349b7bb336f9451a41748

新建controller
```java
@Controller
@RequestMapping("/user")
public class UserController {
    private static Logger log = LoggerFactory.getLogger(GoodsController.class);
    @RequestMapping("/info")
    @ResponseBody
    public Result<MiaoshaUser> info(Model model,MiaoshaUser user){
        return Result.success(user);
    }

}
```
![userinfoqps.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/userinfoqps.jpg)
报错消息：`JedisException: Could not get a resource from the pool`
redis获取不到连接
修改配置
```sh
# redis
redis.timeout=10
redis.password=123456
redis.poolMaxTotal=1000
redis.poolMaxIdle=500
spring.redis.pool.max-wait=500
# jdbc
spring.datasource.maxActive=1000
spring.datasource.initialSize=100
spring.datasource.maxWait=60000
spring.datasource.minIdle=500
```
不报错了
![userinfomax.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/userinfomax.jpg)

比商品列表的qps高很多，因为redis在内存

多用户token测试
在Jmeter中添加CSV data set config 
在http请求里的参数是`${userToken}`

在服务器上测试jmeter
1.在windows上录好jmx
2.运行`jmeter.sh -n -t xxx.jmx -l result.jtl`
3.把result.jtl导入jmeter

redis压测：
100个并发 100000个请求
`redis-benchmark -h 127.0.0.1 -p 6379 -c 100 -n 100000`
```sh
====== GET ======
  100000 requests completed in 2.55 seconds
  100 parallel clients
  3 bytes payload
  keep alive: 1

7.87% <= 1 milliseconds
72.82% <= 2 milliseconds
94.64% <= 3 milliseconds
97.13% <= 4 milliseconds
98.74% <= 5 milliseconds
99.65% <= 6 milliseconds
99.98% <= 7 milliseconds
100.00% <= 7 milliseconds
39277.30 requests per second
```
1秒能4w get
```sh
[root@localhost ~]# redis-benchmark -h 127.0.0.1 -p 6379 -q -d 100
PING_INLINE: 41806.02 requests per second
PING_BULK: 41858.52 requests per second
SET: 39184.95 requests per second
GET: 41736.23 requests per second
INCR: 41876.05 requests per second
```

### 打war包
```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-tomcat</artifactId>
  <!--编译时需要 运行时不需要-->
  <scope>provided</scope>
</dependency>


 <build>
    <finalName>${project.artifactId}</finalName>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-war-plugin</artifactId>
        <configuration>
          <failOnMissingWebXml>false</failOnMissingWebXml>
        </configuration>
      </plugin>
    </plugins>
  </build>
```

修改启动类
```java
@SpringBootApplication
public class MainApplication extends SpringBootServletInitializer{

    public static void main(String[] args) throws Exception {
        SpringApplication.run(MainApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(MainApplication.class);
    }
}
```

命令行`mvn clean package`
把war放到tomcat里`D:\apache-tomcat-8.5.31\webapps` 启动`startup.bat`
访问`http://localhost:8080/miaoshaLearn/login/to_login`
真实部署的时候放到ROOT下面就不需要tomcat路径了

为了方便还是打jar包
war包插件改jar包的 注释掉tomcat的依赖
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
</plugin>
```
启动类还原
```java
@SpringBootApplication
public class MainApplication{
    public static void main(String[] args) throws Exception {
        SpringApplication.run(MainApplication.class, args);
    }
}
```
命令行`mvn clean package`
打开jar包 `META-INF\META-INF`
```java
Main-Class: org.springframework.boot.loader.JarLauncher
Start-Class: com.cloud.miaosha.MainApplication
Spring-Boot-Classes: BOOT-INF/classes/
Spring-Boot-Lib: BOOT-INF/lib/
```

上传jar包到linux
`nohup java -jar miaosha.jar &`
访问：`http://10.1.18.133:8080/goods/to_list`

上传jmeter和jmx文件到linux
```sh
chmod 777  jmeter.sh
chmod 777  jmeter
```

生成测试用户：
用`HttpURLConnection` 发送post
```java
URL url = new URL(urlString);
HttpURLConnection co = (HttpURLConnection)url.openConnection();
co.setRequestMethod("POST");
co.setDoOutput(true);
OutputStream out = co.getOutputStream();
String params = "mobile="+user.getId()+"&password="+MD5Util.inputPassToFormPass("123456");
out.write(params.getBytes());
out.flush();
InputStream inputStream = co.getInputStream();
ByteArrayOutputStream bout = new ByteArrayOutputStream();
byte buff[] = new byte[1024];
int len = 0;
while((len = inputStream.read(buff) >=0)){
    bout.write(buff,0,len);
}
inputStream.close();
bout.close();
String response = new String(bout.toByteArray());
//fast json解析并获取token
```

修改login返回token
```java
@RequestMapping("/do_login")
@ResponseBody
public Result<String> doLogin(HttpServletResponse response,@Valid  LoginVo loginVo) {
    log.info(loginVo.toString());
//        登录
    String token = userService.login(response, loginVo);
    System.out.println("登陆成功");
    return Result.success(token);
}
```

dbutil
```java
public class DBUtil {
    
private static Properties props;

static {
    try {
        InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("application.properties");
        props = new Properties();
        props.load(in);
        in.close();
    }catch(Exception e) {
        e.printStackTrace();
    }
}

public static Connection getConn() throws Exception{
    String url = props.getProperty("spring.datasource.url");
    String username = props.getProperty("spring.datasource.username");
    String password = props.getProperty("spring.datasource.password");
    String driver = props.getProperty("spring.datasource.driver-class-name");
    Class.forName(driver);
    return DriverManager.getConnection(url,username, password);
}
}
```
删除数据库
```sql
delete from miaosha_user where nickname like 'user%';
```

userutil
```java
public class UserUtil {
    
    private static void createUser(int count) throws Exception{
        List<MiaoshaUser> users = new ArrayList<MiaoshaUser>(count);
        //生成用户
        for(int i=0;i<count;i++) {
            MiaoshaUser user = new MiaoshaUser();
            user.setId(13000000000L+i);
            user.setLoginCount(1);
            user.setNickname("user"+i);
            user.setRegisterDate(new Date());
            user.setSalt("1a2b3c");
            user.setPassword(MD5Util.inputPassToDbPass("123456", user.getSalt()));
            users.add(user);
        }
        System.out.println("create user");
//      //插入数据库
        Connection conn = DBUtil.getConn();
        String sql = "insert into miaosha_user(login_count, nickname, register_date, salt, password, id)values(?,?,?,?,?,?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        for(int i=0;i<users.size();i++) {
            MiaoshaUser user = users.get(i);
            pstmt.setInt(1, user.getLoginCount());
            pstmt.setString(2, user.getNickname());
            pstmt.setTimestamp(3, new Timestamp(user.getRegisterDate().getTime()));
            pstmt.setString(4, user.getSalt());
            pstmt.setString(5, user.getPassword());
            pstmt.setLong(6, user.getId());
            pstmt.addBatch();
        }
        pstmt.executeBatch();
        pstmt.close();
        conn.close();
        System.out.println("insert to db");
        //登录，生成token
        String urlString = "http://localhost:8080/login/do_login";
        File file = new File("D:/miaoshaLearn/tokens.txt");
        if(file.exists()) {
            file.delete();
        }
        RandomAccessFile raf = new RandomAccessFile(file, "rw");
        file.createNewFile();
        raf.seek(0);
        for(int i=0;i<users.size();i++) {
            MiaoshaUser user = users.get(i);
            URL url = new URL(urlString);
            HttpURLConnection co = (HttpURLConnection)url.openConnection();
            co.setRequestMethod("POST");
            co.setDoOutput(true);
            OutputStream out = co.getOutputStream();
            String params = "mobile="+user.getId()+"&password="+MD5Util.inputPassToFormPass("123456");
            out.write(params.getBytes());
            out.flush();
            InputStream inputStream = co.getInputStream();
            ByteArrayOutputStream bout = new ByteArrayOutputStream();
            byte buff[] = new byte[1024];
            int len = 0;
            while((len = inputStream.read(buff)) >= 0) {
                bout.write(buff, 0 ,len);
            }
            inputStream.close();
            bout.close();
            String response = new String(bout.toByteArray());
            JSONObject jo = JSON.parseObject(response);
            String token = jo.getString("data");
            System.out.println("create token : " + user.getId());
            
            String row = user.getId()+","+token;
            raf.seek(raf.length());
            raf.write(row.getBytes());
            raf.write("\r\n".getBytes());
            System.out.println("write to file : " + user.getId());
        }
        raf.close();
        
        System.out.println("over");
    }
    
    public static void main(String[] args)throws Exception {
        createUser(5000);
    }
}

```
// 虚拟机压测todo


### 页面缓存
页面静态化：前后端分离，通过ajax渲染页面
浏览器会把html缓存在客户端，页面数据不需要重复下载，只下载动态数据

Redis 页面缓存key
```java
public class GoodsKey extends BasePrefix {
    private GoodsKey(int expireSeconds, String prefix) {
        super(expireSeconds, prefix);
    }
    public static GoodsKey getGoodsList = new GoodsKey(60, "gl");
    public static GoodsKey getGoodsDetail = new GoodsKey(60, "gd");
}
```

```java
@Autowired
ThymeleafViewResolver thymeleafViewResolver;

@Autowired
ApplicationContext applicationContext;

@RequestMapping(value = "/to_list",produces = "txt/html")
@ResponseBody
public String toLogin(HttpServletRequest request, HttpServletResponse response, Model model, MiaoshaUser user) {
    model.addAttribute("user",user);
    // 取页面缓存
    String html = redisService.get(GoodsKey.getGoodsList, "", String.class);
    if(!StringUtils.isEmpty(html)) {
        return html;
    }
    // 秒杀商品列表
    List<GoodVo> goodVos = goodsService.listGoodsVo();
    model.addAttribute("goodsList",goodVos);
    SpringWebContext ctx = new SpringWebContext(request,response,
            request.getServletContext(),request.getLocale(), model.asMap(), applicationContext );
    //手动渲染
    // 模板名称 context
    html = thymeleafViewResolver.getTemplateEngine().process("goods_list", ctx);

    // 缓存起来
    if(!StringUtils.isEmpty(html)) {
        redisService.set(GoodsKey.getGoodsList, "", html);
    }
    return "goods_list";
}
```
http://localhost:8080/goods/to_list
连上redis 查看keys GoodsKey:gl

### URL缓存 详情页缓存
```java
@RequestMapping(value = "/to_detail/{goodsId}",produces="text/html")
@ResponseBody
public String detail(HttpServletRequest request, HttpServletResponse response,
                     Model model,MiaoshaUser user,
                     @PathVariable("goodsId")long goodsId) {
    model.addAttribute("user", user);
    //取缓存
    String html = redisService.get(GoodsKey.getGoodsDetail, ""+goodsId, String.class);
    if(!StringUtils.isEmpty(html)) {
        return html;
    }

    GoodVo goods = goodsService.getGoodsVoByGoodsId(goodsId);
    model.addAttribute("goods", goods);

    long startAt = goods.getStartDate().getTime();
    long endAt = goods.getEndDate().getTime();
    long now = System.currentTimeMillis();
    // 0：没开始 2：结束 1：进行中
    int miaoshaStatus = 0;
    // 倒计时
    int remainSeconds = 0;
    if(now < startAt ) {//秒杀还没开始，倒计时
        miaoshaStatus = 0;
        remainSeconds = (int)((startAt - now )/1000);
    }else  if(now > endAt){//秒杀已经结束
        miaoshaStatus = 2;
        remainSeconds = -1;
    }else {//秒杀进行中
        miaoshaStatus = 1;
        remainSeconds = 0;
    }
    model.addAttribute("miaoshaStatus", miaoshaStatus);
    model.addAttribute("remainSeconds", remainSeconds);
//        return "goods_detail";
    SpringWebContext ctx = new SpringWebContext(request,response,
            request.getServletContext(),request.getLocale(), model.asMap(), applicationContext );
    html = thymeleafViewResolver.getTemplateEngine().process("goods_detail", ctx);
    if(!StringUtils.isEmpty(html)) {
        redisService.set(GoodsKey.getGoodsDetail, ""+goodsId, html);
    }
    return html;
}
```

### 对象缓存 
分布式session根据token从redis中拿User对象
添加redis 用户id key
```java
public class MiaoshaUserKey extends BasePrefix{

    public static final int TOKEN_EXPIRE = 3600*24 * 2;
    private MiaoshaUserKey(int expireSeconds, String prefix) {
        super(expireSeconds, prefix);
    }
    public static MiaoshaUserKey token = new MiaoshaUserKey(TOKEN_EXPIRE, "tk");
    //永久有效
    public static MiaoshaUserKey getById = new MiaoshaUserKey(0, "id");
}
```
登陆验证的时候不是从mysql按id取 而是从redis取
```java
public MiaoshaUser getById(long id) {
    //取缓存
    MiaoshaUser user = redisService.get(MiaoshaUserKey.getById, ""+id, MiaoshaUser.class);
    if(user != null) {
        return user;
    }
    //取数据库
    user = miaoshaUserDao.getById(id);
    if(user != null) {
        redisService.set(MiaoshaUserKey.getById, ""+id, user);
    }
    return user;
}
```

修改密码： 更新数据库，修改缓存

Cache Aside Pattern
![cachepattern.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/cachepattern.jpg)

更新缓存的的Design Pattern有四种：Cache aside, Read through, Write through, Write behind caching.

```java
public boolean updatePassword(String token, long id, String formPass) {
    //取user
    MiaoshaUser user = getById(id);
    if(user == null) {
        throw new GlobalException(CodeMsg.MOBILE_NOT_EXIST);
    }
    //更新数据库
    MiaoshaUser toBeUpdate = new MiaoshaUser();
    toBeUpdate.setId(id);
    toBeUpdate.setPassword(MD5Util.formPassToDBPass(formPass, user.getSalt()));
    miaoshaUserDao.update(toBeUpdate);
    //处理缓存
    redisService.delete(MiaoshaUserKey.getById, ""+id);
    user.setPassword(toBeUpdate.getPassword());
    redisService.set(MiaoshaUserKey.token, token, user);
    return true;
}
```

user对象缓存应该删除。token缓存应该更新。

redisService 添加delete方法
```java
public boolean delete(KeyPrefix prefix, String key) {
    Jedis jedis = null;
    try {
        jedis =  jedisPool.getResource();
        //生成真正的key
        String realKey  = prefix.getPrefix() + key;
        long ret =  jedis.del(realKey);
        return ret > 0;
    }finally {
        returnToPool(jedis);
    }
}
```

在dao层添加update
```java
@Mapper
public interface MiaoshaUserDao {
    
    @Select("select * from miaosha_user where id = #{id}")
    public MiaoshaUser getById(@Param("id") long id);

    @Update("update miaosha_user set password = #{password} where id = #{id}")
    public void update(MiaoshaUser toBeUpdate);
}
```


### 页面静态化
不用`thymeleaf`


#### 详情页

将商品详情页包装成vo
```java
public class GoodsDetailVo {
    private int miaoshaStatus = 0;
    private int remainSeconds = 0;
    private GoodsVo goods ;
    private MiaoshaUser user;
}
```

静态页面xhr获取后台数据
`<a th:href="'/goods_detail.htm?goodsId='+${goods.id}">`
```js
$(function(){
    //countDown();
    getDetail();
});

function getDetail(){
    var goodsId = g_getQueryString("goodsId");
    $.ajax({
        url:"/goods/detail/"+goodsId,
        type:"GET",
        success:function(data){
            if(data.code == 0){
                render(data.data);
            }else{
                layer.msg(data.msg);
            }
        },
        error:function(){
            layer.msg("客户端请求有误");
        }
    });
}
```


js获取url后面的参数name的值
```javascript
// 获取url参数
function g_getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if(r != null) return unescape(r[2]);
    return null;
};
```

成功之后的回调函数 渲染页面
```js
function render(detail){
    var miaoshaStatus = detail.miaoshaStatus;
    var remainSeconds = detail.remainSeconds;
    var goods = detail.goods;
    var user = detail.user;
    if(user){
        $("#userTip").hide();
    }
    $("#goodsName").text(goods.goodsName);
    $("#goodsImg").attr("src", goods.goodsImg);
    $("#startTime").text(new Date(goods.startDate).format("yyyy-MM-dd hh:mm:ss"));
    $("#remainSeconds").val(remainSeconds);
    $("#goodsId").val(goods.id);
    $("#goodsPrice").text(goods.goodsPrice);
    $("#miaoshaPrice").text(goods.miaoshaPrice);
    $("#stockCount").text(goods.stockCount);
    countDown();
}
```

日期格式化
```js
//设定时间格式化函数，使用new Date().format("yyyyMMddhhmmss");  
Date.prototype.format = function (format) {  
    var args = {  
        "M+": this.getMonth() + 1,  
        "d+": this.getDate(),  
        "h+": this.getHours(),  
        "m+": this.getMinutes(),  
        "s+": this.getSeconds(),  
    };  
    if (/(y+)/.test(format))  
        format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));  
    for (var i in args) {  
        var n = args[i];  
        if (new RegExp("(" + i + ")").test(format))  
            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? n : ("00" + n).substr(("" + n).length));  
    }  
    return format;  
};  
```

页面：
```html
<body>
<div class="panel panel-default">
    <div class="panel-heading">秒杀商品详情</div>
    <div class="panel-body">
        <span id="userTip"> 您还没有登录，请登陆后再操作<br/></span>
    </div>
    <table class="table" id="goodslist">
        <tr>
            <td>商品名称</td>
            <td colspan="3" id="goodsName"></td>
        </tr>
        <tr>
            <td>商品图片</td>
            <td colspan="3"><img  id="goodsImg" width="200" height="200" /></td>
        </tr>
        <tr>
            <td>秒杀开始时间</td>
            <td id="startTime"></td>
            <td >
                <input type="hidden" id="remainSeconds" />
                <span id="miaoshaTip"></span>
            </td>
            <td>
                <!--
                    <form id="miaoshaForm" method="post" action="/miaosha/do_miaosha">
                        <button class="btn btn-primary btn-block" type="submit" id="buyButton">立即秒杀</button>
                        <input type="hidden" name="goodsId"  id="goodsId" />
                    </form>-->
                <button class="btn btn-primary btn-block" type="button" id="buyButton"onclick="doMiaosha()">立即秒杀</button>
                <input type="hidden" name="goodsId"  id="goodsId" />
            </td>
        </tr>
        <tr>
            <td>商品原价</td>
            <td colspan="3" id="goodsPrice"></td>
        </tr>
        <tr>
            <td>秒杀价</td>
            <td colspan="3"  id="miaoshaPrice"></td>
        </tr>
        <tr>
            <td>库存数量</td>
            <td colspan="3"  id="stockCount"></td>
        </tr>
    </table>
</div>
</body>
```

controller
```java
@RequestMapping(value = "/detail/{goodsId}")
@ResponseBody
public Result<GoodsDetailVo> detail(HttpServletRequest request, HttpServletResponse response, MiaoshaUser user,
    @PathVariable("goodsId")long goodsId) {

    GoodVo goods = goodsService.getGoodsVoByGoodsId(goodsId);

    long startAt = goods.getStartDate().getTime();
    long endAt = goods.getEndDate().getTime();
    long now = System.currentTimeMillis();
    // 0：没开始 2：结束 1：进行中
    int miaoshaStatus = 0;
    // 倒计时
    int remainSeconds = 0;
    if(now < startAt ) {//秒杀还没开始，倒计时
        miaoshaStatus = 0;
        remainSeconds = (int)((startAt - now )/1000);
    }else  if(now > endAt){//秒杀已经结束
        miaoshaStatus = 2;
        remainSeconds = -1;
    }else {//秒杀进行中
        miaoshaStatus = 1;
        remainSeconds = 0;
    }
   GoodsDetailVo vo = new GoodsDetailVo();
    vo.setGoods(goods);
    vo.setUser(user);
    vo.setMiaoshaStatus(miaoshaStatus);
    vo.setRemainSeconds(remainSeconds);
    return Result.success(vo);
}
```

#### 秒杀按钮
`<button class="btn btn-primary btn-block" type="button" id="buyButton"onclick="doMiaosha()">立即秒杀</button>`

秒杀返回订单
对后台数据有影响的要用post，put不能用get。因为搜索引擎遍历，执行`/delete?`等链接

```js
function doMiaosha(){
    $.ajax({
        url:"/miaosha/do_miaosha",
        type:"POST",
        data:{
            goodsId:$("#goodsId").val(),
        },
        success:function(data){
            if(data.code == 0){
                window.location.href="/order_detail.htm?orderId="+data.data.id;
            }else{
                layer.msg(data.msg);
            }
        },
        error:function(){
            layer.msg("客户端请求有误");
        }
    });

}
```

跳转到订单详情页
```java
@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    MiaoshaUserService userService;
    
    @Autowired
    RedisService redisService;
    
    @Autowired
    OrderService orderService;
    
    @Autowired
    GoodsService goodsService;
    
    @RequestMapping("/detail")
    @ResponseBody
    public Result<OrderDetailVo> info(Model model, MiaoshaUser user,
                                      @RequestParam("orderId") long orderId) {
        if(user == null) {
            return Result.error(CodeMsg.SESSION_ERROR);
        }
        OrderInfo order = orderService.getOrderById(orderId);
        if(order == null) {
            return Result.error(CodeMsg.ORDER_NOT_EXIST);
        }
        // 用订单的商品id 查商品信息
        long goodsId = order.getGoodsId();
        GoodVo goods = goodsService.getGoodsVoByGoodsId(goodsId);
        OrderDetailVo vo = new OrderDetailVo();
        vo.setOrder(order);
        vo.setGoods(goods);
        return Result.success(vo);
    }
    
}
```

新建订单VO
```java
public class OrderDetailVo {
    private GoodVo goods;
    private OrderInfo order;
}
```
新建订单页controller
新的sql 用订单id查订单
```java
@Mapper
public interface OrderDao {
    @Select("select * from order_info where id = #{orderId}")
    public OrderInfo getOrderById(@Param("orderId")long orderId);
}
```

新的错误对象
```java
//订单模块 5004XX
public static CodeMsg ORDER_NOT_EXIST = new CodeMsg(500400, "订单不存在");
```


```html
<body>
<div class="panel panel-default">
  <div class="panel-heading">秒杀订单详情</div>
  <table class="table" id="goodslist">
        <tr>  
        <td>商品名称</td>  
        <td colspan="3" id="goodsName"></td> 
     </tr>  
     <tr>  
        <td>商品图片</td>  
        <td colspan="2"><img  id="goodsImg" width="200" height="200" /></td>  
     </tr>
      <tr>  
        <td>订单价格</td>  
        <td colspan="2"  id="orderPrice"></td>  
     </tr>
     <tr>
            <td>下单时间</td>  
            <td id="createDate" colspan="2"></td>  
     </tr>
     <tr>
        <td>订单状态</td>  
        <td id="orderStatus">
        </td>  
        <td>
            <button class="btn btn-primary btn-block" type="submit" id="payButton">立即支付</button>
        </td>
     </tr>
      <tr>
            <td>收货人</td>  
            <td colspan="2">XXX  18812341234</td>  
     </tr>
     <tr>
            <td>收货地址</td>  
            <td colspan="2">北京市昌平区回龙观龙博一区</td>  
     </tr>
  </table>
</div>
</body>
<script>
function render(detail){
    var goods = detail.goods;
    var order = detail.order;
    $("#goodsName").text(goods.goodsName);
    $("#goodsImg").attr("src", goods.goodsImg);
    $("#orderPrice").text(order.goodsPrice);
    $("#createDate").text(new Date(order.createDate).format("yyyy-MM-dd hh:mm:ss"));
    var status = "";
    if(order.status == 0){
        status = "未支付"
    }else if(order.status == 1){
        status = "待发货";
    }
    $("#orderStatus").text(status);
    
}

$(function(){
    getOrderDetail();
})

function getOrderDetail(){
    var orderId = g_getQueryString("orderId");
    $.ajax({
        url:"/order/detail",
        type:"GET",
        data:{
            orderId:orderId
        },
        success:function(data){
            if(data.code == 0){
                render(data.data);
            }else{
                layer.msg(data.msg);
            }
        },
        error:function(){
            layer.msg("客户端请求有误");
        }
    });
}
</script>
```


#### 静态化配置
304是客户端（浏览器）向服务端自动加
`If-Modified-Since: Fri, 28 Dec 2018 11:48:23 GMT`
服务端会检查如果没发生变化就304.还是发生了一次交互。

让页面直接从浏览器取。
Spring resources handling
```shell
#static
spring.resources.add-mappings=true
spring.resources.cache-period= 3600
spring.resources.chain.cache=true 
spring.resources.chain.enabled=true
spring.resources.chain.gzipped=true
spring.resources.chain.html-application-cache=true
spring.resources.static-locations=classpath:/static/
```
response里200 （但其实是来自缓存）响应头里有，达到从浏览器读。
`Cache-Control: max-age=3600`

### bug1：秒杀并发库存到0以下`and stock_count >0`
code review
1.判断库存2.判断用户订单3.秒杀
```java
@RequestMapping(value = "/do_miaosha",method = RequestMethod.POST)
@ResponseBody
public Result<OrderInfo> list(MiaoshaUser user,
                   @RequestParam("goodsId")long goodsId) {
    // 没登陆
    if(user == null) {
        return Result.error(CodeMsg.SESSION_ERROR);
    }
    //判断库存
    GoodVo goods = goodsService.getGoodsVoByGoodsId(goodsId);
    int stock = goods.getStockCount();
    if(stock <= 0) {
        return Result.error(CodeMsg.MIAO_SHA_OVER);
    }
//      从用户订单查询是否已经对这个物品下过单了
    MiaoshaOrder order = orderService.getMiaoshaOrderByUserIdGoodsId(user.getId(), goodsId);
    if(order != null) {
        return Result.error(CodeMsg.REPEATE_MIAOSHA);
    }
    //1.减库存 2.下订单 3.写入秒杀订单 这三步是一个是事务
    OrderInfo orderInfo = miaoshaService.miaosha(user, goods);

    return Result.success(orderInfo);
}
```

减库存的sql
```java
@Update("update miaosha_goods set stock_count = stock_count -1 where goods_id = #{gooddsId}")
public int reduceStock(MiaoshaGoods g);
```
如果库存有1，两个线程同时调用这个sql就负数了

修改：只有库存>0才减
```java
@Update("update miaosha_goods set stock_count = stock_count -1 where goods_id = #{gooddsId} and stock_count >0")
    public int reduceStock(MiaoshaGoods g);
```
因为数据库会加锁 不会两个线程同时更新

### bug2：用户秒杀了多个商品:数据库唯一索引
同一个用户多个请求，在没完成第一个订单之前都判断完了有库存，也没秒杀过。
结果：多个线程都到减库存，下订单，生成新的秒杀订单。

数据库唯一索引，让一个用户只能有一个秒杀订单
![uniqueindex.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/uniqueindex.jpg)


优化：
查询用户是否买过这个商品不走数据库
建key
```java
public class OrderKey extends BasePrefix {

    public OrderKey( String prefix) {
        super( prefix);
    }
    public static OrderKey getMiaoshaOrderByUidGid = new OrderKey("moug");
}
```


```java
// 根据用户ID和商品ID查找相应订单
public  MiaoshaOrder getMiaoshaOrderByUserIdGoodsId(long userId, long goodsId) {
    return redisService.get(OrderKey.getMiaoshaOrderByUidGid,""+userId+"_"+goodsId , MiaoshaOrder.class);
//      return orderDao.getMiaoshaOrderByUserIdGoodsId(userId, goodsId);
}
```

生成订单之后要写缓存
```java
// 根据用户和商品信息创建订单信息
@Transactional
public OrderInfo createOrder(MiaoshaUser user, GoodVo goods) {
    //...
    // 数据库 miaoshaOrder表
    orderDao.insertMiaoshaOrder(miaoshaOrder);

    redisService.set(OrderKey.getMiaoshaOrderByUidGid,""+user.getId()+"_"+goods.getId(),miaoshaOrder);
    return orderInfo;
}
```

### 其他静态资源优化
1.js/css压缩
2.多个js/css组合成一个减少连接数
3.CDN

### 接口优化

redis预减库存减少数据库访问，减库存请求入消息队列，返回排队中。
服务端：请求出队，生成订单，减库存。
客户端轮询秒杀是否成功。

### 安装 RabitMQ
1.安装依赖`yum install ncurses-devel`
2.安装erlang`yum install erlang` 执行erl表示安装成功
3.安装rabbitmq 
解压`xz -d rabbitmq-server-generic-unix-3.7.9.tar.xz`
解压`tar xf rabbitmq-server-generic-unix-3.7.9.tar`
安装python
安装`yum install xmlto -y`
安装`yum install python-simplejson -y`
```shell
cd rabbitmq_server-3.7.9/
cd sbin
```
启动然后报错
yum remove掉erlang*相关的
```shell
tar -xf otp_src_21.0.tar.gz
./configure --prefix=/usr/local/erlang20 --without-javac
make -j 8
make install
vim /etc/profile
export PATH=/usr/local/erlang21/bin:$PATH 
source /etc/profile
```
回到sbin启动`./rabbitmq-server`
可以看log 端口是5672
```shell
[root@localhost sbin]# netstat -nap |grep 5672
tcp        0      0 0.0.0.0:25672           0.0.0.0:*               LISTEN      14205/beam.smp      
tcp6       0      0 :::5672                 :::*                    LISTEN      14205/beam.smp 
```
关闭用`./rabbitmqctl stop`
```shell
[root@localhost sbin]# netstat -nap |grep 5672
tcp        0      0 127.0.0.1:43296         127.0.0.1:25672         TIME_WAIT   -
```

安装lsof
```shell
[root@localhost ebin]# lsof -i:5672
COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
beam.smp 17480 root   68u  IPv6 176892      0t0  TCP *:amqp (LISTEN)
beam.smp 17480 root   69u  IPv6 176909      0t0  TCP localhost.localdomain:amqp->10.1.18.15:10893 (ESTABLISHED)
```

### SpringBoot 集成RabbitMQ
erlang有原生socket一样的延迟
AMQP协议模型
生产者：1.投递到server，2投递到virtual host，3投递到exchange
exchange 和 message queue 有绑定关系。
![amqp.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/amqp.jpg)

核心概念：
{% note %}
- Server：Broker。接受连接。
- Connection:应用与Broker的网络连接。
- Channel：网络信道，一个会话任务。一个客户端可以建立多个channel。
- Message：消息结构由Properties（优先级，延迟）和Body组成。
- Virtual host：逻辑隔离，消息路由，划分服务。一个host里可以有多个exchange和queue。同一个host不能有同名的exchange和queue。（相当于redis 16个db的逻辑概念）
- Exchange：交换机，接受消息，根据路由键转发消息到binding的队列。
- Binding：Exchange和Queue的虚拟连接，可以有routing key。
- Routing key：路由规则。host确定如何路由一个消息。
- Queue:保存并转发给消费者。

{% endnote %}

核心配置文件位置：
`vi /usr/local/rabbitmq_server-3.7.9/ebin/rabbit.app`
loopback_users也在里面 可以修改成`[guest]`

rabbitMQ插件 可视化管理
```shell
rabbitmq-plugins list
rabbitmq-plugins enable rabbitmq_management
```
访问：`http://10.1.18.20:15672/`

1 添加依赖
```xml
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-amqp</artifactId>  
</dependency> 
```
2 添加配置
```java
#rabbitmq
spring.rabbitmq.host=10.1.18.20
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest
spring.rabbitmq.virtual-host=/
#消费者数量
spring.rabbitmq.listener.simple.concurrency= 10
spring.rabbitmq.listener.simple.max-concurrency= 10
#从队列里每次取几个
spring.rabbitmq.listener.simple.prefetch= 1
#消费者默认自动启动
spring.rabbitmq.listener.simple.auto-startup=true
# 消费失败会重新压入队列
spring.rabbitmq.listener.simple.default-requeue-rejected= true
#生产者重试
spring.rabbitmq.template.retry.enabled=true 
spring.rabbitmq.template.retry.initial-interval=1000 
spring.rabbitmq.template.retry.max-attempts=3
spring.rabbitmq.template.retry.max-interval=10000
spring.rabbitmq.template.retry.multiplier=1.0
```

新建rabbitmq包，

交换机的4种模式

### Direct 模式

配置类
```java
import org.springframework.amqp.core.Queue;
@Configuration
public class MQConfig {
    public static final String QUEUE = "queue";

    @Bean
    public Queue queue(){
        return new Queue(QUEUE,true);
    }
}
```

新建发送者
```java
@Service
public class MQSender {

    @Autowired
    AmqpTemplate amqpTemplate;

    public void send(Object message){
        String msg = RedisService.beanToString(message);
        amqpTemplate.convertAndSend(MQConfig.QUEUE,msg);
    }
}
```

重用redis中bean2String的方法
```java
public static  <T> String beanToString(T value){
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
String2Bean
```java
public static <T> T stringToBean(String str,Class<T> clazz){
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
        //fastJson 其他List类型要再写
        return JSON.toJavaObject(JSON.parseObject(str), clazz);
    }
}
```

消费者监听轮询
```java
@Service
public class MQSender {
    private static Logger log = LoggerFactory.getLogger(MQSender.class);

    @Autowired
    AmqpTemplate amqpTemplate;

    public void send(Object message){
        String msg = RedisService.beanToString(message);
        log.info("send message"+msg);
        amqpTemplate.convertAndSend(MQConfig.QUEUE,msg);
    }
}
```

随便用一个controller测试一下
```java
@RequestMapping("/mq")
@ResponseBody
public Result<String> mq(){
    sender.send("rabbitMQ消息测试");
    return Result.success("rabbitMQ消息测试");
}
```

报错：
```java
rabbitmq.client.AuthenticationFailureException: ACCESS_REFUSED - Login was refused using authentication mechanism PLAIN. For details see the broker logfile.
```

因为guest用户默认不能远程连接 localhost是可以的
https://www.rabbitmq.com/access-control.html
it can only connect over a loopback interface (i.e. localhost).

用方法2
修改rabbitmq.config
在`/usr/local/rabbitmq_server-3.7.9/etc/rabbitmq`下创建`rabbitmq.config`
添加
`[{rabbit, [{loopback_users, []}]}].`

重启
```shell
rabbitmqctl stop
rabbitmq-server 
```

访问`http://localhost:8080/demo/mq` 可以看到log

### Topic模式 可以发给多个queue
```java
@Configuration
public class MQConfig {
    public static final String QUEUE = "queue";
    public static final String TOPIC_QUEUE1 = "topic_queue1";
    public static final String TOPIC_QUEUE2 = "topic_queue2";
    public static final String TOPIC_EXCHANGE = "topic_queue2";
    public static final String ROUTING_KEY1 = "topic.key1";
    //* 表示一个单词。 #表示0个或者多个单词
    public static final String ROUTING_KEY2 = "topic.#";

    // 直接模式
    @Bean
    public Queue queue(){
        return new Queue(QUEUE,true);
    }

    // topic模式
    @Bean
    public Queue topicQueue1(){
        return new Queue(TOPIC_QUEUE1,true);
    }

    @Bean
    public Queue topicQueue2(){
        return new Queue(TOPIC_QUEUE2,true);
    }

    @Bean
    public TopicExchange topicExchange(){
        return new TopicExchange(TOPIC_EXCHANGE);
    }
    @Bean
    public Binding topicBinding1(){
        return BindingBuilder.bind(topicQueue1()).to(topicExchange()).with(ROUTING_KEY1);
    }

    @Bean
    public Binding topicBinding2(){
        return BindingBuilder.bind(topicQueue2()).to(topicExchange()).with(ROUTING_KEY2);
    }
}
```

发送：
```java
@Service
public class MQSender {
    private static Logger log = LoggerFactory.getLogger(MQSender.class);

    @Autowired
    AmqpTemplate amqpTemplate;

    public void send(Object message){
        String msg = RedisService.beanToString(message);
        log.info("send message"+msg);
        amqpTemplate.convertAndSend(MQConfig.QUEUE,msg);
    }

    public void sendTopic(Object message){
        String msg = RedisService.beanToString(message);
        log.info("send topic message"+msg);
        // queue1和2都能匹配上都能收到
        amqpTemplate.convertAndSend(MQConfig.TOPIC_EXCHANGE,MQConfig.ROUTING_KEY1,msg+"1");
        // 只有queue2能匹配上
        amqpTemplate.convertAndSend(MQConfig.TOPIC_EXCHANGE,MQConfig.ROUTING_KEY2,msg+"2");
    }
}
```

接收：
```java
@Service
public class MQReceiver {

    private static Logger log = LoggerFactory.getLogger(MQSender.class);

    @RabbitListener(queues = MQConfig.QUEUE)
    public void receive(String message){
        log.info("receive message:"+message);
    }

    @RabbitListener(queues = MQConfig.TOPIC_QUEUE1)
    public void receiveTopic1(String message){
        log.info("receive q1 message:"+message);
    }

    @RabbitListener(queues = MQConfig.TOPIC_QUEUE2)
    public void receiveTopic2(String message){
        log.info("receive q2 message:"+message);
    }
}
```

```java
@RequestMapping("/mq/topic")
@ResponseBody
public Result<String> topic(){
    // 发两条消息
    sender.sendTopic("topic消息测试");
    return Result.success("topic消息测试");
}
```

结果
![topicmq.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/topicmq.jpg)


### Fanout模式 广播模式 不需要绑定key
