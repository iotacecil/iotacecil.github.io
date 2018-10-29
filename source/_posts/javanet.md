---
title: javanet
date: 2018-03-11 23:05:52
tags: [javaNet,java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
### 模块化开发
1. 按业务层次划分，将dao层和service层单独划分成模块
2. 功能划分：管理和销售模块
3. 重复使用的模块：Util，Quartz，Swagger

#### 构建工具 Gradle
模块：jar/war可以独立部署
创建gradle java项目 使用本地gradle
修改构建脚本 添加单独文件
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
修改build.gradle
```json
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

在工程上新建Module 因为`subprojects`定义过了所有模块，将util的`build.gradle`清空
新建其他api,entity,manager,quartz,swagger,saller模块。删除根目录下的src


#### 数据库设计
1.管理端：产品表
> datetime 保存的时间更广，timestamp有时区信息

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

2.销售端：订单表order_t  (order是关键字)
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
重写toString（apache.commons）
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

Order类
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

#### manager 添加
新建mannager-ManagerApp.java
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
在resources添加jpa配置文件
```yml
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
新建controller，repository,service包
dao层ProductRepository

```java
public interface ProductRepository extends JpaRepository<Product,String>,JpaSpecificationExecutor<Product>{
}
```
int会有默认值 Integer不会有默认值
**判断整数的方法**
service
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
     * 产品：编号 步长 收益率 校验
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
controller info级别的log
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

#### manager 查询
service
```java
public Product findOne(String id){
    Assert.notNull(id,"需要产编号参数");
    LOG.debug("查询单个产品,id={}",id);
    Product product = repository.findById(id).orElse(null);
    LOG.debug("查询单个产品,结果={}",product);
    return product;
}
```
controller
```java
@RequestMapping(value = "/{id}",method = RequestMethod.GET)
public Product findOne(@PathVariable String id){
    LOG.info("查询单个产品，id:{}",id);
    Product product = service.findOne(id);
    LOG.info("查询单个产品，结果:{}",product);
    return product;
}
```
分页查询service
```java
public Page<Product> query(List<String> idList,
                               BigDecimal minRewardRate, BigDecimal maxRewardRate,
                               List<String> statusList,
                               Pageable pageable){
    LOG.debug("查询产品,idList={},min={},max:{},status={},pageable={}",idList,minRewardRate,maxRewardRate,statusList,pageable);
    Specification<Product> specification = new Specification<Product>() {
        @Override
        public Predicate toPredicate(Root<Product> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
            //获得列
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
            query.where(predicates.toArray(new Predicate[0]));
            return null;
        }
    };
    Page<Product> page = repository.findAll(specification, pageable);

    LOG.debug("查询产品，结果={}",page);

    return page;
}
```

controller
```java
@RequestMapping(value = "",method = RequestMethod.GET)
    public Page<Product> query(String ids, BigDecimal minRewardRate,BigDecimal maxRewardRate,
                               String status,@RequestParam(defaultValue = "0") int pageNum,@RequestParam(defaultValue = "10")int pageSize){
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

#### 测试
启动MangerAPP
添加
post:http://localhost:8081/manager/products
Content-Type: application/json
```json
{
    "id":"001",
    "name":"金融1号",
    "thresholdAmount":10,
    "stepAmount":1,
    "lockTerm":0,
    "rewardRate":3.86,
    "status":"AUDITING"
}
```
查询
get：http://localhost:8081/manager/products/001

搜索功能：
get:http://localhost:8081/manager/products?minRewardRate=3&maxRewardRate=5&status=AUDITING&pageNum=0&pageSize=10

#### 统一错误处理
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-error-handling
spring boot提供了默认的`/error`全局错误处理
对于machine clients(程序，jar包，http client ,ajax发起的), it produces a JSON response 包括HTTP status, the exception message.
对于浏览器（browser clients会自动添加accept: text/html到报文头）发起的请求renders the same data in HTML format  如果用postman加上`Accept:text/html`就返回html
通过实现`ErrorController`接口注册到容器中或者添加一个`ErrorAttributes`bean
还可以用`@ControllerAdvice`拦截controller的错误

源码：变成html的实现方法`BasicErrorController`
```java
@Controller
@RequestMapping("${server.error.path:${error.path:/error}}")
public class BasicErrorController extends AbstractErrorController 
```
所以可以通过修改server.error.path修改默认配置
```java
@RequestMapping(produces = "text/html")
public ModelAndView errorHtml(HttpServletRequest request,
        HttpServletResponse response) {
    HttpStatus status = getStatus(request);
    Map<String, Object> model = Collections.unmodifiableMap(getErrorAttributes(
            request, isIncludeStackTrace(request, MediaType.TEXT_HTML)));
    response.setStatus(status.value());
    ModelAndView modelAndView = resolveErrorView(request, response, status, model);
    //如果没有视图，用error视图
    return (modelAndView == null ? new ModelAndView("error", model) : modelAndView);
}
```
注册过程
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
方法1新建resources-static.error-5xx.html

方法2新建error包 新建类继承`BasicErrorController`重写返回错误的方法，去掉不要的信息
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
添加配置类注册bean 参考BasicError的注册类ErrorMvcAutoConfiguration
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
添加错误枚举类(注意 枚举类中的类方法)
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
修改service中的check抛出的不是message而是自己定义的错误code
```java
private void checkProduct(Product product) {
Assert.notNull(product.getId(), ErrorEnum.ID_NOT_NULL.getCode());}
```
修改MyErrorController,只输出自己定义的错误信息
```java
 @Override
protected Map<String, Object> getErrorAttributes(HttpServletRequest request, boolean includeStackTrace) {
    Map<String, Object> errorAttributes = super.getErrorAttributes(request, includeStackTrace);
    errorAttributes.remove("timestamp");
    errorAttributes.remove("error");
    errorAttributes.remove("path");
    String message = (String)errorAttributes.get("message");
    errorAttributes.remove("message");

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

jackson格式化 好像并不用
```yml
spring:
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
```

#### 自动化测试
功能测试，工具类还是要用单元测试
新建Util类
1.`JsonUtil`:Object->Json 用于log输出
```java
public class JsonUtil {
    private static final Logger LOG = LoggerFactory.getLogger(JsonUtil.class);
    private final static ObjectMapper mapper = new ObjectMapper();
    public static String toJson(Object obj) {
        try {
            return mapper.writeValueAsString(obj);
        } catch (IOException e) {
            LOG.error("to json exception.", e);
            throw new JSONException("把对象转换为JSON时出错了", e);
        }
    }

}
final class JSONException extends RuntimeException {
    public JSONException(final String message) {
        super(message);
    }

    public JSONException(final String message, final Throwable cause) {
        super(message, cause);
    }
}
```
2.`RestUtil`:发送Http请求
```java
public class RestUtil {
    static Logger log = LoggerFactory.getLogger(RestUtil.class);

    public static HttpEntity<String> makePostJSONEntiry(Object param) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
        headers.add("Accept", MediaType.APPLICATION_JSON_VALUE);
        HttpEntity<String> formEntity = new HttpEntity<String>(
                JsonUtil.toJson(param), headers);
        log.info("rest-post-json-请求参数:{}", formEntity.toString());
        return formEntity;
    }
    public static <T> T postJSON(RestTemplate restTemplate, String url, Object param, Class<T> responseType) {
        HttpEntity<String> formEntity = makePostJSONEntiry(param);
        T result = restTemplate.postForObject(url, formEntity, responseType);
        log.info("rest-post-json 响应信息:{}", JsonUtil.toJson(result));
        return result;
    }
}
```
在manager添加util依赖
```java
compile project(":util")
```
新建测试类test-manager.controller-ProductControllerTest
```java
@RunWith(SpringRunner.class)
//随机端口
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class ProductControllerTest {
    private static RestTemplate rest  =new RestTemplate();

    @Value("http://localhost:${local.server.port}/manager")
    private String baseUrl;

    //正常的测试用例
    private static List<Product> normals = new ArrayList<>();
    //异常测试用例
    private static List<Product> exceptions = new ArrayList<>();

    @BeforeClass
    public static void init(){
        Product p1 = new Product("T001", "灵活宝1号", ProductStatus.AUDITING.name(),
                BigDecimal.valueOf(10), BigDecimal.valueOf(1), BigDecimal.valueOf(3.42));
        Product p2 = new Product("T002", "活期盈-金色人生", ProductStatus.AUDITING.name(),
                BigDecimal.valueOf(10), BigDecimal.valueOf(0), BigDecimal.valueOf(3.28));
        Product p3 = new Product("T003", "朝朝盈-聚财", ProductStatus.AUDITING.name(),
                BigDecimal.valueOf(100), BigDecimal.valueOf(10), BigDecimal.valueOf(3.86));
        normals.add(p1);
        normals.add(p2);
        normals.add(p3);
        //异常
        Product e1 = new Product(null, "编号空", ProductStatus.AUDITING.name(),
                BigDecimal.valueOf(10), BigDecimal.valueOf(1), BigDecimal.valueOf(3.42));
        Product e2 = new Product("E002", "收益>30", ProductStatus.AUDITING.name(),
                BigDecimal.valueOf(10), BigDecimal.valueOf(0), BigDecimal.valueOf(31));
        Product e3 = new Product("E003", "投资步长是小数", ProductStatus.AUDITING.name(),
                BigDecimal.valueOf(100), BigDecimal.valueOf(1.01), BigDecimal.valueOf(3.86));
        exceptions.add(e1);
        exceptions.add(e2);
        exceptions.add(e3);
    }
    @Test
    public void create(){
        normals.forEach(product -> {
            Product rst = RestUtil.postJSON(rest, baseUrl + "/products", product, Product.class);
            Assert.notNull(rst.getCreateAt(),"插入失败" );
        });
        exceptions.forEach(product -> {
            Product rst = RestUtil.postJSON(rest, baseUrl + "/products", product, Product.class);
            Assert.notNull(rst.getCreateAt(),"插入失败" );
        });
    }
}
```
对错误的测试用例添加异常捕获
//todo 3-6,3-6 查询的测试

#### 文档管理工具swagger//todo

#### 销售端
产品查询 申购赎回 对账
jsonrpc
添加全局依赖
```json
ext {
libs = [
jsonrpc:[
        "com.github.briandilley.jsonrpc4j:jsonrpc4j:1.5.1"
],]
}
```
添加到api模块
```json
dependencies{
    compile libs.jsonrpc
}
```
添加entity依赖
新建接口api-ProductRpc
```java
@JsonRpcService("rpc/products")
public interface ProductRpc {
    /**
     * 查询多个产品
     * @param req
     * @return
     */
    List<Product> query(ProductRpcReq req);

    /**
     * 查单个产品
     * @param id
     * @return
     */
    Product findOne(String id);

```
将参数复杂的接口的参数封装到请求对象 
api-domain
```java
public class ProductRpcReq {
    private List<String> idList;
    private BigDecimal minRewardRate;
    private BigDecimal maxRewardRate;
    private List<String> statusList;
    }
```

修改manger添加api依赖
```java
compile project(":api")
```

在管理端新建包rpc
rpc实现类
```java
@AutoJsonRpcServiceImpl
@Service
public class ProductRpcImpl implements ProductRpc {
    private static Logger LOG = LoggerFactory.getLogger(ProductRpcImpl.class);
    @Autowired
    private ProductService productService;
    
    @Override
    public List<Product> query(ProductRpcReq req) {
        LOG.info("查询多个产品：{}",req );
        Pageable pageable = new PageRequest(0,1000, Sort.Direction.DESC,"rewardRate");
        Page<Product> page = productService.query(req.getIdList(), req.getMinRewardRate(),
                req.getMaxRewardRate(), req.getStatusList(), pageable);
        LOG.info("查询多个结果：{}",page );
        return page.getContent();
    }

    @Override
    public Product findOne(String id) {
        LOG.info("请求id:{}",id);
        Product rst = productService.findOne(id);
        LOG.info("结果id:{}",rst);
        return rst;
    }
}
```
将rpc地址交给spring管理的配置类
在manager新建包configuration rpc服务端
```java
@Configuration
public class RpcConfiguration {
    @Bean
    public AutoJsonRpcServiceImplExporter rpcServiceImplExporter(){
        return new AutoJsonRpcServiceImplExporter();
    }
}
```
可以看到日志信息 说明在manager的rpc实现导出到api中的地址成功
```log
2018-08-30 13:17:37.832  WARN 21224 --- [           main] o.s.c.a.ConfigurationClassEnhancer       : @Bean method RpcConfiguration.rpcServiceImplExporter is non-static and returns an object assignable to Spring's BeanFactoryPostProcessor interface. This will result in a failure to process annotations such as @Autowired, @Resource and @PostConstruct within the method's declaring @Configuration class. Add the 'static' modifier to this method to avoid these container lifecycle issues; see @Bean javadoc for complete details.
2018-08-30 13:17:37.846  INFO 21224 --- [           main] c.g.j.s.AutoJsonRpcServiceImplExporter   : exporting bean [productRpcImpl] ---> [/products]
```

saller模块：
添加api依赖，新建saller包并添加启动类
```java
dependencies{
    compile project(":api")
}
```
```java
@SpringBootApplication
public class SellerApp {
    public static void main(String[] args) {
        SpringApplication.run(SellerApp.class);
    }
}
```
新建service包
```java
@Service
public class ProductRpcService {
    private static Logger LOG = LoggerFactory.getLogger(ProductRpcService.class);

    @Autowired
    private ProductRpc productRpc;

    /**
     * 查询全部产品 暂时不分页返回
     * @return List
     */
    public List<Product> findAll(){
        ProductRpcReq req = new ProductRpcReq();
        List<String> status = new ArrayList<>();
        //只能查询销售中的
        status.add(ProductStatus.IN_SELL.name());
        req.setStatusList(status);
        LOG.info("rpc查询全部产品 请求:{}",req);
        List<Product> result = productRpc.query(req);
        LOG.info("rpc查询全部产品 结果:{}",result);
        return result;
    }
    //测试类
    @PostConstruct
    public void testFindAll(){
        findAll();
    }
    public Product findOne(String id){
        LOG.info("单个产品请求:{}", id);
        Product rst = productRpc.findOne(id);
        LOG.info("单个产品 结果:{}", rst);
        return rst;

    }
    @PostConstruct
    public void testfindone(){
        findOne("001");
    }

```
添加配置文件映射rpc路径
`application.yml`
```yml
server:
  servlet:
    context-path: /seller
  port: 8082

rpc.manager.url: http://localhost:8081/manager/
```
新建configuration包 导出bean创建rpc客户端
```java
@Configuration
@ComponentScan(basePackageClasses = {ProductRpc.class})
public class RpcConfiguration {
    private static Logger LOG = LoggerFactory.getLogger(RpcConfiguration.class);
    @Bean
    public AutoJsonRpcClientProxyCreator rpcClientProxyCreator(@Value("${rpc.manager.url}") String url){
        AutoJsonRpcClientProxyCreator creator = new AutoJsonRpcClientProxyCreator();
        //设置地址
        try{
            creator.setBaseUrl(new URL(url));
        }catch (MalformedURLException e){
            LOG.error("创建rpc服务地址错误",e);
        }
        //扫描接口
        creator.setScanPackage(ProductRpc.class.getPackage().getName());
        return creator;
    }
}
```

修改路径
```java
bean [productRpcImpl] ---> [rpc/products]
```
jsonRPC
注意点：
1.不能传递复杂参数不要传递分页对象
2.路径rpc路径前不能有`/`
3.RPC配置类的扫描路径

JSONRPC 

#### 客户端原理
```java
logging:
  level:
    com.googlecode.jsonrpc4j: debug
```
开启客户端debug log
```java
2018-08-30 15:28:40.612 DEBUG 31512 --- [           main] c.g.j.s.AutoJsonRpcClientProxyCreator    : Scanning 'classpath:api/**/*.class' for JSON-RPC service interfaces.
2018-08-30 15:28:40.613 DEBUG 31512 --- [           main] c.g.j.s.AutoJsonRpcClientProxyCreator    : Found JSON-RPC service to proxy [api.ProductRpc] on path 'rpc/products'.
```

```java
2018-08-30 15:28:42.819  INFO 31512 --- [           main] saller.service.ProductRpcService         : 单个产品请求:001
2018-08-30 15:28:42.836 DEBUG 31512 --- [           main] c.g.jsonrpc4j.JsonRpcHttpClient          : Request {"id":"1269662779","jsonrpc":"2.0","method":"findOne","params":["001"]}
2018-08-30 15:28:42.872 DEBUG 31512 --- [           main] c.g.jsonrpc4j.JsonRpcHttpClient          : JSON-PRC Response: {"jsonrpc":"2.0","id":"1269662779","result":{"id":"001","name":"金融1号","status":"AUDITING","thresholdAmount":10.0,"stepAmount":1,"lockTerm":0,"rewardRate":3.86,"memo":null,"createAt":"2018-08-29T11:38:02.000+0000","updateAt":"2018-08-29T11:38:02.000+0000","createUser":null,"updateUser":null}}
2018-08-30 15:28:42.905  INFO 31512 --- [           main] saller.service.ProductRpcService         : 单个产品 结果:entity.Product@12fcc71f[id=001,name=金融1号,status=AUDITING,thresholdAmount=10.0,stepAmount=1,lockTerm=0,rewardRate=3.86,memo=<null>,createAt=Wed Aug 29 19:38:02 CST 2018,updateAt=Wed Aug 29 19:38:02 CST 2018,createUser=<null>,updateUser=<null>]
```
`AutoJsonRpcClientProxyCreator`源码
{% fold %}
自动注入`Application`
从容器中获取bean之后会调用方法`postProcessBeanFactory`
```java
implements BeanFactoryPostProcessor, ApplicationContextAware
```
```java
private String resolvePackageToScan() {
    return CLASSPATH_URL_PREFIX + convertClassNameToResourcePath(scanPackage) + "/**/*.class";
}
@Override
public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
    SimpleMetadataReaderFactory metadataReaderFactory = new SimpleMetadataReaderFactory(applicationContext);
    DefaultListableBeanFactory defaultListableBeanFactory = (DefaultListableBeanFactory) beanFactory;
    //配置的包路径
    String resolvedPath = resolvePackageToScan();
    logger.debug("Scanning '{}' for JSON-RPC service interfaces.", resolvedPath);
    try {
        for (Resource resource : applicationContext.getResources(resolvedPath)) {
            if (resource.isReadable()) {
                MetadataReader metadataReader = metadataReaderFactory.getMetadataReader(resource);
                ClassMetadata classMetadata = metadataReader.getClassMetadata();
                //扫描注解
                AnnotationMetadata annotationMetadata = metadataReader.getAnnotationMetadata();
                String jsonRpcPathAnnotation = JsonRpcService.class.getName();
                //如果是jsonRpc服务
                if (annotationMetadata.isAnnotated(jsonRpcPathAnnotation)) {
                    String className = classMetadata.getClassName();
                    String path = (String) annotationMetadata.getAnnotationAttributes(jsonRpcPathAnnotation).get("value");
                    logger.debug("Found JSON-RPC service to proxy [{}] on path '{}'.", className, path);
                    //注册到容器
                    registerJsonProxyBean(defaultListableBeanFactory, className, path);
                }
            }
        }
    } catch (IOException e) {
        throw new RuntimeException(format("Cannot scan package '%s' for classes.", resolvedPath), e);
    }
}
```
注册到容器
```java
/**
 * Registers a new proxy bean with the bean factory.
 */
private void registerJsonProxyBean(DefaultListableBeanFactory defaultListableBeanFactory, String className, String path) {
    BeanDefinitionBuilder beanDefinitionBuilder = BeanDefinitionBuilder
        //代理类
            .rootBeanDefinition(JsonProxyFactoryBean.class)
            .addPropertyValue("serviceUrl", appendBasePath(path))
            .addPropertyValue("serviceInterface", className);
    
    if (objectMapper != null) {
        beanDefinitionBuilder.addPropertyValue("objectMapper", objectMapper);
    }
    
    if (contentType != null) {
        beanDefinitionBuilder.addPropertyValue("contentType", contentType);
    }
    
    defaultListableBeanFactory.registerBeanDefinition(className + "-clientProxy", beanDefinitionBuilder.getBeanDefinition());
}
```

`JsonProxyFactoryBean`

```java
public class JsonProxyFactoryBean extends UrlBasedRemoteAccessor implements MethodInterceptor, InitializingBean, FactoryBean<Object>, ApplicationContextAware {
@Override
    @SuppressWarnings("unchecked")
    public void afterPropertiesSet() {
        super.afterPropertiesSet();
        //根据接口创建代理对象
        proxyObject = ProxyFactory.getProxy(getServiceInterface(), this);

        if (jsonRpcHttpClient==null) {
            //与spring容器共用一个objectMapper
            if (objectMapper == null && applicationContext != null && applicationContext.containsBean("objectMapper")) {
                objectMapper = (ObjectMapper) applicationContext.getBean("objectMapper");
            }
            if (objectMapper == null && applicationContext != null) {
                try {
                    objectMapper = BeanFactoryUtils.beanOfTypeIncludingAncestors(applicationContext, ObjectMapper.class);
                } catch (Exception e) {
                    logger.debug(e);
                }
            }
            if (objectMapper == null) {
                objectMapper = new ObjectMapper();
            }
    
            try {
                //通过HTTP的方式发送数据的
                jsonRpcHttpClient = new JsonRpcHttpClient(objectMapper, new URL(getServiceUrl()), extraHttpHeaders);
                jsonRpcHttpClient.setRequestListener(requestListener);
                jsonRpcHttpClient.setSslContext(sslContext);
                jsonRpcHttpClient.setHostNameVerifier(hostNameVerifier);
    
                if (contentType != null) {
                    jsonRpcHttpClient.setContentType(contentType);
                }
                
                if (exceptionResolver!=null) {
                    jsonRpcHttpClient.setExceptionResolver(exceptionResolver);
                }
            } catch (MalformedURLException mue) {
                throw new RuntimeException(mue);
            }
        }
    }
}
```
实际与服务端交互的http方法
```java
@Override
public Object invoke(MethodInvocation invocation)
        throws Throwable {
    Method method = invocation.getMethod();
    if (method.getDeclaringClass() == Object.class && method.getName().equals("toString")) {
        return proxyObject.getClass().getName() + "@" + System.identityHashCode(proxyObject);
    }

    Type retType = (invocation.getMethod().getGenericReturnType() != null) ? invocation.getMethod().getGenericReturnType() : invocation.getMethod().getReturnType();
    Object arguments = ReflectionUtil.parseArguments(invocation.getMethod(), invocation.getArguments());

    return jsonRpcHttpClient.invoke(invocation.getMethod().getName(), arguments, retType, extraHttpHeaders);
}
```
`jsonRpcHttpClient.java`
```java
private HttpURLConnection prepareConnection(Map<String, String> extraHeaders) throws IOException {
        
    // create URLConnection
    HttpURLConnection connection = (HttpURLConnection) serviceUrl.openConnection(connectionProxy);
    connection.setConnectTimeout(connectionTimeoutMillis);
    connection.setReadTimeout(readTimeoutMillis);
    connection.setAllowUserInteraction(false);
    connection.setDefaultUseCaches(false);
    connection.setDoInput(true);
    connection.setDoOutput(true);
    connection.setUseCaches(false);
    connection.setInstanceFollowRedirects(true);
    connection.setRequestMethod("POST");
    
    setupSsl(connection);
    addHeaders(extraHeaders, connection);
    
    return connection;
}
```

{% endfold %}

测试调用rpc路径bug
```java
/**
 * Appends the base path to the path found in the interface.
 */
private String appendBasePath(String path) {
    try {
        return new URL(baseUrl, path).toString();
    } catch (MalformedURLException e) {
        throw new RuntimeException(format("Cannot combine URLs '%s' and '%s' to valid URL.", baseUrl, path), e);
    }
}

 public static void main(String[] args) throws MalformedURLException {
    URL baseUrl = new URL("http://localhost:8081/manager/");
    String path = "rpc/products";
    //只有这种是对的
    //http://localhost:8081/manager/rpc/products
    System.out.println(new URL(baseUrl, path).toString());

    URL baseUrl = new URL("http://localhost:8081/manager");
    String path = "/rpc/products";
    //少了manager
    //http://localhost:8081/rpc/products
    System.out.println(new URL(baseUrl, path).toString());

    URL baseUrl = new URL("http://localhost:8081/manager/");
    String path = "/rpc/products";
    //http://localhost:8081/rpc/products
    System.out.println(new URL(baseUrl, path).toString());
}
```

#### 服务端的运行原理
```java
logging:
  level:
    com.googlecode.jsonrpc4j: debug
```
导出bean 注册接口 创建服务 映射到handler
```java
2018-08-30 21:48:37.315  INFO 20852 --- [           main] c.g.j.s.AutoJsonRpcServiceImplExporter   : exporting bean [productRpcImpl] ---> [rpc/products]
2018-08-30 21:48:37.328 DEBUG 20852 --- [           main] c.g.j.s.AutoJsonRpcServiceImplExporter   : Registering interface 'api.ProductRpc' for JSON-RPC bean [productRpcImpl].
2018-08-30 21:48:40.683 DEBUG 20852 --- [           main] c.g.jsonrpc4j.JsonRpcBasicServer         : created server for interface interface api.ProductRpc with handler class com.sun.proxy.$Proxy89
2018-08-30 21:48:40.685  INFO 20852 --- [           main] o.s.w.s.h.BeanNameUrlHandlerMapping      : Mapped URL path [/rpc/products] onto handler '/rpc/products'
```
启动客户端
收到http请求 参数是 调用方法findOne

```java
2018-08-30 21:53:22.947 DEBUG 20852 --- [nio-8081-exec-2] com.googlecode.jsonrpc4j.JsonRpcServer   : Handling HttpServletRequest org.apache.catalina.connector.RequestFacade@5681e873
2018-08-30 21:53:22.962 DEBUG 20852 --- [nio-8081-exec-2] c.g.jsonrpc4j.JsonRpcBasicServer         : Request: {"id":"425662322","jsonrpc":"2.0","method":"findOne","params":["001"]}
2018-08-30 21:53:22.964 DEBUG 20852 --- [nio-8081-exec-2] c.g.jsonrpc4j.JsonRpcBasicServer         : Invoking method: findOne with args ["001"]
```
结果 响应信息
```java
2018-08-30 21:53:23.025 DEBUG 20852 --- [nio-8081-exec-2] c.g.jsonrpc4j.JsonRpcBasicServer         : Invoked method: findOne, result entity.Product@1f724803[id=001,name=金融1号,status=AUDITING,thresholdAmount=10.000,stepAmount=1.000,lockTerm=0,rewardRate=3.860,memo=<null>,createAt=2018-08-29 19:38:02.0,updateAt=2018-08-29 19:38:02.0,createUser=<null>,updateUser=<null>]
2018-08-30 21:53:23.064 DEBUG 20852 --- [nio-8081-exec-2] c.g.jsonrpc4j.JsonRpcBasicServer         : Response: {"jsonrpc":"2.0","id":"425662322","result":{"id":"001","name":"金融1号","status":"AUDITING","thresholdAmount":1E+1,"stepAmount":1,"lockTerm":0,"rewardRate":3.86,"memo":null,"createAt":"2018-08-29T11:38:02.000+0000","updateAt":"2018-08-29T11:38:02.000+0000","createUser":null,"updateUser":null}}
```
服务端配置类`AutoJsonRpcServiceImplExporter`
实现`BeanFactoryPostProcessor`的方法
```java
public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
    DefaultListableBeanFactory defaultListableBeanFactory = (DefaultListableBeanFactory) beanFactory;
    //<path,bean名称>
    Map<String, String> servicePathToBeanName = findServiceBeanDefinitions(defaultListableBeanFactory);
    for (Entry<String, String> entry : servicePathToBeanName.entrySet()) {
        registerServiceProxy(defaultListableBeanFactory, makeUrlPath(entry.getKey()), entry.getValue());
    }
}
```
```java
private static Map<String, String> findServiceBeanDefinitions(ConfigurableListableBeanFactory beanFactory) {
        final Map<String, String> serviceBeanNames = new HashMap<>();
        //遍历所有bean
        for (String beanName : beanFactory.getBeanDefinitionNames()) {
            //是否添加了auto rpc的注解
            AutoJsonRpcServiceImpl autoJsonRpcServiceImplAnnotation = beanFactory.findAnnotationOnBean(beanName, AutoJsonRpcServiceImpl.class);
            //判断jsonrpcservice的注解
            JsonRpcService jsonRpcServiceAnnotation = beanFactory.findAnnotationOnBean(beanName, JsonRpcService.class);
            //如果有Impl没有jsonrpcservice的注解 就报错
            if (null != autoJsonRpcServiceImplAnnotation) {
                
                if (null == jsonRpcServiceAnnotation) {
                    throw new IllegalStateException("on the bean [" + beanName + "], @" +
                            AutoJsonRpcServiceImpl.class.getSimpleName() + " was found, but not @" +
                            JsonRpcService.class.getSimpleName() + " -- both are required");
                }
                
                List<String> paths = new ArrayList<>();
                //auto上的注解会作为path，实现类上可以有额外的additionPath
                //一个rpc服务可以映射到多个服务
                Collections.addAll(paths, autoJsonRpcServiceImplAnnotation.additionalPaths());
                paths.add(jsonRpcServiceAnnotation.value());
                
                for (String path : paths) {
                    //判断格式是否合法
                    if (!PATTERN_JSONRPC_PATH.matcher(path).matches()) {
                        throw new RuntimeException("the path [" + path + "] for the bean [" + beanName + "] is not valid");
                    }
                    
                    logger.info(String.format("exporting bean [%s] ---> [%s]", beanName, path));
                    //判断是否是重复的服务，放到<路径，名称>的bean目录里
                    if (isNotDuplicateService(serviceBeanNames, beanName, path))
                        serviceBeanNames.put(path, beanName);
                }
                
            }
        }
        
        collectFromParentBeans(beanFactory, serviceBeanNames);
        return serviceBeanNames;
    }
```




chrome-network-preserve log
{% qnimg cookieresponse.jpg %}

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
{% qnimg struts2.jpg %}
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
{% qnimg tomcat.jpg %}
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
{% qnimg git.jpg %}
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

