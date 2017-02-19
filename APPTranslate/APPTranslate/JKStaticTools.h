//
//  JKStaticTools.h
//  APPTranslate
//
//  Created by wangdan on 15/5/15.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKStaticTools : NSObject

+ (void)traverseSubviews:(UIView *)superView;

+ (UIViewController *)viewControllerOfView:(UIView *)view;

+ (NSString *)uniqueIdentifer;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

+ (NSMutableDictionary *)parseQuery:(NSString *)queryString;

+ (NSString *)randomString:(NSInteger)length;

+ (UIImage *)takeScreenshots;

@end

@interface NSNumber (SPObject)

+ (NSNumber *)intNumberWithObject:(id)object;

+ (NSNumber *)longlongNumberWihtObject:(id)object;

@end

@interface UIView (image)

- (UIImage *)convertViewToImage;

@end
