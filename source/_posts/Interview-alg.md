---
title: 每日Review
date: 2018-10-11 11:13:55
tags:
categories: [算法备忘]
---
### 循环数组找一个数

### 如何用最少的步骤称出13颗1g砝码中的赝品
https://blog.csdn.net/zhtengsh/article/details/38879431

### 一个圆中三个点构成一个锐角三角形的概率
圆内接三角形的最大角至少要大于等于60度，该最大角的范围可从60到180度变化，但只有60到90间为锐角，所以占1/4.

### 字节流和字符流，读取一个配置文件读一行 写入数据库

two sum
如果数字在最后怎么优化
如果有序two sum怎么做
three sum

### String2Integer

### 16 快速排序
基本：
最普通的，每次取[0]作子集划分s1+[0]+s2,再递归两个子集。
最坏情况123456 O(n^2)
```java
private void qS(int[] arr,int left,int right){
        if(left>=right)return;
        int pivot = arr[right];
        // 因为保证i最后在左集合右边 用++i 
        // 所以初始化的时候边界都向外扩一格
        int i = left-1;int j = right;
        while (true){
            // 关键 i<j
            while (++i<j && arr[i] <= pivot);
            while (--j>i && arr[j] >= pivot);
            if(i < j){
                swap(arr,i , j);
            }
            else break;
        }
        // 把主元放到左集合右边
        swap(arr, i, right);
        qS(arr, left, i-1);
        qS(arr, i+1,right);
    }
```

注意1：
主元：1取头、中、尾的中位数比随机函数便宜。
用ifelse判断这三个数，1)把最小的放到左边2)把最大的放到右边3)把中间的数替换到最后位置上
`pivot = nums[n-1]`

然后用pivot划分子集，i从左开始，j从右开始,i最后停在j右边，交换`[i],[n-1]`，pivot放了正确的位置。

注意2：
如果有重复元素 如果11111，
1）重复元素也交换，最后pivot也会被换到中间，很等分nlogn。
2）不交换，i直接比较到最后，pivot还是在最后，变成n^2

注意3：
小规模数据集（N不到100可能还不如插入排序）
当递归的长度够小直接插入排序。

JDK `Arrays.sort()`中的根据阈值从merge，quick，insert，count sort中选一个
{% fold %}
```java
/**如果数组长度小于 this, Quicksort 优先于 merge sort.*/
private static final int QUICKSORT_THRESHOLD = 286;

/**如果数组长度小于 this , insertion sort 优先于 Quicksort.*/
private static final int INSERTION_SORT_THRESHOLD = 47;

/**如果Byte数组长度大于this, counting sort 优先于 insertion sort. */
private static final int COUNTING_SORT_THRESHOLD_FOR_BYTE = 29;

/** 如果short or char 数组长度大于 this, counting sort 优先于 Quicksort.*/
private static final int COUNTING_SORT_THRESHOLD_FOR_SHORT_OR_CHAR = 3200;

```
{% endfold %}

### 17 堆排序 不需要额外空间 大顶堆
堆（数组实现的完全二叉树）
左孩子是`(1+i<<1)` // 1+i<<2 奇数
右孩子是`(i+1)<<1` //偶数
父节点是`(i-1)>>1`

堆排序：
线性复杂度将数组调成最大堆O(n)，将堆顶和数组最后交换，堆规模-1，再调成最大堆。

```java
heapify(arr);
for (int i = 0; i <arr.length ; i++) {
    swap(arr,0,n-1-i);
    shiftDown(arr,0,n-1-i);
}
```

建堆方法1：
从上到下，每个新加的结点放在最右下，然后shiftUp每个 复杂度O(nlogn) (都可以做全排序了)
正确方法：
思路：
每个叶节点都成一个子堆，下滤操作能完成两个子堆的合并。

```java
//大顶堆
private static void shiftDown(int[] arr,int idx,int n){
    int lowest = n/2;
    while(idx < lowest){
        int left = (idx*2) + 1;
        int right = left + 1;
        if(right < n && arr[left]<arr[right] && arr[right]>arr[idx]){
            swap(arr,idx,right);
            idx = right;
        }else if(arr[idx] < arr[left]){
            swap(arr,idx,left);
            idx = left;
        }else break;
    }
}

private static void heapify(int[]arr){
    int n = arr.length;
    for(int i = (n-1)/2;i>=0;i--){
        shiftDown(arr,i,n);
    }
}
```

复杂度：
复杂度每个节点只需要比较的长度最多是这个节点到叶子的高度（而不是在树中的深度）。O(N)的
因为二叉树越底层节点越多。深度越高节点越多，所以上滤复杂度高。

从右下开始依次下滤，所有叶子节点都不用下滤。
如果全堆大小为n，内部节点最后一个的idx是`(n/2)-1`
例子：一共9个节点 各层1，2，4，2个。最后一个内部节点是3，它的右边和下面都是叶子。

向堆添加节点（添加在数组最后，上滤）
```java
private void shifUp(int[] arr,int i,int x){
    while (i>0){
        int parent = (i-1)>>>1;
        int e = arr[parent];
        if(e >= x)break;
        // 下移父节点
        arr[i] = e;
        i = parent;
    }
    arr[i] = x;
}
```


### 32 递归冒泡排序
```java
public void bubblesort(int[] array,int n) {
    if (n == 1)
        return;
    if (array == null || array.length == 0)
        return;
    for (int i = 0; i < n - 1; i++) {
        if (array[i] > array[i + 1]) {
            swap(array,i,i+1);
        }
    }
    bubblesort(array, n - 1);
}
```

### 37 二分
2.[0,len) 保持len取不到 
[0]:l=0,r=1,l++,while(l==r)的时候应该结束
好处：len就是长度[a,a+len)，[a,b)+[b,c)=[a,c),[a,a)是空的
```java
int l = 0,r = n;
while(l<r){
    int mid = l+(r-l)/2;
    if(arr[mid]==target)return mid;
    if(arr[mid]>target){
        //在左边，边界为取不到的数
        r=mid;//[l,mid)
    }else{
        //左闭又开
        l = mid+1;//[mid+1,r)
    }
}
//如果l==r [1,1)表示空的
return -1;
```

### 40 !!!线程安全的单例模式
单元素枚举类是实现Singleton的最佳方法
```java
public enum Singleton{

    //定义1个枚举的元素，即为单例类的1个实例
    INSTANCE;

    // 隐藏了1个空的、私有的 构造方法
    // private Singleton () {}

}
// 获取单例的方式：
Singleton singleton = Singleton.INSTANCE;
```

【初始化占位类模式】
如果是静态初始化对象不需要显示同步。
静态初始化：JVM在类初始化阶段执行，在类加载后并在线程执行前。JVM会获取锁确保这个类已经被加载。任何一个线程调用`getInstance`的时候会使静态内部类被加载和初始化。
```java
public class Singleton {  
    private static class SingletonHolder {  
        private static final Singleton INSTANCE = new Singleton();  
    }  
    private Singleton (){}  
    public static final Singleton getInstance() {  
        return SingletonHolder.INSTANCE; 
    }  
}
```

用反射强行调用私有构造函数可以创建多个实例。防止序列化：重写私有的`readReslove()` 当反序列化readObject()的时候会直接调用readReslove替换原本的返回值。

双重检查锁已经被广泛地废弃了！

懒加载 推迟高开销的对象初始化操作。
同步 double checked locking 
只希望在第一次创建 实例的时候进行同步
创建对象分为3个步骤：
1）分配内存
2）初始化对象
3）obj指向内存地址
关键：（2）、（3）会被重排序（因为理论上单线程不会有错，而且能提高性能），导致obj不未空，但还没初始化，所以volatile禁止重排序。
如果两个操作之间没有happens-before则JVM可以重排序。
Volatile变量规则。对一个volatile修饰的变量，对他的写操作先行发生于读操作。

特别对于有final字段的对象，构造函数完成的时候才完成final的写入。
初始化安全：防止对对象的初始引用被重排序到构造过程之前。

```java
public class LazySingle(){
    private volatile static LazySingle obj = null;
    private LazySingle(){}
    public static getInstance(){
        if(obj == null){
            // 1.只有一个线程能进来
            synchronized(LazySingle.class){
                if(obj == null){
                    obj = new LazySingle();}}}
        return obj;
}}
```

方法2：静态内部类

### 42  2进制字符串转16进制
```java
 String b2h(String bins){
    int n = bins.length();
    String hexs = "0123456789abcdf";
    StringBuilder sb = new StringBuilder();
    //0101 n =4
    while (n>=4){
        int idx = (bins.charAt(n - 1) - '0') +
                ((bins.charAt(n - 2) - '0') * 2) +
                ((bins.charAt(n - 3) - '0') * 4) +
                ((bins.charAt(n - 4) - '0') * 8);
        System.out.println(n);
        sb.append(hexs.charAt(idx));
        n-=4;
    }
    int last = 0;int cnt = 0;
    while (n>0){
        last += (bins.charAt(n-- - 1) - '0')*(1<<(cnt++));
    }
    sb.append(hexs.charAt(last));
    return sb.reverse().toString();
}
```

### 43 !十进制转2进制
没有oj过
```java
public String D2Bin(int de){
    StringBuilder sb = new StringBuilder();
    while (de != 0){
        sb.insert(0,de&1);
        de >>>= 1;
    }
    return sb.toString();
}
```

### 44 编辑距离
1）定义`dp[n][m]`表示从s1的前n个字符->s2的前m个字符最少的编辑距离。
2）加一个：[n-1][m]+1
   减一个: [n][m-1]+1
   变一个:[n-1][m-1] +1 
   相等：[n-1][m-1]
```java
public int minDistance(String word1, String word2) {
    int n = word1.length();
    int m = word2.length();
    int[][] dp = new int[n+1][m+1];
    for(int i =0;i<=n;i++){dp[i][0] = i;}
    for(int i =0;i<=m;i++){dp[0][i] = i;}
    for(int i =1;i<=n;i++){
        for(int j = 1;j<=m;j++){
            if(word1.charAt(i-1) == word2.charAt(j-1)){
                dp[i][j] = dp[i-1][j-1];          
            }else {
                dp[i][j] = Math.min(Math.min(dp[i-1][j]+1,dp[i][j-1]+1),dp[i-1][j-1]+1);
            }
        }
    }
    return dp[n][m];
}
```

### 二维数组搜索
```java
public boolean searchMatrix(int[][] matrix, int target) {
    int n = matrix.length;
    if(n <1)return false;
    int m = matrix[0].length;
    if(m<1)return false;
    int x = 0; int y = m-1;
    while(x < n && y >=0){
        if(matrix[x][y] == target)return true;
        if(target > matrix[x][y])x++;
        else if(target < matrix[x][y])y--;
    }
    return false;
}
```

### 矩阵旋转90度 lc 48
逆时针：第一步交换主对角线两侧的对称元素，第二步交换第i行和第n-1-i行，即得到结果。 如果是顺时针， 第一步交换对角线两侧的对称元素，第二步交换第i行和第n-1-i行，即得到结果。
```java
public void rotate(int[][] matrix) {
   int n = matrix.length;  
    for(int i = 0;i<n;i++){
        for(int j = i+1;j<n;j++){
            if(i!=j){
                int tmp = matrix[i][j];
                matrix[i][j] = matrix[j][i];
                matrix[j][i] = tmp;  
            }            
        }
    }
    for(int i =0;i<n;i++){
        for(int j = 0;j<n/2;j++){
           int tmp = matrix[i][j];
            matrix[i][j] = matrix[i][n-1-j];
            matrix[i][n-1-j] = tmp;
        }
    }
}
```

### 人民币转换
链接：https://www.nowcoder.com/questionTerminal/00ffd656b9604d1998e966d555005a4b?commentTags=Java
输入一个double数
输出人民币格式
1、中文大写金额数字前应标明“人民币”字样。中文大写金额数字应用壹、贰、叁、肆、伍、陆、柒、捌、玖、拾、佰、仟、万、亿、元、角、分、零、整等字样填写。（30分） 

2、中文大写金额数字到“元”为止的，在“元”之后，应写“整字，如￥ 532.00应写成“人民币伍佰叁拾贰元整”。在”角“和”分“后面不写”整字。（30分） 

3、阿拉伯数字中间有“0”时，中文大写要写“零”字，阿拉伯数字中间连续有几个“0”时，中文大写金额中间只写一个“零”字，如￥6007.14，应写成“人民币陆仟零柒元壹角肆分“。（

151121.15
人民币拾伍万壹仟壹佰贰拾壹元壹角伍分

思路：整数部分：
1）每个数字都是单位+数字（元+个位，十拾十位），
2）单位顺序完整应该是
【"元", "拾", "佰", "仟", "万", **"拾", "佰", "仟",** "亿", **"拾", "佰", "仟"**】
3）对批量0做flag。
4)如果14去掉1其它都ok。

小数部分题目要求0角1分不用输出角则暴力

```java
public class Main {
public static String[] RMB = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"};
public static String[] unit1 = {"元", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟"};
public static String[] unit2 = {"角", "分"};

public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    while (sc.hasNext()) {
        String s = sc.next();
        String result = "";
        if(s.contains(".")) {
            String s1 = s.substring(s.indexOf('.') + 1);
            String s2 = s.substring(0, s.indexOf('.'));
            result = "人民币" + integer(s2) + decimal(s1);
        } else
            result = "人民币" + integer(s) + "整";
        System.out.println(result);
    }
}
// 处理整数
public static String integer(String s) {
    if(s.length() == 1 && s.charAt(0) == '0') return "";//RMB[0]+unit1[0];
    int[] arr = new int[s.length()];
    int idx = 0;
    for (int i = s.length()-1; i >= 0; i -- )
        arr[idx++] = s.charAt(i)-'0';
    StringBuilder sb = new StringBuilder();
    boolean zero = false;
    for (int i = 0; i < arr.length; i ++ ) {
        if(!zero && arr[i] == 0){
            sb.append(RMB[arr[i]]);
            zero = true;
        }else if (arr[i] != 0){
            sb.append(unit1[i] + RMB[arr[i]]);
            zero = false;
        }
    }
    sb = sb.reverse();
    if(sb.charAt(0) == '壹' && sb.charAt(1) == '拾') sb.deleteCharAt(0);
    return sb.toString();
}
// 处理小数
    public static String decimal(String s) {
        StringBuilder sb = new StringBuilder();
//        boolean zero = true;
        for (int i = s.length()-1; i >=0; i -- ) {
            int tmp = s.charAt(i)-'0';
            if( tmp ==0)continue;
            // 1分 0角 输出角
//            if(!zero || tmp > 0){
//                sb.append(unit2[i] + RMB[tmp] );
//                zero = false;
//            }
            //不输出角
            sb.append(unit2[i] + RMB[tmp] );
        }
        return sb.length()<1?"整":sb.reverse().toString();
    }

```

### 快速排序



### 24 两个一组反转链表
{% note %}
Given 1->2->3->4, you should return the list as 2->1->4->3.
{% endnote %}

```java
public ListNode swapPairs(ListNode head) {
 if(head==null||head.next==null)return head;
    //保留第二个
    ListNode se = head.next;
    //第一个指向第三个，第三个也是同样修改方案返回头指针
    head.next = swapPairs(head.next.next);
    //第二个指向第一个
    se.next = head;
    //返回第二个当作头指针
    return se;
}
```

### 11 选两点容纳的水面积最大
{% note %}
Input: [1,8,6,2,5,4,8,3,7]
Output: 49
{% endnote %}

```java
public int maxArea(int[] height) {
    int n = height.length;
    int left = 0;
    int right = n-1;
    int rst = 0;
    while(left<right){
        int tmp = Math.min(height[left],height[right]) * (right-left);
        rst = Math.max(rst,tmp);
        if(height[left] >height[right])right--;
        else left++;
    }
    return rst;
}
```

### 42 雨水 水槽问题
{% note %}
Input: [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
{% endnote %}

正确做法：双指针
```java
public int trap(int[] A){
    int a=0;
    int b=A.length-1;
    int max=0;
    // 关键
    int leftmax=0;
    int rightmax=0;
    while(a<=b){
        leftmax=Math.max(leftmax,A[a]);
        rightmax=Math.max(rightmax,A[b]);
        if(leftmax<rightmax){
            max+=(leftmax-A[a]);
            a++;
        }
        else{
            max+=(rightmax-A[b]);
            b--;
        }
    }
    return max;
}
```

两个数组做法：left保存当前位置左边的max。right保存当前位置右边的max。
```java
public int trap(int[] height) {
  int n  = height.length;
  int[] left = new int[n];
  int[] right = new int[n];
  for(int i = 1;i<n;i++){
      left[i] = Math.max(left[i-1],height[i-1]);
  }
  for(int i = n-2;i>=0;i--){
      right[i] = Math.max(right[i+1],height[i+1]);
  }
    int rst = 0;
    for(int i = 0;i<n;i++){
        int tmp = Math.min(left[i],right[i]) - height[i];
        if(tmp >0)
        rst += tmp;
    }
    return rst;
}
```

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
}
```
{% endfold %}

---

### 946 栈顺序
{% note %}
Input: pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
Output: true
{% endnote %}
```java
public boolean validateStackSequences(int[] pushed, int[] popped) {
    Deque<Integer> stk = new ArrayDeque<>();
    int i = 0;
    for (int p : pushed) {
        stk.push(p);
        while (!stk.isEmpty() && stk.peek() == popped[i]) {
            stk.pop();
            ++i;
        }
    }
    return stk.isEmpty();
}
```

### 206反转链表
![reverselist2.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/reverselist2.jpg)

空间是n
```java
public ListNode reverseList(ListNode head) {
    if(head == null || head.next == null)return head;
    ListNode second = reverseList(head.next);
    // 1->(second:7->6->5..->2)   (second:7->6->5..->2) ->1->null
    head.next.next = head;
    head.next = null;
    return second;
}
```

---

迭代空间是1：
![reverselist.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/reverselist.jpg)

三个指针pre（注意初始为null),cur,next(只用于cur跳跃),用cur控制结束，一个暂存三个赋值。
```java
public ListNode reverseList(ListNode head) {
    if(head == null || head.next == null)return head;
    ListNode prev = null;
    ListNode curr = head;
    while(curr != null){
        ListNode next = curr.next;
        curr.next = prev;
        prev = curr;
        curr = next;
    }
    return prev;
}
```

少一个指针 正确做法
```java
public ListNode reverseList(ListNode head) {
    if(head == null || head.next == null)return head;
   ListNode cur = null;
    while(head!=null){
        ListNode next = head.next;
        head.next = cur; 
        cur = head;
        head = next;
    }
    return cur;   
}
```

python
```python
def reverseList(self, head):
        cur,prev = head,None
        while cur:
            cur.next,prev,cur = prev,cur,cur.next
        return prev
```


转成栈浪费空间并且代码复杂


### 141链表环检测
空间O(1) 快慢指针：快指针走2步，慢指针走一步，当快指针遇到慢指针
最坏情况，快指针和慢指针相差环长q -1步
{% fold cpp练习 %}
```java
class Solution{
    public:
    bool hasCycle(ListNode *head) {
        auto slow = head;
        auto fast = head;
        while(fast){
            if(!fast->next)return false;
            fast = fast->next->next;
            slow = slow->next;
            if(fast == slow) return true;
        }
        return false;
    }
};
```
{% endfold %}

### 142 环起始于哪个node
![loops.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/loops.jpg)
1->2->3->4->5->6->7->3 meet:6
a: 从head到环 
b：快指针走了两次的环内距离(慢指针到环起点的距离)
c: 慢指针没走完的环内距离
已知快指针走的距离是slow的两倍
慢=a+b  快=a+2b+c
则a=c
从len(head - 环起点) == 慢指针没走完的环距离
**head与慢指针能在环起点相遇。**
```java
if(slow==fast){
    while(head!=slow){
        head=head.next;
        slow=slow.next;
    }
    return slow;
}
```