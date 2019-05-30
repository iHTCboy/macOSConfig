title: iOS单独集成QQ分享功能的苦逼经验
date: 2015-02-27 23:17:26
categories: technology  #life poetry
tags: [iOS,QQsdk,QQ分享]  # <!--more-->
reward: true
---

这个过程其实很简单，就是腾讯的文档真的不敢恭维！

如果只是想把一段文字，或一张图片分享到QQ（包括好友、群、讨论组、空间），那么你看文档会感觉到很无助，不知道从那里开始，并且地魔（demo）跑不起来！（ps，腾讯的员工是不是经常跳槽到微信？）

### （1）首先，把TencentOpenAPI.framework、TencentOpenApi_IOS_Bundle.bundle导入工程中。

ps: 我在搜索资料时，看到有人说TencentOpenAPI.framework要放在工程根目录，我在Xcode6下试了一下，结果是不放根目录也行，同时Xcode6下，导入framework就好，其它操作都自动了，官方sdk文档好像好久没更新了，我又想吐槽？不要阻止我！what's up？

<!--more-->

### （2）添加SDK依赖的系统库文件。

- Security.framework
- libiconv.dylib
- SystemConfiguration.framework
- CoreGraphics.Framework
- libsqlite3.dylib
- CoreTelephony.framework
- libstdc++.dylib
- libz.dylib


### （3）在AppDelegate.h中 导入 头文件

```
 #import <TencentOpenAPI/TencentOAuth.h>

```

### （4）在AppDelegate.m中向腾讯注册。（ps：只是集成分享功能，所以不用授权）

```
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

       [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:nil]; //注册

｝

```

##### 要特别注意以下3点：

1、上面代码中QQkey为APP ID，而不是APP KEY，并且与URL schemes不相同。

2、URL type 里的 URL schemes  = tencent + appid。（因为微信、微博的两个值是相同的，所以要注意一下。）

![appid是1104292447.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/02/appid是1104292447.png)

3、这里delegate为空，因为没有授权，所以不用代理。


### （5）重写AppDelegate 的handleOpenURL和openURL方法

```
 - (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation{
 
 return[TencentOAuth HandleOpenURL:url];

 ｝

 -(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

 return[TencentOAuth HandleOpenURL:url];
 
 }

```
（ps：不用实现TencentSessionDelegate代理方法，手机QQ里分享时，会等到分享成功后，才会跳回原应用，所以不用监听发送情况）


### （6）设置Bundle display name属性值。

如果是Xcode 6.0创建工程时，默认可能没有单独设置Bundle display name属性值。但是因为SDK需要用到Bundle display name的值，所以务必请检查确保这个属性存在，如果没有请添加上。如下图所示：

![Bundle display name 为桂林理工大学.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/02/Bundle_display_name为桂林理工大学.png)

（ps：注意的是，这个名字会用在2个地方：1、应用显示的名字，2、分享到QQ界面时显示的“来自”小尾巴（到空间时，小尾巴是你注册腾讯appid时写的应用名字）

### （7）在实现分享的ViewCotroller里加入头文件

```
 #import  <TencentOpenAPI/QQApi.h>

 #import <TencentOpenAPI/QQApiInterface.h>

```

### （8）实现分享内容的代码（以分享图片为例）

```
 //用于分享图片内容的对象

	QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData

	previewImageData:previewImage

	title:self.newsModel.title

	description:@"由 桂林理工大学-校园通 转码"];

	SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];

	//将内容分享到qq

	QQApiSendResultCode sent = [QQApiInterface sendReq:req];
	其它内容，大家还是磨磨官方文档，或者用集成化的sdk吧，同时希望腾讯的iOS开发者不要在打酱油了~.~


```


### 相关连接：

[QQ SDK 介绍页](http://wiki.open.qq.com/wiki/mobile/SDK下载)

[QQ SDK IOS_API调用说明](http://wiki.open.qq.com/wiki/IOS_API调用说明#2._iOS_SDK_API.E4.BD.BF.E7.94.A8.E8.AF.B4.E6.98.8E)

[《QQ SDK iOS SDK环境搭建》.doc 下载](http://qzonestyle.gtimg.cn/qzone/vas/opensns/res/doc/iOS_SDK_huanjingdajian.doc)

[《QQ SDK iOS SDK API使用说明.doc》下载](http://qzonestyle.gtimg.cn/qzone/vas/opensns/res/doc/iOS_SDK_API_shiyongshuoming.doc)


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源



