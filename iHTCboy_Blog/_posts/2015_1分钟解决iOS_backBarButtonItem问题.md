title: 1分钟解决iOS_backBarButtonItem问题
date: 2015-04-27 20:32:16
categories: technology #life poetry
tags: [iOS,backBarButtonItem]  # <!--more-->
reward: true
---

## 1、序
- iOS导航栏的返回按钮，一直都是开发中比较头痛的问题。

正好在做毕业设计时，想到要设置全局的返回样式，只要图片，不要文字，形式如下：

![最终效果图.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/04/最终效果图.png)

<!--more-->


## 2、思考过程

- 网上有很多种方法，但是我都认为太麻烦，所以看能不能简单的设置一个全局样式

（1）开始时，我设置了如下：

```

UINavigationBar * navigationBar = [UINavigationBar appearance];

//返回按钮的箭头颜色

[navigationBar setTintColor:[UIColor whiteColor]];

//设置返回样式图片

UIImage *image = [UIImage imageNamed:@"navigationbar_back"];

image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

navigationBar.backIndicatorImage = image;

navigationBar.backIndicatorTransitionMaskImage = image;

```

- 以上代码实现了全局的形式如下：

![带有上一级导航标题.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/04/带有上一级导航标题.png)



（2）讨论：全局下，箭头都是自定义样式了，但是文字怎么去掉？网上的方法很多，有用到时在设置，或全局的利用运行时重载方法，问题都是没有达到简单的方法，后来找到这样一个方法如下：

- 利用全局的UIBarButtonItem，然后巧妙的设置文字的偏移值，达到“隐藏”效果

```

UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];

UIOffset offset;

offset.horizontal = -500;

[buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];

```

- 不知道这个方法是不是最简单，和这个方法是不有什么“bug”，能力有限，欢迎指点！

## 3、最后效果如下：

![最后效果图.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/04/最后效果图.png)

## 4、快速使用方法

```

- (void)setNaviBack{

UINavigationBar * navigationBar = [UINavigationBar appearance];

//返回按钮的箭头颜色

[navigationBar setTintColor:[UIColor colorWithRed:0.984 green:0.000 blue:0.235 alpha:1.000]];

//设置返回样式图片

UIImage *image = [UIImage imageNamed:@"navi_back"];

image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

navigationBar.backIndicatorImage = image;

navigationBar.backIndicatorTransitionMaskImage = image;

UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];

UIOffset offset;

offset.horizontal = - 500;

offset.vertical =  - 500;

[buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];

}
```

##  5、总结
在AppDelegate里集成上面代码，应用只要push后，不设置left按钮，默认都是统一的返回图片，快不快！而且保留了系统自带的左滑返回手势


## 6、Bug
感谢 @binMyth 、 @简书坤  提醒，bug:
- 导航条上的返回按钮 的 相应区域 还是原来那么大 没有变为图片的大小
- 第一个界面的 title 过长 会影响 跳转到的第二界面 的 title

因为没有去改变系统的backBarButtonItem，所以位置是没有变的。
在iPhone 5s上测试：
- 如果上一级标题没有超过6个中文，那么其实下一级时，返回标题会显示完整，导致下一级标题右移了。
- 如果上一级标题超过6个中文，系统会设置”返回“,位置相对较少，标题不会右移。

当然，在iPhone 6plus上宽度更大，具有没有测试，对于一般应用，标题不会太长，是可以接受吧。谢谢大家的指正！！如果大家有更好的方法，欢迎指教！



- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

