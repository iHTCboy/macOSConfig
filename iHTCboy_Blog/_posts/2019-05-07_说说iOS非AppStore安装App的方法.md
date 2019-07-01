title: 说说 iOS 非 AppStore 安装App的方法
date: 2019-05-07 22:49:16
categories: technology #induction life poetry
tags: [iOS,AppStore,IPA]  # <!--more-->
reward: true

---

### 1、前言
关于 iOS 安装 App 的方法，相信熟悉 iOS 的朋友都知道，如果是越狱设备，随便搞。但是，现实中，大部分用户都是小白，不会自己去越狱，安全是一方面。所以，普通情况下，AppStore 一家独大，企业账号可以玩一玩的情况，这也是苹果优秀的地方！ 今天就是想说说，关于新出的玩法~

<!--more-->

### 2、账号证书类型

| 账号类型 | 价格 | 发布到AppStore？ | 支持安装设置数量 | 申请条件 |
| --- | --- | --- | --- | --- |
| 个人账号 | $99 | 可以 | 100 | 无限制 |
| 公司账号 | $99 | 可以 | 100 | DUNS编码 |
| 企业账号 | $299 | 不可以 | 无限制 | DUNS编码 |
| 教育账号 | $0 | 可以 | 100 | 教育机构 |


通过这个表，就知道普通情况下，如果让用户安装App，只能是企业账号可行，而企业账号苹果当初只是想让那些只流通在企业内部使用的App使用，现在发展成了，非AppStore渠道的安装方式！ 灰产和各大第三方渠道xx装机xx助手。当然，这个不是今天的主题，以后有机会在慢慢说~


### 3、新安装方式

通过上面的表格，除了企业账号，其它类型的账号，也是可以安装App到设备上，缺点有2个：

- 要先添加 UDID 到证书
- 一年只能添加一百台设备且删除不恢复

基于这2点，正常情况下，没有人会想到用这样的方法提供安装App，但现在的情况不一样，苹果今天的审核已经很严格，基本过不了审核，另一方面企业账号，被苹果封杀和难申请，已经15万元都买不到！

现在，这终于成为新的安装方式！那就要解决上面说到的 2 个缺点， UDID 获取，如果让普通用户自己获取，然后提交在，在添加证书，在，，，， 这个流程太长！！ 所以，还是有解决方案！ 而，100台设备限制无解，只能多准备n个开发者账号啊！！

原理：

> 通过网页，用户接受授权就拿到iOS设备的`UDID` ,然后把你的`UDID`添加到他们的证书里面，用这个新证书重新签名原来的IPA包，此时，你的`UDID`在IPA包的证书里面，这样，你的iOS设备就能下载这个IPA包啊


### 4、UDID 获取

`UDID` (Unique Device Identifier)，唯一标示符,是iOS设备的一个唯一识别码，每台iOS设备都有一个独一无二的编码，UDID其实也是在设备量产的时候,生成随机的UUID写入到iOS设备硬件或者某一块存储器中,所以变成了固定的完全不会改变的一个标识，用来区别每一个唯一的iOS设备，包括 iPhones, iPads, 以及 iPod touches。


#### MDM

iOS支持企业级的MDM（Mobile Device Managment），也就是所谓的移动设备管理，目的就是让企业能够方便的管理 iPhone、iPad等移动设备。具体的做法是通过在系统中安装配置文件（Profiles）的方式实现各种功能，设备管理，设备安全，获取设备信息，设备配置，备份和恢复等几类功能，可以根据不同应用场景实现很多具体小功能。


#### 通过 Safari 浏览器获取iOS设备UDID步骤

苹果公司允许开发者通过iOS设备和Web服务器之间的某个操作（其实就是MDM的获取设备信息功能），来获得IOS设备的UDID(包括其他的一些参数)。以下为简要概述：
1、在你的Web服务器上创建一个.mobileconfig的XML格式的描述文件；
2、用户在所有操作之前必须通过某个点击操作完成.mobileconfig描述文件的安装；
3、服务器需要的数据，比如：UDID，需要在.mobileconfig描述文件中配置好，以及服务器接收数据的URL地址；
4、当用户设备完成数据的手机后，返回提示给客户端用户；

![20190507-Device-registration-process-ota_developer_flow_chart.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/05/20190507-Device-registration-process-ota_developer_flow_chart.jpg)


具体流程可参考文章：

[通过Safari浏览器获取iOS设备UDID(设备唯一标识符)-天狐博客](http://www.skyfox.org/safari-ios-device-udid.html)

具体后台开发代码可参考：

[shaojiankui/iOS-UDID-Safari: iOS-UDID-Safari,（不能上架Appstore！！！）通过Safari获取iOS设备真实UDID，use safari and mobileconfig get ios device real udid](https://github.com/shaojiankui/iOS-UDID-Safari)

#### 添加 UDID 到证书

- [fastlane/spaceship at master · fastlane/fastlane](https://github.com/fastlane/fastlane/tree/master/spaceship)

TODO

#### IPA 包重签名

- [fastlane/sigh at master · fastlane/fastlane](https://github.com/fastlane/fastlane/tree/master/sigh)

TODO

#### 从 Safari 安装 IPA 包

- [atelierdumobile/appdeploy: 🚀 AppDeploy is the fastest way to get info on your mobile app & deploy it OTA without specific server configuration](https://github.com/atelierdumobile/appdeploy)

TODO

### 总结

其实，这个作为一个`创新`的安装 App 的方式，不掉包！ 已经是企业证书无法比的，而且，不需要用户到设置里点击`验证`证书！ 完全在 Safari 里完成整个安装流程，确实是举足轻重的一步，未来将怎么样发展？期待吧！

- 2019.05.26 更新
因为之前比较忙部分文章内容没有给出方案，博主想打算继续写完时，发现已经有同志完成了，[超级签名-原理/机制/技术细节-完全解析 - 掘金](https://juejin.im/post/5cdeb72151882525cc707729?utm_source=gold_browser_extension)，所以，本文就不在重复给出方案啦（当然，可以自己根据实现需要定制自己的签名流，以后有机会做这一块在给大家分享吧），大家有什么不明白的，讨论区一起交流~


### 参考

- [Configuration Profile Examples](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/ConfigurationProfileExamples/ConfigurationProfileExamples.html)
- [shaojiankui/iOS-UDID-Safari: iOS-UDID-Safari,（不能上架Appstore！！！）通过Safari获取iOS设备真实UDID，use safari and mobileconfig get ios device real udid](https://github.com/shaojiankui/iOS-UDID-Safari)
- [通过Safari浏览器获取iOS设备UDID(设备唯一标识符) - FengHongSeXiaoXiang的博客 - CSDN博客](https://blog.csdn.net/FengHongSeXiaoXiang/article/details/82825046)
- [通过Safari浏览器获取iOS设备UDID(设备唯一标识符)-天狐博客](http://www.skyfox.org/safari-ios-device-udid.html)
- [超级签名-原理/机制/技术细节-完全解析 - 掘金](https://juejin.im/post/5cdeb72151882525cc707729?utm_source=gold_browser_extension)
- [fastlane/spaceship at master · fastlane/fastlane](https://github.com/fastlane/fastlane/tree/master/spaceship)
- [fastlane/sigh at master · fastlane/fastlane](https://github.com/fastlane/fastlane/tree/master/sigh)
- [atelierdumobile/appdeploy: 🚀 AppDeploy is the fastest way to get info on your mobile app & deploy it OTA without specific server configuration](https://github.com/atelierdumobile/appdeploy)
- [蒲公英 | 一步快速获取 iOS 设备的UDID](https://www.pgyer.com/udid)
- [蒲公英 - 超级签名](https://www.pgyer.com/app/superSignature)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
<br>


