title: shell技巧3 - 自动生成AppIcon
date: 2018-09-15 16:20:16
categories: induction #technology life poetry
tags: [shell,bash,sips,appicon,Assets,xcassets]  # <!--more-->
reward: true

---

### 1、前言
上一篇讲到 [shell技巧2 - 图片旋转缩放转换格式等](https://ihtcboy.com/2018/09/14/2018-09-14_shell技巧2_图片旋转缩放等/)，而平时iOS开发中，Xcode中`Assets.xcassets`的`AppIcon` 需要设计师或开发者自行放置对应尺寸的图标，虽然我经常使用macOS下的 `Prepo` 应用生成多尺寸的图标，但是依然需要一张一张的放置到Xcode中，并且步骤非常不智能化，部分图标需要人工对应位置放置。如果通过使用 `sips` 命令，其实可以自动生成对应尺寸的图片，就可以灵活和自动化的批量生成AppIcon的全部图标，绝对的方便和效率！说到就马上实践吧！

<!--more-->

### 2、AppIcon 要求
平时，我们的应用的图标，都会在 Assets.xcassets 的AppIcon 设置，对于 iOS 来说，需要配置如下图标：

![20180915-Xcode-Assets.xcassets-AppIcon.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180915-Xcode-Assets.xcassets-AppIcon.png)

其中，因为App如果只支持iOS7以上，1x 的设备也不需要支持了，那么大概导出需要如下的尺寸：

| pt | 像素密度(scale) | 尺寸(px) | 用途 | 支持系统版本 |
| --- | --- | --- | --- | --- |
| 20pt | 2x | 40*40 | iPhone Notificafion | iOS 7-12 |
| 20pt | 3x | 60*60 | iPhone Notificafion | iOS 7-12 |
| 29pt | 2x | 58*58 | iPhone Spotlight/Settings | iOS 5-6/5-12 |
| 29pt | 3x | 87*87 | iPhone Spotlight/Settings | iOS 5-6/5-12 |
| 40pt | 2x | 80*80 | iPhone Spotlight | iOS 7-12 |
| 40pt | 3x | 120*120 | iPhone Spotlight | iOS 7-12 |
| 60pt | 2x | 120*120 | iPhone App | iOS 7-12 |
| 60pt | 3x | 180*180 | iPhone App | iOS 7-12 |
| 20pt | 2x | 40*40 | iPad Notificafion | iOS 7-12 |
| 29pt | 2x | 58*58 | iPad Settings | iOS 5-12 |
| 40pt | 2x | 80*80 | iPad Spotlight | iOS 7-12 |
| 76pt | 2x | 152*152 | iPad App | iOS 7-12 |
| 83.5pt | 2x | 167*167 | iPad Pro App | iOS 9-12 |
| 1024pt | 1x | 1024*1024 | App Store | iOS 7-12 |

从上面表格可以看出，这些尺寸还是有一些重复的，所以导出尺寸时，其实没有那么多的啊，因为如果相同尺寸，可以使用同一张图片，从而减少包的体积啊！

### 3、shell 编程
通过使用 `sips` 命令进行图片处理，这里简单的写一下iOS App图标生成，apple watch 或 macOS app的图标生成的示例，希望大家能举一反三，这都是授鱼不如授渔！ 

先说一下操作步骤：

1.在终端执行shell脚本：

```shell
sh /Users/HTC/Desktop/make_iOSAppIcon.sh 
```

2.然后拖拽1024图片路径到终端：

```shell
================================================
Enter origin image path: /Users/HTC/Desktop/apple.jpg 
```

3.执行成功:

```
------- start processing -------
info:	resize copy 1024 successfully.
info:	resize 1024 successfully.
info:	resize 180 successfully.
info:	resize 167 successfully.
info:	resize 152 successfully.
info:	resize 120 successfully.
info:	resize 87 successfully.
info:	resize 80 successfully.
info:	resize 60 successfully.
info:	resize 58 successfully.
info:	resize 40 successfully.
info:	resize 1024 to jpg successfully.

creat iOS AppIcon finished!

------- end processing -------
```

生成的图标和json文件：
![20180915-creat-AppIcon.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180915-creat-AppIcon.png)

4.然后找到输出的文件夹（默认是在填写的图片的同级目录），复制到Xcode项目中 `Project/Assets.xcassets/AppIcon.appiconset/` 即可。（如果还想省略这一步操作，也可以直接将生成的输出到项目的目录中，这步就交给读者需要自行添加啊）

![20180915-move-to-Xcode-Assets.xcassets-AppIcon.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180915-move-to-Xcode-Assets.xcassets-AppIcon.png)

5.打开Xcode，就能看到图片已经自动显示好！
![20180915-Xcode-Assets.xcassets-AppIcon-icon.png](https://github.com/iHTCboy/iGallery/raw/master/BlogImages/2018/09/20180915-Xcode-Assets.xcassets-AppIcon-icon.png)

这里说一下大概的思路，其实也不难，首先判断输出的路径，如果不是`目录`、`不存在的目录的文件`、`格式不符合的图片`，就可以图片处理，否则提示重新输入图片路径。然后创建图片同级的文件夹用于保存生成的图标和配置的json文件，由于 “1024”图片最大，所以，先转成png，然后从大到小，一张一张剪切，另外，需要注意，1024如果是png，因为有透明度的话上传到AppStore是不成功的，所以，这里最后转换1024图片格式为jpg，这样保证万无一失。其它图标都是png，也不用切成圆角，因为苹果最终显示时系统自动切成图角。

总结一下好处：
- 方便快捷，不用人为关心
- 尺寸相同的图片只保留一张，减少包体积
- 1024图片为jpg，万无一失

### 4、源代码

具体的代码，也可参考我的Github代码：
-  [iHTCboy/iShell: Shell脚本编程技巧，总结一些常用的提高效率的方法。](https://github.com/iHTCboy/iShell)

```shell
#!/bin/bash

# 定义用到的变量
image_path=""

# 定义读取输入字符的函数
getImagePath() {
	echo -e "\n================================================"
	# 监听输入并且赋值给变量
	read -p "Enter origin image path: " image_path
	# 如果字符串的长度为零则为真为空值，从新监听，否则执行旋转函数
	if	test -z "$image_path"; then
		 getImagePath
	else
		# 如果文件存在且为目录则为真
		if test -d "$image_path"; then
			echo -e "\n------- [Error] the file path is directory --------"
			getImagePath
		else
			# 如果文件存在且可读则为真
			if test -r "$image_path"; then
				ext="\.jpeg|\.jpg|\.png|\.JPEG|\.JPG|\.PNG|\.gif|\.bmp"
				# get the images that need process.
				valid_img=$(echo "$image_path" | grep -E "${ext}")
				# 匹配到图片格式才处理
				if test -z "$valid_img"; then
					echo -e "\n------- [Error] the file is not's legal format --------"
					getImagePath
				else
					creatAppIcon	
				fi
			else			
				echo -e "\n------- [Error] the file path is not's find --------"
				getImagePath
			fi	
		fi
	fi
}

creatAppIcon() {
	echo -e "\n------- start processing -------"
	
	# 图片的上一级目录
	prev_path=$(dirname "$image_path")
	
	# 输出icon的目录
	icon_paht="${prev_path}/iOS_icon_`date +%Y%m%d_%H%M%S`"
	
	# 创建目录
	mkdir -p ${icon_paht}
	
	# 1024 icon 特别处理
	icon_1024_path="${icon_paht}/icon-1024.png"
	cp ${image_path} ${icon_1024_path}
	
	sips -s format png ${image_path} --out ${icon_1024_path} > /dev/null 2>&1
	[ $? -eq 0 ] && echo -e "info:\tresize copy 1024 successfully." || echo -e "info:\tresize copy 1024 failed."
	
	sips -z 1024 1024 ${icon_1024_path} > /dev/null 2>&1
	[ $? -eq 0 ] && echo -e "info:\tresize 1024 successfully." || echo -e "info:\tresize 1024 failed."
	
	prev_size_path=${icon_1024_path} #用于复制小图，减少内存消耗
	# 需要生成的图标尺寸
	icons=(180 167 152 120 87 80 60 58 40)
	for size in ${icons[@]}
	do
		size_path="${icon_paht}/icon-${size}.png"
		cp ${prev_size_path} ${size_path}
		prev_size_path=${size_path}
		sips -Z $size ${size_path} > /dev/null 2>&1
		[ $? -eq 0 ] && echo -e "info:\tresize ${size} successfully." || echo -e "info:\tresize ${size} failed."
	done
	
	# 转换1024图片为jpg，防止有透明区域导致上传 App Store 失败
	icon_1024_jpg_path="${icon_paht}/icon-1024.jpg"
	mv ${icon_1024_path} ${icon_1024_jpg_path}
	sips -s format jpeg ${icon_1024_jpg_path} --out ${icon_1024_jpg_path} > /dev/null 2>&1
	[ $? -eq 0 ] && echo -e "info:\tresize 1024 to jpg successfully." || echo -e "info:\tresize 1024 to jpg  failed."
	
	contents_json_path="${icon_paht}/Contents.json"
	# 生成图标对应的配置文件
	echo '{
		"images" : [
			{
				"size" : "20x20",
				"idiom" : "iphone",
				"filename" : "icon-40.png",
				"scale" : "2x"
			},
			{
				"size" : "20x20",
				"idiom" : "iphone",
				"filename" : "icon-60.png",
				"scale" : "3x"
			},
			{
				"size" : "29x29",
				"idiom" : "iphone",
				"filename" : "icon-58.png",
				"scale" : "2x"
			},
			{
				"size" : "29x29",
				"idiom" : "iphone",
				"filename" : "icon-87.png",
				"scale" : "3x"
			},
			{
				"size" : "40x40",
				"idiom" : "iphone",
				"filename" : "icon-80.png",
				"scale" : "2x"
			},
			{
				"size" : "40x40",
				"idiom" : "iphone",
				"filename" : "icon-120.png",
				"scale" : "3x"
			},
			{
				"size" : "60x60",
				"idiom" : "iphone",
				"filename" : "icon-120.png",
				"scale" : "2x"
			},
			{
				"size" : "60x60",
				"idiom" : "iphone",
				"filename" : "icon-180.png",
				"scale" : "3x"
			},
			{
				"idiom" : "ipad",
				"size" : "20x20",
				"scale" : "1x"
			},
			{
				"size" : "20x20",
				"idiom" : "ipad",
				"filename" : "icon-40.png",
				"scale" : "2x"
			},
			{
				"idiom" : "ipad",
				"size" : "29x29",
				"scale" : "1x"
			},
			{
				"size" : "29x29",
				"idiom" : "ipad",
				"filename" : "icon-58.png",
				"scale" : "2x"
			},
			{
				"idiom" : "ipad",
				"size" : "40x40",
				"scale" : "1x"
			},
			{
				"size" : "40x40",
				"idiom" : "ipad",
				"filename" : "icon-80.png",
				"scale" : "2x"
			},
			{
				"idiom" : "ipad",
				"size" : "76x76",
				"scale" : "1x"
			},
			{
				"size" : "76x76",
				"idiom" : "ipad",
				"filename" : "icon-152.png",
				"scale" : "2x"
			},
			{
				"size" : "83.5x83.5",
				"idiom" : "ipad",
				"filename" : "icon-167.png",
				"scale" : "2x"
			},
			{
				"size" : "1024x1024",
				"idiom" : "ios-marketing",
				"filename" : "icon-1024.jpg",
				"scale" : "1x"
			}
		],
		"info" : {
			"version" : 1,
			"author" : "xcode"
		}
	}' > ${contents_json_path}
		
	echo -e "\n creat iOS AppIcon finished!"
	echo -e "\n------- end processing -------"
}


# 首先执行函数，填写1024图片的路径赋值
getImagePath
```

### 5、总结

通过 ship 命令和 shell脚本和前面几篇技巧，大家应该能感受到shell脚本编程的魅力，希望大家能举一反三，授鱼不如授渔！生活工作中结合 sehll 脚本，提高效率和自动化，珍爱时间不是梦！

其实，只要用命令有终端的地方，都是可以用shell脚本！后续有更多技巧，还会继续给大家分享，期待吧~


### 参考
- [shell技巧2 - 图片旋转缩放转换格式等 | iHTCboy's blog](https://ihtcboy.com/2018/09/14/2018-09-14_shell技巧2_图片旋转缩放等/)
- [利器: Mac自带的图片工具Sips](http://www.voidcn.com/article/p-xrygdftf-bmv.html)
- [sips MAN page Man Page - macOS - SS64.com](https://ss64.com/osx/sips.html)
- [使用sips命令自动缩减图片尺寸](https://www.jianshu.com/p/7246c5a5b083)
- [shell技巧1 - 生成ipa文件 | iHTCboy's blog](https://ihtcboy.com/2018/08/31/2018-08-31_shell技巧1_生成ipa文件/)

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源
