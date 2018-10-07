title: NSDateFormatter的hh与HH和yyyy与YYYY出坑
date: 2016-10-11 23:30:16
categories: technology #life poetry
tags: [iOS,NSDateFormatter,HH,YYYY]  # <!--more-->
reward: true
---

### 原因
最近发现应用的倒计时显示为00:00:00，开始以为后台给的时间问题，然后怀疑是缓存问题，跟着代码调试了很久，终于发现原因。

<!--more-->

```
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSDate *nowDate = [formatter dateFromString:currentTime];

```

- 发现一台设备调试显示： nowDate == nil
- 其它设备日期显示正确

### 解决
** @"yyyy-MM-dd hh:mm:ss";  ** 改成** @"yyyy-MM-dd HH:mm:ss";  **

- hh:mm:ss  
按照12小时制的格式进行字符串格式化
如果时间处于00：00：00——12：59：59，则返回的字符串正常
如果时间处于13：00：00——23：59：59，则返回的字符串是实际时间-12小时后的值，也就是说比真实的时间少了12个小时。
 
- HH:mm:ss
按照24小时制的格式进行字符串格式化
** 当手机时间为任意一个区间，则返回的字符串都是正常的。**


### 参考
[时间格式化hh:mm:ss和HH:mm:ss区别](http://blog.csdn.net/u011344883/article/details/48622015)
[NSDateFormatter的yyyy和YYYY到底什么区别](https://segmentfault.com/q/1010000000174542)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

