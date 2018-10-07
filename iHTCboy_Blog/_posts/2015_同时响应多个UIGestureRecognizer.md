title: 同时响应多个UIGestureRecognizer
date: 2015-07-29 23:52:16
categories: technology #life poetry
tags: [iOS,UIGestureRecognizer]  # <!--more-->
reward: true
---

最近在做产品试戴，效果如下：
![效果图](http://upload-images.jianshu.io/upload_images/99517-4a52cfabb55b00b6.JPG?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

 <!--more-->

使用了多个手势识别器：
- ``UIRotationGestureRecognizer``
-  ``UIPinchGestureRecognizer``
-  ``UIPanGestureRecognizer``
-  ``UITapGestureRecognizer``

其中的问题是，试戴的图片可以同时旋转和缩放，而系统默认只能响应一个手势。
要同时响应多个手势，可以通过``UIGestureRecognizerDelegate`` 代理方法：
```objective-c

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

```

代理方法中，可以设置那些手势可以同时响应操作。


### -

- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


