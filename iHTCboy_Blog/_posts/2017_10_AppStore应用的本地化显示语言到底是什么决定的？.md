title: AppStore 应用的本地化显示语言到底是什么决定的？
date: 2017-10-28 19:04:16
categories: technology #life poetry
tags: [AppStore,Localization,应用本地化语言]  # <!--more-->
reward: true

---
### 本地化 App Store 信息
iTunes Connect 本地化说明：
>在添加 App 至您的帐户之后，您可以添加语言并输入您的 App 在 App Store 中显示的本地化信息。若要查看您可以本地化 App 元数据的语言和语言区列表，请参见 App Store 本地化。若要了解您可以本地化的属性，请参见必填项、可本地化以及可编辑的属性。
>
>例如，**如果主要语言设置为英文，那么该信息在所有 App Store 地区中都会显示为英文。**如果您为您的 App 添加了法文并对文本、关键词和屏幕快照进行了本地化，那么语言设置为法文的用户会看到法文的本地化内容。所在地区支持法文（而非英文）的用户，也会看到法文的本地化内容。用户也可以在所有法语 App Store 中使用本地化关键词搜索到您的 App。在其他 App Store 地区，用户会看到以主要语言显示的信息（本示例中为英文）。
>
>**用户在设备上设置的语言控制 App Store 中显示的本地化内容。** 如果没有与设置语言匹配的可用本地化内容，将显示最接近的本地化内容。如果您需要显示特定语言区的元数据，请在您的 App 中添加特定语言区的语言——例如，添加法文（加拿大）。无论用户设备的语言设置如何，您 App 的 App Store 网址（URL）都是相同的。
>
>您在 iTunes Connect 中添加到 App 中的语言与您在 Xcode 中添加到 App 中的语言不同。您在 Xcode 中添加的语言在 App Store 中的“语言”下显示。若要本地化您 App 的二进制文件，请参阅“Internationalization and Localization Guide（《国际化和本地化指南》）”。
>
>【重要事项】仅当 App 状态为可编辑时，您才可以管理语言。

<!--more-->

### 问题总结
##### 1.主要语言是指什么？有什么作用？
> 如果某个 App Store 地区没有提供本地化的 App 信息，那么 App 信息将以主要语言呈现。如果您没有看到想要使用的支持语言，请参阅 [常见问题](https://itunespartner.apple.com/cn/apps/faq/管理您的%20App_本地化#64875326)。

也就是，在新建App时，苹果要求选择 主要语言（其实就是至少有一种本地化语言）：
![选择 主要语言.png](http://upload-images.jianshu.io/upload_images/99517-fb137425b84f9d90.png?imageMogr2/auto-orient/strip%7CimageView2/2/h/440)

应用创建好后，还可以更改主要语言，前提是有创建了2个以上本地化语言：
![AppStore 主语言.jpg](http://upload-images.jianshu.io/upload_images/99517-06d626524a83d6ea.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

所以，主要语言的作用就是 **作为应用在 AppStore 上显示的主本地化语言**。也就是说，如果应用只支持一种本地化语言，那么在所以 AppStore 上都是显示一样的语言。那么如果有2种本地化语言，又怎么显示呢？

#####  2.如果应用支持2种本地化语言，用户在 AppStore 上会显示那种本地化语言呢？
**假如应用支持 英文(英国)（主要语言）和法文：**
- 用户操作系统中设置本地化的语言为英文，应用支持英文，则显示英文 App Store ;
- 用户操作系统中设置本地化的语言为法文，应用支持法文，则显示法文 App Store ;
- 用户操作系统中设置本地化的语言为中文的中国账号用户，因为在中国地区不支持英文和法文（按苹果支持语言列表查询），则显示主要语言：英文 App Store ;
- 用户操作系统中设置本地化的语言为中文的法国账号用户，因为在法国地区支持法文, 英文（英国）（按苹果支持语言列表查询），则优先显示排前语言：法文 App Store 。（参考下图）

可以得出，
> 应用在 AppStore 显示的本地化语言顺序，如果应用支持用户设备操作系统中设置本地化的语言，那么应用在 AppStore 本地化以操作系统中设置本地化的语言来显示。如果设置本地化的语言不被应用支持，以用户账号所在地区支持的本地化语言为显示，如果支持多种，排序在前为准。如果用户账号所在地区支持的本地化语言不被应用支持，那么以应用设置的主要语言显示。

苹果默认 AppStore 多数地区本地化都支持 英文（英国），加拿大、美国、澳大利亚除外:
![法国支付 法文，英文（英国）.png](http://upload-images.jianshu.io/upload_images/99517-d1ece151c0eebd86.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####  3.我的 app 信息已本地化，它在 App Store 上为什么不以特定的语言显示？
要在 App Store 上看到您的 app 的特定本地化内容，您需要更改 OS X 或 iOS 的语言。

`OS X：`
>
>1. 退出 iTunes
>2. 前往“系统偏好设置”中的“语言与地区”
>3. 添加新的语言，或将所需语言拖放到语言列表的顶部
>4. 打开 iTunes
>5. 点按“iTunes Store”按钮
>6. 滚动到页面底部
>7. 点按页面右侧的当前地区图标
>8. 选取所需的 App Store 的地区
>9. 搜索您的 App，此时应能看到您提供的本地化信息

`iOS：`

>1. 按两次主屏幕按钮，然后将 App Store 扫出屏幕，从而关闭 App Store
>2. 前往“设置”>“通用”>“多语言环境”>“语言”
>3. 轻按所需的语言
>4. 轻按“完成”
>5. 打开 App Store 并滚动到页面底部
>6. 如果已经登录，则轻按您的 Apple ID，然后轻按“注销”
>7. 轻按“登录”
>7. 轻按“创建 Apple ID”
>9. 选取所需的地区并轻按“下一步”
>10. 显示语言将发生变更。如果您不想创建新的 Apple ID，则轻按以新的语言显示的“取消”
>11. 搜索您的 app，此时应能看到您提供的本地化信息
>12. 要查看原始语言的本地化内容，请重复上述步骤，然后用您现有的 Apple ID 登录。


![我的 app 信息已本地化，它在 App Store 上为什么不以特定的语言显示？.png](http://upload-images.jianshu.io/upload_images/99517-6a549aa162f5b541.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 更多参考
- [本地化 App Store 信息 - iTunes Connect 开发人员帮助](https://help.apple.com/itunes-connect/developer/?lang=cn#/deve6f78a8e2)
- [本地化 - iTunes Connect 资源和帮助](https://itunespartner.apple.com/cn/apps/faq/管理您的%20App_本地化#64875326)




<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


