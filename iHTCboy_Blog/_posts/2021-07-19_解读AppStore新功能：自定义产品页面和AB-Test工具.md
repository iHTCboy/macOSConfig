title: 解读 AppStore 新功能：自定义产品页面和 A/B Test 工具
date: 2021-07-19 11:51:16
categories: technology #induction life poetry
tags: [App Store,产品页优化,自定产品页,Custom Product Pages]  # <!--more-->
reward: true

---

本文首发于 [解读 AppStore 新功能：自定义产品页面和 A/B Test 工具 - 掘金](https://juejin.cn/post/6986478834040209445)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

<!--more-->

### 一、前言

可能很多开发者还没有意识到，今年 WWDC21 推出 [《Get ready to optimize your App Store product page》](https://developer.apple.com/videos/play/wwdc2021/10295/) 是一个重磅功能！因为 iOS app 下载的地方，目前只有一个：`App Store`。所以，它是所有 app 能够提高暴光和决定用户是否下载最直接和最后的风口。如何包装好这个风口，最直接是影响下载量！而下载量意味着用户量。所以这个 Session 的重要性不言而喻，但是这个 Session 视频仅仅只有 8 分钟时间！为什么呢？咱们先留个伏笔，下文在解读。


### 二、正文

大家好！今天小编又带大家一起吃瓜啦！咱们先来总结一下有那些 App Store 新功能，然后**挖掘一些深度剖析的问题并尝试“解答”，最后分享一些 App Store 解读**，最后，本文希望大家能有所**收获**哈~

![16266156439879.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/752ed7c3d3b04e52b551b9ac18f97338~tplv-k3u1fbpfcp-watermark.image)

首先，AppStore 产品页面优化有二个方面：

* 自定产品页面
* 产品页面优化

简单来说，`自定产品页面` 就是开发者可以针对一个 app 设置不同的商店截图、app 预览和推广文本；而 `产品页面优化` 就是可以测试使用不同的 app 图标、截图、预览和推广文本时，不同用户的反应(展示次数、下载次数、转化率等)，从而优化并提升效果。

> **进一步利用您的产品页面**
>  
> 今年晚些时候，您将能够在 App Store 上对产品页面进行优化和自定，进一步提高页面的相关性和有效性。了解如何使用这些功能在 iOS 和 iPadOS 上的 App Store 中以全新方式与顾客分享您的 app。

**自定产品页面**
使用不同的推广文本、截屏和 app 预览，创建产品页面的其他版本，更好地展示 app 的特定功能或内容。通过唯一的链接将相关受众定向到特定页面，并在“App 分析”中查看效果。

**产品页面优化**
比较不同的 app 图标、截屏和 app 预览，看看哪个最能引起用户共鸣，从而优化您的产品页面。在 App Store Connect 的“App 分析”中查看结果，然后将效果最好的素材资源呈现给所有用户。

> 注：在苹果的 [官方文档](https://developer.apple.com/cn/app-store/product-page-updates/) 有详细说明。

#### 2.1 自定产品页面

首先，讲解一下自定产品页面，到底有那些内容可以自定义：

1. app 预览
2. 截屏
3. 推广文本

目前只支持以上三种元数据的自定义，app 图标、app 名称、描述、副标题等暂时不支持。（为什么不支持？读者可以思考一下，下文会解读。）

举例子来说，比如下面这个应用：

![16266160583897.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0c3c83659f0147308335fcb84d98f170~tplv-k3u1fbpfcp-watermark.image)


这是一个关于登山者的应用，第一个产品页面是 `默认产品页面`，也就是这个是默认的商店显示效果，但是这个默认的页面，针对所有用户都是一样的，所以，并不能让不同的兴趣爱好的用户都能第一时间了解到自己想要和关注的功能。举例来说，比如一些用户喜欢登山，而另一些用户可能只是喜欢看别人登山或享受山上风景，这时候开发者就可以利用自定产品页面，选择展示 app 直播的功能，吸引有兴趣实时关注登山者或将直播他们自己的登顶旅程的用户。诸如此类，创建突出显示 GPS 跟踪功能，以吸引有兴趣计划与一群朋友一起攀登的人。如果您开发一款游戏，您可以创建一个最吸引人的游戏角色或受欢迎的玩法，突出您游戏的截图或 app 预览的自定义界面。**总之，您可以把您 app 的特色内容提炼成卖点，创建特色的自定义产品页面。**（是不是很棒，可以点个赞！下面内容更赞哦~）

![16266176661670.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fac8e2e77f4c4aa2b143ebe9f9d9daf5~tplv-k3u1fbpfcp-watermark.image)

好了，咱们总结一下 `自定产品页面` 的功能：

* 自定义元数据：
    1. app 预览
    2. 截屏
    3. 推广文本
* 可本地化
* 唯一商店链接

**可本地化**就是可以针对某个语言创建自定义产品页面，最后，每个自定义的产品页面，都有自己唯一的 URL，因为自定义的产品页面，必须是通过单独的链接才能访问显示对应的自定义页面，而默认用户在商店看到的是：`默认产品页面`（Dafault product page）。

说到这里，有读者可能会有这样的疑问：能自定义的 app 图标吗？不着急，小编在下文解读部门在分析啊。


![16266176768705.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2cd9ce56bab049fca64a3c8e145d9b8b~tplv-k3u1fbpfcp-watermark.image)

既然创建了自定义产品页面，那么目的也是很明确，做了事情就要看效果嘛！通过 App Store Connect 后台的 App Analytics 中可以查看每个页面的指标，包括：

* 展示次数
* 下载量
* 转化率
* 留存数据
* 每位付费用户的平均收益

通过以上数据，了解某些页面如何转化用户，具体的数据和效果，目的不太确定，到时候大家可以试试看啊~


![16266184290852.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0ab9a4efd0fe47ee8603b8358c3eb2d8~tplv-k3u1fbpfcp-watermark.image)

总结一下 `自定产品页面` 开发者可以提前准备什么：

* 计划明确您的目标
* 考虑您突出显示的功能和内容
* 准备好元数据


最后，**划重点**：

* 一次最多可以发布 35 个自定产品页面。
* 您可以随时在 App Store Connect 中创建新的页面并单独提交这些页面进行审核，而不需提交 app 更新。
* 在“App 分析”中查看展示次数、下载次数、转化率等信息，以便监控每个自定产品页面的效果。
* 衡量每个自定产品页面的用户留存率和付费用户平均收益，以了解这些页面在一段时间内的效果。

> 注：可以在 [增强您的产品页面 - App Store - Apple Developer](https://developer.apple.com/cn/app-store/product-page-updates/) 页面了解。

#### 2.2 产品页面优化

以上说的 `自定产品页面` 功能，因为自定义的界面是通过单独唯一的链接访问，所以一般是用在推广渠道，针对某些兴趣的用户群体投放的广告等。那些在 App Store 里搜索或浏览 app 的用户，自定义产品页面起不到作用啊！所以，苹果就提出了优化的方案，通过设置和测试默认页面的不同处理方式，拆分每个页面的流量，给不同的用户展示不同的内容：


![16266190429109.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/230c2624009a4c9881158f88520a72fa~tplv-k3u1fbpfcp-watermark.image)

* 原始产品页面
* 测试产品页面

`Treatment` 可译为治疗、处理，此处小编翻译为**测试**比如好理解。也可以这样理解：`原始产品页面`（对照组）和 `测试产品页面`（实验组）。

举例来说，有一个 app 的图标主色调是紫色，那如果换成红色图标后用户会不会更愿意下载 app 呢？换作以前是没有办法对比测试，只能换一个图标看看。而现在，苹果允许，一个 app 同时创建不同的 app 图标的产品页面进行对比测试：


![16266196049939.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/41a912ddcba64add95d9aa0988e0ec11~tplv-k3u1fbpfcp-watermark.image)

简单来说，开发者设置 `原始产品页面` 和 `测试产品页面`后，选择每一种获得总流量比例，比如原始产品页面设置为 70% 流量后，其它三种每个将获得 10% 流量。需要注意的时，按照控制变量法的原则，每个测试最好是只改变一个变量啊。


![16266202825378.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/088f40712ab84c8cb5bf53febddf4ee8~tplv-k3u1fbpfcp-watermark.image)

涉及 app 图标测试时，我们要确保所有下载您 app 的用户都能获得一致的体验。因为，您的 app 图标是吸引 App Store 用户并在他们的主屏幕上脱颖而出的重要变量。简单来说，就是用户如果在商店看到你的 app 图标是红色，那么用户如果下载到手机的话，应该看到 app 的图标也是红色，这样才符合用户的预期！所以，**测试 app 图标时，需要在 app 包体中包括对应的测试图标，也就是需要重新提交 app 更新审核**。


![16266203252869.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f07b616a178d49518be89854ed839f3c~tplv-k3u1fbpfcp-watermark.image)

另外，开发者还可以仅在特定的本地化语言中测试。例如，app 产品页面当前已本地化为英语、日语和韩语，则您可以选择仅以日语进行测试。这意味着任何看到您的产品页面的英语或韩语本地化版本的用户都不会参与测试。因为如果您的测试目的仅与您的本地化的一个子集相关，这使您可以灵活地专注于测试。简单来说，一些测试的内容可能与日本地区的文化背景和用户习惯有很大关联，调整的内容可能只针对日本地区用户展示，那么测试就没有必要干扰其它地区的用户，也更加精耕细作！另外，**如果测试产品页面的图标转化效果更好，此时不能设置测试产品页面为默认的产品页面，需要提交 app 更新图标的重新送审。**


![16266205532546.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5b86f5467d3e4dbfbed56a8d4788f9fe~tplv-k3u1fbpfcp-watermark.image)

既然优化产品页面测试有这些多变量控制，那么目的也是很明确，做了事情就要看效果嘛！通过 App Store Connect 后台的 App Analytics 中可以查看每个页面的指标，包括：

* 展示次数
* 下载量
* 转化率
* 改进方案

改进方案是指每种处理相对于基线（`原始产品页面`）的改进的指标，比如实验组的测试结果比原始产品页面效果更好，就改用实验组的产品页面等。有关如果在 App Analytics 中查看这些分析数据和更多详细信息，大家可以查看 “[App Analytics 中的新功能](https://developer.apple.com/videos/play/wwdc2021/10115)”。


![16266224678416.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b5be1c061db2422aaa1ef640c04e9b2b~tplv-k3u1fbpfcp-watermark.image)


总结一下 `优化产品页面` 开发者可以提前准备什么：

* 形成强有力的假设
* 准备好元数据
* 计划您的应用发布

**形成强有力的假设**

您可能会预测将应用图标更改为不同的样式会在某些语言环境中带来更好的转化，为什么这样做？因为测试是有条件限制的：

1. 每个测试是一个 `原始产品页面` 和最多 3 个`测试产品页面`。
2. 测试期间最多可以持续 90 天

所以，开发者针对每个测试，一定有良好的假设支撑，不然测试假设可能会误导自己啊~

**准备好元数据**

目前支持测试的只有以下三种元数据：

1. app 图标
2. 截屏
3. app 预览


**计划您的应用发布**

这个是针对 app 图标的测试，因为测试的 app 图标是必须包含在 app 的二进制文件中，也就是包体中，所以测试图标前，需要提交 app 更新审核。

最后，**划重点**：

* 考虑限制每次测试的元素数量，这样更容易确定具体是哪个元素产生了特定结果。
* 您所测试的所有备选元数据都需要提交审核。
* 只包含备选截屏和 app 预览的方案可以单独提交审核，而不需提交新的 app 版本。
* 如果您希望测试备选的 app 图标，那么您发布的 app 的二进制文件中必须包含图标的所有尺寸版本 (包括适用于 App Store 的 1024 x 1024 像素版本)。

> 注：可以在 [增强您的产品页面 - App Store - Apple Developer](https://developer.apple.com/cn/app-store/product-page-updates/) 页面了解。


![16266224997979.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9169b9dba68141b795d845967efbd83a~tplv-k3u1fbpfcp-watermark.image)

自定义和优化产品页面这两个功能的所有操作，App Store Connect API 都将支持自动化的接口，完整的 API 规范将于今年晚些时候发布。

最后的最后，以上所有的功能，到目前为止 7 月 19 号还没有看到详细的文档，苹果重新定义了 `later this year`。所以，下面就是本文的重头戏，小编带你解读产品页面功能！


#### 2.3 解读：产品页面功能

WWDC21 在 6 月 7 号开始至今 7 月 19 号，已经一个半月都过去了，苹果关于 App Store Connect 更新内容一点消息都没有！（小编注：可能是美国疫情，苹果工程师在家办公对接的效率不高！？）

1. 所有视频和资料，均没有本次功能更新的后台操作界面
2. 截止 7 月 19 号，所有文档没有找到相关资料。（包括 Xcode 和 iOS beta 更新文档也没有提及。）

综上，小编有理由怀疑，这些功能在 6 月 7 号时还没有开发！也许产品经理觉得今年没有创新和亮点，临时加上的功能？？？（小编注：此功能在 Google Play 早已经有了。）所以今年晚些，总之 2021 年 12 月 31 号前都有可能！

所以，小编接下来，为大家解读一些深度的内容（觉得不错，可以先点个赞啊~）：

**解读1：自定义产品页面为什么只支持以下三种元数据的自定义？**

1. app 预览
2. 截屏
3. 推广文本

除了以上三种元数据，产品页面还有那些元数据呢？

1. app 图标
2. app 名称
3. 副标题
4. 描述

首先说说 app 图标，正如苹果说的用户一致的体验，用户 在 App Store 看到什么图标，下载到手机时看到的图标应该一样！所以，怎么保证用户下载的 app 图标一致，那就需要 app 包体二进制中包括这些图标。也就意味着，开发者需要把图标配置在项目中打包，还要提交 app 更新。另外，不同图标，意味着不同的 app？马甲包的概念？综上，不支持 app 图标自定义，是因为自定义是一个永久的链接，而一个 app 有多个图标可能并不太适合（苹果应该是这样考虑的。）

另外，关于使用不同 app 图标，苹果能接受的“不同”的度有多少？完全不一样的图标可以吗？所以，这个理由你觉得充分吗？（小编注：这里自定义 app 图标，与下面的测试不同 app 图标是不同概念，下文再解析。）

最后， app 名称，副标题，描述等，为什么不能改呢？如果熟悉 App Store 的开发者一定都知道 `关键词`！没错，就是关键词，因为以上这些文本都与关键词紧密关联。那么，可能有读者马上就会有疑问：`推广文本`不也是文字吗？是的，但苹果已经明确说，宣传文本不会影响您的 app 的搜索排名，因此不得用于显示关键词。详细可以查看 [苹果文档](https://developer.apple.com/cn/app-store/product-page/)，小编就不在展开了，如果有机会在单独写一篇文章啊。

因为有关键字搜索的文字，所以，苹果目前是不允许更改 app 名称、描述、副标题等。当然，如果从技术上分析完全可行，但是，大家都知道苹果允许开发者设置的关键词总计不能超过 100 个字符，如果可以自定义 app 名称、描述、副标题，一方面是扰乱现有的关键词搜索排名，还有另一方面，不同的 app 名称对于苹果和用户来说，都是一个不友好的体验，你懂我说什么的。

所以，从这里就可以看出，一个功能的调整不是简单的技术是不是可以实现，还有更多的细节的系统性的考虑，**当一个系统越复杂，它的变动影响的范围就更大，或者说它能创新的范围可能就缩小了。**



**解读2：产品页面什么元数据更新需要提交 app 新版本审核？**

首先，产品页面的元数据包括：

1. app 图标
2. app 名称
3. app 预览
4. 截屏
5. 副标题
6. 描述
7. 推广文本
8. App 内购买项目
9. 新功能
10. 评分与评论
11. 类别
12. 本地化

从本质来说，这些内容的修改，与 app 无关，也就是不用提交 app 新版本。但是，前文已经提到了，app 图标是一个特殊的存在，苹果一直非常注重用户体验，所以，如果在测试不同 app 图标时，是需要提交包含测试图标的新版本 app 审核。既然要送审，那么有多种不同的图标，送审流程是怎么样的呢？


**解读3：测试不同的 app 图标，提交新图标的 app 审核流程是怎么样？**

很遗憾的告诉大家，到目前为止，小编费尽全力也没有找到流程！如果有读者知道，可以告诉一下大家啊。下面就给大家分析一下目前已知的情况：

在 [Get ready to optimize your App Store product page - WWDC21](https://developer.apple.com/videos/play/wwdc2021/10295) 视频中有这样一段话：

> And remember, to test a variation of your app icon, you'll need to include the icon assets in the binary of your app version that is currently live, so make sure to prepare your app releases accordingly.
> 请记住，要测试 app 图标的变体，您需要将图标集包含在当前上线的 app 版本的二进制文件中，因此请确保相应地准备应用版本。

那么问题就来了，怎么包含不同的图标集到 app 中呢？首先，想到的是 Xcode 13 beta 版本，然后在苹果的文档 [Xcode 13 Beta 3 Release Notes | Apple Developer Documentation](https://developer.apple.com/documentation/Xcode-Release-Notes/xcode-13-beta-release-notes) 中找到这样一段话：

> **Asset Catalogs**
>  
> **New Features**
>  
> At runtime, your app can now use iOS app icon assets from its asset catalog as alternate app icons. A new build setting, “Include all app icon assets,” controls whether Xcode includes all app icon sets in the built product. When the setting is disabled, Xcode includes the primary app icon, along with the icons specified in the new setting, “Alternate app icon sets.” The asset catalog compiler inserts the appropriate content into the Info.plist of the built product. (33600923)
> 在运行时，您的 app 现在可以使用其资产目录中的 iOS app 图标资产作为备用 app 图标。新的构建设置“包括所有 app 图标资产”控制 Xcode 是否包含构建产品中的所有 app 图标集。当该设置被禁用时，Xcode 包括主 app 图标，以及在新设置“备用 app 图标集”中指定的图标。资产目录编译器将适当的内容插入到构建产品的 Info.plist 中。 (33600923)

很显示，这个 Asset 图标功能是备用图标功能，在 Xcode 13.0 beta 3 (13A5192j) 中有一个新的选项 `Include all app icon assets`， 但是对应是 buildSettings 的 `ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS` 字段，作用就是 Asset Catalogs 编译器要不要把所有的备用图标也编译到 asset 集中。这个功能可以参考 [苹果文档](https://developer.apple.com/documentation/uikit/uiapplication/2806818-setalternateiconname?language=objc)，这里就不展开了。或者参考这些文章：

* [Alternate App Icons using Asset Catalogs in Xcode 13| Medium](https://katzenbaer.medium.com/alternate-app-icons-using-asset-catalogs-in-xcode-13-da6387d1cd78)
* [How to change your app icon dynamically with setAlternateIconName()](https://www.hackingwithswift.com/example-code/uikit/how-to-change-your-app-icon-dynamically-with-setalternateiconname)
* [jknlsn/XCode13-Alternate-App-Icons](https://github.com/jknlsn/XCode13-Alternate-App-Icons)

在 Xcode 的更新日志没有找到线索，那么小编想到的就剩下 `Assets.xcassets` 这个文件，打开后，也没有看到有更新和变动的功能和特性，一度让小编怀疑是不是这个功能没有！经过，最后的思考，小编终于想通了！在回头看这句话：

> And remember, to test a variation of your app icon, you'll need to include the icon assets in the binary of your app version that is currently live, so make sure to prepare your app releases accordingly.
> 请记住，要测试 app 图标的变体，您需要将图标集包含在当前上线的 app 版本的二进制文件中，因此请确保相应地准备应用版本。

小编大胆的猜测，如果要测试 app 图标功能，那么就要打出不同的图标的 app 包体，然后所有不同图标的包体都要提交 app 更新审核！！！这个流程是不是很大胆！

从目前的 Xcode 编译工具和文档来看，小编认为这种可能性很高，原因来几个方面。要从 App Store 显示图标和下载的包体图标一致，假设要测试三种图标的效果，如果一个包体里包含这三种图标，那么 App Store 要怎么通过下载过程的 app 包体显示什么图标呢？从技术上就比较难实现（不是实现不了，是需要时间，因为要 App Store、Xcode、开发者三者的联动。），所以，很大概率目前的实现方案很简单很粗暴！最后，小编当然也不会放过任何希望，在 Apple Developer Forums 论坛提问 [How to test a variation of your app icon | Apple Developer Forums](https://developer.apple.com/forums/thread/685321)，截止本文发表还没有回到回复。


**解读4：原始组和对照组，怎么分配测试的流量？**

从苹果的视频中，如果原始组是 70% 流量比例，那么对照组就分到 30% 流量，目前没有看到 App Store Connect 后台相关操作和文档更新的资料，所以，暂时不确定流量分配的细节，很大概率目前只支持随机分配吧。至于这个分配的规则苹果会不会透露暂时不确定，大家一起期待更新吧。


**解读5：测试有结果后，如果对照组效果更好，对照组是否可以设置为默认组？**

目前支持测试的只有以下三种元数据：

1. app 图标
2. 截屏
3. app 预览

因为以上三种元数据在发布测试前，都是需要苹果审核，并且是过审的。所以，如果对照组效果更好，是否可以设置为默认的产品页面元数据呢？

从目前已知的情况，默认产品页面的 app 图标更新，是需要重新提交 app 审核，跟现在更新 app 图标流程一样。而截图和 app 预览，不涉及到用户下载的 app，所以理论上是不需要更新 app 版本，并且测试的元数据是已经送审过了，所以是支持设置为默认组吧。总之，现在苹果后台和文档都没有更新出来，小编只能说大家一起期待吧~


**解读6：通过 App Store 搜索或者排行榜单进入 app 时，显示什么图标？**

目前来说，测试不同 app 图标是苹果分配流量，那么具体怎么分配，是用户打开 App Store 时就已经确认，还是请求数据时，苹果在分配呢。也就是说，用户通过链接打开 App Store 和主动打开 App Store时，测试不同 app 图标应该显示什么图标，应该是有多种情况，还要考虑用户是否已经下载过此 app 等，另外，每次测试只有 90 天，过了这个时间后，用户更新 app 对应的图标又应该怎么显示，所以，这个流程是一个复杂的过程。小编能猜测到就是，在 App Store 搜索和榜单显示的图标应该是一样的，至于显示那个测试的图标，要看看苹果的算法，一起期待吧~


**解读7：一次最多可以发布 35 个自定产品页面，够用了吗？**

刚开始看到 35 个自定义产品页面，小编觉得应该是够了。但深入思考后，如果你的 app 是全球同一个包体的话，35 个可能是不够啊。因为自定义的元数据有以下：

* 截屏、app 预览、推广文本
* 不同地区

从这些维度来说，开发者要思考好每个自定义产品页面需要变动的元数据，因为通过唯一的链接将特定受众定向到该页面，链接一旦生成，如果修改或者达到上限需要删除，原链接失效，这个影响和风险需要开发者考虑到。


**解读8：一次最多可以发布多少个产品页面优化的测试方案？**

目前支持测试的有以下三种元数据：

1. app 图标
2. 截屏
3. app 预览

目前苹果文档可以知道，针对一个测试产品页面，除了您的原始产品页面以外，您还可以尝试最多三种其他方案。但是，一个 app 最多可以有多少个测试产品页面呢？会不会是不限制？目前文档没有更新，所以我们只能猜猜啊~ 小编认为，测试期间最多可以持续 90 天，跟 TestFlight 保持一致，所以，测试产品页面，目前苹果应该是没有限制的或者说限制只能进步一种测试，一方面测试越多，测试流量怎么分配？不同的测试影响的效果怎么比较？数据怎么分析？所以，小编也认为，建议开发者要测试时，考虑限制每次测试的元数据数量，这样更容易确定具体是哪个元素产生了特定结果。


### 三、总结

以上就是自定义和优化产品页面这两个功能的解读，最后，我们来总结一下，这些功能的影响，不忘初心，这些功能的最初的目的是什么？都是提高 app 暴光量和下载量，所以，苹果在 [Meet in-app events on the App Store - WWDC21](https://developer.apple.com/videos/play/wwdc2021/10171) 提供了app 活动事件的新功能：


![16266617093722.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/21e82fdfcd224029b7cf63e620f7d584~tplv-k3u1fbpfcp-watermark.image)


这个功能的重点是什么？苹果推荐位！


![16266617742714.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b722ca289dc441dd800eb4a1321334fd~tplv-k3u1fbpfcp-watermark.image)

在 App Store 中除了苹果推荐位、排行榜外，最重要的入口就是搜索，用户搜索一般只会查看首屏的 app，占据上风，并大大提高应用程序的可见度。所以大家会尽量通过各种方式占据首屏：

**App 内购买项目**
通过 [推广 App 内购买项目](https://developer.apple.com/cn/app-store/promoting-in-app-purchases/) 可以让 app 占据更多的搜索位置，把竞品排掉，比如：


![16266639879996.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f7333dba4f574e7eaf483e3e60a50c7d~tplv-k3u1fbpfcp-watermark.image)


**关键词：App 名称**

比如抖音，通过分裂多个 app 名称，把搜索关键词紧紧抓住了，竞品排到了第 5 位，用户要滚动二屏才能看到，并且极速版的大小与其它 app 并未有很大的差异：


![16266638986534.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6be21ccbdeda45a1914ff98ae7db4885~tplv-k3u1fbpfcp-watermark.image)


以上还是中国区没有开启 Apple Search Ads 的情况，苹果搜索广告将在 7 月 21 日上线中国大陆，也是一波新的流量红利。大家可能没有什么感觉，我们通过苹果官网看一组数据：


![16266635553264.jpg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/358fcb4fb2844effb189d97ca5a29df3~tplv-k3u1fbpfcp-watermark.image)

> 1.来源：所有提供 Apple Search Ads 的国家和地区的 App Store 数据，2020 年。
> 2.来源：Apple Search Ads 在所有已推出该服务的国家和地区的搜索结果数据，2020 年。
> 来源：[Apple Search Ads](https://searchads.apple.com/cn/)

与搜索引擎优化（SEO）一样，App Store Optimization（ASO）是 iOS 平台非常重要的手段，包括关键字、评论和评级等。这里就不展开了，有兴趣的朋友，可以自行搜索了解更多。


**搜索结果中已安装的App不再显示截图**

另外，在 iOS 15 中，如果用户设备已经安装了此 app，那么搜索时，并不会显示此 app 的预览和截图，以 [‎斗罗大陆：魂师对决](https://apps.apple.com/cn/app/id1558453472) 为例：


![16266637955026.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3fd92d62347e4fcc8b729a759bba84ef~tplv-k3u1fbpfcp-watermark.image)


但是需要注意的是，app events（app 内活动）功能因为目前还没有上线，并且相关文档没有看到说明，所以目前不确认已经下载的 app 在搜索界面会不会显示 app 内活动，但从用户体验来说，应该显示才对！一起期待吧~


**解读 A/B Test**

开发者可以对 app 产品页面进行 A/B 测试，早在 2015 年的 Google Play 商店中已经有了，所以，开发者其实一直在 “催” App Store 提供原生 A/B 测试工具。而在今年 WWDC21 之前，开发者怎么进行 A/B 测试，马甲包，懂的自然懂，小编就不展开了啊。

所以，苹果到底有没有计划开发 A/B 测试呢？ Epic 诉 Apple 法庭案件中有揭示：


![16266651246320.jpg](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d9b3d8405ba44daea2dd67845cf774b8~tplv-k3u1fbpfcp-watermark.image)

答案是：2017年，足足开发了 4 年？？？

> 小编注：揭示文件下载链接(需要外网访问)：[DX-4526.pdf](https://app.box.com/s/6b9wmjvr582c95uzma1136exumk6p989/file/814311935191) 。

同样的，in app events (app 内活动功能)，Google Play 也有提供 [Events - Google Developers](https://developers.google.com/games/services/common/concepts/events)。所以，竞品之间相互学习还是很重要的啊！


最后，开发者不忘初心，通过这些功能和工具，从而帮助您改进应用。当然优化 app 产品页面是表面功夫，除了将效果最好的素材资源呈现给所有用户，还要开发者从 app 功能深入打动用户，提升 app 的整体体验才是可持续发展的方法。

欢迎大家一起在评论区交流~


> 下期预告，小编将会给大家带来《你一定不知道的 App Store 秘密》，欢迎关注我们，了解更多 iOS 和 Apple 的资讯~


### 四、参考

* [Get ready to optimize your App Store product page - WWDC 2021 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10295/)
* [增强您的产品页面 - App Store - Apple Developer](https://developer.apple.com/cn/app-store/product-page-updates/)
* [创建您的产品页面 - App Store - Apple Developer](https://developer.apple.com/cn/app-store/product-page/)
* [您在 App Store 上的 app - Apple Developer](https://developer.apple.com/cn/app-store-connect/)
* [App Store 图标、App 预览和截屏概述 - App Store Connect 帮助](https://help.apple.com/app-store-connect/?lang=zh-cn#/dev910472ff2)
* [App 预览 - App Store - Apple Developer](https://developer.apple.com/cn/app-store/app-previews/)
* [What's new in App Analytics - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10115)
* [Alternate App Icons using Asset Catalogs in Xcode 13 | by Terrence Katzenbaer | Jun, 2021 | Medium](https://katzenbaer.medium.com/alternate-app-icons-using-asset-catalogs-in-xcode-13-da6387d1cd78)
* [How to change your app icon dynamically with setAlternateIconName() - free Swift 5.4 example code and tips](https://www.hackingwithswift.com/example-code/uikit/how-to-change-your-app-icon-dynamically-with-setalternateiconname)
* [jknlsn/XCode13-Alternate-App-Icons: Simple alternate app icons with Xcode 13 and SwiftUI](https://github.com/jknlsn/XCode13-Alternate-App-Icons)
* [How to test a variation of your app icon | Apple Developer Forums](https://developer.apple.com/forums/thread/685321)
* [Meet in-app events on the App Store - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10171)
* [Apple Search Ads](https://searchads.apple.com/cn/)
* [All the App Store Optimization News From WWDC 2021 You Need to Know: A/B Testing Tool, Custom Product Pages, and In-App Events in iOS15 - Phiture - Mobile Growth Consultancy and Agency](https://phiture.com/asostack/all-the-app-store-optimization-news-from-wwdc-2021-you-need-to-know-a-b-testing-tool-custom-product-pages-and-in-app-events-in-ios15/)
* [Firebase A/B Testing](https://firebase.google.com/docs/ab-testing?hl=zh-cn)
* [对商品详情进行 A/B 测试 - Play 管理中心帮助](https://support.google.com/googleplay/android-developer/answer/6227309?hl=zh-Hans)
* [添加预览资产以展示您的应用 - Play 管理中心帮助](https://support.google.com/googleplay/android-developer/answer/9866151?hl=zh-Hans)
* [利用发布前测试报告和 Firebase 功能改进应用 - Google Play](https://developer.android.com/distribute/best-practices/launch/pre-launch-crash-reports)
* [利用商品详情实验将访问量转化为安装量 - Google Play](https://developer.android.com/distribute/best-practices/grow/store-listing-experiments)
* [创建和设置应用 - Play 管理中心帮助](https://support.google.com/googleplay/android-developer/answer/9859152)
* [WWDC开幕第一天，苹果App Store就爆出了这些重大更新！新流量入口、A/B测试…你没想到的都在这里！](https://mp.weixin.qq.com/s/suOZedHQEuIiXRKX3P5AQw)
* [Practical ASO Guide: How to Optimize your App Store Product Page? - ASO Blog](https://www.apptweak.com/en/aso-blog/practical-aso-guide-how-to-optimize-your-app-store-product-page)
* [App Store Optimization Tips (2021): A Step-by-step ASO Guide for iOS & Google Play Apps – App Store Optimization](https://www.meatti.com/blog/app-store-optimization-tips/)
* [App Store Product Page Design Guidelines](https://www.storemaven.com/academy/how-to-design-app-store-product-page/)

