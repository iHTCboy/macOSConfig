# SoftwareConfig

My Mac config/backup files for macOS.
个人日常使用的 macOS 中使用的系统和软件配置项。


## PopClip

> popclip 软件自定义的扩展


- `MarkdownTools.popclipext`：用于快捷粘贴markdown格式的内容，比如 代码块、[]、（）等。

Original code:
```
async getAuthButtonList() {
  const { data } = await getAuthButtonListApi();
  this.authButtonList = data;
}
```

After formatting with the code plugin:
```
\```
async getAuthButtonList() {
  const { data } = await getAuthButtonListApi();
  this.authButtonList = data;
}
\```
```

- `JSONer.popclipext`：格式 Json 字符串为可读的 JSON 格式。

Original json format:
```json
{"a": "data", "b": 1, "c": true, "d": 4.4}
```

After formatting with the jsoner plugin:
```json
{
  "a": "data",
  "b": 1,
  "c": true,
  "d": 4.4
}
```
