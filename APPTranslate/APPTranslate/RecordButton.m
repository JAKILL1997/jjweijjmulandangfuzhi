//
//  RecordButton.m
//  APPTranslate
//
//  Created by 王丹 on 15-5-13.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "RecordButton.h"
#import "UIColor+HEX.h"

@interface RecordButton()

@property (nonatomic, strong) UIView *roundBackView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) void(^btHandler)();
@property (nonatomic, assign) BOOL animating;
@end

@implementation RecordButton




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithRadius:(CGFloat)radius center:(CGPoint)center
{
    
    self = [super initWithFrame:CGRectMake(0, 0, radius + 1, radius + 1)];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = (radius + 1) / 2.0f;
    self.center = center;
    [self setBackgroundImage:[UIImage imageNamed:@"VoiceSearchLoading010.png"] forState:UIControlStateNormal];
    
    _roundBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius + 1, radius + 1)];
    _roundBackView.backgroundColor = [UIColor clearColor];
    _roundBackView.layer.borderWidth = 2.0f;
    _roundBackView.layer.borderColor = [[UIColor colorFromRGB:0x09bb07] CGColor];
    
    _roundBackView.layer.cornerRadius = radius / 2.0f;
    [self addSubview: _roundBackView];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, radius + 1, radius + 1)];
    _imgView.layer.cornerRadius = radius / 2.0f;
    _imgView.image = [UIImage imageNamed:@"voice_password_loading.png"];
    [self addSubview: _imgView];
    _imgView.alpha = 0.0f;
    
    [self addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];

    return self;

}



-(void)setClickHandler:(void(^)())handler {
    _btHandler = handler;
}


-(void)clickHandler:(RecordButton *)sender {
    
    if (sender.tag == 0) {
        [self beginAnimate];
        sender.tag = 1;
        
    }else if (sender.tag == 1) {
        sender.tag = 0;
        [self stopAnimate];
        
    }
    
    if (_btHandler != nil) {
        _btHandler();
    }else {
        NSLog(@"no handler");
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pt = [self convertPoint:point fromView:self];
    if ([self pointInside:pt withEvent:event]) {
        return self;
    }
    return nil;
}




- (void)beginAnimate {
    _animating = YES;
    _imgView.alpha = 1.0f;
    _roundBackView.alpha = 0.0f;
    CABasicAnimation *appDeleteShakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    appDeleteShakeAnimation.autoreverses = NO;
    appDeleteShakeAnimation.repeatDuration = HUGE_VALF;
    appDeleteShakeAnimation.duration = 0.6;
    appDeleteShakeAnimation.fromValue = [NSNumber numberWithFloat:0];
    appDeleteShakeAnimation.toValue=[NSNumber numberWithFloat:M_PI * 2];
    [_imgView.layer addAnimation:appDeleteShakeAnimation forKey:@"appDeleteShakeAnimation"];
}

- (void)stopAnimate {
    _animating = NO;
    _imgView.alpha = 0.0f;
    _roundBackView.alpha = 1.0f;
    [_imgView.layer removeAllAnimations];
}




@end
