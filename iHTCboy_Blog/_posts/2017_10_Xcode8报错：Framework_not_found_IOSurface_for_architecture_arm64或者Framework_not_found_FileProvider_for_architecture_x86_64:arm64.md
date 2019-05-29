title: Xcode8报错："Framework not found IOSurface for architecture arm64"或者 "Framework not found FileProvider for architecture x86_64/arm64".
date: 2017-10-27 08:33:16
categories: technology #life poetry
tags: [Xcode9,IOSurface,Framework not found]  # <!--more-->
reward: true

---

Xcode8 编译报错：
> **Framework not found IOSurface for architecture arm64** 
或者
 **Framework not found FileProvider for architecture x86_64/arm64.** 

### 原因
IOSurface.framework和 FileProvider.framework是 iOS11 新增加的库，但  Xcode8下没有这个库。打包静态库的时候，有一个Link Frameworks Automatically设置，默认为YES，会自动链接框架。所以Xcode 9打包的静态库时，在Xcode 8项目编译时候会提示找不到 IOSurface.framework和 FileProvider.framework。

<!--more-->

题外话，这个在 Xcode5 和 Xcode6 过度时，Metal.framework 时发生过，可能过了就忘记了。也发现 Xcode 很多特性平时没有注意，有空真要多看看 LLVM 的知识。

### 结果

如果升级到 Xcode9，则不受影响。如果 Xcode8 编译报错，网上最初给出的方案，在 Xcode8 中添加IOSurface.framework和 FileProvider.framework后打包，结果最后坑定了！

在 Xcode8 中添加IOSurface.framework和 FileProvider.framework后打包，上传iTunes Connet 报错：

![iTunes Connet 报错使用非法 API.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2017/10/iTunes-Connet-Error.jpg)

### 正解解决方案

 Build Settings 中 Link Frameworks Automatically 把默认Yes 改成 No ，在 Xcode8 编译就能通过。

![设置 Link Frameworks Automatically 为 NO.jpeg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2017/10/Xcode-Settings.jpeg)


### 参考&扩展阅读
- [ios8 - XCode 6 GM: linker error when building for device (Metal not found) - Stack Overflow](https://stackoverflow.com/questions/25804696/xcode-6-gm-linker-error-when-building-for-device-metal-not-found/25924645)
- [New Features in Xcode 5](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/WhatsNewXcode/Chapters/xcode_5_0.html#//apple_ref/doc/uid/TP40012953-SW1)
- [XCode’s New “Link Frameworks Automatically” & How to Fix “framework not found Metal for architecture armv7”](https://mmmag.appsee.com/2014/09/22/xcode-new-link-frameworks-automatically-fix-framework-not-found-metal-for-architecture-armv7/)
- [ios - Framework not found IOSurface for architecture arm64 - Stack Overflow](https://stackoverflow.com/questions/44450673/framework-not-found-iosurface-for-architecture-arm64)
- [ios - When do you have to link Frameworks and Libraries to an XCode project? - Stack Overflow](https://stackoverflow.com/questions/33728359/when-do-you-have-to-link-frameworks-and-libraries-to-an-xcode-project)
- [Don't we need to link framework to XCode project anymore?](https://stackoverflow.com/questions/24902787/dont-we-need-to-link-framework-to-xcode-project-anymore)
- [objective c - @import vs #import - iOS 7 - Stack Overflow](https://stackoverflow.com/questions/18947516/import-vs-import-ios-7/18947634#)
- [Modules和Autolinking的介绍与使用 - 简书](http://www.jianshu.com/p/0ce22e777900)
- [xcode 新特性的 一点理解 enable module 和 link frameworks automatically - 滴水成川 - CSDN博客](http://blog.csdn.net/xiaofei125145/article/details/41117085)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

