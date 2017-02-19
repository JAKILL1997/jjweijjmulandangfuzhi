//
//  ViewController.h
//  APPTranslate
//
//  Created by 王丹 on 15-5-13.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordButton.h"
#import "ButtonHoldView.h"
#import "UUInputFunctionView.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "ListeDataSource.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) UITableView *tbView;
@property (strong, nonatomic) ListeDataSource *listenSorce;
@property (strong, nonatomic) ButtonHoldView *holdView;

@property (nonatomic, assign) CGFloat oldContentOffsetY;
@property (nonatomic, assign) BOOL holdViewIsShow;

@end

