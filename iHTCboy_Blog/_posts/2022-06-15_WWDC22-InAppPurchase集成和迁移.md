title: WWDC22 10040 - 探索 In-App Purchase 集成和迁移
date: 2022-06-15 21:14:10
categories: technology #induction life poetry
tags: [WWDC22,In-App Purchase]  # <!--more-->
reward: true

---

> 本文是《WWDC22 内参》参与创作者，首发于 [【WWDC22 10040】 探索 In-App Purchase 集成和迁移 － 小专栏](https://xiaozhuanlan.com/topic/8024563197)。

基于 [Session 10040](https://developer.apple.com/videos/play/wwdc2022/10040/) 梳理

> 作者：iHTCboy，目前就职于三七互娱37手游，从事游戏 SDK 开发多年，对 IAP 和 SDK 架构设计有丰富的实践经验。
>
> 审核：
> 黄骋志（橙汁），老司机技术社区核心成员，现于西瓜视频负责稳定性 OOM/Watchdog 相关工作。
> 
> SeaHub，目前任职于腾讯 TEG 计费平台部，负责搭建服务于腾讯系业务的支付组件 SDK，对 IAP 相关内容及 SDK 设计开发有一定的经验。
> 
> 王浙剑（Damonwong），老司机技术社区负责人、WWDC22 内参主理人，目前就职于阿里巴巴。

<!--more-->

![WWDC22_session_10040_0](https://ihtcboy.com/images/WWDC22_session_10040_0.png)

## 前言

苹果去年 WWDC21 推出了 StoreKit 2、App Store Server API 和 App Store Server Notifications V2，今年 WWDC22 基于这些功能的基础上，增加了一些新的 API 和一些服务的优化。另外，苹果针对这些新特性的疑虑进行了解答，例如 JWT/JWS、兼容性、安全性、订阅通知、服务端集成和迁移等等，最后提供了最佳实践的建议。

![WWDC22_session_10040_1](https://ihtcboy.com/images/WWDC22_session_10040_1.png)

本文内容分成两个主题，分别是 App Store Server API 和 App Store Server Notifications，并结合去年和今年推出的新特性，进行深入浅出的探索。如果读者对去年 WWDC21 相关的内容还不太熟悉的话，推荐先阅读我们去年的文章：

- [初见 StoreKit 2](https://mp.weixin.qq.com/s/arA0_uyc4CWMQ7WJ2RanJA)
- [IAP 后台通信优化与实践](https://mp.weixin.qq.com/s/dWsRKRJsYMRl0GX_36T-kg)
- [IAP 用户退款与客诉处理优化](https://mp.weixin.qq.com/s/MtytymgkcP3_oAH7JyI1og)

开始之前，为帮助读者理解本文将提及的名词，我们一起梳理和回顾关于 In-App Purchase 的名词：

| 名词 | 功能 | 说明 |
|---|---|---|
| `IAP` 或 `In-App Purchase` | App 内购买项目，在所有 Apple 平台上，可以利用 IAP 支付系统，直接在您的 App 内提供额外的内容和功能，包括数字商品、订阅和增值内容等。 | In-App Purchase 简写为 IAP 或者 `内购`，都是非苹果官方写法，但开发者普遍都接受，所以本文也将两者等同关系处理。 |
| `App Store Server API` | WWDC21 推出的 REST API，它是一种强大、安全和高效的 Server to Server API，提供获取数据和执行操作的服务。 | 请求接口使用 JWT 验证，接口返回的信息使用 JSON Web Signature (JWS) 规范格式加密签名。 |
| `App Store Server Notifications V1` 和 `App Store Server Notifications V2` | 目前有 V1 和 V2 版本。通过来自 App Store 的服务器通知实时监控 IAP 事件。 | V1 版本是 WWDC17 推出用于自动续期订阅的订阅状态变化通知，WWDC20 增加了退款通知，API 返回的内容是 JSON 格式。V2 版本是 WWDC 21 推出，API 返回的内容是 JSON Web Signature（JWS）规范格式加密签名，移除和新增部分通知类型，一些通知类型增加子类型（SubState）。|
| `Original API for In-App Purchase` 或 `Original StoreKit` | IAP 支付系统，原始的 StoreKit API，用于区分 StoreKit 2。| 获取的交易票据叫 `App receipt`，需要通过 VerifyReceipt API 来解析票据内容。 |
| `StoreKit 2` | WWDC21 推出的全新的基于 Swift 的 API，仅在 iOS15+ 生效。使用 Swift 的并发特性简化接口，并且使用 JWS 格式的交易票据。| 获取的交易票据叫 `JWS transaction` 或 `Signed transaction`，开发者可独立进行验证，而无需通过苹果服务端 API 解码。另外需要注意，与 Original StoreKit 都是基于 StoreKit Framework 的 API，所以并不是叫 V2 版本。 |
| `originalTransactionId` | IAP 交易成功时，App Store 生成的唯一交易标识符。此字段可通过 StoreKit API、App Store Server API 和 App Store Server Notifications 等方式获取。 | 自动续期订阅的项目使用此字段作为唯一标识，而续订成功的交易票据中 `transactionId` 会更新。另外部分的 App Store Server API 使用此字段作为请求参数。 |

## App Store Server API

首先，我们先来看看 App Store Server API 的变化，会从下面的四个方面进行阐述：

![WWDC22_session_10040_2](https://ihtcboy.com/images/WWDC22_session_10040_2.png)

- App Store Server API 的使用
- 探讨 JWT(JSON Web Tokens) 签名细节
- 校验签名的 transactions（交易）
- 从 StoreKit 的 verifyReceipt 迁移到 App Store Server API

### App Store Server API 的使用

#### 回顾 App Store Server API
 
苹果去年 WWDC21 推出了 App Store Server API，**这套接口兼容 Original StoreKit 和 StoreKit 2，开发者服务端可以直接使用，因为是新接口，所以无迁移或兼容的问题。** 其中有 5 个 API 是通过 `originalTransactionId` 作为查询的参数，这个参数可以通过 receipts（票据）、signed transactions（签名的交易）、signed renewals（签名的续订信息）和 notifications（通知）等获取。

![WWDC22_session_10040_3](https://ihtcboy.com/images/WWDC22_session_10040_3.png)

这几个接口解决了很多内购场景的问题，多年以来只能被动式接收苹果 IAP 流程的通知，导致开发者对 IAP 流程的处理总是不及时。比如自动续期订阅的续订，如果开发者接收苹果服务端通知异常，甚至用户不打开 App 的情况下，订阅到期后，用户是否有续订，开发者总是慢半拍，而现在通过 subscriptions API 开发者就可以实时用户查询订单状态，提升了订阅产品的用户体验。还有主动查询退款 refund lookup API，可以主动或定时检索用户的购买订单，及时发现恶意退款和异常购买，避免用户和开发者蒙受损失。

> 以上接口的详细介绍，可参考我们之前的文章：[IAP 用户退款与客诉处理优化](https://mp.weixin.qq.com/s/MtytymgkcP3_oAH7JyI1og)。

去年还有一个 `lookup` API，这个接口根据用户提供的 `orderId` 来查询用户的每笔支付对应的开发者交易订单信息，从而让开发者更好地帮助用户解决问题。比如用户反馈充值成功但没有收到金币，这时候让用户提供苹果收据订单号 `orderId`，开发者就能查到此订单号对应的 `originalTransactionId` 交易标识，这样就能根据用户订单号关联开发者订单号的问题，从而解决以前无法根据用户的收据截图判断是否真实的支付成功的问题。

另外，今年新增了三个关于 App Store Server Notifications 的 API，在本文的后续章节会有简要的应用案例。如果读者想了解这部分的详细更新内容，可以参考 [What's new with in-app purchase - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10007)。

![WWDC22_session_10040_4](https://ihtcboy.com/images/WWDC22_session_10040_4.png)

#### App Store Server API 和 Original StoreKit 结合使用

接下来讲解 App Store Server API 如何与开发者的服务器交互，正如前面说的，API 需要 `originalTransactionId` 作为查询的参数，具体可以怎么样获取？我们先来看 Original StoreKit 从哪里获取。

客户端将 Original StoreKit 获取的 `App receipt` 发送到开发者服务器，开发者服务器调用苹果的 `verifyReceipt` API 进行解析，根据苹果服务端返回的票据内容中的 in_app 、latest_receipt_info 和 pending_renewal_info 字段都包含 `originalTransactionId` 参数。
![WWDC22_session_10040_5](https://ihtcboy.com/images/WWDC22_session_10040_5.png)

那么 Original StoreKit 怎么结合 App Store Server API 一起使用，原有的 `verifyReceipt` API 验证流程保持不变。具体的交互流程，首先是开发者 app 根据用户充值成功时获取的 App receipt 发给开发者服务器后，通过 `verifyReceipt` API 获取解码后的票据内容，然后通过 `originalTransactionId` 参数就可以调用 App Store Server API。对于原来的流程并没有影响，开发者可以通过 API 获取这个用户的交易或订阅信息，包括订阅续订详细信息等。

![WWDC22_session_10040_6](https://ihtcboy.com/images/WWDC22_session_10040_6.png)

#### App Store Server API 和 StoreKit 2 结合使用

StoreKit 2 获取 `originalTransactionId` 通过新 API `transaction.originalID` 获取，但需要注意只支持 iOS 15 或更高的系统版本。
![WWDC22_session_10040_7](https://ihtcboy.com/images/WWDC22_session_10040_7.png)

当然也可以通过服务端获取，例如客户端提供的签名的 JWS transaction 的解析，或者是调用 App Store Server API 或 App Store Server Notifications 回调等等。例如 JWS transaction 中的 Payload 中就有 originalTransactionId 字段：
![WWDC22_session_10040_8](https://ihtcboy.com/images/WWDC22_session_10040_8.png)

StoreKit 2 使用 App Store Server API 更加简单，因为不需要调用 `verifyReceipt` API，所以直接调用 App Store Server API 就可以。与 Original StoreKit 一样不影响开发者服务端现有的票据验证流程。
![WWDC22_session_10040_9](https://ihtcboy.com/images/WWDC22_session_10040_9.png)

最后，我们总结一下在 Original StoreKit 和 StoreKit 2 中使用 App Store Server API 的流程。首先 App Store Server API 支持 Original StoreKit 和 StoreKit 2，并且不需要依赖其它的接口，只需要 `originalTransactionId` 参数。而这个参数在 Original StoreKit 的  App receipts 中可获取，在 StoreKit 2 中的 Signed transactions 中可获取。所以，App Store Server API 的使用就是这么简单。
![WWDC22_session_10040_10](https://ihtcboy.com/images/WWDC22_session_10040_10.png)

这里还想重点提醒一下，使用 Original StoreKit 的开发者服务器，以前从票据（App receipt）中解析 `latest_receipt` 来获取订阅的最新状态，而现在可以通过 `originalTransactionId` 请求 `Get All Subscription Statuses` API 获取相应订阅的最新状态，相比以前通过客户端刷新或者等待苹果服务器推送通知的方式，更加灵活和高效。
![WWDC22_session_10040_11](https://ihtcboy.com/images/WWDC22_session_10040_11.png)

以上就是将 App Store Server API 与 Original StoreKit 和 StoreKit 2 一起结合使用的案例。接下来，我们一起看看怎么调用 App Store Server API。

### 探讨 JWT 签名细节

#### JWT 的优势

App Store Server API 为什么使用 JWT(JSON Web Tokens) 作为身份验证参数呢？

其实 JWT 是目前最流行的跨域认证解决方案，什么是跨域认证呢？如今的互联网服务都离不开用户认证，在解答这些问题之前，我们先来看看实现一个用户认证的流程：

```
1、用户向服务器发送用户名和密码。
2、服务器验证通过后，在当前对话（session）里面保存相关数据，比如用户角色、登录时间等等。
3、服务器向用户返回一个 session_id，写入用户的 Cookie。
4、用户随后的每一次请求，都会通过 Cookie，将 session_id 传回服务器。
5、服务器收到 session_id，找到前期保存的数据，由此得知用户的身份。
```

这种流程存在什么问题？扩展性不好，无法适应现在的服务端架构。如果只是单台服务器是没有问题，但如果是服务器集群，或者是跨域的服务器架构，就要求 session 数据共享，每台服务器都能够读取 session。

session 在多个服务器之间共享就是最大的问题，服务器间要做到实时共享 session，另外不同业务的服务器可能 session 逻辑不一样，可能无法做到共享。所以另一种方案是服务器索性不保存 session 数据，所有数据都保存在客户端，每次请求都发回服务器。JWT 就是这种方案的一个代表。

#### JWT 的原理

JWT 是一个开放式标准（规范文件 [RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519)），用于网络主机之间以 JSON 对象安全传输信息。而 JWS 是其中的一种实现规范（规范文件 [RFC 7515](https://datatracker.ietf.org/doc/html/rfc7515)），表示签名过的 JWT。也就是说，可以通过 JWS 验证信息是否被篡改，用于验证内容的真实性。

JWT 由三部分组成，通过点号 `.` 进行分割。每个部分都是经过 Base64Url 编码的字符串。第一部分 (Header) 和第二部分 (Payload) 在解码后应该是有效的 JSON，最后一部分 (签名) 是通过指定的算法得到在前两部分上所得到的签名数据。

JWT 格式：

```
base64(header) + '.' + base64(payload) + '.' + sign( Base64(header) + "." + Base64(payload) )
```

这样说可能比较抽象，我们举一个例子来说，假设我们需要创建一个身份认证的 JWT 字符串：

header 内容：

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

payload 内容：

```json
{
  "姓名": "iHTCboy",
  "角色": "管理员",
  "到期时间": "2022年6月30日0点0分"
}
```

因为 header 算法是 `HS256`，所以假设 secret 设置为 123456，则可以得到最终的 JWT 编码后的字符串：

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyLlp5PlkI0iOiJpSFRDYm95Iiwi6KeS6ImyIjoi566h55CG5ZGYIiwi5Yiw5pyf5pe26Ze0IjoiMjAyMuW5tDbmnIgzMOaXpTDngrkw5YiGIn0.vZhFBP0EIP2pE29X_7G_1dM7JflIRFouJcXjjo_BAnM
```

具体要怎么验证 JWT 是否合法，开发者可以根据 JWT 的规范自行解析，也可以使用验证 JWS 的第三方库，可参考 jwt.io 网站的 [JSON Web Token Libraries](https://jwt.io/libraries)，也可以使用 [jwt.io](https://jwt.io/) 在线网站进行验证：

![WWDC22_session_10040_12](https://ihtcboy.com/images/WWDC22_session_10040_12.png)

但是 HS256 算法加上一个密钥即可，这种方式严格依赖密钥，但在分布式场景，可能多个服务都需要验证 JWT，若要在每个服务里面都保存密钥，那么安全性将会大打折扣，如果密钥一旦泄露，任何人都可以随意伪造 JWT。所以，应该怎么保证呢？

JWT 的原理现在读者应该了解基本知识了，保证数据未被篡改，JWS 核心就是签名，而检查签名的过程就叫做验证。更通俗的理解，就是对应前面提到的 JWT 的第三部分 Signature，如何保证数据不被篡改，那么就需要使用数字签名，它保证只有信息的发送者才能产生的别人无法伪造的一段数字串，一般是非对称密钥加密技术与数字摘要技术的结合应用，目前在数字签名中使用的三种非对称算法有 `RSA`、`DSA` 和 `ECDSA`。

> 严格来说，JWT 有两种实现，分别是 JWS (JSON Web Signature) 和 JWE (JSON Web Encryption)。由于 JWS 的应用更为广泛，所以一般说起 JWT 大家默认会认为是 JWS。JWS 的 Payload 是 Base64Url 的明文，而 JWE 的数据则是经过加密的。相对地，相比于 JWS 的三个部分，JWE 有五个部分组成。JWT 还有很多值得探讨的内容，本文只能简单介绍原理，读者可以参考阅读 [引用 1](https://jishuin.proginn.com/p/763bfbd6c8bc)、[引用 2](https://onevcat.com/2018/12/jose-1/)。

#### App Store Server API 的 JWT 使用

接下来我们讲解 JWT 的使用细节，JWT 是调用 App Store Server API 必须生成的签名参数。App Store Server API 使用的前提条件：

- 调用 App Store Server API 时必须验证你的合法身份，通过 JWT 来验证
- 每次请求 API 需要包含这个 JWT 的请求头信息
- JWT 由 header（签名头）、payload（有效负载）和 signature（签名）组成

![WWDC22_session_10040_13](https://ihtcboy.com/images/WWDC22_session_10040_13.png)
具体来说，JWT 签名分为三个部分，用句点分隔，Base64 编码的 header（签名头）、 Base64 编码的 payload（有效负载）和 signature（签名）组成，最后的签名部分，根据 header 定义的签名算法和类型进行签名。

具体 JWT 字段的含义：

| 字段 | 含义 | 字段值说明 |
|---|:--|---|
| alg | Encryption Algorithm，加密算法 | 默认值：ES256。App Store Server API 的所有 JWT 都必须使用 ES256 加密进行签名。 |
| kid | Key ID，密钥 ID | 您的私钥 ID，值来自 App Store Connect 的内购密钥页面。 |
| type | Token Type，令牌类型 | 默认值：JWT |
| iss | Issuer，发行人 | 您的发卡机构 ID，值来自 App Store Connect 的 API 密钥页面。 |
| iat | Issued At，发布时间 | 秒，以 UNIX 时间（例如：1623085200）发布令牌的时间 |
| exp | Expiration Time，到期时间 | 秒，令牌的到期时间，以 UNIX 时间为单位。在 iat 中超过 60 分钟过期的令牌无效（例如：1623086400） |
| aud | Audience，受众 | 固定值：appstoreconnect-v1 |
| bid | Bundle ID，套装 ID | 您的 app 的套装 ID，即 app 包名 |

![WWDC22_session_10040_14](https://ihtcboy.com/images/WWDC22_session_10040_14.png)

生成 JWT 还需要生成一个私钥文件，可以参考苹果文档 [Creating API Keys to Use With the App Store Server API](https://developer.apple.com/documentation/appstoreserverapi/creating_api_keys_to_use_with_the_app_store_server_api)。一般生成 JWT token 我们会通过第三方库来生成，可以参考 [JSON Web Token Libraries](https://jwt.io/libraries)。具体请求可参考上图的 `curl` 命令示例，替换 `${token}` 和 `${originalTransactionId}` 就可以。

关于 App Store Server API 苹果怎么验证我们的生成的这个 JWT token 是否可信呢？我们在苹果后台生成 `.p8` 格式的私钥文件，苹果服务器保存了公钥文件，当我们请求 App Store Server API 时，苹果根据公钥文件就可以验证 JWT 是否可信。当然开发者也可以自己验证，首先执行下面命令，把  `.p8` 私钥文件导出公钥文件：

```
openssl ec -in AuthKey_123ABC456.p8 -pubout -out AuthKey_123ABC456_public.p8
```

然后可以在 [jwt.io](https://jwt.io/) 网站选择 `ES256` 算法后，复制 JWT token 和公钥文件的内容到网页，就可以看到验证结果。

![WWDC22_session_10040_15](https://ihtcboy.com/images/WWDC22_session_10040_15.png)

关于 App Store Server API 请求的细节，可以参考苹果文档 [Generating Tokens for API Requests](https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests)，或这篇实践教程 [App Store Server API 实践总结](https://juejin.cn/post/7056976669139009573)。

### 校验签名的 transactions（交易票据）

WWDC21 推出的 StoreKit 2 的交易票据（receipt）是使用 JWS(JSON Web Signature) 格式签名。JWS 表示签名过的 JWT，也就是说，可以通过 JWS 验证信息是否被篡改，用于验证内容的真实性。关于 JWS transaction 的校验，其实从去年开始就有非常多的开发者吐槽，不知道如何校验：

- [Validate StoreKit2 in-app purchase… | Apple Developer Forums](https://developer.apple.com/forums/thread/691464)
- [App Store Notifications v2 - Verif… | Apple Developer Forums](https://developer.apple.com/forums/thread/693351)
- [iOS - Validate Apple StoreKit2 in-app purchase receipt jwsRepresentation in backend - Stack Overflow](https://stackoverflow.com/questions/69438848/validate-apple-storekit2-in-app-purchase-receipt-jwsrepresentation-in-backend-n)

现在苹果对验证 StoreKit 2 已签名的交易票据（JWS transactions）进行了详细的解答，大概分为三步：

![WWDC22_session_10040_16](https://ihtcboy.com/images/WWDC22_session_10040_16.png)

- 具体 JWT 的格式，先用 Base64 解码 header 获取签名信息
- 使用 header 解码中的 `alg` 字段确定使用的签名算法 
- 验证 header 解码中的 `x5c` 确认签名的证书链

![WWDC22_session_10040_18](https://ihtcboy.com/images/WWDC22_session_10040_18.png)

首先 `x5c`表示 X509 证书链，X.509 是一种证书标准，主要定义了证书中应该包含哪些内容。其详情可以参考 [RFC5280](https://datatracker.ietf.org/doc/html/rfc5280)，SSL 使用的就是这种证书标准。同样的 X.509 证书，可能有不同的编码格式，目前有以下两种编码格式：

- DER：Distinguished Encoding Rules，打开看是二进制格式，不可读.
- PEM：Privacy Enhanced Mail，打开看文本格式，以 `—–BEGIN…` 开头，`—–END…` 结尾，内容是 BASE64 编码。

那么 x5c 证书链成功验证，就表示这个签名的 JWS 是可信的，所以，x5c 证书链的规范如下：

![WWDC22_session_10040_17](https://ihtcboy.com/images/WWDC22_session_10040_17.png)

- 每个证书都由前一个证书签名
- 最开头的证书是根证书，是苹果的证书 [Apple Root CA - G3 Root](https://www.apple.com/certificateauthority/AppleRootCA-G3.cer)
- 最后一个证书叫叶证书，用于签名 JWS 

所以，x5c 证书链的生成，简单来说，苹果的根证书（只能从苹果下载，相当于信任）签名包含了中间的证书，中间的证书签名包含了叶证书，而叶证书就是签名 JWS 内容的证书。证书链签名规则如下：
![WWDC22_session_10040_19](https://ihtcboy.com/images/WWDC22_session_10040_19.png)

所以验证 x5c 证书链，就是反过来，我们验证叶证书是由中间签名证书签名的，然后确保中间签名证书是由根证书签名的，最后，根证书与 Apple 证书颁发机构提供的证书相匹配。如果这些步骤都验证成功，则整个 x5c 链验证就可以认为是合法的证书链。如果有证书不匹配，则不应该信任该链。
![WWDC22_session_10040_20](https://ihtcboy.com/images/WWDC22_session_10040_20.png)

原理讲清楚后，那么我们应该怎么验证证书链呢？最简单的方法是使用 OpenSSL 命令验证 x5c 证书链。具体命令的参数 `-trusted` 带上信任的根证书，这里是苹果的 [Apple Root CA - G3 Root](https://www.apple.com/certificateauthority/AppleRootCA-G3.cer)，可以在苹果网站下载 [Apple PKI](https://www.apple.com/certificateauthority/) 证书。参数 `-untrusted` 就是中间证书和叶证书。

执行这个 `openssl verify -trusted xxx.pem -untrusted xxx.pem leaf.pem` 后，根据返回的结果码判断，如果表示验证不成功，则此 JWS 数据可能被篡改且不应使用。

![WWDC22_session_10040_21](https://ihtcboy.com/images/WWDC22_session_10040_21.png)
> 注：苹果网站下载的 AppleRootCA-G3 是 `.cer` 格式，需要把 .cer 转换成 .pem 格式，转换命令： `openssl x509 -inform der -in AppleRootCA-G3.cer -out AppleRootCA-G3.pem`

这里补充说明一下，在苹果 [Apple PKI](https://www.apple.com/certificateauthority/) 证书网页有四个苹果根证书，为什么使用 AppleRootCA-G3 这个根证书呢？

| 证书 | 证书组织  | 签名算法 |
|---|---|---|
| [Apple Inc. Root](https://www.apple.com/appleca/AppleIncRootCertificate.cer) | Apple Inc. | 带 RSA 加密的 SHA-1 |
| [Apple Computer, Inc. Root](https://www.apple.com/certificateauthority/AppleComputerRootCertificate.cer) | Apple Computer, Inc. | 带 RSA 加密的 SHA-1 |
| [Apple Root CA - G2 Root](https://www.apple.com/certificateauthority/AppleRootCA-G2.cer) | Apple Inc. | 带 RSA 加密的 SHA-384 |
| [Apple Root CA - G3 Root](https://www.apple.com/certificateauthority/AppleRootCA-G3.cer) | Apple Inc. | 带 SHA-384 的 ECDSA 签名 |

所以从表格可以看出，因为苹果 JWS 使用 `ES256` 算法，所以只能使用 AppleRootCA-G3 这个根证书。另外大家可能看到 `Apple Computer, Inc.`，因为 2007 MacWorld 大会上，乔布斯亲自推出传闻已久的 iPhone 手机，为消除公司只生产电脑的形象，将 `苹果电脑公司` 改名为 `苹果公司`，所以这个根证书还保留着（目前这个证书有效期是 2005 年至 2025 年），不清楚过期后苹果还否会更新这个证书呢？

验证了 x5c 证书链，还要用叶证书，验证一下 JWS 签名内容是否正确，至此签名验证成功后，就表示 JWS 内容可信。示例代码如下：
![WWDC22_session_10040_22](https://ihtcboy.com/images/WWDC22_session_10040_22.png)
> 关于验证 JWS 的第三方库，可以参考 jwt.io [JSON Web Token Libraries](https://jwt.io/libraries)。

### 从 StoreKit 的 verifyReceipt 迁移到 App Store Server API

接下来，我们回顾一下，从 Original StoreKit 的 verifyReceipt 接口迁移到 App Store Server API 的使用案例。

![WWDC22_session_10040_23](https://ihtcboy.com/images/WWDC22_session_10040_23.png)

- 检查订阅状态的变化
- Original StoreKit：调用 verifyReceipt 接口，根据 latest_receipt 字段判断状态
- StoreKit 2：调用 Get Subscription Status 接口查询

所以，获取订阅品项的最新状态的交互流程如图：
![WWDC22_session_10040_24](https://ihtcboy.com/images/WWDC22_session_10040_24.png)

通过 App Store Server API 的 `/inApps/v1/subscriptions/{originalTransactionId}` 接口获取订阅品项的最新状态，包含最新的签名交易票据和续订更新信息等。

接下来，我们来看获取最新交易状态的案例。获取最新交易票据，可以知道用户购买了什么品项、订阅了什么品项，或者续订了什么品项等。
![WWDC22_session_10040_25](https://ihtcboy.com/images/WWDC22_session_10040_25.png)
对于用户来说，交易票据的状态获取有两种情况：

- Original StoreKit：通过 verifyReceipt 接口返回的 `in_app` 和 `latest_receipt_info` 获取
- StoreKit 2：通过 App Store Server API 的 `Get transaction History` 接口条件过滤获取

> App Store Server API 的条件过滤功能，可以参考 [What's new with in-app purchase - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10007)。

所以，获取最新交易票据状态的交互流程如图：
![WWDC22_session_10040_26](https://ihtcboy.com/images/WWDC22_session_10040_26.png)
> 如果读者想进一步了解这个流程的客户端代码具体该如何实现，可以参考 [What's new in App Store Connect - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10043)

最后，我们来说一下 `appAccountToken` 的更新。`appAccountToken` 字段是 StoreKit 2 交易票据提供的开发者 app 与用户绑定关联的 UUID。在已签名的交易票据、已签名的续订和该交易的苹果服务器通知中都会包含。

以前的 Original StoreKit 是不支持 appAccountToken 字段，因为它是 StoreKit2 的新功能。而现在，苹果增加了对 Original StoreKit 中的 `applicationUsername` 字段中提供 UUID 支持，从而让服务端不需要区分 Original StoreKit 还是 StoreKit 2，都可以支持 appAccountToken 所做的逻辑功能。详细的更新介绍，可以参考文章 [苹果内购录：关于透传字段的一些讨论](https://mp.weixin.qq.com/s/ZslPiqGmC6B8OfgwZeasrw)。

![WWDC22_session_10040_27](https://ihtcboy.com/images/WWDC22_session_10040_27.png)

以上就是本次 session 关于 App Store Server API 部分的更新。

接下来，我们讲解 App Store Server Notifications 内容的更新。

## App Store Server Notifications

关于 App Store Server Notifications 的内容，将从以下四方面进行讲解：

- 配置 App Store Server Notifications
- 迁移到 App Store Server Notifications V2
- 恢复 App Store Server Notifications
- 通过 App Store Server Notifications 获得洞察力

![WWDC22_session_10040_28](https://ihtcboy.com/images/WWDC22_session_10040_28.png)

首先，App Store Server Notifications V2 兼容 Original StoreKit，并且全面支持应用内购买数据。详细的更新内容，可以参考我们之前的文章：[IAP 后台通信优化与实践](https://mp.weixin.qq.com/s/dWsRKRJsYMRl0GX_36T-kg)。

![WWDC22_session_10040_29](https://ihtcboy.com/images/WWDC22_session_10040_29.png)

### 配置 App Store Server Notifications

如何配置 App Store Server Notifications 来接收通知，可以在 App Store Connect 中的应用页面，看到配置的部分：
![WWDC22_session_10040_30](https://ihtcboy.com/images/WWDC22_session_10040_30.png)

可以分别配置生产和沙盒环境的回调通知链接，然后每个链接的配置，可以设置 V1 或 V2 版本的通知。
![WWDC22_session_10040_31](https://ihtcboy.com/images/WWDC22_session_10040_31.png)
> 这里建议如果开发者现在使用的是 V1 版本的通知，迁移到 V2 版本前，先配置一个沙盒环境的 V2 链接进行测试，测试通过后，再切换到生产环境的 V2 版本。

接口通知的链接，需要注意服务器配置：
![WWDC22_session_10040_32](https://ihtcboy.com/images/WWDC22_session_10040_32.png)

- 有效的 HTTPS 证书
- 允许 Apple 的公共 IP 段（17.0.0.0/8）访问您的服务器
- 使用 Test Notification API 来测试通知接口（测试接口，下文会讲到）

App Store Server Notifications V2 版本通知的内容是 JWS 格式，所以需要验证签名：
![WWDC22_session_10040_33](https://ihtcboy.com/images/WWDC22_session_10040_33.png)

签名证书验证可信后，可以读取 payload 的内容：
![WWDC22_session_10040_34](https://ihtcboy.com/images/WWDC22_session_10040_34.png)

这个内容字段，需要开发者注意一下，`notificationUUID` 字段是每个通知的唯一标识符，如果服务器重试通知，则重试通知包含相同的 notificationUUID，有助于开发者服务器处理了通知但没有及时响应时接到到重复通知内容的情况。`signedDate` 字段是每个通知的创建时间，这对于检测重试通知也特别有用，具体作用下文会讲解。`appAppleId` 和 `bundleId` 可以用于验证 app 是否为开发者的。

### 迁移到 App Store Server Notifications V2

App Store Server Notifications V1 版本虽然现在还可以使用，但是苹果强烈建议开发者升级迁移到 App Store Server Notifications V2，因为 V2 版本增加了更多的状态通过，并且是支持 Original StoreKit 版本，完成是兼容性迁移，不会很麻烦，收益也更好。具体 V1 和 V2 的区别和优劣势，可以参考文章：[IAP 后台通信优化与实践](https://mp.weixin.qq.com/s/dWsRKRJsYMRl0GX_36T-kg)。

![WWDC22_session_10040_35](https://ihtcboy.com/images/WWDC22_session_10040_35.png)

App Store Server Notifications V2 增加了新的类型和添加新的子类型字段，从而提高所提供的通知场景更加详细并扩展更多的情景，以下这个示例就是订阅品项的生命周期的每一步提供通知：
![WWDC22_session_10040_36](https://ihtcboy.com/images/WWDC22_session_10040_36.png)

上面这个流程图，我们假设一个用户订阅成功后，开发者可能收到 `SUBSCRIBED` 类型和带有 `INITIAL_BUY` 子类型的通知，或者用户使用了优惠订阅，则收到 `OFFER_REDEEMED` 类型和带有 `INITIAL_BUY` 子类型的通知，通知中包含首次交易的票据和订阅的续订信息。

时间流逝，用户一直订阅续订，所以一直处于续订状态（Renewing subscription）。每次续订时，苹果都会发送一个 `DID_RENEW` 通知，其中包含新的（支付成功）的交易票据。而当用户停用自动续订时，订阅进入即将到期的订阅状态时（Expiring subscription），开发者将收到 `DID_CHANGE_RENEWAL_STATUS` 类型和带有 `AUTO_RENEW_DISABLED` 子类型的通知。最后，如果用户不重新启用自动续订，则在订阅到期时，订阅会进入过期状态（Expired），开发者将收到 `EXPIRED` 类型和带有 `VOLUNTARY` 子类型的通知。

还有 `Pending price increase`（订阅涨价）、`Grace period enabled?`（启用宽限期）/ `Grace period`（账单宽限期）、`Billing retry`（扣费重试）等通知，另外这个流程图没有展示订阅退款通知和订阅撤销通知等场景。

所以可以感受到，App Store Server Notifications V2 通知覆盖了大量场景，可以通知开发者订阅品项的生命周期的每个步骤，苹果也在努力覆盖更多的过渡状态，希望给开发者提供更有价值的通知。最后，关于 App Store Server Notifications 全部的通知类型，可以阅读苹果 [App Store Server Notifications](https://developer.apple.com/documentation/appstoreservernotifications) 文档。


### 恢复 App Store Server Notifications

App Store Server Notifications 是开发者被动接收通知，所以总会有开发者的服务器出现故障的情况，时间可能是几分钟，甚至是几天。所以总有错过接收通知的情况，所以，现在我们可以通过一些方法来解决这个问题了！

例如你的服务器，接到到 1 和 2 的通知，然后服务器宕机等，导致 3、4、5 通知无法接收，然后服务器恢复了，接收到 6 通知，然后 3 和 4 通知可能会晚于 6 通知，5 晚于 7 通知等情况。
![WWDC22_session_10040_37](https://ihtcboy.com/images/WWDC22_session_10040_37.png)

那么针对上述这种情况，有几种方法可以处理。

首先，苹果将 App Store Server Notifications V2 通知的重试策略进行了调整，在首次尝试通知后没有收到来自开发者服务器的 200 回复时，则会按如下方式重试：：

- App Store Server Notifications V1：重试三次；在上次尝试后 6、24 和 48 小时。
- App Store Server Notifications V2：重试五次；在上次尝试后 1、12、24、48 和 72 小时。

增加了两次重试次数，并且时间缩短到第一次重试为 1 小时后，对于开发者来说，一般的服务器故障能在一小时内容恢复，所以一小时后重试更加有效。

这里就有一个疑问，如何检测通知是原始通知还是重试通知？开发者可以检查通知里的 `signedDate` 字段，它表示通知的签名时间，也就是说通知发送的时间，通过对比通知里的这个字段与当前接收到的时间，就知道这个通知是否为重试通知。

![WWDC22_session_10040_38](https://ihtcboy.com/images/WWDC22_session_10040_38.png)

比如，通知 6 和通知 3，服务器先收到 6 通知，并不意味着 6 比 3 通知早。比如通知 6 是用户取消订阅，通知 3 是用户续订订阅，所以开发者要通过 `signedDate` 字段，确保通知的顺序逻辑正确。 
![WWDC22_session_10040_39](https://ihtcboy.com/images/WWDC22_session_10040_39.png)

另外通知会重试，所以可能会存在重复通知的情况，所以请务必检查通知的 `notificationUUID` 字段，如果发现重复的 UUID，可以删除这些重复数据。
![WWDC22_session_10040_40](https://ihtcboy.com/images/WWDC22_session_10040_40.png)

最后，我们来看看 App Store Server API 今年新推出的 `Get Notification History`（获取通知历史记录） API，它提供了六个月内的苹果服务器发送通知的历史记录查询。关于这个 API 的详细介绍，可以参考 [What's new with in-app purchase - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10007)。

**获取通知历史记录接口**允许在特定时间跨度内进行查询，比如开发者服务器宕机解决后，可以使用开始和结束时间戳来查询宕机期间所有未接收到的通知。查询时间参数格式如下：
![WWDC22_session_10040_41](https://ihtcboy.com/images/WWDC22_session_10040_41.png)

当然，考虑到宕机时间如果很久，可能会有很多未接收的通知，所以也可以指定具体的通知类型进行过滤。比如 `notificationType` 设置为 `DID_RENEW` 通知类型来查询订单更新的通知。
![WWDC22_session_10040_42](https://ihtcboy.com/images/WWDC22_session_10040_42.png)

最后，还可能通过 `originalTransactionId` 过滤到特定用户。
![WWDC22_session_10040_43](https://ihtcboy.com/images/WWDC22_session_10040_43.png)

通过 `Get Notification History`（通知历史记录）接口，可以方便开发者获取到错过的通知，当处理用户反馈订阅状态与预期不同时，获取通知历史记录在客户支持中也非常有帮助。最后回顾一下接口的返回内容，这里简单起见，只列出部分字段内容：
![WWDC22_session_10040_44](https://ihtcboy.com/images/WWDC22_session_10040_44.png)

可以看到 `notificationHistory` 数组中每一条就是一个通知，`signedPayload` 就是签名的 JWS 通知内容，`firstSendAttemptResult` 字段表示苹果服务器记录的初始通知的响应结果，比如通知成功的情况下，这个值是 `SUCCESS`，但是可能开发者服务器配置或者宕机等，会有不同的值，比如我们这里的 `SSL_ISSUE`，表示开发者服务器的 SSL 证书或进程存在问题。所以，除了看到通知未发送成功之外，此字段还提高了诊断服务器问题的可见性。

![WWDC22_session_10040_45](https://ihtcboy.com/images/WWDC22_session_10040_45.png)
所以，如果开发者刚刚接入 App Store Server Notifications，那么开发者服务器并没有用户之前的通知历史记录，那么就可以使用 `Get Notification History` 接口获取之前的通知历史记录，这也是接口的作用之一。

另外，苹果新提供的 `Get Test Notification Status` API 也具有相同的 `firstSendAttemptResult` 字段，方便测试通知时诊断。详细可以参考 [What's new with in-app purchase - WWDC22](https://developer.apple.com/videos/play/wwdc2022/10007)。

### 通过 App Store Server Notifications 获得洞察力

最后让我们来了解一下，怎么通过通知了解用户购买或取消的原因，从中洞察商业机会。比如 App Store Server Notifications V2 提供了一些新的通知子类型，比如 `EXPIRED` 或 `DID_CHANGE_RENEWAL_STATUS`。

例如 `EXPIRED` 类型，开发者一般收到通知后，会将用户的订阅标记为过期并撤销对产品服务的访问权限。但是，**了解用户过期的原因通常很有用**。是由于扣费问题、自愿取消还是订阅价格上涨？

另一个通知 `DID_CHANGE_RENEWAL_STATUS` 也是获得额外信息和机会的一个很好的例子。表面上收到这个通知，表示用户的订阅状态更新了，表面上开发者不需要采取任何的操作，相比 EXPIRED 通知，优先级可能更低，但这往往是错误的理解！这个通知是一个机会！

首先，此通知是尝试在订阅到期之前赢回客户的绝佳机会。特别是由于停用自动续订可能发生在 app 之外，这可能是在到期日期之前续订状态更改通知的另一个唯一触发的通知。

此外，这个通知还提供对客户行为的洞察。可用于确定订阅者在续订期间何时取消。是订阅到期前一天吗？新订阅者是否会在注册您的服务后立即停用自动续订？此类信息对于了解取消的原因和改进您的产品非常重要。

![WWDC22_session_10040_46](https://ihtcboy.com/images/WWDC22_session_10040_46.png)

最后，某些场景可能永远不会有通知，但是通过查询用户的订单历史中有记录。例如，用户可以在订阅期到期之前停用但随后重新激活自动续订，由于这一切都发生在订阅期内，因此不会影响订阅的长期状态，所以可能不会有通知。

总体而言，App Store Server Notifications V2 通知通过在用户订阅周期的每一步提供信息来增强和创造了解客户行为的机会，覆盖比以往更多的场景。

### Wrap-up（小结）

![WWDC22_session_10040_47](https://ihtcboy.com/images/WWDC22_session_10040_47.png)

最后，总结一下今天的内容：

- 提供改进管理和跟踪 IAP 的能力。
- 适用于所有的客户端，兼容 Original StoreKit 和 v2 版本，并提高监控订阅生命周期的能力。
- 以上功能在 Sandbox（沙盒） 和 Production（生产）环境中都可用，并且是开发者现有服务和系统的重要补充。

## 总结

从去年推出 StoreKit 2、App Store Server API 和 App Store Server Notifications V2，到今年的优化完善，都是开发者们一直以来期待的功能，现在苹果已逐步完善应用内购买（IAP），相信读者都有所感受。另外，随着应用市场的存量饱和，竞争越来越激烈，获取一个新用户或者挽留一个付费用户的成本很高，所以，苹果也希望开发者能根据这么新 API 的特性，尽早的推进服务端使用这些新的 Server API，对于获得用户的购买行为和感知体验，有更敏捷的洞察力和更准确的预流失风险评估等。总之，善待每一个用户，提升用户体验，是突出重围和赢得用户的绝佳方式。

## 参考链接

- [Explore in-app purchase integration and migration - WWDC22 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2022/10040/)
- [What's new with in-app purchase - WWDC22 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2022/10007)
- [What's new in App Store Connect - WWDC22 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2022/10043)
- [初见 StoreKit 2](https://mp.weixin.qq.com/s/arA0_uyc4CWMQ7WJ2RanJA)
- [IAP 后台通信优化与实践](https://mp.weixin.qq.com/s/dWsRKRJsYMRl0GX_36T-kg)
- [IAP 用户退款与客诉处理优化](https://mp.weixin.qq.com/s/MtytymgkcP3_oAH7JyI1og)
- [Creating API Keys to Use With the App Store Server API | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/creating_api_keys_to_use_with_the_app_store_server_api)
- [Generating Tokens for API Requests | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests)
- [JSON Web Tokens - jwt.io](https://jwt.io/)
- [JSON Web Token Libraries - jwt.io](https://jwt.io/libraries)
- [你真的了解 JWT？这篇刷新你的认知！](https://jishuin.proginn.com/p/763bfbd6c8bc)
- [与 JOSE 战斗的日子 - 写给 iOS 开发者的密码学入门手册 (基础) | OneV's Den](https://onevcat.com/2018/12/jose-1/)
- [WWDC21 - App Store Server API 实践总结](https://juejin.cn/post/7056976669139009573)
- [Apple Root CA - G3 Root](https://www.apple.com/certificateauthority/AppleRootCA-G3.cer)
- [Apple PKI - Apple](https://www.apple.com/certificateauthority/)
- [苹果内购录：关于透传字段的一些讨论](https://mp.weixin.qq.com/s/ZslPiqGmC6B8OfgwZeasrw)
- [App Store Server Notifications | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreservernotifications)
