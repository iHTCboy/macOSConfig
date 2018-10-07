title: UIActivityIndicatorView的hidden隐藏属性没作用？
date: 2017-11-15 09:17:16
categories: technology #life poetry
tags: [UIActivityIndicatorView,hidden隐藏没效]  # <!--more-->
reward: true

---

### 现象

创作的UIActivityIndicatorView，想当作一般的 View 使用，然后想隐藏时，把hidden属性设置为 YES；但是一直没有作用。

### 原因
UIActivityIndicatorView有一个属性hidesWhenStopped。它默认为YES(true)。建议用这个属性来隐藏UIActivityIndicatorView，因为在一些异步和通知回调中，hidden属性起不到作用，可以参考我写的 [GitHub Demo](https://github.com/iHTCboy/UIActivityIndicatorViewDemo).

>// default is YES. calls -setHidden when animating gets set to NO

 <!--more-->

### 解决方案
设置indicatorView.hidesWhenStopped属性，使用startAnimating、stopAnimating方法来按钮 UIActivityIndicatorView 是否显示，这样不管什么情况下，都可以正常。

```
indicatorView.hidesWhenStopped = YES;
```

```
    if (isShow) {
        [self.loadingView startAnimating];
    }
    else{
        [self.loadingView stopAnimating];
    }
```


### 参考
- [Hello World](https://github.com/iHTCboy/HelloWorld)
- [xcode6 - swift UIActivityIndicatorView .hidden = false not working - Stack Overflow](https://stackoverflow.com/questions/25745172/swift-uiactivityindicatorview-hidden-false-not-working)
- [ios - UIActivityIndicatorView hidden property is set to YES by default - Stack Overflow](https://stackoverflow.com/questions/29948983/uiactivityindicatorview-hidden-property-is-set-to-yes-by-default/29952413)
- [https://github.com/iHTCboy/UIActivityIndicatorViewDemo](https://github.com/iHTCboy/UIActivityIndicatorViewDemo)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


