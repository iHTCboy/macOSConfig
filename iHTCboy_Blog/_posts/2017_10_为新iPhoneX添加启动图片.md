title: 为新 iPhone X 添加启动图片
date: 2017-10-28 18:53:16
categories: technology #life poetry
tags: [iPhoneX,Xcode9,LaunchScreen]  # <!--more-->
reward: true

---

###  Xcode9 的 iPhone X 启动图片

iPhone X 启动图片大小：
- Portrait size ： 1125px × 2436px
- Landscape size：2436px × 1125px

<!--more-->

在 Xcode9 中位置：
![ iPhone X 启动图片.png](http://upload-images.jianshu.io/upload_images/99517-0b378a8a1b288922.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

启动图片尺寸：
![Static Launch Screen Images.png](http://upload-images.jianshu.io/upload_images/99517-54f5aa681f02debf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

目前是 iTunes 上传没有强制要求与说明，但是如果没有在 iPhoneX显示会上下留黑边，最好现在开始添加，苹果建议使用 storyboard 创建启动图片，但是要注意 iPhoneX 高度约束问题。网上给了一个应用没有iPhoneX启动图时打开的效果：
![Simulator Screen Shot - iPhone X - 2017-09-13 at 14.22.48_preview.png](http://upload-images.jianshu.io/upload_images/99517-3462692818a500cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/250)

最新消息，iPhone X 的屏幕快照可选性在 iTunes Connet 后台上传，因为昨天 iPhoneX 可预定啦！

>iTunes Connect 现已支持 iPhone X 屏幕快照
2017年10月27日
>
>现在，您可以为 iPhone X 上传屏幕快照。您将在 iOS App 版本信息页的“App 预览和屏幕快照”下方看到一个针对 5.8 英寸显示屏的新标签。 
请注意，iPhone X 的屏幕快照为可选项，且不能用于更小尺寸的设备。在 iPhone 上运行的所有 App 仍需提供 5.5 英寸显示屏的屏幕快照。
**iPhone X 屏幕快照分辨率**1125 x 2436（纵向）2436 x 1125（横向）
在[《iTunes Connect 开发人员帮助》](https://help.apple.com/itunes-connect/developer/#/devd1093d90d)中了解更多关于上传屏幕快照的信息。
了解更多有关[为 iPhone X 更新 App](https://developer.apple.com/cn/ios/update-apps-for-iphone-x/) 的信息。


![App 预览和屏幕快照 屏幕快照必须为 JPG 或 PNG 格式，且必须采用 RGB 颜色空间。 预览必须为 M4V、MP4 或 MOV 格式，且不能超过 500 MB。.png](http://upload-images.jianshu.io/upload_images/99517-51d67b38d790f9d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/840)


### 参考
- [Launch Screen - Icons and Images - iOS Human Interface Guidelines](https://developer.apple.com/ios/human-interface-guidelines/icons-and-images/launch-screen/)
- [ios - iPhone X: Incorrect launch-screen orientation used - Stack Overflow](https://stackoverflow.com/questions/46263795/iphone-x-incorrect-launch-screen-orientation-used)
- [iTunes Connect 现已支持 iPhone X 屏幕快照-2017年10月27日](https://itunespartner.apple.com/cn/apps/news/5993372)
- [Submitting iOS apps to the App Store - Apple Developer](https://developer.apple.com/ios/submit/)


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


