title: iOS快速枚举中stop注意事项
date: 2015-12-17 08:03:26
categories: technology #life poetry
tags: [快速枚举,enumerate,BOOL * stop]  # <!--more-->
reward: true
---

最近有一个需要，只存储服务器返回数组里最多3个照片，所以遍历数时需要做一个判断：

### 1.版本1

```
  [picArray enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx >2) *stop = YES;//最多3张照片
           [pics addObject:[dic objectForKey:@"picture"]];
  }];

```

<!--more-->

### 2.版本2

```
 [picArray enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL * _Nonnull stop) {
                [pics addObject:[dic objectForKey:@"picture"]];
                if(idx >2) *stop = YES;//最多3张照片
  }];

```

### 3.版本3

```
 [picArray enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL * _Nonnull stop) {
          if(idx >1) *stop = YES;//最多3张照片                
          [pics addObject:[dic objectForKey:@"picture"]];
          //也可以写在这里 if(idx >1) *stop = YES;//最多3张照片
  }];

```

### 注意点
大家看懂了吗，*stop＝ YES；时，不会马上结束本次遍历，还会执行下面的代码。



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

