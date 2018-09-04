---
title: About Vue&JS
date: 2018-03-03 08:49:13
tags: [vue,javascript]
category: [js前端常用svgcanvasVue框架jquery源码]
---

```javascript
app.$watch("text",(newV,oldV)=>{
  console.log(`${newV},``)
}
```

`value`、`selected`、`checked`默认情况下会被忽略


1. data是函数因为这样多次引用一个组件都创建新的的data实例

1. 钩子函数create在 data初始化后调用，this指向vm，专门用来发送ajax

### axios基于promise
```js
root["axios"] = factory();
```
axios挂在window上

### promise 
- 回调函数：将【后续】处理逻辑传入当前函数，当前事件完成后自动执行
```js
let a = ''
function buy(callback) {
  setTimeout(()=>{
    a="蘑菇"
    callback(a)
  },2000)
}
buy((val)=>{console.log(val)})
```
- promise的三个状态：等待->成功/失败
```js
//ES6.JS
function Promise(executor) {}
```
传入一个执行函数
```js
Promise.prototype.then = function(onFulfilled,onRejected) {};
```
不用传入回调函数，自动把值传入回调函数
```js
function buyPack() {
  //回调（成功函数，失败函数）
  return new Promise((resolve,reject)=>{
    setTimeout(()=>{
      if(Math.random()>0.5){
        resolve('买')
      }else{
        reject('不买')
      }
    },1000);
  })
}
//then(成功函数，失败函数)
buyPack().then((data)=>{console.log(data);},
              (data)=>console.log(data))
```

### promise解决异步ajax
1. 4步实现ajax
```js
function ajax({url='',type='get',dataType='json'}){
  let xhr = new XMLHttpRequest()
  xhr.open(type,url,true)//是否异步
  xhr.responseType=dataType;//后台响应的类型
  xhr.onload = function(){// 相当于readState=4 
    //防止404还是要： if（xhr.status==200）
  }
  xhr.send()
}
ajax({url:'./.json'}).then
```
2. 使用Promise
```js
function ajax({url='',type='get',dataType='json'}){
  return new Promise((resolve,reject)=>{
    let xhr = new XMLHttpRequest()
    xhr.open(type,url,true)//是否异步
    xhr.responseType=dataType;//后台响应的类型
    xhr.onload = function(){// h5的新方法，等于xhr.readState=4 xhr.status=200
      resolve(xhr.response)
    };
    xhr.onerror = function(err){
      reject(err)
    }
    xhr.send()
  })
}
ajax({url:'http://localhost:8089/getUser'}).then(
    (res)=>{console.log(res)},
    (err)=>{console.log(err)})
```
---
fetch完全基于promise
async await 异步的终极解决方案

1. call和apply的区别是apply第2个参数传数组


2. `var vm = new Vue({el:'#app'})`给body加#app表示body里面的dom都是vue的管理区域
3. 弹窗效果=两个div嵌套，遮罩div width整个屏幕，显示在所有图层上，现在body最上或最上，`v-if="!modal.show` `v-on:click="modal.show=!modal.show"`
4. `ready:function(){this.getData()}`与methods\data同级，对象加载好执行 ,this.methods中的方法（ajax请求更新data）
  1. getData函数中的reqwest函数中的this已经不是实例本身了，取不到data数据，指的是窗口
```js
methods:{
  var self = this
  getData:function(){
    reqwest({
      url:
      type:
      method:
      success:function(resp){
          self.comments = resp.results
      }
    })
  }
}
```
5. `computed：`与methods写法基本相同，有缓存并且
  可以绑定数据`class="{{loadingOrNot}}"`
  ```js
  computed:{
    loadingOrNot:function(){
      if(this.comments.length==0)return 'loading'
      }else{
        return ""
      }
    }
  }
  ```
6. `[1,2,3].filter(isBigEnough)`在computed中写过滤、验证表单
```js
filterdList:function(){
  function useRuler(people){
    return people.heigh>100
  }
  var newList = this.comments.filter(useRuler)
  return newList
}
```

## RESTful API
1. PUT修改已有的某个资源 get是查 post增
2. 返回响应码：201：删除、修改、创建成功； 400：失败
3. token`cookie.js` token认证不能在加data里
```js
getDate:function(){
  var self = this
  reqwest({
    url:
    type:'json',
    headers:Cookies.get{'token'}?{'Authorization':'Token '+Cookies.get('token')}:{}
    success:function(resp){

    }
  })
}
```







#### vue难点
1. $emit()
2. this.$nextTick()
3. **directive 自定义指令**

#### vuex难点

dom上的行间属性
```js
// 注册
Vue.directive('my-directive', {
  bind: function () {},
  inserted: function () {},
  update: function () {},
  componentUpdated: function () {},
  unbind: function () {}
})
// 注册 (指令函数)
Vue.directive('my-directive', function () {
  // 这里将会被 `bind` 和 `update` 调用
})
// getter，返回已注册的指令
var myDirective = Vue.directive('my-directive')
```
4. minxins 混入
```js
// 定义一个混入对象
var myMixin = {
  created: function () {
    this.hello()
  },
  methods: {
    hello: function () {
      console.log('hello from mixin!')
    }
  }
}

// 定义一个使用混入对象的组件
var Component = Vue.extend({
  mixins: [myMixin]
})

var component = new Component() // => "hello from mixin!"
```


### vue
```javascript
var message = `
  hello ${name}!
  the answer is ${40+2}`.toUperCase()
```
+ :root 选择器匹配文档根元素。
+ 响应式布局@media screen and (min-width: 768px)
@media 的媒介查询方式根据屏幕尺寸判断手机端还是PC端

+ 不用history模式路径会有#（hasj模式）
history.pushState API完成URL跳转不需要重新加载页面
{% note  %}  **微信history push注意**  {% endnote %}


### npm 缺少python2.7
[npm python](https://github.com/felixrieseberg/windows-build-tools/issues/56)
npm --add-python-to-path='true' --debug install --global windows-build-tools

## Weex
1. 适配750px，
2. 缩略 border，background
3. 定位： 不支持z-index ，Android的overflow为hidden
4. 渐变：不支持 radial-gradient；box-shadow只支持ios
5. <image> border-top-left-radius可以，安卓不可以
6. 所有元素默认display:flex



## Ajax
1.  readyState 0-4请求初始化 服务器连接已建立 请求已接收 请求处理中 请求已完成
`request.onreadystatechange=function(){
}`
2. post 要用`Content-Type：application/x-www-form-urlencoded`9
3. post 参数用&隔开
- data="name=" .value+"&number=" ;
- request.setRequestHeader("Content-Type","application/x-www-form-urlencoded")
- request.send(data) 
- request.responseText
请求参数：Request Payload
4. eval 解析json字符串 eval('('+json+")");
- eval 中 值为alert() 会被执行
Json.parse(request.responseText)
JSONLint 格式化校验工具
标记约定 "success":true
5. 产生跨域 localhost->127.0.0.1 
- 方法1： 代理 后台
- JSONP解决get请求跨域访问
1. dataType:"json"->"jsonp"
2. jsonp:"参数名" 后台约定
3. H5 XHR2 "Access-Control-Allow-Oringin：*""
### Navigator
1. Chrome浏览器信息 `navigator.appVersion`
2. 用userAgent判断什么浏览器
```javascript
navigatior.userAgent.indexOf("Chrome")>-1
//IE(8-10)
indexOf("MSIE")
```
### Screen 对象
`screen.width/.height`
一、对于IE9+、Chrome、Firefox、Opera 以及 Safari：

•  window.innerHeight - 浏览器窗口的内部高度

•  window.innerWidth - 浏览器窗口的内部宽度
- 元素尺寸
var w= document.documentElement.clientWidth
      || document.body.clientWidth;
var h= document.documentElement.clientHeight
      || document.body.clientHeight;
- scrollTop 可见内容相对顶部高度
- offsetTop相对与页面的位置

