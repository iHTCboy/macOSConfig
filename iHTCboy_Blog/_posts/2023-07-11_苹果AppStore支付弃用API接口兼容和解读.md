title: 苹果 App Store 支付弃用 API 接口兼容和解读 - 2023
date: 2023-07-11 20:16:23
categories: technology #induction life poetry
tags: [App Store,App Store Connect API]  # <!--more-->
reward: true

---

> 本文首发于 [苹果 App Store 支付弃用 API 接口兼容和解读 - 掘金](https://juejin.cn/post/7254373662455185469)，欢迎关注我们 [@37手游移动客户端团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

> 摘要：本文介绍了苹果在 WWDC23 上宣布的对服务端的 2 个 API 弃用，包括verifyReceipt API和App Store Server Notifications V1。同时，本文还提供了相应的兼容迁移建议，包括从 verifyReceipt API 改为 Get Transaction Info API等。此外，本文还介绍了receiptData 旧收据伪造问题和苹果新推出的 App Store Server Library 工具包。


<!--more-->

![WWDC23-AppStore-DeprecatedAPI-00](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-00.png)


# 一、**背景**

苹果在今年 WWDC23 宣布对服务端的2个 API Deprecated（已弃用），意思是API 后续不会有更新和维护，目前还可以用，但未来某天可能会完成不可调用。所以，现在开始需要做兼容和迁移的工作。

![WWDC23-AppStore-DeprecatedAPI-01](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-01.png)

> 参考：[What’s new in App Store server APIs - WWDC23 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2023/10141/)

# 二、**verifyReceipt API 弃用和兼容迁移**

## **2.1 iOS 支付 API 逻辑**

目前苹果有2套内购支付的  API：

- **StoreKit Original API：**：目前支付所有 iOS 系统，还没有弃用。
- **StoreKit v2**：2021年推出，只支持 iOS 15 以上系统

通过这2个版本的支付 API，支付成功的凭证格式不同：

- **StoreKit Original API**：支付凭证格式叫 receipt-data，是 Base64编码的加密内容，需要通过苹果 [verifyReceipt API](https://developer.apple.com/documentation/appstorereceipts/verifyreceipt) 解析出收据信息来校验合法性。
- **StoreKit v2**：支付凭证是 JWS 签名格式，不需要请求苹果 API 校验，开发者可以本地自行校验合法性（验证签名证书链是苹果的证书）。

## **2.2 verifyReceipt API 弃用**

现在弃用的 verifyReceipt API，就是通过 receipt-data 支付凭证内容校验的接口。

![WWDC23-AppStore-DeprecatedAPI-02](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-02.png)
> 参考：[verifyReceipt | Apple Developer Documentation](https://developer.apple.com/documentation/appstorereceipts/verifyreceipt)

**提示：** 虽然苹果宣布弃用 verifyReceipt API，但 StoreKit Original API 并没有弃用，并且在 visionOS 中还支持：

![WWDC23-AppStore-DeprecatedAPI-03](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-03.png)
> 参考：[SKPayment | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skpayment)

**所以：**
笔者预计未来2~3年内，仍然有大部的 App 使用 StoreKit Original API，导致苹果不会删除相关的 API 和后端验证 verifyReceipt API。**但建议开发者，现在开始考虑迁移到新的  API。**

## **2.3 verifyReceipt 兼容迁移**

苹果给的迁移和兼容的建议：

> 参考：[Meet the App Store Server Library  - WWDC23 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2023/10143/) 

![WWDC23-AppStore-DeprecatedAPI-04](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-04.png)

![WWDC23-AppStore-DeprecatedAPI-05](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-05.png)

苹果建议开发者，从 verifyReceipt API 改为  [Get Transaction History | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history) API。

> 有关 Get Transaction History API，可以参考我们之前的文章：[WWDC21 - App Store Server API 实践总结 - 掘金](https://juejin.cn/post/7056976669139009573#heading-14)

**API 查询到交易历史记录返回结果只支持以下情况：**

- 自动续期订阅
- 非续订订阅
- 非消耗型应用内购买项目
- 消耗型应用内购买项目：如果交易被退款、撤销或 app 尚未完成交易处理等。

所以，如果使用这个 API 校验交易订单号（transactionId），可能需要注意，如果客户端已经调用苹果 [finish() | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/transaction/3749694-finish) 或[finishTransaction(_:) | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506003-finishtransaction) API 后，查询 Get Transaction History API 会返回 404 Not Found。

今年苹果 WWDC23 新提供的 API，可以查询某个 transactionId 收据信息，包体finish的消耗型商品。

- [Get Transaction Info | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_info)

![WWDC23-AppStore-DeprecatedAPI-06](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-06.png)

> 参考：[What’s new in App Store server APIs - WWDC23 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2023/10141/)

# 三、**App Store Server Notifications V1 已弃用**

App Store Server Notifications V1 和 V2 通知，是 App Store 服务器主动通知开发者服务器的 API。比如退款通知、订阅商品续费成功通知等。

目前苹果已经弃用 V1 版本的  API：
![WWDC23-AppStore-DeprecatedAPI-07](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-07.png)
> 参考：[App Store Server Notifications V1 | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications/app_store_server_notifications_v1)

**V1 和 V2 的主要区别：**

- V1 版本：响应内容是 JSON 格式的数据。
- V2 版本：响应内容是由 App Store 签名的JSON Web签名（JWS）格式。

V2 支持更多的通知类型：
![WWDC23-AppStore-DeprecatedAPI-08](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-08.png)

V2 重试更多：

- App Store Server Notifications V1：重试三次；在上次尝试后 6、24 和 48 小时。
- App Store Server Notifications V2：重试五次；在上次尝试后 1、12、24、48 和 72 小时。

![WWDC23-AppStore-DeprecatedAPI-09](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-09.png)

V2 JWS 格式中的 payload 解析：

![WWDC23-AppStore-DeprecatedAPI-10](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-10.png)

> 关于 App Store Server Notifications V2 更新内容，可以参考我们之前的文章： 
> - [WWDC22 - 掘金](https://juejin.cn/post/7118958291446661134#heading-13)
> - [WWDC21 - 掘金](https://juejin.cn/post/6974733392260644895#heading-16)

**相关官方文档：**

- V1:[App Store Server Notifications V1 | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications/app_store_server_notifications_v1)
- V2:  [App Store Server Notifications V2 | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications/app_store_server_notifications_v2)

# 四、**receiptData 旧收据伪造问题**

![WWDC23-AppStore-DeprecatedAPI-11](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-11.png)

对于 **StoreKit Original API 获取的** receiptData 凭证，苹果在客户端有 2 个 API ：

- iOS 7 之前：[transactionReceipt | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skpaymenttransaction/1617722-transactionreceipt) （已弃用）
- iOS 7 以上：[appStoreReceiptURL | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/bundle/1407276-appstorereceipturl)

**格式区别：** 这 2 个 API 获取的 receiptData 凭证，经过苹果  verifyReceipt API  解析后的格式是不同的。

**问题：** 目前发现， iOS 7 之前的旧凭证 API，黑产能伪造票据中的 Bundle ID ！

**目前不能伪造的字段：**

- app_item_id：app id，app 在苹果商店的唯一标识
- item_id：商品 id，内购商店在苹果商店的唯一标识
- transaction_id：交易 id，苹果的凭证收据的唯一标识（苹果订单号）

**建议：**

1. 服务端要校验以上3个不能**不能伪造的字段。**
2. 通过 Apple Store Server API 是查询 transaction_id 做二次校验。
3. 如果 app 本身是通过新票据  API 获取，服务端可以直接拒绝旧票据的交易。

> 提示：苹果对旧凭证收据更新了 SHA-256 加密算法：
> [即将推出的 AppStore 收据签名媒介证书相关更新 - 最新动态 - Apple Developer](https://developer.apple.com/cn/news/?id=smofnyhj)
> ![WWDC23-AppStore-DeprecatedAPI-12](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-12.png)


# 五、**App Store Server Library**

针对上述的 App Store 校验，苹果现在推出官方的服务器工具包(库)，减少开发者接入难度和成本，同时也避免校验漏洞等问题。

![WWDC23-AppStore-DeprecatedAPI-13](https://ihtcboy.com/images/WWDC23-AppStore-DeprecatedAPI-13.png)

> 参考：[Meet the App Store Server Library  - WWDC23 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2023/10143/)

- Java 版本：[https://github.com/apple/app-store-server-library-java](https://github.com/apple/app-store-server-library-java)
- Swift 版本：[GitHub - apple/app-store-server-library-swift](https://github.com/apple/app-store-server-library-swift)
- Python 版本：[https://github.com/apple/app-store-server-library-python](https://github.com/apple/app-store-server-library-python)
- Node.js 版本: [GitHub - apple/app-store-server-library-node](https://github.com/apple/app-store-server-library-node)


# 六、**总结**

本文概述了苹果 App Store 相关 API 和开发者链的变化。首先讨论了 verifyReceipt API 的弃用和开发者迁移到较新 API 的必要性。接着，介绍了 App Store 服务器通知 V1 的弃用以及 V1 和 V2 通知之间的区别。另一个重要的话题是旧的 receiptData 格式存在伪造凭证的风险。最后，文章介绍了 App Store 服务器库，这是一组旨在简化与苹果 API 集成的工具。这个库提供了 Java、Swift、Python 和 Node.js 版本。

最后，开发者应该马上注意这些变化，并采取措施及时更新他们的代码。这些变化对开发人员的工作有重要影响，了解这些变化并及时更新代码可以帮助开发人员更好地使用苹果 App Store API 和工具，提高开发效率和应用质量，同时也避免旧 API 存在漏洞导致出现安全风险的问题。

如有问题，欢迎大家评论区一起交流~

> 我们是37手游移动客户端开发团队，致力于为游戏行业提供高质量的SDK开发服务。
> 
> 欢迎关注我们，了解更多移动开发和游戏 SDK 技术动态~
> 
> 技术问题/交流/进群等可以加官方微信 MobileTeam37
