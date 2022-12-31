title: 用 SwiftUI 实现一个开源的 App Store
date: 2022-01-10 17:50:16
categories: technology #induction life poetry
tags: [iOS,SwiftUI,App Store]  # <!--more-->
reward: true

---

> 本文首发于 [用 SwiftUI 实现一个开源的 App Store - 掘金](https://juejin.cn/post/7051512478630412301)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

> App Store 在 iOS 11 之前，App 排行榜一直是衡量开发者 App 活跃度的指标，但在 iOS 11 后苹果弱化了榜单功能，改为了二级入口，导致查询榜单困难，编者通过深入调研最终实现了一个查看 App 榜单、搜索、信息、发布生效等强大功能的开源 App。

<!--more-->

![iAppStore-00](https://ihtcboy.com/images/2022-iAppStore-00.png)

### 一、前言

App Store 一直以来都是 iPhone 生态的最重要一环，在初代 iPhone 商店，因为 App 比较少，当时就有 `Top 25` 榜单：

![iAppStore-01](https://ihtcboy.com/images/2022-iAppStore-01.jpg)

然后在后续的 App Store 迭代中，排行榜（`Top Charts`）一直是一个主要的入口，新用户基本都会从榜单下载 App，所以，榜单的重要性不容忽视。

![iAppStore-02](https://ihtcboy.com/images/2022-iAppStore-02.jpg)

直到 2017 年，虽然占了不到 30% 的手机份额，但 iPhone 的体量已经非常大，App Store 应用数量已经达到 220 万。App Store 的展示和推荐，显然满足不了每天巨大的新 App，有越来越多的 App 希望得到关注；而另一方面，排行榜刷榜问题一直存在；还有就是 App Store 的设计已经满足不了需求！比如更新（`Updates`） 标签功能单一，就是负责显示需要更新的 App 列表。

所以，从 iOS 11 开始，苹果将 AppStore 重新设计，增加了 Today 和 Games 游戏标签入口，而排行榜列表放到了 Apps 标签的二级入口中。苹果加强了自己的编辑团队推荐的App，在游戏和应用标签分类的前面也加入了大区域的编辑推荐 App，如今已经看不到榜单了。

![iAppStore-03](https://ihtcboy.com/images/2022-iAppStore-03.jpg)

而现在 iOS 15 中的 App Store 增加了更多的功能，比如产品页优化、自定产品页、App 内活动（In-App Events）等，目的很明显就是让开发者增加活跃内容，提升 App 日活和收入。

而排行榜功能，其实已经不单单是一个榜单的作用，经常这些年的沉淀，榜单基本已经稳定。比如大家看到的 App，常年不变，而冲到榜单的 App，会获得更多的下载量。**对于开发者来说**，榜单可以用来预测应用收入、使用量和下载量的一个重要指标。**对于用户来说**，发现一些有趣或者热门的 App，依然是部分老用户的习惯。

所以，编者希望通过实现一个 App Store 排行榜，方便日常查看，同时查看信息，搜索或应用发布状态订阅等功能，解决了非常多的痛点问题。


### 二、效果展示


首先，我们先来介绍一下，目前 iAppStore 实现了那些功能。

> [iAppStroe](https://github.com/37iOS/iAppStore-SwiftUI) 是一款使用 **SwiftUI** 打造的苹果商店工具类 App。

1. 提供苹果实时榜单查询，包含 iOS 和 iPad 的热门免费榜、热门付费榜、畅销榜，还有新上架榜、新上架免费榜、新上架付费榜等。
2. 提供查询 app 详细页面内容、搜索 app、订阅 app 状态等功能。
3. 支持苹果所有国家和地区的商店，无需切换 Apple Id，即可查看！


#### 2.1 排行榜

首先，App Store 的榜单有很多，包含 iOS 和 iPad 的热门免费榜、热门付费榜、畅销榜，还有新上架榜、新上架免费榜、新上架付费榜等，我们都实现了这些榜单。另外，我们将 App Store 榜单的 UI 还原，同时，也增加了更多的信息展示，比如 App 所属分类等。

![iAppStore-04](https://ihtcboy.com/images/2022-iAppStore-04.jpg)

最重要的是，我们把所有国家和地区的商店，都集成在一个面板中，通过下拉列表选择，实现快速切换榜单。


#### 2.2 App 详细页

App 详细页面，把开发者最关心的参数显示在最前面。另外，复制包含或者 App ID 是一个高频的需求，App 描述和更新方案也高仿了 App Store 的效果。预览区包含 iPhone 和 iPad 图片。点击可以显示大图，并且可以下载和分享大图。

![iAppStore-05](https://ihtcboy.com/images/2022-iAppStore-05.jpg)



#### 2.3 搜索

搜索区，可以输入`关键字`模糊搜索，或者 `App ID`精准搜索。另外，在右上角切换国家和地区，显示不同地区的 App 搜索。

![iAppStore-06](https://ihtcboy.com/images/2022-iAppStore-06.jpg)


#### 2.4 应用状态订阅

这个状态订阅是什么意思？就是可以监听 App 在商店的状态，举例来说，App 发布了新版本，那么大概要多久才能在商店上显示呢？所以，我们可以通过苹果的接口，来定时的查询 App 的状态，从而知道 App 什么时候生效。还有新 App 刚刚发布时、或者 App 需要下架了，什么时候才从商店消失等。

![iAppStore-07](https://ihtcboy.com/images/2022-iAppStore-07.jpg)



#### 2.5 其它

为了方便开发者使用，App 列表长按时，会弹出操作列表，可以已经复制 App 的信息或者快速打开 App Store 产品页，尽可能的快捷获取内容！另外，还支持暗黑模式，依然精美绝伦！切换图标可以选择自己显示的图标等。

![iAppStore-08](https://ihtcboy.com/images/2022-iAppStore-08.jpg)


大家想要什么功能，可以在评论区留言啊~


### 三、调研工作

接下来，我们说一下要实现以上功能，需要的 API 怎么调研出来的！通过大量的网页检索，最终测试后整理成有价值的列表：

#### 3.1 榜单接口
**查询排行榜的 API 示例**

| 链接示例 | 链接说明 | 参考链接 |
|---|---|---|
| `https://rss.applemarketingtools.com/api/v2/cn/apps/top-free/100/apps.json` | 苹果官方提供的接口，除了 App 榜单，还支持苹果自家的 Music、Books、Podcasts 产品的榜单，目前提供前 200 条数据。 | [RSS Builder](https://rss.applemarketingtools.com/) |
| `http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topfreeapplications/limit=100/json?cc=cn` | Apple RSS Feeds，苹果旧的 RSS接口，目前提供前 100 条数据。 | [RSS Information](https://www.apple.com/rss/) |
| `https://itunes.apple.com/cn/rss/topfreeapplications/limit=100/json` | 苹果榜单查询接口，目前提供前 100 条数据。 | [Stack Overflow](https://stackoverflow.com/questions/29997991/how-to-get-top-400-lists-from-itunes) |
| `https://itunes.apple.com/rss/topGrossingApplications/limit=100/json?cc=cn` |  苹果榜单查询接口，目前提供前 100 条数据。把地区语言放到单独成一个字段。 | [链接](https://www.kalman03.com/2015/05/04/tech/appstore_affiliates_resource/) |

以上内容在苹果公开的文档，都没有查询到 API 文档。但为苹果网站到在一个页面：
[Apple Services Performance Partners](https://affiliate.itunes.apple.com/resources/)，其中一项服务叫：[Enterprise Partner Feed Relational](https://affiliate.itunes.apple.com/resources/documentation/itunes-enterprise-partner-feed/)（企业信息流合作伙伴？），目前这个合作好像很难申请到。所以，相关的文档链接都无法访问到，比如 [https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api.html](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api.html)。

那么以上链接中几个参数类型，因为没有文档，所以调研梳理如下：

**榜单类型**

| 字段 | 英文说明 | 解析 |
|---|---|---|
| topFreeApplications | Top Free Applications | 热门免费应用 |
| topPaidApplications | Top Paid Applications | 热门付费应用 |
| topGrossingApplications | Top Grossing Applications | 畅销榜(收入最高) |
| newApplications | New Applications | 新应用 |
| newFreeApplications | New Free Applications | 新的免费应用 |
| newPaidApplications | New Paid Applications | 新的付费应用 |
| topFreeiPadApplications | Top Free iPad Applications | 热门免费 iPad 应用 |
| topPaidiPadApplications | Top Paid iPad Applications  | 热门付费 iPad 应用 |
| topGrossingiPadApplications | Top Grossing iPad Applications | 最畅销的 iPad 应用 |


**应用分类**

| 分类 ID | 英文说明 | 解析 |
|---|---|---|
| 6000 | Business | 商务 |
| 6001 |  Weather | 天气 |  
| 6002 |  Utilities | 工具 |
| 6003 |  Travel | 旅游 |
| 6004 |  Sports | 体育 |
| 6005 |  Social Networking | 社交
| 6006 |  Reference | 参考资料 |
| 6007 |  Productivity | 效率 |
| 6008 |  Photo & Video | 摄影与录像 |
| 6009 |  News | 新闻，中国区无数据⚠️  |
| 6010 |  Navigation | 导航 | 
| 6011 |  Music | 音乐 | 
| 6012 |  Lifestyle | 生活 | 
| 6013 |  Health & Fitness | 健康健美 | 
| 6014 |  Games | 游戏 | 
| 6015 |  Finance | 财务 | 
| 6016 |  Entertainment | 娱乐 | 
| 6017 |  Education | 教育 | 
| 6018 |  Books | 图书 |
| 6019 |  Places & Objects | 地点与物品，字段已无效⚠️ |
| 6020 |  Medical | 医疗 | 
| 6021 |  Newsstand | 报刊杂志 |
| 6022 |  Catalogs | 商品指南，字段已无效⚠️ |
| 6023 |  Food & Drink | 美食佳饮 | 
| 6024 |  Shopping | 购物 |
| 6025 |  Stickers | iMessage 贴纸，字段已无效⚠️ |
| 6026 |  Developer_Tools | 软件开发工具 |
| 6027 |  Graphics_And_Design | 图形和设计 |

> 更多分类，参考苹果网站的 HTML 标签：[App Store](https://apps.apple.com/cn/genre/ios/id36)


**国家或地区标识**

| ID | 英文说明 | 解析 |
|---|---|---|
| cn | China mainland | 中国 | 
| hk | Hong Kong| 中国香港 | 
| tw | Taiwan | 中国台湾 | 
| mo | Macao | 中国澳门 | 
| us | United States| 美国 | 
| jp | Japan| 日本 | 
| kr | Korea, Republic of| 韩国  | 

> 更多分类标识，参考苹果网站的 HTML 标签：[RSS Builder](https://rss.applemarketingtools.com/)

**接口说明**

原本接口提供 200 条数据查询，但 20221 年 9 月 2 日，苹果接口调整后，大幅削减 App Store 应用排行数据分享，从 1500 名降至 200 名。目前 AppStore 总榜、应用、游戏榜、分类榜只能查看前 200 个 App 的数据。


#### 3.2 搜索接口

App 搜索接口比如简单，并且有官方文档：

* [iTunes Store API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/)
* [iTunes Search API: Constructing Searches](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1)


**接口示例：**

```
https://itunes.apple.com/search?term=斗罗大陆&country=cn&limit=200&entity=software
```

`term` 字段就是关键词，`country` 字段是国家或地区的标签，跟上面的榜单接口是同一个。`entity=software` 固定为搜索软件就好。详细的使用，可以参考官方文档，这里就不展开了。


#### 3.3 App 详细信息

查询某个 App 可以使用 `lookup` 接口，具体可以查看官网文档：[Lookup Examples](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/LookupExamples.html#//apple_ref/doc/uid/TP40017632-CH7-SW1)。


**接口示例：**
```
https://itunes.apple.com/cn/lookup?id=1558453472
```


#### 3.4 App 评论内容

查询某个 App 的用户评论内容，没有在苹果的文档中找到，但是根据以上的调研，接口使用问题不大。


**接口示例：**
```
https://itunes.apple.com/cn/rss/customerreviews/id=989673964/sortBy=mostRecent/json
```

地区、App Id、`sortBy` 字段，就可以搜索。如果需要分页或者获取更多，可以参考文末的链接。


### 四、开发思路

有了以上的 API 接口，就能实现我们的 App，这样使用 SwiftUI 来构建，现已开源：

* [iAppStore - GitHub](https://github.com/37iOS/iAppStore-SwiftUI)

详细的实践过程就不在这样讲解了，因为 App 是工具类应用，交互的内容不多，所以并不是很复杂。当然，使用 SwiftUI 构建 UI 过程异常的快速，但是如果要调整 UI 细节，确定需要花很多心思。比如，SwiftUI 还不支持 WebView，所以用 SFSafariViewController 桥接的 View 在 SwiftUI 组件中显示会异常。

* [How do I use SFSafariViewController with SwiftUI? - Stack Overflow](https://stackoverflow.com/questions/56518029/how-do-i-use-sfsafariviewcontroller-with-swiftui)

另外，就是苹果 API 的坑，接口返回的字段 `im:id`、`im:bundleId`，包含冒号，让人怀疑人生！最后，通过自定义键值名，解决了解析映射的问题。详细，可以参考源代码中 [AppRank.swift](https://github.com/37iOS/iAppStore-SwiftUI/blob/main/iAppStore/Models/AppRank.swift) 类。

```swift
struct IDAttributes: Codable {
    let imBundleID, imID: String
    
    // 自定义键值名
     enum CodingKeys: String, CodingKey {
        case imID = "im:id"
        case imBundleID = "im:bundleId"
    }
}
```

综上，如果是个人开发的 App，可以开始使用 SwiftUI 来开发，毕竟原生的体验和原生的组件，用户起来也很快乐。另外，不考虑支持低版本系统，使用 [SF Symbols](https://developer.apple.com/sf-symbols/) 提供的图标，也非常的友好！


### 五、总结

iAppStore 从构思到实现，花了半个月的时间，期间调研接口和调试接口花了很多时间，网上依然看到很多人问这些接口，相信很多开发者都不知道有这些接口，所以本文也算是一个答案总结，希望这个问题从此消失哈~ 

最后，iAppStore 只是从编者需求来实现的一个产品，所以一定存在很多的问题，但同时它是一个开源项目，所以，如果大家有兴趣，一起来参与，增加更多有趣或者黑科技的体验吧！

欢迎大家有任何想法或者建议，可以在评论区给我们反馈。也可以到 [iAppStore - GitHub](https://github.com/37iOS/iAppStore-SwiftUI) 给我们 Star 鼓励！感谢大家~


欢迎大家在评论区一起交流~

> 欢迎关注我们，了解更多 iOS 和 Apple 的动态~



### 六、参考

- [app store - How to get top 400 lists from iTunes - Stack Overflow](https://stackoverflow.com/questions/29997991/how-to-get-top-400-lists-from-itunes)
- [web services - How can I use Appstore API to get top100 list? What is the common architecture to build a appstore application website? - Stack Overflow](https://stackoverflow.com/questions/1801182/how-can-i-use-appstore-api-to-get-top100-list-what-is-the-common-architecture-t)
- [如何查询某个app在appstore特定关键词搜索下的排名？ - 知乎](https://www.zhihu.com/question/29427568/answer/261315466)
- [AppStore应用排行榜、应用获取接口 | 安琪琪](https://www.kalman03.com/2015/05/04/tech/appstore_affiliates_resource/)
- [iTunes Enterprise Partner Feed](https://affiliate.itunes.apple.com/resources/documentation/itunes-enterprise-partner-feed/)
- [RSS Builder](https://rss.applemarketingtools.com/)
- [RSS Information - Apple](https://www.apple.com/rss/)
- [RSS for Top Movies got no results - Apple Community](https://discussions.apple.com/thread/252568207)
- [Module: StoreApi::AppStore — Documentation for store_api (0.2.2)](https://www.rubydoc.info/gems/store_api/0.2.2/StoreApi/AppStore)
- [苹果大幅削减 App Store 应用排行数据分享，从 1500 名降至 200 名 - IT之家](https://www.ithome.com/0/576/011.htm )
- [从 iTunes 下载的 App Store](https://apps.apple.com/cn/genre/ios/id36)
- [iTunes Store API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/)
- [iTunes Search API: Constructing Searches](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1)
- [iTunes Search API: Lookup Examples](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/LookupExamples.html#//apple_ref/doc/uid/TP40017632-CH7-SW1)
- [Analysis of PodCruncher App Ratings and Reviews on iTunes](https://rstudio-pubs-static.s3.amazonaws.com/267315_46f1f9b894014a588e4a65e3fe4926ff.html)
- [监听 iOS App 新评论 · Bell's blog](https://greedlab.com/blog/apple/rss-app-reviews.html)
- [Marketing Tools and Resources - Apple Services](https://tools.applemediaservices.com/)
- [37iOS/iAppStore-SwiftUI - GitHub](https://github.com/37iOS/iAppStore-SwiftUI)
- [ios - How do I use SFSafariViewController with SwiftUI? - Stack Overflow](https://stackoverflow.com/questions/56518029/how-do-i-use-sfsafariviewcontroller-with-swiftui)
- [SF Symbols - Apple Developer](https://developer.apple.com/sf-symbols/)