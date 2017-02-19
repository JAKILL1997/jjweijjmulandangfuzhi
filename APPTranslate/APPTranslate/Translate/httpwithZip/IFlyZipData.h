//
//  IFlyZipData.h
//  MSC
//
//  Created by ypzhao on 13-4-8.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "LFCGzipUtillity.h"

@interface IFlyZipData : LFCGzipUtillity

+ (NSData *) Encryption:(NSData *) data;

/*
 * @gziip 解压接口,先异或然后解压
 */
+ (NSData *)uncompressZippedData:(NSData *)compressedData;

/*
 * @gzip压缩接口，先异或在压缩
 */
+ (NSData *)gzipData:(NSData *)pUncompressedData;

@end
