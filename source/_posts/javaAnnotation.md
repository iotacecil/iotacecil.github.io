---
title: 反射&静态代理&动态代理
date: 2018-03-06 00:02:50
tags: [java]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
## 反射 java.lang.reflect.*
![reflect.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/reflect.jpg)

> 反射机制是 Java 语言提供的一种基础功能，赋予程序在运行时自省（introspect，官方用语）
的能力。通过反射我们可以直接操作类或者对象，比如获取某个对象的类定义，获取类声明的属
性和方法，调用方法或者构造对象，甚至可以运行时修改类定义。
过运行时操作元数据或对象，Java 可以灵活地操作运行时才能确定的信息。

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

#### AccessibleObject
反射提供的 AccessibleObject.setAccessible (boolean flag)。
它的子类也大都重写了这个方法，这里的所谓 accessible 可以理解成修饰成员
的 public、protected、private，这意味着我们可以在运行时修改成员访问限制！

setAccessible 的应用场景非常普遍，遍布我们的日常开发、测试、依赖注入等各种框架中。
1. 比如，在 O/R Mapping 框架中，我们为一个 Java 实体对象，运行时自动生成 setter、getter 的逻辑，这是加载或者持久化数据非常必要的，框架通常可以利用反射做这个事情，而不需要开发
者手动写类似的重复代码。

2. 绕过 API 访问控制。我们日常开发时可能被迫要调用内部 API 去做些事情，比如，自定义的高性能NIO框架需要显式地释放DirectBuffer，使用反射绕开限制是一种常见办法。

在 Java 9 以后 引入了 Open 的概念，只有当被反射操作的模块和指定的包对反射调用者模块 Open，才能使用 setAccessible；




## 注解
```java
@Target(ElementType.TYPE)//类注解
@Retention(RetentionPolicy.SOURCE)//编译时会被忽略
public @interface ThreadSafe {
    String value() default "";
}
```

代理模式：为其他对象 提供一种代理以控制对这个对象的访问。
代理类负责为委托类进行预处理 （安全检查、权限检查）或执行完转发给其它代理。

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



## 动态代理
> 动态代理是一种方便运行时动态构建代理、动态处理代理方法调用的机制，很多场景都是利用类
似机制做到的，比如用来包装 RPC 调用、面向切面的编程（AOP）。

通过代理可以让调用者与实现者之间解耦。比如进行 RPC 调用，框架内部的寻址、序列化、反
序列化等，对于调用者往往是没有太大意义的，通过代理，可以提供更加友善的界面。

简单指定一组接口及委托类对象，动态获得代理类。

- 动态代理是基于什么原理？

实现动态代理的方式很多，比如 JDK 自身提供的动态代理，就是主要利用了反射机
制。还有其他的实现方式，比如利用传说中更高性能的字节码操作机制，类似 ASM、cglib（基
于 ASM）、Javassist 等。

### .reflect.Proxy 静态方法，动态生成代理类及其对象
![Proxy.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/Proxy.jpg)

### .reflect.InvocationHandler
//代理类实例、被调用的方法对象、调用参数。进行预处理或分配到委托类实例上执行。
`public Object invoke(Object proxy, Method method, Object[] args)`

### 动态代理创建对象的4步
1.实现`InvocationHandler` 创建调用处理器
2.指定`ClassLoader`对象和一组`interface`创建动态代理类。
`Class clazz = Proxy.getProxyClass(classLoader,new Class[]{});`
3.通过反射获得动态代理类的构造函数，参数类型是调用处理器接口
`Constructor constructor = clazz.getConstructor(new Class[]{InvocationHandler.class});`
4.通过构造函数创建动态代理类实例，将调用处理器作为参数
`Interface Proxy = (Interface)construct.newInstance(new Object[]{handle});`

#### JDK实现
这种实现仍然有局限性，因为它是以接口为中心的，相当于添加了一种对于被调用者没有太大意义的限制。
我们实例化的是Proxy对象，而不是真正的被调用类型，这在实践中还是可能带来各种不便和能力退化。

#### Spring代理
1. Bean有实现接口：用JDK动态代理
2. 没有实现接口用CGlib 对接口的依赖被克服了

强制使用CGlib
https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop-api
`<aop:aspectj-autoproxy proxy-target-class="true"/>`

#### cglib和jdkproxy
cglib 动态代理采取的是创建目标类的子类的方式，因为是子类化，我们可以达到近似使用被调
用者本身的效果。

- JDK Proxy 的优势：
最小化依赖关系，减少依赖意味着简化开发和维护，JDK 本身的支持，可能比 cglib 更加可
靠。
平滑进行 JDK 版本升级，而字节码类库通常需要进行更新以保证在新版 Java 上能够使用。
代码实现简单。

- 基于类似 cglib 框架的优势：
有的时候调用目标可能不便实现额外接口，从某种角度看，限定调用者实现接口是有些侵入
性的实践，类似 cglib 动态代理就没有这种限制。
只操作我们关心的类，而不必为其他相关类增加工作量。
高性能。

`Proxy`中的`newInstance`封装了2-4直接返回了4
```java
@CallerSensitive
public static Object newProxyInstance(ClassLoader loader,
                                      Class<?>[] interfaces,
                                      InvocationHandler h)
    throws IllegalArgumentException
{
    Objects.requireNonNull(h);

    final Class<?>[] intfs = interfaces.clone();
    final SecurityManager sm = System.getSecurityManager();
    if (sm != null) {
        checkProxyAccess(Reflection.getCallerClass(), loader, intfs);
    }

    /*
     * Look up or generate the designated proxy class.
     */
    Class<?> cl = getProxyClass0(loader, intfs);

    /*
     * Invoke its constructor with the designated invocation handler.
     */
    try {
        if (sm != null) {
            checkNewProxyPermission(Reflection.getCallerClass(), cl);
        }

        final Constructor<?> cons = cl.getConstructor(constructorParams);
        final InvocationHandler ih = h;
        if (!Modifier.isPublic(cl.getModifiers())) {
            AccessController.doPrivileged(new PrivilegedAction<Void>() {
                public Void run() {
                    cons.setAccessible(true);
                    return null;
                }
            });
        }
        return cons.newInstance(new Object[]{h});
    } catch (IllegalAccessException|InstantiationException e) {
        throw new InternalError(e.toString(), e);
    } catch (InvocationTargetException e) {
        Throwable t = e.getCause();
        if (t instanceof RuntimeException) {
            throw (RuntimeException) t;
        } else {
            throw new InternalError(t.toString(), t);
        }
    } catch (NoSuchMethodException e) {
        throw new InternalError(e.toString(), e);
    }
}
```

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
底层使用SM字节码生成比java反射效率高，但是要注意final
通过继承和重写

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
