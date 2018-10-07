title: macOS的控制台Console.app
date: 2018-07-13 22:29:16
categories: technology #life poetry
tags: [macOS,Console.app,苹果控制台]  # <!--more-->
reward: true

---

### 1、前言
从Xcode9.4开始，Devices 界面已经移除了真机设备的日志输出log，而移到macOS系统独立的控制台app(Console.app):

![20180713-macOS-Console.app.png-w200](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/07/20180713-macOS-Console.app.png)

<!--more-->

### 2、控制台 Console.app
>查看日志信息和报告以获取有关 Mac 和设备的诊断信息。

控制台应用很早的macOS版本就有了，但是不常用，其实Xcode中移除，也是因为与控制器功能相似，对于Xcode来说，也许真的是一个负担，并且Xcode现在bug已经够多了，移除也是一个好事吧。

可以直接看苹果文档：[欢迎使用控制台 - Apple 支持](https://support.apple.com/zh-cn/guide/console/welcome/1.0)


### 3、一些技巧
相对于以前想看设备的日志，其实，控制台可谓更轻量，更快捷，更专业吧。下面就说说一些技巧：

- 筛选所需
我们打开控制台的目的，一般都是调试我们自己开发的iOS应用吧！这时候，链接设备后，其实我们只关心我们自己的应用的日志，但默认情况下，会显示所有应用当前输出的日志，这时候，筛选所需显得很有必要！
找到你应用输出的一条日志，然后鼠标右键（或按住 Control 键点按日志信息），然后选择 `显示“进程'XXX'”`：

![20180713-macOS-Console-Filter-Process-Items.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/07/20180713-macOS-Console-Filter-Process-Items.png)

这里示例`WeRead`(微信读书)的进程筛选，然后就会只显示这个应用的全部日志，相对于Xcode的日志界面，其实非常方便啦~

![20180713-macOS-Console-Filter-Process-Items-activity.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/07/20180713-macOS-Console-Filter-Process-Items-activity.png)


- 显示所需
另一方面，第一条日志默认只显示一行，如果想显示全部，可以点击后，在下方显示具体的内容：
    
![20180713-macOS-Console-Show-Items.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/07/20180713-macOS-Console-Show-Items.png)

如果用快捷键（→ 和 ←）左右箭头键可以快速在当前选择的行显示全部的内容：

![20180713-macOS-Console-Show-Specific-Items.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/07/20180713-macOS-Console-Show-Specific-Items.png)


### 4、快捷键
使用键盘快捷键快速完成“控制台”中的许多任务。

| 快捷键  | 说明 |
| --- | --- |
| Command-Option-F | 搜索日志信息和活动 |
| Command-F | 在日志信息中查找文本 |
| Command-G | 跳到下一条搜索结果 |
| Command-Shift-G | 跳到上一条搜索结果 |
| Command-K | 清除日志信息或活动 |
| Shift-Command-R | 重新载入日志信息或活动 |
| Shift-Command-N | 跳到最近的日志信息或活动 |
| Command-0 | 显示或隐藏边栏 |
| Command-R | 在 Finder 中显示报告 |
| → | 在本行展开所选日志信息 |
| ← | 在本行折叠所选日志信息 |
| Control-Command-F | 进入或退出全屏幕视图 |
| Command-C | 拷贝所选日志信息文本 |

### 5、总结
这个过程，大家也许会发现，用快捷键是提高效率的直接方式，用 `Alfred` 来打开也很方便（后面计划写一个`Alfred`开发者效率的文章，期待吧!）。刚开始，也许对于打开控制台查看日志log输出不习惯，但有时候只是查看日志排查问题，直接打开 Console.app 真的方便很多（你知道打开Xcode需要的时候更久，并且在打开Devices更是久啊），所以，综上，这个控制台 Console.app也是一件好事！

说到这里，其实，我更想吐槽的是Xcdoe！！！越来越庞大，还有Swift的交替，还有功能更强大？直接导致品控越来越差。所以，从这个角度来看，苹果把Xcode的很多相关但不重要的功能单独出来，也许是到于Xcode开发团队来说，是一件好事，到后续的版本迭代也是好事吧，希望Xcode10给开发者带来`新`体验！期待9月！！


### 6、参考

- [欢迎使用控制台 - Apple 支持](https://support.apple.com/zh-cn/guide/console/welcome/1.0)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



