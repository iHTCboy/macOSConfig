title: Apple Silicon(苹果芯片)从 DTK 到 M1 Mac 的入门总结
date: 2020-12-06 15:49:16
categories: technology #induction life poetry
tags: [DTK,Apple Silicon,ARM,Mac,M1]  # <!--more-->
reward: true

---


### 1、前言
> Apple 宣布 Mac 采用 Apple 芯片的转移计划

2020 年 06 月 22 日 `WWDC20`（苹果全球开发者大会）苹果宣布将会推出基于 ARM 架构自研处理器的 Mac，未来转向使用 `Apple Silicon` 的 Mac。苹果表示：开发者可以轻松将现有的 app 转换为基于 Apple 芯片运行，从而充分利用其强大的技术和性能。此外，开发者将首次可以在不做任何修改的情况下，**直接将其 iOS 和 iPadOS app 带到 Mac 上。**

为了帮助开发者着手采用 Apple 芯片，Apple 还将推出 `Universal App Quick Start` 项目，提供各种文档、论坛支持、测试版 macOS Big Sur 和 Xcode 12，以及限定使用的 `Developer Transition Kit` (`DTK`)，即基于 Apple A12Z 仿生片上系统 (SoC) 的一款 Mac 开发系统。

<!--more-->

### 2、入门

#### Apple Silicon（苹果芯片）

> Apple 于 1984 年推出 Macintosh，为个人技术带来了巨大变革。今天，Apple 凭借 iPhone、iPad、Mac、Apple Watch 和 Apple TV 引领全球创新。Apple 的五个软件平台，iOS、iPadOS、macOS、watchOS 和 tvOS，带来所有 Apple 设备之间的顺畅使用体验，同时以 App Store、Apple Music、Apple Pay 和 iCloud 等突破性服务赋予人们更大的能力。Apple 的 100,000 名员工致力于打造全球顶尖的产品，并让世界更加美好。

为什么苹果会从 Intel 芯片的 Mac 转移到 Apple 芯片？

本文就不去分析 Intel 的问题，就看看 ARM 架构的 Apple 芯片，苹果带来的改变:

1. Mac SoC 产品系列将带来强大的新功能和卓越的性能；
2. Universal 2 可以轻松地创建一款兼容 Intel 芯片和 ARM 芯片 app；
3. Rosetta 2 的转译技术，用户将能够运行尚未更新的现有 Mac app；
4. 利用虚拟化技术，用户则能够运行 Linux（目前证明 Windows 也可以）；
5. 开发者无需进行任何修改，即可直接将其 iOS 和 iPadOS app 带到 Mac 上。

从以上特点，可以看出，依赖 macOS Big Sur 系统，以确保流畅无缝地过渡至 Apple 芯片，Apple Silicon SoC 芯片带来性能更强劲的图形处理器、神经网络引擎，建立一个跨所有 Apple 产品的通用架构，大大降低开发者为整个 Apple 生态系统编写和优化软件的难度。

![1.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c6cadeea951e4bc1a8d457e36e1bb8c1~tplv-k3u1fbpfcp-zoom-1.image)

对于苹果开发者来说，苹果生态系统，完成了 iOS 、iPadOS 、 watchOS 、 tvOS 、macOS 的统一！虽然目前依然困难重重，但是，大家已经看到了未来的样子，也许就是这个样子！


> CPU，GPU 和 T2 这三个芯片太过分散，且架构不同，直接后果是互相之间能交流的信息有限。那有没有更好的解决方案，让它们能协同起来做事，被统一调度，在同一时间内能一起处理共有信息？答案是有的，这个方案叫做 SoC 片上系统，也就是手机芯片用了十来年的技术。
> 引用来源： [为什么 ARM 版 Mac 运行效率很高？ - 少数派](https://sspai.com/post/61274)


#### Universal App Quick Start（通用应用快速启动）
为了第一时间体验这个 Developer Transition Kit (`DTK`) ，楼主申请加入了 `Universal App Quick Start` 项目。

Quick Start 项目计划条款如下：

1. 可提供各种文档、论坛支持、测试版 macOS Big Sur 和 Xcode 12，并包括限定使用的 DTK；
2. 开发者可构建并测试自己的 Universal 2 app；
3. DTK 由内置 Apple A12Z 仿生 SoC 的 Mac mini 组成（包括 16GB 内存、512GB 固态硬盘和多种 Mac I/O 端口）；
4. 项目结束时须将 DTK 归还给 Apple（DTK被严格限定为一个租赁物品而非销售给开发者）；
5. 项目总费用为：500 美元（ **人民币 3699**）

备注：**通用应用程序快速启动计划条款和条件**：[Universal App Quick Start Program terms and conditions](https://developer.apple.com/terms/universal-app-quick-start-program/Developer-Universal-App-Quick-Start-Program.pdf)

![2.jpeg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b513455a375f45c5a5a374bcd26c55cf~tplv-k3u1fbpfcp-zoom-1.image)


##### 到底值不值

当时，大家关注最多的就是费用，开发者支付 $500 获得的是 DTK 的有限使用权，相当于是从苹果租借，而非购买！用完了还得还回去！

所以，到底值不值？￥3699/1年，大概是 ￥10/1天，然后网上就有人翻出了有趣的历史：

> 在2005年苹果上一次从 PowerPC 架构转向英特尔 x86 的时候，也推出过一台 DTK，是用当时的 Power Mac G5 电脑改装来的。开发者返还苹果DTK后，苹果给了一台 iMac 。

所以，在2020年的DTK归还后，苹果还会送一台新的 ARM Mac 给开发者吗？

为了探索当年到底是怎么样，在维基百科找到了答案：

> 开发人员实际上从苹果租用了999美元的硬件(DTK)，为期约18个月。苹果要求开发人员计划在2006年12月31日一周内将系统退还给苹果。

![3.jpg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a809e9ee3dcb463798935175e7f93d5d~tplv-k3u1fbpfcp-zoom-1.image)

![4.jpeg](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fe91f3b513ca473aa9c97415057fba9b~tplv-k3u1fbpfcp-zoom-1.image)


2005 年 6 月份，苹果公司宣布他们将会在一年之内，让旗下的 Mac 设备从 PowerPC 过渡到 Intel CPU，这条消息震惊了整个 Mac 行业。而 2006 年 1 月份的 Macworld Expo 上苹果公司推出了他们的第一款 Intel Mac。苹果过渡的速度之快令很多人倍感意外。（而 ARM Mac 第一款 M1 Mac，在11月就推出来，比2015年还快了，说明苹果这次准备的时间可能往前推几年吧！）

2006年1月10日，苹果推出了一部配备英特尔处理器的 iMac 电脑，iMac 价格从 1299 美元起。并推出一部配备英特尔处理器，并代替 PowerBook 的专业型笔记本电脑，新电脑名为 MacBook Pro。 

所以，今年的 DTK，明年开发者归回时，苹果会给开发者一台 ARM 的 Mac mini 吗？

| 对比  |  2005   |   2020  |
|:---:|:---:|:---:|
|  DTK   |  Power Mac G5 (3.6 GHz Pentium 4)   | Mac mini (Apple A12Z Bionic)  |
| 租期 | 2006年12月31日后一星期内 | 一年(收货开始) 到期后30天内 |
|  费用   |  $999   |  $500 |
|  新产品   | Intel iMac ($1299） |  M1 Mac mini ($699) |


其实，我们可能比较纠结，当然，楼主写本文时，苹果已经停止了 DTK 的申请计划。所以，我找到了2005年第一代 DTK 发布时，乔布斯的解读：

> 在2005年的WWDC上，苹果CEO 史蒂夫·乔布斯：强调这一原型硬件并没有任何商业发售计划，称：“这只是个开发平台（Apple Development Platform），它不是个产品也永远不会被当成产品来卖。我们只是让你们拿它来尽快开始开发。实际上你们要在2006年年底前把它还给我们。我们不想让这东西满地都是。这东西不是个产品。”

所以，DTK 不是产品！只是开发者工具~

答案，大家可以期待一下吧！2005是乔帮主作主，如今现在的苹果公司一直不差钱，明年就看库克的表现啦！


##### 到底保密严格

苹果在 [通用应用程序快速启动计划的条款](https://developer.apple.com/terms/universal-app-quick-start-program/Developer-Universal-App-Quick-Start-Program.pdf) 中加入了**严格的保密规定**和各种各样字面上颇为夸张的限制。附加了包括禁止拆解、禁止做性能跑分测试和禁止用于非开发用途等的条款。

> 2. Licenses and Restrictions
> 2.2 No Other Permitted Uses
> 
> 您（和您的授权开发人员）只能出于本附录明确允许的目的和方式并根据文档使用开发人员转换套件。您同意您和您的授权开发人员均不会：
> （a）对开发人员转换套件或其任何部分进行任何更改或更改； 
> （b）全部或部分反编译，反向工程，解密或反汇编Developer Transition Kit，或者尝试全部或部分反汇编Developer Transition Kit，或衍生（或尝试衍生）源代码或以其他方式将Developer Transition Kit的软件部分简化为人类可理解的形式（除非且仅在适用法律禁止上述限制的范围内，或在许可条款允许的范围内，否则）规范任何此类软件随附的开源组件的使用）； 
> （c）复制，修改或创建以下内容的衍生作品： 开发人员过渡套件或其任何部分； 
> （d）在开发人员过渡工具包上显示，演示，视频，照片，对开发人员过渡工具包进行任何绘图或渲染，或对其进行任何图像或测量，或进行任何基准测试（或允许其他任何人进行上述任何一项操作），除非另外苹果公司书面授权； 
> （e）讨论，公开撰写或发布有关开发人员迁移工具包（或您对开发人员迁移工具包的使用）的任何反应，无论是在线，书面，亲自还是在社交媒体上进行，除非另行书面授权苹果公司； 
> （f）租金，租赁，贷款，出售，转让，再许可，分发，转让或以其他方式分享（第2.1节所允许的给您的授权开发人员除外），或允许在开发人员转换套件中放置任何留置权； 
> （g）未经苹果事先书面同意，将开发者迁移工具包从其原始交付国家转移到该国家；
> （h）或导出，重新导出或导入开发人员转换套件（或任何部分）。 


所以，刚开始几个月时，楼主也不敢透漏太多的内容，现在2020年12月了，苹果 [M1 Mac - Apple](https://www.apple.com.cn/mac/) 已经开售，相对来说，这些保密规定就意义不大了。所以，这也是楼主写本文的一个意义，让更多的人关注苹果平台，为苹果开发者创造更多的价值，与苹果的开发者理念是一致的，有冲突但是有意义。


#### DTK（Developer Transition Kit）

DTK（Developer Transition Kit，开发人员过渡工具包）

| 技术规格  |   |
|:---:|:---:|
| 处理器	  |  Apple A12Z Bionic |
| 内存 |  16GB |
| 硬盘 |  512GB SSD |
| I/O |  Two USB-C ports (up to 10 Gbps) <br>Two USB-A ports (up to 5 Gbps)<br>HDMI 2.0 port |
| 网络 | 802.11ac Wi-Fi<br>Bluetooth 5.0（蓝牙5.0）<br>Gigabit Ethernet（千兆以太网）  |
| 租费  | $500/年  |


![5.JPG](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7cc1619f6a1c48c599148c7184626144~tplv-k3u1fbpfcp-zoom-1.image)

DTK 与普通的 Intel Mac mini 的包装是一样的，外形区别不大。特别有趣的是，打开包装说明书正面写着：

“The future of Mac is yours to write”（你来书写 Mac 的未来！）
![6.JPG](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4f49680feb744fc8b9df8371232a5c70~tplv-k3u1fbpfcp-zoom-1.image)


包装盒里面有一张字条写着：

“Congratulations on being one of the first developers for Mac powered by Apple silicon.”（祝贺您成为首批Apple芯片的Mac开发者）

![7.JPG](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/13b0cb2e833a49e48a7b0918911014a7~tplv-k3u1fbpfcp-zoom-1.image)

说实话，简简单单几个字，非常的打动人心~

#### Mac 环境兼容
一个新架构的系统，首先要看的就是兼容性，虽然前面提到 Rosetta 2 的转译技术，但是因为是转译，所以不是所有的指令都兼容或者转换成功，比如内核扩展、x86_64虚拟化指令等。对于不兼容的app，可以使用 Rosetta 2转译，详细可以看看苹果文档：[About the Rosetta Translation Environment | Apple Developer Documentation](https://developer.apple.com/documentation/apple_silicon/about_the_rosetta_translation_environment)。

![8.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2e78cc47061e4d79ba19e70761a09bb6~tplv-k3u1fbpfcp-zoom-1.image)


在 ARM 版的 Mac 上，软件有如下运作方式：

1. 所有 Apple 自家应用，包括系统本身以 ARM 原生模式运行，无任何性能折损；
2. 所有 iOS 和 iPadOS 应用，以 ARM 原生模式运行，无任何性能折损；
3. 所有 Catalyst 应用，需重新编译为 Universal 应用，无任何性能折损；
4. 所有虚拟机应用，运行在 Big Sur 提供的虚拟机环境下；

x86-64 软件运作方式：
* 所有 32 位 x86 应用，已在三年前被 Apple 淘汰，无法运行；
* 所有 64 位 x86 应用，若以应用商店分发，则下载的便是已翻译版本；
* 所有 64 位 x86 应用，若在网络上下载安装，则在安装时翻译；
* 所有 64 位 x86 应用，若以拖拽形式安装，则在首次运行时翻译。

> 以上引用来源：[为什么 ARM 版 Mac 运行效率很高？ - 少数派](https://sspai.com/post/61274)

在 GitHub 上有一个项目：[ThatGuySam/doesitarm](https://github.com/ThatGuySam/doesitarm) 是一个 Apple Silicon 芯片架构的兼容情况的 app 列表，展示了原生兼容、Rosetta 2转译、不兼容但开发中，暂未计划等状态。

![9.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/457d567358c74b53a6425369d7f12211~tplv-k3u1fbpfcp-zoom-1.image)


##### 到底过渡多久

那么，大家可能关注的另一个问题，**Intel Mac 的系统支持更新还能多久？**

苹果表示，未来会继续支持 Intel Mac 的更新维护，但目前没有给出一个具体的时间节点。我们可以参考2005年 Mac 电脑从 PowerPC 转为 x86 架构，用了6年时间：

* 2005年的 Mac OS X 10.4版（Tiger）同时有 PowerPC 和 Intel 两个版
* 2011年的 Mac OS X 10.7 （Lion）才不再支持 PowerPC。

所以，这次从 x86 转为 ARM 架构，估计也需要同样长的时间，大约 5~6 年。


另外，我想很多人一定会问，“我现在适合购买 M1 Mac 吗” ？

- 如果你现在已经有 Mac 电脑，暂时建议 2021年6月后在考虑吧，至少1年时间，到时候，大多数软件都兼容了，迁移才是真的生产力工具！否则，现在就是买一个玩具不断折腾的过程~
- 如果你之前没有使用过 Mac 电脑，那么可以购买啊，现在兼容 iOS/iPadOS 的app，需要是兼容性不太好，但是性价比是比 Intel Mac 高！
- 如果你是开发者且之前没有用过 Mac 电脑，那建议你等等！现在入手 M1 ，开发软件兼容性是一个头痛的问题。虽然从可参考历史上，Intel Mac的 macOS 系统还可以支持更新5代左右，如果入手 Intel Mac，有点像 49 年入国民d（*个人感受，不喜勿喷*）。


####  安装 iOS / iPadOS app
最初在 macOS Big Sur 11.0 beta 10 之前，只需要将 iOS 应用经过砸壳、关SIP、关AMFI、重签名之后能直接运行。

具体步骤：

1. 关闭 **SIP**
2. 关闭 **AMFI**（终端输入：`sudo nvram boot-args="amfi_get_out_of_my_way=1"`，然后重启以生效）
3. 在 DTK 上安装开发证书，然后用 `codesign` 命令重签


重签的脚本：
```bash
#!/bin/sh

codesign -d --entitlements :- "$1" > temp.xcent
codesign -f -s "Apple Development: xxx (xxx)" --entitlements temp.xcent "$1"/Frameworks/*
codesign -f -s "Apple Development: xxx (xxx)" --entitlements temp.xcent "$1"
```

判断是否砸壳的脚本：
```bash
#!/bin/sh

# cryptid 0（砸壳） 1（未砸壳）
otool -l "$1" | grep crypt 
```

常规的关闭 `SIP` 的步骤：
```bash
1. 进入 recovery 模式
2. 选择左上角的 “苹果图标” —— “Startup Disk” —— “System” —— “Security Policy” —— “Reduced Security && Allow kernel extensions from identified developers”
3. 退出启动磁盘，在Utilities选项卡中选择Terminal
4. 输入：csrutil disable
5. 重启电脑
```

而 DTK 关闭 `SIP` 的步骤有所不同：
```base
1. 进入 recovery 模式
2. 选择 “硬盘” 图标
3. 选择 “Security Policy”（安全策略） -- “Reduced Security”（降低安全性） -- “Allow kernel extensions from identified developers”（允许用户管理来自被认可开发者的内核扩展）
4. 然后退出，返回 recovery 模式
5. 选择 “选项” 图标
6. 选择 Terminal
7. 输入：csrutil disable
8. 重启电脑
```

注：关于 `SIP` 详细的内容可自行搜索，`$1` 就是 ipa 解压后的 app 目录。


**在 macOS Big Sur 11 beta 10 上无法运行用上面的方法直接运行 iOS app 了**
打开提示：
![10.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/616b8a94e5304a5bbf31e7d9c2b2e132~tplv-k3u1fbpfcp-zoom-1.image)

重签的 app 都显示禁止了：
![11.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1cfd10f85cd44193971110265afc31bc~tplv-k3u1fbpfcp-zoom-1.image)

日志输出：

```bash
LAUNCH:Application cannot be launched because its unsupported bit is set, com.facebook.Facebook node=<private> status=-10661

handle LS launch error: {\n    Action = oapp;\n    AppPath = "/Users/iHTCboy/Downloads/iOSApp/Facebook.app";\n    ErrorCode = "-10661";\
```

解决方法：
需要把ARM Mac的 uuid 添加到开发者证书中，用包含此 Mac uuid 的证书重签ipa文件，然后双击ipa文件系统就会自动安装，然后在自动添加到 Applications 里，可以直接打开 app。

Mac uuid 位置：

![12.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/411399d722614eed9f83ea675f8c612a~tplv-k3u1fbpfcp-zoom-1.image)

双击 ipa 文件安装：

![13.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/91e9f613cb6745dca3ab262ea18965b1~tplv-k3u1fbpfcp-zoom-1.image)

如果重签后证书不正常也会提示：

![14.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b7bee27c8a954169991bb5a9fb561a7d~tplv-k3u1fbpfcp-zoom-1.image)


安装成功：

![15.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f8f4b0fd1ce14626acf980fafc187239~tplv-k3u1fbpfcp-zoom-1.image)


#### 运行 iOS / iPadOS app
iOS app 可以在 macOS 上原生运行，这个对于 macOS 生态来说非常的重要和兴奋！因为 macOS 一直以来的 app 质量高，但是数量一直都没有大的提高。所以，这次 ARM Mac，对于苹果和用户来说，都是双赢的局面！

运行 iOS app，基本上UI兼容上没有问题，因为支持 iPadOS 的话，其实，在 macOS 上，可以理解为更大屏幕的 iPad 吧了！

楼主录了一个在 DTK 上用鼠标玩王者荣耀的视频： [DTK 苹果芯片 Arm Apple Silicon Mac mini 试玩王者荣耀游戏 - bilibili](https://www.bilibili.com/video/BV1SZ4y1G7UE)。从视频可以看出来，因为手游一般是双手操作，所以鼠标上多点触按是无法实现的，就是图一个新鲜感吧。

运行王者：
![16.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/33db9ad6c16f4d3e883e27cbc7cd2e8b~tplv-k3u1fbpfcp-zoom-1.image)

运行多个应用并不会卡顿，因为都是原生运行：
![17.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e6f87dae5bff497aab98d34deb0e90cb~tplv-k3u1fbpfcp-zoom-1.image)

抖音：

![18.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8dd0fbbf096d4504a7e0d85821399a8e~tplv-k3u1fbpfcp-zoom-1.image)

特别有意义的是，TikTok 可以正常打开，在 iPhone 是无法正常访问的。说明识别 DTK 时获取不到一些物理关键信息，导致无法直接屏蔽。所以，DTK 导致的安全问题不容忽视！
![19.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8f3ea7ff5c00448fb425d190d16f5950~tplv-k3u1fbpfcp-watermark.image)


微信读书：

![20.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/31682b41197f46f79b67e11dd9d29b8a~tplv-k3u1fbpfcp-zoom-1.image)

所以，对于交互少的 iOS app，体验感与 iPhone 上感觉差别不大，就是一个大屏幕的iPhone，比如视频app、读书app，无缝对接，这也许就是苹果生态，未来的优势！


最后，以微信 iOS 版本，来了解一下具体的体验：

打开会显示 for iPad 的界面，因为屏幕变大了，完全不是 iPhone 的尺寸：

![21.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e12a3e8187a3417a97dc7e1f91a9da7b~tplv-k3u1fbpfcp-zoom-1.image)

首页界面：

![22.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cbe90e01ff7c4cd881c634dd1f3f561f~tplv-k3u1fbpfcp-zoom-1.image)

朋友圈界面：

![23.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1a48cb946f844be48e7523381b69ed20~tplv-k3u1fbpfcp-zoom-1.image)

访问相册权限时：

![24.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9499d4f312e84417ba7effc38ea43c9e~tplv-k3u1fbpfcp-zoom-1.image)

访问相机权限时：

![25.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2266eed3f74546ecadfb73c424132abb~tplv-k3u1fbpfcp-zoom-1.image)

发朋友圈：

![26.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4803367fec824e348944ce45d7ddf18f~tplv-k3u1fbpfcp-zoom-1.image)

也能打开小程序，目前bug比较多，部分页面会闪退：

![27.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/17a7f370ac1943d691344fba1f086d64~tplv-k3u1fbpfcp-zoom-1.image)


微信读书体验还是非常顺畅的：

![28.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8f7cd0093d5f4c3bb8ff8cecedd8f33a~tplv-k3u1fbpfcp-zoom-1.image)

最后，通过 UTM 虚拟机启动的 Windows XP 系统，目前还是非常卡顿，期待未来优化，相信可以做到的！：

![29.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4bc33ad77b9a4aee82810296210f6bb7~tplv-k3u1fbpfcp-zoom-1.image)


#### iOS / iPadOS app 原理和安全性

那么，除了 ARM 架构，运行 iOS app 必须是需要系统层级的支持，macOS Big Sur 风格与 iOS 雷同化，所以 iOS app 运行在 macOS 上并不会显得突兀，提示框或UI保持了一致，比如经典的 Mac 图标，现在都开始变成圆角图标。

![30.JPG](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5a86a9cb2b2c4ae7ba3b7f2ceb94749d~tplv-k3u1fbpfcp-zoom-1.image)


macOS提供了 iOS 运行时需要的内核环境和运行时框架，在系统目录下：

```bash
/System/iOSSupport/System/Library/Frameworks/
```

![31.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8a5d3df2d910442499b9b59b1cce347a~tplv-k3u1fbpfcp-watermark.image)


而 iOS app 安全保障的沙盒环境，在 macOS 下则是完全暴露，目前苹果并没有对 iOS app 沙盒目录进行加密或者保护，普通用户权限就可以随意访问 iOS app 的目录，对于 iOS app 来说，如果已经上架，或者未来上架 Mac 平台，建议对沙盒目录的内容和文件做好加密，避免用户的数据泄露，安全风险增加等问题。

iOS app 沙盒目录：
```bash
~/Library/Containers/
```

![32.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a53e81f360e146198bcc126f17d7f205~tplv-k3u1fbpfcp-watermark.image)

DTK 最初的app沙盒目录是直接用app的名字：

![33.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f73719fbf58848d29164aba79a19d934~tplv-k3u1fbpfcp-watermark.image)

Big Sub 10.1 beta 10 和后续的正式版本，改回与 iPhone 一样的目录 id 名字：

![34.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4ca4c1dff3d948ed9f20a245255ab1ac~tplv-k3u1fbpfcp-watermark.image)


另外，macOS 支持 iOS app 的 Scheme 调用，王者荣耀的微信登陆授权，可以跳到 iOS 微信 app授权，所以，可以说苹果把 iOS 整个系统直接搬到了 macOS，未来是不是还会调整，需要市场来验证。

对于苹果生态的开发者来说，除了生态更加完善，可以直接 macOS 运行 iOS app，不用在像以前那样支持 i386/x86 框架的模拟器外，更需要关注安全问题。iOS 以前因为成本高，所以黑灰产更多是用安卓机群，安卓有相应的防护，而 iOS 如果以前没有太多关注安全性，都是交给系统沙盒保护，越狱用户毕竟是少数。而现在 M1 Mac，无沙盒，进程可控，系统可控，所以从现在开始，开发者体验统一的苹果生态时，必须开始关注 AppleOS 安全生态。


#### M1 for Mac
2020 年 11 月 11 日苹果发布使用命名为 M1 处理器的 Mac，Apple 正式启动了 Mac 电脑从 Intel 处理器到 Apple 芯片的过渡。

搭载 Apple 芯片的 Mac 电脑：

* MacBook Pro（13 英寸，M1，2020 年）
* MacBook Air（M1，2020 年）
* Mac mini（M1，2020 年）


| 属性  | 规格  |
|---|---|
| 制程  | 5 纳米 (160 亿晶体管) |
| CPU  | 8 核 (四个高性能核心/四个高能效核心)   |
| GPU  | 8 核 (一次可执行近 25000 个线程)  |
| NPU  | 16 核 (最高达每秒 11 万亿次的惊人运算能力)  |
| 内存  | 统一内存架构 (UMA)  |


#### Mac AppStore

M1 Mac 电脑苹果已经开放了搜索和下载 iOS 和 iPadOS 的 App。方法也很简单，与 iPadOS 上一样， Mac AppStore 增加了一个切换标签：“iPad 与 iPhone App”，安装流程一样。

![35.JPG](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/df6557c14f6343d19a6e0148dd4a9abb~tplv-k3u1fbpfcp-zoom-1.image)

![36.JPG](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/27cc2cb179c6431c9dc62b8afa2ae651~tplv-k3u1fbpfcp-zoom-1.image)


关于兼容性，这样就不多说了，毕竟苹果推出 M1 Mac 也就半个月，这个 iOS App 兼容性，不同的开发者的应用不一样。但是，我相信，给点时间，兼容性问题并不大，毕竟，现在至少是能运行起来。

对于开发者，可以在 AppStoreConnect 后台设置自己的 App 是否允许在 Mac AppStore 下载：

![37.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f8d2c779d09941ef9087a699762fd6bf~tplv-k3u1fbpfcp-watermark.image)

在 App 详细页面的“价格和销售范围”可以配置：

![38.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eb0c71adf671470cbd2c1c674174ac97~tplv-k3u1fbpfcp-watermark.image)

**在 macOS 中验证您的 app**。默认情况下，Mac App Store 中的 iPhone 和 iPad app 会带有“未针对 macOS 验证”标签。当您在搭载 Apple 芯片的 Mac 上测试过您的 app，并确认它能正常运行后，您可以在 App Store Connect 确认其兼容性已受验证，以此移除 App Store 上的相关标签。

![39.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/41108c5c1630441b9e1bd247b887097f~tplv-k3u1fbpfcp-watermark.image)


**注意事项：**

- **评分和评论。** Mac App Store 与 iPhone 和 iPad 版 App Store 有针对各自平台的评分和评论，查看您 app 的用户仅会看到同一平台其他用户发表的评论。
- **通用购买。** 如果您的 iPhone 或 iPad app 在 Mac App Store 中提供，您之后可以在 App Store Connect 中为您的 app 添加 macOS 平台，将它替换为专门的 Mac 版本。替换后，在 Mac 上使用您的 iPhone 或 iPad app 的现有用户在更新该 app 时，即会更换至新的 Mac app。如果您的 iPhone 或 iPad app 已经在通用购买中提供了 Mac app，那么您将无法使用在 Mac App Store 中提供 iPhone 或 iPad app 的选项。

更多内容可查看官方文档：[面向搭载 Apple 芯片的 Mac 的 iPhone 和 iPad app - Apple Developer](https://developer.apple.com/cn/macos/iphone-and-ipad-apps/)


### 3、Restoring Developer Transition Kit（恢复DTK）

最后，在来说说重装系统的事。

DTK 的更新需要通过苹果的 ` Beta Access Utility` 应用来更新，如果你在系统偏好设置里取消了 Beta 版本更新，那么需要重新下载安装 [Beta Access Utility](https://developer.apple.com/services-account/download?path=/WWDC_2020/macOS_10.16_Developer_Beta_Access_Utility/macOSDeveloperBetaAccessUtility.dmg) (注：需要符合计划的开发者才能打开)。

而 DTK 的系统崩溃了，无法启动的话，那么就需要重新安装系统。而 DTK 本身不是成熟的产品，所以，DTK 的恢复模式与现在的 Mac 完全不一样的步骤，因为使用 ARM 架构，所以苹果是把 iOS、iPadOS 的安全引导架构直接搬到了 ARM Mac。具体这样不展开了，大家有兴趣可以看看今年的 WWDC20 有讲解 [Explore the new system architecture of Apple silicon Macs - WWDC 2020](https://developer.apple.com/videos/play/wwdc2020/10686/)（视频15分钟开始）。

![40.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/59f6de81130947f19f9c077708e6cc46~tplv-k3u1fbpfcp-zoom-1.image)


DTK 恢复系统要求：

1. 需要准备一台正常使用的 macOS Big Sur 系统的 Mac
2. 下载和安装 Xcode 12.2 Beta 2 和 Apple Configurator 2.13.1
3. 通过 Universal App Quick Start Program 页面下载 macOS Big Sur beta installer IPSW 文件


注：苹果的DTK恢复随着beta版本的迭代，要求会生成变化，比如开始只需求准备一台  macOS Catalina 10.15.5 or later的Mac，需要必须是 macOS Big Sur 了。另外苹果提供了一份教程文档：[Restoring Developer Transition Kit.pdf](https://download.developer.apple.com/Documentation/Universal_App_Quick_Start_Program_Resources/Restoring_Developer_Transition_Kit.pdf)  (注：需要符合计划的开发者才能打开)。


DTK 恢复系统步骤：

1. Place the DTK in “DFU” mode
2. Connect DTK to Host Mac
3. Restoring the device


简单来说，用一台装有 Apple Configurator 2 的 macOS Big Sur 系统的 Mac，通过 Tpye-C 连接 DTK 来恢复。需要注意，首先需要让 DTK 进入 “DFU” 模式，然后需要先关闭 DTK，拨掉 DTK 的电源线，再按住 DTK 的开机键不放，然后重新链接 DTK 电源线，继续按住 DTK 开机键2~3秒再放手。然后用 Type-C 数据线连接 DTK 的 Type-C 接口（靠近 HDMI 接口的那个）。然后打开 Apple Configurator，会显示一个 DFU 的窗口，然后拖拽 IPSW 系统文件到 DFU 窗口中，点击“恢复”就可以了。

![41.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/79182f2ca4464ab5be577bbbff4d7e8b~tplv-k3u1fbpfcp-zoom-1.image)

当然，以上是理论基础，实际的操作，就会遇到各种各样的问题，比如遇到报错：

```bash
The operation couldn’t be completed. (AMRestoreErrorDomain error 10 - Failed to handle message type StatusMsg) [AMRestoreErrorDomain – 0xA (10)]
```

![42.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d54779621f13480fa5536f9d1489dfe1~tplv-k3u1fbpfcp-zoom-1.image)

![43.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e979f771f789471a88195a02c531e19a~tplv-k3u1fbpfcp-zoom-1.image)

![44.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c1327fc0ba2b46c399f3dc2bfd710ef0~tplv-k3u1fbpfcp-zoom-1.image)


这个时候，只能是查看苹果最新的DTK恢复说明文档，在仔细对比一下，用的 beta 软件版本是不是最新了，操作是不是漏掉了等等。


如果您在更新到 macOS Big Sur 11.0.1 之前抹掉了搭载 Apple M1 芯片的 Mac，您可能无法 [通过 macOS 恢复功能重新安装 macOS](https://support.apple.com/zh-cn/HT204904)。系统可能会显示信息“准备更新时出错。未能个性化软件更新。请再试一次。”

可以使用以下任一解决方案来重新安装 macOS：[如果您在搭载 Apple M1 芯片的 Mac 上重新安装 macOS 时收到个性化错误 - Apple 支持](https://support.apple.com/zh-cn/HT211983)

![45.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0385d95a1a034f338a61a936017153ec~tplv-k3u1fbpfcp-watermark.image)

可以看出，目前 Apple M1 芯片的 Mac 的 macOS 系统刚刚开始适配，所以很多东西并不完美，如果买了 M1 Mac 暂时尽量少折腾吧，让系统升级几个小版本先啊。


### 4、总结

从 DTK 到 Apple M1 芯片的 Mac，苹果用 “One more thing” 来定义这次 Mac 的变革。从历史来看，苹果应该早几年前就有意识到 ARM 架构的生态，从淘汰32位到64位，从 Swift 到 MacCatalyst, 再到 SwiftUI，从 OpenGL 到 Metal，从 iOS 到 iPadOS，自研 GPU/NPU，苹果一直为 AppleOS（苹果生态）铺路，这一切都是以 iOS 强大的生态系统为基础，而借助苹果强大的系统和工具链，推动全平台生态融合统一并不是一件非常难的事情。

最后，作为多年的苹果开发者，虽然按苹果规则是不应用公开DTK，但是现在 M1 Mac 发售，所以楼主认为，让大家了解更多的 ARM Mac，一起开发未来的 Mac，也许是苹果现在希望我们做的，感受到苹果生态工具链的统一，应该与苹果的理念不谋而合！

Mac 的未来，由我们一起开发！一起加油吧！

![46.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a50a0c5d378b461c97f25f6579746110~tplv-k3u1fbpfcp-zoom-1.image)


### 5、参考文章

- [Universal App Quick Start Program - Apple Developer](https://developer.apple.com/programs/universal/)
- [Apple 宣布 Mac 改用 Apple 芯片 - Apple (中国大陆)](https://www.apple.com.cn/newsroom/2020/06/apple-announces-mac-transition-to-apple-silicon/)
- [Apple Silicon | Apple Developer Documentation](https://developer.apple.com/documentation/apple_silicon)
- [Apple M1 芯片 - Apple (中国大陆)](https://www.apple.com.cn/mac/m1/)
- [搭载 Apple 芯片的 Mac 电脑 - Apple 支持](https://support.apple.com/zh-cn/HT211814)
- [Apple Silicon - 维基百科](https://zh.m.wikipedia.org/zh-hans/Apple_Silicon)
- [Mac向苹果芯片迁移 - 维基百科](https://zh.m.wikipedia.org/zh-hans/Mac%E5%90%91%E8%8B%B9%E6%9E%9C%E8%8A%AF%E7%89%87%E8%BF%81%E7%A7%BB)
- [DTK 在 macOS Big Sur 11 beta 10 上无法运行 iOS app 了？- iOSRE](https://iosre.com/t/dtk-macos-big-sur-11-beta-10-ios-app/18196)
- [ARM Mac使用技巧 – 有魔法的典](http://magicdian.cn/?p=67)
- [用 UTM 虚拟机在 iPad 上运行 Windows 和 Linux，拓展生产力新可能 - 少数派](https://sspai.com/post/62092)
- [utmapp/UTM: Virtual machines for iOS](https://github.com/utmapp/UTM)
- [UTM](https://getutm.app/)
- [QEMU](https://www.qemu.org/)
- [UTM - VMs](https://getutm.app/vms/)
- [virtual machine using SPICE - Download](https://www.spice-space.org/download.html)
- [果粉的硬核工具：Apple DTK 2020，一台ARM架构的Mac Mini_笔记本电脑_什么值得买](https://post.smzdm.com/p/adwneo5z/)
- [关于 Apple DTK 申请，到时真的会给一台 Mac mini 吗 - V2EX](https://www.v2ex.com/t/684712)
- [Apple DTK 细节流出 - V2EX](https://www.v2ex.com/t/687827)
- [与Intel结缘10年 苹果Mac越来越强 - Apple 苹果 - cnBeta.COM](https://www.cnbeta.com/articles/465527.htm)
- [Developer Transition Kit - 维基百科](https://zh.m.wikipedia.org/zh-hans/Developer_Transition_Kit)
- [Mac向英特尔平台迁移 - 维基百科](https://zh.m.wikipedia.org/wiki/Mac%E5%90%91%E8%8B%B1%E7%89%B9%E5%B0%94%E5%B9%B3%E5%8F%B0%E8%BF%81%E7%A7%BB)
- [Inside Apple's Intel-based Dev Transition Kit (Photos) | AppleInsider](https://appleinsider.com/articles/05/06/23/inside_apples_intel_based_dev_transition_kit_photos)
- ["This Is Not a Product": The Apple Developer Transition Kit - MacStories](https://www.macstories.net/stories/this-is-not-a-product-the-apple-developer-transition-kit/)
- [Apple WWDC 2005-The Intel Switch Revealed - YouTube](https://www.youtube.com/watch?v=ghdTqnYnFyg)
- [Apple WWDC 2005 - YouTube](https://www.youtube.com/watch?v=Inog4syoHho)
- [Developer Transition Kit - Apple Wiki](https://apple.fandom.com/wiki/Developer_Transition_Kit)
- [Apple debuts Intel-powered Macs - BBC](http://news.bbc.co.uk/2/hi/technology/4600442.stm)
- [ThatGuySam/doesitarm](https://github.com/ThatGuySam/doesitarm)
- [DTK 苹果芯片 Arm Apple Silicon Mac mini 试玩王者荣耀游戏 - bilibili](https://www.bilibili.com/video/BV1SZ4y1G7UE)
- [Apple Silicon——未来已来 - 知乎](https://zhuanlan.zhihu.com/p/151786064)
- [识别 MacBook Pro 机型 - Apple 支持](https://support.apple.com/zh-cn/HT201300)
- [苹果电脑为什么要换 CPU：Intel 与 ARM 的战争 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2020/06/cpu-architecture.html)
- [Explore the new system architecture of Apple silicon Macs - WWDC 2020 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2020/10686/)
- [About the Rosetta Translation Environment | Apple Developer Documentation](https://developer.apple.com/documentation/apple_silicon/about_the_rosetta_translation_environment)
- [通过 macOS 恢复功能重新安装 macOS](https://support.apple.com/zh-cn/HT204904)
- [如果您在搭载 Apple M1 芯片的 Mac 上重新安装 macOS 时收到个性化错误 - Apple 支持](https://support.apple.com/zh-cn/HT211983)
- [如何重新安装 macOS - Apple 支持](https://support.apple.com/zh-cn/HT204904)
- [如何创建可引导的 macOS 安装器 - Apple 支持](https://support.apple.com/zh-cn/HT201372)
- [为什么 ARM 版 Mac 运行效率很高？ - 少数派](https://sspai.com/post/61274)
- [面向搭载 Apple 芯片的 Mac 的 iPhone 和 iPad app - Apple Developer](https://developer.apple.com/cn/macos/iphone-and-ipad-apps/)


<br>

- 如有侵权，联系必删！
- 如有不正确的地方，欢迎指导！
- 如有疑问，欢迎在评论区一起讨论！

<br>

- 如有侵权，联系必删！
- 如有不正确的地方，欢迎指导！
- 如有疑问，欢迎在评论区一起讨论！

<br>

> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源。

<br>


