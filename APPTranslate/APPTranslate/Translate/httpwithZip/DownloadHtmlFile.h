//
//  DownloadHtmlFile.h
//  iFlySpeechPlusPhaseA
//
//  Created by wangdan on 15-1-19.
//  Copyright (c) 2015年 iFlytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"


/** 回调结果，是否需要重新加载网页
 */
@protocol DownloadHtmlFileDelegate<NSObject>

-(void)onCheckoutDownloadHtmlZip:(BOOL)yesOrNot withError:(NSError *)msg;

@end



@interface DownloadHtmlFile : NSObject<HttpRequestListenerDelegate>


/**单例下载对象
 */
+(DownloadHtmlFile*)sharedHtmlDownloader;


@property(nonatomic) id<DownloadHtmlFileDelegate>delegate;


/**在UIWebView里面调用该函数检查是否需要更新html界面
 */
-(void)checkoutToDownloadHtmlZip;



/**在UIWebView不检查并下载
 */
-(void)downloadNomaterHow;

@end
