title: iOS接收null的处理方法
date: 2015-07-19 23:45:16
categories: technology #life poetry
tags: [iOS,NSNull]  # <!--more-->
reward: true

---

经常服务器返回的数据，有null，还有nil，如果在模型层不处理的话，到时候数据展现时，一定会崩啊，最近决心要解决这个问题，所以查看了一些资料后，有答案了：

```objective-c
- (id) setNoNull:(id)aValue{
    if (aValue == nil) {
        aValue = @"";//为null时，直接赋空
    } else if ((NSNull *)aValue == [NSNull null]) {
        aValue = @"";
        if ([aValue isEqual:nil]) {
            aValue = @"";
        }
    }
    return aValue;
}
```

这个方法，可以把null和nil赋空值，这样字符串操作时，就不会崩了，同时，如果解析成数值，也可以改写为@0


<!--more-->


- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！


<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


