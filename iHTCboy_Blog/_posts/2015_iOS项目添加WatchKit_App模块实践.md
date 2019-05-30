title: iOS项目添加WatchKit App模块实践
date: 2015-11-03 01:05:26
categories: technology #life poetry
tags: [iOS,WatchKit,Watch App]  # <!--more-->
reward: true
---

最近在公司原来一个项目里增加了Apple　Watch模块，遇到了很多坑。首先说明，本人目前对Swift还不深入熟悉，所以还是打算在原项目里用OC来实现。其次，我用了Apple Watch3个月了，还是第一次入门，看了喵神的教程，一步步来的。想想WatchOS 都2了，再不用用都老了。

下面简单说一下这个过程：
### 0、前言
如果在这之前，你没有看过或了解WatchKit相关内容，那么建议你读喵神的两篇文章[Apple WatchKit 初探](http://onevcat.com/2014/11/watch-kit/)、[WWDC15 Session笔记 - 30 分钟开发一个简单的 watchOS 2 app](http://www.onevcat.com/2015/08/watchos2/)

<!--more-->

### 一、增加watchOS
这个步骤就看图带过吧，对于还不知道的新手来说，看图最直接：
- 1.新建Target
![step1_New_Target.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step1_New_Target.png)

- 2.选择 watchOS
![step2_Watchk_it_App.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step2_Watchk_it_App.png)

- 3.这步骤注意，默认勾选了Notification Scene，要解释一下：
-  <1> `` Glance Scene`` ：**如果勾选，就会在Interface.storyboard里默认生成GlanceController的界面，如果原来选中了，后来想不要，就直接在Interface.storyboard里把GlanceController界面删除就可以了。**
- <2> `` Complication`` : **这个就是在系统表盘显示时，滚动 Digital Crown 时，进行一些操作，现在OS2里增加的时间旅行，就是滚动 Digital Crown时，天气和日程表计划跟着变动，这个功能还是有点用的。**

![step3_配置.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step3_配置.png)

- 4.点击激活吧
![step4_Activate.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step4_Activate.png)

- 5.最后在原来项目里增加了这两个目录App和Extension。
![step5_Watch目录.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step5_Watch目录.png)


### 二、一些坑要填
1.默认新建的Target版本都是1.0，所以你要改成跟你现在项目的版本一样才行，不然就会报错。App和Extension的Target版本都要改。
![step6_Info.plist报错.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step6_Info.plist报错.png)

![step7_更改为项目对应的版本号.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step7_更改为项目对应的版本号.png)

2.默认App和Extension的Valid Architectures都是“armv7 armv7s i386 arm64”WatchOS运行的框架要改为``armv7k``。如果要在模拟器运行，增加i386。
![step8_No_architectures_to_compile_for_armv7k.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step8_No_architectures_to_compile_for_armv7k.png)

![step9_App和Extension都要改成armv7k.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step9_App和Extension都要改成armv7k.png)

还有一些其实的小问题，不太记得了，相信大家如果遇到自行搜索就能解决。


### 三、一些代码
Watch显示的界面全部由Interface.storyboard里的界面生成，逻辑就是在Extension里写，具体也没什么好写的，由于我是用OC写的，连图片缓存的都不会，参考了喵神原OS1文章：
> 在 Extension 的 target 中获得图片 (比如从网络下载或者代码动态生成等)，并且需要重复使用的话，最好用 WKInterfaceDevice 的 -addCachedImage:name: 方法将其缓存到手表中。这样，当我们之后再使用这张图片的时候就可以直接通过 -setImageNamed: 来快速地从手表上生成并使用了。每个 app 的 cache 的尺寸大约是 20M，超过的话 WatchKit 将会从最老的数据开始删除，以腾出空间存储新的数据。

现在OS2就出现几个问题：
- 1.add方法增加的是图片的名字，如果我是从网络下载的，名字怎么取？
- 2.如何判断有没有缓存？
- 3.OS2默认已经不会自动删除旧的数据了？


`` WKInterfaceDevice ``类里的*cachedImages这个属性OS2下报错，不知道为什么？有懂的求留言。
``` 
@property (nonatomic, readonly, strong) NSDictionary<NSString*, NSNumber*> *cachedImages WK_AVAILABLE_IOS_ONLY(8.2); // name and size of cached images

```

在这篇文章[Apple Watch应用优化的一些心得技巧总结](http://www.csdn.net/article/2015-06-01/2824816/2)找到一些图片优化的方法
WatchKit用的图片库：Github上的[WKImageCache](https://github.com/mkoehnke/WKImageCache)，或者直接用[KFSwiftImageLoader](https://github.com/kiavashfaisali/KFSwiftImageLoader),或者有新的库，暂时没有去研究，求补充。


- 最后提供一个WatchKit下用的NSURLSession方法，网上都是Swift写，OC这样写：


```
    NSString *requestUrl= @"http://www.google.com";
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithURL:[NSURL URLWithString:requestUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data!=nil){// 请求成功
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
           
            
        }else{//请求失败

        }  
    }];
    
    [task resume];// 调用这个方法才会去请求网络
```



### 四、审核的一些坑
前面提到勾选 `include Glance Scene ` 和 `include Complication` ，结果在实现时，没有搞好，直接在Glance Scene里显示一个下载链接的二维码，苹果审核员问我二维码是干什么用的？它会变吗？
- Glance Scene最好要用一些有意义的数据显示

![step10_二维码被拒绝.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step10_二维码被拒绝.png)

- Complication这个，我是勾选了，第二次又被拒绝，我想说，苹果审核能一次审核全部功能吗？？？？

![step11_开启了Complication，但没有实现功能被拒绝.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step11_开启了Complication，但没有实现功能被拒绝.png)


- 取消Complication功能，就是把下图的Data Source Class删除，在把五个勾去掉就可以了：

![step12_Complications_Configuration.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step12_Complications_Configuration.png)

终于改了，希望审核明天通过吧！！


### 五、总结
关于Watch App审核，如果你选择了某个功能，但没有实现，那么一定会被拒绝的，大家注意一下这点，坑就来那里～

用了一个星期，了解了WatchKit的基础功能，实现了基本的需求。其实发现，刚开始很害怕实现不了，或者说，去做时知道一定会遇到很多问题，所以不敢去碰它。作为工程师，我们需要恒心和勇气，才能面对接下来的大数据时代，我们的知道时刻要充电，做好准备吧！


最后想吐槽一下苹果Watch，不知道是不是只有我遇到这个问题，表盘下面掉漆，这是苹果的技术吗？？？
![step13_苹果的logo首先掉色的，心都碎了.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/11/step13_苹果的logo首先掉色的，心都碎了.jpg)


### 参考
- [Apple WatchKit 初探](http://onevcat.com/2014/11/watch-kit/)
- [WWDC15 Session笔记 - 30 分钟开发一个简单的 watchOS 2 app](http://www.onevcat.com/2015/08/watchos2/)
- [Apple Watch应用优化的一些心得技巧总结](http://www.csdn.net/article/2015-06-01/2824816/2)




<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

