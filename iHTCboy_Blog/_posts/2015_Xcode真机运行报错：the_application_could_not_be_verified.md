title: Xcode真机运行报错："the application could not be verified"
date: 2015-03-12 00:56:16
categories: technology #life poetry
tags: [iOS,编译报错]  # <!--more-->
reward: true

---

昨天苹果更新Xcode 6.2 ,升级后项目编译后报错，网上的搜索到的方法试了，结果都不成功，最后在Xcode 设置里重新设置帐号就可以了。
1、用“—”删除你的帐号
 
![左下角“—”删除帐号](http://upload-images.jianshu.io/upload_images/99517-73bdc63dc475022d.png)

<!--more-->

2、然后重新添加帐号，并刷新帐号，所以按提示就可以编译通过。
（ps：1.电脑要有真机调试证书，2.手机已经加入调试设备）

![屏幕快照 2015-03-12 00.51.07.png](http://upload-images.jianshu.io/upload_images/99517-a8e63720b94f85fe.png)

由于急解决，所以过程忘记截图了，也无法在重现了。。。

nice～


- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

