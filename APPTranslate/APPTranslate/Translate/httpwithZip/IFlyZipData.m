//
//  IFlyZipData.m
//  MSC
//
//  Created by ypzhao on 13-4-8.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "IFlyZipData.h"

@implementation IFlyZipData

/*
 * @gzip压缩接口，先异或在压缩
 */
+ (NSData *)gzipData:(NSData *)pUncompressedData
{
    NSData *postData = [super gzipData:pUncompressedData];
     return [self Encryption:postData];
}

/*
 * @gziip 解压接口,先异或然后解压
 */
+ (NSData *)uncompressZippedData:(NSData *)compressedData
{
   NSData *postData =  [self Encryption:compressedData];
    
    return [super uncompressZippedData: postData];
}

/**
 * @ 数据加密类，只是简单的加密，每一个byte都和5做^(异或)操作
 */
+ (NSData *) Encryption:(NSData *) data
{
    Byte *_byte = (Byte*)[data bytes];
    for (int i = 0; i < [data length]; i++) {
        _byte[i] = _byte[i]^0x05;
    }
    NSData *postData = [NSData dataWithBytes:_byte length:[data length]];
    return postData;
}
@end
