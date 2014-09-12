//
//  UIScrollView+DD.m
//  ZH_xinxin
//
//  Created by dd on 14-8-11.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "UIScrollView+DD.h"
#import "UIScrollView+Extension.h"

@implementation UIScrollView (DD)


- (void)contentHeightToFit:(UIViewController *)vc
{
    BOOL root = [vc.navigationController.viewControllers count] == 1;
    [self contentHeightToFit:vc tabbar:root offset:0];
}

- (void)contentHeightToFit:(UIViewController *)vc offset:(CGFloat)offset
{
    BOOL root = [vc.navigationController.viewControllers count] == 1;
    [self contentHeightToFit:vc tabbar:root offset:offset];
}

- (void)contentHeightToFit:(UIViewController *)vc tabbar:(BOOL)tabBar offset:(CGFloat)offset
{
    CGFloat bottom = [self contentBottom];
    CGPoint screentPoint = [self convertPoint:CGPointMake(0, bottom) toView:nil];
    CGFloat tabBarH = 0;
    
    if (vc.tabBarController) {
        tabBarH = tabBar ? 49 : (IOS7_OR_LATER ? -49 : 0);
    }
    
    self.contentSizeHeight = screentPoint.y + tabBarH + self.contentOffset.y + offset;
}

- (CGFloat)contentBottom
{
    __block CGFloat bottom = 0;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view;
        if ([obj isKindOfClass:[UIView class]]) {
            view = (UIView *)obj;
            if ([view y2] > bottom && [view width] > 7 && [view height] > 7) {
                bottom = [obj y2];
            }
        }
    }];
    
    return bottom;
}

@end
