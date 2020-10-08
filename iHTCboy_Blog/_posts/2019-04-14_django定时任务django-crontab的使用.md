title: django 定时任务 django-crontab 的使用
date: 2019-04-14 19:19:16
categories: technology #induction life poetry
tags: [django,django-crontab,python]  # <!--more-->
reward: true

---

### 1、前言
在做 django 开发需求时，多多少少都会遇到需要定时任务的功能，比如定时执行任务，检查订单之类的。可能是一段时间，比如每隔 10分钟执行一次，也可能是定点时间，比如 14:00 执行，也可能是长时间，比如每周几，每个月的哪一天等。查看了一下相关资料， django 定时任务 `django-crontab` 库比较多教程和资料，虽然 star 数才五百，但是 API 接口比较简单，接入也很方便，功能也很全面，当然，也存在一此无法解决的问题，使用时需要注意的。

<!--more-->

### 2、使用教程
1.安装:

```python
pip install django-crontab
```


2.添加配置到 settings.py `INSTALLED_APPS` 中

```python
INSTALLED_APPS = (
    'django_crontab',
    ...
)
```

3.编写定时函数:

> 定时任务可以分成两种，一种是执行自定义的 `mange.py` 的命令，另一种是执行自定义函数。

在django的app中新建一个myapp/cron.py文件，把需要定时执行的代码放进去

示例：
```python
def my_scheduled_job():
  pass
```

4.在 settings.py 中增加`CRONJOBS`配置

```python
CRONJOBS = [
    ('*/5 * * * *', 'myapp.cron.my_scheduled_job')
]
```

也可以定义一些关键字参数，有2种格式：

格式1：
* 要求：cron计时通常格式（有关更多示例，请参阅 [Wikipedia](http://en.wikipedia.org/wiki/Cron#Format) 和 [crontab.guru](https://crontab.guru/examples.html)）
* 要求：python模块路径下待执行定时任务
* 可选：特定于定时任务的后缀（例如，将 `out/err` 重定向到文件，默认值为''）

示例：
```
CRONJOBS = [
    ('*/1 * * * *', 'appname.test_crontab.test','>> /home/python/test_crontab.log')

]
```

注意： `>>` 表示追加写入，`>` 表示覆盖写入。

格式2：
* 要求：cron计时通常格式
* 要求：python模块路径下待执行定时任务
* 可选：方法的位置参数列表（默认值：[]）
* 可选：方法的关键字参数的dict（默认值：{}）
* 可选：特定于定时任务的后缀（例如，将 `out/err` 重定向到文件，默认值为''）

示例：
```
CRONJOBS = [
    ('*/5 * * * *', 'myapp.cron.other_scheduled_job', ['arg1', 'arg2'], {'verbose': 0}),
    ('0   4 * * *', 'django.core.management.call_command', ['clearsessions']),
    
]
```

对于熟悉 Linux 中定时任务`crontab` 的同学可能对上面第一个参数的语法很亲切。上面表示每隔1分钟执行一次代码。

Linux 中的定时任务`crontab`的语法如下:

```crontab
*  *  *  *  * command
分钟(0-59) 小时(0-23) 每个月的哪一天(1-31) 月份(1-12) 周几(0-6) shell脚本或者命令
```

有几个特殊的符号：

```
* 代表所有的取值范围的数字
/ 代表每的意思，*/5就是每5个单位
- 代表从某个数字到某个数字
, 分开几个离散的数字
```

示例:

```crontab
每两个小时    0 */2 * * *
晚上11点到早上8点之间每两个小时，早上8点    0 23-7,8 * * *
每个月的4号和每个礼拜的礼拜一到礼拜三的早上11点    0 11 4 * 1-3
1月1日早上4点    0 4 1 1 * 
```


```crontab
0 6 * * * commands >> /tmp/test.log # 每天早上6点执行, 并将信息追加到test.log中
0 */2 * * * commands # 每隔2小时执行一次
```

有兴趣的小伙伴可以深入研究下 Linux 的`crontab`定时任务。如果不了解和不熟悉可以想看： [cron语法格式学习](https://www.jianshu.com/p/c6a729c81a24)

5.添加并启动定时任务

```python
#添加并启动定时任务
python manage.py crontab add
```

其它命令：

```python
#显示当前的定时任务
python manage.py crontab show

#删除所有定时任务
python manage.py crontab remove
```

### 一些问题
输出到日志的默认是不支持日志的，所以可以 settings.py 中设置中文支持:
```python
CRONTAB_COMMAND_PREFIX = ‘LANG_ALL=zh_cn.UTF-8’ 
```

如果配置成这样：

```crontab 
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

CRONJOBS = [
    ('0 7 * * 1-5', 'api.cron.email_to_late_docs', '>> {}'.format(BASE_DIR + '/logs/log_{:%d_%m_%Y}.log'.format(time.now()))),
    ('0 7 * * 1-5', 'api.cron.email_ten_days_before', '>> {}'.format(BASE_DIR + 'logs/log_{:%d_%m_%Y}.log'.format(time.now())))
]
```

上述代码的目的是，希望对任务的输出和错误日志，进行 `log_ddmmYY` 格式进行文件每天分开保存。

**但是这个任务，在第二天时，就不会在执行啦！！**

因为，`CRONJOBS` 生成任务时，会生成对应的哈希值（hashes），标识每个任务。所以，当文件名变更时，`CRONJOBS` 中的值每天都在变化，导致不同的定时任务哈希值（hashes）。

针对这种情况，解决方法是，日志文件名称固定，然后创建一个任务，用来每天把日志文件重命名（move）成想要的格式名称，这样就可以啦！

#### 2020-09-13 更新

由于最新的 macOS 10.15 后系统对访问文件夹目录权限做了限制，默认是不允许读写文件。所以导致了一些bug。所以，执行定时任务时，如果出错，默认是不会写到日志文件里的，那么排查错误呢？

在 settings.py 中增加`CRONTAB_COMMAND_SUFFIX`配置：

```python
CRONTAB_COMMAND_SUFFIX = ‘2>&1’
```

增加了这个配置，那么错误的日志也会直接输出到配置的日志文件中。

当然，也可以在 settings.py 中的`CRONJOBS`配置中指定错误日志输出的文件目录，例如：

```python
CRONJOBS = [
    ('*/1 * * * *', 'appname.test_crontab.test','>> /home/python/test_crontab.log 2>> /home/python/error_crontab.log')

]
```

另外，可以通过下面2个命令查看 `crontab` 具体的任务：
```
crontab -l
crontab -e
```

输出错误后，就可以根据错误的问题，找到原因后解决了。



### 总结

通过这个需求，可以看到很多知识点其实是串联起来的，从`python`到`django`到`Linux`的`crontab`，所以，学习无止境，知识学习只会越来越多，如果你提前掌握了某些知识，那么学习新（旧）知识的成本就会降低很多，或者理解成本，比如你学习了 `Linux`， 了解过 `cron` ，那么对于学习这个 `django` 的定时任务会轻松很多！永远不要认为有些知识你永远用不上，所以现在就不学，可能现在的永远距离已经很短啦！加油~


### 参考

- [kraiz/django-crontab: dead simple crontab powered job scheduling for django.](https://github.com/kraiz/django-crontab)
- [django开发-定时任务的使用 - wyzane - SegmentFault 思否](https://segmentfault.com/a/1190000016515891)
- [django-crontab 定时执行任务方法 - 程序园](http://www.voidcn.com/article/p-tgyycvyp-bqm.html)
- [django-crontab实现Django定时任务](https://www.leipengkai.com/article/8/)
- [django使用django-crontab实现定时任务 - 简书](https://www.jianshu.com/p/27f003149090)
- [使用django-crontab实现定时任务 - 腾讯云](https://cloud.tencent.com/developer/article/1121891)
- [cron语法格式学习 - 简书](https://www.jianshu.com/p/c6a729c81a24)
- [django-crontab is missing job hash after one day · Issue #76 · kraiz/django-crontab](https://github.com/kraiz/django-crontab/issues/76)
- [Cron Format - Wikipedia](http://en.wikipedia.org/wiki/Cron#Format)
- [crontab.guru](https://crontab.guru/examples.html)
- [python - 的Django的crontab不执行测试功能](https://stackoverrun.com/cn/q/10635382)
- [python - PermissionError: Errno 1 Operation not permitted: ‘/Users/<local_path>/venv/pyvenv.cfg’ - Stack Overflow](https://stackoverflow.com/questions/62876343/permissionerror-errno-1-operation-not-permitted-users-local-path-venv-py)
- [python - Django crontab not executing test function - Stack Overflow](https://stackoverflow.com/questions/38589830/django-crontab-not-executing-test-function)
- [解决mac osx下pip安装ipython权限的问题 – 峰云就她了](http://xiaorui.cc/archives/3061)
- [如何在Django中开启一个定时任务_qq_15256443的博客-CSDN博客](https://blog.csdn.net/qq_15256443/article/details/103668804)


<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



