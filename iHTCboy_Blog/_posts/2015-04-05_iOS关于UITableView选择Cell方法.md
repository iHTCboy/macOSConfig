title: iOS关于UITableView选择Cell方法
date: 2015-04-05 22:49:16
categories: technology #induction life poetry
tags: [iOS,UITableView]  # <!--more-->
reward: true

---

### 1、问题

选择cell有两个方法，今天搞错了，一直以为cell错乱呢，真是人都有掉坑的时候：

```objective-c
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

```

<!--more-->

下次发现选择cell时，“错乱”一定要不惊啊！-_-!

~nice

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



