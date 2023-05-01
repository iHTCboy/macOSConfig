title: WWDC22 - In App Purchase 更新总结
date: 2022-07-11 11:54:10
categories: technology #induction life poetry
tags: [WWDC22,In App Purchase]  # <!--more-->
reward: true

---

> 本文首发于 [WWDC22 - In App Purchase 更新总结 - 掘金](https://juejin.cn/post/7118958291446661134)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

WWDC21 是历年来 In App Purchase（IAP，内购内购买）最大变化的一年，分别推出了 StoreKit 2、App Store Server API、App Store Server Notifications V2 三大特性，去年我们也编写了 [《苹果iOS内购三步曲：App内退款、历史订单查询、绑定用户防掉单！--- WWDC21》](https://juejin.cn/post/6974733392260644895) 文章，所以我们本文不会再深入提及去年的更新，大家如果不太熟悉，可以先温习一下。本文将对今年 WWDC22 带来的变化，从整体的视角一起回顾。

<!--more-->

![WWDC22-IAP-00](https://ihtcboy.com/images/WWDC22-IAP-00.png)

### 前言

WWDC21 是历年来 In App Purchase（IAP，内购内购买）最大变化的一年，分别推出了 StoreKit 2、App Store Server API、App Store Server Notifications V2 三大特性，去年我们也编写了 [《苹果iOS内购三步曲：App内退款、历史订单查询、绑定用户防掉单！--- WWDC21》](https://juejin.cn/post/6974733392260644895) 文章，所以我们本文不会再深入提及去年的更新，大家如果不太熟悉，可以先温习一下。本文将对今年 WWDC22 带来的变化，从整体的视角一起回顾。

![WWDC22-IAP-01](https://ihtcboy.com/images/WWDC22-IAP-01.png)

以下是编者对 In App Purchase 这几年重要的更新或调整的梳理：

| 时间 | 事件 | 变化 | 来源 |
|---|:--|---|---|
| 2020 年 11 月 18 日 | App Store 小型企业计划 | 日历年收入在 100 万美元以下的小型和独立开发者将可以享受 15% 的佣金费率，仅为 App Store 标准佣金费率 30% 的一半，付费 app 和 App 内购买项目的收益抽成将降低 15％。 | [1](https://developer.apple.com/cn/news/?id=i7jzeefs)、[2](https://developer.apple.com/cn/news/?id=6lyxewwp) |
| 2020 年 11 月 23 日 | 针对在线多人活动的 app 内购买项目规定 | 3.1.3(d) 一对一服务：如果您的 App 允许购买两个人之间的一对一实时服务 (例如，学生辅导、医疗咨询、看房服务或健身训练)，您可以使用 App 内购买项目以外的其他购买方式来收取相应款项。一对几和一对多的实时服务则必须使用 App 内购买项目。 | [1](https://developer.apple.com/cn/news/?id=yeyd5xuh)、[2](https://developer.apple.com/cn/app-store/review/guidelines/#in-app-purchase) |
| 2021 年 8 月 26 日 | Apple 与美国开发者就 App Store 达成和解 | 美国开发者提起的 App Store 集体诉讼与苹果和解，Apple 设立一亿美元的基金来帮助美国的小型业务开发者，符合条件的开发者获得 250 美元至 3 万美元的现金）。 | [1](https://developer.apple.com/cn/news/?id=r24k5i3m)、[2](https://www.apple.com.cn/newsroom/2021/08/apple-us-developers-agree-to-app-store-updates/) |
| 2021 年 9 月 1 日 | 日本公平贸易委员会结束对 App Store 的调查 |  3.1.3(a) “阅读器”类型的 App：此类 App 可以允许用户访问先前购买的内容或内容订阅 (具体包括：杂志、报纸、图书、音频、音乐和视频)。各种阅读器 App 可以为使用免费版本的用户提供帐户创建功能，并为现有用户提供帐户管理功能。阅读器 App 开发者可以申请 External Link Account 授权，以在其 App 中提供一个指向其拥有或负责维护的网站的信息链接，以便用户创建或管理帐户。了解有关 [External Link Account](https://developer.apple.com/cn/support/reader-apps/) 授权的更多信息。| [1](https://www.apple.com.cn/newsroom/2021/09/japan-fair-trade-commission-closes-app-store-investigation/)、[2](https://developer.apple.com/cn/news/?id=grjqafts) |
| 2022 年 1 月 14 日 | 针对在荷兰 App Store 上分发的约会 App 的更新 | 荷兰消费者和市场管理局（ACM）允许荷兰 App Store 上的约会 App 开发人员与用户共享额外的付款处理选项。允许仅在荷兰 App Store 中分发的约会 App 在 App 内提供其他支付处理选项。开发者可以使用 StoreKit 外部购买授权，苹果降低 3% 的佣金，可与小型企业计划或自动续期订阅的 15 %佣金叠加，最低抽成 12 %。 | [1](https://developer.apple.com/news/?id=3bttqj0z)、[2](https://developer.apple.com/cn/support/storekit-external-entitlement/) |
| 2022 年 5 月 16 日 |自动续期订阅提价更新 | 目前，当自动续期订阅提价时，订阅者必须在 App 提价之前选择接受。**新调整**：符合某些特定条件并在提前通知用户的情况下，开发者在为自动续订订阅提价时，无需用户额外采取行动，亦不会中断服务。（前提条件：每年提价不超过一次，同时订阅价格上调不超过 5 美元和 50%，或者年度订阅价格上调不超过 50 美元和 50%，并且是在法律允许的范围内。） | [1](https://developer.apple.com/cn/news/?id=tpgp89cl)、[2](https://help.apple.com/app-store-connect/?lang=zh-cn#/devc9870599e) |
| 2022 年 6 月 30 日 | 针对在韩国分发 App 的更新 | 允许仅在韩国 App Store 中分发的 App 在 App 内提供其他支付处理选项。开发者可以使用 StoreKit 外部购买授权，但苹果收益抽成 26%。 | [1](https://developer.apple.com/cn/news/?id=q0feipe4)、[2](https://developer.apple.com/cn/support/storekit-external-entitlement-kr/) |


说到内购，环绕着的新闻，总起到一些波澜，从 2021 年苹果推出 App Store 小型企业计划，降低 15% 的佣金，大家的讨论一直源源不断，对于小型企业和开发者，确实是明显感受到 15% 带来的回报！本文不去讨论合理性，App Store 从 2008 年推出就是一个创举，它改变了世界对 App 的认识。我们本文更多的是讨论如果利用这些变化，为用户提供更好的服务或体验！

本文主要从四方面进行探讨：

1. StoreKit 2
2. App Store Server API
3. App Store Server Notifications V2
4. App Store Connect


### StoreKit 2

StoreKit 2 和 Original StoreKit，应该怎么选择？苹果在[选择文档](https://developer.apple.com/documentation/storekit/choosing_a_storekit_api_for_in-app_purchase)在给出了答案：

* [StoreKit 2](https://developer.apple.com/documentation/storekit/in-app_purchase): 一个基于 Swift 的 API，以 JSON Web Signature (JWS) 格式提供 Apple 签名交易验证，从 iOS 15、macOS 12、tvOS 15 和 watchOS 8 开始提供。
* [Original API for In-App Purchase](https://developer.apple.com/documentation/storekit/original_api_for_in-app_purchase): 一个使用 App Store 收据提供交易信息的API，从 iOS 3、macOS 10.7、tvOS 9 和 watchOS 6.2 开始提供。

去年的文章，我们提到以下功能必须依赖 Original StoreKit API：

1. 为批量购买计划（VPP，Volume Purchase Program）提供支持。有关更多信息，请参阅 [设备管理](https://developer.apple.com/documentation/devicemanagement)。
2. 提供应用预订（app pre-orders）。有关更多信息，请参阅 [应用预订](https://developer.apple.com/app-store/pre-orders/)。
3. 您的 App 从收费更改为免费 App，反之亦然。
4. 推广应用内购买。有关更多信息，请参阅 [推广应用程序内购买](https://developer.apple.com/app-store/promoting-in-app-purchases/)。
5. 对现有和历史遗留的旧 App 使用 v1 API。

因此，今年的 StoreKit 2，苹果提供新的字段 [preorderDate](https://developer.apple.com/documentation/storekit/apptransaction/4013175-preorderdate) 和 [originalPurchaseDate](https://developer.apple.com/documentation/storekit/apptransaction/3954448-originalpurchasedate) 来获取 App 预订时间和购买时间，但是只支持 iOS 16+。

所以，目前 iOS 16 和 StoreKit 2 不能解决的问题：

1. 为批量购买计划（VPP，Volume Purchase Program）提供支持。有关更多信息，请参阅 [设备管理](https://developer.apple.com/documentation/devicemanagement)。
2. 推广应用内购买。有关更多信息，请参阅 [推广应用程序内购买](https://developer.apple.com/app-store/promoting-in-app-purchases/)。
3. 对现有和历史遗留的旧 App 使用 Original StoreKit API。

**2022年，如何选择 Original StoreKit 还是 StoreKit 2**

对于支持低于 iOS 15 以下 app 依然需要使用 Original StoreKit，直到只支持 iOS 15+，并且支持迁移到 StoreKit 2。对于目前开发者来说，使用 StoreKit 2 的成本主要是兼容的系统版本，还有一方面是服务端的兼容，最后是 app 如果有 IAP 服务，那一定是核心业务，不容许一点点的错误！这导致了大多数 app 还处于围观 StoreKit 2 的状态。对于只支持 iOS 15+ 或者独立开发者，建议可以尝试使用 StoreKit 2，如果有异常时，降级到 Original StoreKit 就可以。总之，最后等时间给我们答案吧。

#### App Transaction（App 交易）

StoreKit 2 增加了 [App Transaction](https://developer.apple.com/documentation/storekit/apptransaction) 结构体，用于代替 Original StoreKit 的 receipt 内容，具体直接查看接口文档：

```swift
/// Represents signed transaction information for an app purchase.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AppTransaction : Sendable {

    /// The JSON representation of the transaction.
    public var jsonRepresentation: Data { get }

    /// A number the App Store uses to uniquely identify the application.
    public let appID: UInt64?

    /// The application version the transaction is for.
    public let appVersion: String

    /// A number the App Store uses to uniquely identify the version of the application.
    public let appVersionID: UInt64?

    /// Identifies the application the transaction is for.
    public let bundleID: String

    /// The server environment this transaction was created in.
    public let environment: AppStore.Environment

    /// The version of the app originally purchased.
    public let originalAppVersion: String

    /// The date this original app purchase occurred on.
    public let originalPurchaseDate: Date

    /// The date this app was preordered.
    public let preorderDate: Date?

    /// A SHA-384 hash of `AppStore.deviceVerificationID` appended after
    /// `deviceVerificationNonce` (both lowercased UUID strings).
    public let deviceVerification: Data

    /// The nonce used when computing `deviceVerification`.
    /// - SeeAlso: `AppStore.deviceVerificationID`
    public let deviceVerificationNonce: UUID

    /// The date this transaction was generated and signed.
    public let signedDate: Date

    /// Get the cached `AppTransaction` for this version of the app or make
    /// a request to get one from the App Store server if one has not been cached yet.
    public static var shared: VerificationResult<AppTransaction> { get async throws }

    /// Refreshes the shared `AppTransaction` from the App Store server.
    /// Calling this function will force an authentication dialog to display to the user.
    public static func refresh() async throws -> VerificationResult<AppTransaction>
}
```

`App Transaction` 从以上接口可以获取 App 预订时间 [preorderDate](https://developer.apple.com/documentation/storekit/apptransaction/4013175-preorderdate) 和购买时间 [originalPurchaseDate](https://developer.apple.com/documentation/storekit/apptransaction/3954448-originalpurchasedate) 等。另外，验证用户当前使用的 app 是否正品购买以防止欺诈的作用。

![WWDC22-IAP-02](https://ihtcboy.com/images/WWDC22-IAP-02.png)

- 购买您的 app 的签名信息
- 使用 JWS 签名
- 替换 Original StoreKit 的 receipt（票据）
- StoreKit 提供验证方法
- 开发者可以执行自己的验证（或处理）

验证 App Transaction 的方法：
```swift
    @available(iOS 16.0, *)
    func verificationAppTransaction() {
        Task {
            do {
                let verificationResult = try await StoreKit.AppTransaction.shared
                
                switch verificationResult {
                case .verified(let appTransaction):
                    // StoreKit verified that the user purchased this app and
                    // the properties in the AppTransaction instance.
                    // Add your code here.
                case .unverified(let appTransaction, let verificationError):
                    // The app transaction didn't pass StoreKit's verification.
                    // Handle unverified app transaction information according
                    // to your business model.
                    // Add your code here.
                }
            } catch {
                // Handle errors.
            }
        }
    }
```

最后说明一下，App Transaction 的内容，首次启动时，StoreKit 会自动获取更新并保持最新状态。当您的 app 无法通过 `shared` 属性获得 App Transaction 时（包括返回 [Verification.unverified(_:_:)](https://developer.apple.com/documentation/storekit/apptransaction/4020517-refresh) 或抛出异常错误），可以使用 [refresh()](https://developer.apple.com/documentation/storekit/apptransaction/4020517-refresh) 刷新 App 交易内容，但是刷新时，系统会弹窗提示用户可能需要重新授权认证 Apple ID 账号，所以建议是提供用户操作的按钮，由用户主动发起调用。

#### New properties（新特性）

StoreKit 2 带来了新的四个字段：

![WWDC22-IAP-03](https://ihtcboy.com/images/WWDC22-IAP-03.png)

- 价格地区
- 交易的服务器环境
- 最近的订阅开始日期
- 哨兵值（占位符值）

**Price locale**

```swift
extension Product {

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public var priceFormatStyle: Decimal.FormatStyle.Currency { get }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public var subscriptionPeriodFormatStyle: Date.ComponentsFormatStyle { get }
}
```

新增 [priceFormatStyle](https://developer.apple.com/documentation/storekit/product/4044347-priceformatstyle) 和 [subscriptionPeriodFormatStyle](https://developer.apple.com/documentation/storekit/product/4044348-subscriptionperiodformatstyle) 字段。一般情况下，苹果建议尽可能使用 [displayPrice](https://developer.apple.com/documentation/storekit/product/3749580-displayprice) 字段表示格式。例如从 [price](https://developer.apple.com/documentation/storekit/product/3749586-price) 属性获取两个品项的价格，例如 `2 products for $(`price * 2`)`。


**Server environment**

```swift
public struct Transaction : Identifiable {
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public let environment: AppStore.Environment
    
    @available(iOS, introduced: 15.0, deprecated: 16.0, message: "Use the environment property instead")
    @available(macOS, introduced: 12.0, deprecated: 13.0, message: "Use the environment property instead")
    @available(tvOS, introduced: 15.0, deprecated: 16.0, message: "Use the environment property instead")
    @available(watchOS, introduced: 8.0, deprecated: 9.0, message: "Use the environment property instead")
    @available(macCatalyst, introduced: 15.0, deprecated: 16.0, message: "Use the environment property instead")
    public var environmentStringRepresentation: String { get }
}
```

在 iOS 16+ 使用 [environment](https://developer.apple.com/documentation/storekit/transaction/3963920-environment) 结构体，在 iOS 15 使用 [environmentStringRepresentation](https://developer.apple.com/documentation/storekit/transaction/3976514-environmentstringrepresentation) 字段。

获取到的字段值：

| 环境 | 值 | 说明 |
|---|---|---|
| App Store | `Production` | App Store 商店包环境的交易 |
| App Store Sandbox 或 TestFlight | `Sandbox` | Develop 或 TestFlight 环境的交易 |
| Xcode StoreKit Testing | `Xcode` | 使用 Xcode 进行 StoreKit 测试的交易 |


**Recent subscription start date**

```swift
extension Product.SubscriptionInfo {
    public struct RenewalInfo {
        @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
        public var recentSubscriptionStartDate: Date { get }
    }
}
```

[recentSubscriptionStartDate](https://developer.apple.com/documentation/storekit/product/subscriptioninfo/renewalinfo/3976513-recentsubscriptionstartdate) 表示自动续期订阅购买中订阅的最早开始日期，忽略了超过 60 天的所有续费失败的订阅。

需要注意的是，不要使用 recentSubscriptionStart 字段日期来计算付费服务天数，以前，自动续期订阅的净收入结构和 App Store 上的其他商业模式不同，用户订阅累积满一年后，开发者的 [收入将增加到订阅价格的 85%](https://developer.apple.com/cn/app-store/subscriptions/#revenue-after-one-year)。所以，开发者不能依据这个字段来判断用户订阅是否满一年。另外，如果开发者当前注册了 [App Store Small Business Program](https://developer.apple.com/cn/app-store/subscriptions/#revenue-after-one-year)，符合条件的情况下，无论订阅是否已累积满一年，其实在每个结算周期收到订阅价格的  85%。

**Sentinel values**

![WWDC22-IAP-04](https://ihtcboy.com/images/WWDC22-IAP-04.png)

另外，在不支持的系统和环境中，就会使用 `Sentinel values` 哨兵值（占位符值），例如 Price local 下使用 `Locale(identifier: "xx\_XX")`，而 Recent subscription start date 使用 `Date.distantPast` 等。这是为什么呢？

因为以上的字段，其它在 Xcode13 和 iOS 15 是不存在的！苹果利用 Xcode 14 提供了对 iOS 15, iPadOS 15, macOS 12, Mac Catalyst 15, watchOS 9, tvOS 15 等的支持。原理是通过 Xcode 14 编译 app 时，会带上这些字段在 app 包体中，低系统的用户更新包含这些字段的版本时，就能使用。（具体是怎么编译和实现，有懂的朋友欢迎留言交流，小编暂时还没有找到相关文档。）

另外，JWS Transaction 的 Payload 内也新增 environment、recentSubscriptionStartDate 相关字段，下文会提到。

![WWDC22-IAP-05](https://ihtcboy.com/images/WWDC22-IAP-05.png)

#### SwiftUI API

针对 SwiftUI 增加了优惠代码兑换接口和应用内评分接口。

![WWDC22-IAP-06](https://ihtcboy.com/images/WWDC22-IAP-06.png)

![WWDC22-IAP-07](https://ihtcboy.com/images/WWDC22-IAP-07.png)


#### StoreKit messages

StoreKit [Message](https://developer.apple.com/documentation/storekit/message) API 只支持 iOS 16+，用于开发者在 app 中接收和显示 App Store 消息处理。举例来说，自动续期订阅的费用涨价时，如果需要用户确认同意涨价，就需要弹窗给用于确认：

![WWDC22-IAP-08](https://ihtcboy.com/images/WWDC22-IAP-08.png)

具体的 StoreKit messages 交互流程图：

![WWDC22-IAP-09](https://ihtcboy.com/images/WWDC22-IAP-09.png)


获取 App Store messages 消息，使用 SwiftUI 实现的代码示例：

![WWDC22-IAP-10](https://ihtcboy.com/images/WWDC22-IAP-10.png)


然后显示 App Store messages 消息，需要通过 SwiftUI 环境变量 `displayStoreKitMessage` 来解析和显示，使用 SwiftUI 实现的代码示例：

![WWDC22-IAP-11](https://ihtcboy.com/images/WWDC22-IAP-11.png)


#### applicationUsername 和 appAccountToken

```swift
let payment = SKMutablePayment(product: product)
payment.applicationUsername = uuidString

SKPaymentQueue.default().add(payment)
```

[applicationUsername](https://developer.apple.com/documentation/storekit/skmutablepayment/1506088-applicationusername) 是 Original StoreKit 创建苹果订单时，由开发者赋值的一个字段，原本这个字段是传入用户 UID 的 Hash 值，作用是给苹果验证应用购买以防止欺诈，比如代充和黑产恶意充值等。

而 [appAccountToken](https://developer.apple.com/documentation/storekit/transaction/3749684-appaccounttoken) 是去年 WWDC21 推出 StoreKit 2 的一个字段，用于开发者将苹果交易与自己服务上的用户关联的 UUID 格式的字段。

![WWDC22-IAP-12](https://ihtcboy.com/images/WWDC22-IAP-12.png)

而现在，苹果打通了 applicationUsername 和 appAccountToken，当用 Original StoreKit 创建订单时，applicationUsername 字段赋值使用 UUID 格式内容时，则可以在服务端通知或者解析 receipt 票据时，可以获取这个 UUID 值，也就是订单可以关联确认。

我们回顾一下，我们为什么需要使用 `applicationUsername`？我们是希望每个交易 transaction 可以关联用户订单号，对于订阅类型和非消耗类型品项，关联用户 UID 就能满足需求，但是对于非消耗型品项，其实，需要关联用户 UID 还有订单号 OrderID，因为非消耗型品项可以重复购买并且没有 UID 的强关联。举例来说，游戏里的用户账号可能不止一个，或者一个账号下的游戏角色，通常不止有一个角色，所以购买非消耗型品项时，开发者希望关联的是当前用户 UID 和此角色 RoleID 生成的开发者订单号 OrderID，但此时，UUID 格式并不能满足开发者自定义的需求！

所以，applicationUsername 和 appAccountToken 的透传值，对开发者有一定的关联作用，但其实还不完美。

#### External Purchase（外部购买，第三方支付）

符合条件的 app 可以包含一个链接，引导使用该 app 的用户访问网站进行外部购买。要包含该链接，请完成此授权的请求。有关符合条件的 app 和请求此授权的更多信息，请参阅：

- [在荷兰分发约会 App](https://developer.apple.com/support/storekit-external-entitlement/)
- [在韩国使用第三方支付提供商分发 App](https://developer.apple.com/support/storekit-external-entitlement-kr/) 

具体的细节这里不说，就重点说说代码。首先，需要更新 app 的 Info.plist 文件，添加权限：

- [com.apple.developer.storekit.external-purchase](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_storekit_external-purchase?changes=latest_major&language=ob_8) ：表示您的 app 是否可以提供外部购买。
- [com.apple.developer.storekit.external-purchase-link](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_storekit_external-purchase-link?changes=latest_major&language=ob_8) ：表示您的 app 是否可以包含一个链接，引导用户访问网站进行外部购买。
- [SKExternalPurchase](https://developer.apple.com/documentation/bundleresources/information_property_list/skexternalpurchase?changes=latest_major&language=ob_8) ：表示您的 app 可以提供外部购买的国家或地区。
- [SKExternalPurchaseLink](https://developer.apple.com/documentation/bundleresources/information_property_list/skexternalpurchaselink?changes=latest_major&language=ob_8) ：表示您的 app 可以提供外部购买的国家或地区和对应的用户访问网站进行外部购买的链接。

配置示例：

```xml
    <key>com.apple.developer.storekit.external-purchase</key>
    <true/>
    <key>com.apple.developer.storekit.external-purchase-link</key>
    <true/>
	 <key>SKExternalPurchase</key>
    <array>
        <string>nl</string>
    </array>
    <key>SKExternalPurchaseLink</key>
    <dict>
        <key>nl</key>
        <string>https://www.iHTCboy.com</string>
    </dict>
```

然后就是接口调用，在 iOS 或 iPadOS 15.4 或更高版本，使用 StoreKit [External Purchase](https://developer.apple.com/documentation/storekit/external_purchase) API：

```swift
@available(iOS 15.4, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum ExternalPurchase {

    /// The result of presenting the external purchase notice sheet.
    public enum NoticeResult : Sendable {

        /// The user chose to continue to view external purchases.
        case continued

        /// The user chose to cancel and **not** view external purchases.
        case cancelled

        public static func == (a: ExternalPurchase.NoticeResult, b: ExternalPurchase.NoticeResult) -> Bool
        public func hash(into hasher: inout Hasher)
        public var hashValue: Int { get }
    }

    /// Present a notice sheet to users before showing external purchases.
    ///
    /// Only call this method as a result of deliberate user interaction, such as tapping a button.
    /// - Returns: Whether the user chose to continue to view the external purchases. Only show
    ///            external purchases if the result is `NoticeResult.continued`.
    /// - Throws: A `StoreKitError`
    public static func presentNoticeSheet() async throws -> ExternalPurchase.NoticeResult
}
```

![WWDC22-IAP-13](https://ihtcboy.com/images/WWDC22-IAP-13.png)

如图所示，按照苹果的规范，使用外部购买必须要的步骤：

1. 检查当前设备允许付款
2. 对于运行 iOS 和 iPadOS 15.4 或更高版本的设备，使用 StoreKit ExternalPurchase API
3. 对于低于 iOS 和 iPadOS 15.4 系统，使用上图的 UI 设计和文本内容提示用户


在 iOS 和 iPadOS 15.4 运行的代码示例：
```swift
// 当前设备不能支付，则不能进行购买~
guard AppStore.canMakePayments else {
    return
}

do {
    // 打开外部购买流程
    let res = try await ExternalPurchase.presentNoticeSheet()
    // 打开结果
    switch res {
    case .continued:
        print("用户选择继续查看外部购买")
    case .cancelled:
        print("用户选择取消，不查看外部购买")
    @unknown default:
        fatalError()
    }
} catch {
    // 异常流程
    print(error.localizedDescription)
}
```

注意事项：

- 获取苹果许可权限后，您才可以在 app 中包含第三方支付系统
- 只有用户点击 `I Understand`（我明白）后，才能跳转到第三方支付系统
- 不包含任何隐藏、休眠或苹果未允许的支付功能或行为
- 只能在苹果允许的国家或地区的 App Store 商店使用第三方支付系统


#### External Link Account（访问外部网站的链接）

> 阅读器 App 是指将提供以下一种或多种数字内容类型作为其主要功能的 App：杂志、报纸、图书、音频、音乐或视频。

通过阅读器 App，用户可以登录他们在 App 之外创建的帐户，从而可以在用户的 Apple 设备上阅览和畅读先前购买的媒体内容或内容订阅。开发者可以提供指向 app 网站的链接，以便用户在 app 网站上创建和管理帐户。有关符合条件的 app 和请求此授权的更多信息，请参阅：

- [分发包含指向您网站的链接的“阅读器” App](https://developer.apple.com/cn/support/reader-apps/)

同理，首先，需要更新 app 的 Info.plist 文件，添加权限：

- [com.apple.developer.storekit.external-link.account](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_storekit_external-link_account) ：表示您的 app 是否可以链接到外部网站进行帐户创建或管理。
- [SKExternalLinkAccount](https://developer.apple.com/documentation/bundleresources/information_property_list/skexternallinkaccount) ：表示您的 app 可以提供外部创建或管理帐户的国家或地区，和对应的用户访问创建或管理帐户网站的链接。

```xml
	<key>com.apple.developer.storekit.external-link.account</key>
	<true/>
	<key>SKExternalLinkAccount</key>
	<dict>
		<key>*</key>
		<string>https://www.iHTCboy.com</string>
		<key>jp</key>
		<string>https://www.iHTCboy.com/jp</string>
	</dict>
```

然后就是接口调用，在 iOS 或 iPadOS 16 或更高版本，使用 StoreKit [External Link Account](https://developer.apple.com/documentation/storekit/external_link_account) API：

```swift
@available(iOS 16.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public enum ExternalLinkAccount : Sendable {

    /// Whether the app can open the external link account.
    ///
    /// Check this property before showing any UI controls that the user can use to open the external link
    /// account.
    /// You may want to check the value of this property again when the App Store storefront changes.
    /// - Important: If this property is `false`, do not show UI controls that call `open()` as the
    ///              method will always fail.
    public static var canOpen: Bool { get async }

    /// Opens the external link account in the user's default browser.
    ///
    /// Only call this method as a result of deliberate user interaction, such as tapping a button. If
    /// `canOpen` is `false`, this method will always throw an error. Returning without throwing an error
    /// does not guarantee the user was redirected to the external link account.
    /// - Throws: A `StoreKitError`
    public static func open() async throws
}
```

![WWDC22-IAP-14](https://ihtcboy.com/images/WWDC22-IAP-14.png)

如图所示，按照苹果的规范，使用外部购买必须要的步骤：

1. 检查当前设备允许付款
2. 对于运行 iOS 和 iPadOS 16 或更高版本的设备，使用 StoreKit ExternalPurchase API
3. 对于低于 iOS 和 iPadOS 16 系统，使用上图的 UI 设计和文本内容提示用户，**并且必须是使用默认浏览器中打开一个新窗口**，而不能使用 App 的 WebView 打开


在 iOS 和 iPadOS 15.4 运行的代码示例：

```swift
@available(iOS 16.0, *)
func externalLinkAccount() {
    
    // 当前设备不能支付，则不能进行购买~
    guard AppStore.canMakePayments else {
        return
    }
    
    Task {
        // 判断是否有打开外部链接帐户的权限
        let canOpen = await ExternalLinkAccount.canOpen
        guard canOpen else {
            print("不能打开外部链接帐户")
            return
        }
        
        do {
            // 打开外部链接帐户
            try await ExternalLinkAccount.open()
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

注意事项：

- 获取苹果许可权限后，您才可以在 app 中包含链接到外部网站进行帐户创建或管理
- 只有用户点击 `Continue`（继续）后，才能跳转到外部网站进行帐户创建或管理
- 跳转到外部网站，不能有没有任何重定向、中间链接或着陆页面
- 不得在 URL 中传递附加参数，以便保护用户 (例如用户的隐私)


### App Store Server API

`App Store Server API` 是苹果去年 WWDC21 推出的 ，详细可以参考我们之前的文章《[WWDC21 - App Store Server API 实践总结](https://juejin.cn/post/7056976669139009573)》。

今年 WWDC22 苹果新增了三个新接口，并且对部分接口增加了过滤功能，这里我们列了一个表格：

| 推出时间 | 接口 | 说明 | 链接 |
|---|:--|---|---|
| WWDC21 | [Look Up Order ID](https://developer.apple.com/documentation/appstoreserverapi/look_up_order_id) | **查询用户订单的收据**，使用订单ID从收据中获取用户的应用内购买项目收据信息。 | `GET https://api.storekit.itunes.apple.com/inApps/v1/lookup/{orderId}` |
| WWDC21 | [Get Transaction History](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history) | **查询用户历史收据**，获取用户在您的 app 的应用内购买交易历史记录。 | `GET https://api.storekit.itunes.apple.com/inApps/v1/history/{originalTransactionId}` |
| WWDC21 | [Get Refund History](https://developer.apple.com/documentation/appstoreserverapi/get_refund_history) | **查询用户内购退款**，获取 app 中为用户退款的所有应用内购买项目的列表。 | `GET https://api.storekit.itunes.apple.com/inApps/v1/refund/lookup/{originalTransactionId}` |
| WWDC21 | [Get All Subscription Statuses](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses) | **查询用户订阅项目状态**，获取您 app 中用户所有订阅的状态。 | `GET https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/{originalTransactionId}` |
| WWDC21 | [Send Consumption Information](https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information) | **提交防欺诈信息**，当用户申请退款时，苹果通知（CONSUMPTION_REQUEST）开发者服务器，开发者可在12小时内，提供用户的信息（比如游戏金币是否已消费、用户充值过多少钱、退款过多少钱等），最后苹果收到这些信息，协助“退款决策系统” 来决定是否允许用户退款。 | `PUT https://api.storekit.itunes.apple.com/inApps/v1/transactions/consumption/{originalTransactionId}` |
| WWDC21 | [Extend a Subscription Renewal Date](https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date) | **延长用户订阅的时长**，使用原始交易标识符延长用户有效订阅的续订日期。（相当于免费给用户增加订阅时长） | `PUT https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/extend/{originalTransactionId}` |
| WWDC22 | [Request a Test Notification](https://developer.apple.com/documentation/appstoreserverapi/request_a_test_notification) | **测试 App Store 服务器通知**，让 App Store 服务器通知向开发者服务器发送测试通知。 | `POST https://api.storekit.itunes.apple.com/inApps/v1/notifications/test` |
| WWDC22 | [Get Test Notification Status](https://developer.apple.com/documentation/appstoreserverapi/get_test_notification_status) | **获取 App Store 服务器通知的测试结果**，获取发送到开发者服务器的 App Store 服务器测试通知的检查状态。 | `GET https://api.storekit.itunes.apple.com/inApps/v1/notifications/test/{testNotificationToken}` |
| WWDC22 | [Get Notification History](https://developer.apple.com/documentation/appstoreserverapi/get_notification_history) | **获取 App Store 服务器通知的历史通知**，获取 App Store 服务器尝试发送到开发者服务器的通知列表。 | `POST https://api.storekit.itunes.apple.com/inApps/v1/notifications/history` |


#### Filter and Sort（过滤和排序）

其中只有 [Get Transaction History](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history) 接口提供了过滤和排序的功能：

![WWDC22-IAP-15](https://ihtcboy.com/images/WWDC22-IAP-15.png)

目前支持的查询参数列表：

| 查询参数 | 作用 | 可选值 |
|---|---|---|
| productType | 包含在交易历史记录中的产品类型。您的查询可以指定多个productType。 | AUTO_RENEWABLE, NON_RENEWABLE, CONSUMABLE, NON_CONSUMABLE |
| productId | 包含在交易历史记录中的产品标识符。您的查询可以指定多个productID。 | - |
| subscriptionGroupIdentifier | 包含在交易历史记录中的订阅组标识符。您的查询可能会指定多个subscriptionGroupIdentifier。 | - |
| startDate | 交易开始日期，以 UNIX 时间表示的时间跨度的开始日期，以毫秒为单位。 | - |
| endDate | 交易截止日期，以 UNIX 时间表示的时间跨度的截止日期，以毫秒为单位。 | - |
| inAppOwnershipType | 按应用程序内所有权类型限制交易历史记录。 | PURCHASED，FAMILY_SHARED。 |
| excludeRevoked | 交易历史记录是否排除退款和撤销的交易。默认值为false。 | true, false |
| sort | 交易历史记录的可选排序顺序。响应按最近修改的日期对交易记录进行排序。默认值为 ASCENDING（升序），因此您首先会收到最旧的交易记录。 | ASCENDING, DESCENDING |
| revision | 获取下一组最多20笔交易的令牌。所有回复都包含一个revision令牌。注意：对于使用revision令牌的请求，请包含与初始请求相同的查询参数。使用上一个History中的revision令牌。除初始请求外，所有请求都需要revision。 | - |

查询示例：
![WWDC22-IAP-16](https://ihtcboy.com/images/WWDC22-IAP-16.png)

`productId`、`productType` 和 `subscriptionGroupIdentifier` 查询参数可以同时指定多个值。例如，要按 NON_CONSUMABLE（非消耗型） 和 AUTO_RENEWABLE（自动续期产品类型）字符来筛选交易历史记录，请求中包含以下内容：

```html
GET https://api.storekit.itunes.apple.com/inApps/v1/history/{originalTransactionId}?productType=NON_CONSUMABLE&productType=AUTO_RENEWABLE
```

其实更优雅的方式可能是 App Store Connect API 的形式：`&filter[appStoreVersions.appStoreState]=READY_FOR_SALE,PREORDER_READY_FOR_SALE,READY_FOR_REVIEW` 。


最后，交易历史记录接口返回结果只支持以下情况：

* 自动续期订阅
* 非续订订阅
* 非消耗型应用内购买项目
* 消耗型应用内购买项目：如果交易被退款、撤销或 app 尚未完成交易处理等。

> 特别注意：消耗型应用内购买项目如果调用了 [finishTransaction(_:)](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)，则不会在出现在舞台的交易历史列表中，所以，**消耗型应用内购买项目不能使用这个接口作为校验接口！！！**


#### New Notification API（新的通知接口）

**测试 App Store 服务器通知**

[Request a Test Notification](https://developer.apple.com/documentation/appstoreserverapi/request_a_test_notification) 让 App Store 服务器通知向开发者服务器发送测试通知。 

```
POST https://api.storekit.itunes.apple.com/inApps/v1/notifications/test
```

![WWDC22-IAP-17](https://ihtcboy.com/images/WWDC22-IAP-17.png)

接口响应的 `testNotificationToken` 字段是 App Store 服务器通知发送到开发者服务器的通知测试的测试通知令牌，每次请求获取的唯一标识 Token，这个 Token 用于下面的接口参数。


**获取 App Store 服务器通知的测试结果**

[Get Test Notification Status](https://developer.apple.com/documentation/appstoreserverapi/get_test_notification_status)，获取发送到开发者服务器的 App Store 服务器测试通知的检查状态。

```
GET https://api.storekit.itunes.apple.com/inApps/v1/notifications/test/{testNotificationToken}
```

根据 [Request a Test Notification](https://developer.apple.com/documentation/appstoreserverapi/request_a_test_notification) 接口获取到的 `testNotificationToken` 请求测试结果：

![WWDC22-IAP-18](https://ihtcboy.com/images/WWDC22-IAP-18.png)

返回的响应有两个参数:

- `firstSendAttemptResult`：表示 App Store 服务器尝试向开发者服务器发送 TEST 通知的结果，如果不是 `SUCCESS`，则如上图会返回原因，如果 `TIMED_OUT` 表示超时，`SSL_ISSUE` 表示开发者服务器的 SSL 证书有问题。根据这个字段就能测试和检查 App Store 服务器和开发者服务器之前的连通性。
- `signedPayload`：JWS 格式的签名有效负载，包含 App Store 服务器发送到您的服务器的 TEST 通知。

具体的 `signedPayload` 解码后的格式内容如下示例：

![WWDC22-IAP-19](https://ihtcboy.com/images/WWDC22-IAP-19.png)

 **获取 App Store 服务器通知的历史通知**
 
 [Get Notification History](https://developer.apple.com/documentation/appstoreserverapi/get_notification_history)，获取 App Store 服务器尝试发送到开发者服务器的通知列表。

```
POST https://api.storekit.itunes.apple.com/inApps/v1/notifications/history
```

此接口的目的是，因为 App Store 服务器通知是苹果推送的通知，开发者是被动接收，总会因为各种情况（服务器宕机，运营商链路或云服务提供商故障等）导致无法按时接收到 App Store 服务器通知。所以，可以通过这个接口查询 App Store 服务器通知的历史记录：

![WWDC22-IAP-20](https://ihtcboy.com/images/WWDC22-IAP-20.png)

- 只支持 App Store 服务器通知 V2 版本的响应（即 JWS 格式）
- 最多可以查询 6 个月以内的历史列表（180天内）
- 可以过滤通知类型、通知子类型或用户
- 开发者服务器宕机后可使用接口主动获取通知记录，直到开发者服务器可接收 App Store 服务器通知为止

查询接口的示例：

![WWDC22-IAP-21](https://ihtcboy.com/images/WWDC22-IAP-21.png)

接口每次最多返回20条通知历史记录，所以响应会返回一个 `paginationToken` 字段，用来查询更多分页的通知结果。paginationToken 获取下一组最多 20 条通知历史记录，所有有更多历史记录的响应都包含 paginationToken 字段。


#### New properties（新特性）

除了 StoreKit 2 增加了 `environment`、`recentSubscriptionStartDate` 字段，App Store Server API 的 JWS 格式的签名交易也包含。

JWS transaction info Decoded Payload:

![WWDC22-IAP-22](https://ihtcboy.com/images/WWDC22-IAP-22.png)

JWS renewal info Decoded Payload:

![WWDC22-IAP-23](https://ihtcboy.com/images/WWDC22-IAP-23.png)

详细说明可以查看官方文档：[environment](https://developer.apple.com/documentation/appstoreserverapi/environment) 和 [recentSubscriptionStartDate](https://developer.apple.com/documentation/appstoreserverapi/recentsubscriptionstartdate)，这里不在复述。

### App Store Server Notifications V2

同理 App Store Server Notifications 也有新增相应的 [environment](https://developer.apple.com/documentation/appstoreservernotifications/environment) 和 [recentSubscriptionStartDate](https://developer.apple.com/documentation/appstoreservernotifications/recentsubscriptionstartdate) 字段。

![WWDC22-IAP-24](https://ihtcboy.com/images/WWDC22-IAP-24.png)

从这个图片可以看出，App Store Server API 是 App Store 服务器和开发者服务器之前，相互可以响应的流程。而 App Store Server Notifications V1 和 V2 通知，是 App Store 服务器主动通知开发者服务器，开发者服务器不能主动请求，所以导致了一些场景的缺陷。

#### App Store 服务器通知宕机

服务器宕机是很常见的问题，但是宕机后，开发者就无法接收 App Store 服务器的通知。

![WWDC22-IAP-25](https://ihtcboy.com/images/WWDC22-IAP-25.png)

所以，[App Store Server Notifications V2](https://developer.apple.com/documentation/appstoreservernotifications/responding_to_app_store_server_notifications) 通知在首次尝试通知后没有收到来自开发者服务器的响应时会进行重试：

![WWDC22-IAP-26](https://ihtcboy.com/images/WWDC22-IAP-26.png)

- App Store Server Notifications V1：重试三次；在上次尝试后 6、24 和 48 小时。
- App Store Server Notifications V2：重试五次；在上次尝试后 1、12、24、48 和 72 小时。

重试成功后，开发者服务器接收到的通知，可以并不再是顺序显示：

![WWDC22-IAP-27](https://ihtcboy.com/images/WWDC22-IAP-27.png)

所以，开发者需要通过 `signedDate` 字段，确保通知的顺序逻辑正确，也就是说通知的结果状态以最新的 signedDate 时间来准，来更新用户能享受的服务。而重试的通知可能会出现重复的通知响应，所以开发者可以通过 `notificationUUID` 字段去重通知。

#### 留住订阅者

用户需要不断从订阅中获得价值，才会持续地订阅您的 App。定期更新您的 App，提供新内容和增强功能，以鼓励订阅者继续订阅。

App Store Server Notifications V2 提供了更多的通知类型，达到 28 个，未来还会增加更多。

![WWDC22-IAP-28](https://ihtcboy.com/images/WWDC22-IAP-28.png)

这里一个用户订阅过程的可能会发生的通知：

![WWDC22-IAP-29](https://ihtcboy.com/images/WWDC22-IAP-29.png)

从这个图中，开发者可以思考到什么？

**Subscription loyalty（订阅忠诚度）**

![WWDC22-IAP-30](https://ihtcboy.com/images/WWDC22-IAP-30.png)

从苹果的 [自动续期订阅](https://developer.apple.com/cn/app-store/subscriptions/#retaining-subscribers) 文档可以获取这样的思考：

通过使用 [获取所有订阅状态](https://developer.apple.com/cn/app-store/subscriptions/#retaining-subscribers) 接口和 [获取交易历史记录](https://developer.apple.com/cn/app-store/subscriptions/#retaining-subscribers) 接口，可确定用户的订阅状态并查看交易历史记录，帮助您识别并执行以下操作：

- **自愿流失**。使用 [获取所有订阅状态](https://developer.apple.com/cn/app-store/subscriptions/#retaining-subscribers) 接口确定订阅者是不是已关闭特定订阅的自动续订。您还可以使用 App Store 服务器通知来获取有关用户状态变化的实时更新以及与其 App 内购买项目相关的关键事件，例如退款通知。使用这一信息来采取相应的行动，例如，您可以提供促销优惠以鼓励他们继续订阅，建议更符合他们需求的备用等级，或者在订阅到期后锁定相关订阅内容的访问权限。请务必向用户告知您所做的任何更改，以及他们是否需要完成任何操作，还有重新订阅的方式。
- **非自愿流失**。当订阅者遇到账单问题 (如信用卡过期问题) 时，就会发生非自愿流失。选择接收服务器通知以了解何时由于账单问题而导致订阅续订失败，或使用 [获取所有订阅状态](https://developer.apple.com/cn/app-store/subscriptions/#retaining-subscribers) 接口确定订阅是不是由于账单问题而处于计费重试状态。根据上述信息采取相应措施，例如，您可以在 App 中显示信息或发送电子邮件，提醒订阅者更新他们之前登记的付款方式，并提供其 App Store 帐户中“付款信息”区域的链接。一旦问题得到解决，您就可以恢复服务。Apple 将在 60 天内尝试收取付款。如果订阅在 60 天内续订，则付费服务的天数从续订日期开始继续累积。

为避免由于账单问题而导致服务中断，请在 App Store Connect 中启用账单宽限期。Apple 将尝试解决账单问题，并在订阅者保留订阅访问权限的同时恢复订阅。如果订阅在这个期限内恢复，则付费服务天数的计数和您的收入都不会中断。如果用户在 60 天后重新订阅，则付费服务的天数将重置，您将收到一年的标准订阅费用，直到付费服务满一年为止。

- **价格上调同意状态**。当您提高订阅价格时，Apple 会询问受影响的订阅者是否同意这个新价格，您可以在价格变动生效之前跟踪用户的同意状态。在向受影响的用户显示价格上调单之前，您可以显示一条 App 内信息，说明订阅的好处和价值，以及价格上调将如何改善服务。如果用户没有对上调做出反应，他们的订阅将在当前结算周期结束时到期。

简单来说，通过订阅通知，分析用户的忠诚度，根据用户不同的行为习惯和选择决定（通知），然后分析用户行为的背后原因，从而优化开发者的服务，从而提升订阅的忠诚度！


### App Store Connect

App Store 相关的调整不多，都是细节优化。

#### Sandbox & Test

开发人员将能够更轻松地创建沙盒用户，并测试沙盒购买。相比以前少了 `安全提示问题`、`安全提示问题答案`、`出生日期` 三个选项。

![WWDC22-IAP-31](https://ihtcboy.com/images/WWDC22-IAP-31.png)

增加了 `Allow Purchase & Renewals` 开关，用于测试订阅到期自动扣费和失败重试。
![WWDC22-IAP-32](https://ihtcboy.com/images/WWDC22-IAP-32.png)

Xcode StoreKit 测试中添加了更多测试用例，例如退款请求、优惠代码兑换、订阅涨价、账单扣款重试等。这是一个不错的改进，但目前测试内购功能的开发者还不多，详细参考 [What's new in StoreKit testing - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10039/)。

![WWDC22-IAP-33](https://ihtcboy.com/images/WWDC22-IAP-33.png)


#### App Store Connect API

App Store Connect API 增加了查询沙盒账号、清除沙盒内购历史记录、设置中断内购状态等，也增加内购、用户商店评论内容和回复、App 挂起诊断数据等接口。

最重要是，增加了内购项目的创建！

![WWDC22-IAP-34](https://ihtcboy.com/images/WWDC22-IAP-34.png)

内购品项和订阅品项的相关 API：

![WWDC22-IAP-35](https://ihtcboy.com/images/WWDC22-IAP-35.png)

- 新建订阅品项
- 创建、编辑和删除品项
- 管理定价
- 提交审核
- 创建优惠和促销代码

目前截止本文发表，苹果 [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi) 文档，依然还没有看到这些接口的描述！

最后，是苹果弃用 XML 流文档的形式与 App Store Connect 的交互，未来开发者，都需要迁移到 App Store Connect API！
![WWDC22-IAP-36](https://ihtcboy.com/images/WWDC22-IAP-36.png)

这个怎么理解？参考我们之前开源的一款苹果 macOS 工具：《[AppleParty（苹果派）](https://juejin.cn/post/7081069026515877919)》，它使用到了苹果 [Transporter](https://help.apple.com/itc/transporteruserguide/#/itc0d5b535bf) 命令工具，批量上传内购商品列表和上传 IAP 包文件等。预测 [Reporter](https://help.apple.com/itc/appsreporterguide/#/itcbe21ac7db) 和 [altool](https://help.apple.com/asc/appsaltool/#/) 等命令也会被弃用。

苹果表示，今年秋天开始停用 XML 提交，强制推荐使用 App Store Connect API  接口。但目前还没有看到官网相关的说明文档！

#### App Store

今年 [App Store](https://developer.apple.com/app-store/whats-new/) 相关更新，可能最引人关注的功能，就是这个 `Benchmarks in App Analytics`（App 分析中的基准）功能，，基准通过将与获客率、使用和盈利情况相关的绩效指标置于具体情境中，在整个客户旅程期间提供有价值的见解，这样您就可以很容易地看到您与同行相比的表现，并做出相应决策以实现业务目标。

![WWDC22-IAP-37](https://ihtcboy.com/images/WWDC22-IAP-37.png)

查看自己 app 与同行相比的表现，并做出实现业务目标的决策。使用差异隐私技术，以确保机密信息的安全和私密性。苹果表示这个功能明年 2023 年初才上线，目前官方文档也没有找到详细的介绍。差异隐私技术介绍可以参考我们之前的文章《[WWDC22 - Apple 隐私技术探索](https://juejin.cn/post/7116331493659508744)》。


关于 app 数据，Xcode 提供了功率、性能指标和诊断等新接口。

- 分析和解决 App 挂起（hangs：延时、慢、卡顿）
- 查看诊断签名
- 下载详细日志

![WWDC22-IAP-38](https://ihtcboy.com/images/WWDC22-IAP-38.png)

详细功能可以参考：[Identify trends with the Power and Performance API - WWDC20](https://developer.apple.com/videos/play/wwdc2020/10057) 和 [Track down hangs with Xcode and on-device detection - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10082)。


在 [App Store Connect app](https://apps.apple.com/cn/app/app-store-connect/id1234793120) 中可以送审内购、新版本、In-App Event、产品面优化、自定义产品而等。

![WWDC22-IAP-39](https://ihtcboy.com/images/WWDC22-IAP-39.png)

目前苹果支持送审的内容：

![WWDC22-IAP-40](https://ihtcboy.com/images/WWDC22-IAP-40.png)

可以看到 iOS 除了新版本 app 送审，现在支持 In-App Event、自定义产品、产品面优化测试等。而 tvOS 和 macOS 目前还没有，可能明年 WWDC23 应该就支持一波了吧！

另外，需要提示一下，送审新版本 app 、In-App Event、自定义产品、产品面优化测试等，苹果是建议开发者可以合并提交一起送审，因为这样苹果会以当前送审的内容一起审核，提高苹果的审核效率？总之，提审这些项目后，如果有项目审核不通过，可以单独发布审核通过的内容。
![WWDC22-IAP-41](https://ihtcboy.com/images/WWDC22-IAP-41.png)

关于 App Store 的优化，2022 年 1 月 20 日 [推出适用于订阅的自定优惠代码](https://developer.apple.com/cn/news/?id=9sjl5wuv)，开发者可以自定义，如 `VIP888` 的优惠代码，用于推广活动，自定代码可通过直接 URL 或在您的 app 中兑换。2022 年 4 月 29 日 [阐明 App Store 改善流程的标准和新的限期延长](https://developer.apple.com/cn/news/?id=gi6npkmf)，苹果明确了 App 长期不更新被下架的细则，当一款 App 在过去三年内从未更新且未达到最低下载量 (即该 App 在连续 12 个月内完全没有或只有极低的下载量) 时，其开发者将会收到电子邮件，告知该 App 已被识别并可能从 App Store 中被移除，开发者收到通知起，有 90 天的时间来更新他们的 App。


### 总结

关于 In App Purchase 和 App Store，随着这几年苹果的开放，已经很大程度上解决了开发者大多数的问题，从退款查询到所有订单查询，从被动通知到主动获取通知，从内购税率降低到提高 App 曝光量，苹果已经提供了非常多的接口、案例展示和建议。比如，自动续期订阅类型，目前已经复杂到不能再复杂，订阅群组、免费试用期限、推介促销优惠、促销优惠、优惠代码、计费重试、重新激活、续期等。

最后，大家觉得 `In App Purchase` 和 `App Store` 还有什么疑惑或痛点吗？

欢迎大家评论区一起讨论交流~

> 欢迎关注我们，了解更多 iOS 和 Apple 的动态~


### 参考引用

- [苹果iOS内购三步曲：App内退款、历史订单查询、绑定用户防掉单！--- WWDC21 - 掘金](https://juejin.cn/post/6974733392260644895)
- [App Store Small Business Program 公布 - Apple Developer](https://developer.apple.com/cn/news/?id=i7jzeefs)
- [注册新的 App Store Small Business Program - Apple Developer](https://developer.apple.com/cn/news/?id=6lyxewwp)
- [全新的 App Store 小型企业计划让开发者看到无尽可能 - Apple (中国大陆)](https://www.apple.com.cn/newsroom/2020/11/developers-see-a-world-of-possibilities-with-new-app-store-small-business-program/)
- [App Store Small Business Program - Apple Developer](https://developer.apple.com/cn/app-store/small-business-program/)
- [要求在线团体活动需使用 App 内购买方式的截止日期已延长 - Apple Developer](https://developer.apple.com/cn/news/?id=kw16tplo)
- [针对在线团体活动服务的 app 内购买项目规定更新 - Apple Developer](https://developer.apple.com/cn/news/?id=6qfoid1d)
- [针对在线多人活动的 app 内购买项目规定提醒 - Apple Developer](https://developer.apple.com/cn/news/?id=yeyd5xuh)
- [App Store 审核指南 - Apple Developer](https://developer.apple.com/cn/app-store/review/guidelines/#in-app-purchase)
- [Apple 与美国开发者就 App Store 更新达成一致 - Apple (中国大陆)](https://www.apple.com.cn/newsroom/2021/08/apple-us-developers-agree-to-app-store-updates/)
- [小型业务开发者协助申请提交将于 5 月 20 日截止 - Apple Developer](https://developer.apple.com/cn/news/?id=r24k5i3m)
- [Cameron et al. v. Apple Inc.](https://smallappdeveloperassistance.com/)
- [日本公平贸易委员会结束对 App Store 的调查 - Apple (中国大陆)](https://www.apple.com.cn/newsroom/2021/09/japan-fair-trade-commission-closes-app-store-investigation/)
- [“阅读器”app 分发的更新 - Apple Developer](https://developer.apple.com/cn/news/?id=grjqafts)
- [Update on dating apps distributed on the App Store in the Netherlands - Apple Developer](https://developer.apple.com/news/?id=mbbs4zql)
- [Distributing dating apps in the Netherlands - Apple Developer](https://developer.apple.com/cn/support/storekit-external-entitlement/)
- [Additional details available for dating apps in the Netherlands - Apple Developer](https://developer.apple.com/news/?id=uub8j2f1)
- [Update on StoreKit External Entitlement for dating apps - Apple Developer](https://developer.apple.com/news/?id=jmps5hyj)
- [Further updates on StoreKit External Entitlement for dating apps in the Netherlands storefront - Latest News - Apple Developer](https://developer.apple.com/news/?id=3bttqj0z)
- [订阅通知更新 - 最新动态 - Apple Developer](https://developer.apple.com/cn/news/?id=tpgp89cl)
- [管理自动续期订阅的定价 - App Store Connect 帮助](https://help.apple.com/app-store-connect/?lang=zh-cn#/devc9870599e)
- [针对在韩国分发 App 的更新 - Apple Developer](https://developer.apple.com/cn/news/?id=q0feipe4)
- [Distributing apps using a third-party payment provider in South Korea - Apple Developer](https://developer.apple.com/cn/support/storekit-external-entitlement-kr/)
- [AppTransaction | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/apptransaction)
- [Message | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/message)
- [applicationUsername | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skmutablepayment/1506088-applicationusername)
- [appAccountToken | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/transaction/3749684-appaccounttoken)
- [External Purchase | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/external_purchase)
- [External Link Account | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/external_link_account)
- [App Store Server API | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi)
- [App Store Server Notifications | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications)
- [App Store Connect API | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi)
- [WWDC21 - App Store Server API 实践总结 - 掘金](https://juejin.cn/post/7056976669139009573)
- [开源一款苹果 macOS 工具 - AppleParty（苹果派） - 掘金](https://juejin.cn/post/7081069026515877919)
- [WWDC22 - Apple 隐私技术探索 - 掘金](https://juejin.cn/post/7116331493659508744)
- [Transporter 用户指南](https://help.apple.com/itc/transporteruserguide/#/itc0d5b535bf)
- [altool 指南](https://help.apple.com/asc/appsaltool/#/)
- [Reporter 用户指南](https://help.apple.com/itc/appsreporterguide/#/itcbe21ac7db)
- [充分利用 App Store - Apple Developer](https://developer.apple.com/cn/app-store/)
- [自动续期订阅 - App Store - Apple Developer](https://developer.apple.com/cn/app-store/subscriptions/)
- [阐明 App Store 改善流程的标准和新的限期延长 - Apple Developer](https://developer.apple.com/cn/news/?id=gi6npkmf)
- [现已推出适用于订阅的自定优惠代码 - Apple Developer](https://developer.apple.com/cn/news/?id=9sjl5wuv)

> 注：如若转载，请注明来源。