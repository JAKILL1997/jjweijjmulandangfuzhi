//
//  IATConfig.h
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IATConfig : NSObject

+(IATConfig *)sharedInstance;


/**
 以下参数，需要通过
 iFlySpeechRecgonizer
 进行设置
 ****/
@property (nonatomic, strong) NSString *speechTimeout;
@property (nonatomic, strong) NSString *vadEos;
@property (nonatomic, strong) NSString *vadBos;

@property (nonatomic, strong) NSString *leftLanguage;
@property (nonatomic, strong) NSString *leftAccent;

@property (nonatomic, strong) NSString *rightLanguage;
@property (nonatomic, strong) NSString *rightAccent;

@property (nonatomic, strong) NSString *dot;
@property (nonatomic, strong) NSString *sampleRate;

@property (nonatomic, strong) NSArray *accentNickName;

@property (nonatomic, assign) BOOL isLeftBtn;

@property (nonatomic, strong) NSArray *listenArray;//显示的名称


@property (nonatomic, strong) NSDictionary *iatToTransKeyDic;


+(NSString *)mandarin;
+(NSString *)cantonese;
+(NSString *)henanese;
+(NSString *)chinese;
+(NSString *)english;
+(NSString *)lowSampleRate;
+(NSString *)highSampleRate;
+(NSString *)isDot;
+(NSString *)noDot;


@end
