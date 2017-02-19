//
//  JKMenuViewController.m
//  APPTranslate
//
//  Created by wangdan on 15/5/16.
//  Copyright (c) 2015年 王丹. All rights reserved.
//

#import "JKMenuViewController.h"
#import "TTSConfigViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "JKRootNavigationController.h"
#import "AboutUSViewController.h"

@interface JKMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tbView;

@property (nonatomic, strong) NSArray *itemArray;

@end


@implementation JKMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSoruce];
    [self initView];

    // Do any additional setup after loading the view.
}

-(void)initView {
    [self.view setBackgroundColor:[UIColor clearColor]];
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, self.view.frame.size.height-200)];
    _tbView.backgroundColor = [UIColor clearColor];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.scrollEnabled = YES;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tbView];
}

-(void)initDataSoruce {
    _itemArray = @[@"播放设置",@"识别设置",@"关于我们"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LevelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = [_itemArray objectAtIndex:indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:@"0.png"];
    
    cell.textLabel.text = [_itemArray objectAtIndex:indexPath.row];
    NSLog(@"row is %ld",(long)indexPath.row);
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tbView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        TTSConfigViewController *vc = [[TTSConfigViewController alloc] init];
        vc.title = @"播放设置";
        JKRootNavigationController *navi = (JKRootNavigationController *)[[self mm_drawerController] centerViewController];
        [navi pushViewController:vc animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        
    }else if (indexPath.row == 2) {
        AboutUSViewController *vc = [[AboutUSViewController alloc] init];
        vc.title = @"关于我们";
        JKRootNavigationController *navi = (JKRootNavigationController *)[[self mm_drawerController] centerViewController];
        [navi pushViewController:vc animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        
    }
}

@end
