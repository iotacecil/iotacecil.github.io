---
title: systemdesign
date: 2018-08-07 16:47:36
tags:
---
https://www.educative.io/collection/page/5668639101419520/5649050225344512/5668600916475904
### gohash
[poi-gohash](http://www.learn4master.com/interview-questions/system-design/poi-geohash)

### 弹幕系统
一个直播间：
在线人数100万
1000条弹幕/秒
推送频率：100万\*1000条/秒 = 10亿/秒

拉模式：客户端轮询服务端
推模式：长连接 立即推送（时效性）
![websocket.jpg](/images/websocket.jpg)
websocket 将message->frame

go语言携程模型 自带websocket库



### 146 LRU cache HashMap<Integer,DoubleLinkedList>
[Cache replacement policies](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU)
least recently used cache最近最少使用缓存
java:LinkedHashMap:
https://docs.oracle.com/javase/8/docs/api/java/util/LinkedHashMap.html#removeEldestEntry-java.util.Map.Entry-

双向链表+hashmap
{% fold %}
```java
public class LRUCache {
    //双向链表
    class DoubleLinkedNode{
        //和hashmap对应，用于日后扩容
        int key;
        int value;
        DoubleLinkedNode pre;
        DoubleLinkedNode next;
    }
    HashMap<Integer,DoubleLinkedNode> cache;
    int capacity;
    DoubleLinkedNode head;
    DoubleLinkedNode tail;
    //创建一个头节点

    //链表操作：
    //1. get/update中间的node移到链表最前面
    private void move2head(DoubleLinkedNode node){
        /**** star ****/
        this.remove(node);
        this.addNode(node);
    }
    //2. put1 头插
    private void addNode(DoubleLinkedNode node){
        node.pre = head;
        node.next = head.next;

        head.next.pre = node;
        head.next = node;
    }
    //3. put2 删除节点 (1删除中间的，移到最开头 2.删除尾巴)
    private void remove(DoubleLinkedNode node){
        DoubleLinkedNode pre = node.pre;
        DoubleLinkedNode next = node.next;
        pre.next = next;
        next.pre = pre;
    }
    //4.删除尾巴,
    private int removeTail(){
        DoubleLinkedNode pre = tail.pre;
        this.remove(pre);
        return  pre.key;

    }

    public LRUCache(int capacity) {
        cache = new HashMap<>();
        this.capacity = capacity;
        //创建一个头节点
        head = new DoubleLinkedNode();
        head.pre = null;
        //创建一个空尾巴
        tail = new DoubleLinkedNode();
        tail.next= null;

        head.next = tail;
        tail.pre = head;


    }

    public int get(int key) {
        DoubleLinkedNode node = cache.get(key);
        if(node == null)
            return -1;
        move2head(node);
        return node.value;
    }

    public void put(int key, int value) {
        DoubleLinkedNode node = cache.get(key);
        if(node == null) {
            //插入新值
            DoubleLinkedNode newNode = new DoubleLinkedNode();
            newNode.key = key;
            newNode.value = value;
            //1. 考虑容量剩余,满不满都要插入，但是满了要先删除
            if (capacity == 0) {
                //删除尾巴

                int deleteKey = removeTail();
                cache.remove(deleteKey);
                capacity++;
            }
            //2. 插入队列
            addNode(newNode);
            //3. 加入hash
            cache.put(key, newNode);
            capacity--;
        }else {
            node.value = value;
            move2head(node);
        }

    }
    public static void main(String[] args) {
        LRUCache cache = new LRUCache( 2 /* capacity */ );

        cache.put(1, 1);
        cache.put(2, 2);
        cache.get(1);       // returns 1
        cache.put(3, 3);    // evicts key 2
        cache.get(2);       // returns -1 (not found)
        cache.put(4, 4);    // evicts key 1
        cache.get(1);       // returns -1 (not found)
        cache.get(3);       // returns 3
        System.out.println(cache.get(4));
    }
}
```
{% endfold %}

### 604. Design Compressed String Iterator
https://leetcode.com/articles/desing-compressed-string-iterator/

不需要预处理的O(1)：
```java
int p=0;
int num=0;
char next(){
    if(!hasNext)return ' ';
    char ch = s.charAt(p++);
    while(p<res.length&&Character.isDigit(s.charAt(p)))
        num = num*10+res.charAt(p++)-'0';
    num--;
    return ch;
}
boolean hasNext(){
    return p!=s.length()||num!=0;
}
```

时间空间复杂度O(n) 压缩编码的长度n
> L1e2t1C1o1d1e1
> ->[1, 2, 1, 1, 1, 1, 1]
> ->[L, e, t, C, o, d, e]

```java
int[] nums = Arrays.stream(cmprs.substring(1).split("[a-zA-z]")).mapToInt(Integer::parseInt).toArray();
String[] chars = cmprs.split("[0-9]+");
```
next,hasNext

{% fold %}
```java
int p=0;
public char next() {
    if(!hasNext()){
        return ' ';
    }
    nums[p]--;
    char out = chars[p].charAt(0);
    if(nums[p]==0)p++;
    return out;
}
public boolean hasNext() {
    return p!=chars.length;
}
```
{% endfold %}

### 535 短链接
Base62 编码是由 10 个数字 26 个大些英文字母和 26 个小写英文字母组成
`base63(md5(str))[6:]`
功能要求：
1.过期时间，用户能延长过期时间
2.自定义短链接

非功能要求：
1.系统高可用
2.重定向的延迟
3.连接地址不可预测

扩展：
1.重定向多少次
2.REST api
