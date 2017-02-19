//
//  IATConfig.m
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "IATConfig.h"
#import "TransLate.h"

#define PUTONGHUA   @"mandarin"
#define YUEYU       @"cantonese"
#define HENANHUA    @"henanese"
#define ENGLISH     @"en_us"
#define CHINESE     @"zh_cn"



@implementation IATConfig

-(id)init {
    self  = [super init];
    if (self) {
        [self defaultSetting];
        return  self;
    }
    return nil;
}


+(IATConfig *)sharedInstance {
    static IATConfig  * instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[IATConfig alloc] init];
    });
    return instance;
}


-(void)defaultSetting {
    _speechTimeout = @"30000";
    _vadEos = @"3000";
    _vadBos = @"3000";
    _dot = @"1";
    _sampleRate = @"16000";
    _leftLanguage = CHINESE;
    _leftAccent = PUTONGHUA;
    _accentNickName = [[NSArray alloc] initWithObjects:@"粤语",@"普通话",@"河南话",@"英文", nil];
    _rightLanguage = ENGLISH;
    
    _isLeftBtn = YES;//默认是左边的按钮被点击
    
    //AKPickerView 显示的可以选择的语种
    _listenArray = [[NSArray alloc] initWithObjects:@"中文",@"英文",nil];
    
    _iatToTransKeyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [TransLate BDChinese],CHINESE,
                         [TransLate BDEnglish],ENGLISH,nil];//识别与翻译的关键字建立映射
}


+(NSString *)mandarin {
    return PUTONGHUA;
}
+(NSString *)cantonese {
    return YUEYU;
}
+(NSString *)henanese {
    return HENANHUA;
}
+(NSString *)chinese {
    return CHINESE;
}
+(NSString *)english {
    return ENGLISH;
}

+(NSString *)lowSampleRate {
    return @"8000";
}

+(NSString *)highSampleRate {
    return @"16000";
}

+(NSString *)isDot {
    return @"1";
}

+(NSString *)noDot {
    return @"0";
}

@end
