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

#### ES 安装问题
不能用root启动 max_map太小
```sh
chown -R es:es elasticsearch...
su 
sysctl -w vm.max_map_count=262144
```

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
    // 注意不在数据库中的属性，不持久化，避免jap检查
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