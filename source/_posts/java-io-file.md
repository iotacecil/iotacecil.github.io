---
title: java-io-file
date: 2018-05-04 20:34:13
tags: [java,io]
category: [java源码8+netMVCspring+ioNetty+数据库+并发]
---
### 管道流 `PipedInputStream`.. 线程之间的数据通信
`pin.connect(pout);`

Java的管道不同于Unix/Linux系统中的管道。
在Unix/Linux中，运行在不同地址空间的两个进程可以通过管道通信。在Java中，通信的双方应该是运行在同一进程中的不同线程。


新建一个流对象，下面哪个选项的代码是错误的？
正确答案: B   你的答案: A (错误)
A.new BufferedWriter(new FileWriter("a.txt"));
B.new BufferedReader(new FileInputStream("a.dat"));
C.new GZIPOutputStream(new FileOutputStream("a.zip"));
D.new ObjectInputStream(new FileInputStream("a.dat"));
`public BufferedReader(Reader in, int sz)`

http://blog.jmecn.net/java-iostream/
JNI java native interface 本地接口

### NIO
原来IO流一个字节一个字节处理。NIO块。
每一种java数据类型都有缓冲区
![niobytebuffer.jpg](https://iota-1254040271.cos.ap-shanghai.myqcloud.com/image/niobytebuffer.jpg)
1.`ByteBuffer bf = ByteBuffer.allocate(8);`
2.添加 `bf.put((byte)10);` 获取`.get(index)`
3.偏移量：`bf.position()`
4.缓冲区反转：`bf.flip()`取值的数据变成position-limit

```java
public final Buffer flip() {
    limit = position;
    position = 0;
    mark = -1;
    return this;
}
```
5.`bf.hasRemaining()`positon和limit之间有值,
  `bf.remaining()`有多少个：`return limit - position;`
```java
bf.flip()
if(bf.hasRemaining()){
  for(int i =0;i<bf.remaining();i++){
      byte b= bf.get(i);
  }
}
```
6.`campact`丢弃position及以前的数据，将position到limit的数据复制到之前，并将pisiton移到复制完的数据之后，用于写入新数据覆盖没被覆盖掉但是已经移到前面去的值，limit放到capacity上。

#### Channel
1. 文件只能通过`RandomAccessFile`,`FileInput/OutputStream`的`.getChannel()`打开只读/只写
2. `socket`有`Socket`,`Server`,`Datagram`三种Channel

#### selector是系统(native)调用`select()` `poll()`的封装
注册:通道设置成非阻塞，File通道不能是非阻塞
```java
Selector sl = Selector.open();
channel.configureBolcking(false);
SelectionKey = channel.register(selector,Selection.OP_READ);
```
1. rigister的第二个参数监听四种不同类型：Connect，Accept，R/W
可以用`|`位运算连接多个监听的值
2. 返回的`SelectionKey`对象有4个boolean方法表示通道的就绪状态
从键可以访问对应的通道和选择器：
```java
selectionKey.channel();
selectionKey.selector();
```
2. `Selecotr`对象维护3个键的Set：
每个键关联一个通道
```java
public abstract SelectorProvider provider();
//已注册的键的集合
public abstract Set<SelectionKey> keys();
//已注册中的已经准备好的集合
public abstract Set<SelectionKey> selectedKeys();
```

`select`方法返回上次select之后就绪的通道数(增量)
通过就绪key访问通道
```java
Set selectedKeys = selector.selectedKeys();
Iterator KeyIterator = selectedKeys.iterator();
while(KeyIterator.hasNext){
  SelectionKey key = KeyIterator.next();
  //四种就绪状态
  if(key.isAcceptable()){
    ...
  }
  //从就绪集中移除，下次通道再就绪时再放入选择集
  KeyIterator.remove();
}
```


堆外内存：
ByteBuffer
1.`wrap`可以包装一个数组，保证不被直接修改
2.`ByteBuffer.allocateDirect()` 堆外内存。
```java
public static ByteBuffer allocateDirect(int capacity) {
    return new DirectByteBuffer(capacity);
}
```
DirectByteBuffer继承`MappedByteBuffer`,map..继承`ByteBuffer`继承`Buffer`
Buffer.java中 实现零拷贝
```java
// Used only by direct buffers
// NOTE: 升级为了JNI方法调用的速度hoisted here for speed in JNI GetDirectBufferAddress
//堆外内存数据地址用c申请的
long address;
```
### Reactor模式

### IO分为广义File I/O和Stream I/O两类

### common-io

### xml解析 
#### SAX 事件驱动，顺序。，读取(内存占用小)
1. 解析器工厂
```java
SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
```
2. 创建SAX解析器
```java
SAXParser saxParser = saxParserFactory.newSAXParser();
```
3. 数据处理器
```java
PersonHandler personHandler = new PersonHandler();
```
{% fold %}
```java
public class PersonHandler extends DefaultHandler{
    public List<Person> getPersons() {
        return persons;
    }

    private List<Person> persons = null;
    private Person p= null;
    //用于记录当前正在解析的标签
    private String tag;

    @Override
    public void startDocument() throws SAXException {
        super.startDocument();
        //开始解析文档
        persons = new ArrayList<>();
        System.out.println("开始解析标签");
    }
    @Override
    public void endDocument() throws SAXException {
        super.endDocument();
        System.out.println("结束解析");
    }

    /*
     * @param uri        命名空间
     * @param localName  不带前缀的标签
     * @param qName      带前缀的标签<aa:
     * @param attributes 标签里的属性集合
     */
    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        super.startElement(uri, localName, qName, attributes);
        if("Person".equals(qName)){
            p=new Person();
            int id = Integer.parseInt(attributes.getValue("id"));
           p.setId(id);
        }
        //开始解析标签时记录名字
        tag = qName;
    }

    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        super.endElement(uri, localName, qName);
        //每次结束标记就把tag置空
        if ("Person".equals(qName)) {
            persons.add(p);
        }
        tag = null;
    }

    @Override
    //解析文本内容时
    public void characters(char[] ch, int start, int length) throws SAXException {
        super.characters(ch, start, length);
        //ch是整个xml文件的内容
        if (tag != null) {
            if("name".equals(tag)){
                p.setName(new String(ch,start,length));
            }
        }
    }
}
```
{% endfold %}

4. 开始解析
```java
InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream("person.xml");
saxParser.parse(is,personHandler);
```

---
据说jdom和dom文档超过10M会内存溢出
#### Dom解析
1. 解析器工厂
```java
DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
```
2. 解析器对象
```java
DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
```
3. 解析（把所有文件读取到内存）
```java
//树状结构
Document parse = documentBuilder.parse(is);
```
4. 从内存中读取
```java
NodeList people = parse.getElementsByTagName("Person");
ArrayList<Person> pp = new ArrayList<>();
Person p =null;
for (int i = 0; i <people.getLength() ; i++) {
Node person = people.item(i);
p = new Person();
//获取person元素的属性id
p.setId(Integer.parseInt(person.getAttributes().getNamedItem("id").getNodeValue()));
//获取子节点
NodeList childNodes = person.getChildNodes();
for (int j = 0; j <childNodes.getLength() ; j++) {
    Node child = childNodes.item(j);
    if ("name".equals(child.getNodeName())) {
        p.setName(child.getTextContent());
        System.out.println(child.getFirstChild());
        System.out.println(child.getFirstChild().getNodeValue());
    }
}
pp.add(p);
System.out.println(p);
}
```

#### JDOM 三方 不用NodeList 返回原生的Collection
```java
SAXBuilder builder = new SAXBuilder();
InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream("javacoretest/xmljson/person.xml");
Document build = builder.build(is);
Element root = build.getRootElement();
List<Person> list = new ArrayList<>();
Person p = null;
List<Element> children = root.getChildren();
for(Element e :children){
    p = new Person();
    p.setId(Integer.parseInt(e.getAttributeValue("id")));
    List<Element> child = e.getChildren();
    for(Element ce:child){
        if ("name".equals(ce.getName())) {
            p.setName(ce.getText());
        }
    }
    list.add(p);
}
```

#### DOM4J
JAXM 和hibernate读写配置文件 都使用
```java
SAXReader reader = new SAXReader();
InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream("javacoretest/xmljson/person.xml");
Document doc = reader.read(is);
Element root = doc.getRootElement();
Iterator<Element> iter = root.elementIterator();
ArrayList<Person> people = new ArrayList<>();
Person p = null;
while(iter.hasNext()){
    p = new Person();
    Element next = iter.next();
    p.setId(Integer.parseInt(next.attributeValue("id")));
    Iterator<Element> childiter = next.elementIterator();
    while(childiter.hasNext()){
        Element next1 = childiter.next();
        if ("name".equals(next1.getName())) {
            p.setName(next1.getText());
        }
    }
    people.add(p);
}
```

#### 对象写入生成xml
1.XMLEncoder 用decoder直接解析
```java
BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("outxml.xml"));
XMLEncoder xmlEncoder = new XMLEncoder(bos);
//for
xmlEncoder.writeObject(p);
xmlEncoder.close();
```
生成
```xml
<?xml version="1.0" encoding="UTF-8"?>
<java version="1.8.0_144" class="java.beans.XMLDecoder">
 <object class="javacoretest.xmljson.Person">
  <void property="id">
   <int>3</int>
  </void>
  <void property="name">
   <string>第三个</string>
  </void>
 </object>
</java>
```
2.xstream 依赖包xpp3
```java
XStream xStream = new XStream(new Xpp3Driver());
String xml = xStream.toXML(p);
```
输出：
```xml
<javacoretest.xmljson.Person>
  <name>第三个</name>
  <id>3</id>
</javacoretest.xmljson.Person>
```
修改成Person包名，id为属性:在toXML之前加
```java
xStream.alias("Person",Person.class);
xStream.useAttributeFor(Person.class,"id");
```
解析:xml是字符串xml
`(Person)xStream.fromXML(xml);`

#### JSON：GSON
```json
[{"id":"1","name":"小明"},
  {"id":"2","name":"小红"}]
```
1解析list
```java
InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream("javacoretest/xmljson/people.json");
InputStreamReader in = new InputStreamReader(is);
JsonReader reader = new JsonReader(in);
List<Person> list = new ArrayList<>();
reader.beginArray();
while(reader.hasNext()){
    list.add(addobj(reader));
}
reader.endArray();
```
2解析obj
```java
private static Person addobj(JsonReader reader) throws IOException {
    Person p = null;
    //读大括号
    reader.beginObject();
    p = new Person();
    while(reader.hasNext()){
        String s = reader.nextName();
        if ("name".equals(s)) {
            p.setName(reader.nextString());
        }
       else if("id".equals(s)){
            int i = reader.nextInt();
            p.setId(i);
       }
    }
    reader.endObject();
    return p;
}
```

---
直接用Gson将字符串{:}转化成类 "age":"4"会自动映射成int
```java
Gson gson = new Gson();
list.add(gson.fromJson(reader,Person.class));
```
3 生成json
```java
private static String createJson(List<Person> people){
  JsonArray array = new JsonArray();
  for(Person p: people) {
      JsonObject obj = new JsonObject();
      obj.addProperty("name",p.getName());
      obj.addProperty("id",p.getId());
      array.add(obj); 
  }
  return array.toString();
}
```

---
直接用gson将对象转成json字符串
```java
String s = gson.toJson(pp);
```
制定生成json list
```java
//相当于 允许运行时创建一个子列获取type
class mytype extends TypeToken<List<People>>{}
//new一个子类，里面什么都不写
TypeToken<List<Person>> typeToken = new TypeToken<List<Person>>(){};
List<Person> people = gson.fromJson(reader,typeToken.getType());
```
用List<Person>生成list json
```java
String pjson = gson.toJson(people,typeToken.getType());
```


### IO文件
### `File`
1. `File.separator`:winsows:"\",linux"/"
2. windows换行符：
`System.lineSeparator().equals("\r\n")` true
Linux：`equals("\n")`
2. `.list()`列出目录下所有文件名
   `.listFiles()`返回`File[]`
   `.length()`返回文件字节数
```java
Date last = new Date(f.lastModified());
DateFormat df = new SimpleDateFormat();
System.out.println(f.getName()+f.length()+df.format(last));
```
   过滤：
```java
File[] files = dir.listFiles((pathname) -> 
pathname.getName().endsWith(".java"));
```
   递归找文件：
{% fold %}
```java
 private static void findFile(File start,String file){
    if(start==null)return;
    if(start.isDirectory()) {
        File[] list = start.listFiles();
        if (list != null) {
            for (File f : list) {
                findFile(f,file);
            }
        }
    }else{
        if (start.getName().equals(file)) {
            System.out.println(start.getAbsolutePath());
        }
    }
}
 ```
{% endfold %}

### 字节流
```java
InputStream inputStream = new FileInputStream(a);
//汉字两个字节大小过小会出错
byte[] bt = new byte[3];
int len=-1;
StringBuffer sb = new StringBuffer();
while ((len=inputStream.read(bt))!=-1){
    //如果最后一次只读1个字节，bt[0]是新值，[1-2]是旧值，重复
    sb.append(new String(bt,0,len));}
System.out.println(sb);
```
1. InputStream 字节 ：mark() reset()

### 字符流顶层父类：`Writer`、`Reader` 解决不同文字编码占的字节数不同
1.Reader用`char[]`接收
```java
Reader rd = new FileReader(a);
char[] buff = new char[1];
StringBuffer sb = new StringBuffer();
int len  =-1;
while((len = rd.read(buff))!=-1) {
    sb.append(new String(buff,0,len));}
rd.close();
```
实现：
  1. `FileReader extends InputStreamReader`
  2. `private final StreamDecoder sd;`sd.read()是一个.class
- `LineNumberReader `
2.Writer `append`调用`write`
    `private char[] writeBuffer;`,`WRITE_BUFFER_SIZE = 1024;`
    1.关闭流`.close()`、2.手动刷新、3.缓存满 之后才会把缓冲区写入文件
    字节流的`.write()`直接写
3.文件复制(用字节流)
```java
byte[] bytes = new byte[1024];int len =-1;
while((len=in.read(bytes))!=-1){out.write(bytes,0,len);}
```

- `OutputStreamWriter` Writer =
- `InputStreamReader` Reader=

### 4个缓冲流
1.`BufferedOutputStream(OutputStream)`的关闭
```java
@SuppressWarnings("try")
  public void close() throws IOException {
      try (OutputStream ostream = out) {
          flush(); } }
```
  只需要关闭外层bos的close
  默认缓存大小8192 8K
  使用try语法的类要实现`Closeable`，作用域在后面的大括号中
2.`BufferedReader`可以`readLine()`

### 打印流`PrintStream`字节,`PrintWriter`字符
添加了更多的print，只是为了遍历输出

### 对象流 存储到物理介质/网络传输
```java
Student st = new Student("小明",33);
File store = new File("src/javacoretest/File/tryst.obj");
//写
try (ObjectOutputStream oos = new ObjectOutputStream(
  new FileOutputStream(store))){oos.writeObject(st);}
//读
try(ObjectInputStream ois = new ObjectInputStream(
  new FileInputStream("src/javacoretest/File/tryst.obj"))){
    Student xiaoming = (Student) ois.readObject();
    System.out.println(xiaoming);}
```
加上`serialVersionUID=1L` 版本号
用数组实现一组对象的存储
`trasient`在序列化中被忽略,还原时变成默认值

### 字节数组流`ByteArrayInputStream` `ByteArrayOutputStream`
内存操作与文件无关，每次读取一个字节，处理字符串，无需关闭
从String中得到过滤出全部字母
{% fold %}
```java
String s = "12345dadfa(*dafAAAdaf@$#234";
ByteArrayInputStream bais = new ByteArrayInputStream(s.getBytes());
ByteArrayOutputStream baos = new ByteArrayOutputStream();
int curr =-1;
while((curr=bais.read())!=-1){
    if((curr>=65&&curr<=90)||curr>=97&&curr<=122){
        baos.write(curr);
    }
}
System.out.println(baos.toString());
```
{% endfold %}

### 数据流`DataInputStream` `DataOutputStream`
按java基本数据类型,与机器底层无关
`.writeInt(10)` 对应`.readXXX`
`.wirteByte(1)`
`.writeUTF("中文")`
- 分割文件`void divide(File target,long cutSize)`

```java
for (int i = 0; i <n ; i++) {
    out = new BufferedOutputStream(new FileOutputStream("src/javacoretest/File/"+(i+1)+".txt"));
    ...
    if((len = in.read(bytes))!=-1){
      out.write(bytes, 0, len);
      out.flush();
      }
      out.close();
}
```
- 合并文件 合并流`SequenceInputStream`

```java
Vector<InputStream> v = new Vector<>();
Eumeration es = v.elements();
SequenceInputStream sis = new SequenceInputStream(es);
sis.read(bytes);
bos.write(bytes,0,len);
bos.flash();
```

### 字符串流`StringReader` `StringWriter`
`StringTokenizer`流标记器
```java
if(st.nextToken()==StreamTokenizer.TT_WORD)cnt++;
```



### `RandomAccessFile`在jdk1.4中nio 被内存映射文件 替代
复制文件
```java
RandomAccessFile r = new RandomAccessFile("a.txt","r");
RandomAccessFile w = new RandomAccessFile("c.txt","rw");
```
seek 实现文件续传

### Properties 工具类 `extends Hashtable`
ResourceBundle只能读取
```java
Properties p = new Properties();
InputStream cfg = new FileInputStream...
p.load(cfg);
String name = p.getProperty("username");
//放到内存中 setProperty调用的也是put
p.put("passwd","dafdafa");
String pw = p.getProperty("passwd");
//写
OutputStream out = new FileOutputStream...
p.store(out,"updatatatata");
```
可以通过类加载器加载
```java
InputStream resourceAsStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("src/a.p");
```
清除所有的键值对`p.clear();`

### 压缩`ZipOutputStream`
压缩 `z.putNextEntry(new ZipEntry(name));`
`ZipEntry(String name)` 创建条目 
解压 `zIn.getNextEntry()`





#### 内存缓存区
```java
outBuf.put(inBuf.get());
```

### Path
1. get
2. file.toPath()
3. FileSystem.getDefault().getPath("",);

### Files工具类
1. copy move delete deleteifExists



