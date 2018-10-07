title: iOS支付宝SDK回调那坑
date: 2015-05-26 00:46:26
categories: technology #life poetry
tags: [iOS,支付宝,alipay ]  # <!--more-->
---

支付宝钱包支付接口开发包2.0标准版(iOS 2.2.1) ，回调不出来，demo给出的方法是：
``` objc
 - (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {

 
  if ([url.host isEqualToString:@"safepay"]) {
      
         [[AlipaySDK defaultService] processAuth_V2Result:url
                                       standbyCallback:^(NSDictionary *resultDic) {
          NSLog(@"result = %@",resultDic);
          NSString *resultStr = resultDic[@"result"];
        }];

  }
  return YES;
 }
```
 <!--more-->

而事实上的回调是这样的：
``` objc
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStr = resultDic[@"memo"];
            NSLog(@"memo = %@",resultStr);
        }];
    }

```


这支付宝也真是的，虽然集成过程中很简单，但是这个回调却让人想屎：
支付表是这样说的：
```
 /**
 *  处理授权信息Url
 *
 *  @param resultUrl 钱包返回的授权结果url
 *  @param completionBlock 跳授权结果回调，保证跳转钱包授权过程中，即使调用方app被系统```kill```时，能通过这个回调取到支付结果。
 */
 - (void)processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock;
```

另附几个状态码：
```
   9000 订单支付成功 
   8000 正在处理中  
   4000 订单支付失败 
   6001 用户中途取消 
   6002 网络连接出错 
```


这个月把公司的项目重写了一遍，收获很多，等有点时间时，再慢慢分享给大家啊！
～nice



<br>
> 注：本文首发于 [iHTCboy's blog](http://iHTCboy.com)，如若转载，请注来源

