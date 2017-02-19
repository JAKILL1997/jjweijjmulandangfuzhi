//
//  TTSConfig.h
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSConfig : NSObject


+(TTSConfig *)sharedInstance;

@property (nonatomic) NSString *speed;//语速
@property (nonatomic) NSString *volume;//音量
@property (nonatomic) NSString *pitch;//音调
@property (nonatomic) NSString *sampleRate;//采样率
@property (nonatomic) NSString *commanVcn;//发音人
@property (nonatomic) NSString *engineType;//引擎类型,"auto","local","cloud"


/**
 设置用
 用户暂不用关心
 ****/
@property (nonatomic,strong) NSArray *vcnNickNameArray;
@property (nonatomic,strong) NSArray *vcnIdentiferArray;



@end
