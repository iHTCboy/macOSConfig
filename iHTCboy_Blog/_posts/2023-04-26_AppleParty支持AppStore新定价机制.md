title: AppleParty（苹果派）v3 支持 App Store 新定价机制 - 批量配置自定价格和销售范围
date: 2023-04-26 22:38:23
categories: technology #induction life poetry
tags: [AppleParty,苹果派,App Store 新定价机制,App Store Connect API]  # <!--more-->
reward: true

---

> 本文首发于 [AppleParty（苹果派）v3 支持 App Store 新定价机制 - 批量配置自定价格和销售范围 - 掘金](https://juejin.cn/post/7226327556198744122)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

> 本文主要介绍了 AppleParty v3，一款方便开发者管理 App Store Connect 的工具。文章详细描述了新版本中支持的功能，如内购商品的批量上传、设置销售范围和价格机制等。作者还提到了 API 的一些限制和未来改进的可能性。若您对游戏行业有需求，如管理大量内购项目和多语言应用，AppleParty 可能是一个不错的选择。总之，本文为您提供了一个全面了解 AppleParty v3 的机会，以便更好地管理您在 App Store Connect 上的应用。

<!--more-->

![2023-AppleParty-v3-00](https://ihtcboy.com/images/2023-AppleParty-v3-00.jpeg)

## 一、前言

大家好！我们又见面啦，我们在上篇文章《[使用 App Store Connect API v2.3 管理 App Store 新定价机制](https://juejin.cn/post/7219298341462196281)》讲解了关于 App Store 新定价机制 API 的介绍。但当时没有对 API 之间的关系性和联动进行介绍，有接口也不知道怎么串联起来使用。所以本文将详细介绍 App Store Connect API v2.3 如何实现批量配置自定价格和销售范围等。

首先，纠正一下我们之前文章《[App Store 新定价机制 - 2023年最全版](https://juejin.cn/post/7213022785366933559)》提到 [订阅类型价格调整](https://juejin.cn/post/7213022785366933559#heading-19) 的影响，当时认为苹果全球均衡价格系统，会影响到自动续期订阅产品！但是仔细看 App Store Connect API 后发现，**Apple 不会对你的自动续期订阅产品进行价格调整。**

> [汇率变化和税务调整会如何影响自动续期订阅的价格？](https://developer.apple.com/cn/help/app-store-connect/manage-subscriptions/manage-pricing-for-auto-renewable-subscriptions/)
>  
> Apple 不会对你的自动续期订阅产品进行价格调整。Apple 可能会针对税务变化和重大汇率变动调整零售价格，但价格调整不涉及自动续期订阅。请注意，由于你的收益和 Apple 的佣金均在扣除增值税（VAT）之后计算，因此 VAT 税率变化会影响你的收益。你可以选择调整你的订阅价格，以减少税务或外汇变化对你的收益造成影响。

自动续期订阅产品，跟现有 App 和一次性 App 内购买项目的价格一样，不再使用价格等级，并且支持的价格点是一致的。但是**自动续期订阅产品的价格，不能设置自动根据全球均衡价格系统调价！** 这个就是区别，下文会详细介绍到~


## 二、支持 App Store 新定价机制

在讲解 AppleParty（苹果派）支持 App Store 新定价机制之前，如果大家对 AppleParty（苹果派）不太了解，可以通过我们自己的文章学习，这里就不展开了。

- [AppleParty 下载](https://github.com/37iOS/AppleParty/releases)
- 苹果派安装使用教程：[开源一款苹果 macOS 工具 - AppleParty（苹果派）](https://juejin.cn/post/7081069026515877919)
- 苹果派批量创建内购教程：[使用 App Store Connect API 批量创建内购商品](https://juejin.cn/post/7181099247956131896)


### 2.1 基本功能和表格模板

使用批量内购商品配置，首先要更新到 [v3.0.0](https://github.com/37iOS/AppleParty/releases) 版本，登陆账号后选择 “我的 App”，然后点击 “上传内购项目”，打开内购管理内容：

![2023-AppleParty-v3-01](https://ihtcboy.com/images/2023-AppleParty-v3-01.jpeg)

* **刷新**：刷新当前 App 的内购商品列表（刚刚上传的商品不会自动刷新，所以可以手动刷新）
* **导入表格**：通过固定表格的形式，批量创建内购品项
* **导出表格**：导出所有品项的信息 Excel 表
* **导出品项 ID**：导出品项 productID 和内购品项 id 的映射表
* **下载表格示例**：批量创建内购品项的示例 Excel 表格

首次，需要点击 `下载表格示例`，下载模板表格，用于配置内购信息的信息。


### 2.2 内购商品：基本信息配置

打开示例表格，可以看到如下图所示例：

![2023-AppleParty-v3-02](https://ihtcboy.com/images/2023-AppleParty-v3-02.jpeg)

> 注意：`AppleParty`、`PricePoints`、`Territories` 这 3 个工作表的名字不能更改，App 是根据这些名字来读取对应的内容。

- **Product ID**：内购商品的标识，注意不能重复。
- **参考名字**：内购商品 ASC 后台显示的名字，不会对用户显示。但需要注意，每个内购商品的参考名字不能相同！
- **应用内购买类型**：内购类型，具体不同类型介绍，参见 `帮助` 工作表。
- **审核截图(可选)**：内购审核的截图，填写的是需要上传的图片的名字，包含后缀，例如 `test01.jpg` 或 `t01.png`。
- **审核备注(可选)**：内购审核的备注。
- **zh-Hans | en-US**：对应 ASC 后台的 `App Store 本地化版本`，可以配置多个语言版本，只需要在表格后面，表头添加对应的语言标识。

下面是示例说明：

| Product ID | 参考名字   | 应用内购买类型 | 审核截图(可选)   | 审核备注(可选) | zh-Hans | zh-Hans | en-US  | en-US  |
|------------|--------|---------|------------|----------|---------|---------|--------|--------|
| com.iap.01 | 测试suc1 | 消耗型     | test01.jpg |       | 中文名字01  | 中文描述01  | 英文名字01 | 英文描述01 |

示例表格中使用 `zh-Hans` 和 `en-US`，在编辑内购商品的信息时，如果不需要这2种语言，可以删除或更改其它语言。需要注意，表格前面的几列，位置顺序不能更改，也不能删除列数等。上传到苹果 ASC 后台的效果：

![2023-AppleParty-v3-03](https://ihtcboy.com/images/2023-AppleParty-v3-03.jpeg)

App Store 本地化版本语言代码，可以查看表格的 `帮助` 工作表。例如日本是 `ja`，在 `AppleParty` 工作表后面添加2列 `ja` 的表头，然后就可以配置对应的多语言。

审核截图的上传，下文会提到，这里暂时略过。


### 2.3 内购商品：基准国家和自定价格配置

切换到 `PricePoints` 工作表，可以看到如下图所示例：

![2023-AppleParty-v3-04](https://ihtcboy.com/images/2023-AppleParty-v3-04.jpeg)

- **Product ID**：用于映射多个工作表的内容，所以可以在 `AppleParty` 工作表的内购商品信息填写好后，直接复制过来。
- **基准国家(代码)**：当前内购商品的基准国家，注意是填写代码。175 个国家和地区的代码，可参考 `苹果各国家地区代码` 工作表。
- **基准国价格**：当前内购商品的基准国家对应的价格点，表格中提供了 `部分国家和地区价格点` 工作表，全部的国家和地区的价格点，请从苹果 ASC 后台下载。
- **自定价格国家 | 自定价格**：需要自定（固定）价格的国家或地区，如果不填写，则表示以基准国家的价格点，根据苹果的全球均衡价格自动设置价格。

下面是示例说明：

| Product ID | 基准国家(代码) | 基准国价格 | 自定价格国家1 | 自定价格1 | 自定价格国家2 | 自定价格2 | 自定价格国家3 | 自定价格3 | 自定价格国家4 | 自定价格4 |
|------------|----------|-------|---------|-------|---------|-------|---------|-------|---------|-------|
| com.iap.01 | JPN      | 100   |         |       |         |       |         |       |         |       |
| com.iap.02 | HKG      | 10    | MAC     | 1.9   | TWN     | 65    |         |       |         |       |
| com.iap.03 | USA      | 2.79  | KOR     | 990   | CHN     | 7     | LBR     | 2.19  | COL     | 6500  |

- `com.iap.01`：设置基准国家为 `JPN`（日本），定价为 `100` 日元，而没有填写自定价格国家或地区，所以其余 174 个国家或地区，根据基准国家的 100 日元，苹果全球均衡价格系统自动调整对应的地区价格。
- `com.iap.02`：设置基准国家为 `HKG`（中国香港），定价为 `10` 港元，分别设置了中国澳门和中国台湾 2 个自定价格，其余 172 个国家或地区，根据基准国家的 10 港元，苹果全球均衡价格系统自动调整对应的地区价格。
- `com.iap.03`：设置基准国家为 `USA`（美国），定价为 `2.79` 美元，分别设置了4个国家或地区的自定价格，其余 170 个国家或地区，根据基准国家的 2.79 美元，苹果全球均衡价格系统自动调整对应的地区价格。

**总结：**

- 如果没有自定价格的国家或地区，则只配置基准国家和基准国价格就可以。
- 如果有自定价格的国家或地区，则在表格右边填写对应的自定价格的国家或地区，不同内购商品可以填写不同的国家和地区，并且填写个数也可以不同。
- 175 个国家和地区的代码，可参考 `苹果各国家地区代码` 工作表。


### 2.4 内购商品：销售范围配置

切换到 `Territories` 工作表，可以看到如下图所示例：

![2023-AppleParty-v3-05](https://ihtcboy.com/images/2023-AppleParty-v3-05.jpeg)

- **Product ID**：用于映射多个工作表的内容，所以可以在 `AppleParty` 工作表的内购商品信息填写好后，直接复制过来。
- **在所有国家/地区销售(1是，0否)**：注意，如果此值为 `1`，则其它项的配置直接忽视，并且为 1 时，包含将来新国家/地区自动提供。如果值为 `0`，则默认下架状态，然后根据其它项的配置来决定销售范围，见下一项的配置。
- **将来新国家/地区自动提供(1是，0否)**：如果字段 `在所有国家/地区销售` 值为 `1`，则此字段值固定为 `1`。否则，此值为 `1` 表示将来 App Store 添加新国家/地区时自动提供销售，值为 `0` 表示将来新国家/地区不会自动提供销售。
- **自定销售国家**：如果字段 `在所有国家/地区销售` 值为 `1`，则此字段设置无效。否则，填写一个或多个国家或地区时，则表示不会在所有国家/地区销售，只会在填写的国家和地区中上架销售。

下面是示例说明：

| Product ID | 在所有国家/地区销售(1是，0否) | 将来新国家/地区自动提供(1是，0否) | 销售1 | 销售2 | 销售3 | 销售4 | 销售5 |
|------------|-------------------|---------------------|-----|-----|-----|-----|-----|
| com.iap.01 | 0                 | 1                   | TWN | HKG | MAC |     |     |
| com.iap.02 | 1                 | 0                   |     |     |     |     |     |
| com.iap.03 | 0                 | 0                   | USA | JPN | CHN | LBR | COL |
| com.iap.04 | 0                 | 1                   |     |     |     |     |     |
| com.iap.05 | 0                 | 0                   |     |     |     |     |     |


- `com.bbbap.01`：当前只在 `TWN`(中国台湾)、`HKG`（中国香港）、`MAC`(中国澳门) 销售，并且将来新国家/地区自动提供销售。
- `com.bbbap.02`：在所有国家/地区销售，并且将来新国家/地区自动提供销售。
- `com.bbbap.03`：当前只在 `USA`(美国)、`JPN`（日本）、`CHN`(中国)、`LBR` 和 `COL` 销售，并且将来新国家/地区不提供销售。
- `com.bbbap.04`：当前下架状态，直到将来有新国家/地区时自动提供销售。
- `com.bbbap.05`：下架。


关于这个销售范围的描述，在导入表格后，会显示对应的销售范围说明，参考下一章节内容。


### 2.5 内购商品：批量上传

点击 “导入表格”，可选择excel表进行导入，然后会显示导入的品项明细表：

![2023-AppleParty-v3-06](https://ihtcboy.com/images/2023-AppleParty-v3-06.jpeg)

首先，检查导入的数据，是否正确，包括 `销售范围` 和 `价格机制` 等。

然后，在右下角有 `上传截图` 按钮，点击导入图片。如下图：
![2023-AppleParty-v3-07](https://ihtcboy.com/images/2023-AppleParty-v3-07.jpeg)

截图是根据表格中填写的名字，匹配对应的图片文件，所以需要保证截图文件的名字和后缀一致，否则无法识别和上传。如果截图为空或错误，商品信息会正常更新，但截图不会更新。

左下角的 `保留自动续期订阅者现有定价`，就是表示自动订阅商品，已经订阅的用户，如果价格调整的话，是否原有用户保持原订阅价格。如下图，是不保留原定价和保留的不同效果：
![2023-AppleParty-v3-08](https://ihtcboy.com/images/2023-AppleParty-v3-08.jpeg)

首次点击 `提交` 后，如未设置 API 密钥，会显示下面的界面：

![2023-AppleParty-v3-09](https://ihtcboy.com/images/2023-AppleParty-v3-09.jpeg)

首次需要设置，或者点击右下角 `设置密钥` 重新设置。密钥获取，参考我们之前的文章：[App Store Connect API 密钥生成](https://juejin.cn/post/7181099247956131896#heading-2)

最后，点击 `提交`，会显示提交的日志输出：

![2023-AppleParty-v3-10](https://ihtcboy.com/images/2023-AppleParty-v3-10.jpeg)

上传失败时，查看 `❌` 就是说明有异常或错误内容，需要自行判断是否正常：

```
[04-18 10:12:50] 内购已经存在：com.tc.2 ，开始更新信息中...
[04-18 10:12:51] 开始更新价格计划表：com.tc.2，HKG，10
[04-18 10:12:53] 基准国家的内购价格点：HKG，10.1 ，未找到此档位！❌ 

[04-18 10:13:23] 内购商品：com.tc.6 无送审截图或未上传截图~
[04-18 12:22:17] 内购已经存在：com.tc.7 ，开始更新信息中...
[04-18 12:22:17] 无价格计划表：com.tc.7 ，请确认！❌ 
```

至此，批量内购创建和上传操作完成！✅


### 2.6 其它问题

- 订阅商品：不支持配置订阅时限，现在默认值是`一个月`。
- 家人共享：目前默认是`不开启`。
- 删除商品：避免运营错误操作风险，所以暂时没有提供删除内购商品的功能。下文有脚本，可以自动获取。
- 临时调价：目前不支持不同时间段的价格调整，后续看看大家是否有需要才继续迭代。

另外，近期会增加表格和苹果 ASC 后台商品的价格检查，用于检查配置价格是否正常。

最后，大家使用过程中，有任何疑问或建议，欢迎在评论区反馈。


## 三、代码细节和注意点

### 3.1 价格点

从苹果 ASC 下载的价格点矩阵表，比如中国 `customerPrice` 为 `1`，而通过 [List all price points for an in-app purchase](https://developer.apple.com/documentation/appstoreconnectapi/list_all_price_points_for_an_in-app_purchase) API 获取到的是 `1.0`：

```
"attributes": {
    "customerPrice": "1.0", 
    "proceeds": "0.84", 
    "priceTier": "10001"
}, 
```

所以，我们的表格上应该是填写 `1` 还是 `1.0` 呢？还有港元 `10`，API 获取到的是 `10.0` 等。

答案是，都可以！怎么办到呢？

我们把价格，统一转换成保留 2 位小数的价格点，来保证价格点一致。

```swift
/// 返回保留2位小数的价格格式
/// 因为苹果接口返回的价格可能是 "3"，"3.0" 或 "3.00"
/// - Parameter price: 原价格
/// - Returns: 保留2位小数的价格字符串
func normalizePrice(price: String) -> String {
    let components = price.split(separator: ".")
    if components.count == 1 {
        return price + ".00"
    } else if components.count == 2 {
        let decimalPart = components[1]
        if decimalPart.count == 1 {
            return "\(components[0]).\(decimalPart)0"
        } else if decimalPart.count >= 2 {
            return "\(components[0]).\(decimalPart.prefix(2))"
        }
    }
    return price
}
```

当然，眼尖的朋友，可能关注到一个字段 `"priceTier": "10001"`，不是说没有价格等级了吗？怎么还有！！！理论上是没有了，但其实，苹果也是要保存这些价格之间的关系表，所以可以理解 priceTier 为价格点的 id。

那咱们不填写价格，用这个 `priceTier` 不就好了吗！理想很美好，现实很残酷！

当我调用自动续期订阅的 [List All Price Points for a Subscription](https://developer.apple.com/documentation/appstoreconnectapi/list_all_price_points_for_a_subscription) API 获取到的结果：

```
"attributes" : {
      "customerPrice" : "1.0",
      "proceeds" : "0.84",
      "proceedsYear2" : "0.84"
},
```

自动续期订阅的没有 `priceTier` 字段，所以你可能还有怀疑，咱们在看看 [InAppPurchasePricePoint.Attributes](https://developer.apple.com/documentation/appstoreconnectapi/inapppurchasepricepoint/attributes) 和 [SubscriptionPricePoint.Attributes](https://developer.apple.com/documentation/appstoreconnectapi/subscriptionpricepoint/attributes) 文档，确实没有！

所以，关于价格点，应该怎么让运营同学定义，建议还是直接使用价格，简单明了！

### 3.2 销售范围

苹果提供的更改内购的销售范围接口，只支持 `availableInNewTerritories`，也就是是否将来新国家/地区自动提供！如果你需要支持全部的所有国家或地区，你只能把所有的国家代码，全部放到 `availableTerritories` 数组里！疯了吧！

最后，发现之前的 API [Create an In-App Purchase](https://developer.apple.com/documentation/appstoreconnectapi/create_an_in-app_purchase) 和 [Modify an In-App Purchase](https://developer.apple.com/documentation/appstoreconnectapi/modify_an_in-app_purchase) 里有一个字段 `availableInAllTerritories`，这样，如果我们希望在所有国家/地区销售，设置为 `ture` 就可以！注意，这里是包括了将来新国家/地区自动提供。

### 3.3 删除内购（包含订阅产品）

最后，可能就是我们会一直调试和测试一个或多个内购商品。然后，我们又想重新生成一次，想删除之前所有商品，在苹果 ASC 后台一个一个删除也不太现实，所以，还是写了一个脚本，一键自动删除所有：

```python
#!/usr/bin/env python3

# pip install pyjwt
import jwt
# pip install requests
import requests
import time
import json


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

	
# ---- TODO: 配置你的参数！ ----
	
p8 = "xxxxxx.p8"
kid = "xxxxxx"
iss = "xxxxxx"
token = createASCToken(p8, kid, iss)

header = {
	"Authorization": f"Bearer {token}"
}

def get(url):
	rs1 = requests.get(url, headers=header)
	print(rs1.status_code)
	print(rs1.text)
	#	data = json.loads(rs1.text)
	#	print(data)
	if rs1.status_code != 200:
		print(url)

def post(url, body):
	rs1 = requests.post(url, headers=header, json=body)
	print(rs1.status_code)
	print(rs1.text)
	

def patch(url, body):
	rs1 = requests.patch(url, headers=header, json=body)
	print(rs1.status_code)
	print(rs1.text)
	
	
def delete(url):
	rs1 = requests.delete(url, headers=header)
	print(rs1.status_code)
	print(rs1.text)


# ---- IAP 删除 ----

# 1. 全部 app
def apps():
	url = "https://api.appstoreconnect.apple.com/v1/apps" 
	get(url)

#apps()


# 2. 某个 app 信息
def app_versions(app_id):
	url = f'https://api.appstoreconnect.apple.com/v1/apps/{app_id}/appStoreVersions'
	get(url)


# ---- TODO: 填写要清空的 app id ----

app_id = "xxxxxx"
#app_versions(app_id)



# 3. app 内购列表
def app_inAppPurchases_list(app_id):
	# List All In-App Purchases for an App
	url = f'https://api.appstoreconnect.apple.com/v1/apps/{app_id}/inAppPurchasesV2?limit=200' #'?limit=50&offset=1'
	#url = f'https://api.appstoreconnect.apple.com/v1/apps/{app_id}/inAppPurchasesV2?cursor=Mg.ANrqDAc&limit=50'
	return get(url)


## 4. 删除内购商品信息
def app_iap_delete(app_iap_id):
	id = app_iap_id
	#Delete an In-App Purchase
	url = f'https://api.appstoreconnect.apple.com/v2/inAppPurchases/{id}'
	delete(url)


## 5. Delete All IAP
def delete_all_iap(data):
	iaps = data["data"]
	for iap in iaps:
		id = iap["id"]
		print(id)
		app_iap_delete(id)


data = app_inAppPurchases_list(app_id)
delete_all_iap(data)


## 6. 获取所有订阅组
def app_subscriptionGroups(app_id):
	id = app_id
	# List All Subscription Groups for an App
	url = f'https://api.appstoreconnect.apple.com/v1/apps/{id}/subscriptionGroups'
	return get(url)


## 7. 获取订阅组下所有内购商品
def app_subscriptionGroups_subscriptions(app_iap_grop_id):
	id = app_iap_grop_id
	# List All Subscriptions for a Subscription Group
	url = f'https://api.appstoreconnect.apple.com/v1/subscriptionGroups/{id}/subscriptions'
	return get(url)


## 8. 删除订阅商品
def app_iap_subscriptions_delete(app_iap_id):
	id = app_iap_id
	#Delete a Review Screenshot for an In-App Purchase
	url = f'https://api.appstoreconnect.apple.com/v1/subscriptions/{id}'
	delete(url)


## 9. 删除订阅组
def app_iap_subscriptionGroups_delete(app_iap_grop_id):
	id = app_iap_grop_id
	#Delete a Subscription Group
	url = f'https://api.appstoreconnect.apple.com/v1/subscriptionGroups/{id}'
	delete(url)

	
## 10. Get All Subscription
def all_subscription(groups):
	app_subscriptions = []
	for group in groups.get("data", []):
		app_iap_grop_id = group.get("id", "")
		subscriptions = app_subscriptionGroups_subscriptions(app_iap_grop_id)
		app_subscriptions += subscriptions.get("data", [])	
	return app_subscriptions


## 11. Delete All Subscription
def delete_all_subs(subscriptions):
	for subs in subscriptions:
		app_iap_id = subs.get("id", "")
		print(app_iap_id)
		app_iap_subscriptions_delete(app_iap_id)


## 12. Delete All Subscription Group
def delete_all_groups(groups):
	for group in groups.get("data", []):
		app_iap_grop_id = group.get("id", "")
		print(app_iap_grop_id)
		app_iap_subscriptionGroups_delete(app_iap_grop_id)


groups = app_subscriptionGroups(app_id)
subscriptions = all_subscription(groups)
delete_all_subs(subscriptions)
delete_all_groups(groups)
```

最后，这个脚本也放到了我们 GitHub 仓库 [37iOS/AppStoreConnectAPI-Demo](https://github.com/37iOS/AppStoreConnectAPI-Demo)，后续 API 升级都会一起更新，大家可以自行获取。

## 四、总结和未来

开发过程有很多细节文中没有提到，具体大家可以阅读源代码 [37iOS/AppleParty](https://github.com/37iOS/AppleParty)，或者有遇到什么问题，欢迎评论区交流。

关于苹果 App Store Connect API 的问题，还是有很多优化的空间的。比如接口请求频率过快：

```
Error code: RATE_LIMIT_EXCEEDED, title: The request rate limit has been reached., detail: Optional("We\'ve received too many requests for this API. Please wait and try again or slow down your request rate.")
```

还有就是设置自定价格和销售范围，不支持增量修改！每次必然全量调用，如果有 20 个自定价格的国家或地区，那个自定价格每个请求 2 个，就 40 个请求了。如果有 100 个内购商品，就是 4000 次请求。所以，还是希望苹果后续能完善 API，支持更多场景的配置。

AppleParty 要解决的问题是开发者有很多 app 的情况下的管理，比如有多语言、频繁更新等，当然首要是对游戏行业的需求，比如内购买项目达到 100+ 个，人工一个一个创建显示无法满足，而且如今 App Store 新价格机制，需要看完 175 个国家和地区，已经不再现实！所以，如果团队没有精力打造一套工具流，AppleParty 也许是不错的选择！

以上就是  AppleParty v3 更新的简单介绍，大家可以在 GitHub [37iOS/AppleParty](https://github.com/37iOS/AppleParty) 查看详细的源代码。如果觉得不错，给我们点个赞！如有疑问或者问题，欢迎留言交流~

最后，Apple Party（苹果派）是一个新生儿，所以可能会存在很多缺陷，甚至不能满足所有的场景，这也是我们开源的目的，希望集大家的力量一起参与！也希望大家多担待和理解万岁，期待大家一起给项目提建议，提代码，一起好卷！

最后的最后，还是要重提一次，[准备好迎接即将在 5 月 9 日推出的增强全球定价机制](https://developer.apple.com/cn/news/?id=74739es1)，2023 年 5 月 9 号还没有选择基础国家的 App 或 IAP（包含订阅产品），苹果会以美国为基准定价，直接影响：`比如中国大陆销售的 6 元档位商品，按 1 美元换算会涨价到 8 元！` 所以，现在马上配置吧！避免用户嫌贵！影响销量！

> WWDC23 将于北京时间 6 月 6 日举行，让我们一起期待 Apple 全新的技术升级吧！我们也会第一时间进行解读和分享，欢迎关注我们，了解更多 iOS 和 Apple 的资讯~

## 参考引用

- [使用 App Store Connect API v2.3 管理 App Store 新定价机制 - 掘金](https://juejin.cn/post/7219298341462196281)
- [App Store 新定价机制 - 2023年最全版 - 掘金](https://juejin.cn/post/7213022785366933559)
- [管理自动续期订阅的定价 - 管理订阅 - App Store Connect](https://developer.apple.com/cn/help/app-store-connect/manage-subscriptions/manage-pricing-for-auto-renewable-subscriptions/)
- [开源一款苹果 macOS 工具 - AppleParty（苹果派） - 掘金](https://juejin.cn/post/7081069026515877919)
- [使用 App Store Connect API 批量创建内购商品 - 掘金](https://juejin.cn/post/7181099247956131896)
- [37iOS/AppleParty - Download](https://github.com/37iOS/AppleParty/releases)
- [List all price points for an in-app purchase | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/list_all_price_points_for_an_in-app_purchase)
- [InAppPurchasePricePoint.Attributes | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/inapppurchasepricepoint/attributes)
- [List All Price Points for a Subscription | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/list_all_price_points_for_a_subscription)
- [SubscriptionPricePoint.Attributes | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/subscriptionpricepoint/attributes)
- [Create an In-App Purchase | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/create_an_in-app_purchase)
- [Modify an In-App Purchase | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/modify_an_in-app_purchase)
- [37iOS/AppleParty](https://github.com/37iOS/AppleParty) 
- [准备好迎接即将在 5 月 9 日推出的增强全球定价机制 - Apple Developer](https://developer.apple.com/cn/news/?id=74739es1)

> 注：如若转载，请注明来源。