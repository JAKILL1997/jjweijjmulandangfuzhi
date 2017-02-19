//
//  UIColor+HEX.m
//  APPTranslate
//
//  Created by wangdan on 15/5/14.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "UIColor+HEX.h"

@implementation UIColor(JAKILL)

+(UIColor *)colorFromRGB:(unsigned long)value
{
    return [UIColor colorWithRed:(value >> 16 & 0xff ) / 255.0f
                           green:(value >> 8 & 0xff ) / 255.0f
                            blue:(value & 0xff ) / 255.0f
                           alpha:1.0f];
}

@end
