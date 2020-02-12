# SoftwareConfig
My Mac config/backup files for macOS.


## Alfred


### Appearance（主题）
存放共享的 Alfred 主题的目录


### Snippets（字符片段）
存放共享的 Alfred Snippets 的目录 

### Workflows（工作流）
存放共享的 Alfred Workflows 的目录

#### 1、Copy Path.alfredworkflow

快捷复制当前Finder选择的文件(`cp`)的文件路径或文件名(`cpn`)

下载：[macOSConfig/Copy Path.alfredworkflow at master · iHTCboy/macOSConfig](https://github.com/iHTCboy/macOSConfig/blob/master/Alfred/Workflows/Copy%20Path%20v1.0.alfredworkflow)

#### 2、Reply Message.alfredworkflow
在微信 Mac/PC 端消息有个「引用」的功能，用于针对某个特定消息回复，而其它 App 没有该功能，这个workflow可以读取你复制的东西，给你生成一个带引用格式的文本，并完成后粘贴到App就可以实现引用回复了。

下载：[Reply Message v1.0.alfredworkflow](https://github.com/iHTCboy/macOSConfig/raw/master/Alfred/Workflows/Reply%20Message%20v1.0.alfredworkflow)

1. `自动模板`：复制内容，打开 Alfred 输入 `R` 键后回车，就会自动粘贴到聊天软件中
![Alfred-Copy-Template.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/11/Alfred-Copy-Template.png)

2. `回复内容`：复制内容，打开 Alfred 输入 `R` 键，空格后输入要回复的内容，完成后回车就会自动粘贴到聊天软件中
![Alfred-Copy-Template-Reply.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/11/Alfred-Copy-Template-Reply.png)

3. `快捷符模板`：复制内容后，在聊天软件中输入 `\\rp`，会自动粘贴回复的模板到聊天框
![Alfred-Shortcuts-Key.gif](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/11/Alfred-Shortcuts-Key.gif)

4. `自定义快捷键`：如果觉得还不够快？可以自定义一个自己喜欢的快捷键，快速生成回复模板
这个就不演示了，自己配置快捷键就可以啊


详细说明见：
- [用 Alfred Workflow 实现聊天内容快速引用回复 | iHTCboy's blog](https://ihtcboy.com/2019/11/17/2019-11-17_%E4%B8%80%E4%B8%AAAlfred%E7%9A%84Workflow%E8%81%8A%E5%A4%A9%E5%86%85%E5%AE%B9%E5%BC%95%E7%94%A8%E6%B6%88%E6%81%AF/)