//
//  RecordButton.h
//  APPTranslate
//
//  Created by 王丹 on 15-5-13.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordButton : UIButton


-(id)initWithRadius:(CGFloat)radius center:(CGPoint)center;

-(void)setClickHandler:(void(^)())handler;

-(void)beginAnimate;

-(void)stopAnimate;
@end
