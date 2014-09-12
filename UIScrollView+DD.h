//
//  UIScrollView+DD.h
//  ZH_xinxin
//
//  Created by dd on 14-8-11.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DD)

- (CGFloat)contentBottom;

- (void)contentHeightToFit:(UIViewController *)vc;

- (void)contentHeightToFit:(UIViewController *)vc offset:(CGFloat)offset;

- (void)contentHeightToFit:(UIViewController *)vc tabbar:(BOOL)tabBar offset:(CGFloat)offset;

@end
