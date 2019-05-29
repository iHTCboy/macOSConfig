title: macOS 使用 Sparkle 检查软件自更新
date: 2019-05-04 14:49:16
categories: technology #induction life poetry
tags: [macOS,Sparkle,GitHubUpdates,软件检查更新]  # <!--more-->
reward: true

---

### 1、前言

其实，本篇文章应该是上一年就打算写的，结果呢，最近才有时间整理。开发 macOS 软件也有一段时间，对于软件更新，之前是自己手动编写增加 API 接口来提示是否有新版本，但一直觉得不智能，界面也不友好，而且下载的是压缩包，需要解压后自动手动替换 App，甚是痛苦。所以，看了很多开源项目，看到了一个 macOS 专用的更新库 `Sparkle`, 然而现有网上的教程，已经非常陈旧，花了点时间才悟，所以，写一个总结吧。另外，也有其它的更新库，大家需要可以自行了解，以主流库为主，维护更好，这也是项目选型考虑的条件之一，也许是强者更强，劣币驱逐良币现象在开源界好像没有发生过~

<!--more-->

### 2、Sparkle
> Sparkle的原理是根据提前配置好的xml文件地址，每次启动后解析xml，看看有没有比当前版本新的数据，有的话提示更新。
> xml文件可以存在任何可以访问xml元数据的服务器，包括 GitHub 仓库。

![20190414-Sparkle.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190414-Sparkle.png)

2.1 使用 Cocopods 在项目中集成：

```
pod 'Sparkle'
```

也可以通过下载源代码进行集成（https://github.com/sparkle-project/Sparkle）。

2.2 配置 storyboard 更新 action

1. 打开 Main.storyboard（如果是很旧的项目则为 MainMenu.xib）
2. 选择 View -> Libraries -> Show Library （快捷键为 `shift + command + L`）
3. 在搜索栏中搜索 Object 并将 Object 拖入左侧跟 `App Delegate` 同级层
4. 选中刚添加的 Object 对象
5. 选择 View -> Inspectors -> Show Identity Inspector（快捷键为 `option + command + 3`）
6. 修改 Custom Class 为 `SUUpdater`
7. 如果需要，可以添加一个检查更新的菜单项，设置它的 target 为刚才的 `SUUpdater` 实例，action 为 `checkForUpdates:`

![20190414-AddObjectToMenu.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190414-AddObjectToMenu.png)

![20190414-SUUpdaterObject.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190414-SUUpdaterObject.png)

![20190414-AddActionToUpdaterObject.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190414-AddActionToUpdaterObject.png)


2.3 数字签名

`Sparkle` 能够下载软件并进行替换，所以为了保证安全，确保全程是软件作者行为，给出了3点建议：

> 由于 Sparkle 正在将可执行代码下载到用户的系统, 因此您必须非常小心安全性。为了让 Sparkle 知道下载的更新没有损坏（修改）, 并且来自您 (而不是恶意攻击者), 我们建议:
> 
> 1、通过 HTTPS 提供更新。
>    除非你遵守 Apple 的应用传输安全要求, 否则你的应用不会在 macos 10.11 或更高版本上 HTTP 请求将被系统拒绝。
> 2、通过 Apple 的开发人员 ID 程序对应用程序进行签名。
> 3、使用 Sparkle 的 EdDSA (ed25519) 签名对已发布的更新存档进行签名。

所以，建议使用 `Sparkle` 的签名认证机制，保证更新的合法性。 需要注意的是，`Sparkle`v1.21 之后使用全新的 EdDSA (ed25519) 签名，而之前的旧版本使用 使用DAS SHA-1 数字签名，则是另一种配置方式。

#### `Sparkle`v1.21 以上配置：

首先，双击运行 `Sparkle/bin/generate_keys` 命令工具，会自动打开终端应用，显示：

```bash
➜  ~ /Users/HTC/Downloads/Sparkle-1.21.3/bin/generate_keys ; exit;
This tool uses macOS Keychain to store the Sparkle private key.
If the Keychain prompts you for permission, please allow it.
OK! Read the existing key saved in the Keychain.

In your app's Info.plist set SUPublicEDKey to:
c6KSLEMfs7YqD5M0FZ8McEUi1x9gGdbXSem2T+lCgjA=
```

**配置 SUPublicEDKey**

注意，这个步骤只要运行一次，然后记录下运行的结果，在 `Info.plist` 增加一个key-value 键值对，`SUPublicEDKey` 对应的公钥(base64 编码的字符串)。

注：这个步骤做了两件事: 
1、生成一个私钥, 并将其保存在登录钥匙串中。您不需要对其执行任何操作, 但不要失去对 Mac 钥匙串的访问权限。如果您丢失了它, 您可能无法发出任何新的更新!
2、打印您的公钥到终端应用程序上显示。

**配置 SUFeedURL**

在 `Info.plist` 添加 `SUFeedURL` 属性字段，其值设置为将应用更新的 URL, 例如https://xxx.com/appcast.xml

appcast.xml 内容：

```xml
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>应用名称</title>
        <description>Most recent changes with links to updates.</description>
        <language>en</language>
        <item>
            <title>Version 1.4.14</title>
            <sparkle:releaseNotesLink>
                http://xxx.com/release-note.html
            </sparkle:releaseNotesLink>
            <pubDate>Wed, 10 Apr 2019 19:58:11 +0000</pubDate>
            <enclosure
                url="https://xxx.com/app.zip"
                sparkle:shortVersionString="1.4.14"
                sparkle:version="2019.05.04"
                length="6605799"
                type="application/octet-stream"
                sparkle:edSignature="MEYCIQCQaUqxcrhhEABlWxk+1At5QSwty+Li8d6Sr3q6jJF1JgIhAOWGpIkYLwXC
                RFfaA8uz34Dy7CXCczpmSyCOQ5+rfOFL"
            />
            <sparkle:minimumSystemVersion>10.11</sparkle:minimumSystemVersion>
        </item>
    </channel>
</rss>
```

`releaseNotesLink`: 更新日志的说明网页，最好是html
`url`: zip压缩包下载地扯
`length`: zip压缩文件大小（字节）
`edSignature`: ed签名

**生成签名**
可以使用`generate_appcast`工具进行应用强制转换时, 将自动生成签名。也可以手动生成签名。


```bash
Sparkle/bin/sign_update path_to_your_update.zip
```

示例：

```bash
➜  ~ /Users/HTC/Downloads/Sparkle-1.21.3/bin/sign_update /Users/HTC/Downloads/Sparkle-1.21.3.zip
sparkle:edSignature="j4Mq6yLPlTb1/lGxGiW6BRsYoWBvPkIKc+ACstG87FJJBtjm5StuC07eT2EU4mRVAB0c9Y7ib36lQI8Zft3rCQ==" length="17748993"
```

生成的 `edSignature` 和 `length` 填写到上面的 `appcast.xml`

这样就可以啦，其中 `appcast.xml` 是需要能通过网络访问，不然无法更新。当然，如果是企业内部使用，部署到内网的服务器就可以。

还有很多配置，只下载不更新、多语言本地化、增量更新等，这里就不说了，大家如果有特殊需要，可以自己看文档配置啊 [Publishing an update - Sparkle: open source software update framework for macOS](https://sparkle-project.org/documentation/publishing/#publishing-an-update)


#### `Sparkle`v1.21 之前旧版本的配置：

如果是 1.21 之前的  `DSA` 签名的SDK，现在更新的SDK，已经放到了bin目录的的下目录 `old_dsa_scripts`

**生成数字签名**
使用 `generate_dsa_keys_macos_10.12_only` 命令生成 dsa_priv.pem（私钥）和dsa_pub.pem（公钥）两个文件。其中私钥千万不能丢，否则将无法签署升级包。

然后，把dsa_pub.pam添加到项目中。

**配置公钥**
在 `Info.plist` 添加 `SUPublicDSAKeyFile` 属性字段，其值设置为 `dsa_pub.pem`  公钥的文件名。

**配置更新信息**
在 `Info.plist` 添加 `SUFeedURL` 属性字段，其值设置为将应用更新的 URL, 例如`https://xxx.com/appcast.xml`，下文有xml文件内容说明，与上面 EdDSA 有一些区别。


**更新版本签名**
把新版本生成的程序打包成zip。因为这个是升级包，因此我们要对升级包进行数字签名。方法很简单：

```bash
Sparkle/bin/old_dsa_scripts/sign_update path_to_your_update.zip ~/.ssh/dsa_priv.pem
```

记录下返回的字符串，这就是升级包的签名。使用填下到 `appcast.xml` 中。

appcast.xml 内容：

```xml
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>应用名称</title>
        <description>Most recent changes with links to updates.</description>
        <language>en</language>
        <item>
            <title>Version 1.4.14</title>
            <sparkle:releaseNotesLink>
                http://xxx.com/release-note.html
            </sparkle:releaseNotesLink>
            <pubDate>Wed, 10 Apr 2019 19:58:11 +0000</pubDate>
            <enclosure
                url="https://xxx.com/app.zip"
                sparkle:shortVersionString="1.4.14"
                sparkle:version="2019.05.04"
                length="6605799"
                type="application/octet-stream"
                sparkle:dsaSignature="MEYCIQCQaUqxcrhhEABlWxk+1At5QSwty+Li8d6Sr3q6jJF1JgIhAOWGpIkYLwXC
                RFfaA8uz34Dy7CXCczpmSyCOQ5+rfOFL"
            />
            <sparkle:minimumSystemVersion>10.11</sparkle:minimumSystemVersion>
        </item>
    </channel>
</rss>
```

`releaseNotesLink`: 更新日志的说明网页，最好是html
`url`: zip压缩包下载地扯
`length`: zip压缩文件大小（字节）
`dsaSignature`: 升级包的数据签名


### 一些问题&坑点

- web服务器
上面说明的 `http://xxx.comappcast.xml ` 更新信息文件，还是 ` http://xxx.com/release-note.html` 更新说明页面，还是应用的zip文件下载链接，都是需要通过服务器进行访问。

这里比较简单的方法，就是上传到 `GitHub` 上，就以访问到文件或链接。

如果是本地调试，也可以利用 macOS 自带的 `python` 创建一个本地的文件服务器：

```python
  python -m SimpleHTTPServer
  或者 
  python -m http.server 
```

示例：

```python
➜  ~ python -m SimpleHTTPServer
Serving HTTP on 0.0.0.0 port 8000 ...
```

然后就可以通过 `http://0.0.0.0:8000` 就能访问电脑的所有文档和文件目录。


- HTTPS

macOS 10.11 起苹果默认开启 App Transport Security ，也就是应用只能访问 HTTPS 的链接，HTTP 的默认不能访问。

建议当然是使用https，如果没有能力部署，也可以在应用的 `Info.plist` 配置允许访问http:

```xml
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
```


- 版本号
注意，版本号是 `shortVersionString`；不是 `version` 字段。但是这2个字段都配置了的话，2个都需要大于旧应用的对应版本号，否则，`Sparkle` 认为没有新版本。

- AppStore版本
如果是上架 AppStore，则不能使用 `Sparkle` ，因为苹果审核禁止检查更新和自动更新，需要更新，要求用户使用 AppStore。

- 编译报错

```
/Users/HTC/Desktop/SparkleDemo-macOS/Pods/Target Support Files/Pods-macOSDemo/Pods-macOSDemo-frameworks.sh: line 104: EXPANDED_CODE_SIGN_IDENTITY: unbound variable
Command PhaseScriptExecution failed with a nonzero exit code
```

在Xcode菜单栏选择 File -> Workspace Setting 就会弹出一个界面，看出 Xcode10 是默认选中的最新的 `New Build System(Default)`，在这个编译系统的环境下，编译脚本一直会报错。把 build system 切换到 `Legacy Build System`，使用旧的编译系统就正常运行。怀疑是新的编译系统，流程有变动，如果有问题，后续在深研。


### 总结

其实，官方文档已经给出了很好的教程。这里写的原因:

其一是，官方的文档比较旧，针对 Xcode10，一些操作已经发生了比较大的变化，对于新入门的苹果开发者，可以比较懵。

其二，对于英文或者想最快的方式入门使用的同学，提供一个最简洁的教程，节省大家的时间，对大家都好的事件，应该做！

其三，对于刚刚入门 macOS 软件开发的同学，可能还不知道有这样优秀的第三方更新软件库，所以，心若所诚，力行心从！


### 参考

- [sparkle-project/Sparkle: A software update framework for macOS](https://github.com/sparkle-project/Sparkle)
- [macmade/GitHubUpdates: Cocoa framework to install application updates from GitHub releases.](https://github.com/macmade/GitHubUpdates)
- [为你的Cocoa应用程序加入更新支持：Sparkle 简介 - CocoaChina](http://www.cocoachina.com/mac/20100920/2111.html)
- [用Sparkle为Cocoa程序增加自动升级 - Cocoa学习](http://cocoa.venj.me/blog/auto-update-apps-with-sparkle/)
- [Documentation - Sparkle: open source software update framework for macOS](https://sparkle-project.org/documentation/)
- [Publishing an update - Sparkle: open source software update framework for macOS](https://sparkle-project.org/documentation/publishing/#publishing-an-update)
- [Upgrading from previous versions of Sparkle - Sparkle: open source software update framework for macOS](https://sparkle-project.org/documentation/upgrading/)
- [两款Mac软件自动升级开源开发框架 - CSDNxck的博客 - CSDN博客](https://blog.csdn.net/CSDNxck/article/details/80006835)
- [Sparkle 1: Setup | Elias's Cave](https://meniny.cn/posts/sparkle_1_setup/)
- [MartianZ! - 使用Sparkle为OS X App添加自动更新功能](http://blog.martianz.cn/article/2012-05-26-use-sparkle-to-set-up-check-update-system)
- [使用 最新版本Sparkle 进行自更新 - weixin_34174322的博客 - CSDN博客](https://blog.csdn.net/weixin_34174322/article/details/88485224)
- [App Translocation](https://lapcatsoftware.com/articles/app-translocation.html)
- [potionfactory/LetsMove: A sample that shows how to move a running Mac application to the /Applications directory](https://github.com/potionfactory/LetsMove/)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



