//
//  IATObject.h
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "IATConfig.h"

@interface IATObject : NSObject

+(IATObject *)sharedInstance;

@property (nonatomic, strong) IFlySpeechRecognizer *speechRecognizer;//识别对象

-(void)normalInit;//在使用的时候一定要调用该初始化函数



/**
 调用顺序是
 
 [IATObject sharedInstance];
 [[IATObject sharedInstance] nomarlInit];
 [IATObject sharedInstance].speechRecognizer.delegate = self;//设置回调方法
 [IATObject sharedInstance].speechRecognizer startListenning;//开始说话
 
 ****/
@end
