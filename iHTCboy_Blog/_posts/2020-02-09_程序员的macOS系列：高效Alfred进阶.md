title: 程序员的macOS系列：高效Alfred进阶
date: 2020-02-09 20:49:16
categories: induction #technology life poetry
tags: [程序员的macOS,Mac,macOS,Alfred]   # <!--more-->
reward: true

---

## 1、前言
之前写的《程序员的macOS系列》文章，2018年写了二篇文章：[精选Mac App](https://ihtcboy.com/2018/07/15/2018-07-15_程序员的macOS系列：精选MacApp/)、 [Mac开发环境配置](https://ihtcboy.com/2018/09/30/2018-09-30_程序员的macOS系列：Mac开发环境配置/)，至今，已经过年一年半啦！收到很多同学的点赞，最后一篇 `高效Alfred进阶` 因为各种原因，没有写出来，所以都0202年啦！

其实 `macOS` 系统的高效，很大部分原因是因为有 `Unix/Linux` 的相似血统，本文讲解`Alfred`，就是效率工具的一员，相信注重效率的你，一早肯定听说过或者已经在使用，简单来说 Alfred 以键盘的高效代替鼠标操作的繁冗。还有很多效率方法，以后有机会在总结吧，大家也可以自行搜索 macOS 开发效率，博主之前也写过一些。那为什么会认为 `Alfred` 对程序员很重要呢？如果你没有用过，相信你读完本文就会明白。虽然网上已经有很多 `Alfred` 的教程，但是一直没有找到能相对全面，或很少从入口到进阶的文章，并且很多文章历史已经悠久，所以惟有抛砖引玉，自我总结一下，希望和大家一起努力提交效率！

- [程序员的macOS系列：精选Mac App](https://ihtcboy.com/2018/07/15/2018-07-15_程序员的macOS系列：精选MacApp/)
- [程序员的macOS系列：Mac开发环境配置](https://ihtcboy.com/2018/09/30/2018-09-30_程序员的macOS系列：Mac开发环境配置/)
- [程序员的macOS系列：高效Alfred进阶](https://ihtcboy.com/2020/02/09/2020-02-09_程序员的macOS系列：高效Alfred进阶/)

目前计划写《程序员的macOS系列》三篇已经完成 ✅，后续有想法在更新吧~

## Alfred 提高程序员 100% 效率指南

<!--more-->
**Alfred 4 for Mac** 官网产品说明：

> Alfred is an award-winning app for macOS which boosts your efficiency with hotkeys, keywords, text expansion and more. Search your Mac and the web, and be more productive with custom actions to control your Mac.
> Alfred是一款屡获殊荣的macOS应用程序，可通过热键，关键字，文本扩展等功能提高您的效率。搜索Mac和网页的内容，并通过自定义操作来控制Mac来提高生产力。

小帽子 `Alfred`（读`['ælfrid]`） 是 macOS 平台强大的效率软件！被誉为神兵利器！我们本篇文章基于2020年1月17号更新的版本 `Alfred 4.0.8（Build 1135）`，所以如果低于此版本导致部分功能没有的，请更新最新版本。或者有新功能此版本没有提及的，请以官网为准 [Alfred - Productivity App for macOS](https://www.alfredapp.com/)。

![Alfred-4.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-4.png)

需要注意的是，本文是以提高效率为准，不会讲解如何制作 Workflows（工作流），只会讲解有那些好用的工作流。另外，网上的教程很多都是15、16年为主，新的教程还是以其一功能为主讲，我一直思考，`怎么才能让新手从入门到精通 Alfred 呢？`，所以，为了让大家全面的了解，这里会从 Alfred 的偏好设置开始讲解，从上往下，一个一个解析，中间串插对整个功能的讲解。另外，如果操作或流程很简单的，也不提供截图。下面就让我们开始吧！

### General（通用设置）
![Alfred-General.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-General.png)

- `Startup`（启动）
勾选表示系统重启时，会自动启动 Alfred。

- `Alfred Hotkey`（Alfred 热键）
设置显示 Alfred 输入框的键盘快捷键，我一般设置为 `command + Space`，也就是苹果键（Apple key，`⌘`）和空格键组合，很多人使用 `command + command` 或 `option + option`，双同键的组合，我认为是不够高效的。因为，你要双击（`double click`）才能响应，还是慢了一拍！

- `Where are you`（你在哪）
设置你所有的国家或地区，目的是更加人性化的内容，比如谷歌搜索或易呗（ebay），中国就淘宝什么的，目前这个针对中国区还没有什么作用。

- `Permissions`（权限）
点击 `Request Permissions...` 打开权限许可说明，主要是授权 Alfred 可以访问系统和电脑的那些权限：
![Alfred-General-Permissions-Request-Permissions.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-General-Permissions-Request-Permissions.png)

这个权限的设置，在下面的 `其它问题汇总` 再进一步说明，因为比较多，不影响大家阅读，我们先说重点！

### Features（主要功能）
#### Default Results（默认结果）
![Alfred-Features-Default-Results.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Default-Results.png)
主要是设置搜索相关的默认配置。

- `Applecations`
设置模糊搜索应用名字还有是不是搜索应用内的资源，比如搜索 `梁静茹` 可能在`Music.app`。 第二个勾选项 `Match Application’s keywords in default results` 的作用是匹配应用的关键词元数据。我们以苹果的 音乐App 为例说明，简介可以看到有一栏是关键词：
![Alfred-Features-Default-Results-AppKeywords.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Default-Results-AppKeywords.png)

App添加这些关键词信息，就是为了用户在 `Spotlight`、`Alfred`、`LaunchBar` 等应用搜索这些词语时，匹配并显示出来。一方面，这确实可以带来一定的便利，但是另一方面也会扰乱搜索结果，所以 Alfred 新版本默认禁止(取消勾选)了这种乱刷存在感的行为。不过，如果觉得用着还不错，可以自己重新勾选上啊。

- `Essentials`(要点)
搜索系统偏好设置和联系人信息的内容。

- `Extras`（额外部分）
搜索 文件夹、文档、文本文件、图片、压缩文件、苹果脚本等内容。在右侧 `Advanced…` 按钮，可以自定添加格式内容，比如思维导图的 `.mmap` 和 markdown 文件的 `.md` ，根据自身需求可以添加对应的文件类型让 Alfred 去检索这些文件。只需要将 Alfred 无法检索到的文件类型拖至弹出的框内即可添加。

- `Unintelligent`（不智能的）
搜索全部类型的文件。（不推荐）

- `Search Scope`（搜索范围）
可以设置搜索的文件空间或目录等。

- `Fallbacks`（退路，应变计划）
用于设置搜索没有找到结果时，显示的可选的进一步的操作。
类似如下图，搜索wq时没有结果会显示一个可操作列表，前面2项是 Alfred自带的搜索项，剩下的是`自定义搜索`，可以自定添加或更改显示的操作项。（自定义搜索的内容参考下一节`Web Search（网站搜索）`的内容）。
![Alfred-Features-Default-Results-Fallbacks.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Default-Results-Fallbacks.png)

#### File Search（文件搜索）
![Alfred-Features-File-Search.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-File-Search.png)

通过关键字快速和突出搜索的文件的结果。

##### Search（搜索）标签

- `Quick Search`（快速搜索）
通过`'`或 `spacebar`空格键可以可以快速查找文件。

- `Opening Files`
直接打开文件（默认就是open，不敲入关键字，即搜索文件名后回车，就是直接打开该文件）。默认是`open`，我一般设置为`op`，找到文件后，点击或按右边提示的快捷键，可以快速打开文件。比如：
![
Open.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-File-Search-Open.png)

- `Revealing Files`
打开文件所在的文件夹。默认用`find`，我一般设置为`fd`，fd + 搜索词，找到文件后，点击或按右边提示的快捷键，可以快速打开文件所在的文件夹。（这里省略图示，可以自己试试。）

- `Inside Files`
在文件内搜索内容。默认用`in`，in + 文件内容的搜索词，找到文件后，点击或按右边提示的快捷键，可以快速打开文件。（这里省略图示，可以自己试试。）

- `File Tags`
搜索文件标签。

- `Don't Show`
设置不搜索的内容，比如 Emails(邮箱内容）、Bookmarks（网页书签）、Music（音乐）等等。

- `Result Limit`
显示的搜索结果条数，可以设置为`20`、`30`、`40`条。

##### Navigation（导航）标签
在 Alfred 的输入栏中浏览 macOS 的文件系统，而无需用鼠标操作Finder。熟悉命令行的同学都知道，在 Unix/Linux 系统中有两个很重要的符号：`/` 和 `~`。**/** 代表文件系统的根目录，所有的子文件都挂在这个根目录下；**~** 代表当前用户目录，里面包含了当前用户的所有资料，也就是打开 Finder（访达）之后你在侧边栏可以看到的目录。利用 Alfred 进行文件浏览也是基于这两个符号：

* `/`：在 Alfred 输入栏中首先输入“/”，会带你进入 macOS根目录；
* `~`：在 Alfred 输入栏中首先输入“~”，会带你进入当前的用户目录；

- `Filtering`
启动模糊搜索。比如有一些目录可能我们不记得，例如 Documents、Desktop、Downloads 目录，我们可以搜索 `d*n`，用`*` 来进行模糊搜索。

- `Shortcuts`
设置快捷键导航。
`Use ← and → for folder navigation`：勾选这个复选框之后，可以利用 `←/→`（Left/Right键）来进入上一级目录或者下一级目录。但是 Alfred 默认`→`（Right键）为打开`Actions`（动作面板，将在后面介绍），因此如果你不想与此功能冲突的话，可以利用Alfred 默认的 `Command + Up` 和 `Command + Down` 来进行导览，或者更改 `Actions`（动作面板）使用的快捷键，下方有说明。
`Use ↩︎ to open folders in Finder`：勾选这个复选框后，按下 回车键（Enter键）后会直接在 Finder 中打开选中的文件夹。

- `Previous Path`
可以在这里设置热键和关键字，来进入上一个打开过的目录。

文件导航中，左侧是文件列表，右侧是文件预览。新版本在右下角添加了一个配置菜单，点击 ⚙️️ 图标可以看到有这些选项：

* 排序方式：名称、创建日期、修改日期
* 文件夹置顶
* 逆序排列，快捷键：`⇧Shift + ⌘Command + S`
* 隐藏预览面板，快捷键：`⇧Shift + ⌘Command + I`

![Alfred-Features-File-Search-Navigation.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-File-Search-Navigation.png)

##### Buffer（缓存）标签
文件多选缓存操作，可以从不同的文件夹中选择多个文件，或者同时对多个文件进行相同的操作等，可以进行批量操作，打开、共享、删除等等。

* Alt + ↑ ：把该文件加入列表；
* Alt + ↓ ：把该文件加入列表，光标跳向下一个文件；
* Alt + ← ：删除列表最后一个文件；
* Alt + → ：对列表文件进行统一操作。

利用以上的快捷键将一系列的文件加入到文件缓存区中（文件缓存区位于 Alfred 输入框上方），然后利用 `fn` 键或 `ctrl` 键、`⇥`键（Alt + Right键）等打开 `Actions`（动作面板）对这些文件进行同一操作。

- `Buffer Clearing`
设置操作缓存文件后从缓存区清除文件，如果5分钟不使用缓存文件时也清除。

- `Compatibility`（兼容性）
如果上面的 `Alt`键 + 方向键与其它的操作冲突了，那么可以勾选这个复选框，那么将使用 `Shift + Alt + 方向键` 来操作文件缓存。

##### Advanced（增强）标签
设置文件搜索的高级配置项。默认就好，一般不需要关注。
 
#### Actions（动作）
![Alfred-Features-Actions.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Actions.png)

- `Show Actions`（显示动作）
在选中的文件或者目录上点击 `fn` 键或 `ctrl` 键、`⇥`等都可以触发其额外的操作，具体的动作见 `File Actions` 标签栏。 

- `Selection Hotkey`
可以设置自定义的快捷键来显示动作。

- `Action Ordering`
动作排序显示，如果勾选，表示按最近使用的动作优先显示，否则就按默认排序。

动作操作的效果示意图：
![Alfred-Features-Actions-File-Actions.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Actions-File-Actions.png)

动作操作这里有一个 `Recent Documents...`，在 Alfred 输入框中输入某个App的名字，然后按下`fn` 键或 `ctrl` 键（Action设置的热键）打开关于这个App的操作列表，排在列表的第一个选项 `Recent Documents...`（App最近的浏览记录），按下回车键（Enter键）选择这个选项，就会在 Alfred 中呈现这个App最近打开的文件记录列表，你可以在其中选择想要的文件再次利用这个App打开。

这里以 Xcode app 为例：
![Alfred-Features-Actions-Recent-Documents.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Actions-Recent-Documents.png)

其它的操作，大家自己试试啊！这里省略吧，太多了。

#### Web Search（网站搜索）
![Alfred-Features-Web-Search.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Web-Search.png)

网页搜索 Alfred 自带了不少，比如google、wiki、bing等网页搜索，但对于国内用户来说，还是得需要自定义百度、知乎等搜索，点击右下角的 `Add Custom Search`，按照提示的格式自己增加即可。

这里用一个例子来说明自定义的网页搜索设置，比如想搜索苹果的官方文档中`Swift`，真实的链接是 `https://developer.apple.com/search/?q=Swift`，那么每次搜索苹果的文档内容时，我们都要打死浏览器，打开苹果官方文档链接，然后输入`Swift`，才能看到结果。然这个步骤，可以利用 Aflred 这个网页搜索功能整合为一步，所以我们需要一个自定义的搜索，在 Aflred 点击右下角的 `Add Custom Search`，然后填写下图的信息：
![Alfred-Features-Web-Search-Custom.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Web-Search-Custom.png)

这里需要说明一下，`https://developer.apple.com/search/?q={query}` 中的 `{query}` 是通过 Alfred 输入框输入你需要搜索的关键词的变量，`Title` 就是上图的默认显示的提示语，右边还能上传一个icon图标，用于标识此搜索，`Keyword` 是这个网页搜索的快捷键，这里用 ad （apple document）作为快捷键，`Validation` 是用于测试这个网页搜索是不是正常工作，点击右边的 Test 按钮来测试。左下方的 `Copy URL for sharing`按钮，点击一下就可以将一个带有`alfred://` 前缀的字符串拷贝到系统剪切板，然后分享给好友，在 Alfred 中粘贴后回车键就可以导入。示例：
![Alfred-Features-Web-Search-Swift.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Web-Search-Swift.png)

这里列出一些搜索引擎的搜索的URL示例：
* 掘金搜索：`https://juejin.im/search?type=all&query={query}`
* 简书搜索：`https://www.jianshu.com/search?utf8=%E2%9C%93&q={query}`
* 微信文章：`http://weixin.sogou.com/weixin?type=2&query={query}`
* 知乎内容：`https://www.zhihu.com/search?type=content&q={query}`
* 苹果文档：`https://developer.apple.com/documentation/{query}`
* 淘宝搜索：`https://s.taobao.com/search?oe=utf-8&q={query}`
* 京东搜索：`https://search.jd.com/Search?enc=utf-8&keyword={query}`
* GitHub：`https://github.com/search?utf8=%E2%9C%93&q={query}`
* StackOverflow：`https://www.stackoverflow.com/search?q={query}`
* DuckDuckGo：`https://duckduckgo.com/?q={query}`
* 爱奇艺：`https://so.iqiyi.com/so/q_{query}`
* 哔哩哔哩：`https://search.bilibili.com/all?keyword={query}`
* 豆瓣全站：`https://www.douban.com/search?q={query}`
* 豆瓣电影：`https://movie.douban.com/subject_search?search_text={query}`
* 少数派：`https://sspai.com/search/article?q={query}`

另外，配置搜索引擎时，借助网站方面的 `OpenSearch` 与 `SearchAction` 协议实现自动化填写 `Search URL`。不再像以前那样需要自己寻找关键词参数位置，然后替换为 `{query}` 了。添加搜索引擎时，在 Search URL 文本框中填入网站的域名，然后点击右侧的 `Lookup` 就会自动分析并显示可用的搜索链接格式，接着点击 `Use` 就可以了。但遗憾的是，并非所有网站都支持 OpenSearch 或 SearchAction 协议。（大家可以用`https://www.pinterest.com` 这个体验一下。）

这里分享一些博主自定义的网络搜索：
* 掘金搜索：`alfred://customsearch/Search%20Juejin%20for%20%27%7Bquery%7D%27/jj/utf8/nospace/https%3A%2F%2Fjuejin.im%2Fsearch%3Ftype%3Dall%26query%3D%7Bquery%7D`
* 简书搜索：`alfred://customsearch/Search%20Jianshu%20for%20%27%7Bquery%7D%27/js/utf8/nospace/https%3A%2F%2Fwww.jianshu.com%2Fsearch%3Futf8%3D%25E2%259C%2593%26q%3D%7Bquery%7D`
* 微信文章：`alfred://customsearch/Search%20Weixin%20for%20%27%7Bquery%7D%27/gzh/utf8/nospace/https%3A%2F%2Fweixin.sogou.com%2Fweixin%3Ftype%3D2%26query%3D%7Bquery%7D`
* 知乎内容：`alfred://customsearch/Search%20Zhihu%20for%20%27%7Bquery%7D%27/zh/utf8/nospace/https%3A%2F%2Fwww.zhihu.com%2Fsearch%3Ftype%3Dcontent%26q%3D%7Bquery%7D`
* 苹果文档：`alfred://customsearch/Search%20%EF%A3%BFDeveloper%20for%20%27%7Bquery%7D%27/ad/utf8/nospace/https%3A%2F%2Fdeveloper.apple.com%2Fsearch%2F%3Fq%3D%7Bquery%7D`
* 淘宝搜索：`alfred://customsearch/Search%20Taobao%20for%20%27%7Bquery%7D%27/tb/utf8/nospace/https%3A%2F%2Fs.taobao.com%2Fsearch%3Foe%3Dutf-8%26f%3D8%26q%3D%7Bquery%7D`
* 京东搜索：`alfred://customsearch/Search%20JD%20for%20%27%7Bquery%7D%27/jd/utf8/nospace/https%3A%2F%2Fsearch.jd.com%2FSearch%3Fenc%3Dutf-8%26keyword%3D%7Bquery%7D`
* GitHub：`alfred://customsearch/Search%20Github%20for%20%27%7Bquery%7D%27/sh/utf8/nospace/https%3A%2F%2Fgithub.com%2Fsearch%3Futf8%3D%25E2%259C%2593%26q%3D%7Bquery%7D`
* StackOverflow：`alfred://customsearch/Search%20StackOverflow%20for%20%27%7Bquery%7D%27/so/utf8/nospace/https%3A%2F%2Fwww.stackoverflow.com%2Fsearch%3Fq%3D%7Bquery%7D`

上面这个自定义搜索，只需在 Alfred 输入框中粘贴这个字符串（`alfred://`前缀的字符串），按下回车键就可以导入这个自定义搜索到自己的Alfred中了。

更多搜索网站的大家可以自行收藏啊~

#### Web Bookmarks（网页书签）
![Alfred-Features-Web-Bookmarks.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Web-Bookmarks.png)

目前 Alfred 支持 `Safari` 和 `Chrome` 浏览器的书签搜索。

- `Show bookmarks`
为了更加方便和快捷的搜索书签，可以设置通过 `via keyword`关键词来直接搜索书签，设置前缀`w`为搜索书签。

- `Open Bookmarks`
设置搜索结果中的书签，从那个浏览器打开，可以选择默认系统的浏览器，或者书签来源的浏览器打开。

以搜索 Safari 的书签中 `apple` 为例：
![Alfred-Features-Web-Bookmarks-Search.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Web-Bookmarks-Search.png)

升级到 `macOS 10.15` 后可能会遇到书签搜索不到的问题，因为新版本 macOS 对软件访问权限做了限制，需要访问那个目录，都可以设置。所以，如果要让 Alfred 能搜索书签，需要在系统偏好设置中的 `安全性与隐私 `-> `隐私` ->`完全磁盘访问权限` 勾选 `Alfred 4.app`。然后在 Alfred 中输入 `Reload Alfred Cache` 后回车键，Alfred 重新加载缓存就可以搜索书签。如果不给权限，那么在 `macOS 10.15` 下无法使用书签搜索。

#### Clipboard History（剪切版历史）
![Alfred-Features-Clipboard-History.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Clipboard-History.png)

默认情况下，Alfred 是没有打开剪贴板历史这个功能的，需要自己手动去开启，可以打开文字、图片、文件列表的剪贴板功能，自定义一个快捷键，光标在需要粘贴的地方，呼出剪贴板历史，选中需要粘贴的内容，回车即可。

![Alfred-Features-Clipboard-History-Examples.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Clipboard-History-Examples.png)

上图就是官网的示例，可以看出剪切版历史功能，可以显示复制的文本来源应用，时间等，图片的大小和尺寸等等。我们在来看看怎么使用，很简单，快捷键`⌥ + ⌘ + C`（`alt + commaand + C`）打开`剪切版历史视图`：

![Alfred-Features-Clipboard-History-Copy-Paste.gif](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Clipboard-History-Copy-Paste.gif)

这个对于大量的复制和粘贴功能非常有用，具体使用大家自行体验就行。这里在说说配置内容：

- `Clipboard History`（剪切版历史）
可以设置普通文本、图片和文件的保留时间，因为这里复制的内容，Alfred会自行保存一份，所以需要设置过期时间，避免软件占用过多的空间。

- `Viewer Hotkey`
用于设置全局的快捷键，用于在所有的软件界面都能调用出来，插入剪切的内容。我一般设置为 `⌥ + ⌘ + C`（`alt + commaand + C`）。

- `Viewer Keyword`
用于设置在 Alfred 输入框中输入 `cl` 后，可以快速进入到 `剪切版历史视图`，默认是 `clipboard` 关键词。另外，进入 `剪切版历史视图` 后，按 Alfred 的全局热键就可以重新回到输入框中。

- `Clear Keyword`
剪切版的内容不只是占用空间，可能你还包括了敏感的内容，所以你可能想清空剪切版的内容。所以，可以点击右边的`Clear Now`马上清空（注意，此执行没有确认弹窗。清空后剪切版数据不能恢复。），或者打开 Alfred 输入框输入`clear`，可以选择清除最近的 `5分钟`、`15分钟`或`全部数据`清除，大家可以自已操作一下。

- `Snippets`（片段）
`Snippets`（片段）这个功能是下面一节内容介绍，这里建议都勾选。目前下一节在说。

- `Universal`（通用）
忽略从其它苹果设置同步过来的剪切版内容。建议不勾选。同步同一个苹果账号的剪切版功能是从macOS 10.13 、iOS 12 开始的，详细可以查看苹果官方文档 [使用通用剪贴板在 Apple 设备之间进行拷贝和粘贴 - Apple 支持](https://support.apple.com/zh-cn/HT209460)、[在 iPhone 上使用通用剪贴板 - Apple 支持](https://support.apple.com/zh-cn/guide/iphone/iph220ea8dca/ios)、[从 Mac 上拷贝并在设备间粘贴 - Apple 支持](https://support.apple.com/zh-cn/guide/mac-help/mchl70368996/mac)。

- `Merging`（合并）
比如你复制了三段文本，可以你需要把它们组合成一段话，默认情况下需要你按3次快捷键，但是如果你勾选了这个 `Merging` 功能，就可以实现快速的合并一段剪切的内容。具体的使用也很简单，勾选 Merging 标签的 `Fast append selected text`后就可以，剪切的文本，默认是 `⌘ + C` 剪切一次，再按一次 `⌘ + C`（按住`⌘`不动，再按下`C`键），就是触发合并操作，此时的剪切的内容会与上一次剪切的内容合并为一个。合并内容的格式可以选择是用空格、换行或者不分隔的方式来分隔文本的合并。

- `Advanced`（增强）
这里可以设置一些高级的内容，比如在剪切版历史视图的项中，按回车键后自动粘贴到当前激活的应用的输入框中；复制的内容如果是相同的内容自动移动到最前面（不会重复保存）；剪切版的内容的最大尺寸，`256k`字符串、`512k`或不限制等；忽略的Apps，可以忽略 `Keychain Access`、`1Password`、`Wallet`等可能有敏感内容的剪切内容等。

#### Snippets（字符片段）
![Alfred-Features-Snippets.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Snippets.png)

`Snippet`（字符片段）的作用，简单来说就是能够将自定义的文字通过**关键词**或者**快捷键**的方式插入到当前光标之后。

官方示例：
![Alfred-Features-Snippets-Examples.gif](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Snippets-Examples.gif)

Snippets 主要是对于经常键入的文本的创建和共享代码段，例如当我们需要输入 `手机号码`、`URL`和 `Email`等等，如果每次输入都是6位字符以上，你是不是觉得很浪费时间啊！

官方示例动图的操作，输入 `tflip1` 时会自动替换为对应的一个文字表情包！有没有觉得很利害！很高效！这里使用需要先勾选配置中的 `Automatically expand snippets by keyword` 和系统偏好设置中的`安全性与隐私 `-> `隐私` ->`辅助功能` 勾选 `Alfred 4.app`。

- `Viewer Hotkey`
这里我们不单独设置一个快捷键，因为可以与上一节的 `Clipboard History`（剪切版历史）共用一个弹窗界面，这样更加高效，需要在 Clipboard History 的 `Snippets` 中勾选才能共用界面。

- `Snippet Keyword`
用于设置在 Alfred 输入框中输入 `snip` 后，可以快速进入到 `剪切版历史视图`，默认是 `snip` 关键词，你可以更改你喜欢的词，比如 `sn`。

- `Matching`（匹配）
设置匹配 `Snippet`（字符片段）的方式，是通过 `Name`（名字）和 `Keyword`（关键字）还是包括 `Snippet`（字符片段）。

举个我经常使用的例子，比如，我要把博客的图片都是存放在 GitHub 的仓库中，例如某张图片的下载路径为： `https://github.com/iHTCboy/iGallery/raw/master/BlogImages/年份/月份/xxxx.png`。那么如果我在写博文时，需要插入这个图片，转换为 markdown 格式图片为：`![xxxx.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/年份/月份/xxxx.png)`，如果每次我都是手写，你说是不是非常的痛！痛！痛！因为根本就没有什么技术含量。所以，我定义了这样的快捷方式：

![Alfred-Features-Snippets-Custom.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Snippets-Custom.png)

用关键词 `gimg` 就能快速输入格式 `![{clipboard}](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/{clipboard})`，其中 `{clipboard}` 是当前剪切版的内容。看看最终的效果，大家就明白有多高效：

![Alfred-Features-Snippets-Copy-Paste.gif](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Snippets-Copy-Paste.gif)

这里，我只需要复制图片的名字（通过`回车键`快速重命名文件名的方式，`⌘ + A`全选再`⌘ + C`复制文件名，当然通过下文的 Workflows 也可以快捷复制文件名。），然后 `alt + ⌘ + C` 快速打开 `剪切版历史视图`，输入快捷关键词（`gimg`，不用输完，可以模糊匹配。）然后回车键就完成 markdown 格式图片生成。当然，最后二步可以合并成一步，就是在上图配置Snippets时，勾选 `Auto expansion allowed`，这样，直接在需要输入的地方输入 `gima` 就会显示替换的内容，又减少一步操作。大家有没有感觉到每次记忆无关的链接和信息的痛苦，`Snippet`（字符片段）是不是更快了~

另外，这里 Alfred 提供了一些替换时的 `占位符`，就是替换时，会自动变的，比如 `{time}`（如：16:26:23）、`{date}`（如：2020年2月9日）、`{clipboard}`（当前剪切版的内容）、`{random}`（注：`{random:..}`表示随机数，其它表示见编辑窗口的左下角`{}`。）等，更强大的替换操作， Alfred 建议使用 Workflow Snippet Trigger object。

例如输入 `Emoji`，可以通过 macOS 系统快捷键`ctrl + command + 空格键`打开表情界面选择需要的表情，但是这个查找过程也是很麻烦，有几百个 Emoji，所以其实可以通过 Snippet 来快速输入：
![Alfred-Features-Snippets-Emoji.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Snippets-Emoji.png)

以上的 Emoji 表格，可以通过下载导入到你的 Alfred 中，下载地址：[macOSConfig/Alfred/Snippets · iHTCboy/macOSConfig](https://github.com/iHTCboy/macOSConfig/tree/master/Alfred/Snippets)。

更多 Snippet 分组，可以查看官网推荐 [Snippets - Alfred](https://www.alfredapp.com/extras/snippets/)：

* [Mac Symbols](https://www.alfredapp.com/media/snippets/Mac%20symbols.alfredsnippets)：集合了很多常用的Mac符号，比如输入 `!!cmd` 对应 `⌘`符号，“!!shift”对应“⇧”符号等等。有了这个集合，就再也不用在符号表中辛辛苦苦去找某个Mac标志符号了。
* [ASCII Art](https://www.alfredapp.com/media/snippets/Ascii%20Art.alfredsnippets)：集合了一些好玩的火星文字表情，比如 ` (╯°□°）╯︵ ┻━┻ `。
* [Currency Symbols](https://www.alfredapp.com/media/snippets/Currency%20Symbols.alfredsnippets)：集合了一些常用的货币符号，比如“::cny”代表“¥”，“::usd”代表“$”等等。
* [Dynamic Content examples](https://www.alfredapp.com/media/snippets/Dynamic%20Content.alfredsnippets)：一些关于动态占位符的例子，可以学习一下使用方法。
* [Emoji Pack](http://joelcalifa.com/blog/alfred-emoji-snippet-pack/)：很强大的Emoji表情包。有海量的Emoji符号，输入对应的关键字就能自动插入想要的Emoji表情，简直不要太方便，再也不用一个个翻页的去找了。


##### 对 Snippet 关键字的建议
只要定义好了 Snippet 条目，则在任何文本输入的地方输入`分组Affix + 条目Keyword + 分组keyword`，就能自动展开相应的文本片段。但是这个 `Affix + Keyword` 组合的定义最好也遵循一定的规则，要容易记忆、方便输入，但同时也不能与其他热键冲突。以下是关于怎样定义 Affix 和 Keyword 的几个建议：

1. 在 Keyword 中不要使用正常词汇，以避免有些不期望的展开。比如如果你将 Keyword 定义为`apple`，则在任何输入 `apple` 的地方都会扩展成为定义好的文本片段，即使你想进行输入的就是 `apple` 这个单词本身。因此，最好能用一些特殊记法，比如将关键字每个单词的首字母捡出来连在一起等等；
2. 所有的 Snippet 都要以非字母数字开头，比如感叹号（!），分号(;)，冒号(:)等等（类似于`!!office`，`::coffee`这样的）；
3. 使用不常用的大写形式，比如 `officE`；
4. 使用双重字母，比如 `ttime`。

##### 动态占位符（Dynamic Placeholders）
很多时候，你想在文本中插入一些特定的内容，但这些内容在每一次输入的时候都会有所不同，比如比如 `{time}`（如：16:26:23）、`{date}`（如：2020年2月9日）、`{clipboard}`（当前剪切版的内容）、`{random}`（注：`{random:..}`表示随机数，其它表示见编辑窗口的左下角`{}`。）等等。

**显示日期时间**
显示日期时间的占位符关键字有三个：

* `{date}`：显示当前日期
* `{time}`：显示当前时间
* `{datetime}`：显示当前日期和时间

日期和时间都有`short`、`medium`、`long`和`full`这几种显示方式，Alfred 默认的为midium。要想改变显示方式，只需在关键字后面接上相应的方式名称即可，例如`{date:long}`。这些显示方式的具体格式可以在系统的 `偏好设置设置 ` -> `语言和区域` -> `高级` 中查看.

不仅能显示当前时间，还可以利用加减算数符号进行计算之后，显示过去或者未来的日期时间，比如 `{date +1D}` 会显示明天的日期，`{time -3h -30m}` 会显示3个半小时之前的时间等等。支持的算子有以下几种：

* 1Y：年
* 1M：月
* 1D：天
* 1h：小时
* 1m：分钟
* 1s：秒

在用算式计算时间时，同时也能接上显示方式，按照需要的格式显示相应的日期时间，比如`{time -2h -20m:long}`，`{date -2m:short}`。

**剪切板内容**
利用 `{clipboard}` 的位移功能来选择不同顺序的剪切板文本，需要注意的是，这里的位移首先是从数字0开始，而不是1，`{clipboard:0}` 代表剪切板第一项内容，`{clipboard:1}`为第二项内容，`{clipboard:2}` 为第三项，以此类推。{clipboard}和{clipboard:0}的意义相同。

还可以加上一些转换命令，对剪切板中的文本进行格式转换：

* `{clipboard:uppercase}`：将文本全部转换为大写；
* `{clipboard:lowercase}`：将文本全部转换为小写；
* `{clipboard:capitals}`：将文本中每个单词的首字母变为大写。
* * `{clipboard:trim}`：将文本中前后的换行、空格等空白字符删除。

**光标位置**
利用 `{cursor}` 占位符，可以在输入 Snippet 扩展为对应文字后，光标自动定位到{cursor} 在文本中的位置，方便之后对某些内容的输入。

**随机值** 
随机值占位符 `{random}`，包含：

* 随机的通用唯一标识符 UUID： `{random:UUID}`，形如 5FAF0AC6-B410-446C-A311-E41074205A05
* 随机数字：`{random:1..10}` 
* 列表中的随机项：`{random:苹果,香蕉,梨,葡萄,橙子}`

**修饰符（modifier）**
4.0 版本引入了形如 `{placeholder:variation.modifier}` 的占位符语法，可分为三部份：placeholder 占位符类别、variation 变种（可理解为参数或子类别）、modifier 修饰符。生成 1 到 10 之间随机数字的占位符 `{random:1..10}` 中 `random` 是 placeholder 占位符类别，`1..10` 部分是 variation 变种，而 `modifier` 修饰符部分，可以选择这些：

* `trim`：删去内容前后的换行、空格等空白字符。
* `reverse`：文本反转。
* `stripdiacritics`：去除重音标记，如 å 变为 a。
* `stripnonalphanumeric`：去除标点符号、Emoji 等非字母数字的字符。
* `uppercase`、`lowercase`、`capitalcase`：大写、小写、首字母大写转换。

这些修饰符同样可用于剪贴板占位符、Workflow 内的变量，例如 `{clipboard:3.reverse}` 代表反转第三条剪贴板历史的内容；`{var:result.trim.uppercase}` 代表将 result 变量的内容，删除前后空白字符后，再转换为大写。可以看到，修饰符部分支持复合连用。

##### 富文本（Rich Text）
4.0 版本加入了富文本支持，对于编写邮件等日常事务很有帮助，进一步扩展了使用场景。附加的编辑菜单，支持字体、粗体/斜体/下划线、颜色、复制/粘贴格式等简单的调整选项。另外，还能够自动识别副本文中的链接文本。如果这些编辑功能不能满足要求，我们也可以在「文本编辑」应用中编辑后粘贴过来。富文本在 Snippet 的列表中用 ✴️️ 加以标记。

![Alfred-Features-Snippets-RichText.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Snippets-RichText.png)

关于 Snippets 的使用，有很多技巧可以灵活使用，这里主要通过这2个，大家可以自己思考定义需要的片段！

#### Calculator（计算器）
![Alfred-Features-Calculator.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Calculator.png)

- `Standard`（标准）
Alfred 也支持计算器计算可以简单地输入 `16 * 1024` 便能够计算出结果，敲击回车键之后能够自动保存到剪贴板中，方便快速复制和使用。当然也可以连续的输入 `16 * 1024 / 256`，更加复杂的 `(1 + 4) * 6 / (7 +3)`。

- Advanced（增强）
利用 `GCMathParser` 模块，Alfred还能进行很多高级计算，比如三角运算、平方根等等。需要勾选此选项，在使用时以 `=` 作为开头，比如：`=log2(256) + sqrt(1024/2*3^4)` 表达式。
Alfred支持的高级计算有以下公式：`sin, cos, tan, log, log2, ln, exp, abs, sqrt, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, ceil, floor, round, trunc, rint, near, dtor, rtod`等。

- `Input` / `Output`
设置输入和输出的结果表达式的小数分分隔。

非常贴心的是，当你在用 Excel 等软件进行财务计算时，数字往往会带上货币符号，比如 `¥`、`$`、`€`等。当从 Excel 拷贝这些带有符号的数字到输入框时，Alfred 会自动省略掉这些货币符号，这样你就能直接进行计算了，而不用还要在输入框中进行编辑。

#### Dictionary（字典）
![Alfred-Features-Dictionary.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Dictionary.png)

Alfred 内置了词典查询并使用 Apple 自带的词典软件，可以通过 `define` 和 `spell` 两个关键词唤起。这里 define 我改为了 `df` 这里更加快捷！值得一提的是 spell 能够帮你模糊拼写，有时候忘了单词怎么拼，可以使用它。

苹果默认的词典量很少，可以点击这里下载更多扩展词典：[macOSConfig/macOS_Dictionary · iHTCboy/macOSConfig](https://github.com/iHTCboy/macOSConfig/tree/master/macOS_Dictionary)

以搜索`apple`示例：
![Alfred-Features-Dictionary-Define.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Dictionary-Define.png)

#### Contacts（联系人）
![Alfred-Features-Contacts.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Contacts.png)

Alfred 也内置了 `Contacts`（通信录）查询，联动 Apple 自带的通讯录，输入对应小伙伴的名词能够查看对应名片，还能够 Copy 对应的信息。这里因为我们是程序员，所以其实很少使用到名片，所以这里就不作过多说明了。

#### Music（音乐）
![Alfred-Features-Music.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Music.png)

可以从键盘控制 iTunes与 Alfred 的内置迷你播放器，搜索你的 iTunes音乐收藏，按流派风格或随机播放专辑等。这里国区喜欢用国区的音乐App，一般人都不会购买 Apple Music 服务，所以就不多说，需要的可以自己用用啊。

官网示例：
![Alfred-Features-Music-MiniPlayer.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Music-MiniPlayer.png)

#### 1Password（密码）
![Alfred-Features-1Password.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-1Password.png)

搜索并直接从 Alfred 打开你 `1Password` 中的书签。

![Alfred-Features-1Password-1Click.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-1Password-1Click.png)

但是现在我已经不使用 `1Password` 密码管理软件了，因为 `iCloud` 的 `Passwords & Accounts`（密码和账号）已经非常棒！不需要再记录或查找密码，当然，iCloud 现在对密码和账号的权限管理不足，没有单独的访问和管理密码，使用了macOS或iPhone的设备密码，所以如果密码泄漏就都完了。

#### System（系统）
![Alfred-Features-System.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-System.png)

Alfred 支持系统功能操作，例如：`Screen Saver`（显示待机屏幕）、`Empty Trash`（清空回收站）、`Log Out`（登出当前用户）、`Sleep`（睡眠模式）、`Sleep Displays`（关闭屏幕显示）、`Lock`（锁屏）、 `Restart`（重启）、`Shut Down`（关机）、`Volume Up`（增加音量）、`Volume Down`（减少音量）、`Toggle Mute`（静音）等快捷命令。

针对应用程序可以：`Hide`（隐藏）、`Quit`（退出程序）、`Force Quit`（强制退出）、`Quit All`（退出所有程序）。

`Eject` 是弹出磁盘、存储卡或者虚拟磁盘镜像，如 .dmg 挂载后的磁盘。`Eject All`是全部弹出。

以上的操作，都是可以自定义关键字，另外有一些后面带 `Confirm`的，表示是一些危险的操作，可以勾选，在操作时会先弹窗提示操作的风险。

比较常用的推荐：`Lock` 锁屏，放心离开办公位，开会！如果是去厕所，则可以用 `Sleep Displays`，临时关闭屏幕；`Empty` 清空回收站。


#### Terminal（终端）
![Alfred-Features-Terminal.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Terminal.png)

从 Alfred 在终端中运行命令和脚本，运行 shell 和终端命令，可以设置使用 `>` 或其它更改为前缀符号来表示当前要执行命令，默认是打开 macOS 的`终端`软件，也可以更改为打开 `iTerm`，关于 iTerm 软件的使用和快捷键可以查看我之前的文章 [iTerm2快捷键小记](https://ihtcboy.com/2018/08/03/2018-08-03_iTerm%E5%BF%AB%E6%8D%B7%E9%94%AE%E5%B0%8F%E8%AE%B0/)。

![Alfred-Features-Terminal-Shell.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Terminal-Shell.png)

更改命令从 `iTerm` 打开的方式很简单，在 `Application` 选择为 `Custom`（自定义），然后在下方的文本框输入下面的苹果脚本代码就可以：

```applescript
on alfred_script(q)  
    if application "iTerm2" is running or application "iTerm" is running then  
        run script "  
            on run {q}  
                tell application \":Applications:iTerm.app\"  
                    activate  
                    try  
                        select first window  
                        set onlywindow to false  
                    on error  
                        create window with default profile  
                        select first window  
                        set onlywindow to true  
                    end try  
                    tell current session of the first window  
                        if onlywindow is false then  
                            tell split vertically with default profile  
                                write text q  
                            end tell  
                        end if  
                    end tell  
                end tell  
            end run  
        " with parameters {q}  
    else  
        run script "  
            on run {q}  
                tell application \":Applications:iTerm.app\"  
                    activate  
                    try  
                        select first window  
                    on error  
                        create window with default profile  
                        select first window  
                    end try  
                    tell the first window  
                        tell current session to write text q  
                    end tell  
                end tell  
            end run  
        " with parameters {q}  
    end if  
end alfred_script
```

#### Large Type（放大镜风格）
![Alfred-Features-Large-Type.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Large-Type.png)

一些执行结果的文本可能为了方便其它人？需要显示放大的效果，这里就不多说，感觉可以大家用的不多。例如执行 `2^10` 的结果，按 `comd + L` 快捷键就可以显示：

![Alfred-Features-Large-Type-Calculator.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Large-Type-Calculator.png)

#### Previews（预览）
![Alfred-Features-Previews.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Features-Previews.png)

熟悉 macOS 系统的同学都知道，macOS 有一个很方便的功能叫 `Quick Look`，就是在 Finder 中选中文件后按下 `空格键`（Space键），就能在不打开应用程序的情况下对文件进行快速预览，比如PDF、图片、视频、音频文件等等。Alfred 也集成了这一功能，不过此时的快捷键就不是Space了，而是 `⇧`键（`shift`键）。在 Alfred 的搜索结果列表中选中想要进行预览的文件，按下 shift键就能利用 Quick Look 进行预览了。有时候对某些文件或者某些路径下的文件进行预览，如果你不想对这些文件或者路径下的文件进行预览，可以在 `No Previews For` 和 `No Previews In`中设置。

### Workflows（工作流）
![Alfred-Workflows.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Workflows.png)

`Workflows` 翻译中文为**工作流**，应该也比较好理解。刚才上面介绍的功能，有一部分就是工作流，可以理解为Alfred自带的工作流。类似的，你是不是能想到一些可以定制化的操作流程呢？所以，当然也可以使用第三方的工作流，或者自己定义自己的工作流！

如果想要使用第三方的或者自定义的工作流，需要支付购买Alfred的`PowerPack`（动力组），Alfred的 PowerPack 是最值得购买的服务，没有之一。因为如果使用 Alfred 而没有 PowerPack 授权，那 Alfred 的强大的功能相当失去了左右臂。关于 PowerPack 细节我们在下一节内容在讨论，我们接着说 Workflows（工作流）。

Alfred 安装完「Powerpack」，就像车体安装了引擎，余下的事情就看我们如何 DIY，让引擎为我们提供无限动力。而引擎提供动力的燃料我们称其为 `Workflow`。官方对于 workflow 是这样描述的：

> With Alfred's Powerpack and workflows, you can extend Alfred and get things done in your own way. Replace repetitive tasks with workflows, and boost your productivity.
> Discover the abundance of workflows that integrate with your favourite Mac applications and web services, from social networks and note-taking apps to shopping and music services.
> We've hand-picked a few of the best workflows here. You'll find hundreds more on [Packal](http://www.packal.org), a brilliant user-created repository for workflows, as well as on [Alfred Forum](https://alfredforum.com), where you'll also find help in creating your own workflows.
> 借助Alfred的Powerpack和工作流程，您可以扩展Alfred并以自己的方式完成工作。用工作流替换重复的任务，并提高工作效率。
> 发现丰富的工作流程，这些工作流程与您喜欢的Mac应用程序和Web服务集成在一起，从社交网络和记笔记应用程序到购物和音乐服务。
> 我们在这里手工挑选了一些最佳的工作流程。在 [Packal](http://www.packal.org)（一个出色的由用户创建上传的workflows的网站）上以及 [Alfred Forum](https://alfredforum.com)（您可以在其中找到有关创建自己的workflows的帮助）的更多信息。


#### 认识 Workflows 结构

实现 WorkFlows 的四个基本对象：`trigger`、`keyword`、`action`、`output`。Alfred 通过将这四个基本对象合理链接「Connect」，便能实现各种高级功能。而在 Alfred 的 Workflow 配置界面中，大体上可以将其分为三栏，trigger 和 keyword 都会触发后续行为，所以归到「原因」类；Action 是「过程」类，也是 workflow 的核心，它负责处理用户需求；而 output 是「结果」类，负责把 action 的结果以一定的形式传递给用户，可以是直接屏显，也可以是另存为文件，也可以是返回到最后一个程序的输入框中。总之这三个类别「四个对象」各司其职，最终可以完成较为复杂的数据处理和用户需求。而这四个对象都可以用「线」链接，来形成直接或间接的条件结果关系。

本文主要是提高效率，所以关于如何自定义 Workflows（工作流）暂时不讲解，后面有需要在回来增加，原因 Workflow 创作的门槛比较低，类似iOS的 workflows，同时 workflow 支持的编程语言也非常多。可以参考现有的那些 Workflows（工作流），可以看到他们是怎么构建和流程的。另外，也可以参考我写过的 Workflows：[用 Alfred Workflow 实现聊天内容快速引用回复](https://ihtcboy.com/2019/11/17/2019-11-17_%E4%B8%80%E4%B8%AAAlfred%E7%9A%84Workflow%E8%81%8A%E5%A4%A9%E5%86%85%E5%AE%B9%E5%BC%95%E7%94%A8%E6%B6%88%E6%81%AF/)，借鉴一些痛点，来实现自己的工作流！

下面会列出我现在使用的一些高效的 Workflows（工作流）插件，因为太多，所以就不全部都介绍，大家可以在这里看到我使用的全部 Alfred 相关的内容：[macOSConfig/Alfred - iHTCboy](https://github.com/iHTCboy/macOSConfig/tree/master/Alfred)


#### 高效 Workflows 推荐

- **最近使用的文件/应用等**
最近打开的文档：
![Workflows-Recent-Documents.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Workflows-Recent-Documents.png)

最近打开的应用：
![Workflows-Recent-Apps.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Workflows-Recent-Apps.png)

教程：[妙用 Alfred 让你最近使用的文件触手可及](https://sspai.com/post/47063)
下载：[mpco/AlfredWorkflow-Recent-Documents](https://github.com/mpco/AlfredWorkflow-Recent-Documents/releases)


- **Finder路径快速打开切换到终端（iTerm）的路径**
下载：[TerminalFinder | Packal](http://www.packal.org/workflow/terminalfinder)

- **快速复制当前文件夹路径或者文件名字**
此插件来源：[hzlzh/Alfred-Workflows](https://github.com/hzlzh/Alfred-Workflows)，下面这个下载链接是博主改造后的，增加了文件名的复制，和使用最新的 Finder 图标。快捷复制当前Finder选择的文件(`cp`)的文件路径或文件名(`cpn`)。
下载：[macOSConfig/Alfred at master · iHTCboy/macOSConfig](https://github.com/iHTCboy/macOSConfig/tree/master/Alfred)

- **Xcode 开发者清理 DerivedData 数据**
![Workflows-Clear-Xcode-DerivedData.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Workflows-Clear-Xcode-DerivedData.png) 
下载：[ChopinChao/xcdd_workflow: a simple xcdd workflow for Alfred2](https://github.com/ChopinChao/xcdd_workflow)

- **全局打开App（可自定义快捷键）**
教程：[优秀 workflow 推荐 · GitBook](http://mac.bestswifter.com/mac-gong-zuo-liu/you-xiu-workflow-tui-jian.html)
下载：[my-workflow/AppLauncher.alfredworkflow · bestswifter/my-workflow](https://github.com/bestswifter/my-workflow/blob/master/AppLauncher.alfredworkflow)

- **Linux Command**
下载：[jaywcjlove/linux-command: Linux命令大全搜索工具，内容包含Linux命令手册、详解、学习、搜集。https://git.io/linux](https://github.com/jaywcjlove/linux-command)

- **Encode / Decode**
下载：[willfarrell/alfred-encode-decode-workflow: Encoding and decoding a sting into multiple variations.](https://github.com/willfarrell/alfred-encode-decode-workflow)

- **快速调整图片尺寸**
下载：[Resize Image | Packal](http://www.packal.org/workflow/resize-image)

- **配合 TinyPNG 快速压缩图片**
教程：[alfred 使用 workflows 快速进行图片压缩](https://evolly.one/2019/04/12/77-alfred-gallery/)
下载：[alfred-gallery/image Compressor.alfredworkflow - BlackwinMin/alfred-gallery](https://github.com/BlackwinMin/alfred-gallery/blob/master/image%20Compressor/image%20Compressor.alfredworkflow)

- **取色值工具**
下载：[Colors | Packal](http://www.packal.org/workflow/colors)

- **快速在当前 Finder 窗口创建新文件**
下载：[NewFile | Packal](http://www.packal.org/workflow/newfile)

- **Chrome History**
Chrome History 以及 Chrome Bookmarks 可以用于搜索 Chrome 的收藏书签和历史记录（支持模糊搜索）。
下载：[tupton/alfred-chrome-history: Search your Google Chrome history in Alfred](https://github.com/tupton/alfred-chrome-history)

- **从谷歌浏览器打开URL**
下载：[Alfred Chrome | Packal](https://www.packal.org/workflow/alfred-chrome)

- **有道翻译**
下载：[kaiye/workflows-youdao: 学英语和写工具](https://github.com/kaiye/workflows-youdao/)

- **谷歌翻译**
下载：[xfslove/alfred-google-translate: Alfred 3 workflow - translate with google api💵🚫](https://github.com/xfslove/alfred-google-translate)

- **聊天内容快速引用回复**
教程：[用 Alfred Workflow 实现聊天内容快速引用回复](https://ihtcboy.com/2019/11/17/2019-11-17_%E4%B8%80%E4%B8%AAAlfred%E7%9A%84Workflow%E8%81%8A%E5%A4%A9%E5%86%85%E5%AE%B9%E5%BC%95%E7%94%A8%E6%B6%88%E6%81%AF/)
下载：[macOSConfig/Reply Message v1.0.alfredworkflow at master · iHTCboy/macOSConfig](https://github.com/iHTCboy/macOSConfig/blob/master/Alfred/Reply%20Message%20v1.0.alfredworkflow)

- **Evernote**
支持印象笔记的全局搜索。这功能很好很强大，能够帮助自己快速定位到具体的印象笔记的条目之上。
下载：[Evernote Workflow 9 beta 4 (Alfred 4) - Share your Workflows - Alfred App Community Forum](https://www.alfredforum.com/topic/840-evernote-workflow-9-beta-4-alfred-4/)

- **货币转换**
下载：[Currency Exchange | Packal](http://www.packal.org/workflow/currency-exchange)

- **Dash**
代码 Doc 文档全局快速搜索。
教程：[Dash: Quicker API Documentation Browsing - Alfred Blog](https://www.alfredapp.com/blog/productivity/dash-quicker-api-documentation-search/)

- **世界主要城市时区查询**
下载：[TimeZones | Packal](http://www.packal.org/workflow/timezones)


这些工作流还有很多，大家可以发挥自己的需求自定制。另外，还有非常多没有推荐的，可以参考文末的 workflows 链接大全。

#### 更多 Workflows 资源

- [Workflows 官方站点](https://www.alfredapp.com/workflows/)
官方推荐的「装机必备」系列 Workflows。

- [Packal](http://www.packal.org)
官方推荐的 Workflows 分享站点。

- [Workflows 中文站](http://www.alfredworkflow.com)
国人收藏的超多 Workflows.

- [zenorocha/alfred-workflows: A collection of Alfred 3 and 4 workflows that will rock your world](https://github.com/zenorocha/alfred-workflows)
这个 Github 上维护的 workflows 很赞！汇总了开发用的 workflows。

- [Alfred 论坛](http://www.alfredforum.com)
个人开发者开发的解决比较特别的问题的插件居多。


### Appearance（外观）
![Alfred-Appearance.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Appearance.png)

Alfred 默认的样式是白色背景不太好看，当然也提供了几个外观样式供大家选择。另外也可以自定义外观，比如上图中博主的主题，采用了玻璃背景透明，白色输入文字，蓝色选择文字，白灰色默认文字，淡黄色快捷键文字。喜欢折腾 DIY 样式的小伙伴可以在 Appearance 面板中修改或点击 `+` 增加 Alfred 交互面板的样式。另外，也可以下载别人的外观样式，比如在网站 [Packal](http://www.packal.org/)。

下载博主此主题外观链接：[iHTCboy-Theme.alfredappearance](https://github.com/iHTCboy/macOSConfig/tree/master/Alfred/Appearance)

### Remote（远程）
![Alfred-Remote.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Remote.png)

Alfred 同时也支持使用 `移动端版本的 Alfred` 来控制桌面端，下载链接 [Alfred Remote on the App Store for iOS](https://apps.apple.com/app/alfred-remote/id927944141?ign-mpt=uo%3D4)。

`Alfred Remote for iOS` 最新版本 1.1 是 2015年9月1日发布的，收费 30 人民币。如今5年不更新了，所以暂时不指望它带来什么高效，建议大家暂时也别下载吧。如果需要了解更多，可以参考这个文章的教程：[OS X 效率启动器 Alfred 的最佳伴侣：Alfred Remote for iOS 上手详解 - 少数派](https://sspai.com/post/28137)。

### Advanced（高级）
![Alfred-Advanced.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Advanced.png)

配置中有涉及一些高级配置功能，一般不需要更改配置。

- `Files / Apps`
对 Alfred 和 搜索引擎重置，`Clear Application Cache`(缓存清理)、`Rebuild macOS Metadata`(元数据重建) 。

- `Force Keyboard`
就是 Alfred 输入框中默认的输入法。

- `History`

- `Action Modifiler`
搜索结果项右边的快捷键，默认是 `cmd + 数字`（cmd为苹果键 `⌘`），可以更改为 `^ + 数字`（^ 为 `ctrl` 键）。

这里还有一些默认的动作快捷键，比如在 Alfred 输入`swift`后，通过下面三个快捷键可以快捷执行操作：
* `ctrl + ↩︎`：在浏览器默认的搜索引擎来查询`swift`关键词。
* `alt + ↩︎`：打开 `Finder`（访达）的搜索框查询`swift`。
* `cmd + ↩︎`：打开 Alfred 搜索结果项所在的文件目录（如果是本地文件的话）。

以上快捷键可以更改不能的 Action（动作），大家可以自行调整。

- `Learning`

- `Notifications`

- `Network`

- `Selection Hotkeys`

- `Syncing`（同步）
可以设置 Alfred 所有的配置内容，包括 Workflows 工作流 和 Appearance 主题，都可以备份和同步。作者建议用 Dropbox 网盘同步，因为一些大家懂的原因，这里我建议使用 `iCloud Drive` 这样更加好！设置方式很简单，点击 `Set preference folder` 弹窗中，找到 iCloud 分类下的 iCloud Drive 目录，在目录下新建一个 `Alfred` 文件夹来存放 Alfred 所有配置的同步文件（Alfred.alfredpreferences），这样，以后如果你有多台 macOS 系统，登陆同一个 `Apple id` 账号就可以无缝的同步在所有的设备上面，不需要关注所有内容。点击 Alfred 的 `Reveal in Finder` 可以打开你设置的同步文件所在的目录。

当然，目前每个 macOS 下的 Alfred 的 `Usage`（使用情况）不会同步共享，另外，如果你电脑的硬盘空间不足（少于20GB），`iCloud Drive`的内容在本地系统中经常被清空，导致需要在远端重新下载 Alfred 的同步文件（Alfred.alfredpreferences），只能说买电脑要空间大一点吧！


### Powerpack（动力组）
![Alfred-Powerpack.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Powerpack.png)

`Workflows`（工作流）扩展功能、文件导航、剪贴板历史、通讯录、iTunes Mini播放器等，都是需要购买此 `Powerpack`（动力组） 升级包的，否则免费试用版本是无法使用工作流。博主个人推荐有经济能力的人可以购买正版的授权码，因为软件的价值，本系列的第一篇文章提过。

目前只支持 `VISA`、`Mastercard`（万事达卡）、`AMEX`（American Express，美国运通）的信用卡，或者 `Paypal` 支付。所以对于中国区来说还是不太友好！目前`2020年`的V4版本的单个授权码是 `£25` 英磅，大约 `￥225.26`人民币。而超级支持者可以支付 `£45` 英磅，大约 `￥405.10`人民币，终身免费升级。注意这里是单个用户，就是一个激活码只能用于一台macOS。具体的购买流程这里省略了，有条件的同学建议按需选择购买。

关于 Alfred 那些功能需要购买 Powerpack 后才能使用的，参考官网： [Alfred Powerpack - Take Control of Your Mac and macOS](https://www.alfredapp.com/powerpack/)

### Usage（使用情况）
![Alfred-Usage.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Usage.png)

Alfred 会统计使用的情况。从上图可以看到折线图显示的是28天的使用情况（`当然因为编写文章时，因春节放假，所以有一个波谷区。`），从2019年9月2号起，使用 Alfred 达到 6321 次，平均每天使用 39 次。同时也可以看到 `Clipboard` 和 `Hotkeys` 使用最频繁。为了说明 Alfred 的潜在价值，我们不妨做一个简单的计算，假设每天我都能够保持现况以每日平均唤醒 39 次为基数。假如每次 Alfred 的操作，可以为我节省 5s 的时间（往往有些复杂的操作会大于 5s，比如去寻找一个藏得很深的文件，或者一个记不全的文件或者一个不常用的软件，或者打开一个常用的书签等等)，那么 1 年下来，竟然能够节省 0.82 天。

` 39 * 5 * 365 / 3600 / 24 = 0.823784722 天`

换言之，Alfred 让你的生命延长了 0.82 天！那如果是 5 年，就是 4 天啦！这里是以 39 次为基数，从本文上面的教程可以看出，一个复杂的操作节省可以有几分钟，如果重复一百次就远不止，所以，节省的时间是非常可观的！总之，大家经常有大量重复的工作流或操作步骤，这就更加可观，所以马上使用起来吧！

### Help（帮助）
![Alfred-Help.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Help.png)

注意页面有一个提示 `Try Searching the Preferences`，就是可以搜索软件的所有的配置项目，这个搜索功能非常有用的，因为 Alfred 有非常多的配置项，所以如果你不想一步一步点击打开，搜索永远是最快的，Alfred 中搜索 Alfred，作者还是很用心！另外在 Alfred 输入框中使用 `?关键词` 也可以搜索 Alfred 的偏好设置。

其它的就是帮助和反馈页面，点击会跳转到网页中，这里就不展开了。

### Update（更新）
![Alfred-Update.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/Alfred-Update.png)

这个更新页面也很重要，让我们了解到最新版本到底做了什么调整或新的功能。我发现很多应用没有做好 ChangeLog，至少说明软件做的不够用心，用户关心的不是你有多牛逼，自己使用自己体验，更新说明文档是一项软件开发中非常重要的一部分。这里就不细说了，有时间在写文章一起聊吧。

### 其它问题汇总
在这里汇总一下，在使用 Alfred 时可能遇到的一些问题，这部分在后续会持续更新。其中，首次安装或启动时，默认会显示这样的权限弹窗：
![macOS-Permissions-for-Alfred.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Permissions-for-Alfred.png)

说明权限是 Alfred 最重要和基础的必要条件，下面我们就来看看有那些必要的系统权限。

#### macOS 系统权限问题
在 macOS 10.15 后，苹果收缩了软件访问系统的各种权限，比如说硬盘、文件夹、屏幕录制、输入监视、自动化等。我们来具体说说对 Alfred 的影响：
 
- `辅助功能`：允许 App 控制你的电脑。
![macOS-Preferences-UniversalAccess.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Preferences-UniversalAccess.png)

在 Alfred 中用于控制电脑的时如果没有权限时：
![macOS-Preferences-UniversalAccess-Alfred.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Preferences-UniversalAccess-Alfred.png)

- `输入监视`：即使正在使用其它App，也允许下面的App监视来自键盘的输入。
在 Alfred 中应用说无处不键盘，全部都使用到键盘，其中强烈依赖的有 Snippets，另外 Workflows 也用于监听键盘。
![macOS-Preferences-Input-Monitoring.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Preferences-Input-Monitoring.png)

- `完全磁盘访问权限`：允许 App 访问诸如“邮件”、“信息”、Safari 浏览器、“家庭”、时间机器备份，以及此 Mac 上所有用户的部分管理设置等数据。
在 Alfred 中很多数据都是依赖于系统的磁盘目录。
![macOS-Preferences-Full-Access.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Preferences-Full-Access.png)

- `文件和文件夹`：允许App访问文件和文件夹
![macOS-Preferences-Folder-Access.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Preferences-Folder-Access.png)

在 Alfred 中如果需要打开或跳转到相应目录都是需要文件目录权限。需要注意的时，当然勾选了上面的`完全磁盘访问权限` 后，此项默认变成默认勾选，变成无法操作的状态，这个很好理解。如果首次安装时 Alfred后，会出现访问桌面时类型的文件夹权限的提示：
![macOS-Preferences-Folder-Access-Desktop.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Preferences-Folder-Access-Desktop.png)

- `自动化`：允许 App 控制其他 App。这将允许 App 访问这些受控制 App 中的文稿和数据，并在其中执行操作。
![macOS-Preferences-Automation.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2020/02/macOS-Preferences-Automation.png)

这个 Alfred 中用到最多的是访问 Finder（访达）App。

综上，我们主要是想讲解一下系统的权限和 Alfred 使用到的权限，这样更好的了解这些权限，以便你来决定那些敏感或数据可以通过这些设置来关闭或启动，`在高效和隐私之间做一个平衡点`。

#### 书签功能搜索无结果
如果你刚升级到 macOS 10.15 后，可能会出现搜索浏览器的书签没有搜索到的问题。这是因为系统权限原因，需要在系统偏好设置中的 `安全性与隐私 `-> `隐私` ->`完全磁盘访问权限` 勾选 `Alfred 4.app`。然后在 Alfred 中输入 `Reload Alfred Cache` 后回车键，Alfred 重新加载缓存就可以搜索书签。如果不给权限，那么在 `macOS 10.15` 下无法使用书签搜索。


## 总结
综上，我们已经把 Alfred 的所有功能都讲解完！大家是不是有一个全面的了解了呢！基于最新的 Alfred v4.0 版本！没有想到2年前立下的flag，2年后才完成，所以`希望这篇文章也2年内都能正确和高效的给大家指导作用！`（按 Alfred 更新的情况，改版不会变化很大啊~）又是万字文章，可能不是所有人都能有耐心看完，但希望你是看完并有所收获！Alfred 是 macOS 系统上`程序员必备的效率神器`！希望大家看到本文章`为时未晚`！都能更好地使用 Alfred 来提高日常的生活和工作效率啊！

由于篇幅长度的限制，部分内容的扩展和深度可以阅读下面的参考文章。建议大家看完本文后，都操作一遍，而没有使用过的同学，更加应该开始使用 Alfred！希望大家都开始自己的 Alfred 之旅！提高自己日常工作生活的效率，省时省力，`让效率为程序员所用！`

## 参考

- [Alfred - Productivity App for macOS](https://www.alfredapp.com/)
- [Packal - Alfred Workflows and Themes](http://www.packal.org/)
- [Alfred Forum](https://alfredforum.com)
- [Mac 词典工具推荐：Youdao Alfred Workflow（可同步单词本） - 猫哥_kaiye - 博客园](https://www.cnblogs.com/kaiye/p/5115005.html)
- [用 Alfred Workflow 实现聊天内容快速引用回复 | iHTCboy's blog](https://ihtcboy.com/2019/11/17/2019-11-17_%E4%B8%80%E4%B8%AAAlfred%E7%9A%84Workflow%E8%81%8A%E5%A4%A9%E5%86%85%E5%AE%B9%E5%BC%95%E7%94%A8%E6%B6%88%E6%81%AF/)
- [Mac OS必备工具：Alfred - 曙光博客](https://www.ezloo.com/2019/04/alfred.html)
- [Alfred 效率神器全攻略](http://blog.surfacew.com/tool/2016/08/03/Alfred/)
- [OS X 效率启动器 Alfred 的最佳伴侣：Alfred Remote for iOS 上手详解 - 少数派](https://sspai.com/post/28137)
- [使用通用剪贴板在 Apple 设备之间进行拷贝和粘贴 - Apple 支持](https://support.apple.com/zh-cn/HT209460)
- [在 iPhone 上使用通用剪贴板 - Apple 支持](https://support.apple.com/zh-cn/guide/iphone/iph220ea8dca/ios)
- [从 Mac 上拷贝并在设备间粘贴 - Apple 支持](https://support.apple.com/zh-cn/guide/mac-help/mchl70368996/mac)
- [stidio/Alfred-Workflow: Alfred Workflow教程与实例; CDto: 打开Terminal并转到任意文件夹或文件所在目录; Effective IP:查询本机和外网IP地址，解析任意URL和域名的IP地址，以及进行归属地和运营商查询; UpdateAllNPM: 更新所有Node.js全局模块; UpdateAllPIP: 更新所有Python模块](https://github.com/stidio/Alfred-Workflow)
- [玩转Mac Alfred - LifePro](http://www.lifepro.site/blog/blogdetail/84/)
- [2.2. Mac 第一神软 Alfred · Mac 高效实用指南 · 看云](https://www.kancloud.cn/chopin/mac_program/882465)
- [总是在 Mac 「装机必备」看到的搜索利器 Alfred，究竟是怎么用的？| 新手问号 - 少数派](https://sspai.com/post/43973)
- [一切为了让效率更进一步，Alfred 4.0 更新详解 - 少数派](https://sspai.com/post/55098)
- [Alfred Workflow 从使用到创造 - 少数派](https://sspai.com/post/57648)
- [真正提升你的输入效率，从用好 Alfred 的这个功能开始：Alfred Snippets - 少数派](https://sspai.com/post/46034)
- [妙用 Alfred 让你最近使用的文件触手可及 - 少数派](https://sspai.com/post/47063)
- [看起来很复杂的 DEVONthink 搜索，用 Alfred Workflow 就能轻松搞定 - 少数派](https://sspai.com/post/51174)
- [从 0 到 1 写一个 Alfred Workflow - 少数派](https://sspai.com/post/47710)
- [小白实践《从 0 到 1 写一个 Alfred Workflow》遇到的问题及解决方案 - 少数派](https://sspai.com/post/48386)
- [Windows 上的 Alfred，免费开源的效率启动器：Wox - 少数派](https://sspai.com/post/33460)
- [从零开始学习 Alfred：基础功能及设置 - 少数派](https://sspai.com/post/32979)
- [使用 AppleScript、Tags 和 Alfred 重新打造文件管理和搜索系统 - 少数派](https://sspai.com/post/42859)
- [用 Ai Search 和 Drafts 实现 Alfred 的搜索体验 - 少数派](https://sspai.com/post/35377)
- [5 款提高文件处理效率的 Alfred 扩展 - 少数派](https://sspai.com/post/32680)
- [Alfred，叫你一声Mac上的效率神器你敢答应吗？_值客原创_什么值得买](https://post.smzdm.com/p/677989/)
- [Mac效率神器Alfred以及常用Workflow - 简书](https://www.jianshu.com/p/0e78168da7ab)
- [Mac效率神器Alfred系列教程---Snippets文字扩展 - 知乎](https://zhuanlan.zhihu.com/p/33753656)
- [用Alfred大幅提升操作效率 - workflow - 知乎](https://zhuanlan.zhihu.com/p/19986749)
- [Mac效率神器Alfred系列教程---剪切板历史记录 - 知乎](https://zhuanlan.zhihu.com/p/33515314)

- **Workflows推荐**
- [zenorocha/alfred-workflows: A collection of Alfred 3 and 4 workflows that will rock your world](https://github.com/zenorocha/alfred-workflows)
- [whyliam/whyliam.workflows.youdao: 使用有道翻译你想知道的单词和语句](https://github.com/whyliam/whyliam.workflows.youdao)
- [kaiye/workflows-youdao: 学英语和写工具](https://github.com/kaiye/workflows-youdao/)
- [Share your Workflows - Alfred App Community Forum](https://www.alfredforum.com/forum/3-share-your-workflows/)
- [jaywcjlove/linux-command: Linux命令大全搜索工具，内容包含Linux命令手册、详解、学习、搜集。https://git.io/linux](https://github.com/jaywcjlove/linux-command)
- [那些提高效率的Alfred Workflow - I'm company](https://blog.imcompany.cn/post/na-xie-ti-gao-xiao-lu-de-alfred-workflow/)
- [hzlzh/Alfred-Workflows: Make your Alfred more powerful. (include Workflows, Extensions and Themes)](https://github.com/hzlzh/Alfred-Workflows)
- [willfarrell/alfred-workflows: Alfred Workflows for Developers](https://github.com/willfarrell/alfred-workflows)
- [hzlzh/AlfredWorkflow.com: A public Collection of Alfred Workflows.](https://github.com/hzlzh/AlfredWorkflow.com)


<br>

- 如有侵权，联系必删！
- 如有不正确的地方，欢迎指导！
- 如有疑问，欢迎在评论区一起讨论！

<br>

> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源。

<br>