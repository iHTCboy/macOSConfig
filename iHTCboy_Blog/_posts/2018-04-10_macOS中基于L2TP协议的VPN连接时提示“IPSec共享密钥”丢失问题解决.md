title: macOS中基于L2TP协议的VPN连接时提示“IPSec 共享密钥”丢失问题解决
date: 2018-04-10 18:59:26
categories: technology #life poetry
tags: [macOS,vpn,IPsec,PPP]  # <!--more-->
reward: true

---

### 1、遇到的问题

>“IPSec 共享密钥”丢失。请验证您的设置并尝试重新连接。

![20180410-VPNConnetionFailure.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180410-VPNConnetionFailure.png)


在网上找到很多相似的解决方法，但是却没有人说出为什么要这样做？？

<!--more-->

### 2、问题原因&解决

#### 2.1 原因：
最后在Oracle官方文档找到了解释：

引用 **Oracle Solaris 10 8/11 Information Library** 文档:
> /etc/ppp/options
包含缺省应用于系统中所有 PPP 链路的特征（例如，计算机是否要求对等点对其本身进行验证）的文件。如果不存在此文件，将禁止非超级用户使用 PPP。

也就是说，默认情况下macOS跟Liunx一样，在`/etc/ppp/`目录下没有 `options`这个配置文件，所以对于非root用户就无法使用ppp链路。


#### 2.2 解决
知其然，所以知其后然，这时候的解决方法就是在`/etc/ppp/`目录下建立options`这个配置文件，并且配置ppp链路l2tp不需要ipsec密钥。

下面就是vim命令操作，如果想系统学习相关命令可查看 [每天一个linux命令目录](http://www.cnblogs.com/peida/archive/2012/12/05/2803591.html)，这里不打算详细讲解，有兴趣同学可以另行学习。

**2.2.1 操作步骤**
（1）在终端任意路径下输入命令： `sudo vim /etc/ppp/options`
然后输入电脑密码后，显示vim操作界面后按键盘`i`进入插入模式，输入下面内容：
```
plugin L2TP.ppp
l2tpnoipsec
```
（2）然后按`esc`键退出插入模式，最后输入`:wq!`，强制保存并退出vim模式。


**2.2.2 命令解释**
- `sudo`：用管理员权限执行命令
- `vim`：用vim打开文件，后面跟上文件所在的路径
- `plugin L2TP.ppp`：配置ppp链路插件？具体暂未了解，知道的同学可以告诉我啊！
- `l2tpnoipsec `: 配置ppp链路l2tp不需要ipsec密钥。

**2.2.3 终端操作示意**
![sudo vim /etc/ppp/options](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180410-SudoVim-etc-ppp-options.png)

![添加ppp的options配置文件](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180410-vim-options-insert.png)

![保存内容并退出vim](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180410-vim-wq!.png)

最后，想验证是否保存成功，可以用`open /etc/ppp/options`命令打开文件查看内容：
![打开options文件查看内容](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/04/20180410-open-options.png)

### 3、总结
在这个探索的过程，自己了解得更多，就会发现自己知道的越少！求甚解，也许就是最好的学习态度，大家都要坚持！

### 4、参考引用
- [在文件中和命令行上使用 PPP 选项 - 系统管理指南：网络服务](https://docs.oracle.com/cd/E24847_01/html/E22299/pppsvrconfig.reference-65.html)
- [Mac OS X 下无密钥方式连接基于L2TP协议的VPN](https://lxneng.com/posts/177)
- [mac的vpn配置“IPSec 共享密钥”丢失问题 - 简书](https://www.jianshu.com/p/6bbfbc49e54c)
- [Mac 笔记本无共享密钥连接L2TP VPN-我的运维历程-51CTO博客](http://blog.51cto.com/nginxs/1714806)
- [Mac OSX 无共享的密钥情况下连接基于L2TP协议的VPN « jiangrongyong's Blog](http://jiangrongyong-blog.logdown.com/posts/2013/06/14/osx-vpn-l2tp)
- [Mac OSX 无共享的密钥情况下连接基于L2TP协议的VPN | micmiu - 软件开发+生活点滴](http://www.micmiu.com/os/mac/mac-osx-vpn-l2tp/)
- [每天一个linux命令目录 - peida - 博客园](http://www.cnblogs.com/peida/archive/2012/12/05/2803591.html)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源


