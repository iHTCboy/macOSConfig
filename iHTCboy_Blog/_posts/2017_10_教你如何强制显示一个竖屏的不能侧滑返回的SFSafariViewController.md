title: 教你如何强制显示一个竖屏的不能侧滑返回的SFSafariViewController
date: 2017-10-28 19:28:16
categories: technology #life poetry
tags: [强制竖屏,SFSafariViewController,iOS侧滑返回]  # <!--more-->
reward: true

---

### 强制让控制器竖屏显示
```
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

// 隐藏系统状态样
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
```

<!--more-->

###  设置不让SFSafariViewController侧滑返回
```
Swift:

let viewController = SFSafariViewController(URL: url)  
presentViewController(viewController, animated: true) {  
  
     for view in viewController.view.subviews {  
  
          if let recognisers = view.gestureRecognizers {  
  
               for gestureRecogniser in recognisers where gestureRecogniser is UIScreenEdgePanGestureRecognizer {  
  
                    gestureRecogniser.enabled = false  
               }  
          }  
     }  
 }

```

```
OC:

 EFKRSafariViewController *safari = [[EFKRSafariViewController alloc] initWithURL:url];
    safari.closeHandler = completion;
    [self presentViewController:safari animated:YES completion:^{
        // 禁止侧滑返回，因为侧滑返回导致强制竖屏会变回横屏
        for (UIView * view in safari.view.subviews) {
            NSArray<__kindof UIGestureRecognizer *> * array = view.gestureRecognizers;
            if (array.count) {
                for (UIScreenEdgePanGestureRecognizer * sepgr in array) {
                    sepgr.enabled = NO;
                }
            }
        }
    }];
```

### 如何
创建继承SFSafariViewController的控制器，在里面添加上面的代码就可以啦！
![继承SFSafariViewController.png](http://upload-images.jianshu.io/upload_images/99517-733355d4a71f6083.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###  总结
有时候，我们在修改系统的控件属性时，总是希望想找到一个属性方法设置后，就可以达到自己想要的 UI或者逻辑，但其实，系统不可以提供那么多自定义的 API，所以，我们只能通过自己去找到想要的东西，然后去修复它，达到目的。类似的思想，比如hook。代码上也是很其妙。


### 参考扩展
- [SFSafariViewController in iOS 9.2 | Apple Developer Forums](https://forums.developer.apple.com/thread/29048)
- [ios - Safari View Controller Swipe Left to dismiss goes black - Stack Overflow](https://stackoverflow.com/questions/35088076/safari-view-controller-swipe-left-to-dismiss-goes-black/46974814)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


