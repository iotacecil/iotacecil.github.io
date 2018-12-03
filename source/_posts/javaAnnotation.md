---
title: 反射&静态代理&动态代理
date: 2018-03-06 00:02:50
tags: [java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---

## Spring代理
1. Bean有实现接口：用JDK动态代理
2. 没有实现接口用CGlib
强制使用CGlib
https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop-api
`<aop:aspectj-autoproxy proxy-target-class="true"/>`

## 注解
```java
@Target(ElementType.TYPE)//类注解
@Retention(RetentionPolicy.SOURCE)//编译时会被忽略
public @interface ThreadSafe {
    String value() default "";
}
```


## 静态代理：为对象提供一种代理，控制这个对象的访问
1. 对一个方法添加计算时间的业务
2. 静态代理在于在运行期之前就有已经写好的`actionProxy implements Action`代理类
{% fold %}
```java
//3.在真正的业务方法之前取一下时间，计算耗时
//分离业务逻辑 同时实现相同的接口 代理使用（当作一个属性）业务类
class actionProxy implements Action{
    public Action action;//被代理对象
    public actionProxy(Action action){
        this.action= action;
    }
    public void doAction(){
        //可以添加权限操作
        long start = System.currentTimeMillis();
        action.doAction();
        long end = System.currentTimeMillis();
        System.out.println("耗时"+(end-start));
    }
}
//1.通过一个接口
interface Action{
    public void doAction();
}
//2. 接口的实现类是具体的工作
//没有代理的时候这个类依然能正常使用
class UserAction implements Action{
    public void doAction(){
        System.out.println("用户工作逻辑");
    }
}
public class staticproxy {
    public static void main(String[] args) {
        Action action = new UserAction();
        actionProxy pro = new actionProxy(action);
        pro.doAction();
    }
}
```
{% endfold %}

## 反射 java.lang.reflect.*
- 在运行中分析类能力；
运行中查看对象；Method对象
- Class 是java基础类。虚拟机创建Class的实例。
1. 三种方法获取class：`对象.getClass`。`类.class`。`Class.forName`（抛异常）
2. 实例化对象：
	1. `Class cls = Class.forName(className)` （静态方法）获得类名的Class对象
	2. `cls.newInstance()`调用className的默认无参构造方法，返回className类型)
	3. 获取所有构造方法
	```java
	Constructor<?>[] cs = acla.getDeclaredConstructors();
	```
	`getModifiers()`获得修饰符
	4. 获得指定参数的构造方法 会抛异常
	```java
	Constructor<Bank> c = b.getConstructor(Integer.class,Integer.class);
	```
	5. 通过构造器得到实例 抛异常
	```java
	c.newInstance(1,3);
	```
3. 获取类的所有成员变量，`get/set`设置获取属性
	```java
	//获取public
	Field[] fi = bb.getFields();
	//获取所有属性包括私有属性
	Field[] dd = bb.getDeclaredFields();
	```
	获取修饰符
	```java
	int modifiers = f.getModifiers();
    System.out.println(Modifier.toString(modifiers));
	```
4. 获取所在的包`Package getPackage()`
5. 获取公共方法（包括继承Object的
	```java
	Method[] methods = bb.getMethods();
	//调用方法
	methods[0].invoke(对象,参数);
	```
	`getDeclaredFields()`不包含父类方法，包括私有方法。
	但是私有方法不能`invoke`
	调用私有方法:去除修饰符检查
	```java
	 methods[3].setAccessible(true);
	 methods[3].invoke(b);
	```

## 动态代理
可以代理多个接口
{% fold %}
```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
//1.生成代理类的类
class CreateProxy implements InvocationHandler{
    //2.被代理的对象
    private Object target;
    //3 创建代理的方法
    public Object create(Object target){
        this.target=target;
        //获得所有的接口getInterfaces
        Object proxy = Proxy.newProxyInstance(
            target.getClass().getClassLoader(), 
            target.getClass().getInterfaces(), 
            this);
        return proxy;
    }
    //4.业务代码
    @Override
    //代理类，被代理的方法，方法的参数
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("开始");
        method.invoke(target,args);
        System.out.println("结束");
        return null;
    }}
class Person implements Subject{
    public void shopping(){
        System.out.println("买东西");
    }}
interface Subject{
    public void shopping();
}
public class dynamicProxy {
    public static void main(String[] args) {
        //创建代理对象的对象
        CreateProxy cp = new CreateProxy();
        //被代理的对象
        Subject person = new Person();
        //代理 强制转换成被代理的类型
        Subject proxy = (Subject)cp.create(person);
        //会调用invoke
        proxy.shopping();
    }}
```
{% endfold %}
---
多一个接口,使用同一个代理对象
```java
interface Hotel{public void live();}
class Person implements Subject,Hotel{live(){}}
@Test
CreateProxy cp = new CreateProxy();
Person person = new Person();
Hotel proxy = (Hotel) cp.create(person);
proxy.live();
```
1. `proxy.getClass().getName()` 是$Proxy0 不是InvocationHandler类型，是运行时动态生成的一个对象。
```java
 Object proxy = Proxy.newProxyInstance(
    target.getClass().getClassLoader(), 
    target.getClass().getInterfaces(), 
    this);
```

### `.newProxyInstance`实现

#### `JavaCompiler`编译器

## cglib动态代理（类）
底层使用SM字节码生成

### 类加载器
[类加载器](http://www.cnblogs.com/aspirant/p/7200523.html)
类加载：.class文件中的二进制数据，读入内存方法区，在堆中创建Class对象，封装方法区中的对象。
主动引用
被动引用

### JavaBean规范 private,get/set能被IDE识别
Apache BeanUtils

### 内省


### Java探针agent

#### 注解
编译时注解 JDK：@Override，@Deprecated，@Suppvisewarnings
@Autowired 自动注入

#### 异常
1. 未检查异常:访问null引用 不查看异常处理器（handler)
2. 已检查异常：编译器检查是否提供了处理器> 无处理器> 终止
- Throwable 是Exception类的超类 
```java
catch(Exception e){
	e.printStackTrace()
}
```
