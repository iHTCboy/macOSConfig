title: Sign in with Apple 登录详解
date: 2019-09-16 22:49:16
categories: technology #induction life poetry
tags: [Sign-in-with-Apple, 苹果登录方式]  # <!--more-->
reward: true

---

### 1、前言
iOS 13 最大的亮点是 `Dark` 模式，另一个就是苹果登录（Sign in with Apple）方式的增加，让苹果生态又多了一层体验，苹果的生态建设越来越好，让iOS开发者成为 Apple 全栈开发的可能性更接近，对于开发者来说，用好 API ，然后看到苹果这些年对生态的建设，还是有很多想象力！

<!--more-->

### 2、Sign in with Apple
#### 是什么
> “通过 Apple 登录”让用户能用自己的 Apple ID 轻松登录您的 app 和网站。用户不必填写表单、验证电子邮件地址和选择新密码，就可以使用“通过 Apple 登录”设置帐户并立即开始使用您的 app。所有帐户都通过双重认证受到保护，具有极高的安全性，Apple 亦不会跟踪用户在您的 app 或网站中的活动。

新用户首次使用苹果登录授权时，开发者可以要求获得账号名（可要求用户提供什么样的信息，用户名、或邮箱），而对用户来说，用户名可以随便填写，而邮箱可以使用 Apple ID 对应的真实邮箱，或者生成随时的关联苹果账号和此App对应的私密邮箱。（注：此私密邮箱不到直接发送邮件，需要开发者在后台获取密钥通过苹果接口来发送。）


详细见官方文档：[通过 Apple 登录 - Apple Developer](https://developer.apple.com/cn/sign-in-with-apple/)

#### 为什么

对于专门使用第三方或社交登录服务（如 Facebook、谷歌、 Twitter、Linkedln或亚马逊等）在应用中设置或验证用户主要帐户的应用而言，必须向用户提供“以苹果账号登录”服务的选项。
如果满足以下条件，则不需要使用“以苹果账号登录”功能（以下4种情况可以不用苹果登录方式）：
1. 应用仅使用开发者公司自己的账号设置和登录系统；
2. 应用归类为教育、企业或商业应用，要求用户使用现有的教育或企业账号登录；
3. 应用使用政府或行业支持的公民身份识别系统或电子D对用户进行身份验证；
4. 应用是特定第三方服务的客户端，用户需要直接登录其电子邮件、社交媒体或其他第三方账号才能访问内容。

凡是新提交到 App Store 的应用必须遵循上述“以苹果账号登录”指导原则，现有应用则必须在2020年4月之前跟进。

详见审核条款：[App Store Review Guidelines - Apple Developer](https://developer.apple.com/app-store/review/guidelines/#sign-in-with-apple)


#### 做什么
- 登录按钮
登录按钮可以使用苹果推荐的按钮`ASAuthorizationAppleIDButton`。

注意：
* 内置的登录按钮需要放在显眼的位置，没有强调一定要放在首位，但是提出不能让用户滚动后才看到这一个按钮。
* 内置的登录按钮的大小和圆角是可以自行调整的，但是大小有最大和最小的限制。
* 没有强调一定要使用内置的登陆按钮，但是在设计指南上指出最好使用样式相近的设计。
* 使用苹果提供的按钮，这样就不用默认的图片。苹果会根据语言环境切换文字。

苹果登录按钮有所要求, 详细见 [Sign In with Apple - Sign In with Apple - Human Interface Guidelines - Apple Developer](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/)

- 开发证书
主要是证书生成里需要选择苹果登录相关权限

1. 创建 App ID 时，勾选 Sign In with Apple 
![Sign-in-with-Apple-01.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-01.png)

详细注意事件：
1、创建 Apple ID时，描述内容的 Description 会显示在用户的解绑苹果登录的应用名里，所以可能真实游戏名有变动时，需要更新描述，不然在用户手机端显示就很对不上，影响体验。因为使用过苹果登录后，在设置时查看 使用 Apple ID 的 App 时，名字就是上面的 description。


**以下为针对 `服务端验证` 和 `web 端授权登录` 的操作。**

2. 创建 **Services ID**（当服务器端调用 API 来验证用户身份时，这个值也将充当 `cliend_id`。）：
![Sign-in-with-Apple-02.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-02.png)
 ![Sign-in-with-Apple-03.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-03.png)

 单击 “Sign In with Apple” 旁边的 `Configure` 按钮，将显示一个 Web **Authentication Configuration** 面板:
![Sign-in-with-Apple-04.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-04.png)

3. 创建一个密钥，用于获取我们的 `client_secret`，这也是从 Apple 发出令牌请求所必需的。
进入 **Certificates, Identifiers & Profiles** > **Keys**，然后单击 **Keys** 旁边左上角的 + 号:
![Sign-in-with-Apple-05.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-05.png)

单击 `Configure` 出现的 **Configure Key** 面板中，选择我们之前在 **Choose a Primary App ID** 下使用的 App ID，然后单击保存 `Save` ：
![Sign-in-with-Apple-06.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-06.png)

单击 `Continue`，然后在下一页中验证详细信息并单击 `Register` ：
![Sign-in-with-Apple-07.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-07.png)

点击 `Download` 下载密钥并将其保存在安全的地方，因为您永远无法再次下载密钥。下载密钥后单击 `Done` :
![Sign-in-with-Apple-08.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-08.png)

参考文档：
- [About Sign In with Apple - Developer Account Help](https://help.apple.com/developer-account/?lang=en#/devde676e696)
- [快速配置 Sign In with Apple - 掘金](https://juejin.im/post/5d43bd55e51d4561b84c00c8)
- [What the Heck is Sign In with Apple? | Okta Developer](https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple)

#### 服务端验证
与服务器请求验证数据的流程图：
![Sign-in-with-Apple-09.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-09.png)


苹果登录接口返回的参数：

客户端至少要把苹果接口返回的`identityToken`, `authorizationCode`, `userID`这三个参数传给服务器，用于验证本次登录的有效性。

全部参数说明：

| 参数  | 作用  |
|---|---|
|  User ID | 苹果用户唯一标识符，它在同一个开发者账号下的所有 App 下是一样的，我们可以用它来与后台的账号体系绑定起来（类似于微信的OpenID）。
  |
|  identityToken、authorizationCode | 用于传给开发者后台服务器，然后开发者服务器再向苹果的身份验证服务端验证，本次授权登录请求数据的有效性和真实性。其中 identityToken 是一个经过签名的 [JSON Web Token(JWT)](https://link.juejin.im/?target=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FJSON_Web_Token)，详见 [Sign In with Apple REST API](https://developer.apple.com/documentation/signinwithapplerestapi)  |
|  fullName（givenName、familyName）, verified email |  苹果用户信息，包括全名、邮箱等，注意：如果玩家登录时拒绝提供真实的邮箱账号，苹果会生成虚拟的邮箱账号（固定后缀 @privaterelay.appleid.com） |
|  realUserStatus |  用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported（0）、unknown（1）、likelyReal（2） |


注意：
获取的邮箱如果是苹果虚拟邮箱，不能直接发送邮件，需要通过苹果中转服务发送，详细见文档 [Communicating Using the Private Email Relay Service](https://developer.apple.com/documentation/signinwithapplejs/communicating_using_the_private_email_relay_service)


- 与苹果API验证userIdentifier

关于验证的这一步，需要SDK传递授权码给自己的服务端，服务端调用苹果API去校验授权码 [Generate and validate tokens](https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens)。如果验证成功，可以根据userIdentifier判断账号是否已存在，若存在，则返回自己账号系统的登录态，若不存在，则创建一个新的账号，并返回对应的登录状态给App。

针对后端验证苹果提供了两种验证方式：
- 一种是 `基于JWT的算法验证`
- 一种是 `基于授权码的验证`

1、基于JWT的算法验证

针对identityToken后端验证
详细见 [苹果授权登陆后端验证](https://blog.csdn.net/wpf199402076118/article/details/99677412)

一个苹果登录的`identityToken`的JWT示例：

```jwt
eyJraWQiOiJBSURPUEsxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmZ1bi5BcHBsZUxvZ2luIiwiZXhwIjoxNTY4NzIxNzY5LCJpYXQiOjE1Njg3MjExNjksInN1YiI6IjAwMDU4MC4wODdjNTU0ZGNlMzU0NjZmYTg1YzVhNWQ1OTRkNTI4YS4wODAxIiwiY19oYXNoIjoiel9KY0RscFczQjJwN3ExR0Nna1JaUSIsImF1dGhfdGltZSI6MTU2ODcyMTE2OX0.WmSa4LzOzYsdwTqAJ_8mub4Ls3eyFkxZoGLoy-U7DatsTd_JEwAs3_OtV4ucmj6ENT3153iCpYY6vBxSQromOMcXsN74IrUQew24y_zflN2g4yU8ZVvBCbTrR_6p9f2fbeWjZiyNcbPCha0dv45E3vBjyHhmffWnk3vyndBBiwwuqod4pyCZ3UECf6Vu-o7dygKFpMHPS1ma60fEswY5d-_TJAFk1HaiOfFo0XbL6kwqAGvx8HnraIxyd0n8SbBVxV_KDxf15hdotUizJDW7N2XMdOGQpNFJim9SrEeBhn9741LWqkWCgkobcvYBZsrvnUW6jZ87SLi15rvIpq8_fw
```

JWT格式（以.点号分隔）：

- header: 包括了key id 与加密算法
- payload:
    1. iss: 签发机构，苹果
    2. aud: 接收者，目标app
    3. exp: 过期时间
    4. iat: 签发时间
    5. sub: 用户id
    6. c_hash: 一个哈希数列
    7. auth_time: 签名时间
- signature: 用于验证JWT的签名

**header:**
```json
{
  "kid":"AIDOPK1", //密钥id标识
  "alg":"RS256" //RS256算法对JWT进行的签名。（RSA 256 + SHA 256）
}
```

**payload:**
```json
{
    "iss":"https://appleid.apple.com",//签发者
    "aud":"com.fun.AppleLogin",//目标受众
    "exp":1568721769,//过期时间
    "iat":1568721169,//The issued at registered claim key 签发时间
    "sub":"000580.087c554dce35466fa85c5a5d594d528a.0801", //苹果 userid
    "c_hash":"z_JcDlpW3B2p7q1GCgkRZQ", //一个哈希数列，作用未知
    "auth_time":1568721169 //签名时间
}
```

服务端在获取客户端发出的`identityToken`后，需要进行如下步骤：

1. 需要逆向构造过程，decode出JWT的三个部分
2. 从 [https://appleid.apple.com/auth/keys](https://appleid.apple.com/auth/keys) 中获取公钥，并将公钥 [转换](https://8gwifi.org/jwkconvertfunctions.jsp) 为pem对JWT进行验证
3. 如identityToken通过验证，则可以根据其payload中的内容进行验证等操作

**token验证原理：**
> 因为idnetityToken使用非对称加密 RSASSA【RSA签名算法】 和 ECDSA【椭圆曲线数据签名算法】，当验证签名的时候，利用公钥来解密Singature，当解密内容与base64UrlEncode(header) + "." + base64UrlEncode(payload)的内容完全一样的时候，表示验证通过。

**防止中间人攻击原理：**
> 该token是苹果利用私钥生成的一段JWT，并给出公钥我们对token进行验证，由于中间人并没有苹果的私钥，所以它生成出来的token是没有办法利用苹果给出的公钥进行验证的，确保的token的安全性。


2、基于授权码的后端验证

针对 `authorizationCode` 后端验证，首先需要在苹果后台生成的 `client_secret`，不同应用会不一样。所以，建议还是使用第一种验证。

官方文档：
- [Generate and validate tokens - Sign in with Apple REST API | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens)
- [AuthenticationServices | Apple Developer Documentation](https://developer.apple.com/documentation/authenticationservices)
- [Sign in with Apple REST API | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplerestapi)
- [Communicating Using the Private Email Relay Service | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplejs/communicating_using_the_private_email_relay_service)

参考文章：
- [iOS 13 苹果账号登陆与后台验证相关 - 掘金](https://juejin.im/post/5d551d11e51d4561cf15dfae)
- [苹果授权登陆后端验证](https://blog.csdn.net/wpf199402076118/article/details/99677412)
- [使用JWT和Spring Security保护REST API - 掘金](https://juejin.im/post/58c29e0b1b69e6006bce02f4?utm_source=tuicool&utm_medium=referral)


#### App 端
![Sign-in-with-Apple-10.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/09/Sign-in-with-Apple-10.png)

**集成4步：**
1. 设置ASAuthorizationAppleIDButton相关布局，添加相应地授权处理；
2. 获取授权码；
3. 验证；
4. 处理Sign In With Apple授权状态变化；


打开应用或进行登录界面时，处理 Apple ID 登录状态变化。（可能之前登录过，但用户在手机设置里删除了授权认证，需要重新授权）
* authorized: 已认证
* notFound: 用户可能尚未将帐号与Apple ID绑定
* revoked: 账号已经注销

**开发环境：**
- Xcode11 & iOS13（因为使用 iOS13 API ，所以需要升级到 Xcode11 ）
- 更新有苹果登录权限的配置文件，就是 xxx.mobileprovision 文件【
-  项目在 Xcode11 打开后，`Targets` ->  `Signing & Capabilities` 中添加 `Sign In With Apple` 权限。
- 添加系统库 AuthenticationServices.framework

**注意：**
1、首次登录会返回所有参数，二次登录只会返回 UserID 和 授权码，邮件和用户不再返回！！
2、同一个开发者账号下不同的应用，同一个apple id登陆时，获取的 third id 是一样的。
3、两个开发者账号下的应用，同一个apple id登陆时，获取的 third id 不一样
4、NSNotification.Name.ASAuthorizationAppleIDProviderCredentialRevoked， 系统在苹果账号登出时通知，此时应用如果是苹果登陆的用户，有没有必要也登出账号？
5、如果打开登录界面时，设备的 iCloud Keychain 有 apple id 账号可用时，可以弹窗让用户选择 iCloud Keychain 里的账号来进行登陆。


参考文章：
- [Sign in with Apple - 简书](https://www.jianshu.com/p/23b46dea2076)
- [iOS13 Sign In With Apple适配 – 小瑞的Blog](http://jerryliu.org/ios%20programming/iOS13-Sign-With-Apple%E6%96%B0%E7%89%B9%E6%80%A7%E9%80%82%E9%85%8D)

#### Web端
Sign in with Apple 登录是支持跨平台，安卓和 windows 的 web 页面中使用 apple id 登录授权。

官方文档：
- [Sign in with Apple JS | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplejs)
- [Configuring Your Webpage for Sign In with Apple | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplejs/configuring_your_webpage_for_sign_in_with_apple)

参考文章：
- [Sign In with Apple using JavaScript - Techulus - Medium](https://medium.com/techulus/how-to-setup-sign-in-with-apple-9e142ce498d4)
- [What the Heck is Sign In with Apple? | Okta Developer](https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple)


### 注意事项
1. Sign In With Apple 是跨平台的，可以支持iOS、macOS、watchOS、tvOS、JS（web）。
2. Sign In with Apple 需要用户开启了两步认证（双重因子验证），如果没有开启则会在第一次使用时提示开启，不开启将无法使用。未开启两步认证的账号，点击苹果登录时，会弹窗提示用户，需要跳转到系统设置里开启。
3. 开启双重因子验证的方式：
   `设置 -> 密码与安全性 -> 双重因子验证`； 如果不开启双重因子验证，那么当我们在调用苹果官方授权接口的时候，系统也会提示我们需要去打开双重因子验证。
4. 停止App 使用Sign In With Apple 的方式：
   `设置 -> Apple ID -> 密码与安全性 -> 使用您AppleID的App -> 找到对应的App - > “停止以Apple ID使用 Bundle ID...”`；
   注：用户可以关闭接收转发的邮件。
5. 苹果登录的界面只支持竖屏显示，跟内购买弹窗一样，无法控制横屏游戏时显示横屏苹果登录界面。


### 参考

- [通过 Apple 登录 - Apple Developer](https://developer.apple.com/cn/sign-in-with-apple/)
- [App Store Review Guidelines - Apple Developer](https://developer.apple.com/app-store/review/guidelines/#sign-in-with-apple)
- [Sign In with Apple - Sign In with Apple - Human Interface Guidelines - Apple Developer](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/)
- [About Sign In with Apple - Developer Account Help](https://help.apple.com/developer-account/?lang=en#/devde676e696)
- [快速配置 Sign In with Apple - 掘金](https://juejin.im/post/5d43bd55e51d4561b84c00c8)
- [What the Heck is Sign In with Apple? | Okta Developer](https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple)
- [JSON Web Token(JWT)](https://link.juejin.im/?target=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FJSON_Web_Token)
- [Sign In with Apple REST API](https://developer.apple.com/documentation/signinwithapplerestapi)
- [Communicating Using the Private Email Relay Service](https://developer.apple.com/documentation/signinwithapplejs/communicating_using_the_private_email_relay_service)
- [Generate and validate tokens](https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens)
- [苹果授权登陆后端验证](https://blog.csdn.net/wpf199402076118/article/details/99677412)
- [Generate and validate tokens - Sign in with Apple REST API | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens)
- [AuthenticationServices | Apple Developer Documentation](https://developer.apple.com/documentation/authenticationservices)
- [iOS 13 苹果账号登陆与后台验证相关 - 掘金](https://juejin.im/post/5d551d11e51d4561cf15dfae)
- [苹果授权登陆后端验证](https://blog.csdn.net/wpf199402076118/article/details/99677412)
- [使用JWT和Spring Security保护REST API - 掘金](https://juejin.im/post/58c29e0b1b69e6006bce02f4?utm_source=tuicool&utm_medium=referral)
- [Sign in with Apple JS | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplejs)
- [Configuring Your Webpage for Sign In with Apple | Apple Developer Documentation](https://developer.apple.com/documentation/signinwithapplejs/configuring_your_webpage_for_sign_in_with_apple)
- [Sign In with Apple using JavaScript - Techulus - Medium](https://medium.com/techulus/how-to-setup-sign-in-with-apple-9e142ce498d4)
- [What the Heck is Sign In with Apple? | Okta Developer](https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple)

<br>

- 如有不正确的地方，欢迎指导！
- 如有疑问，欢迎在评论区一起讨论！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
<br>


