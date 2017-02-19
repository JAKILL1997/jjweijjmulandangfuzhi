//
//  TTSObject.m
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "TTSObject.h"
#import "TTSConfig.h"
#import "iflyMSC/IFlySpeechConstant.h"

@implementation TTSObject


-(id)init {
    self = [super init];
    if (self) {
        [self normalInit];
    }
    return self;
}


+(TTSObject *)sharedInstance {
    static TTSObject  * instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[TTSObject alloc] init];
    });
    return instance;
}


-(void)normalInit {
    
    if (_synthesizer == nil) {
        _synthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    TTSConfig *instance = [TTSConfig sharedInstance];
    [_synthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    [_synthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    [_synthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    [_synthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_synthesizer setParameter:instance.commanVcn forKey:[IFlySpeechConstant VOICE_NAME]];
}



@end
