---
title: js彩票项目
date: 2018-12-14 19:24:16
tags: [js]
category: [项目练习]
---
### mongodb react
前端
```shell
cnpm install -g create-react-app
yarn config set sass-binary-site http://npm.taobao.org/mirrors/node-sass
npm config set sass-binary-site http://npm.taobao.org/mirrors/node-sass
yarn create react-app reactlearn
cnpm install redux --save
```
```shell
cnpm install express --save
```
新建server文件夹
新建server.js
```js
const app = express()
app.get('/',function (req,res) {
    res.send('<hi>Hello word</hi>')
    
})
app.get('/data',function (req,res) {
    res.json({name:'小明'})

})
app.listen(9093,function () {
    console.log("输入正确")
})
```

运行：`node server.js`
访问9093成功

node 热加载
```shell
npm install -g nodemon`
nodemon server.js
```

mongodb
```shell
sudo yum install -y mongodb-org
whereis mongod
service mongod start
>use admin
>db.createUser(
  {
    user: "root", //用户名
    pwd: "123456", //密码
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] //设置权限
  }
)
vi /etc/mongod.conf 
service mongod restart
mongo -u root -p 123456
```

node mongodb
```shell
cnpm install mongoose --save
```

暂时先关掉auth

service
```js
const mongoose = require('mongoose')

// 连接数据库
const DB_URL = 'mongodb://10.1.18.20:27017/reactlearn'
mongoose.connect(DB_URL)
mongoose.connection.on('connected',function () {
    console.log("成功连接mongodb")
})
// 定义文档模型
const User = mongoose.model('user',new mongoose.Schema({
    name: {type:String,requier:true},
    age: {type:Number,requier:true}
}))
// 添加数据
User.create({
    name:'wangwu',
    age:18
},function (err,doc) {
    if(!err){
        console.log(doc)
    }else{
        console.log(err)
    }
})
// 删除数据
User.remove({age:18},function (err,doc) {
    if(!err){
        console.log(doc)
        User.find({},function (e,d) {
            console.log(d)
        })
    }
})
// 更新
User.update({'name':'zhangsan'},{'$set':{age:26}},function (err, doc) {
    console.log(doc)
})

const app = express()
 // 查询
app.get('/data',function (req,res) {
    User.find({"age":26},function (err,doc) {
        res.json(doc)
    })
})
```

### antd
```shell
cnpm install antd-mobile
# 按需加载
yarn eject
npm install babel-plugin-import --save-dev
```



### 目录结构
```
/app
    - /app/js
        - /app/js/class
            - /app/js/class/test.js
        - /app/js/index.ejs
    - /app/css
    - /app/views
        - /app/views/error.ejs
        - /app/views/index.ejs
/server
/tasks
    - /tasks/util
        - /tasks/util/args.js
    - /tasks/scripts.js
package.json
.babelrc
gulpfile.babel.js
```

### 搭建server
```shell
npm install express-generator -g
\server>express -e .
npm install
```

### 构建工具
文件合并，脚本编译，模板自动更新
创建命令行工具


### 生成依赖文件package.json
`npm init`

### bebal配置
```
.babelrc
```

### gulp 配置文件
```
gulpfile.babel.js
```

### args.js
```javascript
// 命令行参数包
import yargs from 'yargs';

// 区分开发环境和线上环境
const args = yargs
    .option('production',{
        boolean:true,
        default:false,
        describe: 'min all scripts'
    })

// 开发环境自动编译
    .option('watch',{
        boolean:true,
        default:false,
        describe: 'watch all files'
    })
// 命令行输出详细日志
    .option('verbose',{
        boolean:true,
        default:false,
        describe: 'log'
    })
// source map
    .option("sourcemaps",{
        describe:'force the creation of sroucemaps'
    })
    // 服务器端口
    .option("port",{
        string:true,
        default:8080,
        describe:'server port'
    })
    // 以字符串解析
    .argv
```

### gulp打包脚本
