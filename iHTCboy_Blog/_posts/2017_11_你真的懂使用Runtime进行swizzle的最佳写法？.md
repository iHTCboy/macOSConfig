title: 你真的懂使用Runtime进行swizzle的最佳写法？
date: 2017-11-18 21:15:16
categories: technology #life poetry
tags: [Runtime,swizzle]  # <!--more-->
reward: true

---

### 前言

runtime 的黑魔法很多人都一定听过，或者已经在使用了。但是，怎么swizzle方法才是最好呢？


### 一般写法

```
Method originalMethod = class_getInstanceMethod(aClass, originalSel);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSel);
    method_exchangeImplementations(originalMethod, swizzleMethod);
```

或者是下面这种方式，swizzle第二种写法:

```
   Method originalMethod = class_getInstanceMethod(aClass, originalSel);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSel);
    BOOL didAddMethod = class_addMethod(aClass, originalSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass, swizzleSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
```

### 更好写法
其它，这样写，一般不会有问题，但是在一些情况下，比如这个hook的类没有实现你要swizzle的方法，这时是没有swizzle成功的，然后你自己写的 swizzle 里又自己调用自己，就无限循环。

<!--more-->

```
    Method originalInsMethod = class_getInstanceMethod(class, originalSelector);
    // 处理为实例方法
    if (originalInsMethod)
    {
        method_exchangeImplementations(originalInsMethod, swizzledMethod);
    }else{
        // 处理为类方法
        Method originalClassMethod = class_getClassMethod(class, originalSelector);
        if (originalClassMethod)
        {
            method_exchangeImplementations(originalClassMethod, swizzledMethod);
        }else{
            // 如果hook的类没有实现这个方法，则先添加方法，然后设置方法的IMP为一个空block。否则直接class_replaceMethod，则方法实则没有交接
            class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
            method_setImplementation(swizzledMethod, imp_implementationWithBlock(^(id self, SEL _cmd){}));
        }
    }
```


### 总结
至于这个为什么会更好？ 有时间在慢慢说啦~ 

### 参考
- [利用ios的hook机制实现adobe air ios ane下appdelegate的动态替换 - CSDN博客](http://blog.csdn.net/ashqal/article/details/40979353)
- [Method结构, SEL, IMP理解 - Vanbein's Blog](http://www.vanbein.com/posts/ios进阶/2015/12/10/sel/)
- [深入理解 Objective-C 的方法调用流程 - 简书](http://www.jianshu.com/p/114782a909f9)
- [[iOS]在运行时为类添加方法](http://longtimenoc.com/archives/ios在运行时为类添加方法)
- [Runtime中Swizzle时你可能没注意到的问题 - 简书](http://www.jianshu.com/p/1bacd182329f?utm_campaign=hugo&utm_medium=reader_share&utm_content=note)
- [Hello World](https://github.com/iHTCboy/HelloWorld)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


