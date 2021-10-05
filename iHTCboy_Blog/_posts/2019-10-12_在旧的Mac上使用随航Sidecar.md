title: 在旧的Mac上使用随航(Sidecar)
date: 2019-10-12 23:01:16
categories: technology #induction life poetry
tags: [Mac,macOS,Sidecar,随航]  # <!--more-->
reward: true

---

### 1、前言
6月 `WWDC2019` 上苹果发布新的 `macOS 10.15`，同时发布 `Sidecar`（随航）功能，可以把 `macOS` 界面转发到 `iPad` 上，但是对于旧的 Mac 电脑，不支持随航功能！我的 `MacBook Pro (Retina, 13-inch, Mid 2014)` 哭晕在厕所~

<!--more-->

### 2、Sidecar（随航）

按苹果的介绍：

> Sidecar: Expand Mac Workspace and Creativity with iPad 
> 
> The new Sidecar feature extends a user’s Mac workspace by using iPad as a second display, allowing them to spread out their work. With Sidecar, you can use an iPad display for tablet input to draw, sketch or write with Apple Pencil in any Apple or third-party Mac app that supports stylus input. Sidecar runs on a wired connection so users can charge their iPad as they work, or on a wireless connection for greater mobility, using everything from illustration apps and video editing apps to 3D apps, like Photoshop, Illustrator and ZBrush.

翻译过来就是：

> Sidecar：扩展 Mac 的工作空间和用 iPad 创作
>
> 新的 Sidecar 功能通过使用 iPad 作为第二显示器，让他们把她们的工作延长了用户的 Mac 工作区。边三轮，您可以使用 iPad 显示屏的平板电脑输入画，素描或与苹果铅笔在任何苹果或支持手写笔输入的第三方 Mac 应用程序编写。三轮有线连接上运行，以便为他们工作的用户可以收取他们的 iPad 或对流动性较大的无线连接，使用一切从插图的应用程序和视频编辑应用到3D 应用程序，如 Photoshop，Illustrator 和 ZBrush的。


### 2、解决的方法

#### 前述
在 macOS10.15 beta 版本时，旧版的Mac电脑，可以通过下面的命令开启 Sidecar：

```shell
defaults write com.apple.sidecar.display AllowAllDevices -bool true;
defaults write com.apple.sidecar.display hasShownPref -bool true;
open /System/Library/PreferencePanes/Sidecar.prefPane
```

然而，在正式版 macOS 10.15 上面的命令已经失败，被列入黑名单了。执行命令后提示：`您无法打开“随航”偏好设置面板，因为该面板此时不可用。`

其实，这个原因，还是回到问题本身，为什么苹果限制为旧的 Mac 上使用 Sidecar（随航）？

按照网上讨论的解释：
> Sidecar功能依赖于 `HEVC`，而 HEVC 一个高效率的视频编解码器。与 Intel 的`SKYLAKE` 架构 CPU 处理器开始，增加了内置支持的这种编解码器。

#### 后述

当然，这样的情况下，还是有大神做了一个脚本，执行后，可以修改 SidecarCore 苹果私有框架（SidecarCore.framework）从黑名单中移除您的Mac机型。

具体脚本见：[luca/SidecarCorePatch: Enables Sidecar support on MacOS Catalina 10.15 Beta on non Apple supported devices. - Zeppel](http://dev.zeppel.eu/luca/SidecarCorePatch)

> 1. Backup /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore in case something goes wrong.
> 2. Disable SIP. Check status with $ csrutil status
> 3. clone this repo $ git clone http://dev.zeppel.eu/luca/SidecarCorePatch.git
> 4. run the patch as root $ sudo swift patch.swift
> 5. reboot your mac


1. 备份 /System/Library/PrivateFrameworks/SidecarCore.framework/Versions/A/SidecarCore 以备无防.
2. 关闭 SIP. 通过这个命令检查是否关闭： `$ csrutil status`
3. 克隆本仓库 `$ git clone http://dev.zeppel.eu/luca/SidecarCorePatch.git`
4. 使用管理员权限执行脚本：`$ sudo swift patch.swift`
5. 重启 mac

注：关于 [SIP](https://en.wikipedia.org/wiki/System_Integrity_Protection)（System Integrity Protection, 系统完整性保护）这里就不多说，可以[自行搜索](https://www.jianshu.com/p/fe78d2036192)。要关闭 SIP，需要进入恢复系统模式的终端下执行 `csrutil disable`。

在这里就不多说了，因人而异。

**需要补充说明一下，虽然这个方法可以让旧的 Mac 实现 Sidecar（随航），但是会出现闪屏！！闪屏！！闪屏！！**

所以，如果只是想体验的，可以试试，否则，还是放弃吧...

### 3、最佳的情况

按 [苹果的文档](https://www.apple.com/macos/catalina/docs/Sidecar_Tech_Brief_Oct_2019.pdf) Sidecar 对设备的要求：

#### Macs

MacBook introduced in 2016 or later
MacBook Air introduced in 2018 or later
MacBook Pro introduced in 2016 or later
Mac mini introduced in 2018 or later
iMac introduced in late 2015 or later
iMac Pro introduced in 2017 or later
Mac Pro introduced in 2019


#### iPads

12.9-inch iPad Pro
11-inch iPad Pro
10.5-inch iPad Pro
9.7-inch iPad Pro
iPad (6th generation or later)
iPad mini (5th generation)
iPad Air (3rd generation)

#### 环境要求

1. 必须登录同一个 Apple ID 的两台设备上（一台Mac，一台iPad）
2. Apple ID 开启了双重因素身份验证，必须在iPad和Mac上启用
3. 必须是设备上开启蓝牙
4. 如果以无线方式连接，确保两个设备连接到同一个WiFi网络
5. Mac 系统为 `macOS 10.15` 以上，iPad 系统为 `iPadOS 13` 以上


### 3、总结

按照苹果的技术水平，我们有理由充分相信苹果的技术是做了努力，所以苹果会让尽多的旧设备支持最新的体验。现在硬件的淘汰比技术的淘汰还要快，更不要说前端的技术更新很快，硬件的更新如果不快一点，大家就吐槽说没有创新！21世纪的前20年，感受了技术的爆发式增长，希望接下来的20年，依然让人心潮澎湃！

当然，如果真想在旧Mac上使用分屏多屏，还是有办法的，比如使用著名的第三方软件 `Duet`！但是我依然觉得太卡（可能是我设备太旧的....iPad mini 2）~ 它支持多系统平台，如果需要可以试试。

总的来说，又多了一个理由换 MBP! 对于程序员，写代码的环境，总是觉得屏幕不够大！如果是在空，我或许建议买一个显示器，如果是经常移动办公，或者喜欢去咖啡馆的朋友，可能有需要。而且，我相信，分屏的场景会越来越多，比如2个人用一个电脑，一个工作，一个显示肥皂剧~

结合最近看的`WWDC 2019`视频，多个session都表示，苹果希望打造一个OS生态，把iOS 应用带到 macOS，是一个伟大而现实的一步。苹果这几年来的创新，应该就是对生态系统的整合，从 `Handoff` 到收购 `workflow`，变成 `Shortcuts`, iOS 到 iPadOS，企图壮大`macOS`！当然，从家长监控软件，到`Duet`，大家都是觉得苹果`抄`他们的生活的绝路，也许绝路才是最好的前路！也许，这就是残酷的现实，像19世界汽车出现让多数马夫很愤怒，而现在的我们已经没有`感知`，我们所期待的苹果，总有替代更新，也许是这样的规律~

### 参考
- [Sidecar_Tech_Brief_Oct_2019 - Apple](https://www.apple.com/macos/catalina/docs/Sidecar_Tech_Brief_Oct_2019.pdf)
- [Sidecar support on older Macs : apple](https://www.reddit.com/r/apple/comments/bx3eet/sidecar_support_on_older_macs/)
- [Sidecar not working in iPadOS and macOS? How to fix Sidecar problems - AppleToolBox](https://appletoolbox.com/sidecar-not-working-in-ipados-and-macos-how-to-fix-sidecar-problems/)
- [Apple's Sidecar feature only works on newer Macs](https://www.engadget.com/2019/10/08/apple-macos-sidecar-newer-macs/)
- [Mac开启关闭SIP（系统完整性保护） - 简书](https://www.jianshu.com/p/fe78d2036192)
- [在 macOS 10.15.4 上解锁 Sidecar 需要进行额外步骤 - 知乎](https://zhuanlan.zhihu.com/p/116475208)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
<br>



