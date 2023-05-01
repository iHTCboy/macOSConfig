title: iOS SKAN 4.0 时代的广告追踪优化：掌握隐私友好的营销策略
date: 2023-04-10 21:43:23
categories: technology #induction life poetry
tags: [SKAdNetwork,iOS SKAN 4.0]  # <!--more-->
reward: true

---

> 本文首发于 [iOS SKAN 4.0 时代的广告追踪优化：掌握隐私友好的营销策略 - 掘金](https://juejin.cn/post/7220380791511416891)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：ChatGPT(GPT-4) & iHTCboy

> 摘要：本文深入探讨了苹果的 SKAdNetwork（SKAN）以及它与 App Tracking Transparency（ATT）政策之间的关联，阐明了广告跟踪的限制以及如何在保护用户隐私的同时实现广告效果优化。文章还介绍了 SKAN 4.0 的新特性，以及提高用户 ATT 许可率和 SKAN 广告转化率的实用建议等。

<!--more-->

![2023-SKAdNetwork4-00](https://ihtcboy.com/images/2023-SKAdNetwork4-00.jpeg)

## 一、前言

小编早就想撰写一篇关于苹果 iOS 端广告跟踪历史的文章，可是一直没有抽出时间来完成。直到最近，开始使用 ChatGPT(GPT-4)，突然发现写文章变得轻松许多。现在，我可以轻松地连续爬(写)上五楼(五千字)，都不会喘不过气来。

接下来，我将带领大家穿越时光，详细回顾 iOS 端 IDFA 和 ATT 广告跟踪的发展历程。我们将从早期的广告追踪方法开始，探讨其中的挑战和不足之处，再了解苹果如何引入更先进的技术和策略，以应对日益增长的隐私和安全问题。此外，我们还将讨论广告跟踪技术未来的发展趋势，以及它们将如何影响广告行业的格局。希望这篇文章能为您提供有关 iOS 广告跟踪的全面了解，同时激发您对广告领域的兴趣，研究和实现更加安全和有效的广告和确保用户隐私得到保护的广告模式或技术。

有一个小插曲，ChatGPT 数据目前只到 2021 年 9 月，所以需要给它 “喂” SKAN 4.0 的数据饲料，才能让它了解最新动态：

![2023-SKAdNetwork4-01](https://ihtcboy.com/images/2023-SKAdNetwork4-01.jpeg)


## 二、广告标签符 IDFA 的历史

2020 年苹果在 WWDC20 推出 iOS 14 和  `ATT`（`App Tracking Transparency`, 应用追踪透明度）框架，旨在最终全面关闭 IDFA。**简单来说，苹果把 IDFA 是否允许 app 获取的权限交给了用户来选择。**

而 IDFA 是什么？在 iOS app 中，苹果提供 `IDFA`（`Identifier For Advertisers`，广告标识符） 来确实用户。为了保护用户隐私，早在 2012 年苹果公司就不再允许其生态的 App 获取用户的唯一标识符，但是商家在移动端打广告的时候又希望能监控到每一次广告投放的效果，因此，苹果想出了折中的办法，就是提供另外一套和硬件无关的标识符，用于给商家监测广告效果，同时用户可以在手机中重置这个广告标识符，避免商家长期跟踪用户行为。但一般用户对此无感知（不会关闭），IDFA 准确率非常高。

而现在苹果推出 ATT，把 IDFA 的获取放到台面上，让用户选择是否允许 app 获取 IDFA。从目前的行业数据来看，用户允许 ATT 广告跟踪权限只有不到 30%。也就是说，广告跟踪的准确率远远低于 30%，这对于广告投放效果来说，是无法接受的！因为投放的广告不能看到效果，这是广告投放最可怕的事，投了钱不能看到效果，是亏还是赚还要靠猜？？？

虽然基于广告行业的压力，但苹果最终还是于 2021 年 4 月 27 日发布 iOS 14.5，并增加强制的 ATT 权限功能，App 必然要用户允许 ATT 权限后，才能获取用户设备的 IDFA。至此，IDFA 名存实亡！！！

### 2.1 什么是 App Tracking Transparency（ATT）

App Tracking Transparency（ATT）政策要求应用在收集用户数据或将数据共享给第三方广告平台之前，必须获得用户的明确同意。这意味着在应用中，开发者需要向用户展示一个弹出窗口，向用户解释为什么要收集这些数据以及如何使用它们。这一政策限制了许多传统广告追踪方式，因为它们通常在用户不知情的情况下收集和共享用户数据。

### 2.2 为什么需要 App Tracking Transparency（ATT）

随着个人隐私意识的不断提高，苹果公司认为有必要保护用户的隐私，让他们有权决定自己的数据是否被收集和共享。通过实施 ATT 政策，用户可以选择是否允许应用追踪他们的数据。这有助于提高用户对数据使用的信任和透明度。

### 2.3 怎么使用 App Tracking Transparency（ATT）

作为开发者或广告商，您需要遵循以下步骤来适应和使用 ATT 政策：

1. **更新应用以支持ATT**：首先，您需要更新您的应用以支持 ATT，确保在需要追踪用户数据时，应用会显示一个弹出窗口请求用户许可。
2. **提供清晰的数据收集说明**：在请求用户许可时，您需要明确告知用户您将如何使用这些数据以及数据收集的目的。这有助于提高用户对数据使用的信任。
3. **尊重用户的选择**：根据用户的选择，您应当相应地调整数据收集和广告追踪策略。如果用户拒绝被追踪，您需要确保不会收集和共享其数据。
4. **转向隐私保护的广告解决方案**：为了适应 ATT 政策的限制，您可以考虑使用隐私保护的广告解决方案，例如 SKAdNetwork，来衡量广告效果。

## 三、SKAdNetwork 的历史

跟踪用户设备的目的是什么？最原始的目的是 `广告归因`。他们希望将购买归因于广告点击，以便商家知道将广告预算集中在哪里，此类归因用于衡量哪些广告有效。但随着移动端成为全球用户必备的随身设备，单单的广告归因已经不能满足他们的目的，收集购买习惯以及其他隐私信息，它们变得比你自己更了解自身的购买需求！

苹果推出的 `SKAdNetwork`就是希望在广告端袜掉用户的标识，各 app 之间的用户标识，要不要共享给第三方使用，应该由用户自己来决定。App 获取 IDFA 广告标签符前需要调用 ATT 授权弹窗来求用户许可：

![2023-SKAdNetwork4-02](https://ihtcboy.com/images/2023-SKAdNetwork4-02.jpeg)

那以后怎么投放广告呢？苹果给出的方案是，使用 SKAdNetwork ！

### 3.1 什么是 SKAdNetwork（SKAN）

SKAN 是 SKAdNetwork 的简称，是 Apple 推出的一个隐私保护的广告解决方案。随着 Apple 对用户隐私保护的关注度越来越高，尤其是通过引入 App Tracking Transparency（ATT）政策，SKAdNetwork 的重要性得到了凸显。

SKAdNetwork 是一项用于在 iOS 设备上衡量应用广告效果的解决方案。它允许广告网络和开发人员在不暴露用户个人信息的情况下跟踪广告活动的效果。SKAdNetwork 通过聚合数据，而不是提供用户级别的数据，从而确保用户隐私得到保护。

### 3.2 为什么需要 SKAdNetwork（SKAN）

随着苹果对用户隐私的关注不断加大，通过 ATT 政策限制了许多传统的广告追踪方式

SKAdNetwork 是可以在保护用户隐私的前提下衡量广告效果的解决方案。广告商、开发者和广告平台都需要适应这一变化，以便在 iOS 生态系统中继续提供有效的广告服务和衡量广告投放效果。

### 3.3 如果不用 ATT 和 SKAN，还能做广告追踪吗

在App Tracking Transparency（ATT）政策实施之后，应用开发者和广告商在 iOS 设备上进行广告追踪的方式受到了限制。在不使用 ATT 和 SKAdNetwork（SKAN）的情况下，进行广告追踪变得困难，因为这违反了苹果的隐私政策。

然而，在其他平台（如 Android、Web 等）上，广告追踪仍然可以使用其他方法。以下是一些在其他平台上可以使用的广告追踪方法：

1. **使用 Cookie**：在Web浏览器中，可以使用 Cookie 来追踪用户。Cookie 可以帮助广告商识别用户、衡量广告效果以及进行个性化广告投放。然而，值得注意的是，对于隐私的关注正在导致对Cookie使用的限制，如 Google Chrome 计划逐步取消第三方 Cookie 的支持。
2. **设备指纹技术（Device Fingerprinting）**：设备指纹技术通过收集设备特征（例如操作系统版本、设备型号、屏幕分辨率等）来识别设备。这种方法可以在一定程度上进行广告追踪，但其准确性相对较低，且可能受到隐私法规的影响。
3. **统一登录（Single Sign-On，SSO）**：通过统一登录系统，用户可以在不同的应用和服务之间进行身份验证。广告商可以使用这些身份验证信息来追踪用户，并为他们提供定制化的广告体验。

总之，**在 iOS 设备上，在不使用 ATT 和 SKAN 的情况下进行广告追踪变得越来越困难**。然而，在其他平台上，广告商仍然可以使用 Cookie、设备指纹技术和统一登录等方法进行广告追踪。需要注意的是，随着隐私法规的不断更新和收紧，这些方法也可能受到限制。为了应对这些变化，广告商和开发者需要密切关注行业动态，并考虑转向更加隐私友好的广告解决方案。

## 四、SKAdNetwork 的技术原理

> **我们用一个比喻来解释 SKAdNetwork 的原理**：假设一个快递公司代表了广告网络，而用户安装应用程序就像收件人接收包裹。在这个例子中，SKAdNetwork 就像一个保护用户隐私的隐形屏障。快递公司（广告网络）可以知道包裹（广告点击和安装事件）已经被成功投递，但是并不能知道具体是哪个收件人（用户）收到了包裹。通过这种方式，SKAdNetwork保证了用户隐私得到了保护，同时广告商仍然可以衡量广告效果。

SKAdNetwork 是苹果为了保护用户隐私而推出的一种广告效果衡量系统。它允许广告网络以去中心化的方式追踪用户安装和使用应用程序，而无需访问用户的唯一标识符。SKAdNetwork 使用加密签名和一系列预定义参数传递广告点击、安装和转换数据。在整个过程中，个人信息得到了保护，不会泄露给广告商或广告网络。

所以 SKAdNetwork 归因数据本身不具有任何用户标识符，所以无法跟踪用户。SKAdNetwork 是让广告平台在不获取 IDFA 的前提下，对用户的点击和安装行为提供的一套追踪解决方案。由于 Apple 的介入，将直接横跨设备与 App Store，并且不会把任何设备信息透露给广告主，并且更有利于防作弊。

![2023-SKAdNetwork4-03](https://ihtcboy.com/images/2023-SKAdNetwork4-03.jpeg)

当用户点击广告时，一个带有签名信息的 App Store 产品界面呈现出来，签名信息标记了此次广告活动。如果用户安装并且打开了 app，设备发送一个安装验证通知给广告网络。这个由 Apple 签名的通知包括广告活动 ID，但是不含用户或设备相关的数据。通知还可以包含一个转化数值和来源应用 ID，这个取决于苹果设定的一个隐私阈值。

### 4.1 如何使用 SKAdNetwork（SKAN）

要使用 SKAdNetwork，开发者和广告商需要按照以下步骤操作：

1. 更新 App 以支持 SKAdNetwork：开发者需要更新应用以支持 SKAdNetwork，并为其配置相关参数。这包括在 Info.plist 文件中注册参与的广告网络的 SKAdNetwork ID。
2. 与支持 SKAdNetwork 的广告平台合作：确保您正在使用的广告平台支持 SKAdNetwork，并遵循相关的最佳实践。
3. 使用转化值（Conversion Value）：SKAdNetwork 允许开发者使用转化值来衡量广告效果。开发者需要设定合适的转化值逻辑，以便更好地跟踪广告效果。
4. 分析 SKAdNetwork 数据：广告商和开发者需要关注 SKAdNetwork 返回的数据，分析广告活动的表现，并根据这些数据调整广告策略。

### 4.2 SKAdNetwork 返回的数据

SKAdNetwork 最大的问题就是提供了聚合的数据，但对于广告来说，这个过程已经不是简单的跟踪用户，而跟踪广告也是非常的重要，因为一个广告可能有多个不同的素材和不同的渠道测试等。

通过 SKAdNetwork 回传通知可以获取的 [数据](https://developer.apple.com/documentation/storekit/skadnetwork/verifying_an_install_validation_postback) ：

**SKAdNetwork 2.0**

```json
{
  "version" : "2.0",
  "ad-network-id" : "com.example",
  "campaign-id" : 42,
  "transaction-id" : "6aafb7a5-0170-41b5-bbe4-fe71dedf1e28",
  "app-id" : 525463029,
  "attribution-signature" : "MDYCGQCsQ4y8d4BlYU9b8Qb9BPWPi+ixk\/OiRysCGQDZZ8fpJnuqs9my8iSQVbJO\/oU1AXUROYU="
  "redownload": true,
  "source-app-id": 1234567891
  "conversion-value": 20
}
```

**SKAdNetwork 3.0**

```json
{
  "version": "3.0",
  "ad-network-id": "com.example",
  "campaign-id": 42,
  "transaction-id": "6aafb7a5-0170-41b5-bbe4-fe71dedf1e28",
  "app-id": 525463029,
  "attribution-signature": "MEYCIQD5eq3AUlamORiGovqFiHWI4RZT/PrM3VEiXUrsC+M51wIhAPMANZA9c07raZJ64gVaXhB9+9yZj/X6DcNxONdccQij",
  "redownload": true,
  "source-app-id": 1234567891,
  "conversion-value": 20,
  "fidelity-type": 1,
  "did-win": true
}
```

**SKAdNetwork 4.0**

细粒度转化值的情况：

```json
{
  "version": "4.0",
  "ad-network-id": "com.example",
  "source-identifier": "5239",
  "app-id": 525463029,
  "transaction-id": "6aafb7a5-0170-41b5-bbe4-fe71dedf1e30",
  "redownload": false,
  "source-domain": "example.com", 
  "fidelity-type": 1, 
  "did-win": true,
  "conversion-value": 63,
  "postback-sequence-index": 0,
  "attribution-signature": "MEUCIGRmSMrqedNu6uaHyhVcifs118R5z/AB6cvRaKrRRHWRAiEAv96ne3dKQ5kJpbsfk4eYiePmrZUU6sQmo+7zfP/1Bxo="
}
```

粗粒度转化值的情况：

```json
{
  "version": "4.0",
  "ad-network-id": "com.example",
  "source-identifier": "39",
  "app-id": 525463029,
  "transaction-id": "6aafb7a5-0170-41b5-bbe4-fe71dedf1e31",
  "redownload": false,
  "source-domain": "example.com", 
  "fidelity-type": 1, 
  "did-win": true,
  "coarse-conversion-value": "high",
  "postback-sequence-index": 0,
  "attribution-signature": "MEUCIQD4rX6eh38qEhuUKHdap345UbmlzA7KEZ1bhWZuYM8MJwIgMnyiiZe6heabDkGwOaKBYrUXQhKtF3P/ERHqkR/XpuA="
}
```

**字段说明：**

| 字段名 | 解析 | 支持的版本 |
| --- | --- | --- |
| `app-id` | 投放广告的 App Store App ID | - |
| `ad-network-id` | 广告平台 ID。 | - |
| `transaction-id` | 用于转化验证，去重安装验证回传。 | - |
| `version` | SKAdNetwork 版本号 | 2.0 及更高版本。 |
| `campaign-id` | 记录广告活动 campaign 的标识符信息。4.0 及更高版本的广告使用 source-identifer 替代。 | `1.0 ~ 3.0` 版本使用，4.0 版本弃用。 |
| `attribution-signature` | 您需要验证的 Apple 的归因签名。 | 2.0 及更高版本。 |
| `redownload` | 是否重复下载 | 2.0 及更高版本。 |
| `source-app-id `| 从哪个 app 上看到广告且安装的 | 2.0 及更高版本。 |
| `conversion-value` | 转化值。只有当已安装的 app 提供转换值，并且提供参数满足苹果的隐私阈值时，conversion-value 才会出现在回传中。 | 2.0 及更高版本。 |
| `fidelity-type` | 值为 0 表示页面展示类型的广告；值为 1 表示 StoreKit 渲染的广告或 SKAdNetwork 归因的 Web 广告。 | 2.2 及更高版本 |
| `did-win` | 如果广告网络赢得归因，则为 true，如果回传代表没有赢得归因的合格广告效果，则为 false。（注意：只有为 ture 时，才会包含字段 source-app-id 和值。） | 3.0 及更高版本 |
| `source-identifier` | 取代 campaign-id 的分层来源标识符。此字符串表示原始值的两位数、三位数或四位数。 | 4.0 及更高版本 |
| `source-domain` | 仅适用于 Web 广告。SKAdNetwork for Web Ads 投放广告的来源域名，字段值与 source-app-id 是对立，两者只会返回其一。 | 4.0 及更高版本 |
| `coarse-conversion-value` | 粗粒度的转换值，可能的值为字符串 "low"、"medium" 和 "high"。系统在较低的回传数据层以及第二次和第三次回传中发送该值，且不会返回转化值(conversion-value)。 | 4.0 及更高版本 |
| `postback-sequence-index` | 可能的整数值 0、1 和 2。分别表示由三个转换窗口产生的回传顺序。 | 4.0 及更高版本 |

**注：**

- SKAdNetwork 3.0 版本回调的 `conversion-value`： 无符号的 6 bit 整数（也就是只能为 0-63 的数字）。由广告主应用和广告网络决定此值的含义。默认为 0。所以，因为数字太小，无法绑定到用户信息。
- 在实践中，开发者需要思考调用的时机，并且对 conversion-value 数值做良好的定义，就能达到衡量广告用户质量的目的。
- 为确保用户匿名，Apple 会为应用下载分配一个回传数据层。回传数据层决定了回传中是否出现某些参数，以及分层来源标识符的位数。以下回传参数受回传数据层影响：
    - `source-identifier`（影响回传返回的位数）
    - `coarse-conversion-value`
    - `conversion-value`
    - `source-app-id`
    - `source-domain`


> 以上字段的详细说明文档：[Identifying the parameters in install-validation postbacks](https://developer.apple.com/documentation/storekit/skadnetwork/identifying_the_parameters_in_install-validation_postbacks)

## 五、SKAdNetwork 4.0 更新

### 5.1 新的回传窗口和时间范围

转换窗口（`Conversion Window`）是广告投放与广告效果（如应用安装、购买等）之间的时间间隔。它用于衡量用户在看到或点击广告后多长时间内完成了特定的目标动作。转换窗口可以帮助广告商和开发者了解广告活动的效果，并据此调整广告策略。

SKAdNetwork（SKAN）的转换窗口与传统转换窗口有所不同。在 SKAN 中，转换窗口不再是实时的，因为它采用了聚合和延迟报告的方式来保护用户隐私。这意味着，SKAN 不会立即将转换事件报告给广告商，而是在一个随机的时间窗口内发送回传报告。

![2023-SKAdNetwork4-04](https://ihtcboy.com/images/2023-SKAdNetwork4-04.jpeg)

SKAdNetwork 4.0 引入了三个转化窗口，最多可以为每个获胜广告归因产生三个回传。第一个转化窗口为 0 至 2 天，第二个窗口为 3 至 7 天，第三个窗口为 8 至 35 天。在这三个窗口期间，app 可以更新转化值。

![2023-SKAdNetwork4-05](https://ihtcboy.com/images/2023-SKAdNetwork4-05.jpeg)

当 app 在转化窗口结束之前锁定（`locked conversion`）并最终确定转化值时，系统会在随机延迟后发送回传。首次回传的随机延迟为 24-48 小时，第二次和第三次回传的随机延迟为 24-144 小时。

### 5.2 分层来源标识（source-identifier）

以前称为广告系列 ID 栏位。通过来源标识栏位，广告商可以确定安装归因于哪个广告系列，还能获得其他归因信息。广告商可以根据其目标来配置这个四位数的值，例如广告系列价值、广告投放位置或广告创意类型。

![2023-SKAdNetwork4-06](https://ihtcboy.com/images/2023-SKAdNetwork4-06.jpeg)

在回传中，分层来源标识栏位始终包含至少两位数字。最多可包含四位数字，具体取决于广告系列所带来的安装数量和回传数据层。例如，如果广告系列没有产生足够的安装数量，则回传的来源标识栏位中只会出现两位数字。这为广告商提供了更多的广告系列灵活性，并可在满足隐私阈值时提供更多归因洞察，同时保护跨 App 的用户隐私。

### 5.3 粗粒度转化值和隐私阈值

转化值可以是粗粒度值，也可以是细粒度值。虽然这两个值都是在衡量窗口期间捕获的，但最终值由广告系列所带来的安装数量和回传数据层决定。当广告系列带来的 App 安装数量较少时，广告商将获得仅包含有限归因信息的粗粒度值。粗粒度值可以是低、中或高。

SKAdNetwork 4.0 引入的隐私阈值变更，使得从 SKAdNetwork 回传数据中获取的空值（nulls）变得更少。

在之前的 SKAdNetwork 版本中，根据 Apple 的隐私政策，当达到一定隐私阈值时，某些回传数据可能会被设为 null。这意味着广告网络在某些情况下可能无法获取足够的数据来衡量广告效果。

在 SKAdNetwork 4.0 中，Apple 调整了这些隐私阈值，使得回传数据中的 null 值更少。这有助于广告网络获得更多有用的数据，从而更好地衡量广告效果，同时仍然保护用户隐私。这种调整使广告网络能够在保护用户隐私的前提下，更好地优化广告策略和投放效果。

为了维护用户隐私并确保群体匿名性，设备可能会限制 SKAdNetwork 在回传数据中发送的数据。Apple 为每个应用下载分配一个回传数据层级。以下关系图描述了回传数据层级与相对群体大小之间的关系(仅供示例)：

![2023-SKAdNetwork4-07](https://ihtcboy.com/images/2023-SKAdNetwork4-07.jpeg)

为了保护用户隐私，回传数据分为四个层级（Tier 0、Tier 1、Tier 2 和 Tier 3），每个层级表示不同大小的群体。Tier 0 代表最小的群体，Tier 3 代表最大的群体。

回传数据层级考虑了显示广告的应用或域名、广告应用以及广告网络提供的分层源标识符（source-identifier）相关的群体大小。系统计算两位数、三位数和四位数分层源标识符的回传数据层级，并选择具有最高回传数据层级的源标识符。如果多个源标识符具有相同的最高回传数据层级，系统将选择具有最多位数的源标识符。如果最高的回传数据层级是 Tier 1 或 Tier 0，系统始终选择两位数的源标识符。

| 层级 | 群体大小 | source-identifier | 转化值 | 用户隐私保护 |
| --- | --- | --- | --- | --- |
| Tier 0 | 最小 | 两位数 | 粗粒度 (低) | 最高 |
| Tier 1 | 较大 | 两位数 | 粗粒度 (中) | 较高 |
| Tier 2 | 更大 | 两位数或更多位 | 粗粒度 (高) | 较低 |
| Tier 3 | 最大 | 三位数或四位数 | 细粒度 | 最低 |

回传数据层级会影响回传中的以下字段，这些字段可能存在、不存在或只包含其中部分的值：

1. `source-identifier`（分层来源标识符），影响回传返回的位数，导致可能返回两位数、三位数或四位数。
2. `conversion-value`（细粒度转换值），仅在第一次回传中可用。
3. `coarse-conversion-value`（粗粒度转换值），在较低回传数据层级以及第二和第三次回传中，系统发送此值而不是 conversion-value。
4. `source-app-id`（显示广告的  App id）或 source-domain（显示网页广告的域名）。

**注意：**

- 第一个回传的数据内容取决于回传数据层。第二和第三个回传的数据内容则包括两位数的 source-identifier 和 coarse-conversion-value。Tier 0 的广告不会发送第二和第三个回传。
- 使用 SKAN 4 及更高版本的广告在获胜广告展示后有资格获得第二和第三个回传，而使用 SKAN 3 及更早版本的广告只有资格获得一个获胜回传。

### 5.4 适用于网页广告的 SKAdNetwork

SKAdNetwork 支持对 Safari 浏览器中的网页广告进行归因。用户轻点这类广告后，会转至广告中所推广 App 的 App Store 产品页面。除 App 内广告外，广告商现在还能使用私人点击衡量对网页广告进行归因。

要在网页创建 SKAN 归因广告链接时，需要遵循以下特定格式：

```html
<a href="<https://apps.apple.com/app/id{itunes_item_id}>"
   attributionDestination="<https://example.com>"
   attributionSourceNonce="t8naKxXHTzuTJhNfljADPQ">
</a>
```

这个格式中包含了以下几个值：

1. `{itunes_item_id}`：广告宣传的应用的 App Store App ID。
2. `attributionDestination`：广告网络的有效顶级域名和一个前导域名组件（eTLD+1）表示。此值需要与获取已签名的网络广告展示负载请求和响应中的 `source-domain` 值匹配。
3. `attributionSourceNonce`：为每个广告展示生成的一次性 UUID 值的 Base64URL 编码表示。

您需要根据实际情况填写这些值。当用户点击广告链接时，将会生成一个 AdImpressionRequest，设备会使用这些信息从 Web 广告链接中获取完整的 SKAdNetwork 归因信息。

> 注：有效顶级域名（eTLD）是互联网域名系统（DNS）中的最高级别域名。例如，对于 example.com，有效顶级域名就是 .com。一个前导域名组件（eTLD+1）表示有效顶级域名加上紧邻的一个子域名。例如，在 example.com 中，eTLD+1 就是 example（前导域名组件）+ .com（有效顶级域名）。
> 
> 例如，如果广告网络的域名是 ads.example.com，那么 `attributionDestination` 应为 `https://example.com`。这样，SKAdNetwork for Web Ads API 才可以识别并将广告归因于正确的广告网络。

因为这个是广告商来处理，所以我们这里就不展开了。有兴趣的朋友，可以查看 [苹果文档](https://developer.apple.com/documentation/skadnetworkforwebads/creating_an_attributable_ad_link)。

## 六、广告疑问和提高转化率

### 6.1  ATT 必须获得用户的明确许可，如何提高用户许可率

提高用户在 App Tracking Transparency（ATT）政策下的许可率是广告商和应用开发者关注的重点。以下是一些建议，可帮助您在遵循隐私政策的同时提高用户许可率：

1. **透明沟通**：在弹出窗口中清楚地告诉用户您将如何使用他们的数据，以及数据收集的目的。让用户明白数据追踪对于提供更好的服务和个性化体验的重要性。
2. **突出优势**：向用户强调允许追踪的好处，例如更精准的推荐内容、个性化的广告和优惠等。这有助于提高用户的许可意愿。
3. **界面设计**：优化弹出窗口的设计，使其简洁明了且易于理解。避免使用过于复杂的术语和不必要的信息。突出关键点，使用户能够快速了解您请求许可的原因。
4. **调整时机**：合理选择向用户展示弹出窗口的时机。在用户与应用互动程度较高且对应用满意度较高的时候请求许可，可能会提高用户的许可率。
5. **引导教育**：在请求许可之前，可以通过应用内的教育内容或引导，提前告知用户即将请求许可。这样，用户在看到弹出窗口时已经对其有所了解，可能会更愿意同意。
6. **A/B 测试**：尝试不同的文案、设计和时机，通过A/B测试来找到最适合您应用的策略，从而提高许可率。
7. **尊重用户选择**：即使用户拒绝许可，也要确保为他们提供高质量的应用体验。这有助于建立用户信任，并可能使用户在未来重新考虑允许追踪。

通过遵循上述建议，您可以在遵循 App Tracking Transparency（ATT）政策的同时，提高用户许可率。要记住，建立用户信任和提供优质的应用体验是提高许可率的关键。

### 6.2 SKAN 能不能追踪到具体某个用户？

答：**它不能追踪到具体的某个用户，** 这是因为它的设计初衷就是在保护用户隐私的前提下，提供广告效果数据。

SKAN 的工作原理是通过聚合数据，而不是提供用户级别的数据。这意味着广告商可以了解广告投放效果和转化情况，但无法识别这些数据来自哪个具体的个体。SKAN通过发送不包含设备或用户身份信息的转化报告，确保用户隐私得到保护。

此外，SKAN 还对数据进行了延迟发送，以降低将数据与特定用户关联的可能性。这种延迟发送有助于确保广告效果数据不能用于识别个体用户。

总之，SKAdNetwork（SKAN）无法追踪到具体某个用户，因为其设计初衷是在保护用户隐私的前提下，提供广告效果数据。通过聚合数据、不提供用户级别的数据以及延迟发送数据，SKAN确保用户的隐私得到了保护。

### 6.3 如果我想用 SKAN 追踪到具体某个用户，有可行方案吗

SKAdNetwork（SKAN）的设计目的是在保护用户隐私的前提下提供广告效果数据，因此其本身并不支持追踪具体某个用户。尝试使用 SKAN 追踪到具体某个用户不符合苹果的隐私政策，这可能导致您的应用受到限制或从 App Store 中移除。

值得注意的是，随着隐私保护意识的提高和相关政策的收紧，应用开发者和广告商需要遵循相关法规，确保用户隐私得到保护。在这种情况下，建议您专注于使用SKAN等隐私保护的解决方案来衡量广告效果，并尊重用户的隐私选择。

在不侵犯用户隐私的前提下，您可以尝试采用其他方法来优化广告效果：

1. 使用 SKAN 提供的聚合数据来优化广告策略，了解哪些广告渠道和创意更有效。
2. 对不同的广告创意、目标人群和投放策略进行 A/B 测试，以找到最佳的广告效果组合。
3. 在应用内收集用户反馈和使用数据（在遵循隐私政策的前提下），并根据这些数据优化应用功能和广告投放策略。

总之，使用 SKAN 追踪具体某个用户并不符合其设计目的和苹果的隐私政策。建议您遵循相关法规，确保用户隐私得到保护，并在此基础上优化广告策略和应用体验。

### 6.4 使用 SKAN 有什么注意事项，如何提高转化率

使用 SKAdNetwork（SKAN）时，有一些注意事项需要遵循，同时可以采用一些策略来提高广告转化率。

**注意事项：**

1. 更新 SDK：确保您的应用和广告 SDK 已更新至支持SKAN的最新版本。
2. 配置 SKAdNetwork ID：为了正确跟踪广告效果，请确保将广告平台的 SKAdNetwork ID 添加到您的应用信息中。
3. 转化值管理：SKAN 允许您设置最多 64 个转化值（0-63），需要合理规划转化值，以便更好地衡量广告效果和优化广告策略。（注：SKAN 4.0 可能返回 4 位数转化值。）
4. 遵守苹果政策：使用 SKAN 时，请确保遵守苹果的隐私政策和其他相关规定。

**提高转化率：**

1. **优化广告创意**：投放高质量的广告素材，包括吸引人的图片、视频和文案，以提高用户点击和转化率。
2. **定向投放**：根据目标用户群的兴趣和行为，精确投放广告。这可以提高广告的相关性，从而提高转化率。
3. **A/B 测试**：尝试不同的广告创意、文案和投放策略，通过 A/B 测试找到最佳组合以提高转化率。
4. **应用内优化**：优化应用的用户体验，确保引导用户顺利完成转化目标。例如，简化注册流程、突出产品特点，以及提供明确的调用操作。
5. **限时促销和优惠**：提供独特的优惠和促销活动，以激励用户完成转化。
6. **数据分析**：分析SKAN提供的聚合数据，了解哪些广告渠道和创意更有效。据此调整广告策略以提高转化率。

通过遵循上述注意事项和策略，您可以在使用 SKAdNetwork（SKAN）的过程中更好地遵守苹果政策，同时提高广告转化率。

### 6.5 SKAN 4.0 粗粒度转化值（coarse-conversion-value）和分层来源标识（source-identifier）是什么关系？

首先粗粒度转化值（`coarse-conversion-value`）和分层来源标识（`source-identifier`）没有直接关系。它们都是 SKAdNetwork 回传中的两个参数，它们分别表示粗粒度的转化值和广告来源信息。`source-identifier` 是用于表示广告来源的标识符，它可能包含两位数、三位数或四位数。这个参数的位数并不直接对应粗粒化转化值的级别（低、中、高）。`coarse-conversion-value` 是用于表示粗略的转换值，它有三个可能的值：低、中、高。这个参数是为了在低回传数据层级中保护用户隐私而引入的，它不能直接从 `source-identifier` 的位数推导出来。

**对于高回传数据层级：**

- 回传将包含四位数的 `source-identifier`，表示精确的广告来源信息。
- 回传将包含具体的 `conversion-value`，表示细粒度的转化值。

**对于低回传数据层级：**

- 回传将包含两位数的 `source-identifier`，表示模糊的广告来源信息。
- 回传将包含粗粒度的 `coarse-conversion-value`，而不是具体的 `conversion-value`。

在低回传数据层级的示例中，`coarse-conversion-value` 的值为 "high"。这里的 "high" 是一个相对描述，表示该回传所代表的广告转化效果相对较高。不同的粗略转换值可以用来区分广告效果的不同范围，例如 "`high`"、"`medium`" 和 "`low`"。简而言之，粗粒度的转化值（coarse-conversion-value）是一个相对概念，用于表示广告效果的大致范围。在低回传数据层级中，由于保护用户隐私的需要，不提供精确的转化值和广告来源信息。

**可以将这种关系比喻为一个产品销售报告：**

1. `source-identifier` 类似于报告中的销售渠道。在高回传数据层级中，它可能表示一个特定的商店编号（例如：编号 1234 的商店），而在低回传数据层级中，它只包含粗略的信息（例如：地区编号 12，表示某个地区的所有商店）。
2. `coarse-conversion-value` 类似于报告中的销售额区间。在高回传数据层级中，您可以获得确切的销售额（例如：销售额为 10,000 美元），而在低回传数据层级中，您只能获得一个大致的范围（例如："high"，表示销售额较高，但不提供具体数值）。

因此，在低回传数据层级中，`source-identifier` 和 `coarse-conversion-value` 一起为您提供了模糊的广告效果信息，同时保护了用户隐私。

### 6.6 SKAN 4.0 分层来源标识（source-identifier）有四位转化值，我能全用吗

`source-identifier` 是一个分层源标识符，它可能包括两位数、三位数或四位数。不同的位数表示不同层级的信息，例如：

1. 前两位数字表示 Campaign（广告活动）
2. 第三位数字表示 Location（地理位置）
3. 第四位数字表示 Placement（广告投放位置）

> 注意：苹果官方文档并未明确规定 source-identifier 的第三位和第四位分别代表地理位置和广告投放位置。实际上，苹果没有对 source-identifier 的具体组成部分做出明确的规定。source-identifier 是由广告网络自行确定的，用于识别不同广告来源的标识符。

这种分层标识符有助于广告网络和开发者更好地了解广告效果，并依据这些信息来优化广告策略。同时，SKAdNetwork 也确保了在回传数据时保护用户隐私。

对于 source-identifier 的第 3 位和第 4 位，理论上它们都可以是 0-9。然而，在实际应用中，如何划分这些数字以表示地理位置和广告投放位置是取决于广告网络的实际需求和策略的。您可以将最后两位组合为 00~99，从而得到 100 个不同的组合来表示更多的信息，但这取决于广告网络如何设计和使用这些位数。具体的实现可能因广告网络和实际需求而异。

如果广告网络在 source-identifier 中使用了四位数字，您可以将最后两位组合为 00~99，从而得到 100 个不同的组合来表示更多的信息。但如果您只收到回调中的三位数字，那么您将无法获得全部的四位数字信息，因此可能无法完全匹配和解析所有的数据。

所以，广告网络和开发者可以根据自己的需求自行定义 source-identifier 的层次结构。在某些情况下，根据回传数据分层，回传中可能只包含部分 source-identifier 信息。因此，确保广告网络和开发者之间的沟通和协调，以便正确解析和处理回传数据。

## 七、总结

总之，SKAdNetwork（SKAN）是苹果推出的一种在 iOS 设备上衡量广告效果的解决方案，是目前 iOS 苹果官方最可靠的广告方案。在当前强调用户隐私保护的环境下，广告商、开发者和广告平台需要适应这一变化，以便在 iOS 生态系统中继续提供有效的广告服务。

本文的创作得力于 ChatGPT 的智能辅助，GPT-4 的表现如此出色，读者们应该难以分辨哪些内容是由 ChatGPT 创作，哪些是小编书写？这充分体现了 AI 技术在协同创作中的巨大潜力，为广大创作者提供了更为高效和便捷的创作方式。

此次合作既展示了 AI 的强大能力，也为未来人工智能与人类创作者的协作开辟了广阔的可能性。让我们期待更多类似的卓越成果，共同见证 AI 技术在创作领域的蓬勃发展！

欢迎大家评论区一起讨论交流~

> 欢迎关注我们，了解更多 iOS 和 Apple 的动态~

## 参考引用

- [WWDC22 - Apple 隐私技术探索 - 掘金](https://juejin.cn/post/7116331493659508744)
- [SKAdNetwork 4.0 现已推出 - Apple Developer](https://developer.apple.com/cn/news/?id=31g9nllo)
- [用户隐私和数据使用 - Apple Developer](https://developer.apple.com/cn/app-store/user-privacy-and-data-use/)
- [广告归因 - Apple Developer](https://developer.apple.com/cn/app-store/ad-attribution/)
- [SKAdNetwork 4 release notes | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skadnetwork/skadnetwork_release_notes/skadnetwork_4_release_notes)
- [SKAdNetwork | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skadnetwork/)
- [Receiving postbacks in multiple conversion windows | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skadnetwork/receiving_postbacks_in_multiple_conversion_windows)
- [Verifying an install-validation postback | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skadnetwork/verifying_an_install-validation_postback)
- [Creating an attributable ad link | Apple Developer Documentation](https://developer.apple.com/documentation/skadnetworkforwebads/creating_an_attributable_ad_link)
- [Identifying the parameters in install-validation postbacks | Apple Developer Documentation](https://developer.apple.com/documentation/storekit/skadnetwork/identifying_the_parameters_in_install-validation_postbacks)

> 注：如若转载，请注明来源。
