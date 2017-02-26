//
//  transLate.m
//  baidufanyi
//
//  Created by wangdan on 15-1-19.
//  Copyright (c) 2015年 wangdan. All rights reserved.
//

#import "TransLate.h"
#import "NSString+MD5.h"
#import "JKHttpRequest.h"


#pragma  mark  google翻译语种
#define ENGLISH  @"en"
#define CHINESE  @"zh-CN"


#pragma mark 百度翻译语种

#define  BAIDU_CHINESE      @"zh"
#define  BAIDU_ENGLISH      @"en"
#define  BAIDU_JAPAN        @"jp"
#define  BAIDU_RUSSIA       @"ru"





#pragma  mark - google翻译结果相关字段

#define TRANSLATE_RES   @"res"

#pragma  mark - 百度翻译相关字段

#define  TRANS_RESULT   @"trans_result"
#define  DST            @"dst"



@interface TransLate()
{
    NSMutableURLRequest *urlRequest;
    
    NSURL *testURL;
    
    NSURLConnection *urlConnection;
    
    NSString* resultString;
    
    JKHttpRequest *baiduRequest;//百度翻译的http请求
    
    JKHttpRequest *googleRequest;//google翻译的http请求
}
@end



@implementation TransLate


-(instancetype)init
{
    self=[super init];
    
    if( self ){
        testURL=[[NSURL alloc]init];
        urlRequest=[[NSMutableURLRequest alloc]init];
        urlConnection=[[NSURLConnection alloc]init];
        resultString=[[NSString alloc]init];
    }
    return self;
}



+(NSString *)GGEnglish
{
    return  ENGLISH;
}

+(NSString *)GGChinese
{
    return CHINESE;
}

+(NSString *)BDEnglish
{
    return BAIDU_ENGLISH;
}

+(NSString*)BDChinese
{
    return BAIDU_CHINESE;
}


//获取google翻译的文字
-(NSString*)googleTranslateFrom:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text
{
    if( text == nil || text.length == 0 ){
        NSLog(@"in %s,param error",__func__);
        return nil;
    }
    NSString *urlEncodeString=[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestString=[NSString stringWithFormat:@"http://brisk.eu.org/api/translate.php?from=%@&to=%@&text=%@",srcSpeech,toSpeech,urlEncodeString];
    testURL=[NSURL URLWithString:requestString];
    urlRequest=[[NSMutableURLRequest alloc]initWithURL:testURL];
    NSData *recieveData=[NSData dataWithContentsOfURL:testURL];
    return [self googleParseJsonData:recieveData];
}


/**
 * 使用block的方式，开线程下载
 */
-(void)googleTranslateUsingBlockFrom:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text
{
    if( text == nil || text.length == 0 ){
        NSLog(@"in %s,param error",__func__);
    }
    NSString *urlEncodeString=[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestString=[NSString stringWithFormat:@"http://brisk.eu.org/api/translate.php?from=%@&to=%@&text=%@",srcSpeech,toSpeech,urlEncodeString];
    testURL=[NSURL URLWithString:requestString];
    urlRequest=[[NSMutableURLRequest alloc]initWithURL:testURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
        NSLog(@"error code is %ld",(long)connectionError.code);
        resultString=[self googleParseJsonData:data];
        if( [self.delegate respondsToSelector:@selector(onTranslateResult:withError:)] ){
            [self.delegate onTranslateResult:resultString withError:connectionError];
        }
    }];


}


//获取百度翻译的文字,该接口暂时没法使用
-(NSString*)baiduTranslateFrom:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text
{
    if( text == nil || text.length == 0 ){
        NSLog(@"in %s,param error",__func__);
        return nil;
    }
    NSString *urlEncodeString=[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestString=[NSString stringWithFormat:@"http://openapi.baidu.com/public/2.0/bmt/translate?client_id=GWufVI30Qz4rGAwvaq2mMUiv&q=%@&from=%@&to=%@",urlEncodeString,@"zn",@"en"];
    testURL=[NSURL URLWithString:requestString];
    urlRequest=[[NSMutableURLRequest alloc]initWithURL:testURL];
    NSData *recieveData=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    [self  baiduParseJsonData:recieveData];
    return  nil;
}


//处理返回的翻译的data
-(NSString *)googleParseJsonData:(NSData*)translateData
{
    if( translateData == nil ){
        NSLog(@"data is nil ,now return");
        return nil;
    }
    NSDictionary *tmpDic=[NSJSONSerialization JSONObjectWithData:translateData options:kNilOptions error:nil ];
    NSString *translateResult=[tmpDic objectForKey:TRANSLATE_RES];
    return translateResult;
}




//处理返回的翻译的data
-(NSString *)baiduParseJsonData:(NSData*)translateData
{
    if( translateData == nil ){
        NSLog(@"data is nil ,now return");
        return nil;
    }
    
    NSDictionary *tmpDic=[NSJSONSerialization JSONObjectWithData:translateData options:kNilOptions error:nil ];
    NSArray *resultArray=[tmpDic objectForKey:TRANS_RESULT];
    
    if( resultArray !=nil ){
        NSDictionary *resultDic=[resultArray objectAtIndex:0];
        resultString=[resultDic objectForKey:DST];
        NSLog(@"result is %@",resultString);
        return resultString;
    }
    return nil;
}





-(void)startGoogleTranslateForm:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text
{
    if( text == nil || text.length == 0 ){
        NSLog(@"in %s,param error",__func__);
    }
    NSString *urlEncodeString=[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestString=[NSString stringWithFormat:@"http://brisk.eu.org/api/translate.php?from=%@&to=%@&text=%@",srcSpeech,toSpeech,urlEncodeString];
    
    googleRequest=[[JKHttpRequest alloc]initWithUrl:requestString];
    
    googleRequest.delegate=self;
    
    [googleRequest sendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}


-(void)startBaiduTranslateForm:(NSString*)srcSpeech toSpeech:(NSString*)toSpeech withText:(NSString*)text
{
    if( text == nil || text.length == 0 ){
        NSLog(@"in %s,param error",__func__);
    }
//    NSString *urlEncodeString=[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestString = [self gemerateBDQeuryString:srcSpeech to:toSpeech text:text];;
    
    baiduRequest=[[JKHttpRequest alloc]initWithUrl:requestString];
    
    baiduRequest.delegate=self;
    
    [baiduRequest sendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}


#pragma  mark - http 回调接口

-(void)onDLProgress:(JKHttpRequest *)request progress:(int)progress
{
    
}

-(void)onErrorWithMsg:(JKHttpRequest *)request msg:(NSError *)msg
{
    
}


-(void)onResultWithData:(JKHttpRequest *)request data:(NSData *)data
{
    if( request == googleRequest ){
       NSString*result= [self googleParseJsonData:data];//处理谷歌传回的数据
        if( [self.delegate respondsToSelector:@selector(onTranslateResult:withError:)] ){
            [self.delegate onTranslateResult:result withError:nil];
        }
    }else if( request == baiduRequest ){
        NSString*result= [self baiduParseJsonData:data];//处理谷歌传回的数据
        if( [self.delegate respondsToSelector:@selector(onTranslateResult:withError:)] ){
            [self.delegate onTranslateResult:result withError:nil];
        }
    }
    
}

- (NSString *)gemerateBDQeuryString:(NSString *)from to:(NSString *)to text:(NSString *)text {
    NSMutableString *muString = @"".mutableCopy;
    [muString appendString:@"20170221000039543"];
    NSString *queryText = text.length? text: @"无效值";
    [muString appendString:queryText];
    NSString *salt = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
    [muString appendString:salt];
    [muString appendString:@"knh4ICs7shOS77FLhNpI"];
    NSString *sign = [muString jk_md5];
    

    NSMutableString *finalString = @"".mutableCopy;
    [finalString appendString:@"http://api.fanyi.baidu.com/api/trans/vip/translate?"];
    [finalString appendString:[NSString stringWithFormat:@"q=%@", [queryText jk_urlEncode]]];
    [finalString appendString:[NSString stringWithFormat:@"&from=%@",from]];
    [finalString appendString:[NSString stringWithFormat:@"&to=%@",to]];
    [finalString appendString:[NSString stringWithFormat:@"&appid=%@",@"20170221000039543"]];
    [finalString appendString:[NSString stringWithFormat:@"&salt=%@",salt]];
    [finalString appendString:[NSString stringWithFormat:@"&sign=%@",sign]];
    NSLog(@"%@",finalString);
    return finalString;
    
}



@end
