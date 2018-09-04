---
title: go
date: 2018-08-27 14:02:17
tags:
category: [go语言]
---
### 对象 没有继承和多态 只有封装 只有struct
构造
```go
type treeNode struct{
    value int
    left,right *treeNode
}
func main() {
    var root treeNode
    root = treeNode{value:3}
    root.left = &treeNode{}
    root.right = &treeNode{}
    root2 :=treeNode{3,nil,nil}
    root.right.left = new(treeNode)

    nodes:= []treeNode{
        {value:3},
        {},
        {6,nil,&root},
    }
    //{3 0xc04205c400 0xc04205c420}
    fmt.Println(root)
    //{3 <nil> <nil>}
    fmt.Println(root2)
    // [{3 <nil> <nil>} {0 <nil> <nil>} {6 <nil> 0xc04205c3e0}]
    fmt.Println(nodes)
}
```
没有构造函数可以写工厂函数
局部变量的地址也能返回给外面用
```go
func factory(value int)*treeNode{
    return &treeNode{value:value}
}
```



### 容器
支持中文的go
```go
package main

import (
    "fmt"
    "unicode/utf8"
)
func lengthOfLongestSubstringrune(s string) int {
    lastcur := make(map[rune]int)
    start :=0
    maxLength :=0

    for i,ch:=range []rune(s){
        if lastI,ok:=lastcur[ch];ok&&lastI>=start{
            start = lastcur[ch]+1
        }
        if(i-start+1>maxLength) {
            maxLength = i - start + 1
        }
        lastcur[ch] = i;
    }
    return maxLength;
}
func main() {
    s:="中文中文中文字符串我"
    fmt.Println(len(s))
    for _,b := range []byte(s){
        //utf-8的编码
        fmt.Printf(" %X ",b)
    }
    fmt.Println(s)

    for i,ch := range s{
        //unicode
        fmt.Printf("(%d, %X) ",i,ch)
    }
    fmt.Println(utf8.RuneCountInString(s))

    bytes := []byte(s)
    for len(bytes)>0{
        ch,size :=utf8.DecodeRune(bytes)
        bytes = bytes[size:]
        fmt.Printf("%c ",ch)
    }
    fmt.Println()
//每个rune占了4个字节 另外开了一个rune数组
    for i,ch := range []rune(s){
        fmt.Printf("(%d %c)",i,ch)
    }
    fmt.Println(lengthOfLongestSubstringrune("中文字符串中文中文"))
}
```


Map
除了slice map function其他内建类型都可以当key
struct不包含上面三个也可以当key
```go
func main() {
    m := map[string]string{
        "A":    "a",
        "B":  "b",
        "C":    "c",
        "D": "d",
    }

    m2 := make(map[string]int) // m2 == empty map

    var m3 map[string]int // m3 == nil
// map[A:a B:b C:c D:d] map[] map[]
    fmt.Println(m, m2, m3)
// B b
// C c
// D d
// A a
    for k,v:=range m{
        fmt.Println(k,v)
    }
    //a
    courseName := m["A"]
    fmt.Println(courseName)
    //  false 不存在也会输出空串
    courseName ,ok:= m["dd"]
    fmt.Println(courseName,ok)

    if courseName ,ok:= m["dd"];ok{
        fmt.Println(courseName)
    }else{
        fmt.Println("not Exist")
    }
    //删除
    delete(m,"D")
}
```

数组初始化
```go
func main() {
    var arr1 [5]int
    arr2 := [3]int{1,3,5}
    arr3 := [...]int{2,4,6,8,10}
    fmt.Println(arr1,arr2,arr3)
    var grid [4][5] int
    fmt.Println(grid)
}
```
遍历
```go
for _,v:=range arr3{
        fmt.Println(v)
    }
```

数组是值类型传到func中不会改变
```go
func printArray(arr [5]int)  {
    arr[0]=100
    for i,v:=range arr{
        fmt.Print(i,v," ")
    }
    fmt.Print("\n")
}
func main(){
    arr3 := [...]int{2,4,6,8,10}
    printArray(arr3)
    for i,v:=range arr3{
        fmt.Print(i," ",v," ")
    }
}
```

用指针可以改变
```go
func printArray(arr *[5]int)  {
    arr[0]=100
    for _,v:=range arr{
        fmt.Print(v," ")
    }
    fmt.Print("\n")
}
func main(){
    arr3 := [...]int{2,4,6,8,10}
    //100 4 6 8 10 
    // 100 4 6 8 10 
    printArray(&arr3)
    for _,v:=range arr3{
        fmt.Print(v," ")
    }
}
```

切片Slice
```go
arr:=[...]int {1,2,3,4,5,6,7,8}
// [3 4 5 6 7 8]
s:=arr[2:]
fmt.Println(s)
s[1] =100
//[1 2 3 100 5 6 7 8]
fmt.Println(arr)
```

切片可以扩展
```go
arr:=[...]int {1,2,3,4,5,6,7,8}
s:=arr[2:4]
//6
fmt.Println(cap(s))
//[6 7 8]
fmt.Println(s[3:6])
//[3 4 999] 必须接受append的返回值
s2:=append(s, 999)
fmt.Println(s2)
//[1 2 3 100 999 6 7 8]
//如果append超过了cap 会创建新的数组
fmt.Println(arr)
```

创建切片
```go
var s3[] int;
    for i:=0;i<100;i++{
// len:  0  cap:  0
// len:  1  cap:  1
// len:  2  cap:  2
// len:  3  cap:  4
// len:  4  cap:  4
// len:  5  cap:  8
        fmt.Println("len: ",len(s3)," cap: ",cap(s3))
        s3 = append(s3,2*i+1)
    }
    fmt.Println(s3)
s4 := [] int{1,2,3,4,5}
fmt.Println(s4)
s5 := make([]int,16)
fmt.Println(s5)
s6 := make([]int,16,32)
fmt.Println(s6)
```
拷贝
```go
//s5:[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
//s4:[1 2 3 4 5]
copy(s5,s4)
//s5:[1 2 3 4 5 0 0 0 0 0 0 0 0 0 0 0]
fmt.Println(s5)
```

删除
```go
//删掉3
s=append(s[:3],s[4:]...)
//pop
front := s[0]
s = s[1:]

//pop
tail = s[len(s)-1]
s = s[:len(s)-1] 
```


### 基础语法
变量
simple application
```go
package main

import "fmt"
//包内变量
var aa = 3
var ss = "kkk"
var(
    dd=3
    bb=2)
func variable()  {
    var a int
    var s string
    fmt.Println(a,s)
    fmt.Printf("%d %q\n",a,s)
}

func variableInit(){
    var a,b int=3,4
    var s string = "abc"
    fmt.Println(a,b,s)
}
func varDeduction()  {
    var a,b,c,s = 3,4,true,"def"
    fmt.Println(a,b,c,s)
}
func varShorter()  {
    a,b,c,s := 3,4,true,"def";
    fmt.Println(a,b,c,s);
}

func main() {
    fmt.Println("Hello world")
//Hello world
// 0 
// 0 ""
    variable()
//3 4 abc
    variableInit()
    varDeduction()
    varShorter()
}
```

内建变量
char用rune为了国际化 32位的 utf8很多字符都是3字节的用4字节的int32表示rune
byte 8位
byte和rune可以和整数混用，就是整数的别名

常量 一般go语言常量不大写
```go
import (
    "fmt"
    "math"
)
func consts(){
    const filename = "abc.txt"
    const a,b = 3,4
    var c int
    c = int(math.Sqrt(a*a+b*b))
    fmt.Println(filename,c)
}
func main(){
    // abc.txt 5
    consts()
}
```

枚举
```java
func enums()  {
    const(
        cpp = 0
        java = 1
        python = 2
        golang = 3
    )
    fmt.Println(cpp,java,python,golang)
}
func enumsiota()  {
    const(
        cpp = iota
        java
        python
        golang
    )
    fmt.Println(cpp,java,python,golang)
    const(
        b = 1<<(10*iota)
        kb
        mb
        gb
        tb
        pb
    )
    // 1 1024 1048576 1073741824 1099511627776 1125899906842624
    fmt.Println(b,kb,mb,gb,tb,pb)
}
func main() {
    enums()
    //0 1 2 3 4
    enumsiota()
}
```

条件语法
```go
func bounded(v int) int{
    if v>100{
        return 100
    }else if v<0{
        return 0
    }else{
        return v
    }
}
```
读文件，是个byte数组
```go
package main

import (
    "io/ioutil"
    "fmt"
)

func main() {
    const filename = "file.txt"
    contents, err := ioutil.ReadFile(filename)
    if err != nil {
        fmt.Println(err)
    }else{
        fmt.Printf("%s\n",contents)
    }
}
```
像for一样写if 赋值之后再做判断
```go
if contents,err:= ioutil.ReadFile(filename);err!=nil{
    fmt.Println(err)
}else{
    fmt.Printf("%s\n",contents)
}
```

switch 每个case后默认break，除非用fallthrough
```go
func grade(score int) string {
    g := ""
    switch {
    case score < 0 || score > 100:
        panic(fmt.Sprintf(
            "Wrong score: %d", score))
    case score < 60:
        g = "F"
    case score < 80:
        g = "C"
    case score < 90:
        g = "B"
    case score <= 100:
        g = "A"
    }
    return g
}
func main(){
// panic: Wrong score: 101

// goroutine 1 [running]:
// main.grade(0x65, 0x4cffc1, 0x1)
//     D:/goLearn/branch.go:12 +0x154
// main.main()
//     D:/goLearn/branch.go:43 +0x125
    fmt.Println(
    grade(1),
    grade(99),
    grade(70),
    grade(101),
    )
}
```

循环 10进制转2进制
```go
package main

import (
    "fmt"
    "strconv"
)

func convert2Bin(n int) string  {
    result := ""
    if n==0{
        return "0"
    }
    for ; n>0;n/=2{
        lsb:= n%2
        result = strconv.Itoa(lsb) + result
    }
    return result
}
func main() {
    fmt.Println(
        convert2Bin(5),
        convert2Bin(13),
        convert2Bin(99999999999999),
        convert2Bin(0),
    )
}
```

按行读文件 没有wile，只有for
```go
import (
    "fmt"
    "strconv"
    "os"
    "bufio"
)
func fileLine(filename string){
    file,err :=os.Open(filename)
    if err !=nil{
        panic(err)
    }
    scanner := bufio.NewScanner(file)
    for scanner.Scan(){
        //读一行
        fmt.Println(scanner.Text())
    }
}
func main(){
    fileLine("file.txt")
}
```

死循环
```go
func forever(){
    for{
        fmt.Println("abc")
    }
}
```

函数
带余数除法：
```go

func div(a,b int) (int , int)  {
    return a/b,a%b
}
func divname(a,b int) (q,r int)  {
    q = a/b
    r = a%b
    return
}
func main() {
    fmt.Println(div(3,4))
    q,r := divname(3,4)
    fmt.Println(q,r)
}
```

只想用第一个返回值 第二个用`_` 其他都会报unused，iota递增也可以用`_`表示跳过
```go
func eval(a, b int, op string) (int, error) {
    switch op {
    case "+":
        return a + b, nil
    case "-":
        return a - b, nil
    case "*":
        return a * b, nil
    case "/":
        q, _ := divname(a, b)
        return q, nil
    default:
        return 0, fmt.Errorf(
            "unsupported operation: %s", op)
    }
}
```

函数式编程，传递func给func,匿名函数
```go
func apply(op func(int,int)int,a,b int) int {
    p := reflect.ValueOf(op).Pointer()
    name := runtime.FuncForPC(p).Name()
    fmt.Println(name)
    return op(a,b)

}
func pow(a,b int) int  {
    return int(math.Pow(float64(a),float64(b)))
}
func main(){
    //main.pow
    apply(pow,3,4)
    //main.main.func1
    fmt.Println(apply(func(a int, b int) int {
        return int(math.Pow(a,b))
    },3,4))
}
```
可变参数列表,求和
```go
func sum(number ...int)int{
    s:=0
    for i:= range number{
        s+=number[i]
    }
    return s
}
func main(){
    fmt.Println(sum(1,2,3,4,5,5,6))
}
```

指针 指针不能运算
cpp的值传递和引用传递
```cpp
void pass_by_val(int a){a++;}
void pass_by_ref(int& a){a++;}
int main(){
    int a=3;
    pass_by_val(a)
    //3
    cout<<a;
    pass_by_val(a)
    //4
    cout<<a;
}
```

go 语言全是值传递，引用传递要用指针
```go
func swap(a,b *int)   {
    *a,*b = *b,*a
}
//不可变类型的swap
func swap2(a,b int) (a2,b2 int)  {
    return b,a
}
func main() {
    a,b:=3,4
    swap(&a,&b)
    fmt.Println(a,b)
    a,b = swap2(a,b)
    fmt.Println(a,b)
}
```



