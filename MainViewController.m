//
//  MainViewController.m
//  DaiGou
//
//  Created by ccxdd on 14-5-13.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "MainViewController.h"
#import "NavVC.h"

#define kTabBar0_Title      @"酷易U"
#define kTabBar1_Title      @"本地"
#define kTabBar2_Title      @"百度云"
#define kTabBar3_Title      @"传输队列"
#define kTabBar4_Title      @"更多"

@interface MainViewController ()

@end

@implementation MainViewController

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (IOS7_OR_LATER) {
//        self.tabBar.barTintColor = kTabBarColor;
//    } else {
//        self.tabBar.backgroundColor = kTabBarColor;
//    }
    self.tabBar.tintColor = kNavBarTintColor;
    
    NavVC *navVC0 = [Utility storyboardName:@"KuyiU" identifier:nil];
    NavVC *navVC1 = [Utility storyboardName:@"Local" identifier:nil];
    NavVC *navVC2 = [Utility storyboardName:@"BaiduCloud" identifier:nil];
    NavVC *navVC3 = [Utility storyboardName:@"Transport" identifier:nil];
    NavVC *navVC4 = [Utility storyboardName:@"More" identifier:nil];
    
    UITabBarItem *item0, *item1, *item2, *item3, *item4;
    
    if (IOS7_OR_LATER) {
        
        item0 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar0_Title, nil)
                                              image:[UIImage imageNamed:@"common_btn_u_normal"]
                                      selectedImage:[UIImage imageNamed:@"common_btn_u_normal"]];
        item1 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar1_Title, nil)
                                              image:[UIImage imageNamed:@"common_btn_local_normal"]
                                      selectedImage:[UIImage imageNamed:@"common_btn_local_normal"]];
        item2 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar2_Title, nil)
                                              image:[UIImage imageNamed:@"common_btn_baiducloud_normal"]
                                      selectedImage:[UIImage imageNamed:@"common_btn_baiducloud_normal"]];
        item3 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar3_Title, nil)
                                              image:[UIImage imageNamed:@"common_btn_transmission_normal"]
                                      selectedImage:[UIImage imageNamed:@"common_btn_transmission_normal"]];
        item4 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar4_Title, nil)
                                              image:[UIImage imageNamed:@"common_btn_more_normal"]
                                      selectedImage:[UIImage imageNamed:@"common_btn_more_normal"]];
    } else {
        item0 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar0_Title, nil) image:nil tag:0];
        [item0 setFinishedSelectedImage:[UIImage imageNamed:@"common_btn_u_normal"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"common_btn_u_normal"]];
        item1 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar1_Title, nil) image:nil tag:0];
        [item1 setFinishedSelectedImage:[UIImage imageNamed:@"common_btn_local_normal"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"common_btn_local_normal"]];
        item2 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar2_Title, nil) image:nil tag:1];
        [item2 setFinishedSelectedImage:[UIImage imageNamed:@"common_btn_baiducloud_normal"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"common_btn_baiducloud_normal"]];
        item3 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar3_Title, nil) image:nil tag:2];
        [item3 setFinishedSelectedImage:[UIImage imageNamed:@"common_btn_transmission_normal"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"common_btn_transmission_normal"]];
        item4 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBar4_Title, nil) image:nil tag:3];
        [item4 setFinishedSelectedImage:[UIImage imageNamed:@"common_btn_more_normal"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"common_btn_more_normal"]];
    }
    
    navVC0.tabBarItem = item0;
    navVC1.tabBarItem = item1;
    navVC2.tabBarItem = item2;
    navVC3.tabBarItem = item3;
    navVC4.tabBarItem = item4;
    self.viewControllers = @[navVC0, navVC1, navVC2, navVC3, navVC4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
