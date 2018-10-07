title: Xcode打包上传后, AppStore提示“二进制文件无效”
date: 2015-07-06 16:20:16
categories: technology #life poetry
tags: [iOS,二进制文件无效]  # <!--more-->
reward: true
---

搜索了2个小时，上传了5个版本后，终于解决了。网上是这样说的：
> http://stackoverflow.com/questions/26163856/invalid-swift-support-invalid-implementation-of-swift 
1、重启Xcode，clean build
2、重启Mac OSX
3、换个新版本Xcode 

<!--more-->

最后解决答案是：
>不要用私有Api，如果工程里面导入了Reveal.framework 要删除掉重新打包上传。
一般情况下你用  application loader 上传，如果使用了，会检测出来，并且提示。
如果app特别大，会上传到itunesconnect 才会去检测。
检测私有api 可以看看下面这个
http://stackoverflow.com/questions/2842357/how-does-apple-know-you-are-using-private-api

最近买的Reveal，结果用了后一直没在意，也不知道有私有方法，这次真又涨姿势了！

一般无效苹果会发邮箱到开发者邮箱里，有详情原因。

- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

