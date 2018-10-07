title: iOS11适配UIToolbar无法点击问题
date: 2017-11-09 20:54:16
categories: technology #life poetry
tags: [iOS11,UIToolbar]  # <!--more-->
reward: true

---

### 前言
一个简单的浏览器，使用到UIToolbar做底部工具栏，在 iOS11 上就有点击无响应的问题。现在发现苹果一到大系统版本，很多 UIView的实现和生命周期都变化，他们系统不用兼容 iOS10，想怎么改就怎么改，没有顾虑，但是我们作为开发者只能受累。
![C93266DA-14DD-46E0-9064-F5F5728E67EF.png](http://upload-images.jianshu.io/upload_images/99517-9e8c46fce3a85889.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

### iOS 11
原因：Toolbar 在iOS11默认添加有`_UIToolbarContentView`，_UIToolbarContentView `_UIButtonBarStackView`覆盖在自定义的按钮上面，导致按钮无响应。

 <!--more-->
 
![在Toolbar 上有_UIButtonBarStackView.png](http://upload-images.jianshu.io/upload_images/99517-0064ec0d0729f0e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

![在 Toolbar 上层有_UIToolbarContentView.png](http://upload-images.jianshu.io/upload_images/99517-6e3ed37aa98a0aaf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

### 解决

为了解决iOS11(与较低版本兼容)的问题，您只需要在UIToolBar被添加为UI层次结构的子视图之后，调用 layoutIfNeeded方法，UIToolbarContentView会降低到UIToolBar的第一个子视图，然后你就可以将所有的子视图添加到最顶层。

For example in ObjC:

```
    UIToolbar *toolbar = [UIToolbar new];
    [self addSubview: toolbar];
    [toolbar layoutIfNeeded];

    <here one can add all subviews needed>
```

在创建成功后，使用layoutIfNeeded方法，让_UIToolbarContentView马上生效，这样在添加子视图就没有问题啦。

![正常后_UIToolbarContentView.png](http://upload-images.jianshu.io/upload_images/99517-f77faa171cc652b4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 总结

iOS11 上的 NavigationBar 好像也有相似的结构变化，每一次新系统，用户无愿意升级，开发者为适配要付出更多，一方面是苹果的改变压力在加大，系统的维护也是一个很大工作；另一方面 App 的界面越来越复杂，如果在搭建时没有设计好 UI 框架，部分依赖系统组件功能，导致受到影响也比较大。

### 参考阅读

- [Hello World](https://github.com/iHTCboy/HelloWorld)
- [ios - iOS11 UIToolBar Contentview - Stack Overflow](https://stackoverflow.com/questions/46107640/ios11-uitoolbar-contentview)
- [iOS 11 breaks slacktextviewcontroller · Issue #604 · slackhq/SlackTextViewController](https://github.com/slackhq/SlackTextViewController/issues/604)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


