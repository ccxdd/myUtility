//
//  TWTMainViewController.m
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "TWTMainViewController.h"
#import "TWTSideMenuViewController.h"
#import "DDPageCV.h"
#import "ScienceDietViewController.h"
#import "BeautyDishViewController.h"
#import "MyFavoriteViewController.h"
#import "MyInfoViewController.h"
#import "ChangePasswordViewController.h"
#import "LoginViewController.h"
#import "MyScoreViewController.h"
#import "BeautyCell.h"
#import <QuartzCore/QuartzCore.h>

@interface TWTMainViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tableData;
}

@property (nonatomic, strong) DDPageCV *pageCV;

@end

@implementation TWTMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self interface_queryADList];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"天鲜配";
    self.view.backgroundColor = [UIColor grayColor];
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(slideNotification:)
                                                 name:@"slideNotification"
                                               object:nil];
    
    [self leftButtonWithImageName:@"more" clickBlock:^(id object) {
        [self.sideMenuViewController openMenuAnimated:YES completion:nil];
    }];
    
    _pageCV = [[DDPageCV alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    _pageCV.imageData = @[@"main_bg.jpg", @"main_bg.jpg", @"main_bg.jpg", @"main_bg.jpg", @"main_bg.jpg", @"main_bg.jpg"];
    [self.view addSubview:_pageCV];
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, kORIGIN_Y(_pageCV), 320, 75)];
    buttonsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonsView];
    
    NSArray *itemsArr = @[@"科学饮食", @"美食菜谱", @"今日推荐", @"今日特价"];
    NSArray *colorArr = @[kUIColorRGB(255, 156, 0), kUIColorRGB(255, 84, 9), kUIColorRGB(177, 186, 0), kUIColorRGB(55, 151, 6)];
    float width = 60, height = 60, x = 17, y = 7.5 /*tag = dControlTag*/;
    float hgap = 15;
    
    for (int i = 0; i < itemsArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:itemsArr[i] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(x, y, width, height)];
        [btn addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.titleEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 0);
        btn.layer.cornerRadius = 6;
        btn.backgroundColor = colorArr[i];
        btn.tag = i+1;
        [buttonsView addSubview:btn];
        
        x += width + hgap;
        
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kORIGIN_Y(buttonsView), 320, kVIEW_HEIGHT-kORIGIN_Y(buttonsView)-49)
                                                          style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setRowHeight:RecommendCell_HEIGHT];
    [self.view addSubview:tableView];
    
    
    
}

#pragma mark - TableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;//[tableData count];
}

- (RecommendCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecommendCell";
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setCellWthDict:tableData[indexPath.row]];
    
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.6];
    } else {
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - buttonsAction

- (void)buttonsAction:(UIButton *)sender
{
    switch ([sender tag]) {
        case 1: //
        {
            ScienceDietViewController *scienceVC = [[ScienceDietViewController alloc] init];
            [self.navigationController pushViewController:scienceVC animated:YES];
        }
            break;
        case 2: //
        {
            BeautyDishViewController *beautyVC = [[BeautyDishViewController alloc] init];
            [self.navigationController pushViewController:beautyVC animated:YES];
        }
            break;
        case 3: //
        {
        }
            break;
        case 4: //
        {
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - slideNotification

- (void)slideNotification:(NSNotification *)sender
{
    NSIndexPath *indexPath = [sender object];
    switch (indexPath.row) {
        case 0: //我的资料
        {
            MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] init];
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
            break;
        case 2: //我的积分
        {
            MyScoreViewController *scoreVC = [[MyScoreViewController alloc] init];
            [self.navigationController pushViewController:scoreVC animated:YES];
        }
            break;
        case 4: //我的收藏
        {
            MyFavoriteViewController *favoriteVC = [[MyFavoriteViewController alloc] init];
            [self.navigationController pushViewController:favoriteVC animated:YES];
        }
            break;
        case 5: //修改密码
        {
            ChangePasswordViewController *changeVC = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:changeVC animated:YES];
        }
            break;
        case 6: //注销
        {
            LoginViewController *regVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:regVC animated:YES];
            
            [BMWaitVC showActionSheet:@"是否注销本帐号" buttonTitles:@[@"确定"]
                              keyName:nil
                           alertBlock:^(NSInteger buttonIndex) {
                               
                               if (buttonIndex == 0) {
                                   //注销
                               }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - interface_queryADList

- (void)interface_queryADList
{
    [[HttpClient sharedClient] queryADListWithSuccessBlock:^(id responseObject) {
        
    } failureBlock:^(id responseObject) {
        
    }];
}

#pragma mark - interface_queryRecommendList

- (void)interface_queryRecommendList
{
    [[HttpClient sharedClient] queryRecommendListWithSuccessBlock:^(id responseObject) {
        
    } failureBlock:^(id responseObject) {
        
    }];
}


@end
