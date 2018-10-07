title: 用autolyout实现子视图对齐等宽排列
date: 2015-07-26 11:39:16
categories: technology #life poetry
tags: [iOS,autolyout]  # <!--more-->
reward: true
---

### 最终效果
![实现效果](http://upload-images.jianshu.io/upload_images/99517-66081191ebae4e87.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

<!--more-->

### IB中实现
![组成部分](http://upload-images.jianshu.io/upload_images/99517-9762ef1fef287ae3.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

其实，要让三个button三等分，那么一定要找一个view作为参考，所以我在底部加了一个bottomLine（``距离左边0，距离右边40，距离底部0，高度为1``），重要的是，我设置为``隐藏``。那么，分别让每个button等于bottomLine的三分之一，那么就等分了。

![三分之一的约束](http://upload-images.jianshu.io/upload_images/99517-1dd78a282185b576.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)

当然，三分之一的约束只是约束了每一个button的``宽度``，位置、高度，还要另外针对每一个设置，比如最左边的上架时间（约束：``距离左边0，距离顶部0，距离底部0``），其它同理之。

最后，三条竖线，位置分别距离左边button为0，顶部、底部留距离，宽度设置为1，设置一个灰色背影就行。
![三条竖线约束](http://upload-images.jianshu.io/upload_images/99517-12ba2c68cbb5122b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1240)


### 用代码实现约束
有了上面的思路，用代码实现应该也是一样的，用Masonry来写约束吧，代码就不写了（Swift还在学，不敢教）。


- 如果有什么疑问，可以在评论区一起讨论；
- 如果有什么不正确的地方，欢迎指导！



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

