//
//  TTSConfigViewController.m
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "TTSConfigViewController.h"
#import "TTSConfig.h"

@interface TTSConfigViewController ()<AKPickerViewDelegate,AKPickerViewDataSource>

@end

@implementation TTSConfigViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self initMultiSelector];
    [self initVcnPikerView];
    [self initLabel];
    [self needUpdateView];
    [self setRightButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"语音设置";
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRightButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    //self.navigationController.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)rightBarBtnHandler {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}





-(void)initMultiSelector {

    CGRect rect = [UIScreen mainScreen].bounds;
    _roundSlider = [[SAMultisectorControl alloc]initWithFrame:CGRectMake(0, 64, rect.size.width, 295)];
    [self.view addSubview: _roundSlider];
    
    [_roundSlider addTarget:self action:@selector(multisectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIColor *blueColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:245.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:29.0/255.0 green:207.0/255.0 blue:0.0 alpha:1.0];
    
    _pitchSec = [SAMultisectorSector sectorWithColor:redColor maxValue:100];
    _speedSec = [SAMultisectorSector sectorWithColor:blueColor maxValue:100];
    _volumeSec = [SAMultisectorSector sectorWithColor:greenColor maxValue:100];
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    _pitchSec.endValue = instance.pitch.integerValue;
    _speedSec.endValue = instance.speed.integerValue;
    _volumeSec.endValue = instance.volume.integerValue;
    
    [_roundSlider addSector:_pitchSec];
    [_roundSlider addSector:_speedSec];
    [_roundSlider addSector:_volumeSec];//半径依次增大
}

- (void)multisectorValueChanged:(id)sender{
    [self updateDataView];
}


- (void)updateDataView{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    instance.speed = [NSString stringWithFormat:@"%d", (int)_speedSec.endValue];
    _speedSec.endValue = [instance.speed intValue];
    
    instance.volume = [NSString stringWithFormat:@"%d", (int)_volumeSec.endValue];
    _volumeSec.endValue = [instance.volume intValue];
    
    instance.pitch = [NSString stringWithFormat:@"%d", (int)_pitchSec.endValue];
    _pitchSec.endValue = [instance.pitch intValue];
    
    
    _speedValueLabel.text = instance.speed;
    _volumeValueLabel.text = instance.volume;
    _pitchValueLabel.text = instance.pitch;
    
}


-(void)initLabel {
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    _volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 324+ 64, 106, 21)];
    _volumeLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:207.0/255.0 blue:0.0 alpha:1.0];
    _volumeLabel.textAlignment = NSTextAlignmentCenter;
    _volumeLabel.text = @"音量";
    [self.view addSubview:_volumeLabel];
    
    _volumeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 345 + 64, 106, 21)];
    _volumeValueLabel.textColor = [UIColor blackColor];
    _volumeValueLabel.textAlignment = NSTextAlignmentCenter;
    _volumeValueLabel.text = @"50";
    [self.view addSubview: _volumeValueLabel];
    
    _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 106.0f/2 , 324+ 64, 106, 21)];
    _speedLabel.textColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    _speedLabel.textAlignment = NSTextAlignmentCenter;
    _speedLabel.text = @"语速";
    [self.view addSubview:_speedLabel];
    
    
    _speedValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 106.0f/2 , 345+ 64, 106, 21)];
    _speedValueLabel.textColor = [UIColor blackColor];
    _speedValueLabel.textAlignment = NSTextAlignmentCenter;
    _speedValueLabel.text = @"50";
    [self.view addSubview:_speedValueLabel];
    
    _pitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - 8 - 106 , 324+ 64, 106, 21)];
    _pitchLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    _pitchLabel.textAlignment = NSTextAlignmentCenter;
    _pitchLabel.text = @"音调";
    [self.view addSubview:_pitchLabel];
    
    _pitchValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width - 8 - 106 , 345+ 64, 106, 21)];
    _pitchValueLabel.textColor = [UIColor blackColor];
    _pitchValueLabel.textAlignment = NSTextAlignmentCenter;
    _pitchValueLabel.text = @"50";
    [self.view addSubview:_pitchValueLabel];
    
    
}


-(void)initVcnPikerView {
    CGRect rect = [UIScreen mainScreen].bounds;
    _vcnPicker = [[AKPickerView alloc] initWithFrame:CGRectMake(8, 411 + 64, rect.size.width - 16, 29)];

    _vcnPicker.delegate = self;
    _vcnPicker.dataSource = self;
    _vcnPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _vcnPicker.textColor = [UIColor blackColor];
    _vcnPicker.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _vcnPicker.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    _vcnPicker.highlightedTextColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    _vcnPicker.interitemSpacing = 20.0;
    _vcnPicker.fisheyeFactor = 0.001;
    _vcnPicker.pickerViewStyle = AKPickerViewStyle3D;
    _vcnPicker.maskDisabled = false;
    [self.view addSubview: _vcnPicker];
    
}



-(void)needUpdateView {//更新界面显示
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    _speedValueLabel.text = instance.speed;//超时等时间设置
    _volumeValueLabel.text = instance.volume;
    _pitchValueLabel.text = instance.pitch;
    
    _speedSec.endValue = instance.speed.integerValue;
    _volumeSec.endValue = instance.volume.integerValue;
    _pitchSec.endValue = instance.pitch.integerValue;


    
//    NSString *sampleRate = instance.sampleRate;//采样率
//    if ([sampleRate isEqualToString:[IFlySpeechConstant SAMPLE_RATE_16K]]) {
//        _sampleRateSeg.selectedSegmentIndex = 0;
//        
//    }else if ([sampleRate isEqualToString:[IFlySpeechConstant SAMPLE_RATE_8K]]) {
//        _sampleRateSeg.selectedSegmentIndex = 1;
//        
//    }
//    
    for (int i = 0;i < instance.vcnNickNameArray.count; i++) {
        if ([instance.vcnIdentiferArray[i] isEqualToString: instance.commanVcn]) {
            [_vcnPicker selectItem:i animated:NO];
        }
    }
}


#pragma mark - 发音人选择数据源

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    TTSConfig* instance = [TTSConfig sharedInstance];
    return instance.vcnIdentiferArray.count;
}
- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item;
{
    TTSConfig* instance = [TTSConfig sharedInstance];
    return  [instance.vcnNickNameArray objectAtIndex:item];
}


#pragma mark - 选择发音人事件回调
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    instance.commanVcn = [instance.vcnIdentiferArray objectAtIndex:item];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
