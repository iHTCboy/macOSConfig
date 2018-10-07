title: React Native项目Xcode打包发布iOS问题
date: 2016-12-25 20:45:16
categories: technology #life poetry
tags: [ReactNative,RN,iOS,打ipa包]  # <!--more-->
reward: true

---

### Xcode打包分布准备
对于新手来说，如果是混合开发或者纯RN应用开发好后，想打包上线了，却发现官方文档没有找到详细打包的流程文档，对于完全没有经验的新手真的不太好友。下面是参考资料总结而成：

##### 1、打包命令 [react-native bundle](https://github.com/facebook/react-native/blob/master/local-cli/bundle/bundleCommandLineArgs.js)，在RN项目根目录下：

```
react-native bundle --entry-file index.ios.js --platform ios --dev false --bundle-output ios/ios.jsbundle
```

<!--more-->

参数：
--entry-file ：ios或者android入口的js名称，比如**index.ios.js**
--platform ：平台名称(ios或者android)
--dev ：设置为false的时候将会对JavaScript代码进行优化处理。
--bundle-output,：生成的jsbundle文件的所在目录和名称，比如 ios/ios.jsbundle。

在当前项目中，输入上面命令，然后在ios/目录下生成2个离线包：
![react-native bundle --entry-file index.ios.js --platform ios --dev false --bundle-output ios:ios.jsbundle.png](http://upload-images.jianshu.io/upload_images/99517-6a9c15bd541da22a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
$ react-native bundle --entry-file index.ios.js --platform ios --dev false --bundle-output ios/ios.jsbundle
[2016-12-25 19:55:01] <START> Initializing Packager
[2016-12-25 19:55:01] <START> Building in-memory fs for JavaScript
[2016-12-25 19:55:01] <END>   Building in-memory fs for JavaScript (88ms)
[2016-12-25 19:55:01] <START> Building Haste Map
[2016-12-25 19:55:02] <END>   Building Haste Map (1091ms)
[2016-12-25 19:55:02] <END>   Initializing Packager (1212ms)
[2016-12-25 19:55:02] <START> Transforming files
[2016-12-25 19:55:15] <END>   Transforming files (13122ms)
bundle: start
bundle: finish
bundle: Writing bundle output to: ios/ios.jsbundle
(node:8023) DeprecationWarning: Using Buffer without `new` will soon stop working. Use `new Buffer()`, or preferably `Buffer.from()`, `Buffer.allocUnsafe()` or `Buffer.alloc()` instead.
bundle: Done writing bundle output
Assets destination folder is not set, skipping...
```

运行上面命令后，在项目的ios文件夹下看到 **ios.jsbundle**、**ios.jsbundle.meta**。

![生成的离线包.png](http://upload-images.jianshu.io/upload_images/99517-a6665ab5cf8f135a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 2、iOS项目中导入包

![生成的离线包.png](http://upload-images.jianshu.io/upload_images/99517-1a801cd7016e8048.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![安图选择完成.png](http://upload-images.jianshu.io/upload_images/99517-48879ec871457a8b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 3、修改项目中BundleURL
修改AppDelegate.h的定向URL，需要注意的是名字要跟你生成的jsbundle的名字一致。

```
//  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
  
  jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"ios" withExtension:@"jsbundle"];

```

![修改 jsCodeLocationURL.png](http://upload-images.jianshu.io/upload_images/99517-9c168d50b3e3a31b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 如果项目是混合开发，那么用到BundleURL的地方也要改成这个BundleURL地址。
- 如果修改了项目的js文件，那么就要重新打包一次，或者利用热更新机制更新。

### 参考

- [React Native ios打包 - 简书](http://www.jianshu.com/p/ce71b4a8a246)
- [React Native iOS打包，给用户生成ipa文件 - 简书](http://www.jianshu.com/p/7683efdd31f5)
- [React Native程序部署至iOS应用商店之前需要的配置和如何生成release版本的APK包](http://mp.weixin.qq.com/s?__biz=MzIwMTkxNzU3MA==&mid=2247483827&idx=1&sn=fb7695d8c2e361d6d05ffdaa1b4ccdfb&scene=2&srcid=0815De5rVOvAW4T5ahhZQzht&from=timeline&isappinstalled=0&utm_source=tuicool&utm_medium=referral)




<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


