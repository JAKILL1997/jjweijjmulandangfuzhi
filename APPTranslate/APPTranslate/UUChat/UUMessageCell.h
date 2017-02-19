//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
@class UUMessageFrame;
@class UUMessageCell;

@protocol UUMessageCellDelegate <NSObject>
@optional
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId;
- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage;
@end


@interface UUMessageCell : UITableViewCell

@property (nonatomic, retain)UILabel *labelTime;
@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIButton *btnHeadImage;

@property (nonatomic, retain)UUMessageContentButton *upBtnContent;
@property (nonatomic, retain)UUMessageContentButton *belowBtnContent;

@property (nonatomic, retain)UUMessageFrame *messageFrame;
@property (nonatomic, assign)id<UUMessageCellDelegate>delegate;


@property (nonatomic, copy)NSString *upText;
@property (nonatomic, copy)NSString *belowText;

@property (nonatomic, copy) NSString *upBtnLanguage;
@property (nonatomic, copy) NSString *upBtnAccent;
@property (nonatomic, copy) NSString *belowBtnLanguage;
@property (nonatomic, copy) NSString *belowBtnAccent;


@property (nonatomic, strong) UIImageView *voiceImgView;


@end

