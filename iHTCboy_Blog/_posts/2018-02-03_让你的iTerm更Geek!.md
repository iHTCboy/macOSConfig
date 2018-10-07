title: 让你的iTerm更Geek!
date: 2018-02-03 23:42:16
categories: technology #life poetry
tags: [iTerm进阶,命令行快捷键,Terminal]  # <!--more-->
reward: true

---


### 1、前言
iTerm2 作为一个免费&开源的应用，Mac程序员应用必备的软件！
作为一个专业的终端，功能真的很强大，`iTerm` + `oh-my-zsh`  应作为最佳配置使用！

### 2、一键调出 iTerm2
>我们有时会遇上这样一种情况，就是我们只想用命令行执行某一个特定的操作，然后就不需要它了。其实在这种情况下我们没有必要打开命令行应用的。比如我们就是想看一眼某个文件夹里面都有什么文件，类似这种操作我们其实没有必要单独开启一个命令行窗
口的。

<!--more-->

然后网上找到的配置是这样的，设置HotKey：
打开iTerm的Preperence → Profiles → Keys → HotKey 进行勾选设置
![Preperence → Profiles → Keys → HotKey .jpg](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/02/0203-Preperence → Profiles → Keys → HotKey .jpg)

- Show/hide iTerm2 with a system-wide hotkey
- Hotkey toggles a dedicated window with profile
勾选上面的两个选项，关闭iTerm2，然后再次打开，任意应用程序界面按快捷键尝试一下。你会爱上这个感觉。

然而！！！没有找到 `Hotkey toggles a dedicated window with profile` 这个选项！！！
![没有找到Hotkey toggles a dedicated window with profile.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/02/0203-没有找到Hotkey toggles a dedicated window with profile.png)

我是使用 iTerm2( Build 3.1.5.beta.2):

![iTerm2( Build 3.1.5.beta.2).png](https://raw.githubusercontent.com/iHTCboy/iGallery/master/BlogImages/2018/02/0203-iTerm2（Build%203.1.5.beta.2）.png)


**Way! way!! way!!!**
原来新版已经移动到对应的`Profiles`下的`Keys`下：
![Profiles-Keys.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/02/0203-Profiles-Keys.png)

设置一下热键就可以啦！
![Profiles-Hotkey.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/02/0203-Profiles-Hotkey.png)

实用&装逼时间：
![通过快捷键快速打开后台的iTerm2.gif](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/02/0203-通过快捷键快速打开后台的iTerm2.gif)

有时候想快速打开，真的很方便！

###  3、iTerm2 光标按照单词快速移动设置
在Mac自带的终端中是可以使用 option+←和option+→ 这两个快捷键实现光标按照单词快速移动，但是发现iTerm用这个快捷键没有反应！！！每次只能用`ctrl + f/b `一个个字符移动，效率非常低！经过搜索，发现需要重新配置相应的映射。

打开iTerm2的 Preferences ->选择相应的 Profile（默认为Default），选择“Keys”选项卡，然后可以在Key Mappings看到option+←和option+→ 这两组快捷键用作了其他功能，这里我们只需要重新绑定新的映射即可（下图是已经绑定之后的新映射）。

![Key Mappings.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/02/0203-Key Mappings.png)

分别修改option+←和option+→的映射如下图所示，选择Action为“Send Escape Sequence”，然后输入“b”和“f”即可。
![Key Mappings-shortcut.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/02/0203-Key Mappings-shortcut.png)

### 4、iTerm2 备忘命令行快捷键

| 快捷键 | 作用说明 |  
| --- | --- | 
| command + f | **搜索&查找**，如果输入搜索内容后，按下 tab 键，就会 iTerm 自动帮选中搜索关键词，并且自动的帮我们复制到了剪贴板中。如果输入的是 shift+tab，则自动将查找内容的左边选中并复制。按 esc 退出搜索。  | 
| command + k | 清空屏幕 | 
| command + d | 垂直分屏 | 
| command + shift + d | 水平分屏 | 
| command + ; | 查看历史命令 | 
| command + shift + h | 查看剪贴板历史，会自动列出输入过的命令 | 
|  command + number | tab 标签窗口来回切换 | 
| command + option + ←/→ <br>或 command + [ / ] |  切换屏幕 | 
|  |  | 
| ctrl +  x |第一次按时，移动光标至行首；再次按时，回到原有位置 |
| ctrl + a | 到行首（Ahead of line） | 
| ctrl + e | 到行尾（End of line） | 
| ctrl + f/b  | 前进后退(相当于左右方向键)  | 
| ctrl + u  | 清除当前行（无论光标在什么位置） | 
| ctrl + d | 删除光标当前位置的**字符** | 
| ctrl + h | 删除光标之前的**字符** | 
| ctrl + w |  删除光标之前的**单词** | 
| ctrl + k | 删除光标当前位置到文本末尾的**所有字符** | 
| ctrl + t | 交换光标当前位置的字符与前一个字符的位置 | 
|  |  | 
| ctrl + c <br>或 ctrl + j <br>或 ctrl + o|  取消当前行输入的命令（中断操作）。重新起一行。 | 
| ctrl + y | 粘贴之前（ctrl +u/k/w）删除的内容 |
| ctrl + p |  上一条命令。调出命令历史中的前一条（Previous）命令，相当于通常的上箭头 | 
| ctrl + n |  下一条命令。调出命令历史中的下一条（Next）命令，相当于通常的上箭头 | 
| ctrl + s | 冻结终端操作（暂停脚本） |
| ctrl  + q | 恢复冻结（继续执行脚本） |
| ctrl + r | 搜索命令历史。根据用户输入查找相关历史命令（reverse-i-search） | 
| ctrl + l  <br>或 command + r  <br> 或 clear  | 换到新一屏，创建一个空屏 | 
| ctrl + i <br>或 tab | 横行制表符，在命令行中补齐指令 |
|  |  | 
|  !word | 重复运行最近一条以“word”开头的指令，如!ls 或 !l | 
|  !$ | 调用上一条指令的最后一个参数作为当前指令对象,如，假设上一条指令为： ls abc.txt bbc.txt 那么， vi !$ 相当于： vi bbc.txt	 | 
|  !number | 调用执行指定编号的历史记录指令,如!2, !11 | 


### 5、参考引用
- [打造高效个性Terminal（一）之 iTerm | BlueSun](http://huang-jerryc.com/2016/08/11/打造高效个性Terminal（一）之%20iTerm/)
- [让你的Mac更Geek（逼格） - 简书](https://www.jianshu.com/p/4409e6ac1975)
- [iTerm - 让你的命令行也能丰富多彩 - SwiftCafe 享受代码的乐趣](http://swiftcafe.io/2015/07/25/iterm/)
- [Mac下iTerm2光标按照单词快速移动设置 - CSDN博客](http://blog.csdn.net/skyyws/article/details/78480132)
- [OS X 下的 iTerm 2 如何让 cursor 跳字移动？ · Ruby China](https://ruby-china.org/topics/6114)
- [iTerm2 快捷键大全 - 陈斌彬的技术博客](https://cnbin.github.io/blog/2015/06/20/iterm2-kuai-jie-jian-da-quan/)
- [Mac 终端Terminal光标移动快捷键](https://my.oschina.net/dyl226/blog/752030)



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

