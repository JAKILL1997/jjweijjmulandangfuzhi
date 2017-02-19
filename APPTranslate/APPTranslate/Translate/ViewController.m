//
//  ViewController.m
//  baidufanyi
//
//  Created by wangdan on 15-1-19.
//  Copyright (c) 2015年 wangdan. All rights reserved.
//

#import "ViewController.h"
#import "transLate.h"



#pragma mark 保存的html文件名称和文件夹名称
#define  HTML_ZIP           @"html.zip"
#define  HTML_DIRECTORY     @"htmlDirectory"




@interface ViewController ()
{
    
    NSMutableURLRequest *urlRequest;
    
    NSURL *testURL;
    
    transLate *transObj;

    UIWebView *testWebView;
    
    UILabel *volumeLabel;
    
    NSMutableString *totalstring;
    
    NSString *voiceKind;
    
}

@end

@implementation ViewController



- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //创建识别
    self.recognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
    
    self.sythesizer= [IFlySpeechSynthesizer sharedInstance];
    self.sythesizer.delegate = self;
    return self;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];

    transObj=[[transLate alloc]init];
    transObj.delegate=self;
    
    self.recognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
    
    self.sythesizer= [IFlySpeechSynthesizer sharedInstance];
    self.sythesizer.delegate = self;
    [self optionalSetting];
    
    totalstring=[[NSMutableString alloc]init];

    
    
    volumeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 400, 40, 40)];
    volumeLabel.text=@"__________________";
    [self.view addSubview:volumeLabel];
    
    
    
    UIButton *listenButtonChinese=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    listenButtonChinese.backgroundColor=[UIColor cyanColor];
    [listenButtonChinese setTitle:@"汉语识别" forState:UIControlStateNormal];
    listenButtonChinese.frame=CGRectMake(10, 50, 100, 50);
    [listenButtonChinese addTarget:self action:@selector(listenButtonChineseHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listenButtonChinese];
    
    
    UIButton *listenButtonEnglish=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    listenButtonEnglish.backgroundColor=[UIColor cyanColor];
    [listenButtonEnglish setTitle:@"英语识别" forState:UIControlStateNormal];
    listenButtonEnglish.frame=CGRectMake(150, 50, 100, 50);
    [listenButtonEnglish addTarget:self action:@selector(listenButtonEnglishHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listenButtonEnglish];
    
    
    
    UIButton *cancleListen=[UIButton buttonWithType:UIButtonTypeRoundedRect];    cancleListen.backgroundColor=[UIColor cyanColor];
    [cancleListen setTitle:@"停止识别" forState:UIControlStateNormal];
    cancleListen.frame=CGRectMake(10, 200, 100, 50);
    [cancleListen addTarget:self action:@selector(cancleListenButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleListen];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//
//-(void)translateButtonHandler:(id)sender
//{
//    NSString *tmpString=@"我好怀念我们的过去，曾经的我是一个纯真善良的男人，现在的我，是一个帅气漂亮的存在";
//    
//////    [transObj googleTranslateUsingBlockFrom:[transLate getChineseConstant] toSpeech:[transLate getEnglishConstant] withText:tmpString];
//////    [transObj baiduTranslateFrom:tmpString toSpeech:@"en" withText:@"zh"];
////    [transObj startGoogleTranslateForm:[transLate getGGChineseConstant] toSpeech:[transLate getGGEnglishConstant] withText:tmpString];
//    [transObj startBaiduTranslateForm:nil toSpeech:nil withText:tmpString];
//}





#pragma  mark button点击处理函数
-(void)listenButtonChineseHandler:(id)sender
{
    voiceKind=[NSString stringWithFormat:@"chinese"];
    [self.recognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    [self.recognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE ]];
    bool ret = [self.recognizer startListening];
    totalstring=nil;
    totalstring=[[NSMutableString alloc]init];
    if( ret ){
        NSLog(@"启动识别服务成功");
    }else{
        NSLog(@"启动识别服务失败");
    }
}


-(void)listenButtonEnglishHandler:(id)sender
{
    voiceKind=[NSString stringWithFormat:@"english"];
    [self.recognizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE ]];
    [self.recognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    bool ret = [self.recognizer startListening];
    totalstring=nil;
    totalstring=[[NSMutableString alloc]init];
    if( ret ){
        NSLog(@"启动识别服务成功");
    }else{
        NSLog(@"启动识别服务失败");
    }
}


-(void)cancleListenButtonHandler:(id)sender
{
    [self.recognizer stopListening];
}


#pragma mark 翻译回调
-(void)onTranslateResult:(NSString *)resultString withError:(NSError *)resultErro
{
    NSLog(@"in %s,result is :%@",__func__,resultString);
    if( resultString!=nil && resultString.length!=0 ){
        [self.sythesizer startSpeaking:resultString];
    }
    
}


#pragma  mark 识别回调回调
-(void)onBeginOfSpeech
{
    NSLog(@"on begin of speech");
}

-(void)onError:(IFlySpeechError *)errorCode
{
    NSLog(@"recognizer error");
}



-(void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }

    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    
    [totalstring appendFormat:@"%@",resultFromJson];
    NSLog(@"result string is %@",resultFromJson);
    
    if( isLast  ){
        if( resultFromJson !=nil && resultFromJson.length != 0 ){ //开始翻译
//            [transObj startGoogleTranslateForm:[transLate getBDChineseConstant] toSpeech:[transLate getBDEnglishConstant] withText:totalstring];
            if( [voiceKind isEqualToString:@"chinese"] ){
                [self.sythesizer setParameter:@"Catherine" forKey:[IFlySpeechConstant VOICE_NAME]];
                [transObj startBaiduTranslateForm:[transLate getBDChineseConstant] toSpeech:[transLate getBDEnglishConstant] withText:totalstring];
            }else if( [voiceKind isEqualToString:@"english"] ){
                [self.sythesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
                [transObj startBaiduTranslateForm:[transLate getBDEnglishConstant] toSpeech:[transLate getBDChineseConstant] withText:totalstring];
            }
        }
    }
    
    
}



-(void)onVolumeChanged:(int)volume
{
    volumeLabel.text=[NSString stringWithFormat:@"%d",volume];
}



-(void)onEndOfSpeech
{
    
}



-(void)onCancel
{
    
}



#pragma mark  合成回调

-(void)onCompleted:(IFlySpeechError *)error
{
    
}

-(void)onBufferProgress:(int)progress message:(NSString *)msg
{
    
}

-(void)onSpeakProgress:(int)progress
{
    
}

-(void)onSpeakResumed
{
    
}

-(void)onSpeakPaused
{
    
}



-(void)onSpeakCancel
{
    
}

-(void)onEvent:(int)eventType arg0:(int)arg0 arg1:(int)arg1 data:(NSData *)eventData
{
    
}


#pragma  mark  合成的相关参数设置
-(void) optionalSetting
{
    // 可以自定义音频队列的配置（可选)，例如以下是配置连接非A2DP蓝牙耳机的代码
    //注意：
    //1. iOS 6.0 以上有效，6.0以下按类似方法配置
    //2. 如果仅仅使用语音合成TTS，并配置AVAudioSessionCategoryPlayAndRecord，可能会被拒绝上线appstore
    //    AVAudioSession * avSession = [AVAudioSession sharedInstance];
    //    NSError * setCategoryError;
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) {
    //        [avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&setCategoryError];
    //    }
    
    /*
     // 设置语音合成的参数【可选】
     
     //合成的语速,取值范围 0~100
     [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
     
     //合成的音量;取值范围 0~100
     [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
     
     //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
     [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
     
     //音频采样率,目前支持的采样率有 16000 和 8000;
     [_iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
     
     //设置是否返回事件
     [_iFlySpeechSynthesizer setParameter:@"1" forKey:@"tts_data_notify"];
     
     //设置音频保存，如果不需要则指定为nil
     [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
     
     */
    //    [_iFlySpeechSynthesizer setParameter:@"vixx" forKey:[IFlySpeechConstant VOICE_NAME]];
    [self.sythesizer setParameter:@"Catherine" forKey:[IFlySpeechConstant VOICE_NAME]];
}

#pragma  mark  识别的相关参数设置



@end
