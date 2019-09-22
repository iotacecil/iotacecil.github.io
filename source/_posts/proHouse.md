---
title: es搜房网
date: 2019-01-07 19:27:02
tags: [项目流程]
category: [项目流程]
---
查看suggest的ql
```json
http://127.0.0.1:9200/shoufang/_search
{
  "_source" : {
    "includes" : [
      "suggest"
    ],
    "excludes" : [ ]
  }
}

```

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

堆大小检查：JVM堆大小调整可能会出现停顿，应把Xms和Xmx设成相同
文件描述符： 每个分片有很多段，每个段有很多文件。
`ulimit -n 65536` 只对当前终端生效
`/etc/security/limits.conf` 配置`* - nofile 65536`
最大线程数nproc
最大虚拟内存：使用mmap映射部分索引到进程地址空间，保证es进程有足够的地址空间as为unlimited
最大文件大小 fsize 设置为unlimited
！！虚拟内存区域最大数：
确保内核允许创建262144个【内存映射区】
`sysctl -w vm.max_map_count=262144` 临时，重启后失效
`/etc/sysctl.conf`添加`vm.max_map_count=262144` 然后执行`sysctl -p`立即 永久生效

initial heap size [536870912] not equal to maximum heap size [994050048];
修改config/jvm.options 修改xms和xmx相等

#### ES 安装问题
不能用root启动 max_map太小
```sh
chown -R es:es elasticsearch...
su 
sysctl -w vm.max_map_count=262144
```

es经常卡住，而且新增房源要加到百度云麻点之类的功能

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

### 3. 管理员页面 文件上传 本地+腾讯云
管理员页面1.登陆 2.欢迎 3.管理员中心 4.添加房子

#### security
WebMvcConfig 在thymeleaf 添加 SpringSecurity方言
配置页面解析器并且注册ModelMapper
```java
@Configuration
public class WebMvcConfig extends WebMvcConfigurerAdapter implements ApplicationContextAware {
    @Value("${spring.thymeleaf.cache}")
    private boolean thymeleafCacheEnable = true;

    private ApplicationContext applicationContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    /**
     * 静态资源加载配置
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**").addResourceLocations("classpath:/static/");
    }

    /**
     * 模板资源解析器
     * @return
     */
    @Bean
    @ConfigurationProperties(prefix = "spring.thymeleaf")
    public SpringResourceTemplateResolver templateResolver() {
        SpringResourceTemplateResolver templateResolver = new SpringResourceTemplateResolver();
        templateResolver.setApplicationContext(this.applicationContext);
        templateResolver.setCharacterEncoding("UTF-8");
        templateResolver.setCacheable(thymeleafCacheEnable);
        return templateResolver;
    }

    /**
     * Thymeleaf标准方言解释器
     */
    @Bean
    public SpringTemplateEngine templateEngine() {
        SpringTemplateEngine templateEngine = new SpringTemplateEngine();
        templateEngine.setTemplateResolver(templateResolver());
        // 支持Spring EL表达式
        templateEngine.setEnableSpringELCompiler(true);

        // 支持SpringSecurity方言
        SpringSecurityDialect securityDialect = new SpringSecurityDialect();
        templateEngine.addDialect(securityDialect);
        return templateEngine;
    }

    /**
     * 视图解析器
     */
    @Bean
    public ThymeleafViewResolver viewResolver() {
        ThymeleafViewResolver viewResolver = new ThymeleafViewResolver();
        viewResolver.setTemplateEngine(templateEngine());
        return viewResolver;
    }

     @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }
    }
```


权限配置类
```java
@EnableWebSecurity
@EnableGlobalMethodSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    /**
     * HTTP权限控制
     * @param http
     * @throws Exception
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.addFilterBefore(authFilter(), UsernamePasswordAuthenticationFilter.class);

        // 资源访问权限
        http.authorizeRequests()
                .antMatchers("/admin/login").permitAll() // 管理员登录入口
                .antMatchers("/static/**").permitAll() // 静态资源
                .antMatchers("/user/login").permitAll() // 用户登录入口
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers("/user/**").hasAnyRole("ADMIN", "USER")
                .antMatchers("/api/user/**").hasAnyRole("ADMIN",
                "USER")
                .and()
                .formLogin()
                .loginProcessingUrl("/login") // 配置角色登录处理入口
                .failureHandler(authFailHandler())
                .and()
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/logout/page")
                // 登出擦除密码
                .deleteCookies("JSESSIONID")
                .invalidateHttpSession(true)
                .and()
                .exceptionHandling()
                .authenticationEntryPoint(urlEntryPoint())
                .accessDeniedPage("/403");
        //ifarme开发需要同源策略
        http.csrf().disable();
        http.headers().frameOptions().sameOrigin();
    }

    /**
     * 自定义认证策略
     */
    @Autowired
    public void configGlobal(AuthenticationManagerBuilder auth) throws Exception {
        //添加默认用户名密码
        auth.inMemoryAuthentication().withUser("admin").password("admin").roles("ADMIN").and();
    }
}
```
对接数据库做真实的权限认证,获取用户名，从数据库查找密码比对输入的密码`authentication.getCredentials()`
```java
public class AuthProvider implements AuthenticationProvider {
@Autowired
private IUserService userService;

private final Md5PasswordEncoder passwordEncoder = new Md5PasswordEncoder();

@Override
public Authentication authenticate(Authentication authentication) throws AuthenticationException {
    String userName = authentication.getName();
    String inputPassword = (String) authentication.getCredentials();

    User user = userService.findUserByName(userName);
    if (user == null) {
        throw new AuthenticationCredentialsNotFoundException("authError");
    }

    if (this.passwordEncoder.isPasswordValid(user.getPassword(), inputPassword, user.getId())) {
        return new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());

    }

    throw new BadCredentialsException("authError");

}

@Override
public boolean supports(Class<?> authentication) {
    return true;
}
```
用户实体 实现security的方法...
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
    // 注意不在数据库中的属性，不持久化，避免jpa检查
    @Transient
    private List<GrantedAuthority> authorityList;

    public List<GrantedAuthority> getAuthorityList() {
        return authorityList;
    }

    public void setAuthorityList(List<GrantedAuthority> authorityList) {
        this.authorityList = authorityList;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return this.authorityList;
    }

    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return name;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
```
用户service
```java
public interface IUserService {
    User findUserByName(String userName);
```
用户dao
```java
public interface UserRepository extends CrudRepository<User, Long> {
    User findByName(String userName);
```
添加role信息
```java
@Entity
@Table(name = "role")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id")
    private Long userId;
    private String name;
```
role查询 组装到userservice
```java
public interface RoleRepository extends CrudRepository<Role, Long> {
    List<Role> findRolesByUserId(Long userId);
}
```
userservice 通过名字查用户id，通过id查用户权限，并设置好完整的user返回
```java
 @Autowired
private RoleRepository roleRepository;
@Override
public User findUserByName(String userName) {
    User user = userRepository.findByName(userName);

    if (user == null) {
        return null;
    }

    List<Role> roles = roleRepository.findRolesByUserId(user.getId());
    if (roles == null || roles.isEmpty()) {
        throw new DisabledException("权限非法");
    }

    List<GrantedAuthority> authorities = new ArrayList<>();
    roles.forEach(role -> authorities.add(new SimpleGrantedAuthority("ROLE_" + role.getName())));
    user.setAuthorityList(authorities);
    return user;
}
```

security的认证逻辑
```java
@Autowired
    public void configGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(authProvider()).eraseCredentials(true);
    }
    @Bean
    public AuthProvider authProvider() {
        return new AuthProvider();
    }
```

添加用户登出接口HomeController 设置默认页面的页面跳转
```java
@Controller
public class HomeController {
    @GetMapping(value = {"/", "/index"})
    public String index(Model model) {
        return "index";
    }

    @GetMapping("/404")
    public String notFoundPage() {
        return "404";
    }

    @GetMapping("/403")
    public String accessError() {
        return "403";
    }

    @GetMapping("/500")
    public String internalError() {
        return "500";
    }

    @GetMapping("/logout/page")
    public String logoutPage() {
        return "logout";
    }
```

普通用户的controller
```java
@Controller
public class UserController {
    @Autowired
    private IUserService userService;

    @Autowired
    private IHouseService houseService;

    @GetMapping("/user/login")
    public String loginPage() {
        return "user/login";
    }

    @GetMapping("/user/center")
    public String centerPage() {
        return "user/center";
    }
```

#### 无权限跳转到普通/管理员的登陆入口
```java
public class LoginUrlEntryPoint extends LoginUrlAuthenticationEntryPoint {
    private final Map<String, String> authEntryPointMap;
    private PathMatcher pathMatcher = new AntPathMatcher();
    public LoginUrlEntryPoint(String loginFormUrl) {
        super(loginFormUrl);
        authEntryPointMap = new HashMap<>();

        // 普通用户登录入口映射
        authEntryPointMap.put("/user/**", "/user/login");
        // 管理员登录入口映射
        authEntryPointMap.put("/admin/**", "/admin/login");
    }
}
@Override
protected String determineUrlToUseForThisRequest(HttpServletRequest request, HttpServletResponse response,AuthenticationException exception) {
    String uri = request.getRequestURI().replace(request.getContextPath(), "");

    for (Map.Entry<String, String> authEntry : this.authEntryPointMap.entrySet()) {
        if (this.pathMatcher.match(authEntry.getKey(), uri)) {
            return authEntry.getValue();
        }
    }
    return super.determineUrlToUseForThisRequest(request, response, exception);
}
```

添加config
```java
@Bean
public LoginUrlEntryPoint urlEntryPoint() {
    return new LoginUrlEntryPoint("/user/login");
}
```
添加`.authenticationEntryPoint(urlEntryPoint())`

登陆失败
```java
public class LoginAuthFailHandler extends SimpleUrlAuthenticationFailureHandler {
    private final LoginUrlEntryPoint urlEntryPoint;

    public LoginAuthFailHandler(LoginUrlEntryPoint urlEntryPoint) {
        this.urlEntryPoint = urlEntryPoint;
    }

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException, ServletException {
        String targetUrl =
                this.urlEntryPoint.determineUrlToUseForThisRequest(request, response, exception);

        targetUrl += "?" + exception.getMessage();
        super.setDefaultFailureUrl(targetUrl);
        super.onAuthenticationFailure(request, response, exception);
    }
```

注册
```java
@Bean
public LoginUrlEntryPoint urlEntryPoint() {
    return new LoginUrlEntryPoint("/user/login");
}

@Bean
public LoginAuthFailHandler authFailHandler() {
    return new LoginAuthFailHandler(urlEntryPoint());
}
```

```java
.loginProcessingUrl("/login") // 配置角色登录处理入口
.failureHandler(authFailHandler())
```




前端
thymeleaf 公共头部templates/admin/common.html
在common里定义
`<header th:fragment="header" class="navbar-wrapper">`头部样式
在要使用的页面使用那个header
` <div th:include="admin/common :: head"></div>`

#### 图片上传 腾讯云

添加post接口
```java
@PostMapping(value = "admin/upload/photo",consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
@ResponseBody
public ApiResponse uploadPhoto(@RequestParam("file") MultipartFile file){
    if(file.isEmpty()){
        return ApiResponse.ofStatus(ApiResponse.Status.NOT_VALID_PARAM);
    }
    String fileName = file.getOriginalFilename();
    File target = new File("E:\\houselearn\\tmp\\"+fileName);
    try {
        file.transferTo(target);
        PutObjectResult result = tecentService.uploadFile(target);
        String s = gson.toJson(result);
        System.out.println(s);
        System.out.println(result);
        TecentDTO ret = gson.fromJson(s, TecentDTO.class);
        return ApiResponse.ofSuccess(ret);
    } catch (IOException e) {
        e.printStackTrace();
        return ApiResponse.ofStatus(ApiResponse.Status.INTERNAL_SERVER_ERROR);
    }
}
```

文件上传配置类
```java
@Configuration
@ConditionalOnClass({Servlet.class, StandardServletMultipartResolver.class, MultipartConfigElement.class})
@ConditionalOnProperty(prefix = "spring.http.multipart", name = "enabled", matchIfMissing = true)
@EnableConfigurationProperties(MultipartProperties.class)
public class WebFileUploadConfig {
    private final MultipartProperties multipartProperties;

    public WebFileUploadConfig(MultipartProperties multipartProperties) {
        this.multipartProperties = multipartProperties;
    }
    /**
     * 上传配置
     */
    @Bean
    @ConditionalOnMissingBean
    public MultipartConfigElement multipartConfigElement() {
        return this.multipartProperties.createMultipartConfig();
    }

    /**
     * 注册解析器
     */
    @Bean(name = DispatcherServlet.MULTIPART_RESOLVER_BEAN_NAME)
    @ConditionalOnMissingBean(MultipartResolver.class)
    public StandardServletMultipartResolver multipartResolver() {
        StandardServletMultipartResolver multipartResolver = new StandardServletMultipartResolver();
        multipartResolver.setResolveLazily(this.multipartProperties.isResolveLazily());
        return multipartResolver;
    }
    @Value("${tcent.secretId}")
    private  String secretId;

    @Value("${tcent.secretKey}")
    private  String secretKey;

    @Value("${tcent.bucket}")
    private  String bucket;

    @Value("${tcent.region}")
    private  String region;

    // 1 初始化用户身份信息（secretId, secretKey）。
    @Bean
    public COSCredentials cred(){
        return new BasicCOSCredentials(secretId, secretKey);
    }
    //2 区域
    @Bean
    public ClientConfig clientConfig(){
      return  new ClientConfig(new Region(region));
    }
    // 上传
    @Bean
    public COSClient cosClient(){
        return new COSClient(cred(), clientConfig());
    }
}
```

文件配置属性
```java
spring.http.multipart.enabled=true
spring.http.multipart.location=E:\\houselearn\\tmp
spring.http.multipart.file-size-threshold=5MB
spring.http.multipart.max-request-size=20MB
```

定义和前端的图片大小dto 用imageIO 获取图片大小

### 4.地区、地铁信息等表单数据库查询
注意地址表中存储区和市信息，用一个字段level区分。
并且有belong_to 字段形成树形结构。
```java
@Entity
@Table(name = "support_address")
public class SupportAddress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 上一级行政单位
    @Column(name = "belong_to")
    private String belongTo;

    @Column(name = "en_name")
    private String enName;

    @Column(name = "cn_name")
    private String cnName;

    private String level;

    @Column(name = "baidu_map_lng")
    private double baiduMapLongitude;

    @Column(name = "baidu_map_lat")
    private double baiduMapLatitude;
```

```java
public enum Level {
    CITY("city"),
    REGION("region");

    private String value;

    Level(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
    public static Level of(String value) {
        for (Level level : Level.values()) {
            if (level.getValue().equals(value)) {
                return level;
            }
        }
        throw new IllegalArgumentException();
    }
}
```

为了分页统一包装成带数量的list类
```java
public class ServiceMultiResult<T> {
    private long total;
    private List<T> result;
```
在address实体中定义枚举类 用于按level查找所有城市
```java
public ServiceMultiResult<SupportAddressDTO> findAllCities() {
        List<SupportAddress> addresses = supportAddressRepository.findAllByLevel(SupportAddress.Level.CITY.getValue());
        // to DTO
```
查询地区需要City
```java
@Override
public ServiceMultiResult<SupportAddressDTO> findAllRegionsByCityName(String cityName) {
// 判空
    List<SupportAddress> regions = supportAddressRepository.findAllByLevelAndBelongTo(SupportAddress.Level.REGION
            .getValue(), cityName);
 //转 DTO
    return new ServiceMultiResult<>(regions.size(), result);
}
```
一旦用户选择好了市，直接发送2个xhr查地铁线和区
地铁也按城市名查询，地铁站用地铁id查
AddressService封装所有地铁、城市的查询。

存储房屋实体到数据库，分别对应
房屋、详情、图片、tag表，将整个表单定义成一个类接受前端表格
定义service中的save方法
在adminController中定义接口，并对前端数据做表单验证，
注入addressService用于验证城市列表、城市的区域列表
调用save方法会返回一个DTO
```java
@PostMapping("admin/add/house")
@ResponseBody
public ApiResponse addHouse(@Valid @ModelAttribute("form-house-add") HouseForm houseForm, BindingResult bindingResult) {
    if (bindingResult.hasErrors()) {
        return new ApiResponse(HttpStatus.BAD_REQUEST.value(), bindingResult.getAllErrors().get(0).getDefaultMessage(), null);
    }

    if (houseForm.getPhotos() == null || houseForm.getCover() == null) {
        return ApiResponse.ofMessage(HttpStatus.BAD_REQUEST.value(), "必须上传图片");
    }
    Map<SupportAddress.Level, SupportAddressDTO> addressMap = addressService.findCityAndRegion(houseForm.getCityEnName(), houseForm.getRegionEnName());
    if (addressMap.keySet().size() != 2) {
        return ApiResponse.ofStatus(ApiResponse.Status.NOT_VALID_PARAM);
    }

    ServiceResult<HouseDTO> result = houseService.save(houseForm);
    if (result.isSuccess()) {
        return ApiResponse.ofSuccess(result.getResult());
    }

    return ApiResponse.ofSuccess(ApiResponse.Status.NOT_VALID_PARAM);
}
```

并定义相应的DTO

将controller、dto、entity、repository放到web目录下并记得修改JPA配置

### 5后台浏览增删功能 
redis保存session
```java
 @GetMapping("admin/house/list")
    public String houseListPage() {
        return "admin/house-list";
    }
```

#### redis session
```
spring.redis.database=0
spring.redis.host=10.1.18.25
spring.redis.password=
spring.redis.port=6379
spring.redis.pool.min-idle=1
spring.redis.timeout=3000

```
添加依赖
```
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```
redis配置
```java
@Configuration
@EnableRedisHttpSession(maxInactiveIntervalInSeconds = 86400)
public class RedisSessionConfig {
    @Bean
    public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory factory) {

        return new StringRedisTemplate(factory);
    }
}
```
Unable to configure Redis to keyspace notifications
忘了写密码

monitor查看效果
 "PEXPIRE" "spring:session:sessions:6ca6dd6b-a63a-4676-b1b0-db95fde689cc" "86700000"
 ？怎么看

#### 多维度排序和分页
后台查询条件表单实体
```java
public class DatatableSearch {
    /**
     * Datatables要求回显字段
     */
    private int draw;

    /**
     * Datatables规定分页字段
     */
    private int start;
    private int length;

    private Integer status;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date createTimeMin;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date createTimeMax;

    private String city;
    private String title;
    private String direction;
    private String orderBy;
```
用Sort实现默认查询排序
pageable实现分页
`ServiceMultiResult<HouseDTO> adminQuery(DatatableSearch searchBody);`
```java
public interface HouseRepository extends PagingAndSortingRepository<House, Long>, JpaSpecificationExecutor<House> {
```

#### 编辑按钮
编辑页面get方法
从数据库从查询到的房屋表格数据放在model中
编辑页面post方法
增加find所有房屋表信息的service、update更新的service

点击图片删除图片的接口、添加、删除tag接口
```java
@DeleteMapping("admin/house/photo")
@ResponseBody
public ApiResponse removeHousePhoto(@RequestParam(value = "id") Long id) {
    ServiceResult result = this.houseService.removePhoto(id);

    if (result.isSuccess()) {
        return ApiResponse.ofStatus(ApiResponse.Status.SUCCESS);
    } else {
        return ApiResponse.ofMessage(HttpStatus.BAD_REQUEST.value(), result.getMessage());
    }
}
```

#### 待审核到发布
修改数据库房屋状态


### 6. 客户页面房源搜索
搜索请求
```java
public class RentSearch {
    private String cityEnName;
    private String regionEnName;
    private String priceBlock;
    private String areaBlock;
    private int room;
    private int direction;
    private String keywords;
    private int rentWay = -1;
    private String orderBy = "lastUpdateTime";
    private String orderDirection = "desc";
```

跳转类如果session里没有city跳转到首页
如果前端传入的数据有城市，放到session中
```java
 @GetMapping("rent/house")
    public String rentHousePage(@ModelAttribute RentSearch rentSearch,
                                Model model, HttpSession session,
                                RedirectAttributes redirectAttributes) {
        if (rentSearch.getCityEnName() == null) {
            String cityEnNameInSession = (String) session.getAttribute("cityEnName");
            if (cityEnNameInSession == null) {
                redirectAttributes.addAttribute("msg", "must_chose_city");
                return "redirect:/index";
            } else {
                rentSearch.setCityEnName(cityEnNameInSession);
            }
        } else {
            session.setAttribute("cityEnName", rentSearch.getCityEnName());
        }

        ServiceResult<SupportAddressDTO> city = addressService.findCity(rentSearch.getCityEnName());
        if (!city.isSuccess()) {
            redirectAttributes.addAttribute("msg", "must_chose_city");
            return "redirect:/index";
        }
        model.addAttribute("currentCity", city.getResult());

        ServiceMultiResult<SupportAddressDTO> addressResult = addressService.findAllRegionsByCityName(rentSearch.getCityEnName());
        if (addressResult.getResult() == null || addressResult.getTotal() < 1) {
            redirectAttributes.addAttribute("msg", "must_chose_city");
            return "redirect:/index";
        }
        model.addAttribute("searchBody", rentSearch);
        model.addAttribute("regions", addressResult.getResult());

        model.addAttribute("priceBlocks", RentValueBlock.PRICE_BLOCK);
        model.addAttribute("areaBlocks", RentValueBlock.AREA_BLOCK);

        model.addAttribute("currentPriceBlock", RentValueBlock.matchPrice(rentSearch.getPriceBlock()));
        model.addAttribute("currentAreaBlock", RentValueBlock.matchArea(rentSearch.getAreaBlock()));

        return "rent-list";
    }
```

房屋排序类
```java
public class HouseSort {
    public static final String DEFAULT_SORT_KEY = "lastUpdateTime";

    public static final String DISTANCE_TO_SUBWAY_KEY = "distanceToSubway";


    private static final Set<String> SORT_KEYS = Sets.newHashSet(
        DEFAULT_SORT_KEY,
            "createTime",
            "price",
            "area",
            DISTANCE_TO_SUBWAY_KEY
    );

    public static Sort generateSort(String key, String directionKey) {
        key = getSortKey(key);

        Sort.Direction direction = Sort.Direction.fromStringOrNull(directionKey);
        if (direction == null) {
            direction = Sort.Direction.DESC;
        }

        return new Sort(direction, key);
    }

    public static String getSortKey(String key) {
        if (!SORT_KEYS.contains(key)) {
            key = DEFAULT_SORT_KEY;
        }

        return key;
    }
}

```

### 7.添加ES构建索引
API地址
https://www.elastic.co/guide/en/elasticsearch/client/java-api/5.5/transport-client.html
添加依赖注册客户端
```java
@Configuration
public class ElasticSearchConfig {
    @Value("${elasticsearch.host}")
    private String esHost;

    @Value("${elasticsearch.port}")
    private int esPort;

    @Value("${elasticsearch.cluster.name}")
    private String esName;

    @Bean
    public TransportClient esClient() throws UnknownHostException {
        Settings settings = Settings.builder()
                .put("cluster.name", this.esName)
                // 自动发现节点
                .put("client.transport.sniff", true)
                .build();

        InetSocketTransportAddress master = new InetSocketTransportAddress(
            InetAddress.getByName(esHost), esPort

        );

        TransportClient client = new PreBuiltTransportClient(settings)
                .addTransportAddress(master);

        return client;
    }
```
配置
```
elasticsearch.cluster.name=elasticsearch
elasticsearch.host=10.1.18.25
elasticsearch.port=9300
```

索引接口
```java
public interface ISearchService {
    /**
     * 索引目标房源
     * @param houseId
     */
    void index(Long houseId);

    /**
     * 移除房源索引
     * @param houseId
     */
    void remove(Long houseId);
```
构建索引index方法：新增房源（上架），从数据库中查找到房源数据，建立索引分3种情况
1单纯创建 2es里有，是update 3es异常，需要先删除再创建

ES基础语法
定义索引名、索引类型（mapper下面那个）
```java
@Service
public class SearchServiceImpl implements ISearchService {
    private static final Logger logger = LoggerFactory.getLogger(ISearchService.class);

    private static final String INDEX_NAME = "shoufhang";

    private static final String INDEX_TYPE = "house";

    private static final String INDEX_TOPIC = "house_build";

```

建立索引结构和对应的索引类，用于对象转成json传给es API，官方推荐jackson的ObjectMapper
添加Logger

index方法创建一个Json文档
```java
private boolean create(HouseIndexTemplate indexTemplate) {
    try {
        IndexResponse response = this.esClient.prepareIndex(INDEX_NAME, INDEX_TYPE)
                .setSource(objectMapper.writeValueAsBytes(indexTemplate), XContentType.JSON).get();

        logger.debug("Create index with house: " + indexTemplate.getHouseId());
        if (response.status() == RestStatus.CREATED) {
            return true;
        } else {
            return false;
        }
    } catch (JsonProcessingException e) {
        logger.error("Error to index house " + indexTemplate.getHouseId(), e);
        return false;
    }
}
```
更新，需要传入一个具体的文档目标
```java
private boolean update(String esId, HouseIndexTemplate indexTemplate) {
    try {
        UpdateResponse response = this.esClient.prepareUpdate(INDEX_NAME, INDEX_TYPE, esId)
                .setDoc(objectMapper.writeValueAsBytes(indexTemplate), XContentType.JSON).get();

        logger.debug("Update index with house: " + indexTemplate.getHouseId());
        if (response.status() == RestStatus.OK) {
            return true;
        } else {
            return false;
        }
    } catch (JsonProcessingException e) {
        logger.error("Error to index house " + indexTemplate.getHouseId(), e);
        return false;
    }
}
```
删除创建，查询再删除，传入多少个查到的数据，比较删除的行数是否一致
```java
private boolean deleteAndCreate(long totalHit, HouseIndexTemplate indexTemplate) {
    DeleteByQueryRequestBuilder builder = DeleteByQueryAction.INSTANCE
            .newRequestBuilder(esClient)
            .filter(QueryBuilders.termQuery(HouseIndexKey.HOUSE_ID, indexTemplate.getHouseId()))
            .source(INDEX_NAME);

    logger.debug("Delete by query for house: " + builder);

    BulkByScrollResponse response = builder.get();
    long deleted = response.getDeleted();
    if (deleted != totalHit) {
        logger.warn("Need delete {}, but {} was deleted!", totalHit, deleted);
        return false;
    } else {
        return create(indexTemplate);
    }
}
```
一条文档还需要tag和detail、地铁城市信息
```java
@Override
public void index(Long houseId) {
    House house = houseRepository.findOne(houseId);
    if (house == null) {
        logger.error("Index house {} dose not exist!", houseId);
        return;
    }

    HouseIndexTemplate indexTemplate = new HouseIndexTemplate();
    modelMapper.map(house, indexTemplate);

    HouseDetail detail = houseDetailRepository.findByHouseId(houseId);
    modelMapper.map(detail, indexTemplate);
    //ES中是字符串只有name 不用数据库格式的id和houseID
    List<HouseTag> tags = tagRepository.findAllByHouseId(houseId);
    if (tags != null && !tags.isEmpty()) {
        List<String> tagStrings = new ArrayList<>();
        tags.forEach(houseTag -> tagStrings.add(houseTag.getName()));
        indexTemplate.setTags(tagStrings);
    }
    // 先查询这个ID有没有数据
    SearchRequestBuilder requestBuilder = this.esClient.prepareSearch(INDEX_NAME).setTypes(INDEX_TYPE)
            .setQuery(QueryBuilders.termQuery(HouseIndexKey.HOUSE_ID, houseId));

    logger.debug(requestBuilder.toString());
    SearchResponse searchResponse = requestBuilder.get();

    boolean success;
    long totalHit = searchResponse.getHits().getTotalHits();
    if (totalHit == 0) {
        success = create(indexTemplate);
    } else if (totalHit == 1) {
        String esId = searchResponse.getHits().getAt(0).getId();
        success = update(esId, indexTemplate);
    } else {
        //同样的数据存了好多个
        success = deleteAndCreate(totalHit, indexTemplate);
    }
    if (success){
        logger.debug("Index success with house " + houseId);
    }
}
```
先写一个单测试一下
报错log4j2
ERROR StatusLogger Log4j2 could not find a logging implementation. Please add log4j-core to the classpath. Using SimpleLogger to log to the console...
之前腾讯云把log4j和sl4j都删掉了
还要添加一个log4j
```xml
<dependency>
<groupId>org.apache.logging.log4j</groupId>
<artifactId>log4j-core</artifactId>
<version>2.7</version>
</dependency>
```

```java
public class SearchServiceTests extends ApplicationTests{
    @Autowired
    private ISearchService searchService;

    @Test
    public void testIndex(){
        Assert.assertTrue(searchService.index(15L));
    }
}
```
修改数据库并再次执行测试可以看到索引页更新了

删除索引（下架or出租了）
```java
@Override
public void remove(Long houseId) {
    DeleteByQueryRequestBuilder builder = DeleteByQueryAction.INSTANCE
            .newRequestBuilder(esClient)
            .filter(QueryBuilders.termQuery(HouseIndexKey.HOUSE_ID, houseId))
            .source(INDEX_NAME);

    logger.debug("Delete by query for house: " + builder);

    BulkByScrollResponse response = builder.get();
    long deleted = response.getDeleted();

        logger.debug("Delete total", deleted);
}
```
单测
```java
@Test
public void testRemove(){
   searchService.remove(15L);
}
```

将索引方法逻辑加入到之前的状态变化方法中
houseService的update方法
```java
if (house.getStatus() == HouseStatus.PASSES.getValue()) {
    searchService.index(house.getId());
}
```
updateStatus方法

```java
// 上架更新索引 其他情况都要删除索引
if (status == HouseStatus.PASSES.getValue()) {
    searchService.index(id);
} else {
    searchService.remove(id);
}

```
测试发布按钮是否添加了索引

#### 异步构建索引
https://kafka.apache.org/quickstart
zookeeper添加listener的IP
kafka
:commit_memory(0x00000000c0000000, 1073741824, 0) failed; error='Cannot allocate memory' (errno=12)
内存不够了

有点问题
```shell
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties
```

Option zookeeper is deprecated, use --bootstrap-server instead.

```shell
zkServer.sh start
zkServer.sh status
[root@localhost kafka_2.12-2.2.0]# jps -l
17889 org.apache.zookeeper.server.quorum.QuorumPeerMain
30578 org.elasticsearch.bootstrap.Elasticsearch
3653 sun.tools.jps.Jps
18799 kafka.Kafka

```
server.properties里设置zookeeper 127.0.0.1可以启动
创建topic要设置副本数和分区数
```shell
# 创建topic
[root@localhost kafka_2.12-2.2.0]# bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
Created topic test.
# topic
[root@localhost kafka_2.12-2.2.0]# bin/kafka-topics.sh --list --bootstrap-server 10.1.18.25:9092
__consumer_offsets
test

# 发送消息
[root@localhost kafka_2.12-2.2.0]# bin/kafka-console-producer.sh --broker-list 10.1.18.25:9092 --topic test
>aaaaa
>aaa
>
# 接收消息
[root@localhost kafka_2.12-2.2.0]# bin/kafka-console-consumer.sh --bootstrap-server 10.1.18.25:9092 --topic test --from-beginning
aaaaa
aaa
# 删除
[root@localhost kafka_2.12-2.2.0]# bin/kafka-topics.sh --delete --bootstrap-server 10.1.18.25:9092 --topic test
#查看是否删除
[root@localhost kafka_2.12-2.2.0]# bin/kafka-topics.sh --bootstrap-server 10.1.18.25:9092 --list
__consumer_offsets

```

为什么要用kafka，es服务可能不可用，上架不希望等待es建立完索引再响应

配置kafka
```
# kafka
spring.kafka.bootstrap-servers=10.1.18.25:9092
spring.kafka.consumer.group-id=0
```

```xml
<dependency>
    <groupId>org.springframework.kafka</groupId>
    <artifactId>spring-kafka</artifactId>
</dependency>
```

SearchService
```java
@Autowired
private KafkaTemplate<String, String> kafkaTemplate;

@KafkaListener(topics = INDEX_TOPIC)
private void handleMessage(String content) {
    try {
        HouseIndexMessage message = objectMapper.readValue(content, HouseIndexMessage.class);

        switch (message.getOperation()) {
            case HouseIndexMessage.INDEX:
                this.createOrUpdateIndex(message);
                break;
            case HouseIndexMessage.REMOVE:
                this.removeIndex(message);
                break;
            default:
                logger.warn("Not support message content " + content);
                break;
        }
    } catch (IOException e) {
        logger.error("Cannot parse json for " + content, e);
    }
}
```

自定义消息结构体,用户创建和删除两个操作
```java
public class HouseIndexMessage {

    public static final String INDEX = "index";
    public static final String REMOVE = "remove";

    public static final int MAX_RETRY = 3;

    private Long houseId;
    private String operation;
    private int retry = 0;
    /**
     * 默认构造器 防止jackson序列化失败
     */
    public HouseIndexMessage() {
    }
}
```

#### es实现客户页面关键词查询
多值查询，先按城市+地区的英文名过滤
ａ标签当作按钮来使用，但又不希望页面刷新。这个时候就用到上面的javascript:void(0)；

ISearchService单测 地点、根据关键词从0取10个查询到的ID
```java
@Test
public void testQuery() {
    RentSearch rentSearch = new RentSearch();
    rentSearch.setCityEnName("bj");
    rentSearch.setStart(0);
    rentSearch.setSize(10);
    rentSearch.setKeywords("国贸");
    ServiceMultiResult<Long> serviceResult = searchService.query(rentSearch);
    Assert.assertTrue(serviceResult.getTotal() > 0);
}
```
查到ID还需要去houseService中mysql查询，有关键字的时候才用ES
参数：es得到的id数量，es得到的id List
```java
@Override
public ServiceMultiResult<HouseDTO> query(RentSearch rentSearch) {
    if (rentSearch.getKeywords() != null && !rentSearch.getKeywords().isEmpty()) {
        ServiceMultiResult<Long> serviceResult = searchService.query(rentSearch);
        if (serviceResult.getTotal() == 0) {
            return new ServiceMultiResult<>(0, new ArrayList<>());
        }

        return new ServiceMultiResult<>(serviceResult.getTotal(), wrapperHouseResult(serviceResult.getResult()));
    }
    return simpleQuery(rentSearch);
}
```
通过ID查mysql （+house+detail+tag)，查询结果需要按es重排序
```java
private List<HouseDTO> wrapperHouseResult(List<Long> houseIds) {
    List<HouseDTO> result = new ArrayList<>();

    Map<Long, HouseDTO> idToHouseMap = new HashMap<>();
    Iterable<House> houses = houseRepository.findAll(houseIds);
    houses.forEach(house -> {
        HouseDTO houseDTO = modelMapper.map(house, HouseDTO.class);
        houseDTO.setCover(this.cdnPrefix + house.getCover());
        idToHouseMap.put(house.getId(), houseDTO);
    });

    wrapperHouseList(houseIds, idToHouseMap);

    // 矫正顺序
    for (Long houseId : houseIds) {
        result.add(idToHouseMap.get(houseId));
    }
    return result;
}
```
simpleQuery 是原来db查询

#### 添加关键词功能
```java
 boolQuery.must(
    QueryBuilders.multiMatchQuery(rentSearch.getKeywords(),
            HouseIndexKey.TITLE,
            HouseIndexKey.TRAFFIC,
            HouseIndexKey.DISTRICT,
            HouseIndexKey.ROUND_SERVICE,
            HouseIndexKey.SUBWAY_LINE_NAME,
            HouseIndexKey.SUBWAY_STATION_NAME
    ));
```
但是还是不准
添加面积 ALL 是空
```java
RentValueBlock area = RentValueBlock.matchArea(rentSearch.getAreaBlock());
    if (!RentValueBlock.ALL.equals(area)) {
        RangeQueryBuilder rangeQueryBuilder = QueryBuilders.rangeQuery(HouseIndexKey.AREA);
        if (area.getMax() > 0) {
            rangeQueryBuilder.lte(area.getMax());
        }
        if (area.getMin() > 0) {
            rangeQueryBuilder.gte(area.getMin());
        }
        boolQuery.filter(rangeQueryBuilder);
    }
```

添加价格
```java
RentValueBlock price = RentValueBlock.matchPrice(rentSearch.getPriceBlock());
    if (!RentValueBlock.ALL.equals(price)) {
        RangeQueryBuilder rangeQuery = QueryBuilders.rangeQuery(HouseIndexKey.PRICE);
        if (price.getMax() > 0) {
            rangeQuery.lte(price.getMax());
        }
        if (price.getMin() > 0) {
            rangeQuery.gte(price.getMin());
        }
        boolQuery.filter(rangeQuery);
    }
```
朝向、租赁方式
```java
if (rentSearch.getDirection() > 0) {
    boolQuery.filter(
            QueryBuilders.termQuery(HouseIndexKey.DIRECTION, rentSearch.getDirection())
    );
}

if (rentSearch.getRentWay() > -1) {
    boolQuery.filter(
        QueryBuilders.termQuery(HouseIndexKey.RENT_WAY, rentSearch.getRentWay())
    );
}
```

分析分词效果
get `http://10.1.18.25:9200/_analyze?analyzer=standard&pretty=true&text=这是一个句子`
等于没分

添加中文分词包
https://github.com/medcl/elasticsearch-analysis-ik

```shell
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.5.2/elasticsearch-analysis-ik-5.5.2.zip
```

删除索引 集群变黄？
```shell
curl -XDELETE 
```

修改索引，标题、desc都用analyzed加分词器
```json
 "title": {
      "type": "text",
      "index": "analyzed",
      "analyzer": "ik_smart",
      "search_analyzer": "ik_smart"
    },
```

对数据库批量做索引

#### 自动补全 ES的Suggesters
接口
```java
 @GetMapping("rent/house/autocomplete")
@ResponseBody
public ApiResponse autocomplete(@RequestParam(value = "prefix") String prefix) {
    if (prefix.isEmpty()) {
        return ApiResponse.ofStatus(ApiResponse.Status.BAD_REQUEST);
    }
    ServiceResult<List<String>> result = this.searchService.suggest(prefix);
    return ApiResponse.ofSuccess(result.getResult());
}
```
新建ES返回的类型，添加到es结构中
```java
public class HouseSuggest {
    private String input;
    private int weight = 10; // 默认权重
```
Template
`private List<HouseSuggest> suggest;`
再修改es的索引结构
```json
"suggest": {
  "type": "completion"
},
```
新增updateSuggest方法，在创建or更新索引的时候调用
```java
private boolean create(HouseIndexTemplate indexTemplate) {
 if(!updateSuggest(indexTemplate)){
     return false;
 }
```
Elasticsearch里设计了4种类别的Suggester，分别是:
Term Suggester
Phrase Suggester
Completion Suggester
Context Suggester

而是将analyze过的数据编码成FST和索引一起存放。对于一个open状态的索引，FST会被ES整个装载到内存里的，进行前缀查找速度极快。但是FST只能用于前缀查找，这也是Completion Suggester的局限所在。

逻辑：获得分词，封装到es请求类中
构建分词请求，输入用于分词的字段，
设置分词器
获取分词

```java
private boolean updateSuggest(HouseIndexTemplate indexTemplate) {
    AnalyzeRequestBuilder requestBuilder = new AnalyzeRequestBuilder(
            this.esClient, AnalyzeAction.INSTANCE, INDEX_NAME, indexTemplate.getTitle(),
            indexTemplate.getLayoutDesc(), indexTemplate.getRoundService(),
            indexTemplate.getDescription(), indexTemplate.getSubwayLineName(),
            indexTemplate.getSubwayStationName());

    requestBuilder.setAnalyzer("ik_smart");

    AnalyzeResponse response = requestBuilder.get();
    List<AnalyzeResponse.AnalyzeToken> tokens = response.getTokens();
    if (tokens == null) {
        logger.warn("Can not analyze token for house: " + indexTemplate.getHouseId());
        return false;
    }

    List<HouseSuggest> suggests = new ArrayList<>();
    for (AnalyzeResponse.AnalyzeToken token : tokens) {
        // 排序数字类型 & 小于2个字符的分词结果
        if ("<NUM>".equals(token.getType()) || token.getTerm().length() < 2) {
            continue;
        }

        HouseSuggest suggest = new HouseSuggest();
        suggest.setInput(token.getTerm());
        suggests.add(suggest);
    }

    // 定制化小区自动补全
    HouseSuggest suggest = new HouseSuggest();
    suggest.setInput(indexTemplate.getDistrict());
    suggests.add(suggest);

    indexTemplate.setSuggest(suggests);
    return true;
}
```

排除数字类型的词（token）
对每个合适的词构建自定义的suggest，并设置权重（默认10）
将suggest数组添加到es返回类中

如果想添加一些不用分词的keyword类型，直接包装成suggest放到suggest数组中

补全逻辑：
调用search语法查询suggest
```java
@Override
public ServiceResult<List<String>> suggest(String prefix) {
    CompletionSuggestionBuilder suggestion = SuggestBuilders.completionSuggestion("suggest").prefix(prefix).size(5);

    SuggestBuilder suggestBuilder = new SuggestBuilder();
    suggestBuilder.addSuggestion("autocomplete", suggestion);

    SearchRequestBuilder requestBuilder = this.esClient.prepareSearch(INDEX_NAME)
            .setTypes(INDEX_TYPE)
            .suggest(suggestBuilder);
    logger.debug(requestBuilder.toString());

    SearchResponse response = requestBuilder.get();
    Suggest suggest = response.getSuggest();
    if (suggest == null) {
        return ServiceResult.of(new ArrayList<>());
    }
    Suggest.Suggestion result = suggest.getSuggestion("autocomplete");

    int maxSuggest = 0;
    
    Set<String> suggestSet = new HashSet<>();
    // 去重...
    List<String> suggests = Lists.newArrayList(suggestSet.toArray(new String[]{}));
    return ServiceResult.of(suggests);
}
```


照理说不应该用house生成用户搜索的关键词，建立索引

#### 用户输入存入自动补全索引表
```json
{
  "mappings": {
    "bar": {
      "properties": {
        "body": {
          "type": "completion",
          "analyzer": "ik_max_word"
        }
      }
    }
  }
}
```

异步添加词、句子



#### 一个小区有多少套房 数据聚合统计
对小区名进行聚集
controller
```java
ServiceResult<Long> aggResult = searchService.aggregateDistrictHouse(city.getEnName(), region.getEnName(), houseDTO.getDistrict());
    model.addAttribute("houseCountInDistrict", aggResult.getResult());
```

聚合语法
```java
@Override
public ServiceResult<Long> aggregateDistrictHouse(String cityEnName, String regionEnName, String district) {

    BoolQueryBuilder boolQuery = QueryBuilders.boolQuery()
            .filter(QueryBuilders.termQuery(HouseIndexKey.CITY_EN_NAME, cityEnName))
            .filter(QueryBuilders.termQuery(HouseIndexKey.REGION_EN_NAME, regionEnName))
            .filter(QueryBuilders.termQuery(HouseIndexKey.DISTRICT, district));

    SearchRequestBuilder requestBuilder = this.esClient.prepareSearch(INDEX_NAME)
            .setTypes(INDEX_TYPE)
            .setQuery(boolQuery)
            .addAggregation(
                    AggregationBuilders.terms(HouseIndexKey.AGG_DISTRICT)
                    .field(HouseIndexKey.DISTRICT)
            ).setSize(0);

    logger.debug(requestBuilder.toString());

    SearchResponse response = requestBuilder.get();
    if (response.status() == RestStatus.OK) {
        Terms terms = response.getAggregations().get(HouseIndexKey.AGG_DISTRICT);
        if (terms.getBuckets() != null && !terms.getBuckets().isEmpty()) {
            return ServiceResult.of(terms.getBucketByKey(district).getDocCount());
        }
    } else {
        logger.warn("Failed to Aggregate for " + HouseIndexKey.AGG_DISTRICT);

    }
    return ServiceResult.of(0L);
}
```

#### es查询调优
`_search?explain=true`
对标题字段改权重
```java
boolQuery.must(
    QueryBuilders.matchQuery(HouseIndexKey.TITLE, rentSearch.getKeywords()).boost(2.0f)
);
```
还可以把must改成should

查询条件返回的是整个es文档，只返回需要的字段
```java
SearchRequestBuilder requestBuilder = this.esClient.prepareSearch(INDEX_NAME)
    .setTypes(INDEX_TYPE)
    .setQuery(boolQuery)
    .addSort(
            HouseSort.getSortKey(rentSearch.getOrderBy()),
            SortOrder.fromString(rentSearch.getOrderDirection())
    )
    .setFrom(rentSearch.getStart())
    .setSize(rentSearch.getSize())
    .setFetchSource(HouseIndexKey.HOUSE_ID, null);

```

### 8.百度地图 按地图找房
创建两个应用，类别：服务端、浏览器端
浏览器端的AK 复制到新建的rent-map页面，引入百度的css和js代码
新建controller，利用session存一些东西
查有多少个区域查数据库就ok，一共有多少房需要es聚合数据
```java
public class HouseBucketDTO {
    private String key;
    private long count;
```

```java
 @Override
public ServiceMultiResult<HouseBucketDTO> mapAggregate(String cityEnName) {
    // 过滤城市
    BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
    boolQuery.filter(QueryBuilders.termQuery(HouseIndexKey.CITY_EN_NAME, cityEnName));
    // 起名、根据enname字段聚合
    AggregationBuilder aggBuilder = AggregationBuilders.terms(HouseIndexKey.AGG_REGION)
            .field(HouseIndexKey.REGION_EN_NAME);
    SearchRequestBuilder requestBuilder = this.esClient.prepareSearch(INDEX_NAME)
            .setTypes(INDEX_TYPE)
            .setQuery(boolQuery)
            .addAggregation(aggBuilder);

    logger.debug(requestBuilder.toString());

    SearchResponse response = requestBuilder.get();
    // 异常处理
    List<HouseBucketDTO> buckets = new ArrayList<>();
    if (response.status() != RestStatus.OK) {
        logger.warn("Aggregate status is not ok for " + requestBuilder);
        return new ServiceMultiResult<>(0, buckets);
    }
    // 根据刚起的名获取数据
    Terms terms = response.getAggregations().get(HouseIndexKey.AGG_REGION);
    for (Terms.Bucket bucket : terms.getBuckets()) {
        buckets.add(new HouseBucketDTO(bucket.getKeyAsString(), bucket.getDocCount()));
    }
    return new ServiceMultiResult<>(response.getHits().getTotalHits(), buckets);
}
```

前端地图拿到数据
```js
// 声明一个区域 设置好id
 <div id="allmap" class="wrapper">
<script type="text/javascript" th:inline="javascript">
    // 初始化加载地图数据
    var city = [[${city}]],
        regions = [[${regions}]],
        aggData = [[${aggData}]];
    console.log(regions)
    load(city, regions, aggData);
</script>
```
画地图
```js
function load(city, regions, aggData) {
    // 百度地图API功能
    // 创建实例。设置地图显示最大级别为城市(不能缩放成世界）
    var map = new BMap.Map("allmap", {minZoom: 12});
    // 坐标拾取获取中心点 http://api.map.baidu.com/lbsapi/getpoint/index.html
    var point = new BMap.Point(city.baiduMapLongitude, city.baiduMapLatitude);
    // 初始化地图，设置中心点坐标及地图级别
    map.centerAndZoom(point, 12);
    // 添加比例尺控件
    map.addControl(new BMap.NavigationControl({enableGeolocation: true}));
    // 左上角
    map.addControl(new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}));
    // 开启鼠标滚轮缩放
    map.enableScrollWheelZoom(true);
```
给地图添加标签显示当前区域有多少套，
从百度地图获取城市和区的经纬度，存在support_address表里

文档Label：
http://lbsyun.baidu.com/cms/jsapi/reference/jsapi_reference.html#a3b9
```
setContent(content: String) none    设置文本标注的内容。支持HTML
setStyle(styles: Object)    none    设置文本标注样式，该样式将作用于文本标注的容器元素上。其中styles为JavaScript对象常量，比如： setStyle({ color : "red", fontSize : "12px" }) 注意：如果css的属性名中包含连字符，需要将连字符去掉并将其后的字母进行大写处理，例如：背景色属性要写成：backgroundColor
```

`drawRegion(map, regions);`
```java
// 全局区域几套房数据
var regionCountMap = {}
function drawRegion(map, regionList) {
    var boundary = new BMap.Boundary();
    var polygonContext = {};
    var regionPoint;
    var textLabel;
    for (var i = 0; i < regionList.length; i++) {

        regionPoint = new BMap.Point(regionList[i].baiduMapLongitude, regionList[i].baiduMapLatitude);
        // 从后端获取到的数据先保存成全局的了
        var houseCount = 0;
        if (regionList[i].en_name in regionCountMap) {
            houseCount = regionCountMap[regionList[i].en_name];
        }
        // 标签内容
        var textContent = '<p style="margin-top: 20px; pointer-events: none">' + regionList[i].cn_name + '</p>' + '<p style="pointer-events: none">' +   houseCount + '套</p>';
        
        textLabel = new BMap.Label(textContent, {
            // 标签位置
            position: regionPoint,
            // 文本偏移量
            offset: new BMap.Size(-40, 20)
        });
        // 添加style 变成原型
        textLabel.setStyle({
            height: '78px',
            width: '78px',
            color: '#fff',
            backgroundColor: '#0054a5',
            border: '0px solid rgb(255, 0, 0)',
            borderRadius: "50%",
            fontWeight: 'bold',
            display: 'inline',
            lineHeight: 'normal',
            textAlign: 'center',
            opacity: '0.8',
            zIndex: 2,
            overflow: 'hidden'
        });
        // 将标签画在地图上
        map.addOverlay(textLabel);
```
pointer-events: none
上面元素盖住下面地图，地图无法操作。

但是这个Label一放大就没了

添加区域覆盖 Polygon API
```js
// 记录行政区域覆盖物
// 点集合
polygonContext[textContent] = [];
// 闭包传参
(function (textContent) {
    // 获取行政区域
    boundary.get(city.cn_name + regionList[i].cn_name, function(rs) {
        // 行政区域边界点集合长度
        var count = rs.boundaries.length;
        console.log(rs.boundaries)
        if (count === 0) {
            alert('未能获取当前输入行政区域')
            return;
        }

        for (var j = 0; j < count; j++) {
            // 建立多边形覆盖物
            var polygon = new BMap.Polygon(
                rs.boundaries[j],
                {
                    strokeWeight: 2,
                    strokeColor:'#0054a5',
                    fillOpacity: 0.3,
                    fillColor: '#0054a5'
                }
            );
            // 添加覆盖物
            map.addOverlay(polygon);
            polygonContext[textContent].push(polygon);
            // 初始化隐藏边界
            polygon.hide(); 
        }
    })
})(textContent);
// 添加鼠标事件
textLabel.addEventListener('mouseover', function (event) {
    var label = event.target;
    console.log(event)
    var boundaries = polygonContext[label.getContent()];

    label.setStyle({backgroundColor: '#1AA591'});
    for (var n = 0; n < boundaries.length; n++) {
        boundaries[n].show();
    }
});

textLabel.addEventListener('mouseout', function (event) {
    var label = event.target;
    var boundaries = polygonContext[label.getContent()];

    label.setStyle({backgroundColor: '#0054a5'});
    for (var n = 0; n < boundaries.length; n++) {
        boundaries[n].hide();
    }
});

textLabel.addEventListener('click', function (event) {
    var label = event.target;
    var map = label.getMap();
    map.zoomIn();
    map.panTo(event.point);
});
}
```

给es添加位置索引 es基于gps系统 百度地图是
```json
"location": {
      "type": "geo_point"
    }
```

新建地理位置类
```java
public class BaiduMapLocation {
    @JsonProperty("lon")
    private double longitude;
    @JsonProperty("lat")
    private double latitude;
```
在es显示对应类添加
`private BaiduMapLocation location;`

在addressService里添加根据城市和地址 根据百度地图API找经纬度
在新建索引时调用（template是用于保存mysql中查询到的数据，保存到es）
```java
SupportAddress city = supportAddressRepository.findByEnNameAndLevel(house.getCityEnName(), SupportAddress.Level.CITY.getValue());
SupportAddress region = supportAddressRepository.findByEnNameAndLevel(house.getRegionEnName(), SupportAddress.Level.REGION.getValue());
String address = city.getCnName() + region.getCnName() + house.getStreet() + house.getDistrict() + detail.getDetailAddress();
ServiceResult<BaiduMapLocation> location = addressService.getBaiduMapLocation(city.getCnName(), address);
if (!location.isSuccess()) {
    this.index(message.getHouseId(), message.getRetry() + 1);
    return;
}
indexTemplate.setLocation(location.getResult());
```

addressService中的调用百度api
包装成http格式（中文要用utf-8编码），HttpClient 拼接地址
```java
@Override
public ServiceResult<BaiduMapLocation>  getBaiduMapLocation(String city, String address) {
    String encodeAddress;
    String encodeCity;

    try {
        encodeAddress = URLEncoder.encode(address, "UTF-8");
        encodeCity = URLEncoder.encode(city, "UTF-8");
        System.out.println(encodeAddress);
        System.out.println(encodeCity);
    } catch (UnsupportedEncodingException e) {
        logger.error("Error to encode house address", e);
        return new ServiceResult<BaiduMapLocation>(false, "Error to encode hosue address");
    }

    HttpClient httpClient = HttpClients.createDefault();
    StringBuilder sb = new StringBuilder(BAIDU_MAP_GEOCONV_API);
    sb.append("address=").append(encodeAddress).append("&")
            .append("city=").append(encodeCity).append("&")
            .append("output=json&")
            .append("ak=").append(BAIDU_MAP_KEY);
    // 执行
    HttpGet get = new HttpGet(sb.toString());
    try {
        HttpResponse response = httpClient.execute(get);
        if (response.getStatusLine().getStatusCode() != HttpStatus.SC_OK) {
            return new ServiceResult<BaiduMapLocation>(false, "Can not get baidu map location");
        }
        // 拿结果 json
        String result = EntityUtils.toString(response.getEntity(), "UTF-8");
        System.out.println("返回"+result);
        JsonNode jsonNode = objectMapper.readTree(result);
        int status = jsonNode.get("status").asInt();
        if (status != 0) {
            return new ServiceResult<BaiduMapLocation>(false, "Error to get map location for status: " + status);
        } {
            BaiduMapLocation location = new BaiduMapLocation();
            JsonNode jsonLocation = jsonNode.get("result").get("location");
            location.setLongitude(jsonLocation.get("lng").asDouble());
            location.setLatitude(jsonLocation.get("lat").asDouble());
            return ServiceResult.of(location);
        }

    } catch (IOException e) {
        logger.error("Error to fetch baidumap api", e);
        return new ServiceResult<BaiduMapLocation>(false, "Error to fetch baidumap api");
    }
}
```

测试
```java
@Test
public void testGetMapLocation() {
    String city = "北京";
    String address = "北京市昌平区巩华家园1号楼2单元";
    ServiceResult<BaiduMapLocation> serviceResult = addressService.getBaiduMapLocation(city, address);

    Assert.assertTrue(serviceResult.isSuccess());

    Assert.assertTrue(serviceResult.getResult().getLongitude() > 0 );
    Assert.assertTrue(serviceResult.getResult().getLatitude() > 0 );

}
```

地图找房，前端数据传递
```java
public class MapSearch {
    private String cityEnName;

    /**
     * 地图缩放级别
     */
    private int level = 12;
    private String orderBy = "lastUpdateTime";
    private String orderDirection = "desc";
    /**
     * 左上角
     */
    private Double leftLongitude;
    private Double leftLatitude;

    /**
     * 右下角
     */
    private Double rightLongitude;
    private Double rightLatitude;

    private int start = 0;
    private int size = 5;
```

接口
```java
@GetMapping("rent/house/map/houses")
@ResponseBody
public ApiResponse rentMapHouses(@ModelAttribute MapSearch mapSearch) {
    System.out.println("找房参数"+mapSearch);
    if (mapSearch.getCityEnName() == null) {
        return ApiResponse.ofMessage(HttpStatus.BAD_REQUEST.value(), "必须选择城市");
    }
    ServiceMultiResult<HouseDTO> serviceMultiResult;
    if (mapSearch.getLevel() < 13) {
        serviceMultiResult = houseService.wholeMapQuery(mapSearch);
    } else {
        // 小地图查询必须要传递地图边界参数
        serviceMultiResult = houseService.boundMapQuery(mapSearch);
    }

    ApiResponse response = ApiResponse.ofSuccess(serviceMultiResult.getResult());
    response.setMore(serviceMultiResult.getTotal() > (mapSearch.getStart() + mapSearch.getSize()));
    return response;
}
```
es查找的参数城市、排序方式、数量
```java
@Override
public ServiceMultiResult<Long> mapQuery(String cityEnName, String orderBy,
                                         String orderDirection,
                                         int start,
                                         int size) {
    // 限定城市
    BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
    boolQuery.filter(QueryBuilders.termQuery(HouseIndexKey.CITY_EN_NAME, cityEnName));

    // +排序 +分页
    SearchRequestBuilder searchRequestBuilder = this.esClient.prepareSearch(INDEX_NAME)
            .setTypes(INDEX_TYPE)
            .setQuery(boolQuery)
            .addSort(HouseSort.getSortKey(orderBy), SortOrder.fromString(orderDirection))
            .setFrom(start)
            .setSize(size);

    List<Long> houseIds = new ArrayList<>();
    SearchResponse response = searchRequestBuilder.get();
    if (response.status() != RestStatus.OK) {
        logger.warn("Search status is not ok for " + searchRequestBuilder);
        return new ServiceMultiResult<>(0, houseIds);
    }
    // 从sorce获取数据obj->String->Long ->List
    for (SearchHit hit : response.getHits()) {
        houseIds.add(Longs.tryParse(String.valueOf(hit.getSource().get(HouseIndexKey.HOUSE_ID))));
    }
    return new ServiceMultiResult<>(response.getHits().getTotalHits(), houseIds);
}
```

安装kafka manager
sbt
https://github.com/sbt/sbt/releases


geo查询 bound查询
```java
@Override
public ServiceMultiResult<Long> mapQuery(MapSearch mapSearch) {
    BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
    boolQuery.filter(QueryBuilders.termQuery(HouseIndexKey.CITY_EN_NAME, mapSearch.getCityEnName()));

    boolQuery.filter(
        QueryBuilders.geoBoundingBoxQuery("location")
            .setCorners(
                    new GeoPoint(mapSearch.getLeftLatitude(), mapSearch.getLeftLongitude()),
                    new GeoPoint(mapSearch.getRightLatitude(), mapSearch.getRightLongitude())
            ));

    SearchRequestBuilder builder = this.esClient.prepareSearch(INDEX_NAME)
            .setTypes(INDEX_TYPE)
            .setQuery(boolQuery)
            .addSort(HouseSort.getSortKey(mapSearch.getOrderBy()),
                    SortOrder.fromString(mapSearch.getOrderDirection()))
            .setFrom(mapSearch.getStart())
            .setSize(mapSearch.getSize());

    List<Long> houseIds = new ArrayList<>();
    SearchResponse response = builder.get();
    if (RestStatus.OK != response.status()) {
        logger.warn("Search status is not ok for " + builder);
        return new ServiceMultiResult<>(0, houseIds);
    }

    for (SearchHit hit : response.getHits()) {
        houseIds.add(Longs.tryParse(String.valueOf(hit.getSource().get(HouseIndexKey.HOUSE_ID))));
    }
    return new ServiceMultiResult<>(response.getHits().getTotalHits(), houseIds);
}
```

#### 在地图上绘制各个房子的地点（麻点）
lbs服务，将房源信息上传到lbs 创建数据（create poi）接口 post请求
http://lbsyun.baidu.com/index.php?title=lbscloud/api/geodata
用3：百度加密经纬度坐标
示例 前端配置geotableId就可以直接放图层了
http://lbsyun.baidu.com/jsdemo.htm#g0_4

### 9.会员管理 短信登陆
```java
// 新增用户 更新用户表和权限表要加事务
@Override
@Transactional
public User addUserByPhone(String telephone) {
    User user = new User();
    user.setPhoneNumber(telephone);
    user.setName(telephone.substring(0, 3) + "****" + telephone.substring(7, telephone.length()));
    Date now = new Date();
    user.setCreateTime(now);
    user.setLastLoginTime(now);
    user.setLastUpdateTime(now);
    user = userRepository.save(user);

    Role role = new Role();
    role.setName("USER");
    role.setUserId(user.getId());
    roleRepository.save(role);
    user.setAuthorityList(Lists.newArrayList(new SimpleGrantedAuthority("ROLE_USER")));
    return user;
}
```

添加filter
```java
public class AuthFilter extends UsernamePasswordAuthenticationFilter {

    @Autowired
    private IUserService userService;

    @Autowired
    private ISmsService smsService;

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException {
        String name = obtainUsername(request);
        if (!Strings.isNullOrEmpty(name)) {
            request.setAttribute("username", name);
            return super.attemptAuthentication(request, response);
        }

        String telephone = request.getParameter("telephone");
        if (Strings.isNullOrEmpty(telephone) || !LoginUserUtil.checkTelephone(telephone)) {
            throw new BadCredentialsException("Wrong telephone number");
        }

        User user = userService.findUserByTelephone(telephone);
        String inputCode = request.getParameter("smsCode");
        String sessionCode = smsService.getSmsCode(telephone);
        if (Objects.equals(inputCode, sessionCode)) {
            if (user == null) { // 如果用户第一次用手机登录 则自动注册该用户
                user = userService.addUserByPhone(telephone);
            }
            return new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
        } else {
            throw new BadCredentialsException("smsCodeError");
        }
    }
```

阿里云短信 security
 通过手机号查数据库用户
```java
@Override
public User findUserByTelephone(String telephone) {
    User user = userRepository.findUserByPhoneNumber(telephone);
    if (user == null) {
        return null;
    }
    List<Role> roles = roleRepository.findRolesByUserId(user.getId());
    if (roles == null || roles.isEmpty()) {
        throw new DisabledException("权限非法");
    }

    List<GrantedAuthority> authorities = new ArrayList<>();
    roles.forEach(role -> authorities.add(new SimpleGrantedAuthority("ROLE_" + role.getName())));
    user.setAuthorityList(authorities);
    return user;
}
```
创建用户，生成用户名 要写role表和user表 需要事务
没有密码
```java
@Override
@Transactional
public User addUserByPhone(String telephone) {
    User user = new User();
    user.setPhoneNumber(telephone);
    user.setName(telephone.substring(0, 3) + "****" + telephone.substring(7, telephone.length()));
    Date now = new Date();
    user.setCreateTime(now);
    user.setLastLoginTime(now);
    user.setLastUpdateTime(now);
    user = userRepository.save(user);

    Role role = new Role();
    role.setName("USER");
    role.setUserId(user.getId());
    roleRepository.save(role);
    user.setAuthorityList(Lists.newArrayList(new SimpleGrantedAuthority("ROLE_USER")));
    return user;
}
```

调用读数据库，比较用户输入验证码
```java
public class AuthFilter extends UsernamePasswordAuthenticationFilter {

    @Autowired
    private IUserService userService;

    @Autowired
    private ISmsService smsService;

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException {
        System.out.println("登陆请求"+request.getRequestedSessionId());

        String name = obtainUsername(request);
        if (!Strings.isNullOrEmpty(name)) {
            request.setAttribute("username", name);
            return super.attemptAuthentication(request, response);
        }

        String telephone = request.getParameter("telephone");
        if (Strings.isNullOrEmpty(telephone) || !LoginUserUtil.checkTelephone(telephone)) {
            throw new BadCredentialsException("Wrong telephone number");
        }

        User user = userService.findUserByTelephone(telephone);
        String inputCode = request.getParameter("smsCode");
        String sessionCode = smsService.getSmsCode(telephone);
        if (Objects.equals(inputCode, sessionCode)) {
            if (user == null) { // 如果用户第一次用手机登录 则自动注册该用户
                user = userService.addUserByPhone(telephone);
            }
            return new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
        } else {
            throw new BadCredentialsException("smsCodeError");
        }
    }
}
```
配置到security
```java
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
    /**
     * HTTP权限控制
     * @param http
     * @throws Exception
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.addFilterBefore(authFilter(), UsernamePasswordAuthenticationFilter.class);
}
```

注册manager和失败的bean
```java
@Bean
public AuthenticationManager authenticationManager() {
    AuthenticationManager authenticationManager = null;
    try {
        authenticationManager =  super.authenticationManager();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return authenticationManager;
}
@Bean
public AuthFilter authFilter() {
    AuthFilter authFilter = new AuthFilter();
    authFilter.setAuthenticationManager(authenticationManager());
    authFilter.setAuthenticationFailureHandler(authFailHandler());
    return authFilter;
}
```

#### 短信验证码
发送验证码接口
```java
@GetMapping(value = "sms/code")
@ResponseBody
public ApiResponse smsCode(@RequestParam("telephone") String telephone) {
    if (!LoginUserUtil.checkTelephone(telephone)) {
        return ApiResponse.ofMessage(HttpStatus.BAD_REQUEST.value(), "请输入正确的手机号");
    }
    ServiceResult<String> result = smsService.sendSms(telephone);
    if (result.isSuccess()) {
        return ApiResponse.ofSuccess("");
    } else {
        return ApiResponse.ofMessage(HttpStatus.BAD_REQUEST.value(), result.getMessage());
    }
}
```

添加初始化方法，在bean初始化的时候装配好client
坑：阿里云的gson版本，把自己引入的gson删掉就行了

任何对数据库有更改的接口都要加事务

用户名、密码修改接口

#### 房屋预约功能
```java
@Table(name = "house_subscribe")
public class HouseSubscribe {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "house_id")
    private Long houseId;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "admin_id")
    private Long adminId;

    // 预约状态 1-加入待看清单 2-已预约看房时间 3-看房完成
    private int status;

    @Column(name = "create_time")
    private Date createTime;

    @Column(name = "last_update_time")
    private Date lastUpdateTime;

    @Column(name = "order_time")
    private Date orderTime;

    private String telephone;

    /**
     * 踩坑 desc为MySQL保留字段 需要加转义
     */
    @Column(name = "`desc`")
    private String desc;
```

经纪人看房记录，管理人联系用户
经纪人后台list，操作看房完成标记


api接口security拦截
```java
public void commence(HttpServletRequest request, HttpServletResponse response,
                         AuthenticationException authException) throws IOException, ServletException {
    String uri = request.getRequestURI();
    if (uri.startsWith(API_FREFIX)) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType(CONTENT_TYPE);

        PrintWriter pw = response.getWriter();
        pw.write(API_CODE_403);
        pw.close();
    } else {
        super.commence(request, response, authException);
    }
}
```

客服聊天系统 美洽



监控
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
    <version>1.5.7.RELEASE</version>
</dependency>
```
`management.security.enabled=false`

用jconsole查看maxBean

PS Scavenge 25次 262ms 新生代 吞吐量优先收集器复制算法，并行多线程
PS MarkSweep（Parallel Old） 9次 2073ms 多线程压缩收集









预约功能和会员中心

desc字段需要转义 必须变成
```java
@Column(name = "`desc`")
private String desc;
```

```java
public interface UserRepository extends CrudRepository<User, Long> {

    User findByName(String userName);

    User findUserByPhoneNumber(String telephone);

    @Modifying
    @Query("update User as user set user.name = :name where id = :id")
    void updateUsername(@Param(value = "id") Long id, @Param(value = "name") String name);

    @Modifying
    @Query("update User as user set user.email = :email where id = :id")
    void updateEmail(@Param(value = "id") Long id, @Param(value = "email") String email);

    @Modifying
    @Query("update User as user set user.password = :password where id = :id")
    void updatePassword(@Param(value = "id") Long id, @Param(value = "password") String password);
}
```


es调优
索引读写优化
`index.store.type:"niofs`
`dynamic=strict`
关闭all字段，防止全部字段用于全文索引6.0已经没了`"_all":{ "enabled":flase}`

延迟恢复分片
`"index.unassigned.node_left.delayed_timeout":"5m"`

配置成指挥节点和数据节点，数据节点的http功能可以关闭，只做tcp数据交互
负载均衡节点master和data都是false，一般都是用nginx 不会用es节点
堆内存空间 指针压缩 小于32G内存才会用
批量操作 bulk


nginx
`./configure --with-stream`
用stream模块

开启慢查询日志
```shql
mysql> show variables  like '%slow_query_log%';
+---------------------+-----------------------------------+
| Variable_name       | Value                             |
+---------------------+-----------------------------------+
| slow_query_log      | OFF                               |
| slow_query_log_file | /var/lib/mysql/localhost-slow.log |
+---------------------+-----------------------------------+
2 rows in set (0.00 sec)

mysql> set global slow_query_log=1;
Query OK, 0 rows affected (0.01 sec)
```

tcp反向代理
```shell
./configure --with-stream
make install

./nginx -s reload
```

日志路径
```shell
[root@localhost logs]# ls
access.log  error.log  nginx.pid
```

nginx 坑
访问首页没问题，但是在登录跳转重定向时域名被修改成upstream的名字
一定要加！！！！Host

在HTTP/1.1中，Host请求头部必须存在,否则会返回400 Bad Request

curl 用法


nginx access 日志
```java
10.1.18.87 - - [25/Jun/2019:19:08:50 +0800] "GET /static/lib/layer/2.4/layer.js HTTP/1.1" 200 19843 "http://10.1.18.27/" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36" "-"
```


### 日志采集Logstash
```ruby
input{
        file{
                path => ["/usr/local/nginx/logs/access.log"]
                type => "nginx_access"
                start_position => "beginning"
        }
}
output{
        stdout{
                codec =>rubydebug
        }
}
```

启动
```shell
root@localhost logstash-5.5.2]# ./bin/logstash -f config/logstash.conf
```
提取了日志和时间戳
```json
{
          "path" => "/usr/local/nginx/logs/access.log",
    "@timestamp" => 2019-06-25T11:32:52.787Z,
      "@version" => "1",
          "host" => "localhost.localdomain",
       "message" => "10.1.18.87 - - [25/Jun/2019:19:26:44 +0800] \"GET /static/lib/layer/2.4/skin/layer.css HTTP/1.1\" 200 14048 \"http://10.1.18.27/\" \"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36\" \"-\"",
          "type" => "nginx_access"
}

```