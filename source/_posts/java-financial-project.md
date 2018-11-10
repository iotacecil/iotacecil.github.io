---
title: 理财项目-用到RPC和加密
date: 2018-11-10 13:25:11
tags:
---
主要的业务流程 查询和购买
{% qnimg finacialp1.jpg %}


用到的技术：

### 1.模块化开发 高内聚，低耦合

#### 模块划分
业务模块 公共模块 - 项目模块 - 管理端/销售端
{% qnimg finacialp2.jpg %}

1. 按业务层次划分，将dao层和service层单独划分成模块（Entity、Api）
2. 功能划分：管理和销售模块（可以独立部署的，算一个应用）
3. 重复使用的模块：Util，Quartz，Swagger

#### 构建工具 Gradle
模块：jar/war可以独立部署
创建gradle java项目 使用本地gradle
修改 构建脚本 添加单独文件专门用来依赖管理
`dependencies.gradle`
```json
ext {
    versions = [
            springBootVersion: '2.0.0.RELEASE'
    ]
    libs = [
            common : [
                    "org.springframework.boot:spring-boot-starter-web:${versions.springBootVersion}",
                    "org.springframework.boot:spring-boot-starter-data-jpa:${versions.springBootVersion}",
                    "org.apache.commons:commons-lang3:3.5"
                    , "com.h2database:h2:1.4.195"
            ],
            findbugs: [
                    "com.google.code.findbugs:jsr305:1.3.9"
            ],
            mysql  : [
                    "mysql:mysql-connector-java:5.1.29"
            ],
            jsonrpc:[
                    "com.github.briandilley.jsonrpc4j:jsonrpc4j:1.5.1"
            ],
            swagger: [
                    "io.springfox:springfox-swagger2:2.7.0",
                    "io.springfox:springfox-swagger-ui:2.7.0"
            ],
            hazelcast:[
                    'com.hazelcast:hazelcast:3.8.6',
                    'com.hazelcast:hazelcast-spring:3.8.6',
            ],
            activemq:[
                    "org.springframework.boot:spring-boot-starter-activemq:${versions.springBootVersion}",
            ],
            rsa:[
                    'commons-codec:commons-codec:1.8'
            ],
            test   : [
                    "org.springframework.boot:spring-boot-starter-test:${versions.springBootVersion}"

            ]
    ]
}
```
修改build.gradle 引入依赖文件
```json
group 'finalLearn'
version '1.0-SNAPSHOT'
apply from: "$rootDir/dependencies.gradle"

subprojects {

    apply plugin: 'java'
    apply plugin: 'war'

    sourceCompatibility = 1.8
    targetCompatibility = 1.8

    repositories {
        mavenLocal()
        mavenCentral()
    }

    dependencies {
        compile libs.common
        testCompile libs.test
    }
    [compileJava, compileTestJava]*.options*.encoding = 'UTF-8'
}
```

#### 新建模块
1.在工程上新建Module util，
2.将util的`build.gradle`清空
因为根项目的`build.gradle` 的 `subprojects`定义过了所有模块。
3.新建其他api,entity,manager,quartz,swagger,saller模块。
4.删除根目录下的src

---

### 2数据库设计
创建 manager 数据库 和 saller数据库


#### 管理端：产品表
{% qnimg finacialp3.jpg %}
{% qnimg finacialp4.jpg %}
> datetime 保存的时间更广，timestamp有时区信息（读取的时候会根据客户端时区转换成对应时区）

编号varchar50、名称varchar50、收益率decimal5,3、锁定期smallint、状态varchar20、起投金额decimal 15,3、投资步长decimal 15,3、备注
创建时间datetime、创建者varchar20、更新时间datetime、更新者varchar20
```sql
use manager
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `Id` varchar(50) NOT NULL DEFAULT '' COMMENT '产品编号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '产品名称',
  `threshold_amount` decimal(15,3) NOT NULL DEFAULT '0.000' COMMENT '起投金额',
  `step_amount` decimal(15,3) NOT NULL DEFAULT '0.000' COMMENT '投资补偿',
  `lock_term` smallint(6) NOT NULL DEFAULT '0' COMMENT '锁定期',
  `reward_rate` decimal(5,3) NOT NULL DEFAULT '0.000' COMMENT '收益率',
  `status` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '' COMMENT 'audining审核中',
  `memo` varchar(200) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL COMMENT '创建时间',
  `create_user` varchar(20) DEFAULT NULL,
  `update_at` datetime DEFAULT NULL,
  `update_user` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### 销售端：
{% qnimg finacialp5.jpg %}
{% qnimg finacialp6.jpg %}

订单表order_t  (order是关键字)
订单编号varchar50 渠道编号varchar50 产品编号varchar50 用户编号varchar50 外部订单编号varchar50  类型varchar50 状态varchar50  金额decimal15,3 备注varchar200 创建时间datetime 更新时间datetime
```sql
create database seller;
use seller;
DROP TABLE IF EXISTS `oreder_t`;
CREATE TABLE `oreder_t` (
  `order_id` varchar(50) NOT NULL DEFAULT '',
  `ch_id` varchar(50) NOT NULL DEFAULT '' COMMENT '渠道编号',
  `product_id` varchar(50) NOT NULL DEFAULT '' COMMENT '产品编号',
  `chan_user_id` varchar(50) NOT NULL DEFAULT '',
  `order_type` varchar(50) NOT NULL DEFAULT '' COMMENT '状态购买赎回',
  `order_status` varchar(50) NOT NULL DEFAULT '' COMMENT '状态初始化处理中成功失败',
  `outer_order_id` varchar(50) NOT NULL DEFAULT '' COMMENT '外部订单编号',
  `amount` decimal(15,3) NOT NULL DEFAULT '0.000' COMMENT '金额',
  `memo` varchar(200) DEFAULT NULL COMMENT '备注',
  `create_at` datetime DEFAULT NULL COMMENT '创建时间',
  `update_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

#### entity

##### 产品类 Product
entity的java里新建包`entity`新建`Product`和`Order`类
```java
@Entity
public class Product {
    @Id
    private String id;
    private String name;
    private String status;
    private BigDecimal thresholdAmount;
    private BigDecimal stepAmount;
    private Integer lockTerm;
    private BigDecimal rewardRate;
    private String memo;
    private Date createAt;
    private Date updateAt;
    private String createUser;
    private String updateUser;
}
```

可以用工具类重写toString（apache.commons）
用反射(?)
```java
@Override
public String toString() {
    return ReflectionToStringBuilder.toString(this, ToStringStyle.SIMPLE_STYLE);
```

产品status的枚举类 新建enums包
```java
public enum ProductStatus {
    AUDITING("审核中"),
    IN_SELL("销售中"),
    LOCKED("暂停销售"),
    FINISHED("已结束");
    ProductStatus(String desc) {
        this.desc = desc;
    }
    private String desc;
}
```
在Product类中添加说明
```java
/**
* @see entity.enums.ProductStatus
*/
private String status;
```

##### 订单对象 Order类
```java
@Entity(name = "order_t")
public class Order {
    @Id
    private String orderId;
    private String chanId;
    private String chanUserId;
    private String orderType;
    private String orderStatus;
    private String outerOrderId;
    private BigDecimal amount;
    private String memo;
    private Date createAt;
    private Date updateAt;
}
```
订单状态和订单种类的枚举类
```java
public enum OrderType {
    APPLY("申购"),
    REDEEM("赎回");
    private String desc;
    OrderType(String desc) {
        this.desc = desc;
    }
    public String getDesc() {
        return desc;
    }
}
```
添加doc
```java
/**
 * @see entity.enums.OrderType
 */
private String orderType;
/**
 * @see entity.enums.OrderStatus
 */
private String orderStatus;
```

```java
public enum OrderStatus {
    INIT("初始化"),
    PROCESS("处理中"),
    SUCCESS("成功"),
    FAIL("失败");
    private String desc;

    OrderStatus(String desc) {
        this.desc = desc;
    }

    public String getDesc() {
        return desc;
    }
}
```

### 3.管理端
Spring Data 用JPA 操作数据库
接口设计 添加产品、查询单个产品、条件查询产品
{% qnimg finacialp7.jpg %}

1.新建启动类
在`manager`模块 新建`mannager`-`ManagerApp.java` 启动类
entity不在manager里要手动添加扫描路径
```java
@SpringBootApplication
@EntityScan(basePackages = {"entity"})
public class ManagerApp {
    public static void main(String[] args) {
        SpringApplication.run(ManagerApp.class);
    }
}
```

2.配置数据库连接地址：
在resources添加jpa配置文件
```java
spring:
  datasource:
    url: jdbc:mysql://192.168.3.109:3306/manager?user=root&password=root&useUnicode=true&characterEncoding=utf-8
  jpa:
    show-sql: true
server:
  servlet:
    context-path: /manager
  port: 8081
```

3.新建controller，repository,service包

4.创建接口dao层`repository` - `ProductRepository`
继承 简单查询和复杂查询
```java
public interface ProductRepository extends JpaRepository<Product,String>,JpaSpecificationExecutor<Product>{
}
```
在当前模块的`build.gradle` 添加entity依赖
```java
dependencies{
    compile project(":entity")
    compile project(":util")
    compile project(":api")
    compile libs.mysql
}
```

#### 添加产品
5.service
添加产品 参数校验+设置默认值
不应该在实体类有默认值
int会有默认值 Integer不会有默认值
**判断整数的方法**
```java
@Service
public class ProductService {
    private static Logger LOG = LoggerFactory.getLogger(ProductService.class);

    @Autowired
    private ProductRepository repository;

    public Product addProduct(Product product){
        LOG.debug("创建产品，参数：{}",product);
        //数据校验
        checkProduct(product);
        setDefault(product);
        Product rst = repository.save(product);
        LOG.debug("创建产品，结果:{}",rst);
        return rst;
    }

    /**
     * 产品：编号不可空 步长整数 收益率0-30 校验
     * @param product
     */
    private void checkProduct(Product product) {
        Assert.notNull(product.getId(), "编号不可为空");
        Assert.isTrue(BigDecimal.ZERO.compareTo(product.getRewardRate())<0&&BigDecimal.valueOf(30).compareTo(product.getRewardRate())>=0,"收益率范围错误" );
        Assert.isTrue(BigDecimal.valueOf(product.getStepAmount().longValue()).compareTo(product.getStepAmount())==0, "投资步长需为整数");
    }

    /**
     * 产品默认值：创建更新时间，步长，状态，锁定期
     * @param product
     */
    public void setDefault(Product product) {
        if(product.getCreateAt()==null){
            product.setCreateAt(new Date());
        }
        if(product.getUpdateAt()==null){
            product.setUpdateAt(new Date());
        }
        if(product.getStepAmount()==null){
            product.setStepAmount(BigDecimal.ZERO);
        }
        if(product.getLockTerm()== null){
            product.setLockTerm(0);
        }
        if(product.getStatus()==null){
            product.setStatus(ProductStatus.AUDITING.name());
        }
    }
}
```

6.controller info级别的log
```java
@RestController
@RequestMapping("/products")
public class ProductController {
    private static Logger LOG = LoggerFactory.getLogger(ProductController.class);
    @Autowired
    private ProductService service;

    @RequestMapping(value = "",method= RequestMethod.POST)
    public Product addProduct(@RequestBody Product product){
        LOG.info("创建产品，参数:{}",product);
        Product rst = service.addProduct(product);
        LOG.info("创建产品，参数:{}",product);
        return rst;
    }
}
```

#### 查询产品单个产品
7.service
```java
public Product findOne(String id){
    Assert.notNull(id,"需要产编号参数");
    LOG.debug("查询单个产品,id={}",id);
    Product product = repository.findById(id).orElse(null);
    LOG.debug("查询单个产品,结果={}",product);
    return product;
}
```

8.controller从URL里获得产品id`@PathVariable`
```java
@RequestMapping(value = "/{id}",method = RequestMethod.GET)
public Product findOne(@PathVariable String id){
    LOG.info("查询单个产品，id:{}",id);
    Product product = service.findOne(id);
    LOG.info("查询单个产品，结果:{}",product);
    return product;
}
```

#### 复杂查询 分页查询
9.service
1).多个编号查询`List<String> idList`
2).收益率范围查询`BigDecimal minRewardRate, BigDecimal maxRewardRate`
3).多个状态查询`List<String> statusList`
4).分页查询`Pageable pageable` 分页参数

定义`Specification`
```java
public Page<Product> query(List<String> idList,
                               BigDecimal minRewardRate, BigDecimal maxRewardRate,
                               List<String> statusList,
                               Pageable pageable){
    LOG.debug("查询产品,idList={},min={},max:{},status={},pageable={}",idList,minRewardRate,maxRewardRate,statusList,pageable);
    Specification<Product> specification = new Specification<Product>() {
        @Override
        public Predicate toPredicate(Root<Product> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
            //获得编号、收益率、状态列
            Expression<String> idCol = root.get("id");
            Expression<BigDecimal> rewardRateCol = root.get("rewardRate");
            Expression<String> statusCol = root.get("status");
            //断言列表
            List<Predicate> predicates = new ArrayList<>();
            if(idList!=null &&idList.size()>0){
                predicates.add(idCol.in(idList));
            }
            if(minRewardRate!=null&&BigDecimal.ZERO.compareTo(minRewardRate)<0){
                predicates.add(cb.ge(rewardRateCol,minRewardRate));
            }
            if(maxRewardRate!=null&&BigDecimal.ZERO.compareTo(maxRewardRate)<0){
                predicates.add(cb.le(rewardRateCol,maxRewardRate));
            }
            if(statusList!=null&&statusList.size()>0){
                predicates.add(statusCol.in(statusList));
            }
            // 查询 列表->数组?
            query.where(predicates.toArray(new Predicate[0]));
            return null;
        }
    };
    Page<Product> page = repository.findAll(specification, pageable);

    LOG.debug("查询产品，结果={}",page);

    return page;
}
```

10.controller
pageNum 哪页 pageSize 每页多少
```java
@RequestMapping(value = "",method = RequestMethod.GET)
    public Page<Product> query(String ids, BigDecimal minRewardRate,BigDecimal maxRewardRate,String status,@RequestParam(defaultValue = "0") int pageNum,@RequestParam(defaultValue = "10")int pageSize){
        LOG.info("查询产品,ids={},min={},max={},status={},pagenum ={},pagesize={}", ids,minRewardRate,maxRewardRate,status,pageNum,pageSize);
        List<String> idList = null,statusList = null;
        if(!StringUtils.isEmpty(ids)){
            idList = Arrays.asList(ids.split(","));
        }
        if(!StringUtils.isEmpty(status)){
            statusList = Arrays.asList(status.split(","));

        }
        Pageable pageable = new PageRequest(pageNum,pageSize);
        Page<Product> page = service.query(idList, minRewardRate, maxRewardRate, statusList, pageable);
        LOG.info("={}",page );
        return page;
    }
```

#### API测试
启动MangerAPP
```javascript
var data = {
    "id":"001",
    "name":"金融1号",
    "thresholdAmount":10,
    "stepAmount":1,
    "lockTerm":0,
    "rewardRate":3.86,
    "status":"AUDITING"
}
fetch("http://localhost:8081/manager/products",{ // post请求
  method:"POST",
  headers: {
        "Content-Type": "application/json"
   }, 
   body:JSON.stringify(data)
}).then(res => console.log(res.json()))
  .catch(e=>console.log("something went wrong: " + e))
```
查看数据库 OK

查询
get：http://localhost:8081/manager/products/001

搜索功能：
get:http://localhost:8081/manager/products?minRewardRate=3&maxRewardRate=5&status=AUDITING&pageNum=0&pageSize=10

jackson时间格式化 好像并不用
```java
spring:
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
```

post：http://localhost:8081/manager/products/ 
```json
{
    "name":"金融1号",
    "thresholdAmount":10,
    "stepAmount":1,
    "lockTerm":0,
    "rewardRate":3.86,
    "status":"AUDITING"
}
```
返回
```json
{
    "timestamp": "2018-08-29 19:38:21",
    "status": 500,
    "error": "Internal Server Error",
    "message": "编号不可为空",
    "path": "/manager/products/"
}
```

#### 统一错误处理
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-error-handling
spring boot提供了默认的`/error`全局错误处理
对于machine clients(程序，jar包，http client ,ajax发起的), it produces a JSON response 包括HTTP status, the exception message.
对于浏览器（browser clients会自动添加accept: text/html到报文头）发起的请求renders the same data in HTML format  如果用postman加上`Accept:text/html`就返回html
通过实现`ErrorController`接口注册到容器中或者添加一个`ErrorAttributes`bean
还可以用`@ControllerAdvice`拦截controller的错误

#### 源码：变成html的实现方法`BasicErrorController`
```java
@Controller
@RequestMapping("${server.error.path:${error.path:/error}}")
public class BasicErrorController extends AbstractErrorController 
```
错误页面的拦截
所以可以通过修改server.error.path修改默认配置
```java
@RequestMapping(produces = "text/html")
public ModelAndView errorHtml(HttpServletRequest request,
        HttpServletResponse response) {
    HttpStatus status = getStatus(request);
    Map<String, Object> model = Collections.unmodifiableMap(getErrorAttributes(
            request, isIncludeStackTrace(request, MediaType.TEXT_HTML)));
    response.setStatus(status.value());
    // 自定义的error视图
    ModelAndView modelAndView = resolveErrorView(request, response, status, model);
    //如果没有视图，用error视图
    return (modelAndView == null ? new ModelAndView("error", model) : modelAndView);
}
```

普通机器客户端的拦截
```java
@RequestMapping
@ResponseBody
public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
    Map<String, Object> body = getErrorAttributes(request,
            isIncludeStackTrace(request, MediaType.ALL));
    HttpStatus status = getStatus(request);
    return new ResponseEntity<>(body, status);
}
```
都是用`getErrorAttributes`获取响应数据，用`getStatus` 获取状态码


`BasicErrorController`的注册过程 右键Find Usages
```java
@Bean
//条件表达式，如果没有则新建
@ConditionalOnMissingBean(value = ErrorController.class, search = SearchStrategy.CURRENT)
public BasicErrorController basicErrorController(ErrorAttributes errorAttributes) {
    return new BasicErrorController(errorAttributes, this.serverProperties.getError(),
            this.errorViewResolvers);
}
```
html错误形式
```java
@Configuration
@ConditionalOnProperty(prefix = "server.error.whitelabel", name = "enabled", matchIfMissing = true)
@Conditional(ErrorTemplateMissingCondition.class)
protected static class WhitelabelErrorViewConfiguration {

    private final SpelView defaultErrorView = new SpelView(
            "<html><body><h1>Whitelabel Error Page</h1>"
                    + "<p>This application has no explicit mapping for /error, so you are seeing this as a fallback.</p>"
                    + "<div id='created'>${timestamp}</div>"
                    + "<div>There was an unexpected error (type=${error}, status=${status}).</div>"
                    + "<div>${message}</div></body></html>");
    //注册了一个View名字叫error
    @Bean(name = "error")
    @ConditionalOnMissingBean(name = "error")
    public View defaultErrorView() {
        return this.defaultErrorView;
    }

    // If the user adds @EnableWebMvc then the bean name view resolver from
    // WebMvcAutoConfiguration disappears, so add it back in to avoid disappointment.
    @Bean
    @ConditionalOnMissingBean(BeanNameViewResolver.class)
    public BeanNameViewResolver beanNameViewResolver() {
        BeanNameViewResolver resolver = new BeanNameViewResolver();
        resolver.setOrder(Ordered.LOWEST_PRECEDENCE - 10);
        return resolver;
    }

}
```


#### 自定义错误处理
新建错误页面
```
src/
 +- main/
     +- java/
     |   + <source code>
     +- resources/
         +- public/
             +- error/
             |   +- 404.html
             +- <other public assets>
```
方法1 拦截5xx错误 新建resources-static.error-5xx.html

方法2新建error包 新建类
1.继承`BasicErrorController`重写返回错误的方法，去掉不要的信息
```java
public class MyErrorController extends BasicErrorController{
    public MyErrorController(ErrorAttributes errorAttributes, ErrorProperties errorProperties, List<ErrorViewResolver> errorViewResolvers) {
        super(errorAttributes, errorProperties, errorViewResolvers);
    }

    @Override
    protected Map<String, Object> getErrorAttributes(HttpServletRequest request, boolean includeStackTrace) {
        Map<String, Object> errorAttributes = super.getErrorAttributes(request, includeStackTrace);
        errorAttributes.remove("timestamp");
        errorAttributes.remove("error");
        errorAttributes.remove("path");

        return errorAttributes;
    }
}
```

2.添加配置类注册bean 参考BasicError的注册类ErrorMvcAutoConfiguration 将Controller注册到容器中
```java
@Configuration
public class ErrorConfiguration {
    @Bean
    public MyErrorController basicErrorController(ErrorAttributes errorAttributes,
        ServerProperties serverProperties,
        ObjectProvider<List<ErrorViewResolver>> errorViewResolversProvider) {
        return new MyErrorController(errorAttributes, serverProperties.getError(),errorViewResolversProvider.getIfAvailable());
    }
}
```

效果：
```json
{
    "message": "编号不可空",
}
```


3.添加错误枚举类(注意 枚举类中的类方法)
```java
public enum ErrorEnum {
    ID_NOT_NULL("F001","编号不可空",false),
    UNKNOWN("999","未知异常",false);
    private String code;
    private String message;
    private boolean canRetry;

    ErrorEnum(String code, String message, boolean canRetry) {
        this.code = code;
        this.message = message;
        this.canRetry = canRetry;
    }
    public static ErrorEnum getByCode(String code){
        for(ErrorEnum errorEnum:ErrorEnum.values()){
            if(errorEnum.code.equals(code)){
                return errorEnum;
            }
        }
        return UNKNOWN;
    }
```

修改ProductService中的check抛出的不是message而是自己定义的错误code
```java
private void checkProduct(Product product) {
Assert.notNull(product.getId(), ErrorEnum.ID_NOT_NULL.getCode());}
```

修改MyErrorController,添加errorcode和retry
```java
 @Override
protected Map<String, Object> getErrorAttributes(HttpServletRequest request, boolean includeStackTrace) {
    Map<String, Object> errorAttributes = super.getErrorAttributes(request, includeStackTrace);
    errorAttributes.remove("timestamp");
    errorAttributes.remove("error");
    errorAttributes.remove("path");
    String message = (String)errorAttributes.get("message");
    errorAttributes.remove("message");
    // 获取错误种类
    ErrorEnum errorEnum = ErrorEnum.getByCode(message);
    errorAttributes.put("message",errorEnum.getMessage() );
    errorAttributes.put("code",errorEnum.getCode() );
    errorAttributes.put("canRetry",errorEnum.isCanRetry() );

    return errorAttributes;
}
```

输出
```json
{
    "message": "编号不可空",
    "code": "F001",
    "canRetry": false
}
```

方法3：`@ControllerAdvice`
优先级比方法2高，controller异常后直接这个然后返回response
扫描制定的package
```java
@ControllerAdvice(basePackages = {"manager.controller"})
public class ErrorControllerAdvice {
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public ResponseEntity handleException(Exception e){
        Map<String, Object> errorAttributes = new HashMap<>();
        String errorcode = e.getMessage();

        ErrorEnum errorEnum = ErrorEnum.getByCode(errorcode);
        errorAttributes.put("message",errorEnum.getMessage() );
        errorAttributes.put("code",errorEnum.getCode() );
        errorAttributes.put("canRetry",errorEnum.isCanRetry() );
        //这里再抛一个异常就到basicerror里了
        Assert.isNull(errorAttributes,"advice" );
        errorAttributes.put("type","advice");

        return new ResponseEntity(errorAttributes, HttpStatus.INTERNAL_SERVER_ERROR);
    }
```

```json
{
    "message": "编号不可空",
    "code": "F001",
    "canRetry": false,
    
}
```