//
//  JKAdManager.h
//  APPTranslate
//
//  Created by wangdan on 2017/2/26.
//  Copyright © 2017年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JKAdManager : NSObject


+ (id)sharedInstance;

- (void)integradeWithVc:(UIViewController *)vc;

- (void)show;

@end
