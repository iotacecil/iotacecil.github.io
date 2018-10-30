---
title: Front-end questions
date: 2018-03-07 02:20:53
tags:
category: [js前端常用svgcanvasVue框架jquery源码]
---
！当你在浏览器中输入 google.com 并且按下回车之后发生了什么
https://github.com/skyline75489/what-happens-when-zh_CN/blob/master/README.rst

## html元素
`<base href="/">` 基础路径
`a[href,target]` 默认target是当前页面（在新窗口打开）
`img[src,alt]` alt图片显示失败的字
`label[for]` 加上点单选框复选框的文字也可以选中框



## queryURLParameter
### 字符串拆分法
熟练掌握 字符串方法 substr substring slice match
{% fold %}
```js
function queryURLParameter(url) {
    let obj = {};
    if (url.indexOf('?') < 0) return obj;
    let ary = url.split('?');
    url = ary[1];
    ary = url.split('&');
    for (let i = 0; i < ary.length; i++) {
        let cur = ary[i];
        curAry = cur.split('=');
        obj[curAry[0]]=curAry[1];
    }
    return obj;
}
```
{% endfold %}
### 正则
```js
String.prototype.MyURLquery=function(){
  let reg=/([^=&?]+)=([^=&?]+)/g,
      obj={}
  this.replace(reg,(...arg)=>{
    obj[arg[1]]=arg[2];
  })
  return obj;
}
```

---
## 闭包相关
```js
var a = 12;
function fn(){//变量提升声明var a但没有赋值
  console.log(a);
  var a = 13;
}
fn() //输出undefine
```
---
```js
//报错并不继续执行
console.log(a);
a=12;//没有声明var 不会变量提升
```
---
```js
var foo=1;
function bar(){
  if(!foo){//2.!undefined->true
    var foo=10;//1.变量提升
  }
  console.log(foo);
}
bar()//输出10
```
---
```js
var n =0;
function a(){
  var n =10;
  function b(){n++;console.log(n)}
}
  b()//内部执行了一次
  return b;
}
var c=a()//执行输出11
c()//输出12
console.log(n)//输出0
```
---
```js
function b(x,y,a){
  arguments[2]=10
  console.log(a)
}
c=b(1,2,3)
console.log(a)//10
```
---
```js
var ary=[1,2,3,4]
function fn(ary){
  //arr得到了全局arr的地址，可以改变全局
  ary[0]=0
  //变成另一个地址
  ary=[0]//[0]是一个地址，arr指向了新的堆内存
  ary[0]=100
  return ary
}
var res = fn(ary)
console.log(ary)//输出(4) [0, 2, 3, 4]
console.log(res)//输出[100]
```
---
```js
function fn(i){
  return function(n){
    console.log(n+(--i))
  }
}
var f = fn(2)//输出
f(3)//输出4
f(4)//4
```
---
```js
var num = 10
var obj = {num:20}//{num: 30, fn: ƒ}
obj.fn=(function(num){
                 console.log(this)//window
  this.num=num*3//自执行函数this是window
  num++//21
  return function(n){
                 console.log("内"+this)//window
    this.num+=n;
    num++//向上级作用域找//22
    console.log(num)
  }
})(obj.num)
var fn = obj.fn
fn(5)//22 //this是window
obj.fn(10)//23 此时fn的this是obj
console.log(num,obj.num)//65，30
```
---
```js
function Fn(){
  this.x=100;
  this.y=200;
  this.getX=function(){
    console.log(this.x);
  }
};
Fn.prototype={
  y:400,
  getX:function(){
    console.log(this.x);
  },
  getY:function(){
    console.log(this.y);
  },
  sum:function(){
    console.log(this.x+this.y);
  }
};
Fn.prototype.sum()//undefined+400=NaN
```
{% qnimg proto.jpg %}
---
```js
var name = 'window'
var Tom ={
  name:"Tom",
  show:function(){
    console.log(this.name)
  },
  wait:function(){
    var fun = this.show//Tom.show
    fun()//前面没有.
  }
}
Tom.wait()//window
Tom.show()//Tom
```
---



[front-end](https://github.com/markyun/My-blog/tree/master/Front-end-Developer-Questions/Questions-and-Answers)
- @import是CSS提供的，只能用于加载CSS
- 页面被加载的时，link会同时被加载，而@import引用的CSS会等到页面被加载完再加载;

#### H5
- 本地离线存储 localStorage 长期存储数据，浏览器关闭后数据不丢失;
        sessionStorage 的数据在浏览器关闭后自动删除;
- 表单控件
- [geolocation 对象](https://developer.mozilla.org/zh-CN/docs/Web/API/Geolocation/Using_geolocation)
- [Web Worker](http://www.alloyteam.com/2015/11/deep-in-web-worker/) js多线程:专用线程Dedicated Worker和共享线程 Shared Worker;Dedicated Worker只能为一个页面所使用，而Shared Worker则可以被多个页面所共享

- 离线缓存manifest 新建的.appcache文件的缓存机制(不是存储技术)像cookie一样缓存清单上的资源。
> 如何使用：
  1、页面头部像下面一样加入一个manifest的属性；
  2、在cache.manifest文件的编写离线存储的资源；
  	CACHE MANIFEST
  	#v0.11
  	CACHE:
  	js/app.js
  	css/style.css
  	NETWORK:
  	resourse/logo.png
  	FALLBACK:
  	/ /offline.html
  3、在离线状态时，操作window.applicationCache进行需求实现。


- html5shim  HTML5 styling for Internet Explorer 6-9, Safari 4.x (and iPhone 3.x), and Firefox 3.x.
```html
 <!--[if lt IE 9]>
  		<script> src="http://html5shim.googlecode.com/svn/trunk/html5.js"</script>
  	 <![endif]-->
```