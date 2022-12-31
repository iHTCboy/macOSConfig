title: WWDC21 - App Store Server API 实践总结
date: 2022-01-25 11:14:10
categories: technology #induction life poetry
tags: [WWDC21,App Store Server API]  # <!--more-->
reward: true

---

> 本文首发于 [WWDC21 - App Store Server API 实践总结 - 掘金](https://juejin.cn/post/7056976669139009573)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

> 关于 App Store 用户退款时并没有通知开发者，直到 2020 年 6 月苹果提供了退款通知，但是因为不是 API 方式，导致开发者不一定能收到退款通知。另外像用户充值成功但 app 没有提供金币或服务等，开发者一般无法判断用户是否真的付款了。综上，苹果在 WWDC21 带来了全新强大的 App Store Server API，本文让我们从了解到实践的过程，全面认识 App Store Server API。 

<!--more-->

![AppStoreServerAPI-00](https://ihtcboy.com/images/2022-AppStoreServerAPI-00.png)

## 一、前言

大家好，我们在去年在 WWDC21 后 6 月 17 日发表了总结文章《[苹果iOS内购三步曲 - WWDC21](https://juejin.cn/post/6974733392260644895)》。当时只是根据苹果的演讲内容进行了梳理，当时的很多接口和功能并没有上线，比如根据玩家的发票订单号查询用户的苹果收据，查询历史订单接口等，当时文章并没有深入的分析，而如今都 2022 年了，苹果 App Store Server API 已经上线，所以，今天我们一起来了解一下，相关 API 的具体使用实践吧~


## 二、App Store Server API 

首先，我们先列一下，WWDC21 苹果提供了那些 Server API，然后我们在看看怎么实践这些接口，最后在总结一下注意事项。

### 2.1 API 简介

**查询用户订单的收据**
```
GET https://api.storekit.itunes.apple.com/inApps/v1/lookup/{orderId}
```

* [Look Up Order ID](https://developer.apple.com/documentation/appstoreserverapi/look_up_order_id)：使用订单ID从收据中获取用户的应用内购买项目收据信息。


**查询用户历史收据**

```
GET https://api.storekit.itunes.apple.com/inApps/v1/history/{originalTransactionId}
```

* [Get Transaction History](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)：获取用户在您的 app 的应用内购买交易历史记录。


**查询用户内购退款**

```
GET https://api.storekit.itunes.apple.com/inApps/v1/refund/lookup/{originalTransactionId}
```

* [Get Refund History](https://developer.apple.com/documentation/appstoreserverapi/get_refund_history)：获取 app 中为用户退款的所有应用内购买项目的列表。


**查询用户订阅项目状态**

```
GET https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/{originalTransactionId}
```

* [Get All Subscription Statuses](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses)：获取您 app 中用户所有订阅的状态。

**提交防欺诈信息**

```
PUT https://api.storekit.itunes.apple.com/inApps/v1/transactions/consumption/{originalTransactionId}
```

[Send Consumption Information](https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information)：当用户申请退款时，苹果通知（CONSUMPTION_REQUEST）开发者服务器，开发者可在12小时内，提供用户的信息（比如游戏金币是否已消费、用户充值过多少钱、退款过多少钱等），最后苹果收到这些信息，协助“退款决策系统” 来决定是否允许用户退款。


**延长用户订阅的时长**

```
PUT https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/extend/{originalTransactionId}
```
[Extend a Subscription Renewal Date](https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date)：使用原始交易标识符延长用户有效订阅的续订日期。（相当于免费给用户增加订阅时长）


### 2.2 接口参数说明

**App Store Server API** 是苹果提供给开发者，通过服务器来管理用户在 App Store 应用内购买的一套接口（REST API）。


#### URL

线上环境的 URL：

```
https://api.storekit.itunes.apple.com/
```


沙盒环境测试：

```
https://api.storekit-sandbox.itunes.apple.com/
```

#### JWT 简介

调用这些 API 需要 JWT（`JSON Web Token`）进行授权。那么什么是 JWT 呢？

`JWT` 是一个开放式标准（规范文件 [RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519)），用于在各方之间以 JSON 对象安全传输信息。有两种实现，一种基于 `JWS` 的实现使用了`BASE64URL`编码和**数字签名**的方式对传输的`Claims`提供了完整性保护，也就是仅仅保证传输的`Claims`内容不被篡改，但是会暴露明文。另一种是基于 `JWE` 实现的依赖于加解密算法、`BASE64URL`编码和**身份认证**等手段提高传输的`Claims`内容被破解的难度。

* `JWS`（规范文件 [RFC 7515](https://datatracker.ietf.org/doc/html/rfc7515)）： `JSON Web Signature`，表示使用 `JSON` 数据结构和 `BASE64URL` 编码表示经过数字签名或消息认证码（`MAC`）认证的内容。
* `JWE`（规范文件 [RFC 7516](https://datatracker.ietf.org/doc/html/rfc7516)）： `JSON Web Encryption`，表示基于 `JSON` 数据结构的加密内容。

目前苹果 JWT 相关的内容，都是基于 JWS 实现，所以下文的 JWT 默认指 JWS。


JWT（JWS) 由三部分组成：

```jwt
base64(header) + '.' + base64(payload) + '.' + sign( Base64(header) + "." + Base64(payload) )
```

* **header**：主要声明了 JWT 的签名算法；
* **payload**：主要承载了各种声明并传递明文数据；
* **signture**：拥有该部分的 JWT 被称为 JWS，也就是签了名的 JWS。


JWT 的内容示例： 

```jwt
eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwidGVhbSI6IjM35omL5ri45oqA5pyv6L-Q6JCl5Zui6ZifIiwiYXV0aG9yIjoiaUhUQ2JveSIsImlhdCI6MTUxNjIzOTAyMn0.dL5U_t_DcfLTY9WolmbU-j81jrZqs1HhHqYKM6HSxVgWCGUAKLzwVrnLuuMCnSRnrW9vmGKNqNvrzG8cEwxvAg
```

详细的 JWT 内容，这里就略过了，大家可以自动搜索了解更多。

#### 组装 JWT

知道了基本的 JWT 知识，我们就可以开工啦。要生成签名的 JWT 有三步：

1. 创建 JWT 标头。
2. 创建 JWT 有效负载。
3. 在 JWT 上签名。

JWT header 示例：

```js
{
    "alg": "ES256",
    "kid": "2X9R4HXF34",
    "typ": "JWT"
}
```

JWT payload 示例：

```js
{
  "iss": "57246542-96fe-1a63e053-0824d011072a",
  "iat": 1623085200,
  "exp": 1623086400,
  "aud": "appstoreconnect-v1",
  "nonce": "6edffe66-b482-11eb-8529-0242ac130003",
  "bid": "com.example.testbundleid2021"
}
```

以上是苹果要求的字段规范，所以不同的 JWT 字符和内容并一样，所以，我们看看苹果对这些字段的定义：

| 字段 | 字段说明 | 字段值说明 |
|---|---|---|
| `alg` | Encryption Algorithm，加密算法 | 默认值：ES256。App Store Server API 的所有 JWT 都必须使用 ES256 加密进行签名。 |
| `kid` | Key ID，密钥ID | 您的私钥ID，值来自 App Store Connect，下文会讲解。 |
| `typ` | Token Type，令牌类型 | 默认值：JWT |
| `iss` | Issuer，发行人 | 您的发卡机构ID，值来自 App Store Connect 的密钥页面，下文会讲解。 |
| `iat` |  Issued At，发布时间 | 秒，以 UNIX 时间（例如：1623085200）发布令牌的时间 |
| `exp` | Expiration Time，到期时间 | 秒，令牌的到期时间，以 UNIX 时间为单位。在iat中超过 60 分钟过期的令牌无效（例如：1623086400） |
| `aud` | Audience，受众 | 固定值：appstoreconnect-v1 |
| `nonce` | Unique Identifier，唯一标识符 | 您仅创建和使用一次的任意数字(例如: "6edffe66-b482-11eb-8529-0242ac130003")。可以理解为 UUID 值。 |
| `bid` | Bundle ID，套装ID | 您的 app 的套装ID（例如：“com.example.testbundleid2021”) |


其中 `kid` 和 `iss` 值是从 [App Store Connect](https://appstoreconnect.apple.com/) 后台创建和获取。


##### 生成密钥 ID（kid）

要生成密钥，您必须在 App Store Connect 中具有管理员角色或帐户持有人角色。登录 [App Store Connect](https://appstoreconnect.apple.com/) 并完成以下步骤：

1. 选择 “用户和访问”，然后选择 “密钥” 子标签页。
2. 在 “密钥类型” 下选择 “App内购买项目”。
3. 单击 “生成API内购买项目密钥”（如果之前创建过，则点击 “添加（+）” 按钮新增。）。
4. 输入密钥的名称。该名称仅供您参考，名字不作为密钥的一部分。
5. 单击 “生成”。


![AppStoreServerAPI-01](https://ihtcboy.com/images/2022-AppStoreServerAPI-01.jpg)


![AppStoreServerAPI-02](https://ihtcboy.com/images/2022-AppStoreServerAPI-02.jpg)

生成的密钥，有一列名为 “密钥 ID” 就是 `kid` 的值，鼠标移动到文字就会显示 `拷贝密钥 ID`，点击按钮就可以复制 kid 值。


##### 生成 Issuer（iss）

同理，`iss` 值的生成，类似：

![AppStoreServerAPI-03](https://ihtcboy.com/images/2022-AppStoreServerAPI-03.jpg)®®

**issuer ID** 值就是 `iss` 的值。

![AppStoreServerAPI-04](https://ihtcboy.com/images/2022-AppStoreServerAPI-04.jpg)


#### 生成和签名 JWT

获取到这里参数后，就需要签名，那么还需要签名的密钥文件。


##### 下载并保存密钥文件

App Store Connect 密钥文件，在刚才生成 `kid`时，列表右边有 `下载 App 内购买项目密钥` 按钮（仅当您尚未下载私钥时，才会显示下载链接。）：

![AppStoreServerAPI-05](https://ihtcboy.com/images/2022-AppStoreServerAPI-05.jpg)

**此私钥只能一次性下载！**

另外 Apple 不保留私钥的副本，将您的私钥存放在安全的地方。

> 注意：将您的私钥存放在安全的地方。不要共享密钥，不要将密钥存储在代码仓库中，不要将密钥放在客户端代码中。如果您怀疑私钥被盗，请立即在 App Store Connect 中撤销密钥。有关详细信息，请参阅 [撤销API密钥](https://developer.apple.com/documentation/appstoreconnectapi/revoking_api_keys)。

![AppStoreServerAPI-06](https://ihtcboy.com/images/2022-AppStoreServerAPI-06.jpg)

> API密钥有两个部分：苹果保留的公钥和您下载的私钥。开发者使用私钥对授权 API 在 App Store 中访问数据的令牌进行签名。

需要注意的是，App Store Server API 密钥是 App Store Server API 所独有的，不能用于其他 Apple 服务（比如 Sign in with Apple 服务或 App Store Connet API 服务等。）。


#### 为 API 请求生成令牌

最终，JWT Header 和 payload 示例：
```js
{
    "alg": "ES256",
    "kid": "2X9R4HXF34",
    "typ": "JWT"
}

{
    "iss": "57246542-96fe-1a63-e053-0824d011072a",
    "iat": 1623085200,
    "exp": 1623086400,
    "aud": "appstoreconnect-v1",
    "nonce": "6edffe66-b482-11eb-8529-0242ac130003",
    "bid": "com.apple.test"
}
```

有了以上参数和密钥文件后，我们就可以按 JWT 规范要求来生成 token 值。下面以 `Python3` 代码来生成 token，其它语言类型。

首先，终端执行命令，安装 ptyhon 依赖库：
```
pip3 install PyJWT
```

我们利用 Python 的 `PyJWT` 库来生成 JWT token。示例代码：

```python
import jwt
import time

# 读取密钥文件证书内容
f = open("/Users/37/Downloads/SubscriptionKey_2X9R4HXF34.p8")
key_data = f.read()
f.close()

# JWT Header
header = {
	"alg": "ES256",
	"kid": "2X9R4HXF34",
	"typ": "JWT"
}

# JWT Payload
payload = {
	"iss": "57246542-96fe-1a63-e053-0824d011072a",
	"aud": "appstoreconnect-v1",
	"iat": int(time.time()),
	"exp": int(time.time()) + 60 * 60, # 60 minutes timestamp
	"nonce": "6edffe66-b482-11eb-8529-0242ac130003",
	"bid": "com.apple.test"
}

# JWT token
token = jwt.encode(headers=header, payload=payload, key=key_data, algorithm="ES256")

print("JWT Token:", token)
```

输出示例：
```jwt
eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjJYOVI0SFhGMzQifQ.eyJpc3MiOiI1NzI0NjU0Mi05NmZlLTFhNjMtZTA1My0wODI0ZDAxMTA3MmEiLCJhdWQiOiJhcHBzdG9yZWNvbm5lY3QtdjEiLCJpYXQiOjE2NDMwMTU1OTQsImV4cCI6MTY0MzAxOTE5NCwibm9uY2UiOiI2ZWRmZmU2Ni1iNDgyLTExZWItODUyOS0wMjQyYWMxMzAwMDMiLCJiaWQiOiJjb20uYXBwbGUudGVzdCJ9.muBKcbT3AnK3WAivbtIr64d2Gu7bVhGL3AhiYnDjb7D3qslHNnASE2EUUuN24jOLsSnLBWkBdwDutl5UU87paw
```

通过这个脚本就可以生成 token 来请求 App Store Server API 了。当然可以把以上代码封装成一个方法，传入 kid 和 iss 等参数，然后返回 token，这里就略过了。


### 2.3 接口讲解

说了这么多，终于回到下文啦！！！

怎么请求 App Store Server API ？苹果给出了一个示例：

```js
curl -v -H 'Authorization: Bearer [signed token]' 
"https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/{original_transaction_id}"
```

也就是用 JWT 生成的 token，放到 App Store Server API 请求链接的 header 部分，key 为 `Authorization`，value为 `Bearer [signed token]`。


接下来，我们通过 Python 的 `requests` 来请求 App Store Server API。大家也可以用其它的工具来模拟，比如在线工具或者 Postman 等。


终端执行命令，安装 ptyhon 依赖库：
```
pip3 install requests
```

```python
import requests
import json

# JWT Token
token = "xxxxx"

# 请求链接和参数
url = "https://api.storekit.itunes.apple.com/inApps/v1/lookup/" + "MK5TTTVWJH"
header = {
	"Authorization": f"Bearer {token}"
}
# 请求和响应
rs = requests.get(url, headers=header)
data = json.loads(rs.text)

print(data)
```

查询结果示例：

```js
{
    'status': 0, 
    'signedTransactions': [
            'eyJhbGciOiJFUz.............',                       
            'eyJ0eXAiOiJKV1.............',               
            'eyJ0eXAiJhbGci.............'
    ]
}
```

接下来，下面就不重复展示请求的示例了，主要是讲解一下接口作用和返回的数据格式，注意事项等。


#### 查询用户订单的收据（Look Up Order ID）

![AppStoreServerAPI-07](https://ihtcboy.com/images/2022-AppStoreServerAPI-07.jpg)


```
GET https://api.storekit.itunes.apple.com/inApps/v1/lookup/{orderId}
```

目前这个 [Look Up Order ID](https://developer.apple.com/documentation/appstoreserverapi/look_up_order_id) 接口只有线上环境的，不支持沙盒环境。因为，这个接口是用户购买项目后，收到苹果的发票时，里面有一列叫订单号 `Order ID`，以前是无法与开发者从苹果获取到的交易订单号 `transactionId` 进行映射关联，而现在，可以通过这个接口查询啦！

响应的数据格式：
![AppStoreServerAPI-08](https://ihtcboy.com/images/2022-AppStoreServerAPI-08.jpg)

这个接口的作用，当用户客诉（充值不到账）时，让玩家提供订单 ID，然后通过这个接口查询订单对应的状态，如果有未消耗的收据（transactionId）时，可以为用户进行补发或者服务支持。（因为能查到 transactionId，说明玩家这个充值订单是有效！至于是否消耗，需要服务端来检查是否有未消耗的收据。）

`status=0`，表示有效的订单号：
```js
{
    'status': 0, 
    'signedTransactions': [
            'eyJhbGciOiJFUz.............',                       
            'eyJ0eXAiOiJKV1.............',               
            'eyJ0eXAiJhbGci.............'
    ]
}
```

大家如果有留意，会看到 signedTransactions 是多个 transaction 交易收据，这是为什么呢？其实，这里一个 `Order ID` 可以会对应多个购买的项目，比如用户在 1 分钟里，同时购买了 2 个项目，那些，苹果在给用户发送发票时，会合并这2个订单为一个订单，此时就只有一个订单号 `Order ID`。

![AppStoreServerAPI-09](https://ihtcboy.com/images/2022-AppStoreServerAPI-09.jpg)

所以，开发者需要注意，`Order ID` 对于一个购买订单来说，不是唯一的。验证用户的 `Order ID` 时，也要遍历完所有的 `signedTransactions`，找到可能未消耗的项目。


每个 JWT decode 后，示例格式：

**header:**
```js
{
    "alg":"ES256",
    "x5c":[
            "MIIEMDC....",
            "MIIDFjC....",
            "MIICQzC...."
            ]
}
```

**payload**
```js
{
    "transactionId": "20000964758895",
    "originalTransactionId": "20000964758895",
    "bundleId": "com.apple.test",
    "productId": "com.apple.iap.60",
    "purchaseDate": 1640409900000,
    "originalPurchaseDate": 1640409900000,
    "quantity": 1,
    "type": "Consumable",
    "inAppOwnershipType": "PURCHASED",
    "signedDate": 1642995907240
}
```

> 这是一个消耗型品项的数据格式。

最后，关于解析 JWT 内容，这里先不深入讲解，下文在统一讲解。


#### 查询用户历史收据（Get Transaction History）

```
GET https://api.storekit.itunes.apple.com/inApps/v1/history/{originalTransactionId}
```

根据  WWDC21 视频介绍，接口可以获取用户在您的 app 的应用内购买交易历史记录。但是在实践中，发现消耗型项目没有查到，重新查看接口文档 [Get Transaction History](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)，发现有了新的更新说明：


**交易历史记录返回结果只支持以下情况：**

* 自动续期订阅
* 非续订订阅
* 非消耗型应用内购买项目
* 消耗型应用内购买项目：如果交易被退款、撤销或 app 尚未完成交易处理等。


响应的数据格式：

![AppStoreServerAPI-10](https://ihtcboy.com/images/2022-AppStoreServerAPI-10.jpg)


需要注意的是，返回的结果中，没有 `status` 字段。

```js
{
    "revision": "1642993906000_1000000954832195",
    "bundleId": "com.apple.test",
    "appAppleId": 925021570,
    "environment": "Production",
    "hasMore": false,
    "signedTransactions": [
        "eyJhbGciOi...",
        "eyJhbGciOi..."
    ]
}
```

默认 `signedTransactions` 返回最多 20 条，目前开发者不能控制这个条数。超过 20 条时，数据有一个字段 `hasMore` 为 ture，表示有更新的历史订单有更新，此时，开发者需要增加请求的查询字段 `revision`，对应的值是从上一次请求返回的数据里对应 `revision` 字段内容。


举例来说，请求更多数据：`/inApps/v1/history/foriginalTransactionId}&revision=8a170756-e913-42fc-8629-76051f9e1134`。

每个 JWT decode 后，示例格式：

**payload**

```js
{
    "transactionId": "1000000954804912",
    "originalTransactionId": "1000000954804912",
    "webOrderLineItemId": "1000000071590544",
    "bundleId": "com.apple.test",
    "productId": "com.apple.iap.month",
    "subscriptionGroupIdentifier": "20919269",
    "purchaseDate": 1642990548000,
    "originalPurchaseDate": 1642990550000,
    "expiresDate": 1642990848000,
    "quantity": 1,
    "type": "Auto-Renewable Subscription",
    "inAppOwnershipType": "PURCHASED",
    "signedDate": 1643024941850
}
```

> 这是一个自动续期订阅品项的数据格式。


需要注意，针对消耗型应用内购买项目，如果交易被退款、撤销，那么会包含更多的字段内容：

```js
{
    "transactionId": "20000966985176",
    "originalTransactionId": "20000966985176",
    "bundleId": "com.apple.test",
    "productId": "com.apple.iap.60",
    "purchaseDate": 1640759047000,
    "originalPurchaseDate": 1640759047000,
    "quantity": 1,
    "type": "Consumable",
    "inAppOwnershipType": "PURCHASED",
    "signedDate": 1643246161338,
    "revocationReason": 0,
    "revocationDate": 1643115549000
}
```
> 这是一个消耗型项目退款的内容格式，详细描述见下一节“内购退款”。



#### 查询用户内购退款（Get Refund History）

```
GET https://api.storekit.itunes.apple.com/inApps/v1/refund/lookup/{originalTransactionId}
```

通过用户的任一个购买的 `originalTransactionId` 可以通过 [Get Refund History](https://developer.apple.com/documentation/appstoreserverapi/get_refund_history) 查到这个用户的所有退款记录订单。

响应的数据格式：

![AppStoreServerAPI-11](https://ihtcboy.com/images/2022-AppStoreServerAPI-11.jpg)


响应中包含的 `signedTransactions` 与 App Store Server 通知中一个或多个 `REFUND` 通知（Notification）中可能是相同。所以，使用此 API 查询您可能错过的任何退款通知，例如在服务器停机期间。

但需要注意，**仅包括 App Store 批准的退款**：消耗性、非消耗型、自动续期订阅和非续期订阅。如果用户没有收到任何 App Store 批准的退款，成功时返回一个空的 signedTransactions 数组。

```js
{
    "signedTransactions": [
        "eyJhbGciO...."
    ]
}
```


**退款的 payload 内容格式：**

```js
{
    "transactionId": "20000966985176",
    "originalTransactionId": "20000966985176",
    "bundleId": "com.apple.test",
    "productId": "com.apple.iap.60",
    "purchaseDate": 1640759047000,
    "originalPurchaseDate": 1640759047000,
    "quantity": 1,
    "type": "Consumable",
    "inAppOwnershipType": "PURCHASED",
    "signedDate": 1643246161338,
    "revocationReason": 0,
    "revocationDate": 1643115549000
}
```

多了 2 个新字段：

* `revocationDate`：Apple Support 为交易退款的 UNIX 时间（以毫秒为单位）。
* `revocationReason`：App Store 为交易退款或撤销其家庭共享的原因。

    `0`：出于其他原因，Apple Support 代表客户为交易退款；例如意外购买。
    `1`：由于您的 app 中存在实际或感知到的问题，Apple 支持代表客户为交易退款。


> 详细字段解析，可以参考苹果文档：[JWSTransactionDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwstransactiondecodedpayload)


#### 查询用户订阅项目状态（Get All Subscription Statuses）

```
GET https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/{originalTransactionId}
```

订阅品项状态查询 API [Get All Subscription Statuses](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses)，获取您 app 中用户所有订阅的状态。


响应的数据格式：

```js
{
    "environment": "Sandbox",
    "bundleId": "securitynote",
    "data": [
        {
            "subscriptionGroupIdentifier": "20919269",
            "lastTransactions": [
                {
                    "status": 2,
                    "originalTransactionId": "1000000954804912",
                    "signedTransactionInfo": "eyJhbGciOiJFUz....",
                    "signedRenewalInfo": "eyJhbGciOiJFUzI1Ni...."
                }
            ]
        }
    ]
}
```

![AppStoreServerAPI-12](https://ihtcboy.com/images/2022-AppStoreServerAPI-12.jpg)

`lastTransactions` 是每个订阅项目的最后的订阅状态，`status` 类型：

* 1：有效
* 2：过期
* 3：账号扣费重试
* 4：账号宽限期(这个是开发者设置，比如到期扣费失败时，可以给用户延期多长时间。)
* 5：已经撤销。


**signedTransactionInfo** 格式示例：

```js
{
    "transactionId": "1000000955217725",
    "originalTransactionId": "1000000954804912",
    "webOrderLineItemId": "1000000071615442",
    "bundleId": "com.apple.test",
    "productId": "com.apple.iap.month",
    "subscriptionGroupIdentifier": "20919269",
    "purchaseDate": 1643023487000,
    "originalPurchaseDate": 1642990550000,
    "expiresDate": 1643023787000,
    "quantity": 1,
    "type": "Auto-Renewable Subscription",
    "inAppOwnershipType": "PURCHASED",
    "signedDate": 1643028928116
}
```

**signedRenewalInfo** 格式示例：

```js
{
    "expirationIntent": 1,
    "originalTransactionId": "1000000954804912",
    "autoRenewProductId": "com.apple.iap.month",
    "productId": "com.apple.iap.month",
    "autoRenewStatus": 0,
    "isInBillingRetryPeriod": false,
    "signedDate": 1643028928116
}
```


#### 提交防欺诈信息（Send Consumption Information）

```
PUT https://api.storekit.itunes.apple.com/inApps/v1/transactions/consumption/{originalTransactionId}
```

这个接口的作用是提交防欺诈信息给苹果，具体可以查看文档 [Send Consumption Information](https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information) 。

当用户申请退款时，苹果通知（`CONSUMPTION_REQUEST`）开发者服务器，开发者可在12小时内，提供用户的信息（比如游戏金币是否已消费、用户充值过多少钱、退款过多少钱等），最后苹果收到这些信息，协助“退款决策系统” 来决定是否允许用户退款。详细可以查看我们之前的 [文章内容](https://juejin.cn/post/6974733392260644895#heading-25) 了解更多。

> 用户提交退款申请，苹果系统会于 48 小时内在报告问题中更新处理结果。 所以，开发者收到用户退款通知后，有 12 个小时决定是否要提供防欺诈信息给苹果。

![AppStoreServerAPI-13](https://ihtcboy.com/images/2022-AppStoreServerAPI-13.jpg)

> parameters 字段描述，详细见文档：[Send Consumption Information](https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information)

请求的 Response Codes 为 `202` 就表示苹果收到了信息。


#### 延长用户订阅的时长（Extend a Subscription Renewal Date）

```
PUT https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/extend/{originalTransactionId}
```

开发者一年有2次机会给订阅内购用户每次加90天免费补偿。也就是有自动订阅类型的 App，可以开发者主动在服务器给用户补偿(免费延长)用户的订单时间，每次最多是90天。详细见文档 [Extend a Subscription Renewal Date](https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date)。

以下类型的订阅**不符合**续订日期延期的条件：

* 免费优惠期内的订阅
* 处于账单重试状态的非活跃订阅
* 已经到期，处于宽限期状态的订阅
* 在过去365天内已经收到两次续订日期延期的订阅

另外，苹果有一个提示：`当 App Store 计算开发者的佣金比例时，延长期不计入一年的付费服务。`

简单来说，用户订阅项目满一年后，开发者可获 85% 净收入。而开发者给用户免费延长的时间，并不计入这一年的时间里！（懂了吧？）

![AppStoreServerAPI-14](https://ihtcboy.com/images/2022-AppStoreServerAPI-14.jpg)

> parameters 字段描述，详细见文档：[ExtendRenewalDateRequest | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/extendrenewaldaterequest)

请求的 Response Codes 为 `200` 就表示请求成功。

### 2.4 疑问解答

#### Authorization: Bearer [signed token]

每当用户访问受保护的路由或资源时，用户可以使用承载（bearer）模式发送 JWT，通常在 Authorization 标头中，内容格式如下： 

```
Authorization: Bearer [signed token]
```

随后，服务器会取出 token 中的内容，来返回对应的内容。需要注意，这个 token 不一定会储存在 cookie 中，如果存在 cookie 中的话，需要设置为 http-only，防止 XSS。另外，可以看到，如果在如Authorization: Bearer 中发送 token，则跨域资源共享（CORS）将不会成为问题，因为它不使用 cookie。

所以，JWT 的主要目的是在服务端和客户端之间以安全的方式来转移声明。主要的应用场景：

*  认证 Authentication
*  授权 Authorization
*  联合识别
*  客户端会话（无状态的会话）


#### Error Codes 

如果 token 无效或者失效时，返回内容：
```
Unauthenticated

Request ID: 7F5DBZ7VDX677TOPBAOEUXWSCY.0.0
```

如果请求的 `originalTransactionId` 不存在，会报错 `4040005`([OriginalTransactionIdNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionidnotfounderror))：
```
{
    "errorCode": 4040005,
    "errorMessage": "Original transaction id not found."
}
```

其它的错误码：

| Object | errorCode | errorMessage |
|---|---|---|
| GeneralBadRequestError | 4000000 | Bad request. |
| InvalidAppIdentifierError | 4000002 | Invalid request app identifier. |
| InvalidRequestRevisionError | 4000005 | Invalid request revision. |
| InvalidOriginalTransactionIdError | 4000008 | Invalid original transaction id. |
| InvalidExtendByDaysError | 4000009 | Invalid extend by days value. |
| InvalidExtendReasonCodeError | 4000010 |  Invalid extend reason code. |
| InvalidRequestIdentifierError | 4000011 | Invalid request identifier. |
| SubscriptionExtensionIneligibleError | 4030004 | Forbidden - subscription state ineligible for extension. |
| SubscriptionMaxExtensionError | 4030005 | Forbidden - subscription has reached maximum extension count. |
| AccountNotFoundError | 4040001 | Account not found. |
| AccountNotFoundRetryableError | 4040002 | Account not found. Please try again. |
| AppNotFoundError | 4040003 | App not found. |
| AppNotFoundRetryableError | 4040004 | App not found. Please try again. |
| OriginalTransactionIdNotFoundError | 4040005 | Original transaction id not found. |
| OriginalTransactionIdNotFoundRetryableError | 4040006 | Original transaction id not found. Please try again. |
| GeneralInternalError | 5000000 | An unknown error occurred. |
| GeneralInternalRetryableError | 5000001 | An unknown error occurred. Please try again. |

详细的错误码说明，参见文档：[Error Codes](https://developer.apple.com/documentation/appstoreserverapi/error_codes)。


#### 查询用户订单的收据（Look Up Order ID）

```
GET https://api.storekit.itunes.apple.com/inApps/v1/lookup/{orderId}
```

通过这个接口，可以查询所有订单吗？还是只有使用 StoreKit2 创建的订单才能查询到？

答：目前笔者找了多笔 2020 年购买的项目订单号，都能通过 API 查询到。所以，**此接口不限制订单的购买时期。**（至少 2020 年后的可以查到，如有异常，欢迎大家评论区一起交流啊。）


#### JWT 签名验证

向 App Store Server API 发出的每个请求，都需要带上 JSON Web Token（JWT）令牌来授权。苹果建议不需要为每个 API 请求生成新令牌。为了从 App Store Server API 获得更好的性能，请重用已有的签名令牌，每个令牌有 60 分钟有效时间。

如果只是想获取 JWT 的有效负载 Payload 参数，可以直接 base64 Decode Payload 参数就行了，但是如果你需要验证签名，则必须使用到 Signture, Header。

可以用 Python 的 `PyJWT` 库来 decode：

```python
import jwt

token = "exxxxxx" #需要解码的 token

data = jwt.decode(token, options={"verify_signature": False})
```

苹果的建议是：可以利用各种开源库，创建和签署JWT令牌。有关 JWT 更多信息，请参阅 [JWT.io](https://jwt.io/)。

从 [PyJWT](https://pyjwt.readthedocs.io/en/stable/api.html) 文档可以看到，JWT 验证的内容有：

* verify_signature：验证 JWT 加密签名
* verify_aud：是否匹配 audience
* verify_iss：是否匹配 issuer
* verify_exp：是否过期
* verify_iat：是否为整数
* verify_nbf：是否为过去的时间（nbf 表示：Not Before 的缩写，表示 JWT Token 在这个时间之前是无效的。也就是生效时间。）

所以，我们就能明白，验证 JWT 有那么内容。最重要的是验证 `verify_signature`，当验证签名的时候，利用公钥或者密钥来解密 Sign，和 base64UrlEncode(header) + "." + base64UrlEncode(payload) 的内容完全一样的时候，表示验证通过。


验证的流程，示例：
```python
import jwt

public_key = "xxxx" #公钥证书内容

data = jwt.decode(token, key=public_key, algorithms=["ES256"])
```

那么问题来了，苹果的公钥在那里获取？通过苹果开发者论坛找到了线索：

* [Validate StoreKit2 in-app purchase jwsRepresentation in backend](https://developer.apple.com/forums/thread/691464)


简单来说，JWS 的 x5c 头字段中包含一个证书链（x509），第一个证书包含用于验证 JWS 签名的公钥。从获取获取的 `signedTransactions` 中，取一个 token 解码的格式如下：

```js
{
    "alg": "ES256",
    "x5c": [
        "MIIEMDCCA7.....",
        "MIIDFjCCApy.....",
        "MIICQzCCAc......"
    ]
}
```

证书可以从苹果 [Apple PKI](https://www.apple.com/certificateauthority/) 页面下载。

`x5c` 证书链中最后一个证书，对应苹果的证书 [Apple Root CA - G3 Root](https://www.apple.com/certificateauthority/AppleRootCA-G3.cer)，但我们需要把 .cer 转换成 .pem 格式，命令：

```ssh
openssl x509 -inform der -in AppleRootCA-G3.cer -out AppleRootCA-G3.pem
```

> 注解：
> X.509：是一种证书标准，主要定义了证书中应该包含哪些内容。其详情可以参考 [RFC5280](https://datatracker.ietf.org/doc/html/rfc5280)，SSL 使用的就是这种证书标准。
> 同样的 X.509 证书，可能有不同的编码格式，目前有以下两种编码格式：
> 
> * DER：Distinguished Encoding Rules，打开看是二进制格式，不可读.
> * PEM：Privacy Enhanced Mail，打开看文本格式，以”—–BEGIN…”开头，”—–END…”结尾,内容是BASE64编码。


`AppleRootCA-G3.pem` 内容，和 `x5c` 证书链中最后一个证书的内容一样，如下：

```
MIICQzCCAcmgAwIBAgIILcX8iNLFS5UwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMTQwNDMwMTgxOTA2WhcNMzkwNDMwMTgxOTA2WjBnMRswGQYDVQQDDBJBcHBsZSBSb290IENBIC0gRzMxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzB2MBAGByqGSM49AgEGBSuBBAAiA2IABJjpLz1AcqTtkyJygRMc3RCV8cWjTnHcFBbZDuWmBSp3ZHtfTjjTuxxEtX/1H7YyYl3J6YRbTzBPEVoA/VhYDKX1DyxNB0cTddqXl5dvMVztK517IDvYuVTZXpmkOlEKMaNCMEAwHQYDVR0OBBYEFLuw3qFYM4iapIqZ3r6966/ayySrMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMDA2gAMGUCMQCD6cHEFl4aXTQY2e3v9GwOAEZLuN+yRhHFD/3meoyhpmvOwgPUnPWTxnS4at+qIxUCMG1mihDK1A3UT82NQz60imOlM27jbdoXt2QfyFMm+YhidDkLF1vLUagM6BgD56KyKA==
```

所以，具体的验证，参考 [Validate StoreKit2](https://developer.apple.com/forums/thread/691464) 里给出的答案：

```ruby
def good_signature?(jws_token)
  raw = File.read "/Users/steve1/downloads/AppleRootCA-G3.cer"
  apple_root_cert = OpenSSL::X509::Certificate.new(raw)

  parts = jws_token.split(".")
  decoded_parts = parts.map { |part| Base64.decode64(part) }
  header = JSON.parse(decoded_parts[0])

  cert_chain =  header["x5c"].map { |part| OpenSSL::X509::Certificate.new(Base64.decode64(part))}
  return false unless cert_chain.last == apple_root_cert

  for n in 0..(cert_chain.count - 2)
    return false unless cert_chain[n].verify(cert_chain[n+1].public_key)
  end

  begin
    decoded_token = JWT.decode(jws_token, cert_chain[0].public_key, true, { algorithms: ['ES256'] })
    !decoded_token.nil?
  rescue JWT::JWKError
    false
  rescue JWT::DecodeError
    false
  end
end
```

以上代码是用 Ruby 写的，大概实现验证的逻辑是，用苹果提供的 `AppleRootCA-G3.cer` 证书内容验证 JWT `x5c` 证书链中最后一个证书，然后利用 `x509` 证书链规范，验证剩下的每个证书链，最后用`x5c` 证书链中的第一个证书的公钥，来验证 JWT。


#### Sign in with Apple

除了 App Store Server API，还有 Sign in with Apple、App Store Connet API 等服务，都是使用 JWT 来传递。具体的要求和字段可能与 App Store Server API 不相同。比如 Sign in with Apple 的 JWT 不需要 `typ`，`sub` 与 `bid` 含义一样，都是表示 Bundle ID，app 的包名。所以这些规范也是一样，这些细节不一样时，开发者都需要踩坑然后才能知道，说明了规范的重要性。

```js
{
    "alg": "ES256",
    "kid": "ABC123DEFG"
}
{
    "iss": "DEF123GHIJ",
    "iat": 1637179036,
    "exp": 1693298100,
    "aud": "https://appleid.apple.com",
    "sub": "com.apple.test"
}
```


## 三、总结

小编开始想把所有订阅类型都详细讲解，但编写过程中发现事情很复杂，因为订阅型项目复杂，有很多字段和作用。限于文章篇幅问题，和苹果文档已经有详细的字段说明，所以本文主要是讲解App Store Server API 的整体流程和注意事项。如有错误或问题，欢迎大家评论区纠正和交流哈~

其次，App Store Server API 新接口带来的意义非常重大！**以往内购形成产生大量黑灰产**，利用苹果内购的各种环节的漏洞，通过汇率差、僵尸账号、恶意退款等方式，形成了一条产业链的工作室、团伙作案。去年开始，苹果提供了内购退款通知，今年提供了查询接口，还有相关的客服接口，虽然都是属于后期的响应，但在一定程度上，对于打击黑恶有重要一棒！

最后，从苹果开放的接口和理念来说，苹果注重用户体验，希望开放者能更好的服务用户！所以，2022年，希望与大家学习和分享有趣的技术，打磨优秀的产品体验和服务！一起努力加油~


**37手游 iOS 技术运营团队**全体成员祝：

各位读者，`新年快乐`！`虎虎生威`！


> 欢迎关注我们，了解更多 iOS 和 Apple 的资讯~


## 四、参考引用

* [苹果iOS内购三步曲：App内退款、历史订单查询、绑定用户防掉单！--- WWDC21](https://juejin.cn/post/6974733392260644895)
* [现已推出新的 app 内购买功能 - Apple Developer](https://developer.apple.com/cn/news/?id=1mmydqta)
* [Look Up Order ID | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/look_up_order_id)
* [Get Transaction History | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)
* [Get Refund History | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/get_refund_history)
* [Get All Subscription Statuses | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses)
* [Send Consumption Information | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information)
* [Extend a Subscription Renewal Date | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date)
* [Generating Tokens for API Requests | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests)
* [Generate and Validate Tokens | Apple Developer Documentation](https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens)
* [RFC 7519 - JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
* [冷饭新炒：理解JWT的实现原理和基本使用 - Throwable](https://my.oschina.net/throwable/blog/4955682)
* [Validating "Sign in with Apple" Authorization Code - Parikshit Agnihotry](http://p.agnihotry.com/post/validating_sign_in_with_apple_authorization_code/)
* [What is a JWS and how to encode it for Apple In-App Purchases?](https://www.purchasely.com/blog/handle-jws-signature-for-apple-in-app-purchases)
* [Fraud in In-App Subscriptions : how to crack down on fraud from malicious users](https://www.purchasely.com/blog/how-to-fight-fraud-in-app-subscriptions)
* [JWT(JSON Web)使用_wichandy的技术博客_51CTO博客_jwt使用教程](https://blog.51cto.com/u_6184526/2547503)
* [RFC 7519 - JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
* [自动续期订阅 - App Store - Apple Developer](https://developer.apple.com/cn/app-store/subscriptions/)
* [Getting only decoded payload from JWT in python - Stack Overflow](https://stackoverflow.com/questions/59425161/getting-only-decoded-payload-from-jwt-in-python)
* [Validate StoreKit2 in-app purchase jwsRepresentation in backend| Apple Developer Forums](https://developer.apple.com/forums/thread/691464)
* [How do I convert a .cer certificate to .pem? - Server Fault](https://serverfault.com/questions/254627/how-do-i-convert-a-cer-certificate-to-pem)
