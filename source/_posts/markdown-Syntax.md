---
title: markdown Syntax
date: 2018-03-03 10:08:24
tags: markdown
ategory: [博客相关操作]
---
将 markdown 的图片标签全部换成七牛云的大括号
正则`!\[.*\]\(\/images\/(.*)\)` 替换成 `{ % q n i m g $1 %}` 

---

[网页字体颜色](http://www.w3school.com.cn/tags/html_ref_colornames.asp)

---

将七牛云图片换成腾讯云
```
{ % q n i m g ((\w)*.(\w)*) %}
```

 换成

```
![$1](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/$1)
```

后面加括号补救
`(!\[(\w)*.(\w)*\]\((\S)*)` 换成 `$1)`

浅红色文字：<font color="#FF98AA">浅红色文字：</font><br /> 
{% cq %} blah blah blah {% endcq %}
{% note class_name %} Content (md partial supported) {% endnote %}


