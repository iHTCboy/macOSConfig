title: shell技巧4 - nm命令解决AppStore2.5.2被拒问题
date: 2018-09-16 22:20:16
categories: induction #technology life poetry
tags: [shell,bash,nm,AppStore,Guideline2.5.2] # <!--more-->
reward: true

---


### 1、前言

最近App Store审核被拒，`2. 5 Performance: Software Requirements，Guideline 2.5.2 - Performance - Software Requirements`，遇到这样的问题，回信问苹果，肯定得不到答案，苹果就是`礼貌`的回复。经过一个星期的重复被拒，只能自己找问题，热更新问题，苹果拒审信一直长这样：

> ....
>This code, combined with a remote resource, can facilitate significant changes to your app’s behavior compared to when it was initially reviewed for the App Store. While you may not be using this functionality currently, it has the potential to load private frameworks, private methods, and enable future feature changes. This includes any code which passes arbitrary parameters to dynamic methods such as dlopen(), dlsym(), respondsToSelector:, performSelector:, method_exchangeImplementations(), and running remote scripts in order to change app behavior and/or call SPI, based on the contents of the downloaded script. Even if the remote resource is not intentionally malicious, it could easily be hijacked via a Man In The Middle (MiTM) attack, which can pose a serious security vulnerability to users of your app.
>  ...


从中找到了一些关键点：

```
 dlopen(), dlsym(), respondsToSelector:, performSelector:, method_exchangeImplementations(),
```

然后在 [「iOS」热更新审核被拒的解决方法](https://zhuanlan.zhihu.com/p/41863648) 文章中，找到可以打印下第三方的.a文件看看，看有没有 dlopen(), dlsym()，命令行：

``` shell
nm -u libwechaat.a >> xxx.txt
```

注：`nm -u path`：Display only undefined symbols。更多 `nm` 命令可查看我之前总结的文章 [Mac查看文件内容常用的命令小结](https://ihtcboy.com/2018/02/04/2018-02-04_Mac查看文件内容常用的命令小结/)

<!--more-->

### 2、定位和查到问题

找到了方向，就是利用 `nm` 命令查到所有第三方的 `.a` / `.framework`是否有相关的方法。

但是如果一个一个库用`nm`命令去查找，效率非常低，而且每一个库的目录不一样，所以，想到用sehll脚本，整个工程遍历全部的文件，查到到库的，然后打印出来！这才是万利的方法啊！！


### 3、shell 编程

这里思路大家应该也想到，就是遍历目录，一个一个文件判断，问题的关键出来了！就是怎么判断一个文件是不是`.a` 或 `.framework` ？ 

其实，可以利用 `file` 打印当前读取的文件的类型，如果是 `Mach-O` 类型，就是库文件。比如终端执行 `file libWeChatSDK.a` 会打印如下：

```objc
libWeChatSDK.a: Mach-O universal binary with 5 architectures: [i386:current ar archive] [arm64]
libWeChatSDK.a (for architecture i386):	current ar archive
libWeChatSDK.a (for architecture armv7):	current ar archive
libWeChatSDK.a (for architecture armv7s):	current ar archive
libWeChatSDK.a (for architecture x86_64):	current ar archive
libWeChatSDK.a (for architecture arm64):	current ar archive

```

然后用管道 `grep` 查找 'Mach-O' 关键字，如果存在，就执行 `nm -u file_path` 查看所有的方法，最后通过 `grep -E 'dlopen|method_exchangeImplementations|performSelector|respondsToSelector|dlsym'` 查找包含匹配 `dlopen` `method_exchangeImplementations` `performSelector` `respondsToSelector` `dlsym` 其中一个关键字就算包含，最后打印出包含的字段和路径。


最后，在终端执行脚本 `sh nm_find.sh ` 就会得到下面的检查结果，非常的方便和高效！

```
================================================
 Enter project path: /Users/HTC/Desktop/ThirdSDK 
-----------------------------

/Users/HTC/Desktop/ThirdSDK/Adjust/Adjust-4.12.3/AdjustSdk.framework/AdjustSdk
包含字段：
U _dlsym

-----------------------------

/Users/HTC/Desktop/ThirdSDK/Chartboost/Chartboost-v6.0.1/Chartboost.framework/Chartboost
包含字段：
U _method_exchangeImplementations U _dlopen U _dlsym

-----------------------------

/Users/HTC/Desktop/ThirdSDK/Facebook/Facebook/FBSDKCoreKit.framework/FBSDKCoreKit
包含字段：
U _dlopen U _dlsym


-----------------------------

/Users/HTC/Desktop/ThirdSDK/Firebase/Crashlytics/Crashlytics.framework/submit
包含字段：
_class_respondsToSelector _dlsym

```

![20180916-nm-show-lists.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180916-nm-show-lists.png)


### 4、源代码

具体的代码，也可参考我的Github代码：
-  [iHTCboy/iShell: Shell脚本编程技巧，总结一些常用的提高效率的方法。](https://github.com/iHTCboy/iShell)

```shell
#!/bin/bash

# 定义用到的变量
project_path=""

# 定义读取输入字符的函数
function getProjectPath() {
	# 输出换行，方便查看
	echo "================================================"
	# 监听输入并且赋值给变量
	read -p " Enter project path: " project_path
	# 如果为空值，从新监听
	if test -z "$project_path"; then
		getProjectPath
	else
		read_dir ${project_path}
	fi
}

function read_dir(){
	for file in `ls $1`       #注意此处这是两个反引号，表示运行系统命令
	do
		if [ -d $1"/"$file ]  #注意此处之间一定要加上空格，否则会报错
		then
			read_dir $1"/"$file
		else
			#在此处处理文件即可
			file_path="$1/$file"
			if `file ${file_path} | grep -q 'Mach-O'` ; then
				find_world=$(echo `nm -u ${file_path} | grep -E 'dlopen|method_exchangeImplementations|performSelector|respondsToSelector|dlsym'`)
				# -n 字符串	字符串的长度不为零则为真
				if [ -n "$find_world" ] ; then
					echo '-----------------------------\n'
					echo ${file_path}
					echo '包含字段：'
					echo ${find_world}
					echo '\n'
				fi
			fi
		fi
	done
}   

#读取第一个参数
getProjectPath

echo "------- end processing -------"
```

### 5、总结

最后，我们把这个脚本输出的全部内容截图，和这些第三方SDK的相关官网链接贴到回信中，告诉苹果审核员，我们应用不存在非法使用热更新 ` such as dlopen(), dlsym(), respondsToSelector:, performSelector:, method_exchangeImplementations()` 等方法，最后苹果就通过了审核！！！

通过 nm 命令和 shell脚本，又让效率提升了n倍，和前面几篇技巧一样，大家应该能感受到shell脚本编程的魅力，希望大家能举一反三，授鱼不如授渔！生活工作中结合 sehll 脚本，提高效率和自动化，珍爱时间不是梦！

后续有更多技巧，会继续给大家分享，期待~


### 参考
- [shell技巧1 - 生成ipa文件 | iHTCboy's blog](https://ihtcboy.com/2018/08/31/2018-08-31_shell技巧1_生成ipa文件/)
- [Shell 教程 | 菜鸟教程](http://www.runoob.com/linux/linux-shell.html)
- [Mac查看文件内容常用的命令小结 | iHTCboy's blog](https://ihtcboy.com/2018/02/04/2018-02-04_Mac查看文件内容常用的命令小结/)
- [shell技巧1 - 生成ipa文件 | iHTCboy's blog](https://ihtcboy.com/2018/08/31/2018-08-31_shell技巧1_生成ipa文件/)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
