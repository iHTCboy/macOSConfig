title: JSBadgeView的基本使用
date: 2015-04-22 23:24:16
categories: technology #induction life poetry
tags: [iOS,JSBadgeView]  # <!--more-->
reward: true

---

### 1、前言
[JSBadgeView ](https://github.com/JaviSoto/JSBadgeView) 是iOS开发常用的显示数字图标的库：

![iOS 7以上风格](http://upload-images.jianshu.io/upload_images/99517-6fa0f9ff45c986e2.png)

![iOS 6风格](http://upload-images.jianshu.io/upload_images/99517-18d9bc7af2ca3947.png)


<!--more-->

### 2、使用方法

```obj-c
//新标识视图  
//1、在父控件（parentView）上显示，显示的位置TopRight  
self.badgeView = [[JSBadgeView alloc]initWithParentView:parentView alignment:JSBadgeViewAlignmentTopRight];  
//2、如果显示的位置不对，可以自己调整，超爽啊！  
self.badgeView.badgePositionAdjustment = CGPointMake(-15, 10);
//3、如果多个的badge,可以设置tag要辨别    
self.badgeView.tag = IN_AREA_NEW_TASKS_TAG;

//1、背景色
self.badgeView.badgeBackgroundColor = [UIColor redColor];  
//2、没有反光面
self.badgeView.badgeOverlayColor = [UIColor clearColor];  
//3、外圈的颜色，默认是白色    
self.badgeView.badgeStrokeColor = [UIColor redColor];

  
/*****设置数字****/  
//1、用字符串来ym
self.badgeView.badgeText = @"1";  
//2、如果不显示就设置为空
self.badgeView.badgeText = nil; 
  
//当更新数字时，最好刷新，不然由于frame固定的，数字为2位时，红圈变形  
[self.badgeView setNeedsLayout];

```

- [GitHub - JSBadgeView ](https://github.com/JaviSoto/JSBadgeView)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



