title: iOS的@try、@catch()
date: 2015-03-12 23:19:16
categories: technology #induction life poetry
tags: [iOS,try catch]  # <!--more-->
reward: true

---

### 1、前言
从性能来考虑。由于苹果手机cpu性能好，理论上OC使用try catch没有问题，可以捕捉到数组越界 空字条等。所谓性能损耗，我的理解最大就是电量，多做一个异常处理，计算就多一点，电量也损耗更多，这些都是积累下来的。所以，为什么要做内存优化，重构，算法设计，都是希望减少cpu计算量，好处自然多多～

<!--more-->

### 2、问题

```obj-c
NSArray *tabBarItems=self.tabBar.items;

NSArray * title = @[@"首页",@"分类",@"购物车",@"消息"];
@try {

    [tabBarItems enumerateObjectsUsingBlock:^(UITabBarItem * indexItem, NSUInteger idx, BOOL *stop) {

        indexItem.title=[title objectAtIndex:idx];

        indexItem.image=[UIImage imageNamed:[NSString stringWithFormat:@"menu_0%ld_normal",idx+1]];

        NSLog(@"%ld",idx);

    }];
}
@catch (NSException *exception) {

    NSLog(@"%@",@"有异常");
}
@finally {

    NSLog(@"%@",@"最后执行");
}
```

今天被同事问，所以学习了一下，为什么 ObjC 很少用 @try @catch

在网上搜索到知乎上的答案，总结一下：

1、@try@catch解决异常的能力强吗？

2、@try@catch对资源消耗多吗？

3、Cocoa开发者习惯了？

结果是：

解决问题能力不强，并造成额外的开销，所以很少用？

问题留给自己，有时间在考证～

nice~


### 总结

从客户端来说，崩溃和异常的处理，不崩溃，数据异常处理？


<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



