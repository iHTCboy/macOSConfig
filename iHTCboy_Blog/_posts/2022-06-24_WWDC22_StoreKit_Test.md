title: WWDC22 10039 - Xcode StoreKit 测试的新功能
date: 2022-06-24 23:14:10
categories: technology #induction life poetry
tags: [WWDC22,Xcode,StoreKit Testing]  # <!--more-->
reward: true

---

> 本文是《WWDC22 内参》参与创作者，首发于 [【WWDC22 10039】Xcode StoreKit 测试的新功能 － 小专栏](https://xiaozhuanlan.com/topic/5842093617)。

基于 [Session 10039](https://developer.apple.com/videos/play/wwdc2022/10039/) 梳理

> 作者：iHTCboy，目前就职于三七互娱37手游，从事游戏 SDK 开发多年，对 IAP 和 SDK 架构设计有丰富的实践经验。
>
> 审核：
> 黄骋志（橙汁），老司机技术社区核心成员，现于西瓜视频负责稳定性 OOM/Watchdog 相关工作。
> 
> SeaHub，目前任职于腾讯 TEG 计费平台部，负责搭建服务于腾讯系业务的支付组件 SDK，对 IAP 相关内容及 SDK 设计开发有一定的经验。
> 
> 王浙剑（Damonwong），老司机技术社区负责人、WWDC22 内参主理人，目前就职于阿里巴巴。

<!--more-->

![WWDC22-Xcode-StoreKit-Testing-00](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-00.png)

## 1、前言

在 Xcode 12 之前，App 内购买项目是不能在 Xcode 模拟器中进行购买，只能使用真机进行测试内购充值，因为模拟器无法连接到 App Store 服务器进行交易。苹果在 WWDC20 推出了 [StoreKit Testing](https://developer.apple.com/videos/play/wwdc2020/10659)，通过 Xcode 12 创建 StoreKit 配置文件和搭建本地测试环境，实现本地 App 内购买和验证收据等测试流程，而无需依赖 App Store 服务器。而今年的 WDC22 苹果对 StoreKit 测试流程改进完善，包含 Xcode 14 中测试功能的优化，支持订阅商品更多场景的测试，还有 StoreKit 配置文件通过 App Store Connect 自动同步等等。

![WWDC22-Xcode-StoreKit-Testing-01](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-01.png)

## 2、回顾 StoreKit Testing 功能

### 2.1 StoreKit App 内购买的测试方式

在讲解 StoreKit 测试的新功能之前，小编先带大家回顾一下 StoreKit 测试的历史流程，这样我们才能理解这个新功能的改进的意义。在苹果文档 [Original API for In-App Purchase](https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase) 中有这样的一张图：

![WWDC22-Xcode-StoreKit-Testing-02](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-02.png)

从这张图可以看出 StoreKit API 的测试必须依赖四方：

- 开发者 app
- 开发者服务器
- StoreKit
- App Store 服务器

这样互相循环依赖的关系，导致开发者需要测试 StoreKit 功能就非常的被动，**主要的问题是依赖 App Store 服务器**，一方面是 StoreKit 内购买需要通过 App Store 服务器创建交易（transaction），另一方面是开发者需要通过 App Store 服务器来校验票据（receipt）。而在 Xcode 和模拟器中，StoreKit 并不支持 App Store 服务器交互，导致无法完成流程的闭环。

![WWDC22-Xcode-StoreKit-Testing-03](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-03.png)

所以，要测试 App 内购买功能有以下三种测试环境：

- `Production`：生产环境，也就是 App Store 下载的 app，需要使用真钱才能进行测试。
- `Sandbox`：沙盒环境，开发者用 Development 或 Ad Hoc 证书打包调试时， 在真机中可以进行 App 内购买测试，但需要登录沙盒测试账号。
- `TestFlight`：测试环境，面向外部测试员，App 内购买项目使用的是沙盒环境，但不需要测试员登录沙盒测试账号。

### 2.2 Xcode 中 StoreKit Testing 功能

苹果在 WWDC20 推出了 [StoreKit Testing](https://developer.apple.com/videos/play/wwdc2020/10659)，它的目的是脱离 App Store 服务器，让开发者本地就能完成 App 内购买流程。原理是，Xcode 中创建一个 `StoreKit Configuration File` 本地配置文件，Xcode 通过这个配置文件模拟 StoreKit 与 App Store 服务器的交互流程，从而实现在 Xcode 模拟器中发起 App 内购买操作。

具体的操作是在 Xcode 项目中新建文件，选择创建 `StoreKit Configuration File`，然后选中生成 `.storekit` 后缀的文件，点击左下角的 `+` 可以选择创建商品类型，根据需要填写要测试的商品信息。

![WWDC22-Xcode-StoreKit-Testing-04](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-04.png)

要启动 StoreKit Testing 功能，需要在项目的 `Edit Scheme` 中切换到 `Run` 栏中的 `Options` 标签，再在 `StoreKit Configuration` 中选中需要测试的 StoreKit 配置文件即可。然后运行项目后，在 Xcode 的调试栏中点击 `Manage StoreKit Transactions` 图标，可以打开订单交易管理界面，可以对交易的任一订单进行删除、退款、中断、同意或拒绝购买等操作。

![WWDC22-Xcode-StoreKit-Testing-05](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-05.png)

Xcode 本地创建和生成的交易订单的票据是使用单独的 RSA 密钥生成，使用 `PKCS7` 填充算法，公钥可以在 Xcode 的 `Editor` 菜单栏中 `Save Public Certificate` 导出。
![WWDC22-Xcode-StoreKit-Testing-06](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-06.png)

另外，苹果推出了 [StoreKitTest Framework](https://developer.apple.com/documentation/storekittest) 用于在 Xcode 中编写单元测试和持续集成测试，以实现 StoreKit 自动化测试。简单的一个测试用例如下：

```swift
import XCTest
import StoreKitTest


class InAppPurchaseTests: XCTestCase {
    private let store = Store()
    private var testSession: SKTestSession!
    
    func testRecipeUnlock() throws {
        let session = try SKTestSession(configurationFileNamed: "NonConsumable")
        session.disableDialogs = true
        session.clearTransactions()
        
        buyProduct(Smoothie.thatsBerryBananas.productID)
        
        let contentAvailable = store.receiptContains(productIdentifier: Smoothie.thatsBerryBananas.productID)
        
        XCTAssertTrue(contentAvailable, "Expected content for \(Smoothie.thatsBerryBananas.productID) is not available")
    }
}

```

最后，关于 WWDC20 [StoreKit Testing](https://developer.apple.com/videos/play/wwdc2020/10659) 的详细介绍，可以参考我们之前的文章 [WWDC20 - 介绍 Xcode 中的 StoreKit 测试](https://xiaozhuanlan.com/topic/1950472863)。

## 3、Xcode 14 中 StoreKit Testing 新功能

目前 Xcode 中 StoreKit 测试新流程如下图：

![WWDC22-Xcode-StoreKit-Testing-07](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-07.png)

开发者可以串联 Xcode、App Store Connect、TestFlight、App Store 实现完整的流程，StoreKit 在沙盒和 Xcode 中的测试。

### 3.1 支持 StoreKit 的配置文件从 App Store Connect 同步

我们上面讲到的 StoreKit Configuration 文件的创建和配置，其实是比较麻烦的，因为开发者在 App Store Connect 创建 App 之后需要创建配置 App 内购买商品，然后在 Xcode 中创建 StoreKit Configuration 文件后，还需要把全部的商品信息再配置一次，对于开发者来说是非常麻烦的重复事情。

在 Xcode 14 中，苹果解决了 StoreKit Configuration 文件需要手动配置的商品的问题，开发者在创建时 StoreKit Configuration 文件时，可以选择勾选 `Sync this file with an app in App Store Connect`，然后选择开发者团队和 App ，就可以从 AppStore Connect 拉取已经填好参数的配置文件，同时配置文件也可以进行更新，具体看下文介绍。
![WWDC22-Xcode-StoreKit-Testing-08](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-08.png)

> 这里选择的 App 主要目的是确认同步那个 App 的商品信息，不需要与当前项目的 App（Bundle ID）一致，也能同步商品信息下来。

App Store Connect 同步的 StoreKit Configuration 文件，只能点击刷新按钮同步最新的商品更新信息，而不能在 Xcode 中修改。如果需要本地修改，可以选择配置文件后，点击 Xcode 的 `Editor` 菜单栏中 `Convert to Local StoreKit Configuration` 转换成本地配置文件，转换成功后将不能在从 App Store Connect 中同步了。

![WWDC22-Xcode-StoreKit-Testing-09](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-09.png)

如果转换成本地配置文件，Xcode 会有一个警告提醒，点击 `Conver File` 才能转换成功。另外，如果不想转换，可以点击某个商品的配置，然后复制粘贴到其它的本地配置文件中，这里就不在赘述。

**同步文件的区别**

其实 StoreKit Configuration 是一个 `json` 格式的配置文件。

未勾选同步时，创建的 StoreKit 配置文件内容：

```json
{
  "identifier" : "EDA3AE34",
  "nonRenewingSubscriptions" : [

  ],
  "products" : [

  ],
  "settings" : {

  },
  "subscriptionGroups" : [

  ],
  "version" : {
    "major" : 2,
    "minor" : 0
  }
}
```

创建同步的 StoreKit 配置文件（未点击同步前）的内容：

```json
{
  "identifier" : "9F120B79",
  "nonRenewingSubscriptions" : [

  ],
  "products" : [

  ],
  "settings" : {
    "_applicationInternalID" : "914453386",
    "_developerTeamID" : "28PV6G9666"
  },
  "subscriptionGroups" : [

  ],
  "version" : {
    "major" : 2,
    "minor" : 0
  }
}
```

> 从内容上可以猜到，`identifier` 表示配置文件的唯一标识，`_applicationInternalID` 表示 `app id`，而 `_developerTeamID` 表示开发者的团队唯一标识。

苹果是用 `settings` 字段里的 `_applicationInternalID` 和 `_developerTeamID` 这两个键值共同来判断是本地的还是同步的配置文件：

```json
 "settings" : {
    "_applicationInternalID" : "914453386",
    "_developerTeamID" : "28PV6G9666"
  },
```

直接修改本地的配置文件，可以实现同步 AppStore Connect 的配置。但是需要注意，本地配置的商品信息会被删除，覆盖来 AppStore Connect 配置的商品信息。

一个同步后的 StoreKit 配置文件的内容示例：

```json
{
  "identifier" : "02ECE2F0",
  "nonRenewingSubscriptions" : [

  ],
  "products" : [
    {
      "displayPrice" : "0.99",
      "familyShareable" : false,
      "internalID" : "1545378276",
      "localizations" : [
        {
          "description" : "加餐：给开发者打赏一个鸡腿",
          "displayName" : "1个鸡腿",
          "locale" : "zh_CN"
        }
      ],
      "productID" : "com.iHTCboy.chicken",
      "referenceName" : "一个鸡腿",
      "type" : "Consumable"
    },
    {
      "displayPrice" : "1.99",
      "familyShareable" : false,
      "internalID" : "1545827693",
      "localizations" : [
        {
          "description" : "加餐：给开发者打赏一杯咖啡",
          "displayName" : "一杯咖啡",
          "locale" : "zh_CN"
        }
      ],
      "productID" : "com.iHTCboy.coffee",
      "referenceName" : "一杯咖啡",
      "type" : "Consumable"
    }
  ],
  "settings" : {
    "_applicationInternalID" : "914453386",
    "_developerTeamID" : "28PV6G9666",
    "_lastSynchronizedDate" : 679737877.04214501
  },
  "subscriptionGroups" : [
    {
      "id" : "20919269",
      "localizations" : [

      ],
      "name" : "VIP",
      "subscriptions" : [
        {
          "adHocOffers" : [

          ],
          "codeOffers" : [

          ],
          "displayPrice" : "1.99",
          "familyShareable" : false,
          "groupNumber" : 1,
          "internalID" : "1606645471",
          "introductoryOffer" : null,
          "localizations" : [

          ],
          "productID" : "com.iHTCboy.month",
          "recurringSubscriptionPeriod" : "P1M",
          "referenceName" : "高级月卡",
          "subscriptionGroupID" : "20919269",
          "type" : "RecurringSubscription"
        }
      ]
    }
  ],
  "version" : {
    "major" : 2,
    "minor" : 0
  }
}
```

同步的 StoreKit 配置文件与不同步的 StoreKit 配置文件的商品内容格式是一样的，这里就不在赘述。

### 3.2 本地订单交易管理器（the transaction manager）

之前的 Xcode 订单交易管理界面，可以对交易的任一订单进行删除、退款、中断、同意或拒绝购买等操作。

![WWDC22-Xcode-StoreKit-Testing-10](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-10.png)

Xcode 14 中，点击某个交易订单，可以看到右侧栏会显示商品的交易详细信息，如果是订阅商品还包含订阅过期时间、续订时间等等。另外底部新增搜索栏，可以搜索商品的 ID 或交易时间等。

## 4、StoreKit Testing 的改进案例

那么如何结合 Xcode 进行 StoreKit 测试，如果之前大家没有尝试过，看看这几个案例就能大概学会啦。

- 退款测试（Refund requests）
- 优惠代码测试（Offer codes）
- 订阅涨价测试（Price increases）
- 扣费重试和宽限期（Billing retry and grace period)

### 4.1 退款测试（Refund requests）

在 iOS 15 苹果提供了 app 里申请退款的接口：

![WWDC22-Xcode-StoreKit-Testing-11](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-11.png)

在 SwiftUI 中使用 [refundRequestSheet(for:isPresented:onDismiss:)](https://developer.apple.com/documentation/swiftui/view/refundrequestsheet(for:ispresented:ondismiss:)) 接口实现退款的示例：

```swift
struct RefundView: View {
    @State private var selectedTransactionID: UInt64?
    @State private var refundSheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            refundSheetIsPresented = true
        } label: {
            Text("Request a refund")
                .bold()
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding([.horizontal, .bottom])
        .disabled(selectedTransactionID == nil)
        .refundRequestSheet(
            for: selectedTransactionID ?? 0,
            isPresented: $refundSheetIsPresented
        ) { result in
            if case .success(.success) = result {
                dismiss()
            }
        }
    }
}
```

而在本地订单交易管理器，也可以点击 `Refund Purchases` 图标进行退款。

![WWDC22-Xcode-StoreKit-Testing-12](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-12.png)

那么退款成功后，开发者需要处理退款后的 app 的业务逻辑测试，在 StoreKit 2 中，使用 `Transaction.updates` 监听所有交易的更新，更新交易的 [revocationReason](https://developer.apple.com/documentation/storekit/transaction/revocationreason) 字段是一个结构体，其中 `.developerIssue` 和 `.other` 与上上图中可选择的退款原因是相对应的，所以开发者很容易对这两个撤销原因进行测试。

```swift
for await update in Transaction.updates {
    let transaction = try update.payloadValue
  
    if let revocationDate = transaction.revocationDate,
  	   let revocationReason = transaction.revocationReason {
        print("\(transaction.productID) revoked on \(revocationDate)")
       
        switch revocationReason {
        case .developerIssue: <#Handle developer issue#>
        case .other: <#Handle other issue#>
        default: <#Handle unknown reason#>
        }
        
        <#Revoke access to the product#>
    }
    <#...#>
}
```

最后，退款测试的环境要求如下：

|  | Xcode | Sandbox |
|---|---|---|
| iOS and iPadOS | 15.2 | 15.0 |
| macOS | 12.1 | 12.0 |

### 4.2 优惠代码测试（Offer codes）

关于 `Offer codes`（优惠代码）我们这里就略过了，读者可以查看苹果文档了解 [优惠代码](https://developer.apple.com/cn/app-store/subscriptions/#offer-types)。

优惠代码测试的测试，首先是在 StoreKit 配置文件的订阅商品中点击添加 Offer Codes 栏的 `+` 进行配置：

![WWDC22-Xcode-StoreKit-Testing-13](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-13.png)

在 iOS 14 中就增加 [presentCodeRedemptionSheet()](https://developer.apple.com/documentation/storekit/skpaymentqueue/3566726-presentcoderedemptionsheet) 接口，实现 app 内兑换优惠代码：

![WWDC22-Xcode-StoreKit-Testing-14](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-14.png)

而在 SwiftUI 中需要 iOS 16+ 中通过 [offerCodeRedemption(isPresented:onCompletion:)](https://developer.apple.com/documentation/swiftui/view/offercoderedemption(ispresented:oncompletion:)) 接口实现 App 内兑换优惠代码的示例：

```swift
struct SubscriptionPurchaseView: View {
    @State private var redeemSheetIsPresented = false
        
    var body: some View {
        Button("Redeem an offer") {
            redeemSheetIsPresented = true
        }
        .buttonStyle(.borderless)
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .offerCodeRedeemSheet(isPresented: $redeemSheetIsPresented)
    }

}
```

兑换优惠代码成功的交易，可以在本地订单交易管理器，交易订单的右侧栏 `Renewals` 标签中，看到订阅更新的信息。
![WWDC22-Xcode-StoreKit-Testing-15](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-15.png)

那么开发者需要处理兑换优惠代码后的 app 的业务逻辑测试，在 StoreKit 2 中，使用 `Transaction.updates` 和 `Product.SubscriptionInfo.Status.updates` 监听所有订阅商品交易的状态更新：

```swift
for await verificationResult in Transaction.updates {
    guard case .verified(let transaction) = verificationResult else {
        <#Handle failed verification#>
    }
    <#Handle updated transaction#>
}

for await updatedStatus in Product.SubscriptionInfo.Status.updates {
    guard case .verified(let renewalInfo) = updatedStatus.renewalInfo else {
        <#Handle failed verification#>
    }
    <#Handle updated status#>
}
```

其中 `Product.SubscriptionInfo.Status.updates` 接口中返回的交易字段 `offerType` 可以确认订阅的优惠类型，关于 [OfferType](https://developer.apple.com/documentation/storekit/transaction/offertype) 优惠类型可以阅读文档：[优惠类型](https://developer.apple.com/cn/app-store/subscriptions/#offer-types)。

```swift
for await status in Product.SubscriptionInfo.Status.updates {
    let transaction = try status.transaction.payloadValue
    let renewalInfo = try status.renewalInfo.payloadValue
    
    <#Check active current offer#>
    
    if let nextOfferType = renewalInfo.offerType {
        switch currentType {
        case .introductory: <#Handle introductory offer#>
        case .promotional: <#Handle promotional offer#>
        case .code:
            print("Customer has \(renewalInfo.offerID) queued")
            <#Handle offer for codes#>
        default: <#Handle unknown offer type#>
        }
        self.hasQueuedOffer = true
    }
    <#...#>
}
```

优惠代码（Offer Codes）测试的 StoreKit 配置在 Xcode 13.3+ 以上就可以设置，所以搭配的测试的设备系统必须是 iOS 15.4 或 iPadOS 15.4 以上。

### 4.3 订阅涨价测试（Price increases）

随着 App 订阅的流行，很多 App 的订阅可能因为业务或者服务器成本等原因，提高订阅价格。而部分订阅涨价需要用户同意才能续订，今年 WWDC22 苹果推出了 StoreKit Message 接口，开发者可以在 app 内显示涨价提示：

![WWDC22-Xcode-StoreKit-Testing-16](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-16.png)

关于 StoreKit Message 接口介绍，可以参考 [WWDC22 - 探索 In-App Purchase 新特性](https://mp.weixin.qq.com/s/zzeFoUKA7jXcCaKtcgaiiQ)。StoreKit Message 接口代码示例：

```swift
private var pendingMessages: [Message] = []

private func updatesLoop() {
    for await message in Message.messages {
      if <#Check if sensitive view is presented#>,
         let display: DisplayMessageAction = <#Get display message action#> {
           try? display(message)
      }
      else {
        pendingMessages.append(message)
      }
    }
}
```

关于提高自动续期订阅价格可以参考文档：

- [管理自动续期订阅的定价 - App Store Connect 帮助](https://help.apple.com/app-store-connect/#/devc9870599e)
- [订阅通知更新 - Apple Developer](https://developer.apple.com/cn/news/?id=tpgp89cl)

那么，要怎么提高自动续期订阅价格，在本地订单交易管理器可以点击图标或者右键点击 `Request Price Increase Consent` 按钮，这样就表示这个商品要提高下一个订阅周期的订阅价格：

![WWDC22-Xcode-StoreKit-Testing-17](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-17.png)

因为除了利用 StoreKit Message 提示弹窗中点击同意涨价外，用户也可能会通过电子邮件等其它方式对价格上涨做出选择，所以为了模拟这个场景，可以在本地订单交易管理器，点击 `Approve`（批准）和 `Decline`（拒绝）按钮来模拟用户的选择。

![WWDC22-Xcode-StoreKit-Testing-18](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-18.png)

最后，可以通过 `priceIncreaseStatus` 判断用户是否同意涨价，通过 `expirationReason` 字段的 `.didNotConsentToPriceIncrease` 类型判断用户没有同意涨价。在 StoreKit 2 和 iOS 15 实现的代码示例：

```swift
for await status in Product.SubscriptionInfo.Status.updates {
    let renewalInfo = try status.renewalInfo.payloadValue

    if renewalInfo.priceIncreaseStatus == .agreed {
        print("Customer consented to price increase")
        <#Handle consented to price increase#>
    }
    if renewalInfo.expirationReason == .didNotConsentToPriceIncrease {
        print("Customer did not consent to price increase")
        <#Handle expired due to not consenting to price increase#>
    }

    <#...#>

}
```

使用 iOS 15.4 可以在 [StoreKitTest Framework](https://developer.apple.com/documentation/storekittest) 中编写单元测试代码进行涨价测试：

```swift
let session: SKTestSession = try SKTestSession(configurationFileNamed: "<#Configuration name#>")
session.disableDialogs = true

<#Purchase a subscription#>

var transaction: SKTestTransaction! = session.allTransactions().first
session.requestPriceIncreaseConsentForTransaction(identifier: transaction.identifier)

transaction = session.allTransactions().first
XCTAssertTrue(transaction.isPendingPriceIncreaseConsent)

<#Assert app updates for pending price increase#>

// Write a test case for consenting and cancelling due to price increase:

session.consentToPriceIncreaseForTransaction(identifier: transaction.identifier)

// OR

session.declinePriceIncreaseForTransaction(identifier: transaction.identifier)
session.expireSubscription(productIdentifier: "<#Product ID#>")

<#Assert app updates for finished price increase#>
```

订阅涨价测试支持在 Xcode 13.3 以上使用：

|  | Status | Message |
|---|---|---|
| iOS and iPadOS | 15.4 | 有 |
| macOS | 12.3 | 无 |
| watchOS | 8.5 | 无 |
| tvOS | 15.4 | 无 |

> 注：其中 StoreKit Message 功能只有 iOS 16 或 iPadOS 16 以上支持，其它系统暂不支持。

### 4.4 扣费重试和宽限期（Billing retry and grace period)

扣费重试一般是出现在玩家的银行卡信息过期或者绑定的支付方式过期或撤销等，导致订阅无法按时续期，系统会进行扣费重试。如果重试扣费成功，或者用户续费，则订阅续订成功：

![WWDC22-Xcode-StoreKit-Testing-19](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-19.png)

默认情况下扣费重试阶段，用户的订阅服务已经过期，导致用户无法使用服务。为了解决扣费重试阶段，用户还能享受订阅服务，苹果提供了一个过渡阶段：`Grace period`（宽限期），在宽限期内订阅服务可继续享受。

![WWDC22-Xcode-StoreKit-Testing-20](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-20.png)

要实现扣费重试和宽限期的测试，可以在 Xcode 中分别选择 `Enable Billing Retry on Renewal` 和 `Enable Billing Grace Period`：

![WWDC22-Xcode-StoreKit-Testing-21](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-21.png)

> 注：为了加速订阅过期时间，可以在 `Subscription Renewal Rate` 选择更快的订阅过期时间，这样更快的进入模拟的测试阶段。

最后，要模拟解决扣费失败后成功的场景，可以在本地订单交易管理器中，点击 `Resolve Issues` 表示解决扣费问题，让扣费成功后进入到下一个订阅周期中。

![WWDC22-Xcode-StoreKit-Testing-22](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-22.png)

在代码逻辑中处理，`gracePeriodExpirationDate` 字段的时间小于当前时间，就表示订阅在宽限期内，允许用户继续享受订阅服务。而 `isInBillingRetry` 字段，则表示扣费重试阶段。

```swift
for await status in Product.SubscriptionInfo.Status.updates {
    let renewalInfo = try status.renewalInfo.payloadValue

    if let gracePeriodExpirationDate = renewalInfo.gracePeriodExpirationDate,
       gracePeriodExpirationDate < .now {
        print("In grace period until \(gracePeriodExpirationDate)”)
        <#Allow access to subscription#>
    }
    else if renewalInfo.isInBillingRetry {
        <#Handle billing retry#>
    }

    <#...#>

}
```

在订阅扣费重试阶段，可以提示或引导用户解决扣费失败的问题。具体来说，可以引导用户打开链接 `https://apps.apple.com/account/billing` 会跳转到 App Store 用户账号的 `管理付款方式`，从而解决问题。

```swift
struct SubscriptionStatusView: View {
    let currentSubscription: Product
    let status: Product.SubscriptionInfo.Status
    @Environment(\.openURL) var openURL
    var body: some View {
        Section("Your Subscription") {
            <#...#>
            if status.state == .inBillingRetryPeriod || status.state == .inGracePeriod {
                VStack {
                    Text("""
                    There was a problem renewing your subscription. Open the App Store to
                    update your payment information.
                    """)
                    Button("Open the App Store") {
                        openURL(URL(string: "https://apps.apple.com/account/billing")!)
                    }
                }
            }
        }
    }
}
```

使用 iOS 15.4 以上可以用 [StoreKitTest Framework](https://developer.apple.com/documentation/storekittest) 中编写单元测试代码实现扣费重试测试：

```swift
let session: SKTestSession = try SKTestSession(configurationFileNamed: "<#Configuration name#>")
session.billingGracePeriodIsEnabled = true
session.shouldEnterBillingRetryOnRenewal = true

<#Purchase a subscription#>

wait(for: [<#XCTExpectation#>], timeout: 60)

let transaction: SKTestTransaction! = session.allTransactions().first
XCTAssertTrue(transaction.hasPurchaseIssue)

<#Assert app still allows access to subscription due to grace period#>

wait(for: [<#XCTExpectation#>], timeout: 60)

<#Assert app detects billing retry and no longer allows access to subscription#>

session.resolveIssueForTransaction(identifier: transaction.identifier)

<#Assert app allows access to subscription#>
```

订阅扣费重试测试支持在 Xcode 13.3 以上使用：

|  | Xcode 13.3 | Sandbox |
|---|---|---|
| iOS and iPadOS | 15.4 | 16.0 |
| macOS | 12.3 | 无 |
| watchOS | 8.5 | 无 |
| tvOS | 15.4 | 无 |
| Server | N/A | 有 |

> 注：订阅扣费重试，Sandbox 环境下，苹果会发送 App Store Server Notifications 订阅状态变更的通知，如 `DID_FAIL_TO_RENEW`/`EXPIRED`/`BILLING_RETRY`。而 Xcode 环境测试则不会有通知。

## 5、沙盒测试环境的更新

在 iOS 12 之前沙盒账号测试内购买需要先登出 App Store 账号，在 iOS 12 开始，苹果才提供了单独的沙盒测试账号入口：

![WWDC22-Xcode-StoreKit-Testing-23](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-23.png)

### 5.1 沙盒 Apple ID 创建

开发人员可以更轻松地创建沙盒账号，相比以前少了 `安全提示问题`、`安全提示问题答案`、`出生日期` 三个选项。另外，密码强度不满足时会有提示语。

![WWDC22-Xcode-StoreKit-Testing-24](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-24.png)

### 5.2 App Store Connect API

App Store Connect API 新支持：

- 查询沙盒账号
- 清除沙盒账号的内购买历史记录
- 设置沙盒账号的购买中断状态

### 5.3 账单扣费失败模拟（Billing failure simulation）

简单来说，沙盒测试账号中增加了 `Allow Purchase & Renewals` 开关，用于测试订阅到期自动扣费和失败重试。

![WWDC22-Xcode-StoreKit-Testing-25](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-25.png)

比如当关闭这个按钮时，表示自动续订失败，订阅状态会进入扣费重试和宽限期中，此时就可以在沙盒环境中测试。

如果是 App Store Server Notifications V2 会收到 `DID_FAIL_TO_RENEW` `GRACE_PREIOD` 宽限期的通知：

![WWDC22-Xcode-StoreKit-Testing-26](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-26.png)

开发者也可能通过 App Store Server API 主动查询订阅状态：

![WWDC22-Xcode-StoreKit-Testing-27](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-27.png)

如果是 Original StoreKit API，则通过苹果票据验证接口获取状态：

![WWDC22-Xcode-StoreKit-Testing-28](https://ihtcboy.com/images/WWDC22-Xcode-StoreKit-Testing-28.png)

## 6、总结

关于 StoreKit 和 In-App Purchase 测试，一般开发者会更加关注在 Sandbox（沙盒环境）下测试 App 内购买功能，因为这与 Production（生产环境）的区别最小，但是测试流程比较麻烦，需要开发者证书、沙盒测试账号登录等，开发者账号还必须成功绑定银行卡信息后才能调试内购买功能。如果是订阅类型的商品，还需要覆盖测试的场景非常多，测试起来更加的麻烦。

从上文的案例和代码示例可以知道，StoreKit Testing 借助 SwiftUI 和 StoreKit 2，让测试流程的实现技术更加自然。一方面是 SwiftUI 可以快速构建 UI 界面，更容易实现商品页面的展示和调整；另一方面 StoreKit 2 的 JWS transaction 票据不需要通过苹果的 StoreKit 服务器验证，更方便实现票据的校验流程。所以，对于新项目，或者使用 StoreKit 2 改造内购买逻辑流程时，使用 StoreKit Testing 将会大大提高代码测试的效率。

所以基于 Xcode 的 [StoreKit Testing](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode) 和 [StoreKitTest Framework](https://developer.apple.com/documentation/storekittest) 框架，开发者有了更加高效的测试方式。而今年 WWDC22 改进后更加方便和高效，开发者无需关注证书配置和沙盒环境账号等，就能实现本地的内购买测试，对于需要验证某个商品购买逻辑完备性，或 App 新增加内购买功能时，只需要闭环本地的代码逻辑而无需验证票据等，StoreKit 本地测试会更加顺畅，建议读者可以尝试使用！

## 7、参考链接

- [What's new in StoreKit testing - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10039/)
- [Introducing StoreKit Testing in Xcode - WWDC20](https://developer.apple.com/videos/play/wwdc2020/10659)
- [WWDC20 10659 - 介绍 Xcode 中的 StoreKit 测试 － 小专栏](https://xiaozhuanlan.com/topic/1950472863)
- [聚焦探索 In-App Purchase 新特性](https://mp.weixin.qq.com/s/zzeFoUKA7jXcCaKtcgaiiQ)
- [管理自动续期订阅的定价 - App Store Connect 帮助](https://help.apple.com/app-store-connect/#/devc9870599e)
- [订阅通知更新 - 最新动态 - Apple Developer](https://developer.apple.com/cn/news/?id=tpgp89cl)
- [refundRequestSheet(for:isPresented:onDismiss:) | Apple Developer Documentation](https://developer.apple.com/documentation/swiftui/view/refundrequestsheet(for:ispresented:ondismiss:))
- [Transaction.RevocationReason | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/transaction/revocationreason)
- [presentCodeRedemptionSheet() | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skpaymentqueue/3566726-presentcoderedemptionsheet)
- [offerCodeRedemption(isPresented:onCompletion:) | Apple Developer Documentation](https://developer.apple.com/documentation/swiftui/view/offercoderedemption(ispresented:oncompletion:))
- [Product.SubscriptionInfo.Status | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/product/subscriptioninfo/status)
- [StoreKit Test | Apple Developer Documentation](https://developer.apple.com/documentation/storekittest)
- [Testing in-app purchases in Xcode | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/testing_in-app_purchases_in_xcode)
- [Setting Up StoreKit Testing in Xcode | Apple Developer Documentation](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode)
- [Testing at All Stages of Development with Xcode and Sandbox | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_at_all_stages_of_development_with_xcode_and_sandbox)
- [Testing In-App Purchases with Sandbox | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox)
- [测试 App 内购买项目 - App Store Connect 帮助](https://help.apple.com/app-store-connect/#/dev7e89e149d)
- [使用沙盒测试 App 内购买项目 - Apple Developer](https://developer.apple.com/cn/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox/)
- [为自动续期订阅设置优惠代码 - App Store Connect 帮助](https://help.apple.com/app-store-connect/#/dev6a098e4b1)
- [提供自动续期订阅 - App Store Connect 帮助](https://help.apple.com/app-store-connect/#/dev75708c031)
