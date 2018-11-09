---
title: About-js
date: 2018-04-17 17:06:31
tags:
category: [js前端常用svgcanvasVue框架jquery源码]
---
### 控制台导入jq发送ajax
https://zju.date/ajax-request-in-chrome-console/
不使用contentType: “application/json”则data可以是对象

使用contentType: “application/json”则data只能是json字符串
```javascript
var jq = document.createElement('script');  
jq.src = 'http://7xsy2w.com1.z0.glb.clouddn.com/jquery-3.1.1.min.js'; //也可以放本地服务器上
document.getElementsByTagName('head')[0].appendChild(jq);
j=jQuery
j.noConflict();
j.ajax({
    url: 'http://localhost:8080/test/',
    type: "POST",
    data: usr,
contentType:"application/json;charset=utf-8",
    dataType: "json",
    success:function() {console.log('发送成功！'); },
    error:function() { console.log('发送失败！'); }
});
```

### 手机端查看页面
`npm install http-server -g`
`http-server`

### prototype
http://prototypejs.org/learn/event-delegation.html

### js unicode->中文
```js
unescape('');
```

### h5视频控制
到指定位置并播放
```js
var v = document.getElementsByTagName("video")[0];
v.currentTime = 10.0;
v.play()
//暂停
v.pause()
```

### html5存储
Content-Length 单位是字节
DnionOS nginx？

#### cookie 4k
`document.cookie`
cookies会有主域名污染 
在.baidu.com放了cookie之后music子域名访问都带主域名的cookies，请求头会臃肿
http-only cookie只能被服务器端读写，客户端无权限。
Secure 请求只能是https 

单个域名持支的cookie个数。chrome50个，长度4k 
与localStorage类似 不同域名独立。
可以设置cookie的path和domain相同父域共享

#### H5之前userData 只有IE，存放成XML

#### indexedDB 按域名分配独立空间，一个域名多个数据库

#### H5离线缓存 manifest
{% qnimg appcache.jpg %}
`navigator.onLine`检测是否在线
```html
<html lang = "en" manifest = 'manifestFile'>
```
manifestFile文件
```
CACHE MANIFEST
#version 1.1
CACHE:
  img/1.jpg
NETWORK
```
```js
window.addEventListener('load',function(e){
  window.applicationCache.addEventListener('updateready',function(e){
    if(window.applicationCache.status == window.applicationCache.UPDATEREADY){
      window.applicationCache.swapCache()
      if(confirm("是否更新页面"))
        window.location.reload()
    }
  },fasle)
},false)
```
改manifest版本号会更新

#### 本地存储 子域名不能共享
> h5 postMessage 共享数据

只有5个api：setItem/getItem/removeItem/clear/key
ios的隐身模式没有，需要检测浏览器支持，最好的方法是先set一次
```js
localStorage.setItem('testkey','testvalue')
localStorage.getItem('testkey')
localStorage.key(9)
localStorage.clear()
```
localstorage 永不过期
sessionstorage 重新打开页面/关闭浏览器 消失

每个 域名5M
localStroage在chrome限制为2.6M 同域名一般共享

所有可以序列化的都能存到localStorage

存图片
{% qnimg localstorage.jpg %}
`set('key')`+`get('key')`
{% fold %}
```js
var src = "./bd_logo1.png"
function set(key){
    var img = document.createElement('img')
    img.addEventListener('load',function () {
        var imgCanvas = document.createElement("canvas"),
            imgContext = imgCanvas.getContext("2d");
        imgCanvas.width = this.width;
        imgCanvas.height = this.height;
        imgContext.drawImage(this,0,0,this.width,this.width);
        //base64 url图片
        var imgAsDataUrl = imgCanvas.toDataURL("image/png")
        try{
            localStorage.setItem(key,imgAsDataUrl)
        }
        catch(e){
            console.log("storage failed"+e)
        }},false);
    img.src = src;
}
function  get(key) {
    var srcStr =localStorage.getItem(key)
    var imgObj = document.createElement('img')
    imgObj.src = srcStr
    document.body.appendChild(imgObj)

}
```
{% endfold %}
业务代码添加过期控制`set('wait4expire','expire')`,`get('wait4expire',60*5*1000)`
```js
function set(key,v){
    var curTime = new Date().getTime()
    localStorage.setItem(key,JSON.stringify({data:v,time:curTime}))
}
function get(key,exp) {
    var data = localStorage.getItem(key)
    var dataObj = JSON.parse(data)
    if(new Date().getTime() - dataObj.time > exp){
        console.log("expires")
    }else{
        console.log("data = "+dataObj.data)
    }
}
```


1. HTTP文件缓存
Application-Frames
Etag响应/if-Node-Match请求
同时设置Expire和Cache-Control只有Cache-Control生效











### 浏览器缓存
https://segmentfault.com/a/1190000009638800

### Connection
https://imququ.com/post/transfer-encoding-header-in-http.html
HTTP/1.0 的持久连接机制是后来才引入的，通过 Connection: keep-alive 这个头部来实现，服务端和客户端都可以使用它告诉对方在发送完数据之后不需要断开 TCP 连接，以备后用。HTTP/1.1 则规定所有连接都必须是持久的，除非显式地在头部加上 Connection: close。所以实际上，HTTP/1.1 中 Connection 这个头部字段已经没有 keep-alive 这个取值了，但由于历史原因，很多 Web Server 和浏览器，还是保留着给 HTTP/1.1 长连接发送 Connection: keep-alive 的习惯。

浏览器可以通过 Content-Length 的长度信息，判断出响应实体已结束。那如果 Content-Length 和实体实际长度不一致会怎样？有兴趣的同学可以自己试试，通常如果 Content-Length 比实际长度短，会造成内容被截断；如果比实体内容长，会造成 pending。

TTFB（Time To First Byte），它代表的是从客户端发出请求到收到响应的第一个字节所花费的时间。

在头部加入 Transfer-Encoding: chunked 之后，就代表这个报文采用了分块编码。这时，报文中的实体需要改为用一系列分块来传输。每个分块包含十六进制的长度值和数据，长度值独占一行，长度不包括它结尾的 CRLF（\r\n），也不包括分块数据结尾的 CRLF。最后一个分块长度值必须为 0，对应的分块数据没有内容，表示实体结束。
```js
require('net').createServer(function(sock) {
    sock.on('data', function(data) {
        sock.write('HTTP/1.1 200 OK\r\n');
        sock.write('Transfer-Encoding: chunked\r\n');
        sock.write('\r\n');

        sock.write('b\r\n');
        sock.write('01234567890\r\n');

        sock.write('5\r\n');
        sock.write('12345\r\n');

        sock.write('0\r\n');
        sock.write('\r\n');
    });
}).listen(9090, '127.0.0.1');
```

### webworkers
《高性能网站建设进阶指南》
https://www.html5rocks.com/en/tutorials/workers/basics/
{% qnimg webworkers.jpg %}
{% qnimg XHR.jpg %}
```js
 var worker = new Worker("./worker.js")
    console.log("主线程主线程主线程主线程1")//1
    worker.addEventListener("message",function(e){
        console.log("主线程主线程主线程主线程2")//8
        console.log("worker said",e.data)//9
        console.log("主线程主线程主线程主线程3")//10
    },false)
    console.log("主线程主线程主线程主线程4")//2
    worker.postMessage("hello world");
    console.log("主线程主线程主线程主线程5")//3
//worker.js
console.log("子线程0")//4
self.addEventListener("message",function(e){
    console.log("子线程1")//6
    self.postMessage(e.data)
    console.log("子线程2")//7
},false)
console.log("子线程3")//5
```


### fisher-yates 洗牌
>shuffle the deck first to randomize the order and insure a fair game
O(n)

```js
function shuffle(array){
  var m = array.length,t,i;
  while(m){
    //99...0
    i = Math.floor(Math.random()*m--);
    t = array[m];
    array[m] = array[i];
    array[i] = t;
  }
  return array;
}
```
测试shuff如果5x2一共10个格，雷5个，则出现的概率应该都是0.5
```js
function testshuff (N,n,m,num){
  var freq = Array();
  for(var i=0;i<m*n;i++)
  freq[i]=0;
  var arr = Array() 
for(var test=0;test<N;test++){
  for(var i = 0;i<num;i++){
    arr[i]=1;
    }
  for(var i = num;i<m*n;i++)
    {
    arr[i]=0;
    }
shuffle(arr)
//console.log(arr)
  for(var j=0;j<n*m;j++){
  freq[j]+=arr[j];
    }
}
for(var i =0;i<n*m;i++){
console.log(i+" "+freq[i]/N);
}
}
```

假装做个扫雷 生成nxm大小的格子里面有num个雷,并且打乱它
```js
function generate(n,m,num){
  var mines = new Array()
  let x,y;
  for(var i =0;i<n;i++){
     mines[i]=new Array();
      for(var j=0;j<m;j++){
      mines[i][j]=0;
      }
  }
  while(num){
    x= Math.floor(Math.random()*n);
    y= Math.floor(Math.random()*m);
    //一定要加，不然雷数少于num
    if(mines[x][y]===0){
      mines[x][y]=1;
      num--;
    }
  }
  return mines;
}
function shuff2d(mines,n,m){
  var t,ix,iy,ranx,rany;
    for(var i = n*m-1;i>=0;i--){
    ix = Math.floor(i/m);
    iy = i%m;
    var random = Math.floor(Math.random()*(i+1));
    ranx = Math.floor(random/m);
    rany = random%m;
    t = mines[ix][iy];
    mines[ix][iy]=mines[ranx][rany];
    mines[ranx][rany]=t;
    }
}
```

其他要设置用户点击open[][],这个点周围有多少雷cnt[][]，用户插旗坐标flag[][]
另外 点开不是数字的地方要扩展


### window.getSelections()
https://developer.mozilla.org/zh-CN/docs/Web/API/Window/getSelection
### css 伪类选择器的not
css权重计算？
{% qnimg cssnot.png %}
```html
<head>
 <style>
        p:not(.classy) { color: red; }
        body :not(p) { color: green; }
    </style>
</head>
<body>
<p>Some text.</p>
<p class="classy">就这条不用这个样式</p>
<p>Some text.</p>
<p>Some text.</p>
<p>Some text.</p>
<p>Some text.</p>
<span>body里面除了p都是绿的<span>
<div>body里面除了p都是绿的</div>
```

### 写一个base62.js

### requirejs异步加载文件
加载机制：使用`head.appendChild()`将每个依赖变成`<script>`标签
helper不是xhr是以js形式加载的`Content-Type:application/javascript;charset=UTF-8`
所以模块加载可以跨域，可以从cdn
```html
<script data-main = "/js/app" src = "/js/require.js"></script>
```
app.js
```javascript
//不用data-main直接配置base-Url
//在html里两个script标签，先require.js再app.js
requirejs.config({
  baseUrl:'/js'
});
require(['helper'],function(helper){
  var str = helper.trim(' amd ')
  console.log(str)
});
```
helper.js
```js
//模块名，依赖的模块，加载的依赖中的对象（jquery）
define("helper",['jquery'],fucntion($){
  return {
    trim: function(str){
      return $.trim(str)
    }
  }
});
```

#### 获取用户信息
1.定义简单对象user.js
```javascript
define({
  username:'username',
  name:'zhou',
  email:'abc@abc.com',
  gender:'男'
  })
```
2.app.js
```javascript
require(['jquery','../js/api'],function($,api){
  $("#user").click(function(){
    //.then异步处理
    api.getUser().then(function(user){
      console.log(user);
    })
  })
});
```
3.api.js
```javascript
define(['jquery'],function($){
//异步处理
  var def = $.Deferred();
  require(['../js/user'],function(user){
    def.resolve(user);
  });
  return def;
});
```

#### 不支持AMD(require,define)的库：Mondernizr，bootstrap


### nodejs 单线程
IO密集：静态资源（文件），网络，数据库
Event loop主进程是单线程，I/O等操作系统多线程调用。
nojs有cluster模块可以在每个核启一个进程不会浪费cpu

### 移动端自适应
1.css像素即逻辑像素。
一般屏幕【设备像素比】1：1，一个逻辑像素对应一格设备物理像素
Retina屏幕，1：2，一个逻辑像素需要4个物理像素表示
2.viewport分三类
layout viewport 整个网页
visual viewport 在手机上拖动显示的网页的一部分
ideal viewport 手机的宽和高
`content="width=device-width"`让layout==手机的ideal 手机自动铺满
3.rem：em是相对于父级元素计算大小，rem相对于root element

用viewport和设备像素比可以调整基准像素

### spa的好处
不用每次请求消耗dns tcp等接口相应时间。单页面只有接口耗费的时间。
Prerender可以优化SEO

#### 实现
1.History api
  pushState
  onpopstate
2.Hash
  hashchange
  location.hash


gulp不用io流式处理 比grunt晚出现
## chrome 技巧
截图：ctrl+shift+P Captrue full size screenshot

## Web Component 用法

## Webview loadUrl

## 浏览器由7部分组成
用户界面
网络：请求静态资源发起请求
js引擎
渲染引擎：DOM和CSS内容排版 WebKit中Html和CSS解析可以并行
UI后端：选择框、按钮、输入框
js解释器
持久化数据存储

## 查看渲染计算后的CSS规则
`document.defaultView.getComputedStype(document.getElementById("id",null))`
css计算权重：!important>内联样式>id选择器>类选择器>元素选择器


## HTTP
http/1.1 字符串传输
持久链接：一个tcp链接里可以发送很多http请求。减少三次握手次数。
pipeline:
添加了host：

《Web性能权威指南》
{% qnimg http2.jpg %}
>是通过支持请求与响应的多路复用来减少延迟，通过压缩 HTTP
首部字段将协议开销降至最低，同时增加对请求优先级和服务器端推送的支持。

> 它改变了客户端与服务器之间交换数据的方式。
> 为实现宏伟的性能改进目标，HTTP  2.0 增加了新的二进制分帧数据层

{% qnimg http2connect.jpg %}

> HTTP  2.0 通信都在一个连接上完成，这个连接可以承载任意数量的双向数据流。
> 每个数据流以消息的形式发送，而消息由一或多个帧组成，这些帧可以乱序发送，然后再根据每个帧首部的流标识符重新组装。

{% qnimg http22.jpg %}

{% qnimg sendrecv.jpg %}
> HTTP 消息分解为独立的帧，交错发送，然后在另一端重新组装是 HTTP  2.0 最
重要的一项增强。

{% qnimg http2better.jpg %}

> http2:：浏览器可以在发现资源时立即分派请求，指定每个流的优先级，让服务器决定最优的响应次序。这样请求就不必排队了，既节省了时间，也最大限度地利用了每个连接。 

> 每个来源一个链接:，所有HTTP 2.0 连接都是持久化的，而且客户端与服务器之间也只需要一个连接即可。

{% qnimg http2tcp.jpg %}

http2：分帧传输二进制传输（不用连续）
信道复用 同一个链接多个请求
一个tcp链接并发http请求，不用等前一个请求接收到之后再发送。
server push推送。以前要先解析html再发送请求css/js。现在请求html就获取。

nginx开启http2 开启https才能http2
ALPN转称http1.1传给服务器
```json
server{
  listen 443 http2;
  server_name test.com;
  http2_push_preload on;
}
```
nodejs
```javascript
if(request.url === '/'){
  response.writeHead(200,{
    'Content-Type':'text/html',
    'Connection':'close',
    //http2的push
    'Link':'</test.jpg>;as=image;rel=preload'
  })
}
```
协议变成h2
`chrome://net-internals/#http2` 看pushed和 claimed 使用1个push到30个push的区别
https的握手过程


[http2性能测试](http2.akamai.com/demo/http2-lab.html)

### nodejs跨域测试
1. 被请求的添加
html里
type:xhr
```javascript
<script>
var xhr = new XMLHttpRequest()
xhr.open('GET','http://127.0.0.1:8897')
xhr.send()
<script>
```
8897:任何服务都能访问这个服务
```javascript
response.writeHead(200,{'Access-Control-Allow-Origin':'*'})
```
或者特定域名
```javascript
response.writeHead(200,
  {'Access-Control-Allow-Origin':'http://localhost:8898'})
```

2. jsonp标签里允许跨域不用添加allow-origin
type:script
```js
<script src="http://127.0.0.1:8897"><script>
```

### CORS预请求 option 
跨域只允许get/head/post
content-type只允许 form表单三种数据类型
`text/plain
multipart/form-data
application/x-www.form-urlencoded`
html：报错`not allowed by Access-Control-Allow-Headers`
```javascript
fetch('http://localhost:8897/',{
  method:'POST',
  headers:{
    'X-cors':'123'
  }
})
```
[fetch允许跨域的header](https://fetch.spec.whatwg.org/#cors-safelisted-request-header)
允许的header 其它的都需要服务器端验证先发送option类型再发送post
```javascript
response.writeHead(200,{
  'Access-Control-Allow-Header':'X-Test-Cors'
})
```
同理可以添加`Allow-Methods`等
设置允许跨域的最长时间不需要再发送option预请求
`'Access-Control-Max-Age':'1000'`

###  缓存Cache-Control
1. 可缓存性 
public：http经过的代理服务器、客户端都能缓存 
private：只有发起请求的浏览器可以缓存(百度设置了privae)
2. 过期
max-age：客户端过期时间
s-maxage=代理服务器的过期时间
max-stale=使用过期缓存
3. 重新验证
must-revalidate
4. 其它对代理服务器nginx
no-cache 可以本地缓存。向服务器发起验证是否可以使用本地缓存
no-store 不能本地缓存。
no-transform 不压缩

在请求服务器设置
```js
response.writeHead(200,{
'Cache-Control':'max-age=200,public'
})
```
服务端
```js
const etag = request.headers['if-none-match']
if(etag === '777'){
  response.writeHead(304,{
    'Content-Type':'text/javascript',
    'Etag':'777'
  })
  response.end('并不会显示，浏览器直接读了缓存')
}
```

### 设置Cookie
禁止javascript修改cookie
```js
response.writeHead(200,{
  'Set-Cookie:['id=123;max-age=2','abc=456;HttpOnly']
})
response.end(html)
```
`'adc=456;domain=test.com'` 不能跨域设置给a.test.com

### 长链接Network-Connection ID（TCP链接的id）
http1.1发送请求有先后顺序。不能并发请求
chrome允许并发限制创建6个
{% qnimg 6tcp.jpg %}
保持长链接`Connect:Keep-Alive` 默认都是keep-alive
本地开发 把网速调慢：online->Fast 3G
可以设置`'Connection':'close'`
{% qnimg closetcp.jpg %}

google 使用h2 都是一个connectID
{% qnimg googletcp.jpg %}

### 数据协商
Accept
Accept-Encoding
Accept-Language
[mimetype](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Basics_of_HTTP/MIME_types)

`'X-Content-Type-Options':'nosniff'` 禁止浏览器自动猜测返回类型

使用gzip压缩
```js
const fs = require('fs')
const zlib = require('zlib')
const html = fs.readFileSync('test.html')
response.writeHead(200,{
  'Content-Encoding':'gzip',
})
response.end(zlib.gzipSync(html))
```

表单如果用ajax使用application/json或者application/xml
```html
<form action ='/from' id = "form" method = "POST" enctype="multipart/form-data">
<input type = "text" name = "name">
<input type = "password" name = "password">
<input type="file" name="file">
<input type ="submit" name = "submit">
</form>
```
ajax发送
```javascript
var form = document.getElementById("form")
form.addEventListener('submit',fumction(e){
  e.preventDefault()//页面不会跳转
  var formData = new FormData(form)
  fetch('/form',{
    method:'post',
    body:formData
  })
})
```
会自动带上Content-Type

### redirect
只有302的头才表示跳转
```js
response.writeHead(302,{
  'Location':'/new'
})
```
改成301永久变更 浏览器会自动只发送/new的请求 /new的路由放到了缓存里。接下来改成200也读不到了。

### CSP content-security-policy 内容安全策略
```js
'Content-Security-Policy':'default-src http:https'
```

考虑同一域名的浏览器请求上限将html放在admin.domain.com下,js+css放在s.下，将image放在image.下
前端访问后端api.发生跨域需要使用代理服务器

304是协商缓存 还会和服务器通信一次
本地缓存(cache-control/expires) 通过html中引用css地址更新v1放弃缓存 用摘要算法当文件更新时更新css文件名
静态资源部署在cdn，动态网页部署在另一个节点。
1 先更新页面：加载旧缓存，页面样式错乱
2 先静态资源后页面：有缓存则不更新，第一次访问的没缓存用户 页面执行错误。
访问量小的网站可以先静态资源后页面
非覆盖式发布：新旧css同时存在cdn上，再更新html页面


全局微软雅黑
`document.getElementByTagName("body").sytle.fontFamily="微软雅黑"`
`Array.from(document.getElementByTagName("p").forEach((item)=>item.style.fontFamily="微软雅黑"))`

1. import有无default ，default导出的只能一个，所以不用大括号

### webpack-dev-server 开发模式
wepack.config.js:
```javascript
const isDev = process.env.NODE_ENV==='development'
const config={
  target: 'web'
}
if(isDev){
  config.devSever ={
  port:8888
  host:0.0.0.0,//可以在内网中用内网ip用手机访问测试
  overlay:{
    errors:true,
  },
  historyFallback:"index.html",
  hot:ture//只渲染当前组件
}
}
```
安装corss-env在windows平台下设置NODE_ENV要用set和linux不同
package.json
```javascript
"script":{
  "build":"cross-env NODE_ENV=production webpack --config webpack.config.js",
  "dev": "cross-env NODE_ENV=development webpack-dev-server --mode development --config webpack.config.js"
}
```

### html-webpack-plugin

### autoprefixer
postcss.config.js
优化css代码 自动加webkit等前缀

### mixin模式

### typeof一共有五种返回值
按存储方式只有值类型和引用类型（共用内存块）
只能区分值类型。无法区分引用类型：数组、对象、方法
{% qnimg typeof.jpg %}

### 强制类型转换
#### ==
```javascript
100=='100'//true
0=='' //true 都会转换成false
null==undefine//true 都会转换成false
```

#### if和逻辑运算符
判断变量被当成true还是false
```javascript
var a = 100
console.log(!!a)//true
```

### 何时使用===和==
除了
```javascript
obj.a==null
//相当于
obj.a===null||obj.a===undefined
//来自jquery
```
其它都用`===`

### 12个js内置函数 （数据封装类对象）
JSON和Math也是内置对象
```javascript
JSON.stringify({a:10,b:20})
JSON.parse('{"a":10,"b":20}')
```

### 原型

### js构造函数
```javascript
//构造函数
function MathHandle(x,y){
  this.x=x;
  this.y=y;
}
MathHandle.prototype.add=function(){
  return this.x+this.y
}
var m = new MathHandle(1,2)
console.log(m.add())
```

### Class语法
```javascript
class MathHandle{
  construct(x,y){
    this.x=x;
    this.y=y;
  }
  add(){
    return x+y
  }
}
const m = new MathHandle(1,2);
console.log(m.add())
```

### 语法糖实现
`MathHandle===MathHandle.prototype.constructor` true

### 继承
```javascript
function Animal(){
    this.eat = function(){
        console.log("animal")}}
function Dog(){
    this.bark = function(){
        console.log("bark")}}
Dog.prototype = new Animal()
var hs = new Dog()
//hs有了eat方法
```

### window.onload和DOMContentLoaded区别


#### zepto
rollup.js 比webpack小

babel src/index.js

zepto小型jquery专门移动端开发
Rivets.js数据绑定
[js](https://github.com/ecmadao/Coding-Guide/tree/master/Notes/JavaScript)
预处理器 pug webpack 模版处理器（jade）

### 数组
1. `arr.includes(4)` true/false
2. `.find`
```js
let result = arr3.find(function (item,index) {
    return item.toString().indexOf(5)>-1
})
```
3. `.some`找到true后停止返回true
4. `.every`找到false后停止返回false
5. `.reduce`
{% qnimg reduce.jpg %}
变成undefined是因为没有写返回值
{% qnimg returnreduce.jpg %}
- 对象求和：
```javascript
//不报错，返回NaN 因为pre从对象变成了数 
[{price:30,count:2},{price:20,count:3},{price:40,count:4}].reduce((prev,next)=>prev.price*prev.count+next.price*next.count)
```
正确写法：
```js
[0,{price:30,count:2},{price:20,count:3},{price:40,count:4}].reduce((prev,next)=>prev+next.price*next.count)
//或者添加默认参数
[{price:30,count:2},{price:20,count:3},{price:40,count:4}].reduce((prev,next)=>prev+next.price*next.count,0)
```
- 数组扁平化：二维数组变成一维
```js
[[1,2,3],[4,5,6],[4,5,6]].reduce((prev,next)=>prev.concat(next))
```

### 箭头函数
`let a = b => c => b+c`a(1)(2)=3(return function(c){b+c})
闭包：返回的是引用数据类型，赋值给外界变量，不会被销毁。


更改this指向
### call和apply和bind
[apply\call详解](https://github.com/lin-xin/blog/issues/7)
绑定this上下文，call和apply使函数立即执行

bind返回函数
自己实现bind
```js
if (!Function.prototype.bind) {
        Function.prototype.bind = function () {
            var self = this,                        // 保存原函数
                context = [].shift.call(arguments), // 保存需要绑定的this上下文
                args = [].slice.call(arguments);    // 剩余的参数转为数组
            return function () {                    // 返回一个新函数
                self.apply(context,[].concat.call(args, [].slice.call(arguments)));
            }
        }
    }
```

### 文档碎片

### 在赋值操作中
1. `A||B` :A真返回A，A假返回B
2. `A&&B` :A假返回A，A真返回B &&优先于||
应用场景：
```js
function fn(num,callBack){
  num=num||0//undefined会转换成false
  callBack&&callBack();//只要传了函数进来callBack为真
}
```

### 闭包
{% qnimg bibao.jpg %}
里边的作用域被赋值给外面的变量占用了，不能释放。
```js
var a = 9;
function fn(){
  a=0;
  return function(b){
    return b+a++;
  }
}
var f=fn()//占用 function(b)
console.log(f(5))//输出5.f(5)执行后会销毁 全局a=1
console.log(f()(5))//修改全局a=0 输出5 执行完后a++ 全局a=1
console.log(f(5))//输出6 从fn到return之间的被保留
```

### 类数组 （arguments形参集合）
1. 以0~n数字作索引
2. length
3. arguments.callee是函数本身 严格模式不使用
4. arguments.caller 是fn 严格模式不使用
5. Array.from()将类数组转换成数组
```js
function sum(){console.log(arguments.callee.caller)}
function fn(){sum(1,2,3,4)}
```

### 立即执行函数IIFE
`function t (num){console.log(num)}(3)`

1. 浏览器的【全局作用域】是window,nodejs的全局作用域是global
var a=1 给window加了属性
2. 对象数据类型：
  1. 浏览器开辟内存空间分配一个16进制的地址，
  2. 内存空间存对象键值对
  3. 给对象变量存地址

任意数求和
```js
function fn(){
  //类数组转化成数组
  var ary = Array.prototype.slice.call(arguments);
  return eval(ary.join('+'))
}
fn(12,23,34)
```

3. 函数与对象的创建相同也是地址，函数把js代码当作字符串存到空间中
4. js中栈内存是作用域，用于执行代码，存放基本数据类型。堆内存用于存储键值对or函数字符串
  调用栈是连续空间。后进先释放，要节约栈空间。堆是链表。
5. 变量提升：在当前作用域，浏览器把所有
    1. 带var的声明，
    2. 带function的声明并定义（defined赋值(代码字符串的地址)）
6. 全局作用域var相当于给window加了属性




### 单例模式：团队合作防止全局变量污染：封装到对象

### 内置类
1. htmlCollection元素集合类
```js
getElementByTagName
getElementByClassName
querySelectorAll
```
2. NodeList 节点集合类
```js
getElementByTagName
childNodes
```
3. __proto__:HTML[Div]Element元素对象->HTMLElement->ELement->Node->EventTarget->Object

### 构造函数
构造函数执行方式`new` fn() 普通函数 `fn()`
1. this是window
```js
function fn(num){
    console.log(this)
}
```
2. 调用构造函数时 this指向函数本身 输出：nfn的属性nnn:10
构造函数过程：创建this实例，对this赋值并返回this
并且每次new都是不同实例
```js
function nfn(nnn){
    console.log(this)
    this.nnn=nnn;
}
var ff = new nfn(10)
```

### 判断JS数据类型的4种方法
[js数据类型](https://www.cnblogs.com/onepixel/p/5126046.html)
1. typeof 无法区分正则和array 都返回object
2. instanceof 检测当前实例是否属于这个类
3. .constructor（对象实例的constructor是类）
4. Object.prototype.toString.call

### in/hasOwnProperty
hsOwnProperty是通过原型链检测是否是Constuctor的实例
区别：
`Object.hasOwnProperty('hasOwnProperty')` false
`'hasOwnProperty' in Object` true
hasOwnProperty用于检测私有属性
in 私有共有都返回true
共有：类提供，所有实例都能用 （静态方法）

### 原型和原型链
类是函数，实例是对象。
1. 函数的`prototype`属性是对象
2. 实例的`__proto__`属性是对象
3. `typeof Object` "function" 所有的类都是函数类型 
  `Function instanceof Object` ->true
4. 所有内置类String/Number 也是"function"类型

#### 原型 三个自带的属性
原型链：实例的`__proto__`是类的`prototype` 
1. prototype对象（原型对象）是所有`函数`的属性。
  存储了当前类给实例提供的公共属性和方法
  通过prototype定义类：使用new Person获得实例
  ```js
  var Person = function(){};//function Person(){}
  Person.prototype = {
    name : 'ecmadao',
    sayName : function(){
      console.log(this.name);
    }
  };
  ```
2. prototype对象，带`constructor`属性存的值就是函数本身（类）
3. 每个对象都带`__proto__`属性，值是当前对象所属类的原型(prototype)
{% qnimg prototype.jpg %}
```js
function fun(num){
    this.num = num}
var f1  = new fun(10)
fun.prototype=== f1.__proto__ //true
```
对fun.prototype添加的方法
```js
fun.prototype.say = function(){console.log("prototypesay")}
```
对f1来说`f1.hasOwnProperty('say')` false . 是公共方法
4. `fun.prototype.__proto__`是Object.prototype
5. `Object.prototype`没有`__proto__` 有也指向自己

### 构造原型
`Fn.prototype = {}`
1. 会没有constructor,使用`constructor:Fn`
2. 会导致原来使用`Fn.prototype.c=function`的属性被替换（可以遍历原有的克隆）
3. 
```js
var jQuery = function(selector,context){return new jQuery.fn.init(,)}
jQuery.fn = jQuery.prototype={constructor:jQuery,init:function(,){}}
```


### BOM
{% qnimg BOM.jpg %}
1. 
`document.querySelector("body").setAttribute("style","background-color:black");`
`document.querySelector("body").style.cssText="background-color:black";`

https://chromium.googlesource.com/chromium/src/+/master/docs/es6_chromium.md

## 前端模块化 CommonJS
> CommonJS是不适用于浏览器端,因为文件是从服务器请求过来，不能同步加载模块。

1. 浏览器模块化AMD规范：require.js 
非同步，指定回调函数
浏览器中异步加载。可以并行加载多个模块。
???如何并行？

2. CMD规范：按需加载sea.js

3. ES6模块化
- 通过babel将不被支持的import编译为当前受到广泛支持的 require


### 加载过程
defer 与相比普通 script，有两点区别：载入 JavaScript 文件时不阻塞 HTML 的解析，执行阶段被放到 HTML 标签解析完成之后

### 虚拟DOM 
https://segmentfault.com/a/1190000015821780
1. Virtual Node
- 用json构建，type\props\children
{type:"div",props:{"style:"},children:[]}
vnodes->vdom

### 柯里化currying：函数式编程风格，组合函数
```js
//两数相乘
var multiple = function(a){
  return function(b){
    return +b*a+""
  }
}
//拼接
var concatArray = function(list,fct){
  return list.map(fct)
            .reduce(function(a,b){
              return a.concat(b)
              })
  }
//运行24
concatArray(["1","2"],multiple(2))
```

### Object.defineProperty 为对象定义属性
1. js对象or DOM对象
2. 属性名
3. 描述符：
  > {value: "covergou", writable: false, enumerable: true, configurable: false}
```js
let obj ={}
Object.defineProperty(obj,"school",{get:,set:})
```
  - value:"name"
  1. `writable:true/false` 是否可写
  2. `configurable:false` 删除属性、修改属性（writable, configurable, enumerable）的行为将被无效化
  3. `enumerable: true` 是否能在for-in循环中遍历出来或在Object.keys中列举出来
  4. `get/set:function(){}`使用get/set不能有writable和value属性
  5. 

#### 实现数据双向绑定
数据劫持
```js
Object.defineProperty(dom, 'translateX', {
set: function(value) {
        var transformText = 'translateX(' + value + 'px)';
        dom.style.webkitTransform = transformText;
        dom.style.transform = transformText;
}
})
dom.scale = 1.5; 
```

### ES6

### 数组
类方法：
1. `Array.form(1,2,3,4)`转成数组`.from(3)`生成空位
2. `Array.of(3)`与from用法相同，解决了单个值数组
3. `toArray(1,2,3,4)`转数组

原型方法（用于实例）
1. `.copyWithin(target,start,end)`
- cool()函数丢失了同this之间的绑定
  **var self = this**


```javascript
var obj = { 
       id: "awesome", 
       cool: function coolFn() { 
           console.log( this.id ); 
       } 
   }; 
    
   var id = "not awesome" 
    
   obj.cool(); // 酷 
    
   setTimeout( obj.cool, 100 ); // 不酷
   ```
- setTimeout中的this指向的是全局对象
1. var self = this
2. function(){}.bind(this),1000

- 模板字符串



### 显示所有全局变量
```javascript
for(name in this){
    vars+=name+"\n"}
```

#### 对象保护 对象代理
1. ES3,ES5
```js
//声明类
var Person= fuction(){
  var data={
    name='es3',
    sex:'male',
    age:15
  }
  this.get,this.set = function(){}
}

```
2. es5:对象的只读属性
`Object.defineProperty("Person",'sex',{
  writable:false,value:'male'
})`只能读不能写
3. ES6用代理访问对象
```js
let Person={:,:,:}
let person = new Proxy(Person,{
  get(target,key){
    target[key]
  },
  set(target,key,value)
  })
```

#### 箭头函数
import
1. {}块状作用域
2. .map(function(v){return v+1}) 
  .map(v=>v+1)
3. 箭头函数内的this指向是定义时this的指向
function中this指向是该函数被调用的对象

