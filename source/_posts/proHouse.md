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

### 1.后台工程

#### spring data和jpa
仓库的基础包，事务，数据源属性前缀,实体类管理工厂
```
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://:3306/xunwu
spring.datasource.username=
spring.datasource.password=

spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=validate

logging.level.org.hibernate.SQL=debug
```

```java
@Configuration
@EnableJpaRepositories(basePackages = "com.houselearn.repository")
@EnableTransactionManagement
public class JPAConfig {
    @Bean
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSource dataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        HibernateJpaVendorAdapter japVendor = new HibernateJpaVendorAdapter();
        japVendor.setGenerateDdl(false);

        LocalContainerEntityManagerFactoryBean entityManagerFactory = new LocalContainerEntityManagerFactoryBean();
        entityManagerFactory.setDataSource(dataSource());
        entityManagerFactory.setJpaVendorAdapter(japVendor);
        entityManagerFactory.setPackagesToScan("com.houselearn.entity");
        return entityManagerFactory;
    }

    @Bean
    public PlatformTransactionManager transactionManager(EntityManagerFactory entityManagerFactory) {
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(entityManagerFactory);
        return transactionManager;
    }
}
```

关掉security 
```xml
security.basic.enabled=false
```

#### 单元测试
添加依赖，添加h2数据库
```xml
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>test</scope>
</dependency>
```

创建数据库实体
要兼容h2所以自增用IDENTITY
```java
@Entity
@Table(name = "user")
public class User implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String password;

    private String email;

    @Column(name = "phone_number")
    private String phoneNumber;

    private int status;

    @Column(name = "create_time")
    private Date createTime;

    @Column(name = "last_login_time")
    private Date lastLoginTime;

    @Column(name = "last_update_time")
    private Date lastUpdateTime;

    private String avatar;
 }
```
创建dao 基础的crud
```java
public interface UserRepository extends CrudRepository<User, Long> {}
```

创建entity测试包，新建测试类
```java
public class UserRepositoryTest extends ApplicationTests{
    @Autowired
    private UserRepository userRepository;

    @Test
    public void testFindOne(){
        User user = userRepository.findOne(1l);
        Assert.assertEquals("name1", user.getName());
    }
}
```

集成h2数据库用于测试，配置分离
```xml
# h2
spring.datasource.driver-class-name=org.h2.Driver
# 内存模式
spring.datasource.url=jdbc:h2:mem:test
```
测试类使用test配置文件
```java
RunWith(SpringRunner.class)
@SpringBootTest
@ActiveProfiles("test")
public class ApplicationTests {
    @Test
    public void contextLoads() {
    }
}
```

创建h2数据库放在test的resources下
加配置
```xml
spring.datasource.schema=classpath:db/schema.sql
spring.datasource.data=classpath:db/data.sql
```

#### 集成模板引擎
禁止thymeleaf缓存,thymeleaf html模式
```xml
# dev
spring.thymeleaf.cache=false
# 通用
spring.thymeleaf.mode=HTML
spring.thymeleaf.suffix=.html
spring.thymeleaf.prefix=classpath:/templates/
```

新建用maven方式启动
Command line：`clean package spring-boot:run -Dmaven.test.skip=true`

devtools 热加载工具
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
</dependency>
```
Settings-Compiler-Build project automatically
shift+ctrl+alt+/ - Registry - automake 打开
mvc更新测试
```java
@RequestMapping(value = "/index",method = RequestMethod.GET)
public String index(Model model){
    model.addAttribute("name","不好");
    return "index";
}
```

```html
<html xmlns="http://www.thymeleaf.org" xmlns:th="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
helloooooooohhhhh
<span th:text="${name}"></span>
</body>
</html>
```

### 2. 架构设计

#### 2.1前后端数据格式
```java
public class ApiResponse {
    private int code;
    private String message;
    private Object data;
    private boolean more;
}
```
定义内部枚举类，设定一些模板code和msg状态
```java
public enum Status {
    SUCCESS(200, "OK"),
    BAD_REQUEST(400, "Bad Request"),
    NOT_FOUND(404, "Not Found"),
    INTERNAL_SERVER_ERROR(500, "Unknown Internal Error"),
    NOT_VALID_PARAM(40005, "Not valid Params"),
    NOT_SUPPORTED_OPERATION(40006, "Operation not supported"),
    NOT_LOGIN(50000, "Not Login");

    private int code;
    private String standardMessage;

    Status(int code, String standardMessage) {
        this.code = code;
        this.standardMessage = standardMessage;
    }
}
```

添加静态工厂，直接传入对象包装成success\没有data只有code和msg\枚举类->接口类
```java
public static ApiResponse ofMessage(int code, String message) {
    return new ApiResponse(code, message, null);
}

public static ApiResponse ofSuccess(Object data) {
    return new ApiResponse(Status.SUCCESS.getCode(), Status.SUCCESS.getStandardMessage(), data);
}

public static ApiResponse ofStatus(Status status) {
    return new ApiResponse(status.getCode(), status.getStandardMessage(), null);
}
```

#### 2.2 异常拦截器（页面/api）
关闭whitelabel error页面
新建 base - AppErrorController 
继承ErrorController 注入ErrorAttributes
```java
@Controller
public class AppErrorController implements ErrorController {
    private static final String ERROR_PATH = "/error";

    private ErrorAttributes errorAttributes;

    @Override
    public String getErrorPath() {
        return ERROR_PATH;
    }

    @Autowired
    public AppErrorController(ErrorAttributes errorAttributes) {
        this.errorAttributes = errorAttributes;
    }
}
```
页面处理，在template里添加404，500页面
```java
@RequestMapping(value = ERROR_PATH, produces = "text/html")
public String errorPageHandler(HttpServletRequest request, HttpServletResponse response) {
    int status = response.getStatus();
    switch (status) {
        case 403:
            return "403";
        case 404:
            return "404";
        case 500:
            return "500";
    }
    return "index";
}
```
RequestMapping中的consumes和produce区别
Http协议中的ContentType 和Accept
Accept：告诉服务器，客户端支持的格式
content-type：说明报文中对象的媒体类型
consumes 用于限制 ContentType 
produces 用于限制 Accept

处理api错误
包装request成Attributes 获取错误信息，

状态码要从request中获取
```java
private int getStatus(HttpServletRequest request) {
    Integer status = (Integer) request.getAttribute("javax.servlet.error.status_code");
    if (status != null) {
        return status;
    }
    return 500;
}
```
包装错误对象
```java
RequestMapping(value = ERROR_PATH)
@ResponseBody
public ApiResponse errorApiHandler(HttpServletRequest request) {
    RequestAttributes requestAttributes = new ServletRequestAttributes(request);

    Map<String, Object> attr = this.errorAttributes.getErrorAttributes(requestAttributes, false);
    int status = getStatus(request);

    return ApiResponse.ofMessage(status, String.valueOf(attr.getOrDefault("message", "error")));
}
```

### 3. 管理员页面 文件上传
管理员页面1.登陆 2.欢迎 3.管理员中心 4.添加房子

前端
thymeleaf 公共头部templates/admin/common.html
在common里定义
`<header th:fragment="header" class="navbar-wrapper">`头部样式
在要使用的页面使用那个header
` <div th:include="admin/common :: head"></div>`