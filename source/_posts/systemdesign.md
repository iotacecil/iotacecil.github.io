---
title: systemdesign
date: 2018-08-07 16:47:36
tags:
categories: [算法备忘]
---
https://soulmachine.gitbooks.io/system-design/content/cn/api-rate-limiting.html
https://wizardforcel.gitbooks.io/system-design-primer/4.html#%E7%B3%BB%E7%BB%9F%E8%AE%BE%E8%AE%A1%E4%B8%BB%E9%A2%98%E4%BB%8E%E8%BF%99%E9%87%8C%E5%BC%80%E5%A7%8B
https://www.educative.io/collection/page/5668639101419520/5649050225344512/5668600916475904

### 729 Calendar1 时间区间有无重叠
1.`List<int[]>`
两个区间是否重叠`s1<e2&&e1>s2`
另一种思考
![729overlap.jpg](/images/729overlap.jpg)
{% fold %}
```java
class MyCalendar {
List<int[]> calendar;
public MyCalendar() {
    calendar = new ArrayList<>();
}

public boolean book(int start, int end) {
    for(int[] it:calendar){
        if(it[0]<end&&start<it[1])return false;
    }
    calendar.add(new int[]{start,end});
    return true;
}
}
```
{% endfold %}

2.维持一个排序的map(红黑树）二分查找，start当key，end当value

#### TreeMap
如果不存在，返回小于查询的最大key
`final Entry<K,V> getFloorEntry(K key)`
```java
public K floorKey(K key) {
        return keyOrNull(getFloorEntry(key));
    }
```
如果不存在，返回大于查询的最小key
```java
public K ceilingKey(K key) {
        return keyOrNull(getCeilingEntry(key));
    }
```
只需要查找query start 的floor的end
         query start 的ceil的start
```java
class MyCalendar {
    TreeMap<Integer,Integer> calendar;
    public MyCalendar() {
        calendar = new TreeMap<>();
    }
    public boolean book(int start, int end) {
        Integer prev = calendar.floorKey(start);
        Integer next = calendar.ceilingKey(start);
        if((prev==null||calendar.get(prev)<=start)
            &&(next==null||end<=next)){
            calendar.put(start,end);
            return true;
        }
        return false;
    }
}
```
### 731 不三重预定的日历

### Haversine formula
计算经纬度之间的球面距离


### 布隆过滤器 url去重
https://blog.csdn.net/v_july_v/article/details/6685894

### 746. Design Tic-Tac-Toe 井字棋


### 380insert/delete O(1)，getRandom O(1)的数据结构
```java
class RandomSet{
    Map<Integer,Integer> valIdx;
    List<Integer> list;
    Random rand = new Random();
     public RandomSet() {
        valIdx = new HashMap<>();
        list = new ArrayList<>();
    }
    public boolean insert(int val){
        if(valIdx.containsKey(val))return false;
        valIdx.put(val,list.size());
        list.add(val);
        return true;
    }
    public boolean remove(int val){
        if(!valIdx.containsKey(val))return false;
        int idx = valIdx.get(val);
        int last = list.get(list.size()-1);
        //最后一个插到前面
        list.set(idx,last);
        valIdx.put(last,idx);
        //删除
        list.remove(list.size()-1);
        valIdx.remove(val);
        return true;
    }
    public int getRandom(){
        return list.get(rand.nextInt(list.size()));
    }
}
```



### LFU

### gohash
[poi-gohash](http://www.learn4master.com/interview-questions/system-design/poi-geohash)

http://redisdoc.com/geo/geoadd.html
redis使用的geohash编码长度为26位。可以精确到0.59m的精度。

将经纬度->字符串，一个字符串表示一个矩形，可以用字符串前缀匹配查找范围

算法步骤：
精确度
https://en.wikipedia.org/wiki/Geohash
https://www.cnblogs.com/LBSer/p/3310455.html
1. 通过对经纬度二分查找不断逼近，将经纬度变成01序列
> 纬度产生的编码为10111 00011，经度产生的编码为11010 01011。偶数位放经度，奇数位放纬度，把2串编码组合生成新串：11100 11101 00100 01111。

2. 用0-9、b-z（去掉a, i, l, o）这32个字母进行base32编码，将11100 11101 00100 01111转成十进制，对应着28、29、4、15，十进制对应的编码就是wx4g。

实现：
https://github.com/kungfoo/geohash-java
编码部分
Point:
```java
public class Point {
    private final double longitude;
    private final double latitude;
}
```

```java
public class GeoHash {
private static final char[] base32 = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'b', 'c', 'd', 'e', 'f','g', 'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };
private static final int MAX_BIT_PRECISION = 64;
protected byte significantBits = 0;
protected long bits = 0;
//最后+1
protected final void addOnBitToEnd() {
    significantBits++;
    bits <<= 1;
    bits = bits | 0x1;
}
//最后+0
protected final void addOffBitToEnd() {
    significantBits++;
    bits <<= 1;
}
    //1.获得经纬度交叉的byte
private GeoHash(double latitude, double longitude, int strlen) {
    int desiredPrecision = (strlen * 5 <= 60) ? strlen * 5 : 60;
    point = new Point(latitude, longitude);
    desiredPrecision = Math.min(desiredPrecision, MAX_BIT_PRECISION);

    boolean isEvenBit = true;
    double[] latitudeRange = { -90, 90 };
    double[] longitudeRange = { -180, 180 };
    //偶数是经度
    while (significantBits < desiredPrecision) {
        if (isEvenBit) {
            divideRangeEncode(longitude, longitudeRange);
        } else {
            divideRangeEncode(latitude, latitudeRange);
        }
        isEvenBit = !isEvenBit;
    }

    setBoundingBox(this, latitudeRange, longitudeRange);
    //变成64位
    bits <<= (MAX_BIT_PRECISION - desiredPrecision);
}
private void divideRangeEncode(double value, double[] range) {
    double mid = (range[0] + range[1]) / 2;
    if (value >= mid) {
        addOnBitToEnd();
        range[0] = mid;
    } else {
        addOffBitToEnd();
        range[1] = mid;
    }
}
    //2. base32编码成String
 public String toBase32() {
    if (significantBits % 5 != 0) {
        throw new IllegalStateException("Cannot convert a geohash to base32 if the precision is not a multiple of 5.");
    }
    StringBuilder buf = new StringBuilder();

    long firstFiveBitsMask = 0xf800000000000000l;
    long bitsCopy = bits;
    int partialChunks = (int) Math.ceil(((double) significantBits / 5));

    for (int i = 0; i < partialChunks; i++) {
        int pointer = (int) ((bitsCopy & firstFiveBitsMask) >>> 59);
        buf.append(base32[pointer]);
        bitsCopy <<= 5;
    }
    return buf.toString();
}
```
测试
dr4jb0bn21
dr373nzzdr
f2kjs72830
```java
GeoHash hash1 = new GeoHash(40.390943,-75.9375,10);
GeoHash hash2 = new GeoHash(41.390943,-76.9375,10);
GeoHash hash3 = new GeoHash(47.390943,-72.9375,10);
System.out.println(hash1.toBase32());
assert (hash1.toBase32().equals("dr4jb0bn21")):"不等于dr4jb0bn21";
System.out.println(hash2.toBase32());
System.out.println(hash3.toBase32());
```
加入表示的矩形
```java
public class BoundingBox {
    private double minLat;
    private double maxLat;
    private double minLon;
    private double maxLon;
    public BoundingBox(Point p1, Point p2) {
        this(p1.getLatitude(), p2.getLatitude(), p1.getLongitude(), p2.getLongitude());
    }
    public BoundingBox(double y1, double y2, double x1, double x2) {
        minLon = Math.min(x1, x2);
        maxLon = Math.max(x1, x2);
        minLat = Math.min(y1, y2);
        maxLat = Math.max(y1, y2);
    }

public Point getUpperLeft() {
    return new Point(maxLat, minLon);
}
public Point getLowerRight() {
    return new Point(minLat, maxLon);
}
public String toString() {
    return getUpperLeft() + " -> " + getLowerRight();
}
}
```
构造函数最后加上,利用划分最后的经纬度区间
`setBoundingBox(this, latitudeRange, longitudeRange);`
```java
private static void setBoundingBox(GeoHash hash, double[] latitudeRange, double[] longitudeRange) {
    hash.boundingBox = new BoundingBox(new Point(latitudeRange[0], longitudeRange[0]), new Point(
            latitudeRange[1],
            longitudeRange[1]));
}
```

查询部分：给定senter和半径，查询


算法正确性：
二分法分割空间成01是Peano空间填充曲线。
> Peano曲线就是一种四叉树线性编码方式
![geohash.jpg](/images/geohash.jpg)

但是Peano曲线有突变性，0111和1000并不邻近。
解决方法是查询时用周围点一起查询。
数据库只需要存经纬度，查询字符串之后计算距离。

为什么需要空间索引：
http://www.cnblogs.com/LBSer/p/3392491.html
矩形过滤 遍历复杂度高
```sql
select id,name from poi where lng between 116.3284 and 116.3296 and lat between 39.9682 and 39.9694;
```
对维度建立索引 遍历复杂度变成Log(N)
```sql
alter table lbs add index latindex(lat);
```
> B树其实可以对多个字段进行索引，但这时需要指定优先级，形成一个组合字段，而空间数据在各个维度方向上不存在优先级，我们不能说纬度比经度更重要，也不能说纬度比高程更重要。

其他的空间填充曲线Hilbert最好
```
 0  3  4  5 58 59 60 63 
 1  2  7  6 57 56 61 62 
14 13  8  9 54 55 50 49 
15 12 11 10 53 52 51 48 
16 17 30 31 32 33 46 47 
19 18 29 28 35 34 45 44 
20 23 24 27 36 39 40 43 
21 22 25 26 37 38 41 42 
```
![hilbert.jpg](/images/hilbert.jpg)

索引线、折线或者多边形R-tree

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
