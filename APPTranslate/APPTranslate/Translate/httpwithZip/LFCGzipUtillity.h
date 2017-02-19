//
//  LFCGzipUtillity.h
//  TechownShow
//
//  Created by kuro on 12-8-27.
//  Copyright (c) 2012年 yphao. All rights reserved.
//

// 数据的解压和压缩的过程

#import <Foundation/Foundation.h>

#import "zlib.h"

@interface LFCGzipUtillity : NSObject

+ (NSData *)gzipData:(NSData *)pUncompressedData;

+ (NSData *)uncompressZippedData:(NSData *)compressedData;

@end
