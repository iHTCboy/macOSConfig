title: iOS Handle Refunds 处理退款 --- WWDC20（Session 10661）
date: 2020-07-01 22:40:16
categories: technology #induction life poetry
tags: [WWDC,IAP,Refund]  # <!--more-->
reward: true

---


### 1、前言
今年 WWDC 2020 苹果全球开发者大会，苹果宣布所有的内购品项类型，当用户退款成功时，开发者都能收到退款通知！！！退款通知！！！退款通知！！！

> **针对 App 内购买项目的退款通知现已可用**
> 
> 2020 年 06 月 24 日
> App Store 服务器通知现在包含所有类型的 App 内购买项目的退款通知 (包括消耗型项目、非消耗型项目和非续期订阅)。这些信息能帮助您采取相应的行动，并告知他们相关的优惠更改，以及如何重新订阅。
> 
> [针对 App 内购买项目的退款通知现已可用 - 新闻 - Apple Developer](https://developer.apple.com/cn/news/?id=tv3bhra6)

<!--more-->

### 2、处理退款

#### 2.1 退款流程

在 2020 年 06 月 24 日之前，开发者完全不知道有用户退款了！（只有每月账单里看到退款的一个总数量 -。-）：

![IAP_2020before.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_IAP_2020before.png)


2020 年 06 月 24 日开始，苹果新增流程：

![IAP_2020after.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_IAP_2020after.png)


#### 2.2 退款通知
在苹果后台可以配置一个退款通知的回调地址（一个App配置一条链接）：

![URL_for_AppStore_Server_Notifications.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_URL_for_AppStore_Server_Notifications.png)


配置的回调链接必须满足条件：

* 满足应用传输安全要求（使用 `https`）
* URL 最长 255 字符


> 注意：这里的 `https` 是指苹果的 App Transport Security (ATS)，其中有协议的要求，比如使用 Transport Layer Security (TLS) protocol 1.2 版本，具体见苹果文档： [Preventing Insecure Network Connections | Apple Developer Documentation](https://developer.apple.com/documentation/security/preventing_insecure_network_connections)。


#### 2.3 退款通知的类型

苹果把回调的通知分为2种类型： 
* **退款通知**类型
* **取消通知**类型  

其中新增加的`退款通知`类型是针对：
* 消耗型
* 非消耗型
* 非续期订阅

`取消通知`类型是针对：
* 自动续期订阅

![Server-Server_REFUND_notification.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_Server-Server_REFUND_notification.png)


 
#### 2.4 退款通知的内容
 苹果返回的通知内容为 JSON 对象数据，所有的退款订单的通知是在 `unified_receipt` 里的 `latest_receipt_info` 数组中：
 
![REFUND_Notification_payload.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_REFUND_Notification_payload.png)
 
 
|  字段 | 说明  |
|---|---|
| environment |  收据生成的环境。values: `Sandbox`, `PROD`。自动续订订阅是可以沙盒环境测试取消订阅。 |
| latest_receipt  | Base64编码的最新交易收据。 |
| latest_receipt_info  | 收据的列表  |
|  notification_type | 通知类型，退款的值应该是：`REFUND`， 可参考：[notification_type](https://developer.apple.com/documentation/appstoreservernotifications/notification_type)  |
|  password | 验证收据时的 password，App 专用共享密钥是用于接收此 App 自动续订订阅收据的唯一代码。如果您需要将此 App 转让给其他开发者，或者需要将主共享密钥设置为专用，可能需要使用 App 专用共享密钥。  |
| bid  | App的 bundle id（包名） |
| bvrs | App的版本号  |
| unified_receipt | `退款的订单信息在这里` |

在 `unified_receipt` 里的 `latest_receipt_info` 是一个数组，其中包含的最近的100次应用内购买交易：

![latest_receipt_info_array.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_latest_receipt_info_array.png)


数据中每个退款订单的主要字段：

![REFUND_Field_Type.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_REFUND_Field_Type.png)


|  字段 | 说明 |
|---|---|
| original_transaction_id |  苹果订单的唯一标识 transaction_id |
| cancellation_data_ms  | 退款的时间 |
| cancellation_reason | 用户退款的原因。（0或1，含义未知） |
|  bid |  应用包名 bundle id |
|  product_id | 商品唯一标识 id |


详细的返回字段见官方文档：
* [responseBody | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications/responsebody)
* [unified_receipt | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications/unified_receipt)
* [responseBody.Latest_receipt_info | Apple Developer Documentation](https://developer.apple.com/documentation/appstorereceipts/responsebody/latest_receipt_info)


#### 2.5 退款通知的响应

您的服务器应发送HTTP状态代码，以指示服务器到服务器的通知接收是否成功：
* 如果回调接收成功，则发送 HTTP `200`。您的服务器不需要返回数据。
* 如果回调接收不成功，请发送 HTTP `50x` 或 `40x` 让 App Store 重试该通知。App Store在一段时间内尝试重试该通知，但在连续失败尝试后最终停止(`3次`）。

注意事项：
* 当您使用包含退款交易的收据 `transaction_data` 向苹果服务器校验 [verifyReceipt](https://developer.apple.com/documentation/appstorereceipts/verifyreceipt)  时，JSON响应中不存在退款交易，自动续订订阅除外。
* 收到 `REFUND` 通知时，您有责任为每笔退款交易存储，监控并采取适当的措施。（因为苹果只通知一次，暂时无法在苹果后台查询退款的订单。也不能由开发者主动去苹果服务器查询。）


#### 2.6 自动续订订阅通知
这个取消通知之前就一直有，所以这里不重复了，需要的自行搜索。

自动续订订阅的相关文档：
- [Handling Subscriptions Billing | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/subscriptions_and_offers/handling_subscriptions_billing#3221919)
- [In-App Purchases and Using Server-to-Server Notifications - WWDC 2019 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/302)
- [Subscription Offers Best Practices - WWDC 2019 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/305)


### 疑问解答
1、 苹果后台能否查看到退款的订单详情？
> 答：暂无。（估计明年 WWDC2021 会有啦？）

2、 消耗型、非消耗型、非续期订阅能不能在沙盒环境测试退款？
> 答：暂时不能。（估计未来会有？等更新吧....）


### 总结

大概就是这样，其实退款的流程并不复杂，很简单，但是为什么苹果用了那么多年才做出来呢？

要知道这个原因，还是要回顾一下历史~

#### 退款的方式

用户可以通过那些方式申请退款：
* 联系Apple客户支持并要求退款
* 登录并使用Apple的自助服务工具 [reportaproblem.apple.com](https://reportaproblem.apple.com/) 要求退款
* 要求他们的付款方式发行人退款 *（比如要求银行取消扣费，或者黑卡无法扣费等）*

详细：[针对从 Apple 购买的 App 或内容申请退款 - Apple 支持](https://support.apple.com/zh-cn/HT204084)


#### 退款的政策

针对退款，不同国家或地区会有不同的“无条件退款期限”。

AppStore 商店退款政策：
* **欧盟区**： 14天`无条件`退款。
* **中国台湾**：7天`无条件`退款。
* **中国/美国/韩国**等其它大多数国家：90天`有条件`退款。 *（注：在中国区，每位App Store用户能享有一次无条件退款机会）*

注：中国区 App Store 的具体退款政策：一个ID有一次无条件退款机会，一年2次有条件退款，第3次退款会非常难。至于退款到账时间快为36小时内，也有7-15个工作日退还。

正是这些“漏洞”，所以，出现专业的代充工作室，导致开发者坏帐非常严重~ 

特别是火爆的游戏代充（月流水（千万级）的12%可能就这样没了）~

**很多不熟悉的朋友不太理解，总会问有那么多人退款吗？**

其实，应用内购买的退款主要是针对游戏和直播打赏。游戏类的多是代充黑产；主播自己刷火箭打赏然后退款，收入照收，各种黑幕，只有业内人才懂的苦 -。-


#### “退款”滥用
“退款”人的具体手段方式：

* 1、利用淘宝店，以代充打折的名义获取玩家账号信息，在为玩家充值后申请退款。淘宝店获得充值金、玩家获得道具、游戏厂商亏钱；
* 2、收购消费过的App Store ID账号，要求至少要消费过500元以上。收到的账号会被用来退款和冲榜；
* 3、不断寻找有退款需求的新用户，帮其退款，收取佣金；


#### 退款通知的意义

![Refund_management.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_Refund_management.png)

* 允许您对应用内内容的可访问管理  *（例如游戏的宝石或金币回收或账户余额扣减等）*
* 管理退款滥用
* 快速解决用户问题 *（发现用户退款后，可以在应用内弹出联系客服，协助用户解决应用遇到的退款原因的问题？）*
* 重新平衡游戏经济


#### 处罚行动

一旦收到有关客户获得应用内购买退款的推送通知，作为开发人员，您可以采取七种不同的操作，从中等到严重（温和处理到严肃处理）。：

![Potential_actions.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_Potential_actions.png)

苹果旨在为客户和开发人员提供更好的体验，所以建议操作要慎重考虑。


#### 对退款用户的处理

![Refund_Update_action.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/07/01_Refund_Update_action.png)

苹果给了一个示例，用户退款成功后，**在 App 中给用户提示退款的时间和说明，可以重新购买，或者联系客服！**

也许帮助需要帮助的用户，为他们解决为什么退款的原因，才能减少真正的退款用户，用户觉得值！那么退款数自然会减少~

所以，苹果当初为什么不愿意提供退款的接口？其实是一直想保护用户的隐私（退款自由），但是当“退款”滥用时，不得不这样提供了退款通知接口。

这正是我们所看到的，苹果想的，你怎么想！怎么做！想好在决定~

<br>
<br>

> ps：题外话，大家一直觉得苹果的应用内购买做的很“烂”，是因为大家不太了解，苹果的这套支付系统有多复杂。可以打开下面的链接看看不同国家或地区的付款方式，要在一个应用里集成这些付款方式，不是一个支付宝或微信能想象到的。了解了才知道，唯有多学习：[可与 Apple ID 搭配使用的付款方式 - Apple 支持](https://support.apple.com/zh-cn/HT202631)


### 参考
* [针对 App 内购买项目的退款通知现已可用 - 新闻 - Apple Developer](https://developer.apple.com/cn/news/?id=tv3bhra6)
* [What’s new with in-app purchase - WWDC 2020 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10661/)
* [Handling Refund Notifications | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/handling_refund_notifications?language=objc)
* [Enabling Server-to-Server Notifications | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/subscriptions_and_offers/enabling_server-to-server_notifications)
* [Handling Subscriptions Billing | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/subscriptions_and_offers/handling_subscriptions_billing#3221919)
* [App Store Server Notifications | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications)
* [In-App Purchases and Using Server-to-Server Notifications - WWDC 2019 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/302)
* [Subscription Offers Best Practices - WWDC 2019 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2019/305)

<br>

- 如有侵权，联系必删！
- 如有不正确的地方，欢迎指导！
- 如有疑问，欢迎在评论区一起讨论！

<br>

> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源。

<br>

