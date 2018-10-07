title: QQ和微信同步登陆，AppStore审核被拒4次的坑路
date: 2015-10-16 23:58:26
categories: technology #life poetry
tags: [QQ,同步登陆,微信]  # <!--more-->
---

最近应用加入了微信和QQ同步登陆，结果被拒绝了4次！！下面就让我带大家回顾这坑路～

### 第一次最拒绝
第一次以为是苹果测试手机没有安装QQ导致，所以写了代码判断手机是否安装QQ，如果没有安装就隐藏掉QQ登陆图标。

<!--more-->

```

        //判断是否有qq
    if (!([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi])) {
        view.hideQQ = YES;
    }
    
        //判断是否有微信
    if (![WXApi isWXAppSupportApi]){
        view.hideWeixin = YES;
    }

```

![第一次被拒绝](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.cc解决方案中心2015-09-13%2017.13.58.png)

![有安装的情况，苹果是用iPad测试的](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.cctemp..qunlrjcx.jpg)

![都没有安装的情况](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.cctemp..sgpecehb.png)

##### 问题总结
- 苹果不止用一台设备测试，或者不止一个人测试同一应用
- 苹果用iPad测试，我觉得因为在iPad上就知道应用支持不支持iPad吧
- 苹果不允许应用隐藏图标吗？！都没有安装显示毛线啊！


### 第二次被拒绝
苹果不允许我隐藏图标，那么我就显示出来吧！同时也会判断安装，如果没有安装就提示用户没有安装！这样也不给！！

![第二次被拒绝](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.cc屏幕快照%202015-09-17%2009.15.38.png)

![微信提示没有安装](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.cctemp..pjxfsxjt.png)
![QQ提示没有安装](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.cctemp..xqgngvsq.png)


### 第三次被拒绝
这次没有办法了，网上的方法说，如果没有key安装QQ的能用web网页登陆～
>腾讯的官方文档翻了个底朝天，友盟的文档也翻了个底朝天，俩demo也翻了个底朝天。
经过不懈努力，问题终于解决，原因真是够蛋疼的！！
友盟或者QQ互联提供的demo工程是低于xcode6.0创建的，默认工程的info.plist里有Bundle display name和Bundle name两个key。
而xcode6.0之后创建的工程的info.plist里没有Bundle display name！！调用腾讯的登录API就弹出个webview
界面提示需要安装最新版本QQ。
加上这个key就一切正常了，再删掉这个key调用QQ登录绝逼不行！！
这tmd腾讯也太操蛋了吧！！！！

![QQ 不是最新版](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.qq.jpg.png)

### 第四次被拒绝
最后一次，苹果也有点不耐烦了！！！
看到详细说明，如果第三方app没有安装，那么可以用网页授权方式！！终于找到出路了！！但是怎么才能web登陆？？？

最后，在[cocoachina 论坛](http://www.cocoachina.com/bbs/read.php?tid-269355-page-2.html)找到答案：
> 只要让腾讯客服对appid开通个权限就可以。


![早上9点可以联系人工客服说就行了](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.ccqqweb.png)

![苹果详细说明原因](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.cc屏幕快照%202015-09-19%2008.44.23.png)


### 总结
在这个过程中，也看了一些应用的实现，基本都上面几种方式的一种，但是就能上架，这个苹果的测试人员有很多种吗？？！！
不管怎样，就这样走过坑！！应用最终上架了！！

### 微信同步登陆
如果没有安装微信，微信同步登陆只能通过手机号码，不知道苹果测试员怎么测试呢？！

![没有安装微信时](http://7xliwf.com1.z0.glb.clouddn.com/ihtc.ccIMG_2983.PNG)

### 参考文章
- [关于IOS项目QQ空间授权提示安装最新版本的QQ的解决方法](http://bbs.mob.com/forum.php?mod=viewthread&tid=177)
- [iOS qq第三方登录为什么没有安装qq的时候没有显示登录页面？ - iOS 开发 - 知乎](http://www.zhihu.com/question/26733883)
- [腾讯aouth提示没有安装QQ软件?](http://www.cocoachina.com/bbs/read.php?tid-269355-page-2.html)
- [android/IOS友盟social对qq/qzone的分享/授权登录支持情况说明表](http://bbs.umeng.com/thread-5642-1-1.html)





<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

