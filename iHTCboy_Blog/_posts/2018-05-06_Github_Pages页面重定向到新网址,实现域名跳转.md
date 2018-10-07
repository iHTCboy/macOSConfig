title: Github Pages页面重定向到新网址，实现域名跳转
date: 2018-05-06 16:35:16
categories: technology #life poetry
tags: [Github Pages,域名跳转,重定向,JS跳转]  # <!--more-->
reward: true

---

### 1、前言
最新还是决下心来换域名啦！从 http://ihtc.cc 换成 https://ihtcboy.com ！然后问题就来了，以前文章的链接打开404了，旧域名也访问不通，这样子不行呢！用了2年多的旧域名，在百度谷歌还是积累了一些爬虫，还有很多分享到第三方平台的文章呢！想一想，还是想救一救它！！！

<!--more-->

### 2、准备工作
首先，因为是2个域名，所以我分别用2个GitHub账号设置对应的Repo地址解析。

| 域名 | Repo |
| --- | --- |
| ihtc.cc | HeTianCong.github.io  |
| ihtcboy.com | iHTCboy.github.io |



### 3、域名重定向

首先要解决的问题是 ihtc.cc 重写向到 ihtcboy.com，在网上搜索到，域名的重定向可以有以下3种方法（如果还有其它，欢迎大家补充！）：

1. 域名转发
2. 301重定向
3. JS跳转

方法一，域名注册商支持域名转发功能才行！放弃~
方法二， 就是Web 服务器（这里是GitHub）给访问老域名的请求返回一个 302，然后跳转到新域名上。考虑到使用的GitHub托管服务是不可能配置 Web 服务器的，也只能放弃~

最后就是剩下JavaScript 实现，在 `HeTianCong.github.io` 新建
`index.html` 文件，内容为：

```
<script type="text/javascript">window.location.href="https://ihtcboy.com";</script>
```

**解析：**

index.html就是访问 ihtc.cc 时，GitHub 默认打开的页面，所以在里面用JS重写向到新的域名，这样就解决了旧域名重写向新网址的问题啦！！


### 4、文章重定向

旧的文章链接：

```
http://ihtc.cc/2018/02/25/2018-02-25%20_Gitment评论功能接入踩坑教程/
```

既然要重定向到新的域名，，就不可能在旧的Repo里增加全部旧文章吧（虽然方案是可行），但是这样又起不到读者知道新域名的问题，硬要搞2个Repo，那就没有前面的重定向必要啦！！！

最后想到旧的链接访问不通时，表现形式：
**404 
There isn't a GitHub Pages site here.**！

那么在 Repo 下建立一个 `404.html`，这样是不是就可以拿到访问文章的链接，然后就你所欲为！（拿旧域名替换成新域名就可以啦！）马上就开始行动吧！

`404.html` 文件，内容为：

```
<script src="http://cdn.bootcss.com/purl/2.3.1/purl.min.js"></script>

<script>
var url = purl();
if (url.attr('host') == 'ihtc.cc') {
    var old_url = url.attr('source');
    var new_url = old_url.replace('ihtc.cc', "ihtcboy.com");
    window.location.replace(new_url); 
}else if (url.attr('host') == 'www.ihtc.cc') {
    var old_url = url.attr('source');
    var new_url = old_url.replace('www.ihtc.cc', "ihtcboy.com");
    window.location.replace(new_url);
}else {
    window.location.href="https://ihtcboy.com";
}
	
</script>
```

上面js是放在 404.html 里面，当文章访问不通时会显示 404.html 页面，这时就会直接调用js判断域名，然后替换成新域名来访问！

最后实践发现，这个方法可行！！！（当然，有些禁止js运行的浏览器这些人群就被忽略吧，不属于大多数人的世界-.-）

从浏览器访问 `www.ihtc.cc/xxx` 或 `ihtc.cc/xxx` 的读者，都会被重定向到 **ihtcboy.com**! 

以上全部的配置内容可参考 [HeTianCong.github.io](https://github.com/HeTianCong/HeTianCong.github.io)

### 5、总结
刚开始是想放弃，因为经常中谷歌搜索文章里，常常发现404的 **There isn't a GitHub Pages site here.**，都是怀疑作者域名过期或变更等，又没有自己后台服务器，只能不了而之，旧的读者从此就与这个网站失联，觉得是有点可惜！

所以，今天的这个文章，希望对愿意写文章，有又变更域名需求的博客同仁来说，希望是一个更好的开始！



### 6、参考

- [HeTianCong.github.io](https://github.com/HeTianCong/HeTianCong.github.io)
- [如何实现域名A指向域名B？三种域名跳转方法供选择 - CSDN博客](https://blog.csdn.net/dianjinmi/article/details/78383955)
- [博客折腾记之网址变更｜Ruo Dojo](https://blog.jamespan.me/2015/04/12/the-blogs-migration)
- [三谈github页面域名绑定：域名跳转 - 雁起平沙的网络日志](http://yanping.me/cn/blog/2012/02/06/github-pages-domain-3/)


<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源


