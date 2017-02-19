//
//  ListeDataSource.h
//  APPTranslate
//
//  Created by wangdan on 15/5/15.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListeDataSource : NSObject



/**
 该类的功能，是用于将数据源产生的数据
 封装为cell需要使用到的数据
 进而产生cell
 ****/



@property (nonatomic, strong) NSMutableArray *cellMessageFrameArray;
@property (nonatomic, strong) NSMutableArray *dataDicArray;


+(id)sharedInstance;

/**
 添加一个数据
 ****/
-(void)appendItem:(NSDictionary *)item;


/**
 删除某一个数据
 ****/
-(void)removeItemAtIndex:(NSIndexPath*)index;


-(NSDictionary *)buildDicWithIcon:(NSString *)strIcon
                        withStrId:(NSString *)strId
                      withStrTime:(NSString *)strTime
                      withStrName:(NSString *)strName
                   withStrContent:(NSString *)strContent
                 withBelowContent:(NSString *)belowBtnContent
                  withMessageType:(NSNumber *)messageType
                  withMessageFrom:(NSNumber *)messageFrom
                   withUpLanguage:(NSString *)upLanguage
                     withUpAccent:(NSString *)upAccent
                withBelowLanguage:(NSString *)belowLanguage
                  withBelowAccent:(NSString *)belowAccent;

-(NSDictionary *)fixedOtherDic;

-(NSDictionary *)fixedSelfDic;


-(void)dataAppendDic:(NSDictionary *)dic;


/**
 直接调用下面的接口就行了
 
 此函数上面的接口不用调用
 ****/
-(void)appendFromLanguage:(NSString*)from toLanguage:(NSString*)to
                  srcText:(NSString*)src toText:(NSString *)dest isLeft:(BOOL)isLeft;
@end
