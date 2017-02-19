//
//  ButtonHoldView.h
//  APPTranslate
//
//  Created by wangdan on 15/5/15.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IATObject.h"
#import "TTSObject.h"


typedef NS_ENUM(NSInteger,RecognizeState)
{
    SpeechNotStart = 0, //还未开始
    SpeechStarting = 1  //识别已经开始
};

@interface ButtonHoldView : UIView<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong)IATObject *iatInstance;
@property (nonatomic, strong)TTSObject *ttsInstance;

@end
