---
title: spark
date: 2018-11-17 09:07:12
tags:
---
### currying 函数 两个变量的函数变成两个分次传入
```scala
def sum2(a:Int)(b:Int) = a+b
println(sum2(3)(5)) //8
```

### scala 多行字符串
```scala
// 多行字符串
var b =
s"""
|多行字符串
|$name
""".stripMargin
println(b)
```

### Scala 模式匹配`match case`匹配类型
```scala
matchType(Map("name" -> "PK"))
def matchType(obj:Any): Unit ={
    obj match{
      case x:Int => println("Int")
      case s:String => println("String")
      case m:Map[_,_] => m.foreach(println)
    }
}
```

### Scala的apply 伴生对象
```scala
object ApplyApp {
  def main(args: Array[String]): Unit = {
    /* out：
    调用伴生对象
     1
     */
    ApplyTest.incr
    println(ApplyTest.count)
//   out: 伴生对象 调用了aply方法
//        调用了类
    val applyObj = ApplyTest()

    /** out:
      * 调用了类
      * com.start.ApplyTest@4e9ba398
      */
    val applyClass = new ApplyTest()
    println(applyClass)
    // out:伴生类 调用类的apply方法
    applyClass()
  }
  
}

// 同名 class和object
class ApplyTest{
  println("调用了类")
  def apply() = {
    println("伴生类")
  }

}
// 单例对象
object ApplyTest{
  println("调用伴生对象")
  var count = 0
  def incr = {
    count = count + 1
  }

  // 最佳实践：在object的apply中new Class
  def apply(): ApplyTest =  {
    println("伴生对象")
    new ApplyTest
  }

}
```

#### caseClass
```scala
object CaseClass {
  def main(args: Array[String]): Unit = {
    println(Dog("namename").name)
  }
}
case class Dog(name:String)
```

#### trait
第一个用`extends` 后面用`with`