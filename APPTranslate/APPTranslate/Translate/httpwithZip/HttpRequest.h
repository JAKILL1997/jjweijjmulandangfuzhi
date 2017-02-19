//
//  HttpRequest.h
//  MSC

//  descriptin :一个简单的http连接封装

//  Created by ypzhao on 13-4-8.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//
#import <Foundation/Foundation.h>

@class HttpRequest;

@protocol HttpRequestListenerDelegate

//-(void) onDLProgress:(NSURLConnection *)connection progress:(int) progress;
//
//-(void) onResultWithData:(NSURLConnection *)connection data:(NSData*) data;
//
//-(void) onErrorWithMsg:(NSURLConnection *)connection msg:(NSError*) msg;

-(void) onDLProgress:(HttpRequest *)request progress:(int) progress;

-(void) onResultWithData:(HttpRequest *)request data:(NSData*) data;

-(void) onErrorWithMsg:(HttpRequest *)request msg:(NSError*) msg;


@end


@interface HttpRequest : NSObject
{
    NSMutableData *_reciveData;
    
    //    id<HttpRequestListenerDelegate>       _delegate;
    
}

@property(retain,readonly) NSURLConnection *connection;
@property(readwrite,retain) NSString        *url;
@property(readwrite) NSTimeInterval         timeout;
@property(readwrite) double                 totalSize;
@property(readwrite) double                 dlSize;
@property(readwrite) int                    downloadPercent;
//@property(assign) id<HttpRequestListenerDelegate> delegate;
@property (nonatomic, weak) id<HttpRequestListenerDelegate> delegate;

/**
 * @fn      initWithUrl
 * @brief   创建对象
 *
 * url地址需要将http:// 或者 https://字样带上
 *
 * @param   url         -[in] url地址
 * @see
 */
- (id) initWithUrl:(NSString *) url;

/**
 * @fn      httpRequestWithUrl
 * @brief   创建对象
 *
 * url地址需要将http:// 或者 https://字样带上
 *
 * @param   url         -[in] url地址
 * @see
 */
+ (id) httpRequestWithUrl:(NSString *) url;


/**
 * @fn      sendData
 * @brief   发送数据
 *
 * @param   data        -[in] 需要发送的数据
 * @see
 */
- (void) sendData:(NSData *) data;

/**
 * @fn      sendData
 * @brief   reciveData
 *
 * @param   data        -[out] 需要发送的数据
 * @see
 */
- (void) reciveData:(NSData *) data;

/**
 * @fn      cancel
 * @brief   取消本次http链接
 *
 * @see
 */
- (void) cancel;

@end
