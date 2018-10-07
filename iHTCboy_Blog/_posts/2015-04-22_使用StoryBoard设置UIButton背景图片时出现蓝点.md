title: 使用StoryBoard设置UIButton背景图片时出现蓝点
date: 2015-04-22 15:49:16
categories: technology #induction life poetry
tags: [iOS,StoryBoard,UIButton]  # <!--more-->
reward: true

---

### 1、前言
使用`StoryBoard`设置`UIButton`的背景图片时出现蓝点：

![设置按钮的背影图片选择时显示蓝点](http://upload-images.jianshu.io/upload_images/99517-96ebfde841239962.PNG)

<!--more-->
### 2、解决
##### 原图分析：
刚开始以为选中了 ``Hightlighted Adjusts Image`` 导致的原因，结果发现，是因为Type为System，使用Custom就没有问题了，这个蓝点应该是Title的位置，因为当设置Title为空格时，蓝点位置改变了。

![Type: System](http://upload-images.jianshu.io/upload_images/99517-0a4a01d27f09f9e5.png)

![Type: Custom](http://upload-images.jianshu.io/upload_images/99517-2ea0f2270eccba3f.png)

ps:还有很多问题，iOS7/iOS8下，显示不一样，比如我设置

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



