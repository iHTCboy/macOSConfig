title: iOS开发必备HUD(透明指示层)
date: 2015-05-10 11:18:26
categories: technology #life poetry
tags: [iOS,HUD,透明指示层]  # <!--more-->
---

### 1.MBProgressHUD
GitHub地址：https://github.com/jdg/MBProgressHUD
基本上看到的主流iOS应用都集成了这个，Star 7k了，最近看到很多应用HUD隐藏时，有一个动画过程，我还以为是自己扩展的，后来研究才发现，有这个属性``animationType``:

```
 @property (assign) MBProgressHUDAnimation animationType;

```

```
 typedef NS_ENUM(NSInteger, MBProgressHUDAnimation) {
	/** Opacity animation */
	MBProgressHUDAnimationFade,
	/** Opacity + scale animation */
	MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomOut = MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomIn
 };
```
<!--more-->

![Loading效果](http://upload-images.jianshu.io/upload_images/99517-4068b8afc4126b3d.png)

![还可以显示1行或2行文字](http://upload-images.jianshu.io/upload_images/99517-3bc7a19adc26b953.png)

![圆形进度圆](http://upload-images.jianshu.io/upload_images/99517-b1932cea64a82058.png)

![条形进度条](http://upload-images.jianshu.io/upload_images/99517-970d29864000d811.png)

![通过自定义图片形成的效果](http://upload-images.jianshu.io/upload_images/99517-3e6c998657650b52.png)

![可以只要文字提醒](http://upload-images.jianshu.io/upload_images/99517-89584b85e5b6e627.png)




### 2. SVProgressHUD
GitHub地址：https://github.com/TransitApp/SVProgressHUD
SVProgressHUD和MBProgressHUD效果差不多，特点就是不需要使用协议，同时也不需要声明实例。直接通过类方法就可以调用：
```
 [SVProgressHUD method]
```

```
 [SVProgressHUD dismiss]
```

![效果图.gif](http://upload-images.jianshu.io/upload_images/99517-dc6f8a6b64169303.gif)



### 3. JGProgressHUD
GitHub地址：https://github.com/JonasGessner/JGProgressHUD
JGProgressHUD和MBProgressHUD效果差不多，作为后起之秀，特点就是如果有键盘时，HUD可以自动上移，效果非常棒！另外自定义定制也很灵活。

![JGProgressHUD效果图](http://upload-images.jianshu.io/upload_images/99517-ead9ced1c1b0ee03.png)



### 4. Toast
GitHub地址：https://github.com/scalessec/Toast
这个Toast非常经典。

```
 // basic usage
 [self.view makeToast:@"This is a piece of toast."];
 
 // toast with duration, title, and position
 [self.view makeToast:@"This is a piece of toast with a title." 
            duration:3.0
            position:CSToastPositionTop
               title:@"Toast Title"];
 
 // toast with an image
 [self.view makeToast:@"This is a piece of toast with an image." 
            duration:3.0
            position:[NSValue valueWithCGPoint:CGPointMake(110, 110)]
               image:[UIImage imageNamed:@"toast.png"]];

 // display toast with an activity spinner
 [self.view makeToastActivity];
```

![Toast部分效果](http://upload-images.jianshu.io/upload_images/99517-e7d55e76ce53c1b2.png)


##### 目前来说，以前4种HUD就能满足基本需求，实际开发中，集成到一个Utility中就更方便，等我完善了在放出来分享啦





<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

