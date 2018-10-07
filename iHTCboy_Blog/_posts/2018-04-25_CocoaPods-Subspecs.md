title: CocoaPods Subspecs 子库
date: 2018-04-25 22:19:16
categories: technology #induction life poetry
tags: [CocoaPods,Subspecs,pod子库]  # <!--more-->
reward: true

---

### 1、前言

就像 `Git` 有 `Submodules`（子模块）共享库的代码，`CocoaPods` 也有 `Subspecs` （子库）的功能，用于共享库的部分代码。

### 2、Subspecs（子库）
#### 为什么要使用子库?
假设我们实现了一个完整的远程私有库 `BaseComponent`，可以升级，依赖其他的库，提供给其他人使用，但是现在还有一点问题，其他人如果要用我们的库，就需要把 `BaseComponent` 完整的克隆过来，但是他可能只需要 `BaseComponent` 里面的` Network`，其他的扩展、工具等并不想使用，也不想导入过来，怎么办？
有两种方案：

<!--more-->

- 把 `Network` 剥离出来，再单独建一个远程私有库；
- 使用子库迁出 `Network`；

第一种方案大家都知道了，麻烦不说，而且东西一多起来，这里一个库，那里一个库，也不容易管理，所以，下面就有请子库隆重登场~


#### 什么是子库？

使用 `pod search AFNetworking` 搜索 `AFNetworking` 时，可以发现AFNetworking有5个子库 `Subspecs`：

```
-> AFNetworking (3.1.0)
   A delightful iOS and OS X networking framework.
   pod 'AFNetworking', '~> 3.1.0'
   - Homepage: https://github.com/AFNetworking/AFNetworking
   - Source:   https://github.com/AFNetworking/AFNetworking.git
   - Versions: 3.1.0, 3.0.4, 3.0.3, 3.0.2, 3.0.1, 3.0.0, 3.0.0-beta.3, 3.0.0-beta.2,
   3.0.0-beta.1, 2.6.3, 2.6.2, 2.6.1, 2.6.0, 2.5.4, 2.5.3, 2.5.2, 2.5.1, 2.5.0, 2.4.1, 2.4.0,
   2.3.1, 2.3.0, 2.2.4, 2.2.3, 2.2.2, 2.2.1, 2.2.0, 2.1.0, 2.0.3, 2.0.2, 2.0.1, 2.0.0,
   2.0.0-RC3, 2.0.0-RC2, 2.0.0-RC1, 1.3.4, 1.3.3, 1.3.2, 1.3.1, 1.3.0, 1.2.1, 1.2.0, 1.1.0,
   1.0.1, 1.0, 1.0RC3, 1.0RC2, 1.0RC1, 0.10.1, 0.10.0, 0.9.2, 0.9.1, 0.9.0, 0.7.0, 0.5.1 [master
   repo]
   - Subspecs:
     - AFNetworking/Serialization (3.1.0)
     - AFNetworking/Security (3.1.0)
     - AFNetworking/Reachability (3.1.0)
     - AFNetworking/NSURLSession (3.1.0)
     - AFNetworking/UIKit (3.1.0)

```

- Subspecs:
     - AFNetworking/Serialization (3.1.0)
     - AFNetworking/Security (3.1.0)
     - AFNetworking/Reachability (3.1.0)
     - AFNetworking/NSURLSession (3.1.0)
     - AFNetworking/UIKit (3.1.0)

AFNetworking 划分5个子库，每个的功能都是相对独立的模块，这样一个库分解，不管是从设计还是开发，都是有利于框架和解耦。而如果只用其中的一些模板，则也非常方便，下面会详细讲解。


#### 子库怎么用？

可以一次只引用一个子库：

```
pod 'AFNetworking/Security'  
```

也可以这样指定多个子库：

```
pod 'AFNetworking', :subspecs => ['Security', 'Reachability']
```

#### 怎么创建子库？

- AFNetworking.podspec 示例：

```
Pod::Spec.new do |s|
  s.name             = 'AFNetworking'
  s.version          = '3.1.0'
  s.summary          = 'A delightful iOS and OS X networking framework.'
  s.homepage         = 'https://github.com/AFNetworking/AFNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mattt Thompson': 'm@mattt.me' }
  s.source           = { :git => 'https://github.com/AFNetworking/AFNetworking.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc     = true
  s.dependency 'MobileCoreServices'
  s.dependency 'CoreGraphics'
  s.source_files = 'AFNetworking/AFNetworking.h'
  s.public_header_files = 'AFNetworking/AFNetworking.h'
  s.frameworks = 'UIKit', 'Foundation'

  s.subspec 'Serialization' do |ss|
	  ss.ios.source_files = 'AFNetworking/AFURL{Request,Response}Serialization.{h,m}'
	  ss.ios.public_header_files = 'AFNetworking/AFURL{Request,Response}Serialization.h'
	  ss.dependency 'MobileCoreServices'
	  ss.dependency 'CoreGraphics'
  end

  s.subspec 'Security' do |ss|
	  ss.ios.source_files = 'AFNetworking/AFSecurityPolicy.{h,m}'
	  ss.ios.public_header_files = 'AFNetworking/AFSecurityPolicy.h'
  end

  s.subspec 'Reachability' do |ss|
	  ss.ios.source_files = 'AFNetworking/AFNetworkReachabilityManager.{h,m}'
	  ss.ios.public_header_files = 'AFNetworking/AFNetworkReachabilityManager.h'
  end
  ...
  ...
end
```
- 创建多个Subspecs（Subspecs with different source files.）:

```
subspec 'Twitter' do |st|
  st.source_files = 'Classes/Twitter'
end

subspec 'Pinboard' do |sp|
  sp.source_files = 'Classes/Pinboard'
end
```

- Subspecs里又依赖于其他subspecs。(Subspecs referencing dependencies to other subspecs.):

```
Pod::Spec.new do |s|
  s.name = 'RestKit'

  s.subspec 'Core' do |cs|
    cs.dependency 'RestKit/ObjectMapping'
    cs.dependency 'RestKit/Network'
    cs.dependency 'RestKit/CoreData'
  end

  s.subspec 'ObjectMapping' do |os|
  end
end
```

- 嵌套的subspecs。(Nested subspecs.)

```
Pod::Spec.new do |s|
  s.name = 'Root'

  s.subspec 'Level_1' do |sp|
    sp.subspec 'Level_2' do |ssp|
    end
  end
end
```

#### 注意事项

1.pod下来的`Pods`目录下的库，不在以真实的文件夹区分子库，只会显示全部的源代码文件：
    ![20180425-Pods-AFNetworking.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180425-Pods-AFNetworking.png)

2.如果使用子库方式 pod 下来，那么那些没有未分到子库的源代码文件不会 pod 到项目中，如果需要使用必须放到一个子库中，或者整个库 pod 下来。

3.子库下的目录文件包含关系，是否遍历子路径的问题
![20180425-subPod.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180425-subPod.png)

### 3、总结

`CocoaPods` 是一个非常强大的iOS库管理工具，所以能满足大多数框架开发下的业务逻辑的功能，另外，项目随着时间和开发迭代，越来越庞大，而公司可能有新业务，而底层公共功能接口是一样的。此时，为了快速开发，子库的作用是非常明显的。`CocoaPods`  是用 `Ruby` 开发的，所以，有时候还是学习一下，这对于理解 `CocoaPods`  非常有帮助，也能自主修改`CocoaPods` 功能，任重路远，加油~



### 参考扩展
- [CocoaPods Guides subspec - Podspec Syntax Reference <span>v1.2.0.beta.1</span>](https://guides.cocoapods.org/syntax/podspec.html#subspec)
- [你真的会用 CocoaPods 吗 - 简书](https://www.jianshu.com/p/5d871ae4d7c6)
- [使用CocoaPods进行Xcode的项目依赖管理 - Cocoa开发者](http://www.iliunian.cn/14332613205128.html)
- [Git submodule 使用 ←](http://ntop001.github.io/2014/05/29/Git-Submodule/)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
