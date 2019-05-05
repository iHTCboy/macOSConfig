title: 谈一谈 IPA 上传到 App Store Connect 的几种方法
date: 2019-04-07 15:49:16
categories: technology #induction life poetry
tags: [IPA,Xcode,ApplicationLoader,altool,Transporter]  # <!--more-->
reward: true

---

### 1、前言

关于上传 ipa 包到 App Store Connect 的方法，相信有 iOS 开发经验的同学，一定知道完成 App 开发后，一般都是用 Xcode 的 Archive 打包后上传到苹果后台。所以，这个就是今天要写的水文？显示不是吧！答案肯定不是啊，本文将给大家一个相对全面介绍。苹果开发的知识点非常多，官方文档也很多，能够学好学完，不一定人人能够做到。在我的理解，iOS进阶，不是说你必须掌握很高深的技术，而是了解全面的知识，能够做出不一样的产品、体验，这个才是优秀的开发者！

<!--more-->

### 2、Xcode 

利用 Xcode 的 Archive 生成 app 包后，选择 Distribute App ，将 App 通过 Xcode 上传到  App Store Connect 后台，这个就不多说的，iOS 开发都需要经历一下。

![20190407-Xcode-Distribute-App.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190407-Xcode-Distribute-App.png)

### 3、Application Loader
当然，Xcode 这种方式，是需要有源代码情况下，才能上传。所以，就会有没有源代码的情况，怎么上传的情况啦！

Application Loader 就是这样一种方式：

> Application Loader 是一款 Apple 工具能够帮助您将 App 的二进制文件上传至 App Store。
>
>Application Loader 上传速度快、连接稳定并且具备早期验证警告功能。

登陆界面：

![20190407-Application-Loader-Login.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190407-Application-Loader-Login.png)

主界面：

![20190407-Application-Loader-Upload.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190407-Application-Loader-Upload.png)

其实，如果了解 Xcode 历史的同学，会知道现在的 Application Loader App 的功能已经被苹果弱化了，以前还能够批量创建提交内购品项等，现在新版本已经去掉了。另外，以前在苹果开发者官网，有单独的页面，可以下载独立版本的 Application Loader 软件，现在也已经去掉了。

可能的原因，在我看来有几点。第1点是，单独维护这样一个软件，需要人力，因为，如果不依赖于 Xcode，在一台电脑只安装了 Application Loader，那个肯定需要安装 `Command Line Tools` 这个命令行工具，如果是安装 Xcode 默认也带上，如果更新了 Xcode 版，也会跟随升级，所以，维护 Application Loader 软件，不只是单独的一个应用入口，当然，也是因为这个 Application Loader 做了一些早期验证警告：

![20190407-Xcode-Distribute-App.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/04/20190407-Application-Loader-Error.png)

上传 ipa 包时，工具会检查一些要求和内容格式等，如果不符合，就会报错，所以，这些初步的检查报错，也是 Application Loader 需要维护的。

第2点，Application Loader 需要的人并不多，站在开发者环境，大多数开发者负责上传 ipa 包，另外，批量上传内购品项，一定很多人不知道，所以，苹果也去掉了。开发者后台也去掉了，所以，Application Loader 现在是集成在 Xcode 中，说不定，那天就直接去掉。

第3点，越来越多的声音，希望苹果能通过 App Store Connect 后台能直接上传 ipa 包、批量创建内购品项等功能。但根据我观察这几年的 WWDC，苹果对 App Store Connect 后台进行了比较大的改变，2018年就是对 App Store Connect 和 Apple Developer 后台，2个账号体系合并，主线上，还是整个系统性上，对于功能和UI界面上，不知道有没有相关计划。我的猜测，还是有希望的。因为近年来，跨平台开发， React Native/ Weex / Flutter，其实，可以不需要依赖 Xcode、macOS 进行开发，打包上传 ipa 却需要一台 macOS 和 Xcode，有一点不可理解？（当然，也不排除苹果希望大家因此，能多卖出几台 Mac 电脑，也许我的猜测是错的吧，但愿~）

具体关于 Application Loader 使用方法，大家可以看看官方使用文档，已经非常详细，而且这几年，苹果很多文档都已经有翻译中文版本啦！Application Loader 介绍（中文）：https://help.apple.com/itc/apploader/


### 4、altool

> 您可以使用 Application Loader 的命令行工具 altool，验证 App 二进制文件并将其上传至 App Store。

所以，Application Loader 应用界面下，也是基于 altool 命令来处理 ipa 文件。明白了这点，对于命令行就没有什么问题啦。

> 若要在上传之前验证构建版本或将有效构建版本自动上传至 App Store，您可在您的持续集成系统中包含 altool。altool 位于以下文件夹中：
> `Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/`

对于这点，如果有做过自动化打包、上传发布或 shell 脚本命令的同学，应该就知道，我们很多时候，希望自动上传，而不是人工操作UI，一步一傻瓜的操作，这不是程序员的工作方式！所以，用命令行的目的就在这里。需要说明一下，刚才也提到 Application Loader 是有早期验证警告功能，也就是说，可以检查这个 ipa 包的内容或格式，是不是符合苹果的规定和要求。

所以，若要运行 altool，请在命令行指定以下一项操作，可以是检查（`--validate-app`），或者上传（`--upload-app`）操作：

```shell
$ altool --validate-app -f file -u username [-p password] [--output-format xml]
$ altool --upload-app -f file -u username [-p password] [--output-format xml]
```

命令参数说明：

| 参数命令 | 详细说明 |
| --- | --- |
| --validate-app | 您要验证指定的 App。 |
| --upload-app | 您要上传指定的 App。 |
| -f file  | 正在验证或上传的 App 的路径和文件名。 | 
| -u username | 您的用户名。 |
| -p password | 您的用户密码。 |
| --output-format [xml / normal] | 您想让 Application Loader 以结构化的 XML 格式还是非结构化的文本格式返回输出信息。默认情况下，Application Loader 以文本格式返回输出信息。 |

### 5、Transporter

也许，对于一般的开发者来说，`altool` 已经能满足基本的上传 ipa 文件的需求。但是，正好前面说的，如果你需要进行批量创建内购品项，还有其它操作，可能大多数开发者不知道，苹果除了 iOS，还有非常多的服务， iTunes Connect 帐户（图书发行商或音乐提供商）、 iTunes Store、Apple Books，尽管我们中国地区有些服务或者非常少用。

所以，苹果提供 `Transporter` 来处理大量和差异化数据的操作的工具（可以在 macOS、Windows 和 Linux 操作系统上安装和运行 Transporter。）：

>Transporter 是 Apple 基于 Java 的命令行工具，用于进行大量目录交付。您可以使用 Transporter 将预生成的内容以 Store 数据包的形式交付至 iTunes Store、Apple Books 和 App Store。
>
>不论您使用 iTunes Connect 帐户（图书发行商或音乐提供商）、App Store Connect 帐户（App 开发者）或是编码工作室帐户来交付图书、视频、音乐或 App 内容，您都可以使用 Transporter 以确保您的元数据和素材（例如音频、视频、图书和 App 文件）适当地交付至 iTunes Store、Apple Books 或 App Store，并根据 Apple 的规范验证 Store 数据包。

这里，只会介绍用 `Transporter` 命令来上传 ipa 文件，更多的功能和说明，大家可以查看官方文档（中文）：https://help.apple.com/itc/transporteruserguide/

**注意：** 下面命令中的 `iTMSTransporter` 是一个变量名，[【重要事项】](https://help.apple.com/itc/transporteruserguide/#/apdAbeb95d60) 作为一名 App 开发者，您可以在已安装 Xcode 或 Application Loader 的情况下使用 Transporter，或者您也可以手动下载 Transporter。有关如何为 App 开发者安装 Transporter 的信息，[请参见 App 开发者的安装说明](https://help.apple.com/itc/transporteruserguide/#/apdAbeb95d60)。

因为我们默认都安装了 Xcode，所以 `Transporter` 命令，我们引用 Xcode 中的 Application Loader 里的 `iTMSTransporter`, 在 .bash_profile 添加了一个别名，这样可以在任何目录路径调用 `iTMSTransporter` 命令:

```
alias iTMSTransporter='`xcode-select --print-path`/../Applications/Application\ Loader.app/Contents/MacOS/itms/bin/iTMSTransporter' 
```

注： 
- 1、其中 `xcode-select --print-path`： print the path of the active developer directory（打印当前使用的Xcode版本软件的开发人员目录的路径），然后在当前使用的 Xcode 版本对应的 Application Loader 下的 `iTMSTransporter`。
- 2、当然，也可能通过设置全局环境变量来直接使用命令，添加 TRANSPORTER_HOME 环境变量。要添加 TRANSPORTER_HOME 环境变量，请在您的 .bash_profile 中添加以下行：export TRANSPORTER_HOME=<file path to Transporter>。例如，如果您安装了 Xcode，则该行应如下所示：

```
export TRANSPORTER_HOME=`xcode-select --print-path`/../Applications/Application\ Loader.app/Contents/MacOS/itms/bin
```

其中，我们除了刚才说的检查和上传模式外，可能会用于这个命令的几种模式，

- Lookup Metadata 模式

> 检索您之前上传的某个 App 当前的元数据。如果您之前上传的是 .itmsp 数据包且 Apple 在您初次上传后修改了元数据，您需要先检索修改后的元数据，再重新发送元数据更新的数据包。

```shell
iTMSTransporter -m lookupMetadata -u [user] -p [password] -apple_id(-apple_ids) -destination [output_path]
```

- Provider 模式

> 确定您有权限为哪些帐户交付内容。

```
iTMSTransporter -m provider -u [user] -p [password]
```

- Verify 模式

> 验证您的 .itmsp 数据包，并在交付前确保元数据和素材符合技术要求，以保证上传数据包前解决任何潜在的问题。

```
iTMSTransporter -m verify -u [user] -p [password] -f [itmsp_path] [-vp <text | json>]
```

- Upload 模式

> 检查您的素材和 .itmsp 数据包，验证它们是否准备就绪以供交付，然后向 App Store 上传内容和元数据。

```
iTMSTransporter -m upload -u [user] -p [password] -f [itmsp_path]
```

关于这些模式的参数，苹果文档有非常详细的说明，虽然需要花一点的脑子去理解（文档真的很~），好了。下面简单说明一下，上传命令怎么使用吧


- 上传 ipa 示例：


```shell
iTMSTransporter -m upload -u xxx@xxx.com -p xxx -f /Users/HTC/Desktop/Upload.itmsp
```

`xxx@xxx.com` ：App Store Connect 账号
`xxx` ：App Store Connect 账号的密码
`/Users/HTC/Desktop/Upload.itmsp` ：这个一个目录，`Upload.itmsp` 是一个文件夹名字，不是文件，里面包含2个文件，一个就是要上传的 ipa 文件，另一个是一个 xml ，描述这个 ipa 文件的信息。

ipa_metadata.xml：

```
<?xml version="1.0" encoding="UTF-8"?>
<package version="software5.10" xmlns="http://apple.com/itunes/importer">
  <software_assets apple_id="{apple_id}" app_platform="{app_platform}">
    <asset type="{archive_type}">
      <data_file>
        <size>{file_size}</size>
        <file_name>{file_name}</file_name>
        <checksum type="md5">{file_md5}</checksum>
      </data_file>
    </asset>
  </software_assets>
</package>
```

需要修改 xml 中的一些参数：

`{apple_id}` ：这个 ipa 文件对应的app的 apple id
`{app_platform}` ： app的平台，填写`ios`
`{archive_type}` ：归档类型，填写`bundle`
`{file_size}` ：ipa 文件的大小
`{file_name}` ：ipa 文件的名字
`{file_md5}`： ipa 文件的md5值


- 一些重要参数说明：

|  参数 | 说明 |
| --- | --- |
|  -itc_provider <shortname> | 检查和上传时建议加子账号的团队id，但测试发现不用 也行，先不带，因为获取很麻烦 |
| -errorLogs <path> | 存储错误日志的目录 |
| -loghistory <path>  | 记录成功上传的数据包 |
| -outputFormat xml | 以 XML 格式返回输出信息 |
| -throughput     | 显示成功上传数据包的总传输时间以及数据包大小和每秒字节数 |
| [-o <output>]     | 记录输出信息 |
| [-v <verbosity>]  | 日志级别，默认eXtreme，详细 |
| -vp <text / json> | 在验证或上传数据包文件时显示进度信息 |
| [-Xmx4096m]     | 指定 4 GB  Java 虚拟机 (JVM) 堆栈内存  |


### 总结

最后，这就是几种上传ipa包的方法，当然，如果经验丰富的开发者，可能使用过 `fastlane` 、`shenzhen` 这样的自动化工具命令，也是可以上传 ipa 文件，如果你研究过它们的源代码，你就会发现，他们使用的命令就是 `iTMSTransporter`，这也正是，我想写这篇文章的原因。现在大家在开发过程中，一直想提升自己，想进阶，想成为高手，然而找不到途径？我希望，大家不要忽视开发过程的每一个重要的环节，这就是进阶的途径！愿大家都能感悟达到~

最后的最后，想说一下最近不怎么更新博客的原因？除了比较忙外（什么时候闲！），写好一篇文章，需要去考查相关的资料和知识，对每一行文字，都要精斟细酌，因为当我看到博客的访问量越来越多人时，为了不误导大家，所以需要承担的责任感觉也大了。这也是写文章的好处吧，除了整理思维，体系构建，表达自己，还有分享，责任，担当中国IT技术传承的一份子，安乐~

finally，五一快乐！致敬劳动者！


### 参考
- [Xcode Help](https://help.apple.com/xcode/mac/current/)
- [使用 Application Loader](https://help.apple.com/itc/apploader/#/)
- [通过 altool 上传 App 的二进制文件 - 使用 Application Loader](https://help.apple.com/itc/apploader/#/apdATD1E53-D1E1A1303-D1E53A1126)
- [Transporter 是什么？ - Transporter 用户指南 1.13](https://help.apple.com/itc/transporteruserguide/#/itc0d5b535bf)
- [Podcasts Connect 概览 - Podcasts Connect 帮助](https://help.apple.com/itc/podcasts_connect/#/itcc0e1eaa94)
- [支持的格式 - 使用 Application Loader](https://help.apple.com/itc/apploader/#/apdATD1E887-D1E1A1303-D1E887A1126)
- [How use iTMSTransporter?](https://stackoverflow.com/questions/16582119/how-use-itmstransporter)
- [GitHub - fastlane](https://github.com/fastlane/fastlane)
- [fastlane deliver 上传app到App Store](https://docs.fastlane.tools/actions/deliver/)
- [GitHub - shenzhen](https://github.com/nomad/shenzhen/blob/master/lib/shenzhen/plugins/itunesconnect.rb)


<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



