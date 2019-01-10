---
title: js彩票项目
date: 2018-12-14 19:24:16
tags: [js]
category: [项目练习]
---
### mongodb react
```shell
cnpm install -g create-react-app
yarn config set sass-binary-site http://npm.taobao.org/mirrors/node-sass
npm config set sass-binary-site http://npm.taobao.org/mirrors/node-sass
yarn create react-app reactlearn
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
