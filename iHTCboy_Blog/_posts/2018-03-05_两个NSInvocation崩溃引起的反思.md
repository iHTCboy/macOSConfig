title: 两个NSInvocation崩溃引起的反思
date: 2018-03-05 23:42:26
categories: technology #life poetry
tags: [iOS,NSInvocation,NSMethodSignature]  # <!--more-->
reward: true

---

### 1、前言
最近在使用NSInvocation进行多参数方法调用，结果就崩溃了！signature为nil 和 一直提示找不到方法！！！

`method signature argument cannot be nil` 崩溃信息：
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '+[NSInvocation _invocationWithMethodSignature:frame:]: method signature argument cannot be nil'
*** First throw call stack:
(0x1831a6d8c  .........)
libc++abi.dylib: terminating with uncaught exception of type NSException
```

`unrecognized selector sent to instance`崩溃信息：
```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[ViewController openView]: unrecognized selector sent to instance 0x10510b1b0'
*** First throw call stack:
(0x1831a6d8c ......)
libc++abi.dylib: terminating with uncaught exception of type NSException
```

<!--more-->

开始的代码：

```
- (void)myInvocation {
    
    SEL myMethod = @selector(sum:parm:parm:);
    //创建一个函数签名，这个签名可以是任意的,但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature * sig  = [[self class] instanceMethodSignatureForSelector:myMethod];
    //通过签名初始化
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    //设置target
    [invocatin setTarget:self];
    //设置selecteor
    [invocatin setSelector:myMethod];

    int a=1;
    int b=2;
    int c=3;
    /*
     //index为2 是因为0、1两个参数已经被target和selector占用，其实可以这样设置：
     ViewController * view = self;
     [invocatin setArgument:&view atIndex:0];
     [invocatin setArgument:&myMethod atIndex:1];
     */
    [invocatin setArgument:&a atIndex:2];
    [invocatin setArgument:&b atIndex:3];
    [invocatin setArgument:&c atIndex:4];
    [invocatin retainArguments];
    //我们将c的值设置为返回值
    [invocatin setReturnValue:&c];
    int d;
    //取这个返回值
    [invocatin getReturnValue:&d];
    NSLog(@"%d",d);

    //消息调用
    [invocatin invoke];
    
}

+ (int)sum:(int)a parm:(int)b parm:(int)c{
    NSLog(@"sum: %d:%d:%d",a,b,c);
    return a+b+c;
}

```

### 2、NSInvocation 注意项
一直排查，开始以为是方法名写错了，认真一个一个字检查，没有错哦！！
Way?! 

不得而，还是在看看苹果文档！！！

---

**instanceMethodSignatureForSelector:**
```
+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector;
```
>Returns an NSMethodSignature object that contains a description of the instance method identified by a given selector.

---

**methodSignatureForSelector:**
```
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
```
>Returns an NSMethodSignature object that contains a description of the method identified by a given selector.

---

#### 2.1 崩溃一 分析：
从苹果文档可以看到，生成NSMethodSignature对象有2个方法，一个是实例方法和一个类方法。

- 如果SEL是类方法要使用 **methodSignatureForSelector:**，
- 如果SEL是实例方法就使用 **instanceMethodSignatureForSelector:**

所以，把`instanceMethodSignatureForSelector:` 改为`methodSignatureForSelector ` 就解决啦！

#### 2.2 崩溃二 分析：
有了上面的分析，崩溃二是因为 `setTarget:`使用实例self，而类方法应用使用类，所以修改为`[invocatin setTarget:[self class]];`，就解决啦！


#### 2.3 最终代码：
```

- (void)myInvocation {
    
    SEL myMethod = @selector(sum:parm:parm:);
    //创建一个函数签名，这个签名可以是任意的,但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature * sig  = [[self class] methodSignatureForSelector:myMethod];
    //通过签名初始化
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    //设置target
    [invocatin setTarget:[self class]];
    //设置selecteor
    [invocatin setSelector:myMethod];

    int a=1;
    int b=2;
    int c=3;
    /*
     //index为2 是因为0、1两个参数已经被target和selector占用，其实可以这样设置：
     ViewController * view = self;
     [invocatin setArgument:&view atIndex:0];
     [invocatin setArgument:&myMethod atIndex:1];
     */
    [invocatin setArgument:&a atIndex:2];
    [invocatin setArgument:&b atIndex:3];
    [invocatin setArgument:&c atIndex:4];
    [invocatin retainArguments];
    //我们将c的值设置为返回值
    [invocatin setReturnValue:&c];
    int d;
    //取这个返回值
    [invocatin getReturnValue:&d];
    NSLog(@"%d",d);

    //消息调用
    [invocatin invoke];
    
}

+ (int)sum:(int)a parm:(int)b parm:(int)c{
    NSLog(@"sum: %d:%d:%d",a,b,c);
    return a+b+c;
}

```

### 3、总结
出现这样一个问题，直接说明平时没有关注文档和API实现，当前NSInvocation不常用，但是这次排查也用半天时间，有时候怀疑自己代码时，还是要从根本上找原因——— 从官方文档重新开始！ 

另外，复制网上的代码是一个危险的动作，不求甚解有时候坑就越深，希望自己以后不懂的知识要使用时，除了工期赶&复制，还要及时补充自己的空白，知其码，并知其然！努力成为一个优秀工程师！严谨！

### 4、参考引用
- [objective c - How can I invoke a class method by NSInvocation? - Stack Overflow](https://stackoverflow.com/questions/10900403/how-can-i-invoke-a-class-method-by-nsinvocation)
- [NSInvocation - Foundation | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/nsinvocation)
- [methodSignatureForSelector: - NSObject | Apple Developer Documentation](https://developer.apple.com/documentation/objectivec/nsobject/1571960-methodsignatureforselector?language=objc)
- [instanceMethodSignatureForSelector: - NSObject | Apple Developer Documentation](https://developer.apple.com/documentation/objectivec/nsobject/1571959-instancemethodsignatureforselect?language=objc)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

