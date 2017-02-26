//
//  ViewController.m
//  APPTranslate
//
//  Created by 王丹 on 15-5-13.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "ViewController.h"
#import "JKAdManager.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UUMessageCellDelegate>


@end

@implementation ViewController


#pragma mark - 试图生命周期

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initRecordView];
}





-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

-(void)initSelfView {
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)initRecordView {
    _holdView = [[ButtonHoldView alloc] init];
    [self.view addSubview: _holdView];
    _holdView.alpha = 1;
    _holdViewIsShow = YES;//处于显示状态
}


-(void)initTableView {
    _oldContentOffsetY = 0.0f;
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 120);//减去底下录音button
    _tbView = [[UITableView alloc] initWithFrame:rect];
    [self.view addSubview: _tbView];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.tag = 1024;
    
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _listenSorce = [ListeDataSource sharedInstance];
    [_listenSorce dataAppendDic:[_listenSorce fixedSelfDic]];
    [_listenSorce dataAppendDic:[_listenSorce fixedOtherDic]];
    
    [self.tbView reloadData];
    [self tableViewScrollToBottom];
}


-(void)tableViewScrollToBottom {
    if (self.listenSorce.cellMessageFrameArray.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.listenSorce.cellMessageFrameArray.count-1 inSection:0];
    [self.tbView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - taleView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listenSorce.cellMessageFrameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }

    [cell setMessageFrame:self.listenSorce.cellMessageFrameArray[indexPath.row]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.listenSorce.cellMessageFrameArray[indexPath.row] cellHeight];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma mark - tablviewCell delegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId {
    NSLog(@"head being clicked");
}

- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage {
    NSLog(@"content being clicked");
}

@end
