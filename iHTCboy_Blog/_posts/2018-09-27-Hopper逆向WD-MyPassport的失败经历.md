title: Hopper Disassembler 逆向西数硬盘 WD My Passport 的失败经历
date: 2018-09-27 21:49:16
categories: technology #induction life poetry
tags: [Hopper,Disassembler,西数硬盘,WD,MyPassport]  # <!--more-->
reward: true

---

### 1、前言
一直以来都是使用西数的移动硬盘，最开始256G的 `My Passport`，当时也不知道，在电脑城就买了，回家发现可以设置密码，当然，我记得有密码的存储设备，是台电的U盘，当年16G的加密U盘，我也买了3个（因为当年最大16G容量），所以，之后就与加密的存储设备相惜相爱，现在西数的移动硬盘也是几代后的AES 256位硬件加密。加密功能的存储设备越来越受喜爱，除了大部分网盘破产外，就是隐私的问题，大家都希望有自己的小空间。

几天前，购买了4T的 WD My Passport 加密移动硬盘，设置了一个新密码，然后过完中秋，发现！密码记不起来了！！！反复尝试，只能看到破解！！！

<!--more-->

### 2、怎么办？

先说一下，WD怎么打开硬盘，密码位数不限制，字符、数字和特殊符号都可以，然后，只能点击界面上的 `硬盘解锁` 才能解锁。按回车没有反应：

![20180927-WD-unlock-drive.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-WD-unlock-drive.jpg)

如果尝试密码超过5次，只能把USB拨出，重新插入才能重新尝试：

![20180927-WD-unlock-drive-max.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-WD-unlock-drive-max.jpg)


知道了这个流程，就想到几个思路，找到点击`硬盘解锁` 点击的处理方法，返回成功就可以了？

Hopper Disassembler ：

![20180927-WD-unlock-drive-hopper.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-WD-unlock-drive-hopper.jpg)

从上面的图片，可以找到这个方法，非常明显示了！

然后打开伪代码界面，里面的第一个判断是，如果 `rax==0x7` ，就会进入到失败的逻辑处理中，所以这样要修复它为不等于（!=），下面在说怎么修改：
![20180927-hopper-processUnlockDrive-if1.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-hopper-processUnlockDrive-if1.jpg)

下面这个判断是 如果 `rax==0x6` ，就是密码正确，可以打开硬盘！
![20180927-hopper-processUnlockDrive-if2.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-hopper-processUnlockDrive-if2.jpg)

下图，可以看出`cmp eax, 0x7`，就是上面说的比较是否相等，因此选中`cmp eax, 0x7`一行，选择菜单栏 `Modify -> Assemble Instruction`，然后后面的0x7为其它值，这样就不相等了
![20180927-hopper-processUnlockDrive-fix1.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-hopper-processUnlockDrive-fix1.jpg)

然后，这个也是相似，如果要让他相等，那么这个值改为`0x7`，因为失败时就是走上一个if判断中了，所以改一下这个值指向，应该就可以相等了吧？
![20180927-hopper-processUnlockDrive-fix2.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-hopper-processUnlockDrive-fix2.jpg)

最后，选择 `File -> Produce New Executable` 来生成新的可执行文件，替换掉原来的文件即可。

![20180927-hopper-processUnlockDrive-copy-new.jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180927-hopper-processUnlockDrive-copy-new.jpg)

但是，想复制新的可执行文件替换失败：`Read-only file system`！！！

最后，查了一些方法，也没有办法修改这个硬盘的这个目录属性，唉，这个方法不知道有没有效果？？？ 最后，还是乱输入时，记起了密码！！！然后就没有然后了。

剩下的，就看大家有能力的，来补充一下啊~ 或者，若干年后有能力罢。

### 总结

总结。西数硬盘这个5次失败密码要重新链接的功能，让破解密码变得复杂，当然，能一直尝试密码也是有好处，也是弱处。

最后，发现会一点逆向技术，不管是正向的开发，还是逆向的开发，都会对提高自己开发的系统的安全性，有更好的思考！！！另外，真的需要有时候，回来学习一下汇编语言，是提高逆向内功的必经之路，在这里，先立个目录，回头尝尝，大家一起加油~ 监督！

### 参考
- [最简单的Hopper Disassembler玩转Mac逆向 - 简书](https://www.jianshu.com/p/c04ac36c6641)
- [iOS安全–使用Hopper修改程序逻辑跳过验证](http://www.blogfshare.com/ioss-hopper.html)
- [一个数字的魔法——破解Mac上198元的Paw](https://bestswifter.com/app-crack/)
- [Mac OSX 之自己动手初步学习破解软件入门 - 简书](https://www.jianshu.com/p/33e40af6e328)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



