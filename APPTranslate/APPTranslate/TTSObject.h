//
//  TTSObject.h
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PcmPlayer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"

@interface TTSObject : NSObject


@property (nonatomic, strong) IFlySpeechSynthesizer *synthesizer;//合成类

+(TTSObject *)sharedInstance;

-(void)normalInit;

@end
