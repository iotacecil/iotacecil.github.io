---
title: MVVM
date: 2018-04-19 20:34:27
tags:
category: [js前端常用svgcanvasVue框架jquery源码]
---
### 实现myvue.b=222页面刷新
1. 
  ```html
  <div id="app"><p>{{a.a.a}}</p><p>{{b}}</p></div>
  ```
  ```js
  let myvue = new myVue({
      el:'#app',
      data:{a:{a:{a:1}},b:'aaaaaaaaaaa'}
    });
  ```
2. 
```js
function myVue(options={}) {//传入的对象（{el:,data:}
  //将所有属性挂载在$opthion
  this.$options = options
  var data = this._data=this.$options.data //用data别名._data
  observe(data)//----------->数据劫持
  for(let key in data){ //--> this代理了this._data
    Object.defineProperty(this,key,{
      enumerable:true,
      get(){
        return this._data[key]//this.a={a:1}
      },
      set(newVal){
        this._data[key]=newVal
      }
    })
  }
  ///-------渲染
   new Compile(options.el,this)
}
```

3. 数据劫持（观察者）对_data定义get/set属性
```js
function Observer(data) {
  for(let key in data){
                         // let dep = new Dep()
    let val = data[key]
    observe(val)//递归
    Object.defineProperty(data,key,{
      enumerable:true,
      get() {
                    // -- watcher里的this
                    //只有target绑定了this(Watcher函数) 才把watcher函数放入dep队列
                    Dep.target&&dep.addSub(Dep.target)
        return val;
      },
      set(newVal){
        if(newVal===val)return
        val=newVal
        //----深度数据劫持myvue.a={a:1} 里面的a也有get/set
        observe(newVal)
                    // dep.notify()
      }
    })
  }
}

//观察对象，给对象添加define...
function observe(data) {
  if(typeof data !== 'object')return
    //为方便递归
  return new Observer(data)
}
```
3. 渲染
```js
function Compile(el,vm) {
  vm.$el=document.querySelector(el);
  //创建文档碎片
  let fragment = document.createDocumentFragment();
  // console.log(vm.$el.firstChild)
  //移到内存中
  while(child = vm.$el.firstChild){
    fragment.appendChild(child)
  }
  replace(fragment)
    function replace(fragment) {
    //从DOM元素节点集合返回一个数组
    Array.from(fragment.childNodes).forEach(function (item) {
      let text = item.textContent
      let reg = /\{\{(.*)\}\}/
      //nodeType=3文本节点
      if(item.nodeType===3&&reg.test(text)){
        //获取匹配的第一个分组
        //是标签 nodeType=1
        let arr = RegExp.$1.split('.')//[a.a]
        let val = vm//---->vm=myvue
        arr.forEach(function (k) {//val=vm[a]->val=vm[a][a]
          val = val[k]
        })
                // //----------- 监听替换位置
                // new Watcher(vm,RegExp.$1,function (newVal) {
                //   item.textContent = text.replace(reg,newVal)

                // })
        item.textContent = text.replace(reg,val)}
      if(item.childNodes){
        replace(item)
      }
    })
  }
}
```
4. 订阅器：接受更新重新渲染
 1. 订阅器[fn1,fn2]方法集合
 ```javascript
 function Dep() {this.subs =[]}
 ```
 2. 订阅器添加方法、订阅器中方法全部执行(约定订阅"update方法")
```javascript
Dep.prototype.addSub= function (sub) {
  this.subs.push(sub)
}
//假设每个方法里都有update方法 遍历激活
Dep.prototype.notify= function () {
  this.subs.forEach(sub=>sub.update())
}
```
5. 订阅者（Dep数组中的方法类，被激活的方法类)
 1. 在观察者Observer中注册`let dep = new Dep()`
 2. 订阅事件在渲染Compile中
```javascript
 new Watcher(vm,RegExp.$1,function (newVal) {
          item.textContent = text.replace(reg,newVal)
        })
```
 3. 定义watcher并添加到订阅中
```javascript
 function Watcher(vm,exp,fn) {
    this.fn = fn
    this.vm= vm
    this.exp = exp
    Dep.target = this;
  
    let val = vm;
    let arr = exp.split('.')
    arr.forEach(function (k) {//调用get方法
      val = val[k]
    })
    Dep.target=null
}
```
 4. 调用get方法更新时添加`Dep.target&&dep.addSub(Dep.target)`
 5. 在set中执行订阅器中所有watcher的方法`dep.notify()`
 ```js
 Watcher.prototype.update=function () {
    //取最新的值
  let val = this.vm
  let arr = this.exp.split('.')
  arr.forEach(function (k) {//调用get方法
    val = val[k]
  })
  //将新值传给回调函数
  this.fn(val)
}
 ```
 6. `this.fn(val)`回调函数会回到渲染中,用新值替换
 ```js
  new Watcher(vm,RegExp.$1,function (newVal) {
          item.textContent = text.replace(reg,newVal)
        })
```

====效果：
1.myvue.b放入队列
2.myvue.b=222先调用set，调用notify
3.执行watcher的update
4.回调函数fn更新页面

---

### 实现v-model 双向数据绑定
![nodemap.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/nodemap.jpg)
```html
<div id="app"><p>{{a.a.a}}</p><p>{{b}}</p><input type = "text" v-model="b"></div>
```
找到带v-的元素并获得v-model绑定的属性；在渲染中添加监听器；并添加触发事件
```js
 if(item.nodeType==1){
        //如果是元素节点 获取所有dom属性
        let nodeAttrs = item.attributes;
        Array.from(nodeAttrs).forEach(function (attr) {
            //获取v-model后的属性 //b
          if(attr.name.indexOf('v-')==0){
            let exp = attr.value
            //初始输入框填值
            item.value = vm[exp]
             //订阅每次更改都更新
            new Watcher(vm,exp,function (newVal) {
              item.value = newVal
            })
            //定义触发事件
            item.addEventListener('input',function (e) {
              console.error(e)
              let newVal = e.target.value
              vm[exp] = newVal//调用set方法->notify->更新watcher
            })
          }
        })
      }
```
### 实现computed的缓存 绑数据挂到vm上
```html
<div>{{hello}}<div>
```
```js
computed:{
      hello(){
        return this.b+this.a
      }
    }
```

```js
function myVue(options={}) {
    ...
    initComputed.call(this)
} 
```
```js

```