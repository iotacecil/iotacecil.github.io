---
title: svg
date: 2018-07-20 12:42:39
tags:
---
### 基本图形
`<elipse>`椭圆，cx,cy是圆心
`<polyline>`标签中间用ponits="x1 y1 x2 y2 x3 y3" 同理`<polygon>`
svg画一个三角形
```html
<svg>
<polyline
    points="250 120
            300 220
            200 220"
    stroke="red"
    fill="none">
</polyline>
</svg>
```
---
`fill`填充颜色
`stroke`描边颜色
`stroke-width`描边粗细
`transform`

---
### 操作api：
做一个svg编辑器
html5中inut的type：color调色盘，range进度条
1.创建svg标签并设置svg标签属性，挂载到dom树
```javascript
//命名空间
function createSVG(){
    var SVG_NS = 'http://www.w3.org/2000/svg';
    var svg = document.createElementNS(SVG_NS, 'svg');
    svg.setAttribute('width', '100%');
    svg.setAttribute('height', '100%');
    _svg.appendChild(svg);
    return svg
}
```
