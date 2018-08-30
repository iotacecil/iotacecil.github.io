---
title: 可变对象和不可变对象
date: 2018-08-30 09:23:15
tags:
---
### 可变对象
#### (可变Integer)
输出objTest{val=888}地址1670782018 objTest{val=888}地址1670782018

```java
class  objTest{
    int val = 0;
    public objTest(int val) {
        this.val = val;
    }

    @Override
    public String toString() {
        return "objTest{" +
                "val=" + val +
                '}';
    }
}
  private static void dfsObj(List<objTest> rst,objTest tmp,int idx){
        if(tmp.val==999){
            rst.add(tmp);
        }
        for (int i = idx; i <4 ; i++) {
            tmp.val=999;
            dfsObj(rst,tmp,idx+1);
            tmp.val=888;
        }
    }
```
#### 数组 同理List
输出：[[I@5674cd4d, [I@5674cd4d,
```java
List<int[]> rst5 = new ArrayList<>();
dfsarr2(rst5,new int[]{0},0);
 private static void dfsarr2(List<int[]> rst,int[] tmp,int idx){
        if(tmp[0]==3){
            rst.add(tmp);
        }
        for(int i =idx;i<4;i++){
            tmp[0]=3;
           dfsarr2(rst,tmp,idx+1);
           tmp[0]=1;
        }
    }
```

### 不可变对象：Integer 注意-127~128有cache 同理String，Double
> 的基本数据类型的包装类（如Integer 、 Long 和 Float ）都是不可变的，其它数字类型（如 BigInteger 和 BigDecimal ）也是不可变的。

输出：每次地址不一样
1002地址1450495309 1002地址1670782018 1002地址1706377736 1002地址468121027 
```java
private static void dfsInteger(List<Integer> rst,Integer i,int idx){
        if(i.equals(999+3)){
            rst.add(i);
            return;
        }
        for(int j=idx;j<4;j++){
            i++;
            dfsInteger(rst,i,j+1);
            i--;
        }}
public static void main(String[] args) {
    List<Integer> rst2 = new ArrayList<>();
    dfsInteger(rst2,Integer.valueOf(999),0);
    System.out.println();
    System.out.println("Integer结果 ");
    for(Integer i:rst2){

        System.out.print(i+"地址"+System.identityHashCode(i)+ " ");

    }
}
```

#### 不可变对象的源码：
Double
```java
private final double value;
```
Integer
```java
private final int value;
```
String
```java
private final char value[];
```
不可变容器：
```java
Map<Integer,Integer> map = new HashMap<>();
map.put(1,1);
//java.lang.UnsupportedOperationException
Map<Integer, Integer> unmodifiableMap = Collections.unmodifiableMap(map);
unmodifiableMap.put(2,2);
```
实现源码 
```java
private final Map<? extends K, ? extends V> m;
```

重写了方法直接抛异常
```java
public V put(K key, V value) {
    throw new UnsupportedOperationException();
}
public V remove(Object key) {
    throw new UnsupportedOperationException();
}
public void putAll(Map<? extends K, ? extends V> m) {
    throw new UnsupportedOperationException();
}
public void clear() {
    throw new UnsupportedOperationException();
}
```

#### 可变对象源码
ArrayList
```java
transient Object[] elementData;
private static final Object[] EMPTY_ELEMENTDATA = {};
```

