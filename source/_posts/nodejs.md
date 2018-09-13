---
title: nodejs
date: 2018-07-22 12:58:32
tags:
category: [nodejs]
---
### CommonJS nodejs的模块规范
https://morning.work/page/nodejs/ready-to-async-await.html
global对象和process对象
一个文件是一个模块
使用requirejs需要自己写包裹函数，nodejs省了这一步

`node --inspect-brk learn_path.js`
chrome打开
`chrome://inspect/#devices`
```javascript
(function (exports, require, module, __filename, __dirname) { 
});
```
exports是对外提供的接口/属性
require依赖别的模块
module是模块本身里export属性
![nodemodule](/images/nodemodule.jpg)



