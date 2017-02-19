//
//  TTSConfigViewController.h
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMultisectorControl.h"
#import "AKPickerView.h"

@interface TTSConfigViewController : UIViewController


@property (strong, nonatomic) UIScrollView *backScrollView;


@property (strong, nonatomic) SAMultisectorControl *roundSlider;

@property (strong, nonatomic) UILabel *volumeLabel;
@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *pitchLabel;

@property (strong, nonatomic) UILabel *volumeValueLabel;
@property (strong, nonatomic) UILabel *speedValueLabel;
@property (strong, nonatomic) UILabel *pitchValueLabel;


@property (strong, nonatomic) SAMultisectorSector *volumeSec;
@property (strong, nonatomic) SAMultisectorSector *speedSec;
@property (strong, nonatomic) SAMultisectorSector *pitchSec;

@property (strong, nonatomic) AKPickerView *vcnPicker;

@property (strong, nonatomic) UISegmentedControl *sampleRateSeg;
@property (strong, nonatomic) UISegmentedControl *engineModeSeg;
@property (strong, nonatomic) UISegmentedControl *engineTypeSeg;//云端 本地

@end
