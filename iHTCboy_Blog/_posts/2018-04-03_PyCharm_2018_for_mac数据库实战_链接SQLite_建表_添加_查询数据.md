title: PyCharm 2018 for mac 数据库实战：链接SQLite、建表、添加、查询数据
date: 2018-04-03 21:46:26
categories: technology #life poetry
tags: [PyCharm,SQLite,Python]  # <!--more-->
reward: true

---

###  一、前言
* * *
最近开始入门python，当然是要使用PyCharm，然后在项目中遇到.db数据库文件，双击打不开？网上找到了windows版本的教程，版本也比较旧，所以有空就来一发，当备忘也好~

<!--more-->

### 二、链接SQLite
* * *
###### 2.1 控制台创建数据库DB文件

![创建数据库DB文件](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-createDBfile.png)

######  2.2 打开sqlite配置界面
按下图步骤打开sqlite配置目录
![打开sqlite配置界面](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-openSqliteConfig.png)

######  2.3 安装sqlite驱动
点击下载驱动，直到显示提示“no objects”：
![安装sqlite驱动](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-downloadSqliteDriver.png)

######  2.4  链接刚才创建的数据库 ios_test.db文件
![ 链接数据库Sqlite文件](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-ConnectionSqliteFile.png)


点击步骤4的“Test Connection” 时，显示 `Successful` 就表示连接成功，点击右下角的OK返回！
![Test Connection](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-TestConnectionSqlite.png)

PyCharm自动打开Sqlite数据库：
![SqliteConsole](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-PycharmSqliteConsole.png)


### 三、操作数据库
* * *
######  3.1 创建一张表
![createTable](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-createTable.png)

![createTableConsole](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-createTableConsole.png)

######  3.2 添加数据
![insertIntoTable](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-insertIntoValues.png)

######  3.3 查询数据
![SelectTable](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-SelectFrom.png)


######  3.4 关联表
![referencesForeignKey](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-referencesForeignKey.png)


######  3.5 更多示例
![insertValues](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180403-insertInfoValuesMore.png)

相关代码：

```
-- 创建一个表
create table iOSDevice(
  deviceName TEXT
);

-- 插入数据
insert into iOSDevice values('iPhone8');
insert into iOSDevice values('iPhone8 Plus');
insert into iOSDevice values('iPhoneX');

-- 查询所有数据
select * from iOSDevice;


-- 创建一个新表
create table iProduct (
  Mac    text,
  iPhone text,
  iPad   text,
  Watch  text,

  --  关联表
  foreign key (iPhone) references iOSDevice(deviceName)
)


--  插入多个值
insert into iProduct values(
  'Macbook Pro',
  'iPhone',
  'iPad mini4',
  'apple Watch'
);

-- 查询表数据
select * from iProduct;
```

### 四、总结
* * *
通过PyCharm进行SQLite操作，之前真没有想到PyCharm如此强大！IDE就是`IDE`，收费也是硬道理！希望好好利用PyCharm做更多有趣的事件~


### 五、参考引用
- [PyCharm IDE 链接sqlite、建表、添加、查询数据 - CSDN博客 ](https://blog.csdn.net/qq_36482772/article/details/53458400)





<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


