---
title: jQueryCode
date: 2018-03-15 11:13:05
tags:
---

## browser sync
[自动刷新](http://www.browsersync.cn/)
- npm install -g browser-sync
- 进入监听文件夹`// 如果你的文件层级比较深，您可以考虑使用 **（表示任意目录）匹配，任意目录下任意.css 或 .html文件。 
browser-sync start --server --files "**/*.css, **/*.html"`


## 腻子？
>JavaScript代码，能够赋予浏览器未曾有过的功能
- HTML5shiv 
- 原理？

### jq 目录
1. 代码风格：`.editorconfig` 不同程序员和IDE协作文件
2. 代码规范：eslintrc- node(后端) -brower(前端);.eslintrc.json继承，便于替换
3. 项目版本：git
4. 基于nodejs开发
5. 使用grunt进行工程化管理

#### package.json
1. `devDependencies`开发阶段依赖的包
    1. 转换规则`babel-plugin-transform-es2015-for-of": "7.0.0-beta.0"`
    2. 转换命令`grunt-babel`自动化任务
    3. `husky`阻止git中不好的操作 .git/hooks
    4. `commitplease`保证git提交注释的格式规则
    5. `core-js`es5\6\7的腻子
    6. `eslint-config-jquery` 代码规范的配置
    7. `grunt-eslint` 
    8. `grunt`- `grunt-cli`(一般全局安装）控制台命令接口，安装对应的自动化插件
    9. 测试相关
    10. `require.js` AMD规范
    11. `sizzle` 纯js选择器    
2. `scripts`可以运行的脚本npm
3. `commitplease` 插件配置

### npm
1. install -g全局安装，操作系统任意路径都能找到
    --save 本地安装 项目目录里
    --save-dev 只在开发环境依赖 运行环境不依赖
2. `npm install grunt --save-dev` 加到devdependenceis

### grunt Gruntfile.js
初始化grunt ，加载grunt插件的脚本文件，创建自动化任务

### 测试环境
nodejs测试环境
1. chrome://inspect
2. 控制台 `node --inspect-brk .\app.js` 第一行里加断点
浏览器测试环境
1. `<script>`插入require.js;并设置入口文件`data-main="index.js"`
2.  ```javascript
    index.js 
    1. 默认路径配置
    require.config({
        baseUrl:"../src"
    })
    2. 声明依赖模块 路径是src/css.js(返回jqrery)
    require(['css'],function($){
        $('div')
    })
    ```

### jquery.js
- core.js
    define(依赖的模块,function(依赖模块返回的对象))
- toArray:
    return slice.call( this ); 关联的对象转成数组return [].slice
    .call(this) 绑定上下文 
    `[].slice.call(this)`返回[window]类数组
- get:
    `return num < 0 ? this[ num + this.length ] : this[ num ];`从后往前数数组
- pushStack: 
`jQuery.merge(`构建新的jQ对象

#### ES5普通的创建对象

- 每个构造函数都有一个原型对象 
- constructor属性指向构造函数
```javascript
//1.创建构造函数
function Student(name,sex){
    this.name = name
    ...
}
//2. 创建构造函数原型对象
Student.prototype={
    constructor:Student,
    //添加实例共享的方法
    study:function(){
    }
}
//3. 使用构造函数必须要用new 可以返回this
var stu = new Student(a,b);
stu.study();
```

#### jquery 构造函数
1. core.js:return `new` init(,) 避免使用new 
    但return的是init类型，prototype的方法不能用
2. init.js:`init = jQuery.fn.init = function`放到了jq的原型里；
    `init.prototype = jQuery.fn;`两个原型相等，解决原型方法
    让两个构造函数引用同一个原型对象

1. `jQuery.fn = jQuery.prototype `添加fn属性，其实是prototype的简写

##### init.js
创建DOM对象
- `if ( selector.nodeType ) `DOM元素有nodetype属性
- slector不是string/DOM/function`return jQuery.makeArray( selector, this );`是js对象
1. 如果是string:判断是html标签
    ```javascript
    if ( selector[ 0 ] === "<" &&
                    selector[ selector.length - 1 ] === ">" &&
                    selector.length >= 3 ) 
    ```
    + parseHTML.js
    ```r
     /^<([a-z][^\/\0>:\x20\t\r\n\f]*)[\x20\t\r\n\f]*\/?>(?:<\/\1>|)$/i 
     ```
     1. `^<` 第一个符号是`<`
     2. `[^\/\0>:\x20\t\r\n\f]*`不是`/`,`\0`匹配NULL (U+0000) 字符,`>`，`:`，`\x20`空格...
     3. `[\x20\t\r\n\f]*`很多空格
     4. `\/?`可以有一个`/`
     5. `(?:)`非捕获组。 捕获组：`([a-zA-Z])\1`:`\1`捕获组 `$1`捕获组的引用
     6. `<\/\1>`:`\1`捕获前面`([a-z][^\/\0>:\x20\t\r\n\f]*)`小括号中的内容
     7. `/i` (忽略大小写)
     添加属性
     + `$(html, props)` 添加属性props是js对象`this.attr( match, context[ match ] );`
2. 是string但不是`<>`开头结尾：
    正则html标签`rquickExpr = /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]+))$/,`
    1. 非捕获+很多空白+<任意一个字母或数字或下划线\和所有字母、数字、下划线以外的字符>
    `[^>]*` 除了`>`之外的符号可以有很多个
    2. 或者 是id
3. 是string 是css选择器 `.class`: findFilter.js
    document.find(selector)->`jQuery.fn.extend( {
    find: function( selector )` 使用了第三方的Filter库
    ？？？？使用sizzle
    - $(".face","#box")在box找.face`return this.constructor( context ).find( selector );` 重新返回构造#box的jquery中查找.face
4. 是string 是function 传给`jQuery.Deferred();` DOM加载完毕后执行
    1. `window.onload = function(){}` 
        所有资源加载完毕后执行,只能绑定一次事件处理函数，绑定多次会覆盖
    2. `$(function(){});`只要dom加载好，图片,css,js等不需要，可以绑定多次

#### callbacks 等待耗时操作执行完后自动执行的函数
1. 字符串转对象 option可选参数
```javascript

```



##### sizzle
[sizzle](http://zhenhua-lee.github.io/framework/sizzle.html)



$().ready(function(){
	
})
> Javascript 中的 undefined 并不是作为关键字，因此可以允许用户对其赋值。
#### 门面接口

#### 底层接口

#### 快捷方法
#### ready和load事件
ready先执行，load后执行
- DOM文档加载的步骤：
>(1) 解析HTML结构。
(2) 加载外部脚本和样式表文件。
(3) 解析并执行脚本代码。
**(4) 构造HTML DOM模型。//ready** 
(5) 加载图片等外部文件。
(6) 页面加载完毕。//load

##### promise
```js
document.addEventListener( "DOMContentLoaded", completed, false );
```

### 类数组对象
- jquery实现了9种方法的重载
```js
var aQuery = function(selector) {
    //强制为对象
	if (!(this instanceof aQuery)) {
		return new aQuery(selector);
	}
	var elem = document.getElementById(/[^#].*/.exec(selector)[0]);
	this.length = 1;
	this[0] = elem;
	this.context = document;
	this.selector = selector;
	this.get = function(num) {
		return this[num];
	}
	return this;
}
```
- 属性与方法作为对象的key与value的方式给映射到this上

### 立即调用表达式
```javascript
(function(window, undefined) {
    var jQuery = function() {}
    // ...
    window.jQuery = window.$ = jQuery; 
})(window);
```
1. 减少变量查找所经过的scope作用域:当window通过传递给闭包内部之后，在闭包内部使用它的时候，可以把它当成一个局部变量
2. 挂在到window下执行 在外面就可以用$()执行函数

- 自执行
- 匿名函数，不存在外部引用.防止全局变量污染。
1. jQuery使用()将匿名函数括起来，然后后面再加一对小括号（包含参数列表）
小括号把表达式组合分块，每个小伙好把匿名函数括起来返回一个匿名函数Function对象。
`（function（）{})()`目的：使匿名函数像有名字一样，可以取得它的引用位置。（单利模式）在这个引用位置后面加参数列表，实现普通函数调用。
```js
(function(window){
    var jQuery=function(){console.log("jqqqqqqq");}
    window.aaa=jQuery//保留jquery定义的变量，只暴露为aaa()
    })(window);
```
2. zepto的方式
```js
var Zepto=(function() {
    var Zepto= function(){};
    return Zepto
})();
Zepto()
```