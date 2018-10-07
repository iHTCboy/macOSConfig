title: NSString的boolValue方法甚解
date: 2018-03-11 21:22:26
categories: technology #life poetry
tags: [iOS,NSString,boolValue]  # <!--more-->
reward: true

---

### 1、前言
NSString的`boolValue`之前有使用，但是一直没有真正了解什么时候返回YES（true）或NO(false)。其实，苹果在官方文档中已经写的很清楚，按`command` + `control` 点击`boolValue`进入文档就可以看到：
 
>
>**boolValue**
>The Boolean value of the string.
>
>
>**Declaration**
>@property(readonly) BOOL boolValue;
>
>**Discussion**
>This property is YES on encountering one of "Y", "y", "T", "t", or a digit 1-9—the method ignores any trailing characters. This property is NO if the receiver doesn’t begin with a valid decimal text representation of a number.
The property assumes a decimal representation and skips whitespace at the beginning of the string. It also skips initial whitespace characters, or optional -/+ sign followed by zeroes.

 <!--more-->

**中文意思**:
>字符串中包含“Y”，“y”，“T”，“t”，或1-9的数字开关时，这个属性值为YES。
>
>如果不是以有效的十进制数字开始的文本表示，则此属性为NO。
>
>该属性采用十进制表示法，并在字符串的开头跳过空格。它也会跳过最初的空格字符（忽略全部的空格开头），或者单个 -/+ 符号开头。


### 2、测试一波
大家可以思考一下，下面的代码输出结果是什么？

```
NSArray *tests = @[ @"Y",
                        @"N",
                        @"T",
                        @"F",
                        @"t",
                        @"f",
                        @"1",
                        @"0",
                        @"Yes",
                        @"No",
                        @"No really no",
                        @"true",
                        @"false",
                        @"To be or not to be",
                        @"False",
                        @"3567",
                        @"0123456789",
                        @"000",
                        @"0ab",
                        @"1cd",
                        @"abc",
                        @"",
                        @"+aeb",
                        @"+3sb",
                        @"-ss",
                        @"-01",
                        @"-21",
                        @" 1",
                        @" 0",
                        @"--1",
                        @"++1",
                        @"-+1",
                        @"  2",
                        @"  0",
                        @"   2  0",
                        @"   0  2",
                        @"  20",
                        @"000-1",
                        @" + 111",
                        @"  +111"
                        ];
    NSArray *boolToString = @[@"NO", @"YES"];
    
    for (NSString *test in tests){
        NSLog(@"boolValue:\"%@\" => %@", test, boolToString[[test boolValue]]);
    }
```

### 3、结果
运行结果：

```
boolValue:"Y" => YES
boolValue:"N" => NO
boolValue:"T" => YES
boolValue:"F" => NO
boolValue:"t" => YES
boolValue:"f" => NO
boolValue:"1" => YES
boolValue:"0" => NO
boolValue:"Yes" => YES
boolValue:"No" => NO
boolValue:"No really no" => NO
boolValue:"true" => YES
boolValue:"false" => NO
boolValue:"To be or not to be" => YES
boolValue:"False" => NO
boolValue:"3567" => YES
boolValue:"0123456789" => YES
boolValue:"000" => NO
boolValue:"0ab" => NO
boolValue:"1cd" => YES
boolValue:"abc" => NO
boolValue:"" => NO
boolValue:"+aeb" => NO
boolValue:"+3sb" => YES
boolValue:"-ss" => NO
boolValue:"-01" => YES
boolValue:"-21" => YES
boolValue:" 1" => YES
boolValue:" 0" => NO
boolValue:"--1" => NO
boolValue:"++1" => NO
boolValue:"-+1" => NO
boolValue:"  2" => YES
boolValue:"  0" => NO
boolValue:"   2  0" => YES
boolValue:"   0  2" => NO
boolValue:"  20" => YES
boolValue:"000-1" => NO
boolValue:" + 111" => NO
boolValue:"  +111" => YES
```

### 4、总结
不知道大家答对多少？是不是对这个方法又熟悉了几分呢？实践见真知。

### 5、参考引用
- [[NSString boolValue]-Manbolo Blog](http://blog.manbolo.com/2013/07/22/nsstring-boolvalue)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

