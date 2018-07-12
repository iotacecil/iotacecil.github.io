---
title: webpack
date: 2018-04-11 23:55:05
tags:
---
1. npm init 生成package.json文件
2. npm i webpack
3. 新建build文件夹 放配置文件
4. webpack.config.js:
    1. 仍出一个webpack配置对象module.exports = {
        }
    2. entry 入口文件
    3. 防止系统差异引用`const path= require('path')`
    4. `app:path.join(__dirname,'../app.js')`:`__dirname` 当前文件夹
    5. `output:{filename:'[name].[hash].js}` 中括号表示变量,[name]表示entry下对应的名字,加上打包后的hash值，有任何文件改动hash变化，浏览器刷新缓存
    6. publicPath:"" (js,css404:"/"绝对路径，"./"相对路径)静态资源引用时的路径，区分静态资源还是api请求，如果部署到CDN，写CDN前缀
    ---
    7. 配置moudle识别jsx 
    `test`后面跟正则表达式（以jsx的）表示文件类型
    loader是编译工具，编译成ES5 安装`babel-core`
    ```js
    moudle:{rule:[
        test:'/.jsx$/'，
        loader：'babel-loader'
        ]}
    ```
    8. 配置babel（默认编译ES6）的配置文件`.babelrc` presets 支持的语法
        ```js
        {
            "presets":[
            ["es2015",{"loose":true}],
            "react"
            ]
        }
        ```
        用松散模式编译ES6,用react语法 安装babel的3个包
    9. 安装`html-webpack-plugin -D`并 require
    10. 能生成一个html页面把entry里的都注入，路径根据output
    ```js
    plugins:[
    new HTMLplugin()
    ]
    ```
    没有启动服务器没有做路径映射所以访问不到js文件
    将publicPath设置为''变成相对路径
    react的js文件也需要babel但是nodemodules里面都是js
    ```js
    {
        test:/.js$/,
        loader:'babel-loader',
        exclude:[
            path.join(_direname,'../node_modules')
        ]
    }
    ```
---

## 服务端渲染：单页js写的应用SEO不友好、请求时间长
webpack.config中的内容复制到webpack.config.server
`target:'node`打包完在哪执行可以是node/web（浏览器
1. entry:app： export default的js
2. libraryTarget：'AMD' 模块加载方案 nodejs：commonjs2
3. 服务端渲染不需要htmlplugin
4. `rimraf dist` 是nodejs的包 专门用来删除文件夹
5. `moudle.exports` nodejs的导出方式
6. commonjs2 的写法 export default。 require的时候加.default
7. 将node启动后渲染出server.js的插入html
8. 新建html文件`new HTMLPlugin({template:path.join(__dirname,'../client/template.html')})`生成的html以template为模板
9. server端读template文件 同步读
```js
const template = fs.readFileSync(path.join(,index.html),'utf8')
res.send(template.replace('<app></app>'),appString)
```

### Webpack-dev-server安装
1. contentBase:静态文件地址
2. hot启动 hot-module-replacement 数据请求也刷新？
3. 黑色弹窗报错
`overlay:{
    errors:true
}`
4. cross-env不同系统环境变量配置 mac上可执行的在windows上可能不行
5. historyApiFailback:{index:'/index.html'404路径返回index
6. webpack.bace放client和server相同的js代码

### hot-module-replacement
1. 在babel配置文件中配置
