//
//  ViewController.h
//  baidufanyi
//
//  Created by wangdan on 15-1-19.
//  Copyright (c) 2015年 wangdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "transLate.h"

#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "Definition.h"
#import "iflyMSC/IFlyUserWords.h"


#import "iflyMSC/IFlySpeechRecognizer.h"
#import "ISRDataHelper.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyResourceUtil.h"

#import "RecognizerFactory.h"


@interface ViewController : UIViewController<translateProtocol,IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>


@property (nonatomic,strong)IFlySpeechSynthesizer *sythesizer;

@property (nonatomic,strong)IFlySpeechRecognizer *recognizer;


@end

