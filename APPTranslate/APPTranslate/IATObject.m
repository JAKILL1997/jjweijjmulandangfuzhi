//
//  IATObject.m
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "IATObject.h"
#import "iflyMSC/IFlySpeechConstant.h"


@implementation IATObject

-(id)init {
    self = [super init];
    if (self) {
        [self otherInit];
    }
    return self;
}

+(IATObject *)sharedInstance {
    static IATObject  * instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[IATObject alloc] init];
    });
    return instance;
}



-(void)otherInit {
    _speechRecognizer = [IFlySpeechRecognizer sharedInstance];
    [_speechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
}


-(void)normalInit {
    if (_speechRecognizer == nil) {
        _speechRecognizer = [IFlySpeechRecognizer sharedInstance];
    }
    
    IATConfig *instance  = [IATConfig sharedInstance];
    
    [_speechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    [_speechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    [_speechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    [_speechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
    [_speechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
    [_speechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    if (instance.isLeftBtn == YES) { //如果点击的是左边的识别按钮
        if ([instance.leftLanguage isEqualToString:[IATConfig chinese]]) {
            [_speechRecognizer setParameter:instance.leftLanguage forKey:[IFlySpeechConstant LANGUAGE]];
            [_speechRecognizer setParameter:[IATConfig mandarin] forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.leftLanguage isEqualToString:[IATConfig english]]) {
            [_speechRecognizer setParameter:instance.leftLanguage forKey:[IFlySpeechConstant LANGUAGE]];
        }
        
    }else {//点击的是右边的识别按钮
        if ([instance.rightLanguage isEqualToString:[IATConfig chinese]]) {
            [_speechRecognizer setParameter:instance.rightLanguage forKey:[IFlySpeechConstant LANGUAGE]];
            [_speechRecognizer setParameter:[IATConfig mandarin] forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.rightLanguage isEqualToString:[IATConfig english]]) {
            [_speechRecognizer setParameter:instance.rightLanguage forKey:[IFlySpeechConstant LANGUAGE]];
        }
    }
    //设置是否返回标点符号
    [_speechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
    
}

@end
