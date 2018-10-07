title: 使用AutoLayout约束, 为啥图片的大小(Image size)却还以实际大小显示？
date: 2017-11-18 20:49:16
categories: technology #life poetry
tags: [AutoLayout,Imagesize,图片实际大小显示]  # <!--more-->
reward: true

---

### 问题
给一个 UIImageView 设置一张图片时，使用 AutoLayout 给 UIImageView 约束宽高，但是实际显示的大小，图片以实际的大小显示出来，代码也没有设置 frame，设置contentMode为UIViewContentModeScaleAspectFit 也不起作用。

### 原因
最后注册到约束时，设置了 `@property NSLayoutPriority priority;` ，就是设置了线束的优先级为`UILayoutPriorityDefaultHigh`，导致这个约束级别比图片默认显示的大小的优先级低。

 <!--more-->
 
### 解决方法
如果开始一定要给一个低级的约束，那么要以约束大小显示时，在重新添加一个相同大小约束的`UILayoutPriorityRequired`，这样就会覆盖低优先级的约束，图片大小就不会超级约束范围。

### 参考
- [Hello World](https://github.com/iHTCboy/HelloWorld)
- [ios - With Auto Layout, how do I make a UIImageView's size dynamic depending on the image? - Stack Overflow](https://stackoverflow.com/questions/26833627/with-auto-layout-how-do-i-make-a-uiimageviews-size-dynamic-depending-on-the-im)


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源



