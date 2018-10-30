---
title: algInterval
date: 2018-10-11 13:37:14
tags:
---

### 435 去掉最少区间使区间不重叠
```java
Arrays.sort(intervals,(a,b)->{a.end!=b.end?(a.end-b.end):(a.start-b.start)});
```
性能很慢44ms
换 提升到2ms 打败了100%
```java
Arrays.sort(intervals,new Comparator<Inteval>(){
    public int compare(Interval a,Interval b){
        if(a.start==b.start)return a.end-b.end;
        return a.start-b.start;
    }
})
```
`算法：按start排序，如果重叠了，end更新成min(end1,end2)`


### 539 时间diff
>Input: ["23:59","00:00"]
Output: 1

最快的方法：9ms


1.排序 变成一个循环链表

### interval max overLap
https://www.geeksforgeeks.org/find-the-point-where-maximum-intervals-overlap/
```
 arr[]  = {1, 2, 10, 5, 5}
 dep[]  = {4, 5, 12, 9, 12}

Below are all events sorted by time.  Note that in sorting, if two
events have same time, then arrival is preferred over exit.
 Time     Event Type         Total Number of Guests Present
------------------------------------------------------------
   1        Arrival                  1
   2        Arrival                  2
   4        Exit                     1
   5        Arrival                  2
   5        Arrival                  3    // Max Guests
   5        Exit                     2
   9        Exit                     1
   10       Arrival                  2 
   12       Exit                     1
   12       Exit                     0 
```

### lt391 数飞机，interval最多同时多少个飞机


### lt920 meeting room
给定一系列的会议时间间隔，包括起始和结束时间`[[s1,e1]，[s2,e2]，…(si < ei)`，确定一个人是否可以参加所有会议。
`[[0,30]，[5,10]，[15,20]]`，返回false。
贪心
```java
public boolean canAttendMeetings(List<Interval> intervals) {
    if(intervals == null||intervals.size() == 0)return true;
    Collections.sort(intervals,(o1,o2)->o1.start-o2.start);
    int end = intervals.get(0).end;
    for (int i = 1; i < intervals.size(); i++) {
        if(intervals.get(i).start<end)return false;
        end = Math.max(end,intervals.get(i).end);
    }
    return true;
}
```

### 一个人最多可以参加几个会议
```java
public int howmany(List<Interval> intervals){
    intervals.sort((a,b)->a.end-b.end);
    int cnt = 0;
    int end = 0;
    for (int i = 0; i <intervals.length ; i++) {
        if(end<intervals.get(i).start){
            // System.out.println(i);
            cnt++;
            end = intervals.get(i).end;
        }
    }
    return cnt;
}
```

### lt919 !!!需要几个会议室
不能贪心：
> `[[1, 5][2, 8][6, 9]]`
> 这种情况本来只需要2间房，但是直接贪心就会需要3间房

```java
/**
 |___| |______|
   |_____|  |____|
 starts:
 | |   |    |
 i
 ends:
      |  |     | |
     end
 res++;
 ---------
    i
     end
 res++; 这个end之前有2个start，前一个会议没有结束
 ---------
        i
     end
 end++; start>end表示有个room的会议已经结束，可以安排到这个room
 ---------
 */
//251ms 74%
public int minMeetingRooms2Arr(List<Interval> intervals) {
    int[] starts = new int[intervals.size()];
    int[] ends = new int[intervals.size()];
    for(int i=0;i<intervals.size();i++){
        starts[i] = intervals.get(i).start;
        ends[i] = intervals.get(i).end;
    }
    Arrays.sort(starts);
    Arrays.sort(ends);
    int cnt =0;
    int end = 0;
    for (int i = 0; i < intervals.size(); i++) {
        if(starts[i]<ends[end])cnt++;
        else end++;
    }
    return cnt;
}
```

用TreeMap
```java
//240ms 75%
public int minMeetingRooms(List<Interval> intervals) {
    TreeMap<Integer,Integer> map = new TreeMap<>();
    for(Interval i:intervals){
        map.put(i.start,map.getOrDefault(i.start,0)+1);
        map.put(i.end,map.getOrDefault(i.end,0)-1);
    }
    int room = 0;
    int max = 0;
    for(int num:map.values()){
        room+=num;
        max = Math.max(max,room);
    }
    return max;
}
```

用PriorityQ
```java
//403ms 54%
public int minMeetingRoomsPQ(List<Interval> intervals) {
    Collections.sort(intervals,(o1, o2)->o1.start-o2.start);
    PriorityQueue<Interval> heap = new PriorityQueue<>(intervals.size(),(o1, o2)->o1.end-o2.end);
    heap.add(intervals.get(0));
    for (int i = 1; i <intervals.size() ; i++) {
        if(intervals.get(i).start>=heap.peek().end)heap.poll();
        heap.add(intervals.get(i));
    }
    return heap.size();
}
```

### 452 重叠线段？？ 射破全部气球需要的最少次数
> Input:
> [[10,16], [2,8], [1,6], [7,12]]
Output:
2

```java
int cnt =0;
//按结束顺序排序不会出现
//  |__|     只有：  |___| 和 |____|
//|______|的情况  |____|       |_|
Arrays.sort(points,(a,b)->a[1]-b[1]);
for(int i =0;i<points.length;i++){
    int cur = points[i][1];
    cnt++;
    while(i+1<points.length&&points[i+1][0]<=cur&&cur<=points[i+1][1]){
        i++;
    }
}
return cnt;
```
前一个的end在i+1的线段中，则跳过。


### lt821时间交集 区间交集 扫描线
>seqA = [(1,2),(5,100)], seqB = [(1,6)], 返回 [(1,2),(5,6)]

```java
class Event implements Comparable<Event>{
    static final int START = 0;
    static final int END = 1;
    int time,type;

    public Event(int time, int type) {
        this.time = time;
        this.type = type;
    }

    @Override
    public int compareTo(Event o) {
        if(this.time!=o.time){
            return this.time - o.time;
        }
        return this.type-o.type;
    }
}
public List<Interval> timeIntersection(List<Interval> seqA, List<Interval> seqB) {
    List<Event> events = new ArrayList<>();
    for(Interval i:seqA){
        events.add(new Event(i.start,Event.START));
        events.add(new Event(i.end,Event.END));
    }
    for(Interval i:seqB){
        events.add(new Event(i.start,Event.START));
        events.add(new Event(i.end,Event.END));
    }
    System.out.println(events);
    Collections.sort(events);
    System.out.println(events);

    int count = 0;
    Integer start = null,end = null;
    List<Interval> res = new ArrayList<>();
    for(Event event : events){
        if(event.type == 0){
            //用户上线
            count++;
            if(count == 2)start = event.time;
        }else {
            //用户下线
            count--;
            if(count == 1)end = event.time;
        }
        if(start != null && end != null){
            res.add(new Interval(start,end));
            start = null;end = null;
        }
    }

    return res;
}
```



### 56 合并区间 扫描线
>Input: [[1,4],[4,5]]
Output: [[1,5]]


方法1：O(nLogn) 需要O(n)空间
1.按起点排序，
2.push第一个interval
3.for全部interval：
  a.不交叉，push
  b.交叉,更新栈顶的end

59ms 27%
{% fold %}
```java
public List<Interval> merge(List<Interval> intervals) {
  if(intervals==null||intervals.size()<2)return intervals;
    intervals.sort((a,b)->a.start-b.start);
    List<Interval> rst = new ArrayList<>();
    for(Interval interval:intervals){
        if(rst.size()<1){       
            rst.add(interval);
        }
        else if(rst.get(rst.size()-1).end>=interval.start){
            // 不用新建 只需要更新栈顶
            // Interval newInter = rst.get(rst.size()-1);
            // rst.remove(rst.size()-1);
            // newInter.end = Math.max(newInter.end,interval.end);
            // rst.add(newInter);
            rst.get(rst.size()-1).end =Math.max(rst.get(rst.size()-1).end,interval.end); 
        }else{
            rst.add(interval );
        }
    }
    return rst;
}
```
{% endfold %}

方法2：分解成`start[],end[]`
思想：后一个区间的start(i+1)一定要大于前一个区间的end(i)
98% 10ms
```
starts:   1    2    8    15
               i    i+1
ends:     3    6    10    18
          j
```
add(1,6)
`start[i+1]>end[i]` 直到找的第一个start>end `add(start[j],end[i])` `j=i+1`
如果start到了最后一个，这个区间肯定是从上一个区间(j)开始，到end(i)结束
```java
public List<Interval> merge(List<Interval> intervals) {
    int len = intervals.size();
    int[] start = new int[len];
    int[] end = new int[len];
    for(int i =0;i<len;i++){
        start[i] = intervals.get(i).start;
         end[i] = intervals.get(i).end;
    }
    Arrays.sort(start);
    Arrays.sort(end);
    List<Interval> rst = new ArrayList<>();
    for(int i =0,j=0;i<len;i++){
        //关键 当start扫描到最后一个 ，直接建立起最后一个区间
        if(i==len-1||start[i+1]>end[i]){
            rst.add(new Interval(start[j],end[i]));
            //下一个区间起点
            j=i+1;
        }
    }
}
```

方法3：原地算法
1.按地点降序排序
2. a如果不是第一个，并且和前一个可以合并，则合并
   b push当前

#### lt156合并区间
> ```
[                     [
  (1, 3),               (1, 6),
  (2, 6),      =>       (8, 10),
  (8, 10),              (15, 18)
  (15, 18)            ]
]
```
O(n log n) 的时间和 O(1) 的额外空间。 原地算法





### 57 插入一个区间并合并
方法1： 将区间插到newInterval.start>interval.start之前的位置，用56的和last比较合并
方法2： 分成left+new+right三部分并合并 中间部分取自身和重叠区间的min/max
```java
public List<Interval> insert(List<Interval> intervals, Interval newInterval) {
     List<Interval> left = new ArrayList<>();
     List<Interval> right = new ArrayList<>();
     int start =newInterval.start;
     int end =newInterval.end;
     for(Interval interval:intervals){
         if(interval.end<newInterval.start){
             left.add(interval);
         }else if(interval.start>newInterval.end){
             right.add(interval);
         }else {
             start = Math.min(start,interval.start);
             end = Math.max(end,interval.end);
         }
     }
     left.add(new Interval(start,end));
     left.addAll(right);
    return left;
}
```