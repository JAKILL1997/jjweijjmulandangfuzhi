//
//  pcmPlayer.h
//  MSCDemo
//
//  Created by wangdan on 14-11-4.
//
//

#import <Foundation/Foundation.h>
#import<AVFoundation/AVFoundation.h>



@protocol PcmPlayerDelegate<NSObject>


#pragma mark- 音频播放相关回调

@optional
//播放音频结束
-(void)onPlayCompleted;

@end

@interface PcmPlayer : NSObject<AVAudioPlayerDelegate>


@property (nonatomic,strong) NSMutableData *pcmData;

/**
 * 初始化播放器，并传入音频的本地路径
 *
 * path   音频pcm文件完整路径
 * sample 音频pcm文件采样率，支持8000和16000两种
 ****/
-(id)initWithFilePath:(NSString *)path sampleRate:(long)sample;


/**
 * 初始化播放器，并传入音频数据
 *
 * data   音频数据
 * sample 音频pcm文件采样率，支持8000和16000两种
 ****/
-(id)initWithData:(NSData *)data sampleRate:(long)sample;


/**
 开始播放
 ****/
- (void)play;



/**
 停止播放
 ****/
- (void)stop;




-(id)initWithAudioData:(NSData*)audioData;

-(id)initWithFilePath:(NSString *)filePath;

/**
 是否在播放状态
 ****/
@property (nonatomic,assign) BOOL isPlaying;

@end
