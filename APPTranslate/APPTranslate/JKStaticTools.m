//
//  JKStaticTools.m
//  APPTranslate
//
//  Created by wangdan on 15/5/15.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "JKStaticTools.h"

@implementation JKStaticTools
#pragma mark - public
+ (void)traverseSubviews:(UIView *)superView
{
    [self traverseSubviews:superView depth:1];
}


+ (UIViewController *)viewControllerOfView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (NSString *)uniqueIdentifer
{
    NSTimeInterval prefix = [[NSDate date] timeIntervalSince1970];
    int suffix = arc4random()%10000;
    
    NSString *identifer = [NSString stringWithFormat:@"%10.6f%04d", prefix, suffix];
    identifer = [identifer stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSLog(@"identifer:%@ (%lu位)", identifer, (unsigned long)[identifer length]);
    
    return identifer;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    return [self createImageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSMutableDictionary *)parseQuery:(NSString *)queryString
{
    if ([queryString isEqualToString:@""] || queryString == nil) {
        return nil;
    }
    
    NSArray *temp = [queryString componentsSeparatedByString:@"&"];
    if ([temp count] == 0 || temp == nil) {
        return nil;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *keyValue in temp) {
        NSRange range = [keyValue rangeOfString:@"="];
        if (range.location == NSNotFound) {
            continue;
        } else {
            NSString *key = [keyValue substringToIndex:range.location];
            NSString *value = [keyValue substringFromIndex:range.location+range.length];
            [dict setValue:value forKey:key];
        }
    }
    return dict;
}


+ (NSString *)randomString:(NSInteger)length
{
    char *temp = (char *)malloc(length+1);
    memset(temp, 0, length+1);
    for (int i = 0; i < length; *(temp + i++)=(char)('A'+arc4random()%26));
    NSString *string = [NSString stringWithUTF8String:temp];
    free(temp);//避免内存泄漏
    return string;
}


+ (UIImage *)takeScreenshots
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 2.0f);
    //    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshots = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshots;
}

#pragma mark - private
+ (void)traverseSubviews:(UIView *)superView depth:(NSUInteger)depth
{
    for (UIView *view in superView.subviews) {
        NSLog(@"** %lu - %@", (unsigned long)depth, NSStringFromClass([view class]));
        [self traverseSubviews:view depth:depth+1];
    }
}

@end

@implementation NSNumber (SPObject)

+ (NSNumber *)intNumberWithObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithInt:[object intValue]];
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [NSNumber numberWithInt:[object intValue]];
    }
    return @0;
}

+ (NSNumber *)longlongNumberWihtObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithLongLong:[object longLongValue]];
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [NSNumber numberWithLongLong:[object longLongValue]];
    }
    return @0;
}

@end

@implementation UIView (image)

- (UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 2);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end

