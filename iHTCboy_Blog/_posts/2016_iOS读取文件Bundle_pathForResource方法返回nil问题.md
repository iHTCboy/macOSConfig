title: iOS读取文件Bundle pathForResource方法返回nil问题
date: 2016-11-29 17:19:16
categories: technology #life poetry
tags: [iOS,Bundle,pathForResource]  # <!--more-->
reward: true
---

### 检查代码
``` 
oc:
    NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"wakeup" ofType:@"caf"]; 
    NSLog(@"soundPath:%@", soundPath); 

swift 3.0:
    let audioFile = Bundle.main.path(forResource: "frogs.m4a", ofType: nil)
    print(audioFile)     
```

代码反复看了，clear工程n次，手机删掉项目n次，还是返回空，然后测试了一些pdf，png，mp3文件有路径返回，瞬间晕倒了

<!--more-->

### 问题所在

**音频文件没有包含到项目资源中**，手工添加就可以了！

![音频文件没有包含到项目资源中](http://upload-images.jianshu.io/upload_images/99517-eb7306ade72d3b02.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 总结
这种问题，不是代码多好多好就可以，一个问题，不只是知识点问题，可能对知识抱有怀疑，可以查正，如果发现查不到，然后这个问题是出在工具上，如果我直接新建一个工程，然后没有问题了就不管了，如果没有从根源上解决，下次出现也不能解决，这就是经验。



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

