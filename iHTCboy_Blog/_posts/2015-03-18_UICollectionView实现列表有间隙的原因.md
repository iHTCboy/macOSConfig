title: UICollectionView实现列表，有'非法'间距的原因
date: 2015-03-18 23:24:16
categories: technology #induction life poetry
tags: [iOS,UICollectionView]  # <!--more-->
reward: true

---

### 1、前言
今天用CollectionView实现的列表效果不理想，UICollectionView实现列表有间隙，开始一直找不知道问题出现在那里。

<!--more-->

### 2、问题

![2015-03-18-CollectionView-margin.PNG](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/03/2015-03-18-CollectionView-margin.PNG)

有间距，但不属于cell的高度
改变下面2个方面也不行：


```obj-c
//定义每个UICollectionViewCell 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(80,80);
    return size;

｝

//定义每个Section 的上左下右的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、右

}
```

最后才明白，那个间距是cell之间的间距（通过设置背景色发现的-.-），要另外设置：


```obj-c
//这个是两行之间的间距（上下cell间距）
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

//这个方法是两个之间的间距（同一行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

```

也可以用在这个layout设置为0：


```obj-c
UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
layout.minimumLineSpacing = 0.0f;
```

最后实现效果，至于原理，为什么苹果会自动给间距呢？我理解是因为，collection本来就是用来做一个分视图的效果的，所以默认留20的间距吧。（因为要实现一个流水式的热点关键字布局，所以用collectionView，合理吗？(其实，UI布局没有合理不合理，只要满足需求就可以，另外方便后续扩展也是很重要啊。)）

没有间距的效果:
![2015-03-18-CollectionView.PNG](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2015/03/2015-03-18-CollectionView.PNG)


<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



