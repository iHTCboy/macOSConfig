title: iOS CoreSpotlightSearch探索之道
date: 2016-06-18 18:17:16
categories: technology #life poetry
tags: [iOS,CoreSpotlightSearch]  # <!--more-->
reward: true
---

![AppleStore搜索结果示例](http://upload-images.jianshu.io/upload_images/99517-9a3b2a1cc4a53302.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 前言
看到上图的搜索结果，找完了文档都没有发现这个效果怎样实现，我也是醉了，然后不小心看到下图，我相信有方法能实现，只是现在还没有发现！

 <!--more-->
 
![淘票票搜索显示.png](http://upload-images.jianshu.io/upload_images/99517-c0f46c5d2308fb70.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

研究了几天，还是让我找到了结果，苹果还是不行啊，还是我不行？反正一路过来，不容易！！自己想实现的效果，含泪也要实现出来—.—
![最后实现的可用全部类型.png](http://upload-images.jianshu.io/upload_images/99517-8aaacffe38ead37a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

下面就是探索之道，喜欢看代码的就直接先上代码看吧
 [CoreSpotlightSearchDemo](https://github.com/iHTCboy/CoreSpotlightSearchDemo)


### 1、普通类型
一般应用搜索出来的结果都是一图片，一标题，一内容
![简书的搜索结果](http://upload-images.jianshu.io/upload_images/99517-6618a31f933c3512.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是如果想实现没有图片呢？如下图：
![没有实现的，有点难看吧，至少有应用logo吧！](http://upload-images.jianshu.io/upload_images/99517-9d1242b99045caf2.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
``` 
   // 把一个空数据赋给图片对象，然后系统好像判断了如果没有图片，则不显示？
    attributedSet.thumbnailData = [NSData new];
``` 

### 2.右上角带有时间
右上角带有时间的类型，一直看文档和网上的教程，都没有发现时间的设置，一般都是简单提一下怎么设置然后显示，不求甚解？！
![带有时间的](http://upload-images.jianshu.io/upload_images/99517-ba6003190161f2c5.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

``` 
    // 显示时间的必要条件
    attributedSet.contentType = (NSString*)kUTTypeMessage;
    attributedSet.contentCreationDate = [NSDate date];
``` 


### 3.显示电话
下图是实现的电话显示和系统通讯录的搜索结果比较，系统有FaceTime的会显示，没有就隐藏，同时有发送短信的功能。但是系统好像没有开放这么多功能给开发者，只是给了电话的显示。而且，电话设置多个号码，但是点击时，直接打数据数组的第一个号码。最后是图标也不一样，系统的电话图标是实心的，实现的却是空心，累都凉了。

``` 
    // 显示的必要条件，是一个数据，可以有多个号码，但只会读第一个电话
    attributedSet.phoneNumbers = @[@"12345678",@"42535353"];
    attributedSet.supportsPhoneCall = @1;
``` 

![实现的电话类型png](http://upload-images.jianshu.io/upload_images/99517-f20fb4943676011f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![通讯录.png](http://upload-images.jianshu.io/upload_images/99517-6f5f9aa97a5dd3db.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![有多个号码系统打电话则显示多个选择.PNG](http://upload-images.jianshu.io/upload_images/99517-bf0bdb549134fa58.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 4.带有位置导航的
点击导航会跳转到地图，然后系统自动导航（代码里写好了经纬度），系统的地图都没有显示这个图标出来，就是这样了。提醒的是，如果你点击导航图标默认是跳转到系统的地图，然后是你当前地点到目标地点的线路规范，然后就可以导航了。如果点击cell其它内容，则跳转回应用，自己实现逻辑。
![位置导航类型.png](http://upload-images.jianshu.io/upload_images/99517-8ccdd6d64132edc9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
    // 显示的必要条件，经纬度
    attributedSet.longitude = @113.270793;
    attributedSet.latitude = @23.135308;
    attributedSet.supportsNavigation = @1;
```

### 5.带有星星评价的
这个测试了很久才显示出来的，心累了。
星星的显示，只能是整数个或者半个星星，最大是5，就是显示5星。星星后面还可以星星的评价说明，这个起点缀作用啦！
![带星星评价](http://upload-images.jianshu.io/upload_images/99517-8ff8d409ba87cac9.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
 //要选中对应的媒体类型
    attributedSet.contentType = (NSString*) kUTTypeAudio;
//    attributedSet.contentType = (NSString*) kUTTypeMovie;
    attributedSet.rating = @3.5;
    attributedSet.ratingDescription = @"raign44";
```
### 6.音乐
我实现出来的音乐跟系统的音乐显示完全不一样，不清楚是我这边没有实现，还是苹果没有开放接口。我感觉是苹果没有开放的原因，如果你实现了一定要告诉我，我会知错就改的。

![音乐类型](http://upload-images.jianshu.io/upload_images/99517-18253ee128b3f451.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![ 苹果音乐.PNG](http://upload-images.jianshu.io/upload_images/99517-3ebc424e2ecb1f06.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
    attributedSet.contentType = (NSString*) kUTTypeAudio;
    attributedSet.album = @"album";
    attributedSet.lyricist = @"lyricist";
    attributedSet.composer = @"composer";
    attributedSet.artist = @"artist";
```

### 7.文档类型【未实现】
这个也没有测试出来，等高手。文档类型带的是时间的修复。找到字段，设置了，但没有显示出来。下面是印象笔记和有道云笔记实现的效果。
![文档类型.png](http://upload-images.jianshu.io/upload_images/99517-7286b9a8bb99388e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 8.邮件类型【未实现】
系统的邮件类型显示分三行的。第一行是发件人，第二行是主题，第三行是内容。但是我还是没有找到苹果实现的效果。QQ邮箱显示的也是三行，但是他用了一个技巧，就是内容用了一个换行`` \\n``，让内容一分为二，这样的效果我只能说将就了，但系统的实现我也没有找到，知道的麻烦也通知一下我，我一个星期在嘛呀。。
![苹果邮件.PNG](http://upload-images.jianshu.io/upload_images/99517-6ab7ba38af3b3b5e.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![QQ邮箱搜索显示效果.png](http://upload-images.jianshu.io/upload_images/99517-909c83ec7c4f7e91.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 9.搜索关键字？
最特别的是，我在搜索很多关键字时，发现京东每一次都出现，并且关键字也命中啦！如下图：
![京东搜索.png](http://upload-images.jianshu.io/upload_images/99517-12f0ae64a9c16b14.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当时我就疑惑，这tm的怎么实现的！！！x爆天了！查看了系统的文档，都没有发现这样的搜索接口。然后想到 关键字的搜索，比如用`` "*" "?" ``，但是发现系统是无法代替换搜索的。最后想到京东覆盖了非常多的关键字，就是**大量的注入**关键字！！。这招真服了！！

关于大量注入，我测试了一万条，因为系统的索引建立是在子线程执行，然后其实也没有什么大问题。

### 10.其它类型
有了前面的类型，想要让你搜索结果显示的不一样，就是综合其它效果，做出自己漂亮吸引的形式啦！！
如下是京东的商品显示，效果感觉还可以。当然，其它应用应该找到合适自己的显示，或好的让用户点击的欲望吧！
![京东搜索结果多行显示.png](http://upload-images.jianshu.io/upload_images/99517-a042dcd755a69491.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 11.言外之意
从前面就可以看出，CSS(CoreSpotlightSearch)有非常多，非常复杂的知识，很多需要大家了解搜索吧。比如可以设置搜索关键字`` @property(nullable, copy) NSArray<NSString*> *keywords; `` ，也可以设置每一条搜索的过期时间`` @property (copy, null_resettable) NSDate * expirationDate ``，当然还可以删除某条记录或全部，关于更新，我发现每一条记录是根据`` UniqueIdentifier ``，如果发现相同的UniqueIdentifier，则系统会覆盖原来的内容，从而达到更新的作用。还有点击搜索结果，跳转回应用做逻辑处理，大家可以参考本文结尾的参考文章来学习，在这里就不多言了。

### 12.写写总结
代码写的越多，对人生的感悟越多，对代码也产生了敬畏之道。有人说，代码产生的是对用户的作用，不要一言追求重构，新技术。一个小小的功能，也许就是用户继续使用你的App的惟一原因，而不是这一次你重构了多少代码。

所以，在使用CSS时，应该考虑怎么为用户提供优质的搜索结果，而不是竞争或出风头！

因为用户有权选择不显示应用的搜索结果：
![关闭应用搜索结果.png](http://upload-images.jianshu.io/upload_images/99517-45bd345ccb64d4f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但我在想，我安装了200+应用，有时候都不想显示，苹果没有一个全部关闭的按钮，我想这不是苹果不知道，而是不“为”！就是希望用户保留搜索，一个大数据的时代！！

当然，我们在使用时，是不是也要关心一直搜索隐私问题，苹果说了(他说了算)：
![Spotlight隐私说明.png](http://upload-images.jianshu.io/upload_images/99517-c7860b385e98702a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 参考
- [如何使用iOS 9的Core Spotlight框架](http://www.cocoachina.com/ios/20160128/15163.html)
- [iOS开发之Core Spotlight实战](http://www.jianshu.com/p/b55172f0767b)
- [Core Spotlight Framework Reference](https://developer.apple.com/library/ios/documentation/CoreSpotlight/Reference/CoreSpotlight_Framework/)
- [App Search Programming Guide/ Search Drives User Engagement](https://developer.apple.com/library/prerelease/content/documentation/General/Conceptual/AppSearch/index.html#//apple_ref/doc/uid/TP40016308-CH4-SW1)
- [Introducing Search APIs - WWDC 2015 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2015/709/)
- [快速上手 Core Spotlight](http://www.cocoachina.com/ios/20160615/16703.html)
- [iOS9适配 《AdaptationTips》](https://github.com/ChenYilong/iOS9AdaptationTips)

喜欢的点赞一个，有问题先看代码吧，欢迎留言交流！
Demo: [CoreSpotlightSearchDemo](https://github.com/iHTCboy/CoreSpotlightSearchDemo)





<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

