---
title: 前端性能优化
date: 2018-04-12 21:29:48
tags: [js]
---
> 谷歌 PageSpeed团队的测试表明，30~50 KB（压缩后）是每个 JavaScript 文件大小的合适范围：既大到了能够减少小文件带来的网络延迟，还能确保递增及分层式的执行。

[浏览器解析](https://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/)
- Firefox 规则树

### CSS图像精灵 减少http请求次数

服务端对静态文件gzip压缩
使用css/js（内容不是很多）内嵌式减少http请求

JS和DOM的映射机制是浏览器的监听机制是，DOM操作会触发浏览器回流和重绘。
减少css选择器前缀，使用组合名表示层级。避免使用css表达式

服务器多处理304缓存，客户端利用localStoreage将css/js存储在本地。
少使用闭包，会产生不销毁的栈内存。内存泄漏。
eval性能消耗大，压缩后会错乱。
DOM事件绑定使用事件委托（代理），把事件绑定给外层容器，里面元素触发外层也触发（冒泡）。通过事件源判断做不同的操作。

用CSS3替代js动画，css3有硬件加速。
减少css滤镜使用和页面flash。
 CDN 效果最佳

数据懒加载 分页(后台)

### html渲染
1. 外部资源在浏览器加载是并发加载，对于单个域名浏览器的并发度有限，设3-4个CDN域名，防止浏览器达到外部资源并发请求数目上限，导致资源不能并发请求。

### css阻塞
用link在head导入css会阻塞页面渲染，阻塞js执行，但是不阻塞外部脚本加载

### js阻塞
不用defer和async直接用`<script src>`会阻塞页面渲染，不阻塞资源加载，阻塞执行
async 不会阻塞页面加载，放弃了js依赖关系

### 懒加载 zepto.js
1. 图片 进入可视区域再加载，浏览器并发上限如果图片和静态资源在的cdn是同一个，图片加载会阻塞js加载
2. img的src并不是图片的url是只有1px的占位符，图片标签被放在data-url属性上，js监听scroll事件。 lazyload=true。触发时链接放到background-image中
3.  dom上底边(clientHeight) 到页面顶部的距离小于 手机屏高 则可视
  1. `addEventListener('scroll',lazyload)` 
  2. 遍历所有懒加载标签`document.querySelectorAll('div[lazyload]')`
  3. 获取距离顶部的位置
  ```js
  element.getBoundingclientRect()
  >document.querySelectorAll('img[src]')[0].getBoundingClientRect()
  //输出 DOMRect {x: 0, y: 0, width: 0, height: 0, top: 0, …}
  >document.querySelectorAll('img[src]')[99].getBoundingClientRect()
  //输出 DOMRect {x: 835, y: -1604, width: 22, height: 22, top: -1604, …}
  ```
  4. NodeList，它里面没有.forEach方法
  ```c
  Array.prototype.forEach.call(nodes,function(item,index)){
  var image = new Image()
  //请求图片资源
  image.src=dataurl
  //赋值到item上
  image.onload = function(){item.src = img.src}
  item.removeAttribute('data-original')
  item.removeAttribute('lazyload')
  }
  ```

### 预加载preloadjs
1. 九宫格抽奖
2. `style="display:none"`
3. 使用new Image()
4. XMLhttpRequest2加了对请求过程的监控`xmlhttprequest.onprogress` 会有跨域问题
```js
var xmlhttprequest = new XMLHttpRequest()
xmlhttprequest.onreadystatechange = callback;
xmlhttprequest.open("GET",".jpg",true)
xmlhttprequest.send() //请求返回时会 onreadystatechange
function callback(){
  if(xmlhttprequest.readyState==4&&xmlhttprequest.status==200){
    var responseText = xmlhttprequest.responseText;
  }
}
```