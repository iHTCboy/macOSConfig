title: 使用 App Store Connect API 批量创建内购商品
date: 2022-12-25 22:54:10
categories: technology #induction life poetry
tags: [批量创建内购,App Store Connect API,In App Purchase]  # <!--more-->
reward: true

---

> 本文首发于 [使用 App Store Connect API 批量创建内购商品 - 掘金](https://juejin.cn/post/7181099247956131896)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

我们去年开源 [AppleParty（苹果派）](https://juejin.cn/post/7081069026515877919) 用于批量应用内购商品的创建和更新的方案，具体的技术方案是使用 XML Feed 格式来处理。而今年苹果在 WWDC22 宣布，2022 年 11 月开始，不再允许使用 XML 方式上传元数据和内购商品。

<!--more-->

### 一、前言

我们去年开源 [AppleParty（苹果派）](https://juejin.cn/post/7081069026515877919) 用于批量应用内购商品的创建和更新的方案，具体的技术方案是使用 XML Feed 格式来处理。而今年苹果在 WWDC22 宣布，2022 年 11 月开始，不再允许使用 XML 方式上传元数据和内购商品。

苹果在 7 月公告 [即将从 XML Feed 过渡到 App Store Connect API](https://developer.apple.com/cn/news/?id=yqf4kgwb)，并且一直邮件通知开发者，截止 11月 9 日之前：

```
We noticed you recently used the XML feed to manage and deliver content to App Store Connect. As we wrote to you previously, as of November 9, 2022, you’ll need to use the App Store Connect REST API to manage in-app purchases, subscriptions, metadata, and app pricing. The XML feed no longer supports this content, but continues to support existing Game Center management functionality. 

If you have any questions, contact us. 

Apple Developer Relations
```

如果现在还使用 XML feed 上传，会收到以下告警：

```
		ERROR ITMS-6036: "XML schemas software5.12 and earlier have been deprecated and uploads of app metadata, in-app purchases, and subscriptions are no longer supported through the XML feed. You can use the App Store Connect API instead.

		Game Center will continue to be supported with XML schema software6.0." at Software/SoftwareMetadata
```

所以，XML feed 禁止上传的内容：

- app metadata（app元数据，如截图、预览、描述等）
- in-app purchases, and subscriptions（内购商品，包括订阅类型）
- app pricing（app定价）

而 `Game Center` 和上传 `ipa` 文件等方式，目前还能上传，目前来看，是因为 App Store Connect API 还不支持！所以，希望明年 WWDC23 苹果能支持上传 ipa 文件，这样就更加方便~

### 二、App Store Connect API

App Store Connect API 需要生成密钥才能调用使用，所以，我们先来介绍一下密钥的生成，然后在以应用内购商品的创建和更新为例，展示 API 使用示例。

#### 2.1 App Store Connect API 密钥生成

**生成密钥 ID（kid）和 Issuer ID（iss）**

要生成密钥，您必须在 App Store Connect 中具有管理员角色或帐户持有人角色。登录 [App Store Connect](https://appstoreconnect.apple.com/) 并完成以下步骤：

1. 选择 “用户和访问”，然后选择 “密钥” 子标签页。
2. 在 “密钥类型” 下选择 “App Store Connect API”。
3. 单击 “生成 API 密钥”（如果之前创建过，则点击 “添加（+）” 按钮新增。）。
4. 输入密钥的名称。该名称仅供您参考，名字不作为密钥的一部分。
5. 单击 “生成”。

![AppStoreConnectAPI-01](https://ihtcboy.com/images/2022-AppStoreConnectAPI-01.png)

“用户和访问” -> “密钥” -> “App Store Connect API” -> “生成 API 密钥”

![AppStoreConnectAPI-02](https://ihtcboy.com/images/2022-AppStoreConnectAPI-02.png)

![AppStoreConnectAPI-03](https://ihtcboy.com/images/2022-AppStoreConnectAPI-03.png)

**注：访问权限：**
根据密钥使用场景，访问的权限也不一样。要创建和管理 App 内购买项目，请确保您拥有以下用户角色之一：
* 帐户持有人
* 管理
* App 管理（这个要求角色权限最低）

> 详细权限，可参考文档 [职能权限](https://help.apple.com/app-store-connect/#/deve5f9a89d7)。


![AppStoreConnectAPI-04](https://ihtcboy.com/images/2022-AppStoreConnectAPI-04.png)

1、**Issuer ID**：拷贝复制内容
2、**密钥 ID**:  生成的密钥，有一列名为 “密钥 ID” 就是 kid 的值，鼠标移动到文字就会显示 拷贝密钥 ID，点击按钮就可以复制 kid 值。
3、**API 密钥文件**，下载 API 密钥 按钮（仅当您尚未下载私钥时，才会显示下载链接。），此私钥只能一次性下载！。

> 注意：将您的私钥存放在安全的地方。不要共享密钥，不要将密钥存储在代码仓库中，不要将密钥放在客户端代码中。如果您怀疑私钥被盗，请立即在 App Store Connect 中撤销密钥。有关详细信息，请参阅 [撤销API密钥](https://developer.apple.com/documentation/appstoreconnectapi/revoking_api_keys)。

最终，生成以下参数和文件：

| 名字 | 值示例 | 说明 | 字段值说明 |
| --- | --- | --- | --- |
| 密钥ID | GC8HS3SX37 | kid，Key ID，密钥ID | 您的私钥ID，值来自 API 密钥页面。 |
| 密钥内容文件 | SubscriptionKey_GC8HS3SX37.p8 | 密钥文件（p8） | 用来访问和使用 App Store Connect API 接口的服务。 |
| Issuer ID | 69a6de92-xxx-xxxx-xxxx-5bc37c11a4d1 | iss，Issuer ID，发行人 | 您的发卡机构ID，值来自 App Store Connect 的 API 密钥页面。 |

#### 2.2 App Store Connect API 使用示例

这里我们使用 python3 创建 API 请求示例，需要依赖 `jwt` 和 `requests` 库，所以需要在终端安装：

```
pip3 install jwt

pip3 install requests
```

怎么请求 App Store Connect API ？苹果给出了一个示例：

```bash
curl -v -H 'Authorization: Bearer [signed token]' 
"https://api.appstoreconnect.apple.com/v1/apps"
```

也就是用 JWT 生成的 token，放到 App Store Connect API 请求链接的 header 部分，key 为 `Authorization`，value为 `Bearer [signed token]`。

接下来，我们通过 Python 的 `requests` 来请求 App Store Connect API。大家也可以用其它的工具来模拟，比如在线工具或者 Postman 等。

```python
import jwt
import time
import requests

def createASCToken(p8KeyPath, kid, iss):
	try:
		header = {
			"alg": "ES256",
			"typ": "JWT",
			"kid": kid
		}
		payload = {
			"iss": iss,
			"aud": "appstoreconnect-v1",
			"iat": int(time.time()),
			"exp": int(round(time.time() + (20.0 * 60.0))) # 20 minutes timestamp
		}
		file = open(p8KeyPath)
		key_data = file.read()
		file.close()
		token = jwt.encode(headers=header, payload=payload, key=key_data, algorithm="ES256")
		return token
	except Exception as e:
		print(e)
		return ""

# 密钥路径
p8 = "/Users/iHTCboy/Downloads/AppStoreConnectAPI/AuthKey_GC8HS3SX37.p8"
kid = "GC8HS3SX37"
iss = "69a6de92-xxx-xxxx-xxxx-5bc37c11a4d1"

# 生成请求 token
token = createASCToken(p8, kid, iss)
```

接下来，以获取 app 列表为例，请求也非常简单：

```python
# 获取全部 app
url = "https://api.appstoreconnect.apple.com/v1/apps" 
header = {
	"Authorization": f"Bearer {token}"
}
rs1 = requests.get(url, headers=header)
data = json.loads(rs1.text)

print(data)
```

返回内容示例：
```json
{
  "data" : [ {
    "type" : "apps",
    "id" : "123456737",
    "attributes" : {
      "name" : "AppleParty - 37手游 iOS 技术团队",
      "bundleId" : "cn.com.37iOS.AppleParty",
      "sku" : "2021.04.25",
      "primaryLocale" : "zh-Hans",
      "isOrEverWasMadeForKids" : false,
      "subscriptionStatusUrl" : null,
      "subscriptionStatusUrlVersion" : null,
      "subscriptionStatusUrlForSandbox" : null,
      "subscriptionStatusUrlVersionForSandbox" : null,
      "availableInNewTerritories" : true,
      "contentRightsDeclaration" : null
    },
    "relationships" : {
        xxxx
     }
  }],
  "links" : {
    "self" : "https://api.appstoreconnect.apple.com/v1/apps"
  },
  "meta" : {
    "paging" : {
      "total" : 1,
      "limit" : 50
    }
  }
}
```

#### 2.3 App Store Connect API 使用说明

App Store Connect API 可以根据官方文档就能大概了解，但是依然非常难，就是 POST 接口的 body 和上传文件的流程。

**POST body**

以 [Create an In-App Purchase](https://developer.apple.com/documentation/appstoreconnectapi/create_an_in-app_purchase) 为例，请求的 body：

```json
{
	'data': {
		'attributes': {
			'availableInAllTerritories': True,
			'familySharable': False,
			'inAppPurchaseType': 'NON_CONSUMABLE',
			'name': '我是测试商品01',
			'productId': 'com.apple.iap01',
			'reviewNote': '审核备注',
		},
		'relationships': {
			'app': {
				'data': {
					'id': "{app_id}",
					'type': 'apps'
				}
			}
		},
		'type': 'inAppPurchases'
	}
}
```

其中 `inAppPurchaseType` 可能为：
- CONSUMABLE
- NON_CONSUMABLE
- NON_RENEWING_SUBSCRIPTION

而订阅类型的商品，是另一个 API [Create an Auto-Renewable Subscription](https://developer.apple.com/documentation/appstoreconnectapi/create_an_auto-renewable_subscription)，对应的请求的 body：

```json
{
	"data": {
		"type": "subscriptions",
		"attributes": {
			"name": "一个月订阅会员",
			"productId": "com.apple.mon01",
			"subscriptionPeriod": "ONE_MONTH",
			"familySharable": False,
			"reviewNote": "审核备注",
			"groupLevel": 1,
			"availableInAllTerritories": True
		},
		"relationships": {
			"group": {
				"data": {
					"type": "subscriptionGroups",
					"id": "{app_iap_grop_id}"
				}
			}
		}
	}
}
```

其中 `subscriptionPeriod` 可以为：
- ONE_WEEK
- ONE_MONTH
- TWO_MONTHS
- THREE_MONTHS
- SIX_MONTHS
- ONE_YEAR

**上传文件**

上传文件的流程，刚开始看文档没有看明白，最后又仔细查文档才找到 [Uploading Assets to App Store Connect](https://developer.apple.com/documentation/appstoreconnectapi/uploading_assets_to_app_store_connect)，以上传应用内购买的送审图片为例，[Create an In-App Purchase Review Screenshot](https://developer.apple.com/documentation/appstoreconnectapi/create_an_in-app_purchase_review_screenshot)，需要对应的请求的 body：

```json
{
	'data': {
		'attributes': {
			'fileName': 'test.png',
			'fileSize': '1000',
		},
		'relationships': {
			'inAppPurchaseV2': {
				'data': {
					'id': '{app_iap_id}',
					'type': 'inAppPurchases'
				}
			}
		},
		'type': 'inAppPurchaseAppStoreReviewScreenshots'
	}
}
```

请求成功后，Response Code 为 201 时：

```json
{
  "data" : {
    "type" : "inAppPurchaseAppStoreReviewScreenshots",
    "id" : "caeda501-xxxx-xxxx-8fb3-6a3c0f462720",
    "attributes" : {
      "fileSize" : 1000,
      "fileName" : "test.png",
      "sourceFileChecksum" : "",
      "imageAsset" : {
        "templateUrl" : "",
        "width" : 0,
        "height" : 0
      },
      "assetToken" : "",
      "assetType" : "SCREENSHOT",
      "uploadOperations" : [ {
        "method" : "PUT",
        "url" : "https://store-032.blobstore.apple.com/itmspod11-assets-massilia-032001/PurpleSource112%2Fv4%2F2c%2F3f%2Fe1%2F2c3fe12e-a9ea-xxx-xxx-12a8c02df932%2FieKZRQnL0o2fK4sbeFRXOQ8tVRjPIVyJaGCNLsLg2Dc_U003d-1669087039587?uploadId=2c75a0f0-6a14-11ed-93d1-d8c4978a0739&Signature=OWuT65nZNeMgWMNbaZtEGc9lcDU%3D&AWSAccessKeyId=MKIA474WIEZZVU5QMKHI&partNumber=1&Expires=1669691839",
        "length" : 1000,
        "offset" : 0,
        "requestHeaders" : [ {
          "name" : "Content-Type",
          "value" : "application/octet-stream"
        } ]
      } ],
      "assetDeliveryState" : {
        "errors" : null,
        "warnings" : null,
        "state" : "AWAITING_UPLOAD"
      }
    },
    "links" : {
      "self" : ""
    }
  },
  "links" : {
    "self" : "
  }
}
```

返回的响应内容 `uploadOperations` 中的 url 就是上传图片文件的请求 url，对应的 `requestHeaders` 也是组装 request 必备的 headers 属性，图片文件的大小要与 length 长度一致。

#### 2.4 App Store Connect Swift SDK

从上文就可以看出来，如果自己全部的 API 都实现一次，工作时是非常大，所以我们非常感谢 [AvdLee/appstoreconnect-swift-sdk](https://github.com/AvdLee/appstoreconnect-swift-sdk)，使用 Xcode 的 Swift Package Manager 导入 `https://github.com/AvdLee/appstoreconnect-swift-sdk.git` 就可以使用！

以创建内购商品为例：

```swift
    func createInAppPurchases(appId: String, product: IAPProduct) async -> ASCInAppPurchaseV2? {
        let body = [
            "data": [
                "attributes": [
                    "availableInAllTerritories": product.availableInAllTerritories,
                    "familySharable": product.familySharable,
                    // CONSUMABLE、NON_CONSUMABLE、NON_RENEWING_SUBSCRIPTION
                    "inAppPurchaseType": product.inAppPurchaseType.rawValue,
                    "name": product.name,
                    "productId": product.productId,
                    "reviewNote": product.reviewNote,
                ],
                "relationships": [
                    "app": [
                        "data": [
                            "id": appId,
                            "type": "apps"
                        ]
                    ]
                ],
                "type": "inAppPurchases"
            ]
        ]
        
        do {
            guard let provider = provider else {
                return nil
            }
            let json = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            let model = try JSONDecoder().decode(InAppPurchaseV2CreateRequest.self, from: json)
            let request = APIEndpoint.v2.inAppPurchases.post(model)
            let data = try await provider.request(request).data
            return data
        } catch APIProvider.Error.requestFailure(let statusCode, let errorResponse, _) {
            handleRequestFailure(statusCode, errorResponse)
        } catch {
            handleError("创建内购商品失败: \(error.localizedDescription)")
        }
        return nil
    }
```

这里就不再展开，详细可以参考我们开源项目代码：[AppStoreConnectAPI.swift](https://github.com/37iOS/AppleParty/blob/main/AppleParty/Shared/Network/AppStoreConnectAPI.swift)。


### 3、Apple Party（苹果派）更新

下载 2.1.0 更新版本：[Releases · 37iOS/AppleParty](https://github.com/37iOS/AppleParty/releases)

**更新重点内容**

- 截图不再是必需项
- 支持多种本地化语言

表格格式更新，删除无法字段，支持多种本地化语言：
![AppStoreConnectAPI-05](https://ihtcboy.com/images/2022-AppStoreConnectAPI-05.png)

> 支持多种本地化语言，通过在表格最后的列增加，本地化语言标识，每种语言增加2列，分别对应本地化的名字和描述。

内购列表更新支持不同的价格国家地区的价格显示：
![AppStoreConnectAPI-06](https://ihtcboy.com/images/2022-AppStoreConnectAPI-06.png)

导入表格后，首次需要设置 API 密钥：
![AppStoreConnectAPI-07](https://ihtcboy.com/images/2022-AppStoreConnectAPI-07.png)

密钥获取，参考本文的第二章内容。
![AppStoreConnectAPI-08](https://ihtcboy.com/images/2022-AppStoreConnectAPI-08.png)

提交后，会自动执行上传，如果存在的商品会更新内容，成功时：
![AppStoreConnectAPI-09](https://ihtcboy.com/images/2022-AppStoreConnectAPI-09.png)

### 四、总结

App Store Connect API 功能非常多，包括元数据的管理，构建版本的管理、TestFlight 管理、证书管理等等，Apple Party（苹果派）从日常使用场景最多的内购商品批量创建入手，未来依然有非常多的生效力效率提升，欢迎大家一起迭代和 PR 提交！

欢迎你一起体验和参考 [37iOS/AppleParty](https://github.com/37iOS/AppleParty)~

欢迎大家评论区一起讨论交流~

> 欢迎关注我们，了解更多 iOS 和 Apple 的动态~


### 参考引用

- [即将从 XML Feed 过渡到 App Store Connect API - 最新动态 - Apple Developer](https://developer.apple.com/cn/news/?id=yqf4kgwb)
- [职能权限 - App Store Connect 帮助](https://help.apple.com/app-store-connect/#/deve5f9a89d7)
- [Revoking API Keys | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/revoking_api_keys)
- [Create an In-App Purchase | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/create_an_in-app_purchase)
- [Create an Auto-Renewable Subscription | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/create_an_auto-renewable_subscription)
- [Uploading Assets to App Store Connect | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/uploading_assets_to_app_store_connect)
- [Create an In-App Purchase Review Screenshot | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/create_an_in-app_purchase_review_screenshot)
- [AvdLee/appstoreconnect-swift-sdk: The Swift SDK to work with the App Store Connect API from Apple.](https://github.com/AvdLee/appstoreconnect-swift-sdk)
- [Releases · 37iOS/AppleParty](https://github.com/37iOS/AppleParty/releases)

> 注：如若转载，请注明来源。