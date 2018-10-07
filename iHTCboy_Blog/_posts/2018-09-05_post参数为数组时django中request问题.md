title: django中ajax post数据时request.POST获取数组问题
date: 2018-09-05 18:49:16
categories: technology #induction life poetry
tags: [django,request.POST,post数组参数]  # <!--more-->
reward: true

---

### 1、前言
最近在使用django开发web页面时，使用ajax的post参数中带有数组，然后在 `request.POST` 里获取的数组时，数组变成了一个元组！！！官方给出的通过 `request.POST.getlist('key')`来获取也是很鸡肉！那要怎么解决呢？

<!--more-->

### 2、问题

问题是这样，在前端js的post请求参数带有数组或字典：
```js
    var body = {
        'account': account,
        'password': password,
        'array': [1, 2, 3],
        'dict': {'k1': 'v1', 'k2': 'v2'}
    };
    $.ajax({
        url: url,
        type: "POST",
        data: body,
        ...
        ...
    });
```

在django后python解析request.POST，获取数组就变成这样：

如果是这样写：


```python
    if request.method == 'POST':
        array = request.POST['array']
        dict = request.POST['dict']
```

直接是报错：

```
raise MultiValueDictKeyError(key)
django.utils.datastructures.MultiValueDictKeyError: 'array'
```

所以我们要看看 `request.POST` 到底是什么类型，内容又是什么？？？

```python
request.POST：
<QueryDict: {'account': ['account'], 'password': ['password'], 'array[]': ['1', '2', '3'], 'dict[k1]': ['v1'], 'dict[k2]': ['v2']}>
```

`QueryDict` ？？？字典！！！

从前端传入的数组，变成了字典，问题有三个：
- `array` 变成 `array[]` 键
- `[1, 2, 3]` 变成 `['1', '2', '3']`
- `dict` 变成 `dict[k1]`、`dict[k1]`

其实，这个不是bug！！！

> 这是一个 django 自定义的类似字典的类，用来处理同一个键带多个值的情况。 python 原始的字典中，当一个键出现多个值的时候会发生冲突，只保留最后一个值。而在 HTML 表单中，通常会发生一个键有多个值的情况。

例如：

```python
 query_string 需要一个字符串 a=1&a=2&c=3，例如：

>>> QueryDict('a=1&a=2&c=3')
<QueryDict: {'a': ['1', '2'], 'c': ['3']}>
```

那么怎么取值呢？

按照`getlist(key)` 拿不到：
![20180905-request.POST-getlist-key.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180905-request.POST-getlist-key.png)

用 `[key]` 只取到容器的最后一个值：
![20180905-request.POST-get.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180905-request.POST-get.png)

用 `getlist(key[])` 数组可以拿到字符串数组，但是字典就只能一个一个拿了！
![20180905-request.POST-getlist.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180905-request.POST-getlist.png)

### 3、解决方法

- 方法一

在前端的body参数变成json字符串：
```js
    var body = JSON.stringify({
        'account': account,
        'password': password,
        'array': [1, 2, 3],
        'dict': {'k1': 'v1', 'k2': 'v2'}
    })
```

但在后端得到的是这样：

```python
<QueryDict: {'{"account":"account","password":"password","array":[1,2,3],"dict":{"k1":"v1","k2":"v2"}}': ['']}>
```

全部参数作为key的字典，显示不符合要求，并且导致处理复杂起来。

- 方法二
子级变成json字符串：

```js
    var body = {
        'account': account,
        'password': password,
        'array': JSON.stringify([1, 2, 3]),
        'dict': JSON.stringify({'k1': 'v1', 'k2': 'v2'})
    };
```

得到的结果：

```python
<QueryDict: {'account': ['account'], 'password': ['password'], 'array': ['[1,2,3]'], 'dict': ['{"k1":"v1","k2":"v2"}']}>
```
数组和字典的全部值作为value，并且是string类型，显示不符合要求，并且导致处理复杂起来。

- 方法三
其实，我们知道后端为了多个相同key存在，所以才这样处理，那么我们可以这样考虑，让数据和字典不在是数组和字典，后端在还原不就可以啦！

```js
    var body = {
        'account': account,
        'password': password,
        'array': '1' + JSON.stringify([1, 2, 3]),
        'dict': '1' + JSON.stringify({'k1': 'v1', 'k2': 'v2'})
    };
```

让 'array'、'dict' 变成 ‘1’ + json字符串形式，然后后端按规则还原：

```python
<QueryDict: {'account': ['account'], 'password': ['password'], 'array': ['1[1,2,3]'], 'dict': ['1{"k1":"v1","k2":"v2"}']}>
```

按规则还原：
```python
    array = request.POST['array']
    dict = request.POST['dict']
    array_list = json.loads(array[1:])
    dict_list = json.loads(dict[1:])
```

![20180905-request.POST-irregular.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180905-request.POST-irregular.png)

这样拿也许不是好办法，但是当你数组或字典数据非常多时，也就这样啦，当然，也可以json字符串后加密，这样后端也不能解析，如果需要，大家也可以这样做啊~

### 总结
在处理这些数据时，可能是为了方便而方便，有时候只有清楚知道原因，才能更好的处理，上面的方法确实不是`好方法`，有时候还是按规则来处理更好，一个人开发还好，如果是多人，那将来可能会留下坑啊。


### 参考

- [关于ajax post 数据时django中request.body与request.POST问题 - 简书](https://www.jianshu.com/p/7af7e1e783ee)
- [django-QueryDict 对象 - scolia - 博客园](https://www.cnblogs.com/scolia/p/5634591.html)
- [Request and response objects | Django documentation | Django](https://docs.djangoproject.com/en/dev/ref/request-response/#django.http.QueryDict.getlist)
- [django中同通过getlist() 接收页面form的post数组 - ccorz - 博客园](https://www.cnblogs.com/ccorz/p/6346883.html)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
