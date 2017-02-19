//
//  transLate.h
//  baidufanyi
//
//  Created by wangdan on 15-1-19.
//  Copyright (c) 2015年 wangdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"

@protocol TranslateDelegate <NSObject>

/**
 * 回调结果以及error
 */
-(void)onTranslateResult:(NSString*)resultString withError:(NSError*)resultErro;

@end


@interface TransLate : NSObject<HttpRequestListenerDelegate>



/**
 *  回调的delegate
 */
@property (nonatomic) id<TranslateDelegate> delegate;


/**
 * 获取google翻译语种
 * 英语
 */
+(NSString *)GGEnglish;

/**
 * 获取google翻译语种
 * 汉语
 */
+(NSString *)GGChinese;


/**
 * 获取百度翻译语种
 * 英语
 */
+(NSString *)BDEnglish;


/**
 * 获取百度翻译语种
 * 汉语
 */
+(NSString*)BDChinese;



/**
 * 获取google翻译结果，阻塞式
 * 
 * @srcSpeech 源语种
 *
 * @toSpeech  目的语种
 *
 * @text      待翻译的文本
 */
-(NSString*)googleTranslateFrom:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text;


/**
 * 获取百度翻译结果，阻塞式
 *
 * @srcSpeech 源语种
 *
 * @toSpeech  目的语种
 *
 * @text      待翻译的文本
 */
-(NSString*)baiduTranslateFrom:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text;



/**
 * google翻译使用block的方式，开线程下载,使用回调来处理结果
 */
-(void)googleTranslateUsingBlockFrom:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text;



/**
 * 新的google翻译接口，非阻塞，http请求类型
 */
-(void)startGoogleTranslateForm:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text;

/**
 * 新的百度翻译接口，非阻塞，http请求类型
 */
-(void)startBaiduTranslateForm:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text;




@end
