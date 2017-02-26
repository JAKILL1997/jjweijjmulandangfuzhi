//
//  ButtonHoldView.m
//  APPTranslate
//
//  Created by wangdan on 15/5/15.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "ButtonHoldView.h"
#import "RecordButton.h"
#import "UIColor+HEX.h"
#import "AKPickerView.h"
#import "IATConfig.h"
#import "IATDataHelper.h"
#import "TransLate.h"
#import "ListeDataSource.h"
#import "JKStaticTools.h"
#import "ViewController.h"
#import "PcmPlayer.h"
#import "TTSConfig.h"
#import "JKAdManager.h"


#define VIEW_HEIGHT     120.0f
#define BUTTON_RADIUS   60.0f //button 直径


@interface ButtonHoldView ()<AKPickerViewDataSource,AKPickerViewDelegate,TranslateDelegate>

@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property (nonatomic, assign) RecognizeState speechState;

@property (nonatomic, strong) RecordButton *leftRecordBtn;
@property (nonatomic, strong) RecordButton *rightRecordBtn;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *verticalView;

@property (nonatomic, strong) AKPickerView *leftPickerView;
@property (nonatomic, strong) AKPickerView *rightPickerView;


@property (nonatomic, assign) BOOL isLeft;//是左边的按钮被点下，还是右边的按钮被点下
@property (nonatomic, strong) NSString *leftListenLanguage;//左侧识别语种
@property (nonatomic, strong) NSString *leftListenAccent;//左侧识别口音

@property (nonatomic, strong) NSString *rightListenLanguage;//右侧识别语种
@property (nonatomic, strong) NSString *rightListenAccent;//右侧识别口音


@property (nonatomic, strong) NSMutableString *recognizerString;//识别得到的字符串

@property (nonatomic ,strong) TransLate *translateInstance;

@end

@implementation ButtonHoldView



-(id)init {
    CGRect rect = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:
            CGRectMake(0,rect.size.height - VIEW_HEIGHT,rect.size.width,VIEW_HEIGHT)];
    
    if (self) {
        [self initUI];
        [self initObjAndParam];
    }
    return  self;
}

-(void)initObjAndParam {
    [IATConfig sharedInstance];//初始化识别参数
    _iatInstance = [IATObject sharedInstance];//初始化识别对象
    [_iatInstance normalInit];//识别对象设置参数
    _recognizerString = [[NSMutableString alloc] init];//识别结果string
    
    _translateInstance = [[TransLate alloc] init];//初始化翻译对象
    _translateInstance.delegate = self;
    
    
    [TTSConfig sharedInstance];
    _ttsInstance = [TTSObject sharedInstance];
    _ttsInstance.synthesizer.delegate = self;
}




-(void)initUI {
    
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    
    CGPoint leftCenter = CGPointMake(rect.size.width / 4, 10 + BUTTON_RADIUS / 2);
    CGPoint rightCenter = CGPointMake((rect.size.width * 3) / 4, 10 + BUTTON_RADIUS / 2);
    
    _leftRecordBtn = [[RecordButton alloc] initWithRadius:BUTTON_RADIUS center:leftCenter];
    [self addSubview: _leftRecordBtn];
    _leftRecordBtn.tag = 0; //还未开始识别
    [_leftRecordBtn addTarget:self action:@selector(leftBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _rightRecordBtn = [[RecordButton alloc] initWithRadius:BUTTON_RADIUS center:rightCenter];
    [self addSubview: _rightRecordBtn];
    _rightRecordBtn.tag = 0; //还未开始识别
    [_rightRecordBtn addTarget:self action:@selector(rightBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 0.5f)];
    _topLine.backgroundColor = [UIColor colorFromRGB:0x09bb07];
    [self addSubview: _topLine];
    
    
    _verticalView = [[UIView alloc] initWithFrame:CGRectMake(rect.size.width / 2 - 0.5f, 20, 0.5, BUTTON_RADIUS)];
    _verticalView.backgroundColor = [UIColor colorFromRGB:0x09bb07];
    [self addSubview: _verticalView];
    
    
    
    _leftPickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 10 + BUTTON_RADIUS +10 , rect.size.width / 2 , 20)];
    _leftPickerView.delegate = self;
    _leftPickerView.dataSource = self;
    _leftPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    _leftPickerView.textColor = [UIColor colorFromRGB: 0x09bb07];
    _leftPickerView.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 17];
    _leftPickerView.highlightedFont = [UIFont fontWithName: @"HelveticaNeue" size: 17];
    _leftPickerView.highlightedTextColor = [UIColor blackColor];
    _leftPickerView.interitemSpacing = 20.0;
    _leftPickerView.fisheyeFactor = 0.001;
    _leftPickerView.pickerViewStyle = AKPickerViewStyle3D;
    _leftPickerView.maskDisabled = false;
    [self addSubview: _leftPickerView];
    [_leftPickerView selectItem:0 animated:NO];//默认选择中文
    
    
    _rightPickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(rect.size.width / 2, 10 + BUTTON_RADIUS +10 , rect.size.width / 2 , 20)];
    _rightPickerView.delegate = self;
    _rightPickerView.dataSource = self;
    _rightPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    _rightPickerView.textColor = [UIColor colorFromRGB: 0x09bb07];
    _rightPickerView.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 17];
    _rightPickerView.highlightedFont = [UIFont fontWithName: @"HelveticaNeue" size: 17];
    _rightPickerView.highlightedTextColor = [UIColor blackColor];
    _rightPickerView.interitemSpacing = 20.0;
    _rightPickerView.fisheyeFactor = 0.001;
    _rightPickerView.pickerViewStyle = AKPickerViewStyle3D;
    _rightPickerView.maskDisabled = false;
    [self addSubview: _rightPickerView];
    [_rightPickerView selectItem:1 animated:NO];//默认选择英语
}


#pragma mark - 事件响应函数
-(void)leftBtnHandler:(RecordButton *)sender {
    
    if (_speechState == SpeechNotStart) {
        self.isLeft = YES;
//        [self playStartSpeeking];
        [_recognizerString setString:@""]; //将识别数据清空
        [IATConfig sharedInstance].isLeftBtn = YES;
        [_iatInstance normalInit];
        _iatInstance.speechRecognizer.delegate = self;
        [_iatInstance.speechRecognizer startListening];//开始识别
        _speechState = SpeechStarting;
    }else {
        _iatInstance.speechRecognizer.delegate = self;
        [_iatInstance.speechRecognizer stopListening];//取消识别
         _speechState = SpeechNotStart;
    }
    
}


-(void)rightBtnHandler:(RecordButton*)sender {
    
    if (_speechState == SpeechNotStart) {
        self.isLeft = NO;
        [_recognizerString setString:@""]; //首先将识别数据清空
        [IATConfig sharedInstance].isLeftBtn = NO;
        [_iatInstance normalInit];
        _iatInstance.speechRecognizer.delegate = self;
        [_iatInstance.speechRecognizer startListening];//开始识别
        _speechState = SpeechStarting;
    }else {
        _iatInstance.speechRecognizer.delegate = self;
        [_iatInstance.speechRecognizer stopListening];//取消识别
        _speechState = SpeechNotStart;
    }
    
}


#pragma mark - AKPickerView回调

-(NSString*)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return [[IATConfig sharedInstance].listenArray objectAtIndex:item]; //显示 @"中文",@"英文"
}

-(NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return  [[IATConfig sharedInstance].listenArray count]; //可选语言的数量
}


-(void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    if (pickerView == _leftPickerView) { //左侧的语种
        if (item == 0) {
            [IATConfig sharedInstance].leftLanguage = [IATConfig chinese];//识别语种是汉语
            [IATConfig sharedInstance].leftAccent = [IATConfig mandarin];//普通话
        }else if (item == 1) {
            [IATConfig sharedInstance].leftLanguage = [IATConfig english];//识别语种是英语
        }
        
    }else if (pickerView == _rightPickerView) { //右侧的语种
        if (item == 0) {
            [IATConfig sharedInstance].rightLanguage = [IATConfig chinese];//识别语种是汉语
            [IATConfig sharedInstance].rightAccent = [IATConfig mandarin];//普通话
        }else if (item == 1) {
            [IATConfig sharedInstance].rightLanguage = [IATConfig english];//识别语种是英语
        }
    }
}

#pragma mark - 识别回调

-(void)onBeginOfSpeech {//开始说话
    if (_isLeft) {
        [_leftRecordBtn beginAnimate];
    }else {
        [_rightRecordBtn beginAnimate];
    }

}

-(void)onCancel { //识别被取消
    
}

-(void)onEndOfSpeech { //说话结束
    
    _speechState = SpeechNotStart;
    [_leftRecordBtn stopAnimate];
    [_rightRecordBtn stopAnimate];
    
}

-(void)onError:(IFlySpeechError *)errorCode {//识别出现错误
    
}


/**
 isLast：本次识别的最后一个结果
 
 这里处理会出现一种真空的情况
 如果用户识别完成，按钮也不旋转了
 但是翻译结果还没出来
 此时应该给予一个提示
 说明正在翻译中
 ****/
-(void)onResults:(NSArray *) results isLast:(BOOL)isLast {
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [IATDataHelper stringFromJson:resultString];
    [_recognizerString appendString:resultFromJson];
    
    IATConfig *configInstance = [IATConfig sharedInstance];

    
    if (isLast){
        if (_recognizerString == nil || [_recognizerString isEqualToString:@""]) {
            NSLog(@"识别结果为空");
            return;
        }
        
        if ([configInstance.leftLanguage isEqualToString:configInstance.rightLanguage]) {//两边的语言相等不用翻译
            /**
             两边相等，可以进行识别，但是由于
             数据相等，也没必要进行处理，直接给出
             一个数据相等的提示就行了
             
             也就是暂时不处理这种情况的数据
             ****/
            NSLog(@"language same not need translate");
            
        }else {
            
            NSDictionary *keyDic = configInstance.iatToTransKeyDic;
            NSString *fromLanguage;
            NSString *toLanguange;
            if (_isLeft == YES) {
                fromLanguage = [keyDic objectForKey:configInstance.leftLanguage];
                toLanguange = [keyDic objectForKey:configInstance.rightLanguage];
            }else {
                fromLanguage = [keyDic objectForKey:configInstance.rightLanguage];
                toLanguange = [keyDic objectForKey:configInstance.leftLanguage];
            }
            _translateInstance.delegate = self;//开始翻译
            [_translateInstance startBaiduTranslateForm:fromLanguage
                                               toSpeech:toLanguange
                                               withText:_recognizerString];
        }
        NSLog(@"\r++++++++++++++++++++++++++++++++\r%@\r++++++++++++++++++++++++++++++++\r",  _recognizerString);
    }
}


-(void)onVolumeChanged:(int)volume { //识别音量回调
    
}


/**
 翻译结果回调
 *****/
-(void)onTranslateResult:(NSString*)resultString withError:(NSError*)resultErro {
    
    if (resultString == nil && resultString.length == 0) {
        return;
    }
    if (resultErro.code == 0) {
        NSLog(@"translatedstring is \r %@ \r",resultString);
        NSString *fromLanguage;
        NSString *toLanguange;
        if (_isLeft == YES) {
            fromLanguage = [IATConfig sharedInstance].leftLanguage;
            toLanguange = [IATConfig sharedInstance].rightLanguage;
        }else {
            fromLanguage = [IATConfig sharedInstance].rightLanguage;
            toLanguange = [IATConfig sharedInstance].leftLanguage;
        }
        
        ListeDataSource *listenDataInstance = [ListeDataSource sharedInstance];
        [listenDataInstance appendFromLanguage:fromLanguage
                                    toLanguage:toLanguange
                                       srcText:_recognizerString
                                        toText:resultString
                                        isLeft:_isLeft];
        
        UIViewController *vc = [JKStaticTools viewControllerOfView:self];
        
        UITableView *tbView = ((ViewController *)[JKStaticTools viewControllerOfView:self]).tbView;
        [tbView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:listenDataInstance.cellMessageFrameArray.count-1 inSection:0];
        [tbView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
        [[JKAdManager sharedInstance] integradeWithVc:vc];
        [[JKAdManager sharedInstance] show];
        
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_ttsInstance normalInit];
            _ttsInstance.synthesizer.delegate = self;
            [_ttsInstance.synthesizer startSpeaking:resultString];
        });


    }
}

-(void)playStartSpeeking {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VoiceSearchOn" ofType:@"wav"];
    _audioPlayer = [[PcmPlayer alloc] initWithFilePath:path];
    [_audioPlayer play];
}


#pragma mark - 合成回调
/** 开始合成回调 */
-(void)onSpeakBegin {
    
}

/** 缓冲进度回调
 
 @param progress 缓冲进度，0-100
 @param msg 附件信息，此版本为nil
 */
-(void)onBufferProgress:(int) progress message:(NSString *)msg {
    
}

/** 播放进度回调
 
 @param progress 播放进度，0-100
 */
-(void)onSpeakProgress:(int)progress {
    
}

/** 暂停播放回调 */
-(void)onSpeakPaused {
    
}

/** 恢复播放回调 */
-(void)onSpeakResumed {
    
}

/** 正在取消回调
 
 当调用`cancel`之后会回调此函数
 */
- (void) onSpeakCancel {
    
}

@end
