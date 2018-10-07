title: Xcode真机运行报错：the application could not be verified
date: 2015-04-15 20:30:16
categories: technology #life poetry
tags: [iOS,编译报错]  # <!--more-->
reward: true
---

Xcode 提示的报错：** the application could not be verified. **

开发的应用一直真机安装不了，网上查看资料，都是说证书出错，最后在stackoverflow.com 找到原因：

> I deleted the app from the device, restarted Xcode, and the app subsequently installed on the device just fine without any error message. Not sure if deleting the app was the fix, or the problem was due to "the phase of the moon".
就是把手机上安装了的应用删除掉，在安装就行了！

分析：我猜测是因为之前我在另一台电脑上安装了这个应用，调试证书导致的错误？还是，最近升级了OS X 10.10.3 、Xcode 6.3 导致的错误？不得而之了。总之，如果下次遇到这个问题，先删掉原来的应用，如果不行，那考虑其它原因就是证书等问题。

～nice

<!--more-->

- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

