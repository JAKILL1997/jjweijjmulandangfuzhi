//
//  JKRootNavigationController.m
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "JKRootNavigationController.h"

@interface JKRootNavigationController ()

@end

@implementation JKRootNavigationController

+ (void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:[JKRootNavigationController class], nil];
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"resource/navibar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [navigationBar setTintColor:[UIColor blackColor]];
//    [navigationBar setBackIndicatorImage:[UIImage imageNamed:@"resource/Favorite/back.png"]];
//    [navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"resource/Favorite/back.png"]];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
#if 0
    [[navigationBar layer] setShadowRadius:0.5f];
    [navigationBar setShadowImage:[SPStaticTools createImageWithColor:[UIColor whiteColor] size:CGSizeMake(0.5f, 0.5f)]];
#endif
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
