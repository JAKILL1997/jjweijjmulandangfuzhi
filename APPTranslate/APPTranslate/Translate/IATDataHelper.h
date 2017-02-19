//
//  baidufanyi
//
//  Created by wangdan on 15-1-19.
//  Copyright (c) 2015年 wangdan. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface IATDataHelper : NSObject


// 解析命令词返回的结果
+ (NSString*)stringFromAsr:(NSString*)params;

/**
 解析JSON数据
 ****/
+ (NSString *)stringFromJson:(NSString*)params;//


/**
 解析语法识别返回的结果
 ****/
+ (NSString *)stringFromABNFJson:(NSString*)params;

@end
