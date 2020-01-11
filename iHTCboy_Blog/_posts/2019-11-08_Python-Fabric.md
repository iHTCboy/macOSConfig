title: Python 远程部署神器 Fabric
date: 2019-11-08 22:49:16
categories: technology #induction life poetry
tags: [Python,Fabric]  # <!--more-->
reward: true

---

### 1、是什么
Fabric 是一个 Python (2.5, 3.4+) 的库和命令行工具，用来提高基于 SSH 的应用部署和系统管理效率。

而网上搜索了一些教程，发现很旧或者因为Fabric版本不兼容问题，导致代码分裂断层搞不明白，所以就有了本文。

<!--more-->


### 2、为什么
如果不通过 `jenkins` `git` 部署，那么 `pyhton` 项目用 `Fabric` 最佳：
* 一个让你通过 命令行 执行 无参数 Python 函数 的工具；
* 一个让通过 SSH 执行 Shell 命令更加 容易 、 更符合 Python 风格 的命令库（建立于一个更低层次的库）。

### 3、注意什么
`Fabric` 目前有3个版本，为了符合官方自然规律发展，我们建议使用 `Fabric2`：
1. `Fabric`：官方Fabric，只支持 Python 2，如果使用 Pyhon3 已经抛弃。
2. `Fabric2`：兼容 Python 2 & Python 3，但不兼容Fabric 1.x的fabfile，而且有些模块和用法也发生了很大改变。（可使用Fabric包安装1.x 版本，使用Fabric2包安装2.x版本，来实现1.x和2.x的共存）
3. `Fabric3`：是一个基于Fabric 1.x 的fork，兼容Python2 & Python3，兼容 Fabric1.x 的 fabfile。（非官方维护）

### 4、怎么做
安装 Fabric，默认就是安装 Fabric2：

```
pip3 install fabric
```

具体怎么使用，我们直接代码，简单就懂：

```python3
# 导入库
from datetime import datetime
from invoke import run
from fabric import Connection
 
 
def main():
 
    # 用 run 执行本地的环境，跟终端执行一样， 比如 cd 、 ls 命令
    run("cd /tmp/dir")
    # 执行压缩文件
    run("tar czvf archive.tar.gz /tmp/dir")
 
 
    # 建立远端链接
    # 如果你的电脑配了ssh免密码登录，就不需要 connect_kwargs 来指定密码了。
 
    c = Connection("root@172.168.04.14:22", connect_kwargs={"password": "密码"})
 
    with c.cd("/data/www/"):
        # 这里执行的就是远程服务器的 shell ：
        c.run("echo '[Current path] ' `pwd`;")
        # 命令 put 为从本地上传文件到远端
        c.put(zip_file_path, remote_path)
        # 压缩文件
        c.run("tar -xzvf  archive.tar.gz -C /data/www/")
        # 命令 get 为从远程下载文件到本地
        c.get('/data/ www/bk-2019.tar.gz', "/user/htc/Python/bg.gz")
 
```

直接在终端执行编写好的 Python 脚本执行就可以~

Fabric，so easy！ 就是这么简单~


### 参考

- [Welcome to Fabric! — Fabric documentation](https://www.fabfile.org/)
- [欢迎访问 Fabric 中文文档 — Fabric 文档](https://fabric-chs.readthedocs.io/zh_CN/chs/index.html)
- [Python - Fabric简介 - Anliven - 博客园](https://www.cnblogs.com/anliven/p/9186994.html)
- [远程部署神器 Fabric，支持 Python3 - Python之禅 - CSDN博客](https://blog.csdn.net/zV3e189oS5c0tSknrBCL/article/details/85271219)
- [python模块fabric踩坑记录 | 淦](https://tankeryang.github.io/posts/python%E6%A8%A1%E5%9D%97fabric%E8%B8%A9%E5%9D%91%E8%AE%B0%E5%BD%95/)
- [python三大神器之fabric（2.0新特性） - 三只松鼠 - 博客园](https://www.cnblogs.com/shenh/p/10060149.html)
- [Fabric 让 Linux 系统部署变得简单](https://www.ibm.com/developerworks/cn/linux/simplyfy-linux-deployment-with-fabric/index.html)


<br>

- 如有不正确的地方，欢迎指导！
- 如有疑问，欢迎在评论区一起讨论！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
<br>


