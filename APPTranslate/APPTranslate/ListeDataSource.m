//
//  ListeDataSource.m
//  APPTranslate
//
//  Created by wangdan on 15/5/15.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "ListeDataSource.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

@implementation ListeDataSource


-(id)init {
    self = [super init];
    return self;
}


+(id)sharedInstance {
    static ListeDataSource *instance = nil;
    static dispatch_once_t predic;
    
    dispatch_once(&predic,^{
        instance = [[ListeDataSource alloc] init];
        instance.cellMessageFrameArray = [[NSMutableArray alloc] init];
        instance.dataDicArray = [[NSMutableArray alloc] init];
    });
    return instance;
}

-(void)appendItem:(NSDictionary *)item {
    
}

-(void)removeItemAtIndex:(NSIndexPath *)index {
    
}

-(NSMutableDictionary *)buildDicWithIcon:(NSString *)strIcon
                        withStrId:(NSString *)strId
                      withStrTime:(NSString *)strTime
                      withStrName:(NSString *)strName
                   withStrContent:(NSString *)strContent
                 withBelowContent:(NSString *)belowBtnContent
                  withMessageType:(NSNumber *)messageType
                  withMessageFrom:(NSNumber *)messageFrom
                   withUpLanguage:(NSString *)upLanguage
                     withUpAccent:(NSString *)upAccent
                withBelowLanguage:(NSString *)belowLanguage
                  withBelowAccent:(NSString *)belowAccent {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    [dic setValue:strIcon forKey:@"strIcon"];
    
    [dic setValue:strId forKey:@"strId"];
    [dic setValue:strName forKey:@"strName"];
    [dic setValue:strContent forKey:@"strContent"];
    [dic setValue:belowBtnContent forKey:@"translatedStr"];
    [dic setValue:messageFrom forKey:@"from"];
    [dic setValue:messageType forKey:@"type"];
    
    
    [dic setValue:upLanguage forKey:@"upLanguage"];
    [dic setValue:upAccent forKey:@"upAccent"];
    [dic setValue:belowLanguage forKey:@"belowLanguage"];
    [dic setValue:belowAccent forKey:@"belowAccent"];
    
    return dic;
    
}

-(NSDictionary *)fixedOtherDic {
    
    NSDictionary *dic = [self buildDicWithIcon:@"hah"
                                     withStrId:@"123"
                                   withStrTime:@"2015"
                                   withStrName:@"" //头像底下的人名
                                withStrContent:@"且听风吟，吟不完我一生思念，细水长流，流不完我一世情深！"
                              withBelowContent:@"Hear the wind sing, sing not over my life long, a never-ending stream of thoughts, I love!"
                               withMessageType:[NSNumber numberWithInt:0]
                               withMessageFrom:[NSNumber numberWithInt:1]
                                withUpLanguage:@"zh_cn"
                                  withUpAccent:@"mandarin"
                             withBelowLanguage:@"chinese"
                               withBelowAccent:@"mandarin"];
    return dic;
}


-(NSDictionary *)fixedSelfDic {
    
    NSDictionary *dic = [self buildDicWithIcon:@"hah"
                                     withStrId:@"123"
                                   withStrTime:@"2015"
                                   withStrName:@"" //头像底下的人名
                                withStrContent:@"且听风吟，吟不完我一生思念，细水长流，流不完我一世情深！"
                              withBelowContent:@"Hear the wind sing, sing not over my life long, a never-ending stream of thoughts, I love! "
                               withMessageType:[NSNumber numberWithInt:0]
                               withMessageFrom:[NSNumber numberWithInt:0]
                                withUpLanguage:@"en_us"
                                  withUpAccent:@"mandarin"
                             withBelowLanguage:@"chinese"
                               withBelowAccent:@"mandarin"];
    return dic;
}









// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;

-(void)dataAppendDic:(NSDictionary *)dic {
    if (dic == nil) {
        return;
    }
    [self.dataDicArray addObject:dic];
    
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    [message setWithDict:dic];
    [message minuteOffSetStart:previousTime end:dic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    if (message.showDateLabel) {
        previousTime = dic[@"strTime"];
    }
    
    [self.cellMessageFrameArray addObject:messageFrame];
}


-(void)appendFromLanguage:(NSString*)from toLanguage:(NSString*)to
                  srcText:(NSString*)src toText:(NSString *)dest isLeft:(BOOL)isLeft{

    NSNumber *isLeftNumber;
    
    if (isLeft) {
        isLeftNumber = [NSNumber numberWithInt:1];//左边就是1
    }else {
        isLeftNumber = [NSNumber numberWithInt:0];//右边的
    }
    NSString *name;
    
    NSLog(@"data soruce from is %@",from);
    
    if ([from isEqualToString:@"zh_cn"]) {
        name = @"";
    }else if ([from isEqualToString:@"en_us"]) {
        name = @" ";
    }
    
    NSDictionary *dic = [self buildDicWithIcon:@"hah"
                                     withStrId:@"123"
                                   withStrTime:@"2015"
                                   withStrName:name //头像底下的人名
                                withStrContent:src
                              withBelowContent:dest
                               withMessageType:[NSNumber numberWithInt:0]
                               withMessageFrom:isLeftNumber    //注意这里0代表是右边发的，1代表时左边发的
                                withUpLanguage:from
                                  withUpAccent:@"ha"
                             withBelowLanguage:to
                               withBelowAccent:@"ha"];
    
    
    [self.dataDicArray addObject:dic];//先加到字典数据里面
    
    [self dataAppendDic:dic];//再构建messageFrame
}


@end
