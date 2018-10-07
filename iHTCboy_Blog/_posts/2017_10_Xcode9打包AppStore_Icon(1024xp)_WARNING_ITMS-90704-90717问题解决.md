title: Xcode9 打包App Store Icon(1024xp) WARNING ITMS-90704 -90717 问题解决
date: 2017-10-12 09:00:16
categories: technology #life poetry
tags: [Xcode9,App Store Icon,ITMS-90704,ITMS-90717]  # <!--more-->
reward: true

---

#### Xcode9 打包，上传 iTunes Connet 报错，提示需要在icon添加一张 Marketing 1024x1024 的图标
> WARNING ITMS-90704: "Missing Marketing Icon. iOS Apps must include a 1024x1024px Marketing Icon in PNG format. Apps that do not include the Marketing Icon cannot be submitted for App Review or Beta App Review."

Xcode9 中需要添加：
![AppStore 1024pt](http://upload-images.jianshu.io/upload_images/99517-97ddb8e31e633c19.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

<!--more-->

如果是 Xcode8还是在 iTunes Connect 后台添加 1024x1024 图标：
![iTunes Connect 后台说明](http://upload-images.jianshu.io/upload_images/99517-94aeddcf90f731d9.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### App Store 1024x1024px 图标规范
用 Xcode9 打包后上传 iTunes Connet 报错：
> ERROR ITMS-90717  Invalid App Store Icon. The App Store Icon in the asset catalog in 'Some.app' can't be transparent nor contain an alpha channel.

![ERROR ITMS-90717](http://upload-images.jianshu.io/upload_images/99517-0a2ba03b013b5083.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

原因：Xcode9中 1024x1024的图标只能 Alpha通道为否的 png 或 jpg 图片。

![App Store 图标规范](http://upload-images.jianshu.io/upload_images/99517-6b4fc430ebc4a130.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 总结
 App Store Icon (1024px)图标在 Xcode9 中只能放置不透明（没有 alpha通道）的 png 或 jpg 格式图片。

#### 参考：
- [Marketing/App Store Icon PNG transparency issue | Apple Developer Forums](https://forums.developer.apple.com/thread/86829)
- [Add an App Store icon - Xcode Help](http://help.apple.com/xcode/mac/current/#/dev4b0ebb1bb)
- [ERROR ITMS-90717 - 简书](http://cdn2.jianshu.io/p/e8f3791ec556)
- [添加一个 App Store 图标 - iTunes Connect 开发人员帮助](https://help.apple.com/itunes-connect/developer/#/dev8b5cb82e2)


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


