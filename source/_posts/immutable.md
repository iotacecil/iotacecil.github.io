---
title: 可变对象和不可变对象
date: 2018-08-30 09:23:15
tags:
category: [并发,java]
---
### 实现immutable类
1. class 声明为final
`public final class String`
2. 成员变量 private final (保证其他线程可见时初始化完成），且没有setter
3. 构造对象时，成员变量使用深度拷贝来初始化。
4. 如果有字段是可变对象，必须是private，不能向外暴露。getter方法，使用 copy-on-write原则(防御性复制），创建私有的 copy。
5. this关键字没有泄露（如匿名内部类在创建的时候修改其状态)

---

final 修饰的 class 代表不可以继承扩展.避免 API 使用者更改基础功能
final 的变量是不可以修改的.，利用final 可能有助于 JVM 将方法进行内联(现代高性能 JVM（如 HotSpot）判断内联未必依赖final 的提示)，可以改善编译器进行条件编译的能力.
final 的方法也是不可以重写的（override）

### 不可变对象模式 `创建后，对外可见状态保持不变`
类图：client通过 Manipulator 类 的  `change`方法生成新的 不可变对象 并set。

#### 不可变对象
因为一个对象的修改是直接替换的，所以不会存在`Location`多线程只修改了一个字段。

!! **如果对象作为key放入HashMap，对象状态变化导致HashCode变化，会导致同样的对象作为Key，get不到相关联的值。 所以不可变对象适合作为Key。**

最佳实战：
电信服务商的路由表`<String,Object>`


#### 模式应用：CopyOnWriteArrayList
对集合加锁：不适合插入删除操作比遍历多的集合。
`CopyOnWriteArrayList` 应用了不可变对象模式。
不用锁的遍历安全。适用于遍历操作比添加删除频繁的场景。
源码：加添元素时会复制
用实例变量静态变量并且`volatile`
```java
private transient volatile Object[] array;
public boolean add(E e) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        int len = elements.length;
        Object[] newElements = Arrays.copyOf(elements, len + 1);
        newElements[len] = e;
        setArray(newElements);
        return true;
    } finally {
        lock.unlock();
    }
}
```

遍历：直接根据 `array` 生成一个新的实例
```java
/**
 * Returns an iterator over the elements in this list in proper sequence.
 *
 * <p>The returned iterator provides a snapshot of the state of the list
 * when the iterator was constructed. No synchronization is needed while
 * traversing the iterator. The iterator does <em>NOT</em> support the
 * {@code remove} method.
 *
 * @return an iterator over the elements in this list in proper sequence
 */
public Iterator<E> iterator() {
    return new COWIterator<E>(getArray(), 0);
}

static final class COWIterator<E> implements ListIterator<E> {
    /** Snapshot of the array */
    private final Object[] snapshot;
    /** Index of element to be returned by subsequent call to next.  */
    private int cursor;

    private COWIterator(Object[] elements, int initialCursor) {
        cursor = initialCursor;
        snapshot = elements;
    }
    ...
}
```

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

