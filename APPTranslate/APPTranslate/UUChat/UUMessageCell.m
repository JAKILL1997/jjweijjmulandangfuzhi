//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "UUAVAudioPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UUImageAvatarBrowser.h"
#import "UIColor+HEX.h"
#import "TTSObject.h"

@interface UUMessageCell ()<UUAVAudioPlayerDelegate,IFlySpeechSynthesizerDelegate>
{
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
    UUAVAudioPlayer *audio;
    
    UIView *headImageBackView;
    BOOL contentVoiceIsPlaying;
    TTSObject *_ttsInstance;
}

@end


@implementation UUMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 4、上面的button
        self.upBtnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.upBtnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.upBtnContent.titleLabel.font = ChatContentFont;
        self.upBtnContent.titleLabel.numberOfLines = 0;
        [self.upBtnContent addTarget:self action:@selector(upBtnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.upBtnContent];
        
        // 5、下面的button
        self.belowBtnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.belowBtnContent setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.belowBtnContent.titleLabel.font = ChatContentFont;
        self.belowBtnContent.titleLabel.numberOfLines = 0;
        self.belowBtnContent.backgroundColor = [UIColor blackColor];
        [self.belowBtnContent addTarget:self action:@selector(belowBtnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.belowBtnContent];
        
        
        

        
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        contentVoiceIsPlaying = NO;
        
        _ttsInstance = [TTSObject sharedInstance];

    }
    return self;
}



//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}




- (void)upBtnContentClick{
//    //play audio
//    if (self.messageFrame.message.type == UUMessageTypeVoice) {
//        if(!contentVoiceIsPlaying){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
//            contentVoiceIsPlaying = YES;
//            audio = [UUAVAudioPlayer sharedInstance];
//            audio.delegate = self;
//            //        [audio playSongWithUrl:voiceURL];
//            [audio playSongWithData:songData];
//        }else{
//            [self UUAVAudioPlayerDidFinishPlay];
//        }
//    }
//    //show the picture
//    else if (self.messageFrame.message.type == UUMessageTypePicture)
//    {
//        if (self.upBtnContent.backImageView) {
//            [UUImageAvatarBrowser showImage:self.upBtnContent.backImageView];
//        }
//        if ([self.delegate isKindOfClass:[UIViewController class]]) {
//            [[(UIViewController *)self.delegate view] endEditing:YES];
//        }
//    }
//    // show text and gonna copy that
//    else if (self.messageFrame.message.type == UUMessageTypeText)
//    {
//        [self.upBtnContent becomeFirstResponder];
//        UIMenuController *menu = [UIMenuController sharedMenuController];
//        [menu setTargetRect:self.upBtnContent.frame inView:self.upBtnContent.superview];
//        [menu setMenuVisible:YES animated:YES];
//    }
}




-(void)belowBtnContentClick{
    
    [_ttsInstance normalInit];
    _ttsInstance.synthesizer.delegate = self;
    [_ttsInstance.synthesizer startSpeaking:self.belowText];
    
//    //play audio
//    if (self.messageFrame.message.type == UUMessageTypeVoice) {
//        if(!contentVoiceIsPlaying){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
//            contentVoiceIsPlaying = YES;
//            audio = [UUAVAudioPlayer sharedInstance];
//            audio.delegate = self;
//            //        [audio playSongWithUrl:voiceURL];
//            [audio playSongWithData:songData];
//        }else{
//            [self UUAVAudioPlayerDidFinishPlay];
//        }
//    }
//    //show the picture
//    else if (self.messageFrame.message.type == UUMessageTypePicture)
//    {
//        if (self.upBtnContent.backImageView) {
//            [UUImageAvatarBrowser showImage:self.belowBtnContent.backImageView];
//        }
//        if ([self.delegate isKindOfClass:[UIViewController class]]) {
//            [[(UIViewController *)self.delegate view] endEditing:YES];
//        }
//    }
//    // show text and gonna copy that
//    else if (self.messageFrame.message.type == UUMessageTypeText)
//    {
//        [self.belowBtnContent becomeFirstResponder];
//        UIMenuController *menu = [UIMenuController sharedMenuController];
//        [menu setTargetRect:self.belowBtnContent.frame inView:self.belowBtnContent.superview];
//        [menu setMenuVisible:YES animated:YES];
//    }
    
    [self.voiceImgView startAnimating];
    
    
}



- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.upBtnContent benginLoadVoice];
}
- (void)UUAVAudioPlayerBeiginPlay
{
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.upBtnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    contentVoiceIsPlaying = NO;
    [self.upBtnContent stopPlay];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}


//内容及Frame设置
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{

    _messageFrame = messageFrame;
    UUMessage *message = messageFrame.message;
    
    
    
    //设置发音人相关
    self.upText = message.strContent;
    self.belowText =message.belowBtnStrContent;
    
    self.upBtnLanguage = message.upBtnLanguage;
    self.upBtnAccent = message.upBtnAccent;
    
    self.belowBtnLanguage = message.belowBtnLanguage;
    self.belowBtnAccent = message.belowBtnAccent;
    
    
    // 1、设置时间
    self.labelTime.text = message.strTime;
    self.labelTime.frame = messageFrame.timeF;
    
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
//    NSLog(<#NSString *format, ...#>)
    if ([self.upBtnLanguage isEqualToString:@"zh_cn"]) {
        [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
                                              withURL:[NSURL URLWithString:message.strIcon]
                                     placeholderImage:[UIImage imageNamed:@"chinese_flag"]];
    }else if ([self.upBtnLanguage isEqualToString:@"en_us"]) {
        [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
                                              withURL:[NSURL URLWithString:message.strIcon]
                                     placeholderImage:[UIImage imageNamed:@"english_flag2.png"]];
    }

    
    // 3、设置下标
    self.labelNum.text = message.strName;
    if (messageFrame.nameF.origin.x > 160) {
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }

    // 4、设置内容
    
    //prepare for reuse
    [self.upBtnContent setTitle:@"" forState:UIControlStateNormal];
    self.upBtnContent.voiceBackView.hidden = YES;
    self.upBtnContent.backImageView.hidden = YES;

    self.upBtnContent.frame = messageFrame.contentF;
    
    if (message.from == UUMessageFromMe) {//我自己说的
        self.upBtnContent.isMyMessage = YES;
        [self.upBtnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.upBtnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, messageFrame.belowBtnContentF.size.height , ChatContentLeft);
    }else{
        self.upBtnContent.isMyMessage = NO;
        [self.upBtnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.upBtnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, messageFrame.belowBtnContentF.size.height, ChatContentRight);

    }
    
    //背景气泡图
    UIImage *normal;
    if (message.from == UUMessageFromMe) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.upBtnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.upBtnContent setBackgroundImage:normal forState:UIControlStateHighlighted];

    
    // 5、设置下面的button
    
    //prepare for reuse
    [self.belowBtnContent setTitle:@"" forState:UIControlStateNormal];
    self.belowBtnContent.voiceBackView.hidden = YES;
    self.belowBtnContent.backImageView.hidden = YES;
    
    self.belowBtnContent.frame = messageFrame.belowBtnContentF;
    self.belowBtnContent.backgroundColor = [UIColor clearColor];
    
    if (message.from == UUMessageFromMe) {// 我自己的imageview
    
        self.upBtnContent.isMyMessage = YES;
        [self.belowBtnContent setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        self.belowBtnContent.contentEdgeInsets = UIEdgeInsetsMake(0, ChatContentRight, ChatContentBottom, ChatContentLeft);
        
//        if (self.voiceImgView == nil) {
//            //添加小喇叭
//            CGRect rect = CGRectMake(0, 0, messageFrame.belowBtnContentF.size.width, messageFrame.belowBtnContentF.size.height);
//            CGRect voiceRect = CGRectMake(rect.size.width - 20 - 15, rect.size.height - 20 - 2, 20, 20);
//            self.voiceImgView = [[UIImageView alloc]initWithFrame:voiceRect];
//            self.voiceImgView.image = [UIImage imageNamed:@"chat_animation_white3"];
//            self.voiceImgView.animationImages = [NSArray arrayWithObjects:
//                                                 [UIImage imageNamed:@"chat_animation_white1"],
//                                                 [UIImage imageNamed:@"chat_animation_white2"],
//                                                 [UIImage imageNamed:@"chat_animation_white3"],nil];
//            self.voiceImgView.animationDuration = 1;
//            self.voiceImgView.animationRepeatCount = 0;
//            [self.belowBtnContent addSubview: _voiceImgView];
//        }

        
    }else{
        self.upBtnContent.isMyMessage = NO;
        [self.belowBtnContent setTitleColor:[UIColor colorFromRGB:0x09bb07] forState:UIControlStateNormal];
        self.belowBtnContent.contentEdgeInsets = UIEdgeInsetsMake(0, ChatContentLeft, ChatContentBottom, ChatContentRight);
        
//        if (self.voiceImgView == nil) {
//            //添加小喇叭
//            CGRect rect = CGRectMake(0, 0, messageFrame.belowBtnContentF.size.width, messageFrame.belowBtnContentF.size.height);
//            CGRect voiceRect = CGRectMake(rect.size.width - 20 - 15, rect.size.height - 20 - 2, 20, 20);
//            self.voiceImgView = [[UIImageView alloc]initWithFrame:voiceRect];
//            
//            self.voiceImgView.image = [UIImage imageNamed:@"chat_animation3"];
//            self.voiceImgView.animationImages = [NSArray arrayWithObjects:
//                                                 [UIImage imageNamed:@"chat_animation1"],
//                                                 [UIImage imageNamed:@"chat_animation2"],
//                                                 [UIImage imageNamed:@"chat_animation3"],nil];
//            self.voiceImgView.animationDuration = 1;
//            self.voiceImgView.animationRepeatCount = 0;
//            [self.belowBtnContent addSubview: _voiceImgView];
//            
//        }

    }

    
    
    
    switch (message.type) {
        case UUMessageTypeText:
            [self.upBtnContent setTitle:message.strContent forState:UIControlStateNormal];
            [self.belowBtnContent setTitle:message.belowBtnStrContent forState:UIControlStateNormal];
            break;
        case UUMessageTypePicture:
        {
            self.upBtnContent.backImageView.hidden = NO;
            self.upBtnContent.backImageView.image = message.picture;
            self.upBtnContent.backImageView.frame = CGRectMake(0, 0, self.upBtnContent.frame.size.width, self.upBtnContent.frame.size.height);
            [self makeMaskView:self.upBtnContent.backImageView withImage:normal];
        }
            break;
        case UUMessageTypeVoice:
        {
            self.upBtnContent.voiceBackView.hidden = NO;
            self.upBtnContent.second.text = [NSString stringWithFormat:@"%@'s Voice",message.strVoiceTime];
            songData = message.voice;
        }
            break;
            
        default:
            break;
    }
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


-(void)onCompleted:(IFlySpeechError *)error {
    
}

@end



