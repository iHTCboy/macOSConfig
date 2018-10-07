title: 关于监听UITextField的问题
date: 2015-04-08 10:00:16
categories: technology #induction life poetry
tags: [iOS,UITextFieldDelegate]  # <!--more-->
reward: true

---

### 1、前言
公司测试说，用户输入了11位手机号码后，在输入12位时，提示他只能输入11位，先不说这合不合产品需求，对于这个功能，怎么样实现和满足呢？

<!--more-->

### 2、问题


#### UITextFieldDelegate

```objective-c
@protocol UITextFieldDelegate <NSObject>

@optional

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

@end
```

代理根本就没有办法满足需求，所以应该怎么办呢，所以出现了通知

#### UITextFieldNotification
```objective-c
UIKIT_EXTERN NSString *const UITextFieldTextDidBeginEditingNotification;
UIKIT_EXTERN NSString *const UITextFieldTextDidEndEditingNotification;
UIKIT_EXTERN NSString *const UITextFieldTextDidChangeNotification;
```

#### 添加监听很简单：
```objective-c
    /**
     *  监听UITextField文字改变
     *
     *  @param textFieldTextDidChange 文本改变时通知方法
     *
     *  @param name UITextFieldTextDidChangeNotification（通知类型）
     *
     *  @param object （可用于传递数据）
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:telephone];
```

#### 监听方法
```objective-c
- (void)textFieldTextDidChange
{
        if(telephone.text.length > 11 ){
            NSRange range = NSMakeRange(0, 11);
            telephone.text = [telephone.text substringWithRange:range];
            [self endEditing:YES];
            [MBProgressUtil showToast:@"手机号码最多为11位" inView:self];
        }  
}
```

到此，需求实现并满足，以后想怎么监听文本枢都不用担心代理方法不够用啦！


### 附：
#### UITextViewDelegate
```objective-c
@protocol UITextViewDelegate <NSObject, UIScrollViewDelegate>
@optional

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView;

- (void)textViewDidChangeSelection:(UITextView *)textView;

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);

@end

#UITextViewNotification通知

UIKIT_EXTERN NSString * const UITextViewTextDidBeginEditingNotification;
UIKIT_EXTERN NSString * const UITextViewTextDidChangeNotification;
UIKIT_EXTERN NSString * const UITextViewTextDidEndEditingNotification;

```

~nice

<br>

- 如有疑问，欢迎在评论区一起讨论！
- 如有不正确的地方，欢迎指导！

<br>
> 注：本文首发于 [iHTCboy's blog](https://iHTCboy.com)，如若转载，请注来源



