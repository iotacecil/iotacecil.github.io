---
title: About SpringBoot
date: 2018-03-06 07:51:17
tags: [java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---




### MVC ViewResolver View 接口

测试网络
https://httpbin.org/#/

打车app API
https://www.easyapi.com/api/?documentId=8067

## spring
### 自动装配`context.getBean(.class)`获取对象
1. `AnnotationConfigApplicationContext(App.class)`注解形式上下文，用`component`标识bean,`scan`扫描自动执行component的构造函数,`@Autowire`加在有参构造函数上，自动装配参数到当前类，实现类的关联
2. `ClassPathXmlApplicationContext(".xml")`不用注解，用`<bean>`,和`ref`
在maven下resources和java都是源码的根目录，所以在java里面读resources里的文件可以直接.xml
3. 将组件扫描`ComponentScan`与启动类分离 范围是所在包和子包，可以加("")
相当于在xml里配置`<context:component-scan base-package=""/>`

```java
ApplicationContext context = new ApplicationConfigApplicationContext(AppCfg.class);
//AppCfg.java
@Configuration
@ComponentScan
```

### 引入spring test 基于junit自动引入上下文
```java
@RunWith(SpringJunit4ClassRunner.class)
@ContextConfiguration(classes=AppConfig.class)
//不用再创建context，也不用getBean,自动注入直接用
@Autowired
private CDplayer cdplayer;
```

### @Autowired 使用
1. 有参构造函数
2. 成员变量 反射 效率低
3. setCD(CD cd)等setter方法上

#### @Autowired(required=false)
用接口注入成员对象时有两个实现类时，使用`@Primary`或者使用限定符`Qualifier("")`相互对应，或者把限定符写在`@Component("")`里。默认的限定符是类名小写
使用`Resource(name="")` = @Autowired+@Qualifier 是jdk自带的标准




### 配置文件详解
![bean.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/bean.jpg)
[公共配置](http://www.ymq.io/2017/11/01/spring-boot-common-application-properties-example/)

### DispatcherServlet
![webcontext.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/webcontext.jpg)
1. 需要定义一个[servlet-name]-servlet.xml配置文件
	HandlerMapping
	Controllers
	view解析相关的

2. 定义ContextLoaderListerner 并指定配置文件

3. @RequestMapping:
 consumes:处理特定请求类型，'Content-Type'
 `RestAPI` 
 ```java
 @RequestMapping(Path="/users/{userId}")
 public String webMethod(@PathVariable String userId)
 ```
4. 登陆场景表单
```java
public void login(@ModelAttribute User user, Writer writer){	
	}
```
```java
@RequestMapping("/user/login")
@ResponseBody
public String login(@RequestParam("name") String name,@RequestParam("password")String password)throws IOexception{}
```
4. 上传文件
定义bean
```xml
<bean id = "multipartResolver"class="...CommonsMultipartResolver">
```
```java
@RequestMapping(path="/form",method = RequestMethod.POST)
	public String handleForm(@RequestParam("file"), MultipartFile file){
	}
```

### IOC容器：ApplicationContext类
一个ApplicationContext对象就是一个容器。属于spring-context模块
1. 初始化
	1. `WebApplicationContext`:在web应用中初始化 web.xml 
		1.全局参数配置 
	```xml
	<context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value> 
		classpath:application-context.xml </param-value>
	</context-param>
	```
		2.加载上下文环境配置
		```xml
		<listener>
			<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
		</listener>
		```
		3.servlet入口
		```xml
		<servlet>
			<servlet-name>example</servlet-name>
			<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
		</servlet>
		<servlet-mapping>
			<servlet-name>example</servlet-name>
			<url-pattern>/api/*</url-pattern>
		</servlet-mapping>
		```
		4.添加servlet配置文件`example-servlet.xml`
		名称符合spring标准：servletname-servlet
		`<bean <context:component-scan base-package=""/>>`
		5.@Controller @RequestMap(value=) 
			`response.getWriter().write("");`
	2. 在测试.java的psvm中使用`ApplicationContext context = new ClassPathXmlApplicationContext("application-context.xml");`
	3. `ApplicationContext context = new FileSystemXmlApplicationContext(".xml");`
2. Bean定义：`<bean id = "bean类名" class="类">`
3. 获取对象 类名 a = `context.getBean("bean类名",类.class）`
4. Bean作用域：
	1. singleton 默认`<bean scope="singleton">`
	2. prototype 每次引用创建一个实例
	web里仅有
![scope.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/scope.jpg)
5. Bean生命周期回调
	1. 创建`<bean init-method="init>`
	2. 销毁`<bean destory-method="cleanup">`
	3. 容器关闭:转换成支持close的子类
		`((ConfigurableApplicationContext)context).close()`

### 依赖注入
> <font color="#fc6486">面向对象封装数据和方法，对象的依赖关系体现在对数据和方法的依赖上。把依赖注入交给框架or IOC完成，从具体对象手中交出控制（依赖关系）。
> Ioc容器是实现依赖控制反转的载体。在对象生成or初始化时直接将数据注入对象；？？注入对方法的调用的依赖：通过将对象引用注入对象数据域中的方法
> 处理数据的对象和对象之间的相互依赖关系比较稳定。
</font>

1. 强依赖（螺丝刀必须有刀头）：构造函数
2. 可选依赖（可配置 颜色）：Setter方法

定义抽象接口，实现接口，以接口为基础注入
- 实现类有构造函数参数
```xml
<bean>
	<constructor-arg value = "值"></constructor-arg>
	<constructor-arg index="1" vlaue ="">
	<constructor-arg type="java.lang.String" value="">
	<constructor-arg name="color" value="red">
</bean>
```

1. 注入集合`Map<String,String> paras` 每个key,value都是entry
```xml
<constructor-arg>
	<map>
		<entry key = "color" value = "red"></entry>
		<entry key = "size" value = "15"></entry>
	</map>
</constructor-arg>
```
2. 注入List `<list><value>14</value><list>` `<set><value>`
3. 注入Properties对象 `<props><prop key = "color">red</prop>`
	+ 配置文件
	```xml
	<bean id = "header"><constructor-arg name = "color" value = "${color}">
	<bean id = "headerProperties" class = "org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
		<property name = "location" value = "classpath:header.properties"/>
	</bean>
	```
	+ header-property:
		`colr =green`
		`size =16`
	```java
	Header heaer = context.getBean("header",子类.class);
	sout(header.getInfo());
	```
4. bean 依赖
```xml
<bean>
	<constructor-arg>
		<ref bean = "header"/>
	</constructor-arg>
</bean>
```
5. 自动装配
	不用构造函数`<constructor-arg>`
	1. `<bean autowire="byName">`/byType/constructor
	2. 使用setter方法
	```java
	public void setHeader(Header header){
		this.header = header;
	}
	```
	3. 用`context.getBean(,.class)`获取对象
6. 注解
	1. `@Component`定义Bean
	2. `@Value`properties注入Bean
	3. `@Autowired`&`@Resource`自动装配依赖 如果后续会把springIOC去掉用后者(java标准javax.annotation.Resource)
	4. `@PostConstruct`&`PreDestroy`Bean的生命周期回调
7. 使用注解
	1. 添加`<comtext:component-scan base-package=""/>`
	2. @Component("header")和@value("${color}")替换
		```xml
		<bean id = "header">
		<constructor-arg name = "color" value = "${color}">
		```
		也不再需要setter函数
	3. @Autowired 替换 ``<bean autowire="byName">``不需要setter
---

### AOP
完整的aop框架AspectJ
1. Aspect非业务逻辑（日志、安全）
2. Join point业务函数执行
3. Advice：切面在函数实现的功能。Aspect对函数打日志
	5种类型
	1. @Before 函数执行之前
	2. @After returning 正常返回之后
	3. @Around 函数执行前后
	4. @After throwing 抛出异常之后
	5. @After finally 函数返回之后
4. pointcut：匹配AOP目标函数的表达式+名称。哪些业务方法需要AOP
![pointcut.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pointcut.jpg)
execution 匹配函数
within 某个包某个类下面的函数
`*`匹配所有 `save*`表示save开头的所有函数
- 所有public函数
`execution(public**(..))`
- 组合两个表达式`execution(表达式1()&&表达式2()`
![pointcut2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/pointcut2.jpg)

#### Aspectj使用
1. 添加依赖 aspectjweaver.jar
	spring容器<artifactId>spring-context</artifactId>
2. xml添加 xmlns:xml link space 类似于包
	`<beans xmlns:aop = "http://www.springframework.org/schema/aop"`
	`http://www.springframework.org/schema/aop`
	xsd:xml schema defination
	`http://www.springframework.org/schema/aop/spring-aop-2.0.xsd">`
	`<aop:aspectj-autoproxy />`
3. 新建Aspect类，定义类级别的@Aspect 添加`<bean>`配制（两个bean 切面和业务类）
4. 定义Pointcut范围 匹配Caculator下的所有函数
	```java
	@Aspect
	public class LoggingAspect {
		@PointCut("execution(* ..Caculator.*(..)) && args(a, ..)")
		private void arithmetic() {//表达式的名称
		}
	}
	```
5. 定义Advice：添加函数级别@Before(pointcut表达式/pointcut名称)
6. Advice参数 获得上下文信息`JoinPoint jp`
```java
@Before("pointcut()")
public void doLog(JoinPoint jp){
	//获得函数签名、函数参数 都是无类型的Object
	sout(jp.getSignature+","+jp.getArgs())}
```
- @Around需要注入的是`ProceedingJoinPoint pjp`
- 获得函数的返回值
```java
@AfterReturning(pointcut="()",returning = retVal)
public void doLog(Object retVal)
```
- 获得异常 是有类型的不是Exception
```java
@AfterThrowing(pointcut="()",throwing = "ex")
public void doLog(IllegalArgumentException ex){}
}
```
- 获得目标函数第一个参数 &&args(a,..)
```java
@Before("pc() && args(a,..)")
public void doLog(JoinPoint jp,int a){sout(a)}
```

#### Schema-based AOP
`aop:aspect`
---

#### JdbcTemplate
> DAO Data Access Object 数据访问接口由JDBC/Mybatis等ORM框架实现

spring-jdbc:
1. 加载db配置文件
`<context:property-placeholder location="db.properties" />`
	jdbc.driverClassName= com.mysql.jdbc.Driver
	jdbc.url= jdbc:mysql://:3306/example
	jdbc.username=
	jdbc.password=
2. 配置数据源
```xml
<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource"
		destroy-method="close">
		<property name="driverClassName" value="${jdbc.driverClassName}" />
		<property name="url" value="${jdbc.url}" />
		<property name="username" value="${jdbc.username}" />
		<property name="password" value="${jdbc.password}" />
	</bean>
```
3. 创建DAO类@Repository
	@Repository 定义一个Bean 代表DAO的bean,创建JDBC实例
	```java
	public class JdbcTemplateDao {
	private JdbcTemplate jdbcTemplate;
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	}
	```
4. application-context添加Autowired的搜索
```xml
<context:component-scan base-package="com.netease.course" />
```
5. 数据转换成对象`RowMapper`
```java
new RowMapper<User>() {
	public User mapRow(ResultSet rs, int rowNum) throws SQLException {
		User user = new User();
		user.setId(rs.getInt("id"));
		user.setFirstName(rs.getString("first_name"));
		user.setLastName(rs.getString("last_name"));
		return user;
	}
}
```

#### NamedParameterJdbcTemplate
1. JdbcTemplate 通过？传参，很多列的时候不明确
`this.jdbcTemplate.update("insert into user values (2, ?, ?)", "Lei", "Li");`
2. named `where firest_name=:first_name`
`queryForObject(sql,Map<Sting,?>paramMap,RowMapper<T> rowMapper)`
- SqlParameterSource在spring中用MapSqlParameterSource/BeanPropertySqlParameterSource(java对象（bean))

#### 异常处理
SQLException是checked异常：需要捕获
Spring的DataAccessException是unchecked异常
![dsexcept.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/dsexcept.jpg)

#### 事务管理
![transaction.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/transaction.jpg)

### MyBatis


#### AOP 一组类共享相同行为（继承 @Aspect
AspectJ注解式切面

- @Transcational 事务处理 @Cacheable 数据缓存
1. 规则注解@interface
2. 注解拦截类 @Action(name="")
3. 被拦截类 与（2）相同但是没有@Action
4. 切面 @Aspect
	- @PointCut声明切点：("@annotation(注解(1))")
5. @After声明建言
	反射：

#### 电影例子
- IoC控制反转 某一接口的实现控制权，从调用类中移除，由第三方决定
	（导演选角色扮演者（具体实现类），放到电影中）
- DI 依赖注入 让调用类对某一实现类的依赖由第三方来注入。移除调用类对某一实现接口的依赖。
- 构造函数注入（构造函数的参数）:传入扮演者
```python
//电影
 ljm;
 构造函数（ljm){this.ljm = ljm}
//导演
ljm = ldh；//(角色=演员)
电影= 电影（ljm）
wjd.action
```
- **Setter**并不是电影每个场景都要用到LJM->属性注入
```java
//电影
ljm;
set(ljm){this.ljm=ljm;}
//导演
电影.set(ljm)
电影.action
```

- 接口注入 与属性注入没用本质区别
```java
interface{
	void inject(ljm);
}
电影 implements interface{
	inject(ljm){this.ljm = ljm;}
}
导演{
	电影.inject(ljm)
}

```

- 注解 描述类和类之间的依赖关系自动完成类的初始化和依赖注入
```xml
//实例化
<bean id ="ljm" class = "ldh"/> //ljm = new ldh;
//建立依赖
<bean id ="wjd" class = "wjd" p:ljm-ref ="ljm"/>
```
从容器中返回bean实例


## SpringMVC
![mvc_front.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/mvc_front.jpg)
前端调度器把请求分发给业务控制器，把生成的数据分发给视图模板。
- js deguggger
1. watch

#### springboot遇到过的注解
创建API
`@ResponseBody` 标注返回值是json：在response的header中塞入contentType

1. @Controller 修饰class创建http请求 
2. @ResController -> @RequestMapping("/hello")返回json `method=RequestMethod.GET`
3. @Component -> @Value("${application.properties(属性名)}")
- 单元测试：
- 随机数
``` 
${random.value} + ${random.long} + ${random.int(10)} + ${random.int[10,20]}
```
- `--`是对application.properties 中属性的标识
-屏蔽命令行访问属性设置`SpringApplication.setAddCommandLineProperties(false)
-多环境配置文件格式`application-{profile}.properties
-激活spring.profiles.active = dev

4. @RestController -> @RequestMappint(value="users")
等于`@controller`+`ResponseBody` 将java类用Jackason转换为JSON
 	1. RequestMapping("/")
 	2. GetMapping("/get1")
 	3. PostMapping("/postJson")
 		1. @RequestBody 对象
6. `@RequestParam` 接收?后的query参数
7. @ModelAttribute User user 绑定参数
8. `@PathVariable` url路径中的参数 绑定value="/{id}"
```java
@GetMapping("/hotels/{htid}/rooms/{roomId}")
public Room getRoomById(
        @PathVariable String htid,
        @PathVariable Integer roomId
){}
```
9.  map.addAttribute("host","") -> th:text ="${host}"

#### 使用Swagger2
##### mvn依赖写法检索 [mvnrepository](http://mvnrepository.com/search?q=spring+boot)
```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.2.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.2.2</version>
</dependency>
```

10. @Configuration 加载类配置
11. @Bean 标记的方法会在容器启动自动执行，并且创建的对象是单例的

#### 跨域问题
[cors](https://hectorguo.com/zh/cross-origin-solve/)
- 协议、域名、端口不同
- 浏览器对ajax xhr的限制
- jsonp 动态创建script 在script里发出请求（现在不用
	- 只能get
> 原理：后台约定super("callback")=>前台?callback=Jquery 函数名  参数值
```js
$.ajax({
	url: base+"/get1",
	dataType: "jsonp",
	后台约定
	jsonp:"callback2",
	//结果可以被缓存 缓存->无&_
	cache: true,
	//返回的结果保存到result字段
	success: function(json){
		//要求返回js代码。但是普通ajax请求，后台返回了json对象。加切面
		result= json;
	}
	})
```
> 查看返回类型：Network->右键->Response Headers->Content-Type
- ?calLback= json对象->函数调用

- 被调用方，返回允许调用client->另一个http服务器
	1. 在http服务器添加响应头
	2. 在应用服务器上添加
	 跨域请求多了Origin:当前域名
	 - `@Bean FilterRegistrationBean`
	 ```java
	 bean.addUrlPatterns("/*")//所有请求都经过filter
	 bean.setFilter(new CrosFilter())
	 ```
	 - doFilter
	 ```java
	 res.addHeader("Access-Control-Allow-Origin","http::")//,"*"允许所有域
	 res.addHeader("Access-Control-Allow-Methods","GET")//,"*"
	 //filter链
	 chain.doFilter(,)
```
- 简单请求：GET/HEAD/POST；无自定义头；Content-Type 为`"text/plain"``multipart/form-data``application/x-www-form-urlencoded`
- 非简单：put,delete、发送json、带自定义头的ajax；

- 调用方 代理，隐藏跨域http服务器->http服务器


- Spring解决跨域 @CrossOrigin +类or方法上面

- 反向代理： 访问同一个域名的两个URL,去两个不同的服务器

##### J2EE架构
- Apache/Nginx(处理静态请求、负载均衡）判断静态请求（js\css->直接返回给客户端；
	- 动态请求（与用户数据有关的）客户端->http服务器->后台应用服务器(tomcat)


#### IOC控制翻转 通过 DI依赖注入 实现
<artifactId>spring-context</artifactId>
IOC容器创建Bean，将功能类Bean注入到Bean中。
- 配置元数据：xml配置、注解、java配置
Spring容器解析配置元数据 Bean初始化、配置和管理依赖。
- 声明Bean的注解：
	- @Component @Service @Repository @Controller
- 注入Bean
	- @Autowired @Inject @Resource 用在set方法or属性上	

1. 编写功能类 
业务Bean的注解配置@Service，@Component，@Service，@Repository，@Controller 声明是Spring管理的Bean
2. 使用功能类 @Autowired 注入Bean 添加功能
3. 配置类（空的） @Configuration。@ComponentScan 自动扫描@Service，@Component,@Repository,@Controller的类 注册为Bean
4. 运行 AnnotationConfigApplicationContext是Spring容器，参数：配置类(3).class
	使用功能类（2） = 容器.getBean((2).class)
	容器context.close()


##### Java 配置
1. （1）、（2）不适用@Service和@Autowired;(2)+set
2. (3)配置类不使用Scan包扫描 @Bean
- @Bean（1）返回名称为方法名（type:功能类）的Bean
- 法1：@Bean (2).set(1) 注入并直接调用(1)
- 法2：（2）直接传参(1)
```java
@Configuration //1
public class JavaConfig {
	@Bean //2
	public FunctionService functionService(){
		return new FunctionService();
	}
	
	@Bean 
	public UseFunctionService useFunctionService(){
		UseFunctionService useFunctionService = new UseFunctionService();
		useFunctionService.setFunctionService(functionService()); //3
		return useFunctionService;
		
	}
}
```
- 只要容器中有Bean就可以在另一个Bean的方法参数中传入
全局配置使用Java配置（数据库，MVC）
---



