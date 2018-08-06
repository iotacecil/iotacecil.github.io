---
title: javanet
date: 2018-03-11 23:05:52
tags: [javaNet,java]
---
### 1.前后台json格式
```java
class Result<T> {
    private int code;
    private String msg;
    private T data;
}
```
为实现controller中的返回：
```java
@RequestMapping("/hello")
    @ResponseBody
    public Result<String> hello() {
        return Result.success("hello");
       // return new Result(0, "success", "hello");
    }
```
给Result添加静态方法和对应的构造函数
```java
public static <T> Result<T> success(T data){
    return new Result<T> (data)
}
private Result(T data){
    this.code = 200;
    this.message = "success";
    this.data = data;
}
```
封装错误信息类，用于生成各种各样的错误信息（枚举类？）
```java
return Result.error(CodeMsg.SERVER_ERROR);
```

### 2.配置文件配置项
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#common-application-properties
aplication.properties
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
hello.html
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

```
mybatis.type-aliases-package=package.model
#下划线转驼峰
mybatis.configuration.map-underscore-to-camel-case=true
mybatis.configuration.default-fetch-size=100
mybatis.configuration.default-statement-timeout=3000
mybatis.mapperLocations = classpath:package/dao/*.xml
```
数据源druid
```xml
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
spring.datasource.url=jdbc:mysql://:3306/datasets?useUnicode=true&characterEncoding=utf-8&allowMultiQueries=true&useSSL=false
spring.datasource.username=
spring.datasource.password=
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
新建domain对象
```java
public class User {
    private int id;
    private String name;
}
```
新建dao层interface UserDao
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
@Autowired
UserService userService;
@RequestMapping("/db/get")
@ResponseBody
public Result<User> dbGet() {
    User user = userService.getById(1);
    return Result.success(user);
}
```
测试事务：数据库中已经有id=1的数据，连插入id=2，id=1的数据，如果能回滚就行
dao:
```java
@Insert("insert into user(id, name)values(#{id}, #{name})")
public int insert(User user);
```
service:
```java
//注解注释掉 报错但插入了id=2
@Transactional
public boolean tx() {
    User u1= new User();
    u1.setId(2);
    u1.setName("2222");
    userDao.insert(u1);
    
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
结果：
Duplicate entry '1' for key 'PRIMARY'
MySQLIntegrityConstraintViolationException:

### 4.搭建redis服务器

```shell
cd /usr/local
tar -zvxf 
yum -y install gcc gcc-c++ libstdc++-devel
make MALLOC=libc
yum install tcl
make test
vi tests/integration/replication-2.tcl 1000->10000
make install
redis-server
vi redis.conf
    bind 127.0.0.1->0.0.0.0所有ip都能访问
    :/dae
    daemonize yes 允许后台执行
redis-server ./redis.conf
#Redis version=4.0.2, bits=64, commit=00000000, modified=0, pid=10217, just started
ps -ef |grep redis
#root     10218     1  0 10:42 ?        00:00:00 redis-server 0.0.0.0:6379
redis-cli
#给redis加密码
vi redis.conf
    :/requirepass
     # requirepass foobared -> requirepass 123456
#重启
redis-cli
    shutdown save
    exit
ps -ef | grep redis
redis-server ./redis.conf
redis-cli
    auth 123456
# 变成系统服务
cd utils
./install_server.sh
# 配置文件位置
    /usr/local/redis-4.0.2/redis.conf
# log位置
    /usr/local/redis-4.0.2/redis.log
# data位置
    /usr/local/redis-4.0.2/data
# 可执行文件路径
chkconfig --list |grep redis
# redis_6379        0:关 1:关 2:开 3:开 4:开 5:开 6:关
systemctl status redis_6379
systemctl stop redis_6379
systemctl start redis_6379
ps -ef |grep redis
# 改服务名
vi /etc/init.d/redis_6379
```

### 5.集成Redis
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
redis.host=192.168.3.109
redis.port=6379
redis.timeout=3
redis.password=123456
redis.poolMaxTotal=10
redis.poolMaxIdle=10
```
新建redis包
配置类
```java
@Component
//配置里的前缀
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
通过service提供Redis的get/set
```java
@Service
public class RedisService{
    public<T> T get(String key,Class<T> clazz){
        JedisPoll jp = null;
        Jedis jedis = jp.getResource();

    }
    @Bean
    public Jedis
}

```


---

spring中自建exception类要继承RuntimeException
只有RuntimeException才会事务回滚，继承Exception不会。

使用PUT方式body要设置成`x-www-from-urlencoded`

过滤器：登陆、加密、解密、会话检查、图片转换。

spring通知、事务传播行为

maven依赖子类不用版本号

抓包记得开隐身窗口
注意`dp[one++][two++]=dp[one-1][two-1];`的执行顺序 1,1不会等于0,0

## 分页
1. `List.subList(,)`
2. SQL的`limit`或者Oracle`rownum`
`select * from t_student limit 0,10`从0取10条
PostgerSQL：
`select * from t_student limit 10 offset 0`
3. hibernate:
```java
String hql = "from Student";
//创建Query或者Criteria对象
Query q = session.createQuery(hql);
q.setFirstResult(0);
q.setMaxResults(10);
List l = q.list();
```

### 对象
```java
public class Pager<T> implements Serializable{
    //每页显示几条记录
    private int pageSize;
    //当前页
    private int currentPage;
    private int totalPage;
    private int totalRecord;
    private List<T> dataList;
}
```

`InternalResourceViewResolver`bean配置页面的jsp路径和后缀名`JstlView`
处理`?clouseID=123`用
```java
(@RequestParam("courseId") Integer courseId,Model model)
model.addAttribute(course);
```
处理rest风格的`/{courseId}`
```java
@RequestMapping(value="/view2/{courseId}")
(@PathVariable("courseId") Integer courseId,Map<String,Object>model)
model.put("course",course);
```

### 在SpringMVC中使用HttpServletRequest等对象
引入
```xml
<groupId>javax.servlet</groupId>
<artifactId>servlet-api</artifactId>
```
```java
request.getParameter("courseId");
request.setAttribute("course",course);
```

### `@ModelAttribute`模型自动绑定 
```java
//请求重定向
return "redirect:view/"+course.getCourseId();
```

### 文件上传
表单属性`enctype="multipart/from-data`
action页面拦截
```java
//自动转型
(@RequestParam("file") MultipartFile file)
```
common-io中的文件流操作
```java
FileUtils.copyInputStreamToFile(file.getInputStream,new File(""));
```

### Json 添加依赖
```java
@ResponseBody Course getCourseInJson(@PathVariable Integer courseId)
ResponseEntity<Course> getCourseInJson(@PathVariable Integer courseId){
    return new ResponseEntity<Course>(course,HttpStatus.OK);
}
```

### 数据绑定 
1. 基本类型int当参数不能为空，包装类型可以为null
2. 传数组`?name=tom&name=jack&name=lucy`用`String[] name`接收

1. 横向越权
不同用户相同权限的数据，A可以查看B的订单
2. 纵向：变成管理员

### 封装响应对象`status`,`msg`,`T data`

### JSP
1. 指令
`<%@ page属性="" %>`属性 language，import，contentType
include，taglib
2. 脚本元素`<% out.println("") %>`
3. 声明
```java
<%! String s = " ";
int add(int x,int y){return x+y;}%>```
4. 表达式`<% =s %>`不以分号结束

#### JSP声明周期
1. 第一次用户请求.jsp，JSP引擎转为Servelet类（.java)，生成字节码文件，执行jspInit()初始化
2. 解析执行字节码文件的`jspService()`
3. `jspService()`处理客户端请求每个客户端一个线程。Servlet常驻内存。


#### JSP9大内置对象
1. out对象是`JspWriter`类实例。8k缓冲区
2. 表单get提交数据小于2k `action=".jsp"`
3. `request`是`HttpServletRequest`的实例，
接收action的js：
```java
//修改接收的字符集 与表单页面的编码一致
<% request.setCharaterEncoding("utf-8")%>
```
URL传参，但这种方法设置request的字符集无效，
要修改tomcat的server.xml的Connetor标签
```xml 
<a href="接收请求的.jsp?username=a">接收参数并跳转</a>
```
4. `response.sendRedirect(".jsp")`重定向
5. response中的`.getWriter`得到的`PrintWriter`总是先于out对象输出，可以使用`out.flush`强制刷新输出
6. `session`对象是`HttpSession`类的实例。保存在服务器的内存中，保存一个用户访问一个服务器页面切换仍然是同一个用户。
用`<a href=".jsp">`后另一个页面仍能获得相同的session
7. `application`对象是ServletContext类的实例。服务器的启动和关闭。get/setAttribute(,)
8. `page`对象就是页面object
9. `pageContext`对象可以获得所有session，response等对象
10. `Config`对象servlet初始化要用到的参数
11. 

#### 请求重定向 请求转发
重定向`.sendRedirect`：客户端行为`response`对象，两次请求，第一次请求对象不被保存（重定向到的页面无法获得原来的`request`内容。地址栏URL变化。 （登陆失败）
转发：服务器行为。`request.getRequestDispatcher().forward(req,resp)`一次请求，转发后请求对象被保存（把request也转发，再把response传回原jsp），URL地址不变。（登陆成功）
登陆成功
```java
session.setAttribute("loginUser",username);
request.getRequestDispatcher("success.jsp").forward(request,response);
```
在success.jsp获取
```java
<%=session.getAttribute("loginUser");
```

#### jsp动作标签和javaBean
```xml
<jsp:useBean id="u" class="U" scope="page"/>
<jsp:setProperty name="u" property="*">
    根据表单name自动和javabean的类自动匹配
传统的表达式方式：<%= u.getUsername()%> 
<jsp:getProperty name="u" property="username">
```
还可以用property+value设置值，可以通过param获得url传的参数

##### bean的四个作用域：page，request，session，application
 
#### 动作include、forward
`<jsp:forward page="url"/>`等同于request.getRequestDispatcher("/url").forward(request,response);


### mina
#### 创建连接
```java
//服务端
SocketAcceptor acceptor = new NioSocketAcceptor();
//客户端
NioSocketConnector connector = new NioSocketConnector();
```

#### 设定过滤规则
```java
DefaultIoFilterChainBuilder chain = acceptor.getFilterChain();
chain.addLast("obj",new ProtocolCodecFilter(new ObjectSerializationCodecFactory()));
//设置消息处理器 服务端
acceptor.setHandler(new minaHandler());
//服务器
acceptor.bind(new InetSocketAddress(port));
//客户端连接服务器
ConnectFuture cf = connector.connect(new InetSocketAddress("localhost",9999));
//客户端等待连接成功
cf.awaitUninterruptibly();
//客户端 发送
cf.getSession().write(msg);
```

#### 消息处理器
`extends IoHandlerAdapter`
重写session接收的方法

### Spring配置文件
读取bean declaration 
tx声明式事务配置文件

### struts2
1. 加入jar包：asm 替代反射，字节码操控框架；ognl struts2的标签库；xwork和webwork整合的包
2. <font color="#FF98AA">sturts.xml</font>放入src负责Action映射和Result定义、拦截器；
    1. `<include>`把每个功能的配置放到不同的xml文件里导入
    **动态方法调用：** 解决action太多`<constant name="struts.enable.DynamicMethodInvocation" value = "true">`
    2. `<action name = "addAction" method="add" class="">`遇到add.action时调用指定类中的add 方法
    3. 通过!add.action访问`<action><result name="add">/result.jsp</result>`对应action的方法中`return "add"`对应result的name字符串
    4. 通配符`name = "{2}_*" method={1} class="..{1}Action"`访问`helloworld_add.action`可以匹配add和helloword
    **默认错误路径**
    5. `<default-action-ref name="index>`并配置名为index的action
    6. 参数：`<contant name="struts.action.extension value="">`不用输入.action后缀
3. struts.properties 全局属性文件；可以不用，在struts.xml用constant元素
3. 在web.xml配置核心过滤器 core包下的;`/*`.jsp和.html不拦截
```xml
<filter>
    <filter-name>Struts2Filter</filter-name>
    <filter-class>...dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>Struts2Filter</filter-name>
    <url-pattern>\*</url-pattern>
</filter-mapping>
```

### Struts原理
![struts2](/images/struts2.jpg)
{% note class_name %} 
1. `HttpServltRequest`经过`ActionContextCleanUp`、各种`Filter` .action的请求会到ActionMapper返回Filter
2. Filter发给`ActionProxy` 并读取struts的配置文件，找到具体的action类，通过`ActionProxy`代理创建Action实例
3. 经过拦截器执行到action返回result是字符串对象对应视图（JSP/FreeMaker）
4. 继续经过拦截器 通过`HttpServletResponse`返回到用户实例进行显示 
{% endnote %}

- Action搜索顺序: 顺着不存在的包名向上查，包名存在则查找action
- 动态方法调用：

### URL读取html
```java
import java.net.*;
import java.io.*;
public class URLReader{
	public static void main(String[] args) throws Exception{
		URL cs = new URL("http://www.sina.com");
        //直接获得inputStream
		BufferedReader in = new BufferedReader(
            new InputStreamReader(cs.openStream()));
		String inputLine;
		while((inputLine = in.readLine())!= null)
			sout(inputLine);
		in.close();
	}
}
```
- 意外处理
try{}catch(MalformedURLexception e) 不符合URL常规的url异常
-
```java
URL url = new URL("https://baidu.com");
HttpURLConnection conn = (HttpURLConnection)url.openConnection();
BufferedInputStream in = new BufferedInputStream(conn.getInputStream());
```


### tomcat
![tomcat](/images/tomcat.jpg)
- server.xml
```xml
<server>
    <service>
        <Connector>
        </Connector>
        <Engine>
            <host> 可以有多个host虚拟主机
                <Context>
                    web应用
                </Context>
            </host>
        </Engine>

</server>

```
- Connector 接收用户请求，Coyote实现(BIO)阻塞式IO
    adddress只监听的地址
    acceptCount 没有空闲线程时的排队长度默认100
    maxConnections 线程池的最大值 -1 不限制
    - 线程池：事先创建一定数目的线程，减少了线程创建与销毁的过程
   ```xml
   <Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
        maxThreads="150" minSpareThreads="4"/>```
- Engine 处理Connector接收到的用户请求

### maven
**pom 项目对象模型**
- `<properties>`中配置的常量属性可以用${property}取
- 子pom和父pom可以继承覆盖
- Super POM中有默认设置
- user/.m2/repository本地缓存的仓库
- [中央仓库](https://search.maven.org/)
**生命周期**
clean:清理项目pre-clean clean post-clean
- default: 构建项目 validate，process-resources
运行package会自动运行compile、test
site:生成站点文档
`<scope>provided</scope>`只在编译和测试时运行
1. 依赖范围：`<scope>`6种
    1. compile：默认。编译测试运行都有效。
    1. provided在编译和测试时有效，运行无效。例如servlet-api因为web容器已经有api了
    2. runtime：运行、测试有效。例如jdbc驱动api
    3. test:测试时有效。例如junit
    4. system：编译和测试有效，不可移植，与系统相关联。例如引入本地的JAVA_HOME
    5. import:只用在dependencyManagement中，表示从其它pom中继承的依赖。


#### 命令
mvn complie编译 test测试 package打包 
    clean删除target
    install安装jar包到本地仓库
#### archetype插件 建立符合规定的目录骨架
`mvn archetype:generate`

### git
![git](/images/git.jpg)
`git push -u origin master`

### Servelet:运行在server端的java程序
- 1.java类 没有main方法 2.运行于容器 提供请求-响应的web服务
1. **servlet处理流程**
    1. pom.xml:tomcat:
    ```xml
    <configuration>
        <path>/web_project_template</path>
    </configuration>
    ```
    2. servlet容器的配置文件web.xml找到对应的Servlet,转发到service方法
    ```xml
    <servlet>
        <servlet-name>TestServlet</servlet-name>
        <servlet-class>..TestServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>TestServlet</servlet-name>
        <url-pattern>/hello</url-pattern>
    <servlet-mapping>
    ```
    3. 客户端请求http对象的时候service方法被调用
    4. 客户端使用get方法访问时doGet方法被调用
    TestServlet.java
    ```java
    @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws ServletException, IOException {
            System.out.println("doGet method");
            PrintWriter pw = resp.getWriter();
            //设置文件类型
            response.setContentType("text/html;charset=utf-8")
            pw.print("/hello");
            pw.close();
        }
    ```
2. Servlet 生命周期
**生命周期方法由服务器调用**
    1. 默认web客户端第一次请求容器，创建servlet实例 调用init(ServletConfig)
    2. 请求处理 转发请求
    3. destory
> get通过header传输数据，post通过body传输

3. ServletConfig：以servlet为单位
    ```xml
    <servlet>
        <init-param>
            <param-name>data1</param-name>
            <param-value>value1</param-value>
        </init-param>
        <init-param>
            <param-name>data2</param-name>
            <param-value>value2</param-value>
        </init-param>
        <servlet-name></servlet-name>
        <servlet-class></servlet-class>
    </servlet>
        ```
    ```java
        ServletConfig config = this.getServletConfig();
        String v1 = config.getInitParameter("data1");
    ```
3. context-param ：全局配置
    + ServletContext对象 web应用中全局唯一
    ```xml
    <context-param>
        <param-name>globalData1</param-name>
        <param-value>123</param-value>
    </context-param>
    ```
    ```java
    ServletContext ctx = this.getServletContext();
    String v1 = ctx.getInitParameter("data1");
    ```
4. servletContext 可以CLUD共享不是事先知道的动态信息
    ```java
    //在context中设置属性
    ctx.setAttribute("attribute1", "111");
    ```
    读取外部资源配置文件信息：
    `ServletContext.getResource` :URL
    `.getResourceAsStream` 
    `.getRealPath`:File
    ??? `Properties` 对象
    + web.xml 部署描述符
    为一个servlet配置多个url-pattern、`/*`模糊匹配
    ```xml
    <servlet-mapping>
            <servlet-name></servlet-name>
            <url-pattern>/hello/*</url-pattern>
    </servlet-mapping>
    ```
    匹配优先级规则

### 监听器
1. 用途：
    1. 统计在线人数和在线用户 HttpSession
    2. 系统启动时加载初始化信息 缓存、数据库链接ServletContext
    3. 统计网站访问量
    4. spring相关
2. 用法：
    1. `impletemts ServletContextListener`
    2. 在web.xml注册
    ```xml
    <listener><listener-class></listener-class></listener>
    ```
    上下文对象，web启动时创建，web销毁 销毁
3. 监听器的启动循序按注册顺序。
    优先级：监听器>过滤器>servlet加载
4. 监听器种类
    1. `ServletContext`监听应用程序环境对象
    2. `HttpSession`用户会话对象
    3. `ServletRequest`请求消息对象

### MIME 多用途 互联网 邮件 扩展 类型
    设定某种扩展名的文件用什么应用打开
    ```xml
    <mime-mapping>
        <extension>java</extension> 扩展名映射类型
        <mime-type>text/plain</mime-type>
    </mime-mapping>
    ```

### Session & Cookie
- Cookie 短时间，数据频繁访问 保存在客户端
    - V0: 
        - Set-Cookie: userName= "";
        - Domain= ""
    - V1:
        - Max-Age= 1000
    - 实际：
        - Version= "1"
- Session NANE为JSESIONID的 Cookie 保存在服务端

#### Cookie
1. 会话cookie 关闭浏览器消失，保存在内存中
2. setMaxAge 设置cookie有效期，浏览器会把cookie保存到硬盘上
3. 一个站点最多能保存20个cookie，每个4k以内
cookie
```java
/***第一次请求把cookie设置好**/
Cookie userNameCookie = new Cookie("userName", userName);
Cookie pwdCookie = new Cookie("pwd", userPassword);
/***设置时间**/
userNameCookie.setMaxAge(10 * 60);
pwdCookie.setMaxAge(10 * 60);
/***把cookie放到响应中**/
response.addCookie(userNameCookie);
response.addCookie(pwdCookie);
/***第二次从请求中获取cookies数组**/
Cookie[] cookies = request.getCookies();
//第二次
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if (cookie.getName().equals("userName")) {
            userName = cookie.getValue();
        }
        if (cookie.getName().equals("pwd")) {
            userPassword = cookie.getValue();
        }
    }
}
```

#### Session
1. 默认有效期30分钟 `setMaxInactiveInterval`设置有效期
2. 部署描述符设置有效期
3. `invalidate` Session失效
- 第一次请求：服务器创建session对象，把SessionID作为cookie发送给浏览器
```java
//创建Session对象
HttpSession session = request.getSession();
session.setAttribute("userName", userName);

// 第二次请求
String name = (String) session.getAttribute("userName");
if (name != null) {
    //服务器已经保存了session
            System.out.println("second login: " + name);
        }
```
- 第二次 Request:`Cookie: JSESSIONID=B2980D3ABAB39EF6EA09F278F261C2A4;`

##### Session钝化：不不常使用的session对象序列化到文件/数据库
tomcat两种钝化管理器
1. `StandardManger`
    1. tomcat 关闭重启时，web应用重启时（覆盖了web.xml)，钝化到文件。
    钝化到`/work/Catalina/hostname/applicationname/SESSION.ser`重启时加载删除
2. Persistentmanager

#### Servlet3.0
1. `@WebListner`免注册声明为监听器
#### 转发与重定向
1. 转发对象：`RequestDispatcher(".jsp").forward(request,response)`
2. 重定向：是两次请求 获取不到原来的req



tail -f 监视日志输出
- javax.servlet
    - Servlet 所有Servlet必须实现的方法
    - Config Servlet配置信息
    - Context 容器信息
    + GenericServlet底层（实现了5个servlet中的方法）
- javax.servlet.http
    - HttpSession标识并存储客户端信息
    - HttpServletRequest
        - getParameter(String key)获得第一个name和key一样的表单控件的数据
        - getParameterValues同上返回数组
        - getParameterMap 返回kv
        - getParameterNames 返回所有表单控件的name值
    + HttpServlet 扩展GenericServlet
    + Cookie 存储Servlet发送给客户端的信息
- javax.servlet.annotation 注解



##### javaWeb域对象：存、取数据（Map）
- Java Web四大域对象(PageContext、ServletRequest、HttpSession、ServletContext)

