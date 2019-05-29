title: Xcode10再坑之framework not found CoreServices for architecture armv7 
date: 2019-03-15 21:19:16
categories: technology #induction life poetry
tags: [Xcode10,IOSurface,CoreServices,Framework not found]  # <!--more-->
reward: true

---

### 1、前言

前段时间，升级了 Xcode10 后，提供给第三方用户的SDK，客户反馈说报错：

```ObjC
ld: framework not found CoreServices for architecture armv7 
```

**为什么 iOS SDK 拖入项目中就报错"ld: framework not found IOSurface for architecture arm64"？**

其实，翻开之前写的文章已经说过解决方案： [Xcode8报错："Framework not found IOSurface for architecture arm64"或者 "Framework not found FileProvider for architecture x86_64/arm64". | iHTCboy's blog](https://ihtcboy.com/2017/10/27/2017_10_Xcode8%E6%8A%A5%E9%94%99%EF%BC%9AFramework_not_found_IOSurface_for_architecture_arm64%E6%88%96%E8%80%85Framework_not_found_FileProvider_for_architecture_x86_64:arm64/)

当时，反复确认后，网上有些第三方的SDK提供商说升级 Xcode10 吧！！！慌张~ 你们就只能让别人升级啦！解决不了，重启，升级！但，NO，最后发现是新项目是使用 `CocoaPods` 导致的坑，一个地方进2次，还真不简单！

<!--more-->

其中，看到有赞云这样说：

![20190315-youzanyun-sdk.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/03/20190315-youzanyun-sdk.png)

我只能说，坑的一个算一个，第三方用户就是这样，希望技术真的改变生活！包括技术的生活！

### 2、问题原因

因为我们新的项目使用 `CocoaPods` 组件化，所以最后打SDK的项目是CocoaPods集成的，问题就出在这里！上一个文章说到解决方法很简单：（[Xcode8报错："Framework not found IOSurface for architecture arm64"或者 "Framework not found FileProvider for architecture x86_64/arm64". | iHTCboy's blog](https://ihtcboy.com/2017/10/27/2017_10_Xcode8%E6%8A%A5%E9%94%99%EF%BC%9AFramework_not_found_IOSurface_for_architecture_arm64%E6%88%96%E8%80%85Framework_not_found_FileProvider_for_architecture_x86_64:arm64/)）

> Build Settings 中 Link Frameworks Automatically 把默认Yes 改成 No 

但是，如果用 `CocoaPods` 集成，默认是 `Yes`！！！ 尼玛！！！

知道原因，解决就好办啦！但是，突然想到，以后 `pod install` 或 `pod update` 时，难道要人工的设置一次？？？ 不可能！不可能！不可能！

最后，还是在 `CocoaPods` 官方文档找到答案 [CocoaPods Guides - post_install](https://guides.cocoapods.org/syntax/podfile.html#post_install)：

在 `Podfile` 文件最后，添加下面代码：

```Ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_MODULES_AUTOLINK'] = 'NO'
        end
    end
end

```

这个是一个勾子`hook`，在pod安装完成前，允许更改配置或做些别的事件！

### 3、总结
这个问题，2次进坑，解决的问题本质就是一个，只是自己开始不相信！所以，遇到问题，还是要学会找到原因，只是通往答案的道路各不相同，只要不放弃，不抛弃，一定能为大家提供优质的服务！相信科技的力量！不然，只能让别人升级环境来适配你，这可不好哦！


### 参考
- [Xcode8报错："Framework not found IOSurface for architecture arm64"或者 "Framework not found FileProvider for architecture x86_64/arm64". | iHTCboy's blog](https://ihtcboy.com/2017/10/27/2017_10_Xcode8%E6%8A%A5%E9%94%99%EF%BC%9AFramework_not_found_IOSurface_for_architecture_arm64%E6%88%96%E8%80%85Framework_not_found_FileProvider_for_architecture_x86_64:arm64/)
- [SDK引入_常见问题 - 有赞云](https://www.youzanyun.com/support/faq/3476?qa_id=9026)
- [Core Services | Apple Developer Documentation](https://developer.apple.com/documentation/coreservices)
- [ios - Error when trying to link fat binary with 64-bit simulator target - Stack Overflow](https://stackoverflow.com/questions/22736056/error-when-trying-to-link-fat-binary-with-64-bit-simulator-target/53280331#53280331)
- [ld: framework not found CoreServices for architecture x86_64 · Issue #21768 · facebook/react-native](https://github.com/facebook/react-native/issues/21768)
- [XCode's New “Link Frameworks Automatically” & How to Fix “framework not found Metal for architecture armv7”](https://blog.appsee.com/xcodes-new-link-frameworks-automatically-how-to-fix-framework-not-found-metal-for-architecture-armv7/)
- [Add option to set “LINK FRAMEWORKS AUTOMATICALLY” to NO · Issue #48 · CocoaPods/cocoapods-packager](https://github.com/CocoaPods/cocoapods-packager/issues/48)
- [CocoaPods Guides - Podfile Syntax Reference <span>v1.7.0.beta.2</span>](https://guides.cocoapods.org/syntax/podfile.html#post_install)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



