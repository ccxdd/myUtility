//
//  TWTMenuViewController.m
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "TWTMenuViewController.h"
#import "TWTMainViewController.h"
#import "TWTSideMenuViewController.h"

@interface TWTMenuViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *tableData;
}

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation TWTMenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的主页";
    self.view.backgroundColor = [UIColor grayColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg.jpg"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];

    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    
    tableData = [NSMutableArray arrayWithArray:@[@"我的资料", @"订单", @"我的积分", @"我的地址", @"我的收藏", @"修改密码", @"注销"]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kVIEW_Y, 320, kVIEW_HEIGHT) style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setRowHeight:50];
    [self.view addSubview:tableView];
    
}

#pragma mark - TableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = tableData[indexPath.row];
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
    [self.sideMenuViewController closeMenuAnimated:YES completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"slideNotification" object:indexPath];
    }];
}

- (void)changeButtonPressed
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[TWTMainViewController new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (void)closeButtonPressed
{
    [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
