title: 开源一款苹果 macOS 工具 - AppleParty（苹果派）
date: 2022-03-31 09:26:10
categories: technology #induction life poetry
tags: [AppleParty,苹果派,macOS app]  # <!--more-->
reward: true

---

> 本文首发于 [开源一款苹果 macOS 工具 - AppleParty（苹果派） - 掘金](https://juejin.cn/post/7081069026515877919)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

> AppleParty 是 37手游 iOS 团队研发，实现快速操作 App Store Connect 后台的自动化 macOS 工具。本文会介绍工具诞生的背景、使用教程和代码实现的简介，希望通过开源与大家分享成果，让更多人一起参与改进和完善，最后一起提高效率和拓展探索方向。

<!--more-->

![AppleParty-00](https://ihtcboy.com/images/2022-AppleParty-00.png)

## 一、前言

大家好，很高兴告诉大家一件重要的事情，我们发起了一个开源项目 —— [AppleParty（苹果派）](https://github.com/37iOS/AppleParty)（苹果派）。这是我们团队在上一个 [开源的 App Store](https://juejin.cn/post/7051512478630412301) 后又一个尝试。AppleParty 这个项目是我们 37手游 iOS 团队内部孵化的一个产品，希望这个项目能作为一个引子，通过开源与大家分享成果，一起提高效率和拓展大家对未来的探索方向。


## 二、项目背景

目前，iOS/macOS App 上架 App Store，与苹果打交道的唯一方式，就是登陆苹果 App Store Connect 后台（[https://appstoreconnect.apple.com](https://appstoreconnect.apple.com)，通过苹果后台进行 App 所有的信息和素材等送审准备工作。但是，目前苹果后台的自动化水平还处于零基础，很多重复的操作和功能，都没有提供批量处理方案，比如：

- 商店截图和预览视频的上传
- 应用内购商品的创建和更新
- App 本地化的元数据信息配置
- 开发者证书创建和管理
- ...


App 分析的指标：

- 展示次数
- 产品页面查看次数
- 首次下载次数
- 净预订量
- 平台版本（iOS14.5、iOS15...)
- 页面类型（产品页面、商店表单、App内活动...）
- 用户来源（网页引荐来源、App 引荐来源、AppStore 浏览、AppStore 搜索、活动通知...）
- ...

以上的 App 分析数据，每次只能下载一个指标的数据，每个 App 有十几个指标，操作这些重复的配置往往占用了运营同学非常长的时间，效率低且重复无聊的工作，导致我们长期无法做更多的时间开启和享受创造性。

基于以上种种痛点，我们从多个技术手段，打造了 Apple Party（苹果派对）工具! 通过尽可能快速实现操作的自动化流程，从而大大提高苹果后台的操作效率！

> 注：目前苹果有提供 App Store Connect API 方式，但是目前迭代的功能，还不能满足所有的需求，下文会展开说明。

### 2.1 Apple Party（苹果派）名字起源

**Apple Party（苹果派）**

我们倡导工作之余，丰富多彩的生活要领，健身、旅游、聚会、培养艺术兴趣等等。

- Party：派对 即 “宴会，聚会” 的意思，大家聚在一起庆祝和休闲的一种活动。

所以，Apple Party（苹果派对），简称：**苹果派**，就是希望大家在使用苹果的服务时，像似参加一场苹果派对，尽情欢乐，欢聚宴会~

我们希望，大家在 AppleOS 生态下开发时，可以提高效率，专注于核心内容，然后愉快派对！

##  三、使用说明

### 3.1 注意事件

**目前实现的功能**

- 内购买项目管理（批量创建和更新）；
- 批量商店图和预览视频上传和更新；
- 数据报表批量下载(后续开源)；
- 邮件发送工具；
- 二维码扫描和生成工具；

> 注：内购买项目和商店素材上传，暂时只支持 iOS app，未来会考虑支持 macOS app、tvOS app。

**环境依赖**

- 支持 macOS 10.13 和以上系统
- 依赖 [Transporter.app](https://apps.apple.com/cn/app/transporter/id1450874784)
- 依赖 Xcode（Transporter.app 依赖）


### 3.1 安装包下载

目前我们在 GitHub 开源 [37iOS/AppleParty](https://github.com/37iOS/AppleParty)，所以提供GitHub 安装包：

- [AppleParty 下载](https://github.com/37iOS/AppleParty/releases)

**update 更新**

目前已经使用 Sparkle 来实现版本更新，默认启动就会自动检查更新，也可以通过菜单栏进行手动检查更新。


### 3.2 使用介绍

因为账号记录是存放在 Keychain 里，所以首次打开时，会提示需要访问**钥匙串**：
![AppleParty-01](https://ihtcboy.com/images/2022-AppleParty-01.png)

> 如果点击“拒绝”，则不会保存账号和密码信息。

然后，会显示主界面：
![AppleParty-02](https://ihtcboy.com/images/2022-AppleParty-02.png)

默认情况下弹出登陆界面，也可以点击取消登陆（快捷键`esc`）：
![AppleParty-03](https://ihtcboy.com/images/2022-AppleParty-03.png)

现在默认登陆都需要双重认证：
![AppleParty-04](https://ihtcboy.com/images/2022-AppleParty-04.png)


如果需要使用短信验证码，可以点击“发送短信验证码”，如果希望通过语言验证码，可以勾选“拨打语言来电”切换：
![AppleParty-05](https://ihtcboy.com/images/2022-AppleParty-05.png)

#### 3.2.1 批量上传内购买项目和商店素材
点击“我的 App”，显示帐号所有的App，可以操作内购买项目管理和商店素材管理。
![AppleParty-06](https://ihtcboy.com/images/2022-AppleParty-06.png)

点击内购管理，显示当前已有的内购品项列表:
![AppleParty-07](https://ihtcboy.com/images/2022-AppleParty-07.png)

* 刷新：刷新当前App的内购品项列表（刚刚上传的品项不会马上生效，所以可以手动刷新）
* 导入表格：通过固定表格的形式，批量创建内购品项
* 导出表格：导出所有品项的信息 Excel 表
* 导出品项 ID：导出品项productID和内购品项id的对应表
* 下载表格示例：批量创建内购品项的示例 Excel 表格


点击 “导入表格”，可选择excel表进行导入，然后会显示导入的品项明细表。
![AppleParty-08](https://ihtcboy.com/images/2022-AppleParty-08.png)

> 如上图所示，列表1和2是自定义的送审截图，所以需要点击右下角的“上传截图”选定。

“提交”后，会显示下面的界面，如未设置专用密码，首次需要设置，或者点击右下角“设置特殊密码”重新设置。
![AppleParty-09](https://ihtcboy.com/images/2022-AppleParty-09.png)

> 专用密码的生成参考文档：[使用 App 专用密码 - Apple 支持 (中国)](https://support.apple.com/zh-cn/HT204397)

上传失败时，查看 ERROR 内容就是错误内容：
![AppleParty-10](https://ihtcboy.com/images/2022-AppleParty-10.png)


**批量素材上传**

点击“素材一键导入”一键上传，素材可以分别在不同尺寸下显示。

![AppleParty-11](https://ihtcboy.com/images/2022-AppleParty-11.png)

对应的尺寸，上传视频和截图后，填写排序的位置和视频海报帧：
![AppleParty-12](https://ihtcboy.com/images/2022-AppleParty-12.png)

> 可点击右上角 `？`按钮查看帮助文档。

#### 3.2.2 其它扩展功能

邮箱功能，一方面是可以设置快速邮件发送，另一方面是工具效率自动邮箱的通知需求。
![AppleParty-13](https://ihtcboy.com/images/2022-AppleParty-13.png)

二维码功能也是一个工作中的小痛点。
![AppleParty-14](https://ihtcboy.com/images/2022-AppleParty-14.png)


## 四、代码实现简解

### 4.1 上传内购买项目和商店素材

使用的是苹果提供的 Transporter 工具链，提供了上会的命令，有 3 个工具：

- Xcode.app
- Application Loader.app
- Transporter.app

其中，Application Loader 已经弃用了，可以忽视。`Transporter` 命令所有的目录：

Xcode.app:
```
/Applications/Xcode.app/Contents/SharedFrameworks/ContentDeliveryServices.framework/Versions/A/itms/bin/iTMSTransporter
```

Transporter.app:
```
/Applications/Transporter.app/Contents/itms/bin/iTMSTransporter
```

#### 4.1.1 Transporter 命令使用

**Lookup Metadata 模式**

获取 app 信息，获取到一个 xxx.itmsp 包，里面有关于 app 版本和内购品项等信息的 xml 格式文件。

```bash
iTMSTransporter -m lookupMetadata -u [user] -p [password] -apple_id(-apple_ids) -destination [output_path]
```

示例：

同时获取多个 app 信息：
```bash
iTMSTransporter -m lookupMetadata -u xxx@37.com -p 专用密码 -apple_ids 10 xxxx,多个appid,xxx -destination /Users/37/Desktop/output
```

获取单个 app 信息：
```bash
iTMSTransporter -m lookupMetadata -u 账号邮箱 -p 专用密码 -apple_id 某个appid -destination /Users/37/Desktop/output
```
 
**Provider 模式**

查询供应商，也就是开发者账号的名字和团队 id：

```bash
iTMSTransporter -m provider -u [user] -p [password]
```

示例：
```bash
iTMSTransporter -m provider -u xxx@37.com -p 专用密码
```

输出内容：
```bash
Provider listing:
   - Long Name -         - Short Name -
1  apple_dev           	  28PV6...4
2  37iOSTeam              R7S9...R1

```
 
**Verify 模式**
校验上传内容是否合法。

```bash
iTMSTransporter -m verify -u [user] -p [password] -f [itmsp_path] [-vp ]
```

示例：
```
iTMSTransporter -m verify -u xxx@37.com -p 专用密码 -f /Users/37/Desktop/IAP.itmsp
```

 
**Upload 模式**
上传内容。

```
iTMSTransporter -m upload -u [user] -p [password] -f [itmsp_path]
```

示例：
```
iTMSTransporter -m upload -u xxx@37.com -p 专用密码 -f /Users/37/Desktop/IAP.itmsp
```

 
一些重要参数说明：

- `-itc_provider`: 检查和上传时建议加子账号的团队id，但测试发现不用也行，先不带，因为获取很麻烦
- `-errorLogs`: 存储错误日志的目录
- `-loghistory`: 记录成功上传的数据包
- `-outputFormat xml`:  以 XML 格式返回输出信息,
- `-throughput`: 显示成功上传数据包的总传输时间以及数据包大小和每秒字节数
- `-o`: 记录输出信息
- `-v`: 日志级别，默认 eXtreme，详细
- `-vp`: 在验证或上传数据包文件时显示进度信息
- `-Xmx4096m`: 指定 4 GB Java 虚拟机 (JVM) 堆栈内存

> 详细，可以参考：[指定选项和值 - Transporter](https://help.apple.com/itc/transporteruserguide/#/apdAa073cb45)


详细也可以查看官方文档：

- [What is Transporter?](https://itunespartner.apple.com/tv/articles/transporter_getting-set-up)
- [Transporter 用户指南 2.0](https://help.apple.com/itc/transporteruserguide/)
- [Transporter 帮助](https://help.apple.com/itc/transporter/#/)
- [App 元数据规范 5.11](https://help.apple.com/asc/appsspec/)

#### 4.1.2 itmsp 数据包说明

通过命令，可以了解到，我们需要组装一个 `.itmsp` 的文件夹，里面包含我们需要上传的内购买项目的信息，送审截图，或者商店图片和预览视频等。

**内购买项目的 xml 配置文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://apple.com/itunes/importer" version="software5.9">
    <provider>{team_id}</provider>
    <software>
        <vendor_id>{SKU}</vendor_id>
        <software_metadata>
            <in_app_purchases>
                <in_app_purchase>
                    <!-- 可以由字母、数字、下划线（_）和句点（.）构成，最多 255 个字符 -->
                    <product_id>com.app.1usd</product_id>
                    <reference_name>1ud（2~64 个字符）</reference_name>
                    <!-- 消耗型项目consumable 非消耗型non-consumable 自动续期订阅auto-renewable 非续期订阅subscription -->
                    <type>consumable</type>
                    <products>
                        <product>
                            <cleared_for_sale>true</cleared_for_sale>
                            <wholesale_price_tier>3</wholesale_price_tier>
                        </product>
                    </products>
                    <locales>
                        <locale name="en-US">
                            <title>2~30个字符</title>
                            <description>至少10~45个字符</description>
                        </locale>
                        <locale name="zh-Hans">
                            <title>中文2~30个字符</title>
                            <description>至少10~45个字符</description>
                        </locale>
                    </locales>
                    <review_screenshot>
                        <!-- Supported dimensions are: 1334x750, 750x1334, 1024x768, 1024x748, 768x1024, 768x1004, 2048x1536, 2048x1496, 1536x2048, 1536x2008, 2224x1668, 1668x2224, 960x640, 960x600, 640x960, 640x920, 2208x1242, 1242x2208, 2436x1125, 1125x2436, 312x390, 1136x640, 1136x600, 640x1136, 640x1096, 2732x2048, 2048x2732" -->
                        <size>636132</size>
                        <file_name>IMG_5180.PNG</file_name>
                        <checksum type="md5">xxxxx</checksum>
                    </review_screenshot>
                    <review_notes>Some notes for the reviewer.（2~4000字符）</review_notes>
                </in_app_purchase>
            </in_app_purchases>
        </software_metadata>
    </software>
</package>
```

**商店图片和预览视频的 xml 配置文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<package version="software5.10" xmlns="http://apple.com/itunes/importer">
    <provider>{provider}</provider>
    <team_id>{provider}</team_id>
    <software>
        <vendor_id>{vendor_id}</vendor_id>
        <software_metadata app_platform="{app_platform}">
            <versions>
                <version string="{app_version}">
                    <locales>
                        <locale name="{app_locale}">
                            <title>{title}</title>
                            <app_previews>
                                <app_preview display_target="{iOS-5.5-in}" position="{1}">
                                    <data_file role="source">
                                        <size>{video_size}</size>
                                        <file_name>{video_name}</file_name>
                                        <checksum>{video_md5}</checksum>
                                    </data_file>
                                    <preview_image_time format="30/1:1/nonDrop">{00:00:05:00}</preview_image_time>
                                </app_preview>
                            </app_previews>
                            <software_screenshots>
                                <software_screenshot display_target="{iOS-5.5-in}" position="{1}">
                                    <size>{image_size}</size>
                                    <file_name>{image_name}</file_name>
                                    <checksum type="md5">{image_md5}</checksum>
                                </software_screenshot>
                            </software_screenshots>
                        </locale>
                    </locales>
                </version>
            </versions>
        </software_metadata>
    </software>
</package>
```


**上传 iap 包的 xml 配置文件**

```
<?xml version="1.0" encoding="UTF-8"?>
<package version="software5.10" xmlns="http://apple.com/itunes/importer">
  <software_assets apple_id="{apple_id}" app_platform="ios">
    <asset type="bundle">
      <data_file>
        <size>{file_size}</size>
        <file_name>{file_name}</file_name>
        <checksum type="md5">{file_md5}</checksum>
      </data_file>
    </asset>
  </software_assets>
</package>
```

详细的格式，可以参考项目里的示例：[https://github.com/37iOS/AppleParty/tree/main/AppleParty/Resources/Transporter](https://github.com/37iOS/AppleParty/tree/main/AppleParty/Resources/Transporter)。大家有任务疑问，欢迎在评论区留言哈~


### 4.2 App 分析数据、销售趋势

iOS app 发布上线后，用户从 App Store 搜索和下载 app， 查看 app 产品页面，下载并且使用过程中，app 的使用次数、内购充值、或者崩溃等数据，还有后续的付款和财务报表等。

这些数据对于游戏运营和财务部门来说，同样非常的重要。一般是在苹果后台查看或下载导出，所以希望能从苹果后台自动化的方式获取到这些数据。

目前苹果后台关于数据的功能有这三个：

![](https://ihtcboy.com/images/2022-AppleParty-15.jpg)


* App 分析
* 销售和趋势
* 付款和财务报告（目前没有使用）

注：付款和财务报告是 app 内购买的金额统计和对订单，目前的导出数据需求里，并不需要此数据。


#### 4.2.1 调研报告

通过调研，目前主流的方法有以下三种：

* **苹果官方**：App Store Connect API：REST API，下载销售和趋势报告（.txt文件）
* **苹果官方**：Reporter 命令行工具：.jar包，跨平台，下载销售和趋势报告（.txt文件）
* **第三方开源**：Fastlane - Spaceship：需要Ruby环境，获取每日销售明细（json数据）

对应的文档：

* [App Store Connect API | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi)
* [Reporter 用户指南 3.1.6](https://help.apple.com/itc/appsreporterguide/#/)
* [fastlane/spaceship · fastlane](https://github.com/fastlane/fastlane/tree/master/spaceship)


#### 4.2.2 App Store Connect API

> 自定义工作流程并实现自动化，以便您集中精力打造出色的 app。这个基于标准规范的 REST API 让您可以跨各种开发者工具 (如 App Store Connect、Xcode 以及“Certificates, Identifiers & Profiles”(证书、标识符和描述文件)) 实现任务自动化，使工作流程更灵活、更高效。这个 API 可用于开发、beta 版测试、管理 app 元数据、生成报告等。

**销售和趋势**
下载报告，以查看您的 app 在所有 Apple 平台上的首次下载量、销售额、收入、预订量、订阅活动等。

**付款和财务报告**
下载按产品、销售地区、货币、价格等划分的月度收入报告。您可以查看每个月的付费金额，以及任何纳税调整或预扣税。


**URL**
```url
GET https://api.appstoreconnect.apple.com/v1/salesReports
```

具体请求参数和响应，可以查看文档：[Download Sales and Trends Reports | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/download_sales_and_trends_reports)

#### 4.2.3 Reporter 命令行.

> Reporter 是一个命令行工具，可以用来下载您的销售和趋势报告以及付款和财务报告。您还可以查看错误说明以及延迟报告的预计可用时间等信息。如果您的多个开发者帐户使用同一个 Apple ID，您可以在 Reporter 轻松切换帐户。

**下载销售和趋势报告**
使用 Sales.getReport 命令下载销售和趋势报告。

**下载财务报告**
使用 Finance.getReport 命令可为您下载财务报告。


**语法**

```bash
$ java -jar Reporter.jar p=[properties file] Sales.getReport [vendor number], [report type], [report subtype], [date type], [date], [version]*（如适用）
```

具体请求参数和响应，可以查看文档：[下载销售和趋势报告 - Reporter 用户指南 3.1.6](https://help.apple.com/itc/appsreporterguide/#/apd68da36164)


#### 4.2.4 Spaceship

> spaceship exposes both the Apple Developer Center and the App Store Connect API. It’s super fast, well tested and supports all of the operations you can do via the browser. It powers parts of fastlane, and can be leveraged for more advanced fastlane features. Scripting your Developer Center workflow has never been easier!
> 
> spaceship 公开了 Apple Developer Center 和 App Store Connect API。它速度超快，经过充分测试并支持您可以通过浏览器执行的所有操作。它为 fastlane 的部分功能提供支持，并可用于更高级的 fastlane 功能。编写您的开发人员中心工作流程脚本从未如此简单！

相当于第三方对苹果接口的封装，并且是依赖 Ruby 环境执行，对于我们的自动化来说，可以使用。但是，如果是工具化，那么并不适用，所以，不作深入研究。大家有兴趣可以看看：[spaceship · fastlane/fastlane](https://github.com/fastlane/fastlane/blob/master/spaceship/README.md#readme)。


#### 4.2.5 爬虫

以上介绍的3种方式都不支持获取和下载**App 分析**数据，所以，从目前技术方案来说，爬虫是实现方案中成本和可行性最低的方法。

**爬虫的原理**：模拟开发者输入账号密码（获取到用户的登陆状态），然后点击登陆，点击对应的页面标签，下载对应的数据。

**方案**

* 用 python 爬虫库
* 用 Swift 网络库

#### 4.2.6 总结

| 方案  | 优点  | 缺点  | 登陆验证方式 | 自动化程度  |
|---|---|---|---|---|
| App Store Connect API | 官方维护，接口和文档全  | 不支持下载`App 分析`数据 | API keys | 高 |
| Reporter 命令行工具  | 官方维护，接口和文档全  | 不支持下载`App 分析`数据 | 访问令牌 | 高 |
| Fastlane - Spaceship  | 命令自动化工具  | 不支持下载`App 分析`数据 | API keys、账密(+验证码) | 中 |
| 爬虫  | 苹果后台所有功能都支持  | 如果接口变更，<br>开发者也需要调整 | 账密(+验证码)   | 中 |


综上，从目前业务场景和业务需求来说，爬虫是当前**折中的方案**，也是最快和最有效的方案。未来，如果苹果 `App Store Connect API` 或 `Reporter 工具` 支持下载**App 分析**数据，那么，这将是更好的方案。


## 最后

AppleParty 要解决的问题是开发者有很多 app 的情况下的管理，比如有多语言、频繁更新等，当然也有针对游戏行业的需求，比如素材会经常更新，内购买项目达到100+个，人工处理显示无法满足。而为什么不考虑做成命令行的工具？因为希望相关的这块工具可以交给运营处理，而不需要技术关注。

大家可能有一个疑问：`为什么不使用 SwiftUI`？因为考虑工具的通用性，兼容更多的系统版本，显然才是工具要做的事情，所以，相信未来一定会用上 SwiftUI 的！另外，苹果为什么不推出批量操作和更加完善的工具呢？很显然，苹果在努力打造 `App Store Connect API`，但其实苹果的功能非常多，一步到位解决所有的问题不太现实，所以，我们也非常期待苹果新的 API，来解决更多重复操作的问题。


以上就是  AppleParty 项目的内容简单介绍，大家可以在 GitHub [37iOS/AppleParty](https://github.com/37iOS/AppleParty) 查看详细的源代码。如果觉得不错，给我们点个赞！如有疑问或者问题，欢迎留言交流~

最后，Apple Party（苹果派）是一个新生孩，所以可能会存在很多缺陷，甚至不能满足所有的场景，希望大家多担待和理解万岁，期待大家一起给项目提建议，提代码，一起卷好！


> 欢迎关注我们，了解更多 iOS 和 Apple 的资讯~


### 特别感谢

- [Alamofire/Alamofire](https://github.com/Alamofire/Alamofire)
- [Kitura/Swift-SMTP](https://github.com/Kitura/Swift-SMTP)
- [SnapKit/SnapKit](https://github.com/SnapKit/SnapKit)
- [sparkle-project/Sparkle](https://github.com/sparkle-project/Sparkle)
- [tid-kijyun/Kanna](https://github.com/tid-kijyun/Kanna)
- [drmohundro/SWXMLHash](https://github.com/drmohundro/SWXMLHash)
- [jdg/MBProgressHUD](https://github.com/jdg/MBProgressHUD)
- [joshuajylin/MBProgressHUD-macOS](https://github.com/joshuajylin/MBProgressHUD-macOS)
- [Yueoaix/SymbolicatorX](https://github.com/Yueoaix/SymbolicatorX)
- [fpotter/ExpandingDatePicker](https://github.com/fpotter/ExpandingDatePicker)
- [kishikawakatsumi/KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
  

## 参考引用

- [37iOS/AppleParty: macOS App for App Store Connect to Improve Processing Efficiency and Enjoy the Party.](https://github.com/37iOS/AppleParty)
- [用 SwiftUI 实现一个开源的 App Store - 掘金](https://juejin.cn/post/7051512478630412301)
- [Apple Transporter.app](https://apps.apple.com/cn/app/transporter/id1450874784)
- [使用 App 专用密码 - Apple 支持 (中国)](https://support.apple.com/zh-cn/HT204397)
- [What is Transporter?](https://itunespartner.apple.com/tv/articles/transporter_getting-set-up)
- [Transporter 用户指南 2.0](https://help.apple.com/itc/transporteruserguide/)
- [Transporter 帮助](https://help.apple.com/itc/transporter/#/)
- [App 元数据规范 5.11](https://help.apple.com/asc/appsspec/)
- [App Store Connect API | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi)
- [Reporter 用户指南 3.1.6](https://help.apple.com/itc/appsreporterguide/#/)
- [下载销售和趋势报告 - Reporter 用户指南 3.1.6](https://help.apple.com/itc/appsreporterguide/#/apd68da36164)
- [fastlane/spaceship · fastlane](https://github.com/fastlane/fastlane/tree/master/spaceship)
- [Download Sales and Trends Reports | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/download_sales_and_trends_reports)

> 注：如若转载，请注明来源。