
title: iOS错误---“A valid provisioning profile for this executable was not found”
date: 2015-03-23 10:34:16
categories: technology #life poetry
tags: [iOS,编译报错]  # <!--more-->
reward: true

---

> linker command failed with exit code 1 (use -v to see invocation)

网上答案：

> 1、我以前添加开源的.a文件时也遇到过类似的情况，问题大多主要是出现在Ohter Linker Flags 这个属性，找到Build settings->Linking->Other Linker Flags，将此属性修改成-all_load
> 
> 2、把Other Linker Flags下的属性全删除了。
> 
> 3、错误信息中出现了某个类的名字，去原文件中看看#import了哪些第三方库，把这些库挨个注释排除，找到出错的那个库，然后按照官方提供的步骤重新添加一遍。
> 
> 4、看看是不是有新添加的文件跟之前文件同名


经过多次排查，最后答案是：

> 出现这种情况很可能是，项目中引入了多个相同的文件。

删除一个就ok！


- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源