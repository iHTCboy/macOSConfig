title: 基于NSTimer的倒计时
date: 2015-04-17 15:12:26
categories: technology #life poetry
tags: [iOS,NSTimer,倒计时]  # <!--more-->
reward: true
---

今天做手机短信验证码的功能，不用GCD，简单的NSTimer就可以完成,不知道有没有bug,测试中。。。

```objective-c
 #pragma mark - 倒计时
 - (void)startCount
 {
    /**
     *  添加定时器
     */
    self.currentCountDown = 120;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
 }
 
 - (void)countDown{
    
    if (self.currentCountDown >0) {
        //设置界面的按钮显示 根据自己需求设置
        [self.captchaBtn setTitle:[NSString stringWithFormat:@"(%ld)重新获取",(long)self.currentCountDown] forState:UIControlStateNormal];
        //self.captchaBtn.enabled = NO;
        self.currentCountDown -= 1;
    }else{
        [self removeTimer];
    }  
 }

 /**
 *  移除定时器
 */
 - (void)removeTimer
 {
    self.currentCountDown = 0;
    [self setCaptchaEnable:YES];
    [self.timer invalidate];
    self.timer = nil;
 }


 //因为iOS 7下 按钮 enabled= NO, 不能设置文字
 #pragma mark - 设置按钮状态
 - (void)setCaptchaEnable:(BOOL)enabled{
    //可以按
    if (enabled) {
        self.captchaBtn.userInteractionEnabled = YES;
        [self.captchaBtn setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
        [self.captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
    }else{
        self.captchaBtn.userInteractionEnabled = NO;
        [self.captchaBtn setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    }
 }
```

在项目中目前是自己写的一个集成倒计时的按钮，这个思路暂时可以行！



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

