title: 使用 App Store Connect API v2.3 管理 App Store 新定价机制
date: 2023-04-08 00:16:23
categories: technology #induction life poetry
tags: [App Store,苹果商店新定价机制,App Store Connect API]  # <!--more-->
reward: true

---

> 本文首发于 [使用 App Store Connect API v2.3 管理 App Store 新定价机制 - 掘金](https://juejin.cn/post/7219298341462196281)，欢迎关注我们 [@37手游iOS技术运营团队](https://juejin.cn/user/1002387318511214) 。

作者：iHTCboy

<!--more-->

![2023-AppStoreConnectAPI-v2.3-00](https://ihtcboy.com/images/2023-AppStoreConnectAPI-v2.3-00.jpeg)

### 一、前言

我们在上一篇文章 《[App Store 新定价机制](https://juejin.cn/post/7213022785366933559)》讲解了苹果新定价升级，本文接着来讲解一下新 App Store Connect API v2.3 的使用示例。

### 二、App Store Connect API v2.3

关于 App Store Connect API 的基本使用和密钥创建，可以直接参考我们之前的文章 《[使用 App Store Connect API 批量创建内购商品](https://juejin.cn/post/7181099247956131896)》，这里就不重复展开了。我们直接来给出请求的示例和说明啊。

关于 App Store Connect API [version 2.3 release notes](https://developer.apple.com/documentation/appstoreconnectapi/app_store_connect_api_release_notes/app_store_connect_api_version_2_3_release_notes)，所有请求示例代码和响应内容，已经上传到 GitHub 仓库：

- [37iOS/AppStoreConnectAPI-Demo](https://github.com/37iOS/AppStoreConnectAPI-Demo)


App Store Connect API v2.3 更新的内容：

- 获取 App 和 应用内购买 IAP 的所有价格点（最多 900 个价格点）。
- 获取 App 价格点对应的全球均衡价格。
- 获取和管理 App 和 应用内购买 IAP 的价格表，支持自动价格、手动价格和基准国家的配置。
- 获取和管理 App 和 应用内购买 IAP （包含订阅）的允许销售范围。

#### 2.1 获取所有有效的国家或地区（List Territories）

因为以下的很多接口，都依赖这个接口获取到的国家或地区标识，所以先讲解。这个接口是 v1.2 就有的基础接口，作用是获取 App Store 目前允许销售的所有国家和地区。

GET 请求：

```url
GET https://api.appstoreconnect.apple.com/v1/territories?limit=200
```

返回的内容，其中的中国大陆是这样：

```json
{
    "type": "territories",
    "id": "CHN",
    "attributes": {
        "currency": "CNY"
    },
    "links": {
        "self": "https://api.appstoreconnect.apple.com/v1/territories/CHN"
    }
}
```

目前苹果支持 175 个国家和地区，所以在请求链接增加 `?limit=200`，就可以不用分页，直接返回全部的内容。另外，如果是自定 App，允许的销售国家地区与 App Store 不相同，获取接口是 [List All Territories for an End User License Agreement](https://developer.apple.com/documentation/appstoreconnectapi/list_all_territories_for_an_end_user_license_agreement)，需要了解的可以自行查询。


#### 2.2 获取 App 的价格点（List all price points for an app） 

```url
GET https://api.appstoreconnect.apple.com/v1/apps/{id}/appPricePoints?filter[territory]=CHN&include=territory&limit=200
```

返回的内容：

```json
{
  "data": [
    {
      "type": "appPricePoints",
      "id": "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ",
      "attributes": {
        "customerPrice": "1.0",
        "proceeds": "0.84"
      },
      "relationships": {
        "territory": {
          "data": {
            "type": "territories",
            "id": "CHN"
          }
        }
      }
    }
 ],
 "links": {
    "self": "https://api.appstoreconnect.apple.com/v1/apps/1240856775/appPricePoints?include=territory&filter%5Bterritory%5D=CHN&limit=200",
    "next": "https://api.appstoreconnect.apple.com/v1/apps/1240856775/appPricePoints?cursor=AMg.AM99C8s&include=territory&filter%5Bterritory%5D=CHN&limit=200"
 },
 "meta": {
    "paging": {
      "total": 801,
      "limit": 200
    }
  }
}
```

苹果说这个接口会返回 900 个价格点，目前只返回 801 个，其中包含一个 `0.0` 免费价格点。

```json
"attributes": {
	"customerPrice": "0.0",
	"proceeds": "0.0"
},
```

另外，还有 100 个高价格点，估计是向苹果申请通过后，接口才会返回。

如果不加 `?limit=200` 最大额分页的话，所有的国家和地区的价格点，有 140175 个：

```json
"meta" : {
	"paging" : {
		"total" : 140175,
		"limit" : 50
	}
}
```

加上 `?limit=200` 有 700 分页，所以你需要请求 700 次！在使用时建议还是按国家和地区码分别一个一个获取，如 `filter[territory]=CHN` 只获取中国大陆的价格点，因为减少请求分页量比较方便管理。那么如果请求超过 200 个时，应该怎么分页请求呢？

通过 `next` 字段来请求下一页，里面有一个 `cursor` 字段，表示下一页的游标，是不是有点傻？按道理说，用 `offset=2` 会不会更好一点？

```json
"links" : {
	"self" : "https://api.appstoreconnect.apple.com/v1/apps/1240856775/appPricePoints?include=territory&filter%5Bterritory%5D=JPN&limit=5",
	"next" : "https://api.appstoreconnect.apple.com/v1/apps/1240856775/appPricePoints?cursor=BQ.AMO4C2k&include=territory&filter%5Bterritory%5D=JPN&limit=5"
},
```

`next` 字段就是请求下一页的请求链接，如果开发者不想记录整个链接内容，可以只保存 表示下一页的游标的字段 `cursor` 值。

当然，奇葩的事情，Apple Server API 接口的分页逻辑是：`hasMore` 和 `revision` 或 `paginationToken`，例如 `“&paginationToken=45380b30-5ed1-11ed-8aba-e1f7e9604fd2"`，如此不统一的接口请求方式，充分说明这肯定是两个团队在搞事！


#### 2.3 获取某个 app 的价格点的信息（Read app price point information）

注意这个接口需要的 `{id}`参数，是 App 的价格点接口获取到的价格点 id，例如 `eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ`。

```url
GET https://api.appstoreconnect.apple.com/v3/appPricePoints/{id}?include=app,territory
```

默认请求返回的内容：
```json
{
	"data": {
		"type": "appPricePoints",
		"id": "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ",
		"attributes": {
			"customerPrice": "1.0",
			"proceeds": "0.84"
		}
	}
}
```

加上参数 `?include=app,territory` 才能获取到对应的国家或地区码，比如价格点人民币 1.0 元，对应的 id ：

```json
{
	"type" : "appPricePoints",
	"id" : "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ",
	"attributes" : {
		"customerPrice" : "1.0",
		"proceeds" : "0.84"
	},
	"relationships" : {
		"territory" : {
			"data" : {
				"type" : "territories",
				"id" : "CHN"
			}
		}
	}
}
```

这个接口的作用是方便根据某个价格点，反查货币种类和 app 信息等。另外有 100 个高价格不是所有 app 默认支持，所以通过反查可以获取 app 信息。

#### 2.4 某个价格点对应的174个国家或地区的均衡价格（List app price point equalizations）

注意这个接口的 `{id}`参数，也是 App 的价格点接口获取到的价格点 id。

```
GET https://api.appstoreconnect.apple.com/v3/appPricePoints/{id}/equalizations?include=app,territory
```

返回的内容示例：

```json
{
      "type": "appPricePoints",
      "id": "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJBRkciLCJwIjoiMTAwMTAifQ",
      "attributes": {
        "customerPrice": "0.99",
        "proceeds": "0.84"
      },
      "relationships": {
        "app": {
          "data": {
            "type": "apps",
            "id": "1240856775"
          }
        },
        "territory": {
          "data": {
            "type": "territories",
            "id": "AFG"
          }
        }
      }
    }
```

返回的是剩下 174 个国家或地区的对应价格点的均衡价格。

注意：这个接口是 app 的全球均衡价格点查询，IAP 内购的接口暂时未发现苹果有提供，但 v2.0 版本苹果提供了订阅商品的全球均衡价格点接口：[List All Subscription Price Point Equalizations](https://developer.apple.com/documentation/appstoreconnectapi/list_all_subscription_price_point_equalizations)。

#### 2.5 获取内购 IAP 的价格点（List all price points for an in-app purchase）

```url
GET https://api.appstoreconnect.apple.com/v2/inAppPurchases/{id}/pricePoints?filter[territory]=CHN&include=territory&limit=200
```

注意接口的 `{id}` 是内购商品 id，可以通过接口 [List All In-App Purchases for an App](https://developer.apple.com/documentation/appstoreconnectapi/list_all_in-app_purchases_for_an_app) 获取某个 app 的所有 IAP id。

字段 `filter[territory]=CHN,USA` 拼接多个字段，这时可以返回多个地区的价格点。另外，如果需要知道返回的价格点是那个国家或地区的，需要带上 `include=territory`，否则不会显示国家或地区码。

最终返回的内容示例：

```json
{
      "type": "inAppPurchasePricePoints",
      "id": "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ",
      "attributes": {
        "customerPrice": "1.0",
        "proceeds": "0.84",
        "priceTier": "10001"
      },
      "relationships": {
        "territory": {
          "data": {
            "type": "territories",
            "id": "CHN"
          }
        }
      }
    }
```

同时，这个接口返回 800 个价格点，100 个高价格点申请通过的 IAP 商品才支持。另外IAP 内购商品没有 `0.0` 免费的价格点。

#### 2.6 获取某个 app 的价格时间表（App 级别）（Read price schedule information for an app）

```
GET https://api.appstoreconnect.apple.com/v1/apps/{id}/appPriceSchedule?include=app,automaticPrices,baseTerritory,manualPrices
```

返回内容：

```json
{
    "data": {
        "type": "appPriceSchedules",
        "id": "1240856775",
        "relationships": {
            "app": {
                "data": {
                    "type": "apps",
                    "id": "1240856775"
                }
            },
            "automaticPrices": {
                "meta": {
                    "paging": {
                        "total": 170,
                        "limit": 10
                    }
                },
                "data": [
                    {
                        "type": "appPrices",
                        "id": "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJBRkciLCJwIjoiMTAwMTAiLCJzZCI6MC4wLCJlZCI6MC4wfQ"
                    },
                ... 省略 ...
                ... 省略 ...
                ],
            },
            "manualPrices": {
                "meta": {
                    "paging": {
                        "total": 8,
                        "limit": 10
                    }
                },
                "data": [
                    {
                        "type": "appPrices",
                        "id": "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJDSE4iLCJwIjoiMTAwMDEiLCJzZCI6MC4wLCJlZCI6MC4wfQ"
                    },
                ... 省略 ...
                ... 省略 ...
                ],
            },
            "baseTerritory": {
                "data": {
                    "type": "territories",
                    "id": "CHN"
                },
            }
        },
    }
```

返回的内容包含 3 部分：

- automaticPrices：自动价格
- manualPrices：自定价格
- baseTerritory：基准国家

#### 2.7 获取某个 app 的详细价格时间表（App 级别）（Read an app's price schedule information）

```
GET https://api.appstoreconnect.apple.com/v1/appPriceSchedules/{id}?include=app,automaticPrices,baseTerritory,manualPrices
```

这个接口返回内容与上一个接口一样，所以这里省略，暂时不明确为什么会这样。


#### 2.8 获取某个 app 的全球均衡价格时间表（App 级别）（List automatically generated prices for an app）

```
GET https://api.appstoreconnect.apple.com/v1/appPriceSchedules/{id}/automaticPrices?include=appPricePoint,territory&limit=200
```

返回内容，示例：中国香港的价格设置为手动调整价格，且价格于 2023 年 4 月 20 日结束，系统就变成“自动调整”：

```json
{
	"type" : "appPrices",
	"id" : "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJIS0ciLCJwIjoiMTAwMDciLCJzZCI6MTY4MTk3NDAwMC4wMDAwMDAwMDAsImVkIjowLjB9",
	"attributes" : {
		"manual" : false,
		"startDate" : "2023-04-20",
		"endDate" : null
	},
	"relationships" : {
		"appPricePoint" : {
			"data" : {
				"type" : "appPricePoints",
				"id" : "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJIS0ciLCJwIjoiMTAwMDcifQ"
			}
		},
		"territory" : {
			"data" : {
				"type" : "territories",
				"id" : "HKG"
			}
		}
	},
}
```

注意：通过开始时间和结束时间，有可能总的条数 total 超过 174 个国家或地区。还有外汇汇率或税率调整等因素。全球均衡价格时间表比较复杂，大家可以自己在 ASC 后台配置不同价格规则，然后观察接口返回的内容。

#### 2.9 获取某个 app 的自定价格时间表（App 级别）（List manually chosen prices for an app）

```
https://api.appstoreconnect.apple.com/v1/appPriceSchedules/{id}/manualPrices?include=appPricePoint,territory&limit=200
```

响应内容示例：

```json
{
    "type": "appPrices",
    "id": "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJBVVMiLCJwIjoiMTAwMjIiLCJzZCI6MTY4MjQ5MjQwMC4wMDAwMDAwMDAsImVkIjoxNjgyODM4MDAwLjAwMDAwMDAwMH0",
    "attributes": {
        "manual": true,
        "startDate": "2023-04-26",
        "endDate": "2023-04-30"
    },
    "relationships": {
        "appPricePoint": {
            "data": {
                "type": "appPricePoints",
                "id": "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJBVVMiLCJwIjoiMTAwMjIifQ"
            }
        },
        "territory": {
            "data": {
                "type": "territories",
                "id": "AUS"
            }
        }
    }
}
```

#### 2.10 获取某个 app 的基准国家（App 级别）(Read the base territory for an app's price schedule)

```
GET https://api.appstoreconnect.apple.com/v1/appPriceSchedules/{id}/baseTerritory
```

响应内容示例：
```json
{
    "data": {
        "type": "territories",
        "id": "CHN",
        "attributes": {
            "currency": "CNY"
        },
        "links": {
            "self": "https://api.appstoreconnect.apple.com/v1/territories/CHN"
        }
    },
    "links": {
        "self": "https://api.appstoreconnect.apple.com/v1/appPriceSchedules/1240856775/baseTerritory"
    }
}
```

如果没有设置基准国家的新 app，默认是美国为基准国家：

```json
{
  "data" : {
    "type" : "territories",
    "id" : "USA",
    "attributes" : {
      "currency" : "USD"
    },
    "links" : {
      "self" : "https://api.appstoreconnect.apple.com/v1/territories/USA"
    }
  },
  "links" : {
    "self" : "https://api.appstoreconnect.apple.com/v1/appPriceSchedules/6446581591/baseTerritory"
  }
}
```

#### 2.11 设定某个 app 的价格调整（App 级别）(Add a scheduled price change to an app)

```url
POST https://api.appstoreconnect.apple.com/v1/appPriceSchedules
```

请求体：

```python
#基准国家
base_territory_id = "CHN"
base_territory_id2 = "HKG"

app_price_id = "随意名字，用于区别一个价格计划"
# 全球均衡价格
app_price_point_id = "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ" # CNY￥ 1.00
app_price_point_id2 = "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJDSE4iLCJwIjoiMTAwMDUifQ" # CNY￥ 2.50
# 自定价格
app_price_point_id3 = "eyJzIjoiMTI0MDg1Njc3NSIsInQiOiJIS0ciLCJwIjoiMTAwMTUifQ" # HKD $16.00

# 请求体
body = {
	'data': {
		'relationships': {
			'app': {
				'data': {
					'id': f"{app_id}",
					'type': 'apps'
				}
			},
			'baseTerritory': {
				'data': {
					'id': f"{base_territory_id}",
					'type': 'territories'
				}
			},
			'manualPrices': {
				'data': [
					{
						'id': f"{app_price_id}",
						'type': 'appPrices'
					},
					{
						'id': f"{app_price_id}2",
						'type': 'appPrices'
					},
					{
						'id': f"{app_price_id}3",
						'type': 'appPrices'
					}
				]
			}
		},
		'type': 'appPriceSchedules'
	},
	'included': [
		{
			'id': f'{app_price_id}',
			'type': 'appPrices',
			'attributes': {
				'startDate': '2023-04-25',
				'endDate': None
			},
			'relationships': {
				'appPricePoint': {
					'data': {
						'id': f"{app_price_point_id}",
						'type': 'appPricePoints'
					}
				}
			}
		},
		{
			'id': f'{app_price_id}2',
			'type': 'appPrices',
			'attributes': {
				'startDate': None,
				'endDate': '2023-04-25'
			},
			'relationships': {
				'appPricePoint': {
					'data': {
						'id': f"{app_price_point_id2}",
						'type': 'appPricePoints'
					}
				}
			}
		},
		{
			'id': f'{app_price_id}3',
			'type': 'appPrices',
			'attributes': {
				'startDate': None, # '2023-04-14',
				'endDate': None
			},
			'relationships': {
				'appPricePoint': {
					'data': {
						'id': f"{app_price_point_id3}",
						'type': 'appPricePoints'
					}
				}
			}
		}
	]
}
```

关于这个请求的参数和解析，请参考本文的 2.16 章节《2.16 设定某个 IAP 的价格调整（IAP 级别）（Add a scheduled price change to an in-app purchase）》，因为请求相同，所以统一在后文中解析。

#### 2.12 获取某个 IAP 的价格时间表（IAP 级别）（Read price information for an in-app purchase price schedule）

**注：** 这个接口是 v2.0 版本就有，从查询到的内容来看，返回的只是 `manualPrices` 自定价格的信息。

```url
GET https://api.appstoreconnect.apple.com/v1/inAppPurchasePriceSchedules/{id}/manualPrices?include=inAppPurchasePricePoint,territory
```

响应示例：

```json
{
    "type": "inAppPurchasePrices",
    "id": "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJDSE4iLCJwIjoiMSIsInNkIjowLjAsImVkIjowLjB9",
    "attributes": {
        "startDate": null,
        "endDate": null,
        "manual": true
    },
    "relationships": {
        "inAppPurchasePricePoint": {
            "data": {
                "type": "inAppPurchasePricePoints",
                "id": "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJDSE4iLCJwIjoiMSJ9"
            }
        },
        "territory": {
            "data": {
                "type": "territories",
                "id": "CHN"
            }
        }
    }
}
```


#### 2.13 获取某个 IAP 的详细价格时间表（IAP 级别）(Read in-app purchase price schedule information)

**注：** 这个接口是 v2.0 版本就有，返回的内容包含基准国家、全球均衡国家和自定价格的时间表。

```url
GET https://api.appstoreconnect.apple.com/v1/inAppPurchasePriceSchedules/{id}?include=automaticPrices,baseTerritory,manualPrices
```

响应示例：
```json
{
        "type": "inAppPurchasePriceSchedules",
        "id": "6444653105",
        "relationships": {
            "baseTerritory": {
                "data": {
                    "type": "territories",
                    "id": "CHN"
                }
            },
            "manualPrices": {
                "meta": {
                    "paging": {
                        "total": 1,
                        "limit": 10
                    }
                },
                "data": [
                    {
                        "type": "inAppPurchasePrices",
                        "id": "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJDSE4iLCJwIjoiMSIsInNkIjowLjAsImVkIjowLjB9"
                    }
                ]
            },
            "automaticPrices": {
                "meta": {
                    "paging": {
                        "total": 348,
                        "limit": 10
                    }
                },
                "data": [
                    {
                        "type": "inAppPurchasePrices",
                        "id": "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJBRkciLCJwIjoiMSIsInNkIjowLjAsImVkIjoxNjgzNjE1NjAwLjAwMDAwMDAwMH0"
                    },
                ... 省略 ...
                ... 省略 ...
                ]
            }
        }
    }
```

#### 2.14 获取某个 IAP 的全球均衡价格时间表（IAP 级别）(List automatically generated prices for an in-app purchase price)

```url
GET https://api.appstoreconnect.apple.com/v1/inAppPurchasePriceSchedules/{id}/automaticPrices?include=inAppPurchasePricePoint,territory&limit=200
```

响应示例：

```json
{
    "type": "inAppPurchasePrices",
    "id": "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJBRkciLCJwIjoiMSIsInNkIjowLjAsImVkIjoxNjgzNjE1NjAwLjAwMDAwMDAwMH0",
    "attributes": {
        "startDate": null,
        "endDate": "2023-05-09",
        "manual": false
    },
    "relationships": {
        "inAppPurchasePricePoint": {
            "data": {
                "type": "inAppPurchasePricePoints",
                "id": "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJBRkciLCJwIjoiMSJ9"
            }
        },
        "territory": {
            "data": {
                "type": "territories",
                "id": "AFG"
            }
        }
    }
},
```

#### 2.15 获取某个 IAP 的基准国家（IAP 级别）(Read the selected base territory for an in-app purchase price schedule)

```url
GET https://api.appstoreconnect.apple.com/v1/inAppPurchasePriceSchedules/{id}/baseTerritory
```

响应示例：

```json
{
    "data": {
        "type": "territories",
        "id": "CHN",
        "attributes": {
            "currency": "CNY"
        },
        "links": {
            "self": "https://api.appstoreconnect.apple.com/v1/territories/CHN"
        }
    },
    "links": {
        "self": "https://api.appstoreconnect.apple.com/v1/inAppPurchasePriceSchedules/6444653105/baseTerritory"
    }
}
```

#### 2.16 设定某个 IAP 的价格调整（IAP 级别）（Add a scheduled price change to an in-app purchase）

**注：** 这个接口是 v2.0 版本就有，是原有配置 IAP 内购价格的接口，苹果在原接口的基础上，增加了字段 `baseTerritory` 表示基准国家。

```url
POST https://api.appstoreconnect.apple.com/v1/inAppPurchasePriceSchedules
```

请求体：
```json
{
	'data': {
		'relationships': {
			'inAppPurchase': {
				'data': {
					'id': f"{app_iap_id}",
					'type': 'inAppPurchases'
				}
			},
			'baseTerritory': {
				'data': {
					'id': f"{base_territory_id}",
					'type': 'territories'
				}
			},
			'manualPrices': {
				'data': [
					{
						'id': f'{iap_price_id}',
						'type': 'inAppPurchasePrices'
					}
				]
			}
		},
		'type': 'inAppPurchasePriceSchedules'
	},
	'included': [
		{
			'id': f'{iap_price_id}',
			'type': 'inAppPurchasePrices',
			'attributes': {
				'startDate': None, # '2023-04-14',
				'endDate': None
			},
			'relationships': {
				'inAppPurchasePricePoint': {
					'data': {
						'id': f"{iap_price_point_id}",
						'type': 'inAppPurchasePricePoints'
					}
				},
				'inAppPurchaseV2': {
					'data': {
						'id': f"{app_iap_id}",
						'type': 'inAppPurchases'
					}
				}
			}
		}
	]
}
```

其中的请求字段的含义：

- `app_iap_id`：内购商品的标识 id，ASC 后台叫 `Apple ID`，如 `6444653105`
- `base_territory_id`：基准国家或地区，例如中国大陆，`CHN`，中国香港 `HKG`
- `iap_price_id`：随意名字，用于区别一个价格计划，如 `我是1.00人民币计划`
- `iap_price_point_id`：通过内购价格点列表（本文章节 2.5 获取内购 IAP 的价格点）获取，如 CNY￥ 1.00 的价格点 id 是 "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ"。

上面的请求，是表示设置基准国家，并且设置全球均衡价格，注意，这里默认设置全球所有的国家和地区。如果是想某个国家或地区设置自定价格，请求示例：

```python

#基准国家
base_territory_id = "CHN"
base_territory_id2 = "HKG"

iap_price_id = "随意名字，用于区别一个价格计划"
# 全球均衡价格
iap_price_point_id = "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJDSE4iLCJwIjoiMTAwMDEifQ" # CNY￥ 1.00
iap_price_point_id2 = "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJDSE4iLCJwIjoiMTAwMDUifQ" # CNY￥ 2.50
# 自定价格
iap_price_point_id3 = "eyJzIjoiNjQ0NDY1MzEwNSIsInQiOiJIS0ciLCJwIjoiMTAwMTUifQ" # HKD $16.00

# 请求体
body = {
	'data': {
		'relationships': {
			'inAppPurchase': {
				'data': {
					'id': f"{app_iap_id}",
					'type': 'inAppPurchases'
				}
			},
			'baseTerritory': {
				'data': {
					'id': f"{base_territory_id}",
					'type': 'territories'
				}
			},
			'manualPrices': {
				'data': [
					{
						'id': f'{iap_price_id}',
						'type': 'inAppPurchasePrices'
					},
					{
						'id': f"{iap_price_id}2",
						'type': 'inAppPurchasePrices'
					},
					{
						'id': f"{iap_price_id}3",
						'type': 'inAppPurchasePrices'
					}
				]
			}
		},
		'type': 'inAppPurchasePriceSchedules'
	},
	'included': [
		{
			'id': f'{iap_price_id}',
			'type': 'inAppPurchasePrices',
			'attributes': {
				'startDate': '2023-04-25',
				'endDate': None
			},
			'relationships': {
				'inAppPurchasePricePoint': {
					'data': {
						'id': f"{iap_price_point_id}",
						'type': 'inAppPurchasePricePoints'
					}
				},
				'inAppPurchaseV2': {
					'data': {
						'id': f"{app_iap_id}",
						'type': 'inAppPurchases'
					}
				}
			}
		},
		{
			'id': f'{iap_price_id}2',
			'type': 'inAppPurchasePrices',
			'attributes': {
				'startDate': None,
				'endDate': '2023-04-25'
			},
			'relationships': {
				'inAppPurchasePricePoint': {
					'data': {
						'id': f"{iap_price_point_id2}",
						'type': 'inAppPurchasePricePoints'
					}
				},
				'inAppPurchaseV2': {
					'data': {
						'id': f"{app_iap_id}",
						'type': 'inAppPurchases'
					}
				}
			}
		},
		{
			'id': f'{iap_price_id}3',
			'type': 'inAppPurchasePrices',
			'attributes': {
				'startDate': None,
				'endDate': None
			},
			'relationships': {
				'inAppPurchasePricePoint': {
					'data': {
						'id': f"{iap_price_point_id3}",
						'type': 'inAppPurchasePricePoints'
					}
				},
				'inAppPurchaseV2': {
					'data': {
						'id': f"{app_iap_id}",
						'type': 'inAppPurchases'
					}
				}
			}
		}
	]
}
```

这个示例表示，以中国大陆 `CHN` 为基准国家，并且设置所有国家和地区都是自动全球均衡价格，除了中国香港 `HKG`。然后从现在到 `2023-04-25`，使用基准国家中国大陆的 `CNY￥ 2.50` 价格点设置全球均衡价格，从 `2023-04-25` 开始，使用基准国家中国大陆的 `CNY￥ 1.00` 价格点设置全球均衡价格。例外的是中国香港，从现在开始一直是手动调整 `自定价格` `HKD $16.00`，也就是固定价格，不跟随全球均衡价格调整。

这里坑比较多，`baseTerritory` 基准国家字段必须设置，否则会报错：

```json
{
  "errors" : [ {
    "id" : "82b5ea44-b220-402b-b7b9-88031f76a115",
    "status" : "409",
    "code" : "ENTITY_ERROR.ATTRIBUTE.REQUIRED",
    "title" : "The provided entity is missing a required field",
    "detail" : "You must provide a value for the field (baseTerritory) with this request",
    "source" : {
      "pointer" : "/data/attributes/baseTerritory"
    }
  } ]
}
```

然后 `manualPrices` 字段虽然是手动价格的意思，但并不是自定价格的意思，表示所有需要设定的价格时间表计划，这里我们设置了 3 个价格时间计划：

```json
'manualPrices': {
	'data': [
		{
			'id': f'{iap_price_id}',
			'type': 'inAppPurchasePrices'
		},
		{
			'id': f"{iap_price_id}2",
			'type': 'inAppPurchasePrices'
		},
		{
			'id': f"{iap_price_id}3",
			'type': 'inAppPurchasePrices'
		}
	]
}
```

上面的 `id` 表示价格时间计划表的名字，用于区别每个时间计划表。然后接着，就是要列表具体的价格时间表：

```
'included': [
		{
			'id': f'{iap_price_id}',
			'type': 'inAppPurchasePrices',
			'attributes': {
				'startDate': '2023-04-25',
				'endDate': None
			},
			'relationships': {
				'inAppPurchasePricePoint': {
					'data': {
						'id': f"{iap_price_point_id}",
						'type': 'inAppPurchasePricePoints'
					}
				},
				'inAppPurchaseV2': {
					'data': {
						'id': f"{app_iap_id}",
						'type': 'inAppPurchases'
					}
				}
			}
		},
                ... 省略 ...
                ... 省略 ...
    ]
```

这里最复杂的是 2 个地方，`included.x.id` 和 `manualPrices.data.x.id` 是一一对应，所以有一个价格时间计划表，就有对应的一个 `included.x.id`，它们跟 `relationships.inAppPurchasePricePoint.data.id` 是没有关联的，当然如果你觉得方便，把三者都设置为价格点的 id 也是可以。

注意 `included.x.id` 数组列出的价格时间计划表，必然在 `manualPrices.data.x.id` 在列出，否则报错：
```json
{
  "errors" : [ {
    "id" : "13b3b82d-ba4b-4fda-97e1-2c30a37bd729",
    "status" : "409",
    "code" : "ENTITY_ERROR.RELATIONSHIP.REQUIRED",
    "title" : "The provided entity is missing a required relationship",
    "detail" : "You must provide a value for the relationship 'inAppPurchasePricePoint' with this request",
    "source" : {
      "pointer" : "/included/3/relationships/inAppPurchasePricePoint"
    }
  } ]
}
```

`relationships.inAppPurchasePricePoint.data.id` 需要设置为对应需要的国家或地区的价格点 id，这里是中国大陆，所以设置为 `CHN` 对应的价格点。而需要自定价格的国家或地区，则就需要设置对应国家或地区的价格点。（内购价格点列表：参考本文章节 2.5 获取内购 IAP 的价格点）

另外需要注意，基准国家的价格时间表的 `startDate` 和 `endDate`，如果是有多个时间计划表，则一定是需要包含所有的时间段，否则会报错：

```json
{
  "errors" : [ {
    "id" : "8ad9f644-bdb5-4eaf-9029-6b6451b68677",
    "status" : "409",
    "code" : "ENTITY_ERROR.INVALID_INTERVAL",
    "title" : "There is a problem with the request entity",
    "detail" : "Entire timeline must be covered for CHN. Adjacent intervals must not have a gap in between: [null - 2023-04-24T00:00] and [2023-04-25T00:00 - null]",
    "source" : {
      "pointer" : "/data/relationships/manualPrices"
    }
  } ]
}
```

最后，`baseTerritory` 基准国家对应的价格点是必须设置，否则会报错：

```json
{
  "errors" : [ {
    "id" : "4cb1ed03-fea8-467b-a9b0-a563087584f7",
    "status" : "409",
    "code" : "ENTITY_ERROR.BASE_TERRITORY_INTERVAL_REQUIRED",
    "title" : "There is a problem with the request entity",
    "detail" : "There must be at least one manual price for the base territory.",
    "source" : {
      "pointer" : "/data/relationships/manualPrices"
    }
  } ]
}
```

最后，还有一个注意事件，我们这个例子中，基准国家中国大陆（`CHN`）从现在到 `2023-04-25` 使用的 `CNY￥ 2.50` 价格点设置全球均衡价格，从 `2023-04-25` 开始，使用 `CNY￥ 1.00` 价格点设置全球均衡价格。例外的是中国香港，从现在开始一直是手动调整 `自定价格` `HKD $16.00`。但在苹果 ASC 后台展示的价格时间表：

![2023-AppStoreConnectAPI-v2.3-01](https://ihtcboy.com/images/2023-AppStoreConnectAPI-v2.3-01.png)

只有 22 个国家或地区，会跟随 `2023-04-25` 进行自动调整。剩下的 152 个国家或地区，因为基准国家的 `CNY￥ 1.00` 和 `CNY￥ 2.50` 对应的全球均衡价格都是相同的价格点，所以并不会随 `2023-04-25` 进行自动调整。这个需要注意，后续的苹果调价计划，还有外汇汇率或税率调整等因素的影响。

**综上总结**，设定某个 IAP 的价格调整（IAP 级别）的接口，必须遵循的规则：

- 必须设置 `baseTerritory` 基准国家
- 基准国家的价格点时间计划表，必然包含所有的时间段
- 如果是自定价格，则必须一个一个国家的价格点列出，不能批量指定多个国家
- 自定价格的时间计划表，可以只包括一个 `startDate` 或 `endDate`，或者都为空时的全时间段。

#### 2.17 获取某个 app 的销售范围（App 级别）（List availability for an app）

```url
GET https://api.appstoreconnect.apple.com/v1/apps/{id}/appAvailability?include=app,availableTerritories
```

响应示例：

```json
{
    "data": {
        "type": "appAvailabilities",
        "id": "1240856775",
        "attributes": {
            "availableInNewTerritories": true
        },
        "relationships": {
            "app": {
                "data": {
                    "type": "apps",
                    "id": "1240856775"
                }
            },
            "availableTerritories": {
                "meta": {
                    "paging": {
                        "total": 175,
                        "limit": 10
                    }
                },
                "data": [
                    {
                        "type": "territories",
                        "id": "USA"
                    },
                    {
                        "type": "territories",
                        "id": "FRA"
                    },
                ... 省略 ...
                ... 省略 ...
                ]
            }
        }
    },
```

#### 2.18 获取某个 app 的销售范围信息（App 级别）（Read the availability for an app）

```
GET https://api.appstoreconnect.apple.com/v1/appAvailabilities/{id}?include=app,availableTerritories
```

接口响应与上一个接口一样，具体作用是否一样，暂时未发现区别。

#### 2.19 获取某个 app 的销售范围列表（App 级别）(List territory availability for an app)

```url
GET https://api.appstoreconnect.apple.com/v1/appAvailabilities/{id}/availableTerritories
```

响应示例：

```json
{
    "data": [
        {
            "type": "territories",
            "id": "USA",
            "attributes": {
                "currency": "USD"
            },
            "links": {
                "self": "https://api.appstoreconnect.apple.com/v1/territories/USA"
            }
        },
        {
            "type": "territories",
            "id": "FRA",
            "attributes": {
                "currency": "EUR"
            },
            "links": {
                "self": "https://api.appstoreconnect.apple.com/v1/territories/FRA"
            }
        },
                ... 省略 ...
                ... 省略 ...
                ... 省略 ...        
}
```

#### 2.20 修改某个 app 的销售范围（App 级别）（Modify territory availability for an app）

```url
POST https://api.appstoreconnect.apple.com/v1/appAvailabilities
```

请求体：

```json
{
	"data": {
		"type": "appAvailabilities",
		"attributes": {
			"availableInNewTerritories": True
		},
		"relationships": {
			"app": {
				"data": {
					"type": "apps",
					"id": f"{app_id}"
				}
			},
			"availableTerritories": {
				"data": [
					{
						"type": "territories",
						"id": "USA"
					},
					{
						"type": "territories",
						"id": "HKG"
					},
					{
						"type": "territories",
						"id": "CHN"
					}
				]
			}
		}
	}
}
```

这个请求比较简单，把需要销售的国家或地区放到 `availableTerritories` 下的 `data` 数组中就可以，不在 `data` 数组里的国家或地区，就是表示不支持的地区。测试发现，请求成功后，ASC 后台马上生效。

#### 2.21 获取某个 IAP 的销售范围（IAP 级别）(List the territory availablity of an in-app purchase)

```url
GET https://api.appstoreconnect.apple.com/v1/inAppPurchaseAvailabilities/{id}/availableTerritories
```

响应体：

```json

{
    "data": [
        {
            "type": "territories",
            "id": "KOR",
            "attributes": {
                "currency": "KRW"
            },
            "links": {
                "self": "https://api.appstoreconnect.apple.com/v1/territories/KOR"
            }
        },
        {
            "type": "territories",
            "id": "HKG",
            "attributes": {
                "currency": "HKD"
            },
            "links": {
                "self": "https://api.appstoreconnect.apple.com/v1/territories/HKG"
            }
        },
                ... 省略 ...
                ... 省略 ...
                ... 省略 ...
}
```

#### 2.22 获取某个 IAP 的销售范围信息（IAP 级别）（Read the availablity of an in-app purchase）

```url
GET https://api.appstoreconnect.apple.com/v1/inAppPurchaseAvailabilities/{id}?include=availableTerritories
```

响应体：

```json
{
    "data": {
        "type": "inAppPurchaseAvailabilities",
        "id": "6444653105",
        "attributes": {
            "availableInNewTerritories": false
        },
        "relationships": {
            "availableTerritories": {
                "meta": {
                    "paging": {
                        "total": 6,
                        "limit": 10
                    }
                },
                "data": [
                    {
                        "type": "territories",
                        "id": "KOR"
                    },
                ... 省略 ...
                ... 省略 ...
                ],
            }
        }
    },
}
```

#### 2.23 修改某个 IAP 的销售范围（IAP 级别）（Modify the territory availablity of an in-app purchas）

```url
POST https://api.appstoreconnect.apple.com/v1/inAppPurchaseAvailabilities
```

```json
{
	"data": {
		"type": "inAppPurchaseAvailabilities",
		"attributes": {
			"availableInNewTerritories": True
		},
		"relationships": {
			"availableTerritories": {
				"data": [
					{
						"type": "territories",
						"id": "USA"
					},
					{
						"type": "territories",
						"id": "CHN"
					},
					{
						"type": "territories",
						"id": "ISL"
					}
				]
			},
			"inAppPurchase": {
				"data": {
					"id": f"{app_iap_id}",
					"type": "inAppPurchases"
				}
			}
		}
	}
}
```


这个请求比较简单，把需要销售的国家或地区放到 `availableTerritories` 下的 `data` 数组中就可以，不在 `data` 数组里的国家或地区，就是表示不支持的地区。测试发现，请求成功后，ASC 后台马上生效。

#### 2.24 获取某个 subscription IAP 的销售范围（IAP 级别）(List the territory availability of a subscription)

```url
GET https://api.appstoreconnect.apple.com/v1/subscriptionAvailabilities/{id}/availableTerritories
```

#### 2.25 获取某个 subscription IAP 的销售范围信息（IAP 级别）(Read the availability of a subscription)

```url
GET https://api.appstoreconnect.apple.com/v1/subscriptionAvailabilities/{id}?include=availableTerritories,subscription
```

#### 2.26 修改某个 subscription IAP 的销售范围（IAP 级别）(Modify the territory availability of a subscription)

```url
POST https://api.appstoreconnect.apple.com/v1/subscriptionAvailabilities
```

响应体：

```json
{
	"data": {
		"type": "subscriptionAvailabilities",
		"attributes": {
			"availableInNewTerritories": True
		},
		"relationships": {
			"availableTerritories": {
				"data": [
					{
						"type": "territories",
						"id": "USA"
					},
					{
						"type": "territories",
						"id": "CHN"
					},
					{
						"type": "territories",
						"id": "ISL"
					}
				]
			},
			"subscription": {
				"data": {
					"id": f"{app_iap_id}",
					"type": "subscriptions"
				}
			}
		}
	}
}
```

### 三、总结

文中的请求示例是精简后的内容，详细的请求示例（Python 代码实现）和请求响应内容，我们放在 GitHub 仓库 [37iOS/AppStoreConnectAPI-Demo](https://github.com/37iOS/AppStoreConnectAPI-Demo)，后续 API 升级都会一起更新，大家可以自行获取。

关于 API 请求，需要考虑好分页的可能性，未来可能超过 175 个国家地区时的就需要分页，而对于全球均衡价格和自定价格等时间表，有可能超出 200 个价格时间表，所以肯定是需要考虑好分页处理。另外，我们近期会更新苹果派 [AppleParty](https://github.com/37iOS/AppleParty) 以支持批量配置苹果新价格机制，敬请期待~

最后，苹果 App Store Connect API 文档的介绍依然有待提高，了解一个 API 的参数变化，都要重复几百次测试。最后，让我们一起期待 2023 年 6 月苹果 WWDC23 带来更多变化吧~

欢迎大家评论区一起讨论交流~

> 欢迎关注我们，了解更多 iOS 和 Apple 的动态~


### 参考引用

- [App Store Connect API version 2.3 release notes | Apple Developer Documentation](https://developer.apple.com/documentation/appstoreconnectapi/app_store_connect_api_release_notes/app_store_connect_api_version_2_3_release_notes)
- [App Store 新定价机制 - 2023年最全版 - 掘金](https://juejin.cn/post/7213022785366933559)
- [使用 App Store Connect API 批量创建内购商品 - 掘金](https://juejin.cn/post/7181099247956131896)
- [WWDC21 - App Store Server API 实践总结 - 掘金](https://juejin.cn/post/7056976669139009573)
- [设置价格 - 管理 App 定价 - App Store Connect](https://developer.apple.com/cn/help/app-store-connect/manage-app-pricing/set-a-price/)
- [设置 App 内购买项目的价格 - 管理 App 内购买项目 - App Store Connect](https://developer.apple.com/cn/help/app-store-connect/manage-in-app-purchases/set-a-price-for-an-in-app-purchase/)

> 注：如若转载，请注明来源。