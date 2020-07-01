title: 用Python库pyOpenSSL读取iOS的p12证书
date: 2019-06-28 23:19:16
categories: technology #induction life poetry
tags: [Python,pyOpenSSL,iOS,p12]  # <!--more-->
reward: true

---

### 1、前言

本文主要是讲解如何用python读取`p12`的信息。

如果有过iOS(团队)开发经验的朋友，一定对`p12`有所了解，因为苹果开发者网站制作的cer证书，只能用生成 `CSR`（Certificate Signing Request）文件 ————— `CertificateSigningRequest.certSigningRequest` 的macOS系统安装，因为生成`CSR`时，私钥保存地本地电脑中，同时，普通个人开发账号最多可注册 iOS Development/Distribution 证书各2个？所以，`p12` 就是解决在多个电脑之间共享证书的一种方式。本文不会详解iOS证书相关知识，想了解更多，可以查看本文末提供的参考文章。

<!--more-->

### 2、p12证书

在讲解之前，先给大家说说原理。 `p12` --- KCS12 file holds the private key and certificate。 macOS系统查看时显示的p12名字为：个人信息交换（personal information exchange file）

`p12` 存放了证书和私钥，使用的是DER编码。那什么是DER呢? 这里就要讲讲证书的知识：

#### 证书标准
`X.509`：是一种证书标准，主要定义了证书中应该包含哪些内容。其详情可以参考`RFC5280`，`SSL` 使用的就是这种证书标准。

#### 编码格式
同样的`X.509`证书，可能有不同的编码格式，目前有以下两种编码格式：

- `DER`：Distinguished Encoding Rules，打开看是二进制格式，不可读.

- `PEM`：Privacy Enhanced Mail，打开看文本格式，以"-----BEGIN..."开头，"-----END..."结尾,内容是BASE64编码。


因为`p12`是`DER`编码，所以要查看`p12`的内容，当然最好从`DER`编码转换成`PEM`格式。那么因为这是一种证书标准的格式，就需要实现了这种标准的工具就能解析：

- `OpenSSL`：是`SSL`的一个实现，SSL只是一种规范。理论上来说，SSL这种规范是安全的，目前的技术水平很难破解，但SSL的实现就可能有些漏洞，如著名的"心脏出血"。OpenSSL还提供了一大堆强大的工具软件，强大到90%我们都用不到。

所以，使用 `OpenSSL` 就可以读取`p12`的信息，可以通过以下命令把`p12`转换为`pem`：


```shell
openssl pkcs12 -in XXX.p12  -out XXX.pem -nodes
```

执行命令后，会要求输入`p12`文件的密码，如果密码错误：`Mac verify error: invalid password?` ，如果密码正确：`MAC verified OK`。

示例：

p12：
![20190628-HTC.p12.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/06/20190628-HTC.p12.png)

pem：
![20190628-HTC.pem.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2019/06/20190628-HTC.pem.png)

### pyOpenSSL 使用

`pyOpenSSL` 库简介：

> High-level wrapper around a subset of the OpenSSL library
> pyOpenSSL now works with OpenSSL 1.1.1


所以，python 解析 `p12` 可以使用 `pyOpenSSL` ，`pyOpenSSL` 是`OpenSSL`的封装，19.0.0 版本支持 OpenSSL 1.1.1。 这里就没有什么多说的，看代码就好，或者看看文档 [pyOpenSSL · PyPI](https://pypi.org/project/pyOpenSSL/)。


先安装 `pyOpenSSL`：

```python
pip install pyOpenSSL
```

`p12`文件读取，Python3 示例代码：

```python
# load OpenSSL.crypto
from OpenSSL import crypto

# open it, using password. Supply/read your own from stdin.
p12 = crypto.load_pkcs12(open("/Users/HTC/Desktop/HTC.p12", 'rb').read(), '123456')

cer = p12.get_certificate()     # (signed) certificate object
pkey = p12.get_privatekey()      # private key.
ca_cer = p12.get_ca_certificates() # ca chain.
print(cer, pkey, ca_cer)

print('版本', cer.get_version())
print('签名算法', cer.get_signature_algorithm())
print('序列号：', cer.get_serial_number())
print('证书是否过期：', cer.has_expired())
print('在此之前无效：', cer.get_notBefore())
print('在此之后无效', cer.get_notAfter())



#主题名称
subject = cer.get_subject()
s_components = subject.get_components()
print(s_components)

key_dict = {'UID': '用户 ID',
			'CN': '常用名称',
			'OU': '组织单位',
			'O': '组织',
			'C': '国家或地区'
			}

for (key, value) in s_components:
	print(key, value)
	print(key_dict.get(key.decode(), key))

#签发者名称
suer = cer.get_issuer()
print(suer.get_components())

#证书扩展信息
print('扩展数：', cer.get_extension_count())
print('扩展1：', cer.get_extension(0))

```


### 总结
现在 Xcode8 之后，已经可以通过在Xcode登陆开发者账号，就会自动下载和管理证书，从而减少开发者配置证书遇到的各种问题，非常的方便。当然，如果是多人开发或跨地域(异地)团队，或者不想让开发人员拿到最高权限，使用`p12`还是目前最好的方式！因为如果一个主账号下的子账号都可以操作证书，其实影响和安全性很难保证，所以，苹果也有一定道理，很难在Xcode的账号中，分权限管理吧。

关于证书，这里只是介绍的说说`p12`的简单知识，证书体系有非常多的标准和知识，还需要多学习多实战，等有时间在整理总结一下啦，大家一起加油啊！


### 参考
- [cryptography - Python: reading a pkcs12 certificate with pyOpenSSL.crypto - Stack Overflow](https://stackoverflow.com/questions/6345786/python-reading-a-pkcs12-certificate-with-pyopenssl-crypto/6346268#6346268)
- [Python：用pyOpenSSL.crypto读取pkcs12证书 - 代码日志](https://codeday.me/bug/20181207/432700.html)
- [关于开发证书配置（Certificates & Identifiers & Provisioning Profiles）IOS发布 - 前端栈开发 - CSDN博客](https://blog.csdn.net/phj_88/article/details/53045748)
- [iOS开发者证书-详解/生成/使用 - Echo's Blog -](http://nuoerlz.is-programmer.com/posts/47670.html)
- [Python查看ipa UDID和其他基本信息 - 简书](https://www.jianshu.com/p/7b84f95bdf6f)
- [那些证书相关的玩意儿(SSL,X.509,PEM,DER,CRT,CER,KEY,CSR,P12等) - guogangj - 博客园](https://www.cnblogs.com/guogangj/p/4118605.html)
- [pyOpenSSL · PyPI](https://pypi.org/project/pyOpenSSL/)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
<br>


