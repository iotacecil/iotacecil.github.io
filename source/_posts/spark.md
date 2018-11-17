---
title: spark
date: 2018-11-17 09:07:12
tags:
---
### Mlib数据格式
1.本地向量`Vector.dense(1.0,2.0,3.0)` 还有位置的稀疏向量
2.监督学习xy对`LabeledPoint(1.0,Vector.dense(1.0,2.0,3.0))`
3.本地矩阵 是按列存储的 `Matrices.dense(3,3,Array(1,0,0,1,0,0,0,1)`
稀疏矩阵比较复杂
4.分布式矩阵RDD 

RDD:弹性分布式数据集 n行1列的表 行是string 没有列的概念 MLib使用
Dataset:类似csv 有列了 ml 使用
DataFrame：有列，行被封装成Row对象

### spark 配置`spark-env.sh`
https://spark.apache.org/docs/latest/configuration.html

```java
Shell:397 - Failed to locate the winutils binary in the hadoop binary path
java.io.IOException: Could not locate executable 
```
添加`System.setProperty("hadoop.home.dir", "C:\\winutils")`


### Wordcount
1.map,拆分出单词
2.reduce合并并计数单词

```scala
object WordCount {
  def main(args: Array[String]): Unit = {
    System.setProperty("hadoop.home.dir", "C:\\winutils")
    var sc = new SparkContext("local","wordcount")
        val file = sc.textFile("D:\\sparkLearn\\src\\LICENSE")
    file.flatMap(_.split(" ")).map((_,1)).reduceByKey((a,b)=> a+b).foreach(println(_))
    }
}
```

### 打包
Artifacts- Jar - From Modules  - Main class选择WordCount 
因为要发布到spark集群中运行，所以 删除所有scala的jar包 只保留工程的`compile output`
提交后生成`META-INF`-`MANIFEST.MF`
Build-Build Artifacts -Build
out里可以看到编译完的jar包

`spark-submit D:\sparkLearn\out\artifacts\sparkLearn_jar\sparkLearn.jar`


### 数据可视化 echarts
http://echarts.baidu.com/examples/

### 基础统计模块 相关性 假设检验
文档
https://spark.apache.org/docs/2.3.0/mllib-statistics.html
北京历年降水量
```scala
scala> val txt = sc.textFile("D:/sparkLearn/src/beijingdata.txt")
txt: org.apache.spark.rdd.RDD[String] = D:/sparkLearn/src/beijingdata.txt MapPartitionsRDD[6] at textFile at <console>:28

scala> txt.take(10)
res30: Array[String] = Array(0.4806,0.4839,0.318,0.4107,0.4835,0.4445,0.3704,0.3389,0.3711,0.2669,0.7317,0.4309,0.7009,0.5725,0.8132,0.5067,0.5415,0.7479,0.6973,0.4422,0.6733,0.6839,0.6653,0.721,0.4888,0.4899,0.5444,0.3932,0.3807,0.7184,0.6648,0.779,0.684,0.3928,0.4747,0.6982,0.3742,0.5112,0.597,0.9132,0.3867,0.5934,0.5279,0.2618,0.8177,0.7756,0.3669,0.5998,0.5271,1.406,0.6919,0.4868,1.1157,0.9332,0.9614,0.6577,0.5573,0.4816,0.9109,0.921)

scala> val data = txt.flatMap(_.split(",")).map(value => Vectors.dense(value.toDouble))
data: org.apache.spark.rdd.RDD[org.apache.spark.mllib.linalg.Vector] = MapPartitionsRDD[8] at map at <console>:29

scala> data.take(10)
res31: Array[org.apache.spark.mllib.linalg.Vector] = Array([0.4806], [0.4839], [0.318], [0.4107], [0.4835], [0.4445], [0.3704], [0.3389], [0.3711], [0.2669])
```
统计



### 矩阵和向量
文档
https://spark.apache.org/docs/latest/mllib-data-types.html

向量 应该使用
```scala
scala> val v2 =  breeze.linalg.DenseVector(1,2,3,4)
v2: breeze.linalg.DenseVector[Int] = DenseVector(1, 2, 3, 4)
scala> v2.
%     /=    :==     ^^=                         dot            iterator          reduceRight     unary_-
%:%   :!=   :>      active                      equals         keySet            repr            unsafeUpdate
.....
```

```scala
val v1 = Vectors.dense(1,2,3,4)
v1: org.apache.spark.mllib.linalg.Vector = [1.0,2.0,3.0,4.0]
scala> v1.
apply    asML         copy     foreachActive   numActives    size      toDense   toSparse
argmax   compressed   equals   hashCode        numNonzeros   toArray   toJson
```

矩阵
```scala
scala> val m1 = org.apache.spark.mllib.linalg.Matrices.dense(2,3,Array(1,2,3,4,5,6))
m1: org.apache.spark.mllib.linalg.Matrix =
1.0  3.0  5.0
2.0  4.0  6.0
```

```scala
scala> val m2 = breeze.linalg.DenseMatrix(Array(1,2,3),Array(4,5,6))
m2: breeze.linalg.DenseMatrix[Int] =
1  2  3
4  5  6
```

```scala
scala> val m3 = breeze.linalg.DenseMatrix(Array(1,2,3,4,5,6))
m3: breeze.linalg.DenseMatrix[Int] = 1  2  3  4  5  6
scala> m3.reshape(2,3)
res6: breeze.linalg.DenseMatrix[Int] =
1  3  5
2  4  6
```

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