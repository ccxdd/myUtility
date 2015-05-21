//
//  UIScrollView+DD.m
//  ZH_xinxin
//
//  Created by dd on 14-8-11.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "UIScrollView+DD.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "INSLappsyPullToRefresh.h"
#import "INSLappsyInfiniteIndicator.h"

@implementation UIScrollView (DD)

- (void)setContentInsetTop:(CGFloat)contentInsetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)contentInsetTop
{
    return self.contentInset.top;
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)contentInsetBottom
{
    return self.contentInset.bottom;
}

- (void)setContentInsetLeft:(CGFloat)contentInsetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)contentInsetLeft
{
    return self.contentInset.left;
}

- (void)setContentInsetRight:(CGFloat)contentInsetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)contentInsetRight
{
    return self.contentInset.right;
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)contentOffsetX
{
    return self.contentOffset.x;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)contentOffsetY
{
    return self.contentOffset.y;
}

- (void)setContentSizeWidth:(CGFloat)contentSizeWidth
{
    CGSize size = self.contentSize;
    size.width = contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)contentSizeWidth
{
    return self.contentSize.width;
}

- (void)setContentSizeHeight:(CGFloat)contentSizeHeight
{
    CGSize size = self.contentSize;
    size.height = contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)contentSizeHeight
{
    return self.contentSize.height;
}

- (void)contentHeightToFit:(UIViewController *)vc
{
    [self contentHeightToFit:vc tabbar:(BOOL)vc.tabBarController offset:0];
}

- (void)contentHeightToFit:(UIViewController *)vc offset:(CGFloat)offset
{
    [self contentHeightToFit:vc tabbar:(BOOL)vc.tabBarController offset:offset];
}

- (void)contentHeightToFit:(UIViewController *)vc tabbar:(BOOL)tabBar offset:(CGFloat)offset
{
    CGFloat bottom = [self contentBottom];
    CGPoint screentPoint = [self convertPoint:CGPointMake(0, bottom) toView:nil];
    CGFloat tabBarH = 0;
    
    if (vc.tabBarController) {
        tabBarH = tabBar ? 49 : (iOS7_OR_LATER ? -49 : 0);
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

#pragma mark - 上拉、下拉刷新

- (void)addPullToRefreshWithHandler:(void(^)())handler;
{
    [self ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        if (handler) {
            handler();
        }
    }];
    
    self.ins_pullToRefreshBackgroundView.preserveContentInset = NO;
    
    if (!self.ins_pullToRefreshBackgroundView.delegate) {
        CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
        UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSLappsyPullToRefresh alloc] initWithFrame:defaultFrame];
        self.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
        [self.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
    }
}

- (void)addInfinityScrollWithHandler:(void(^)())handler
{
    [self ins_addInfinityScrollWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        if (handler) {
            handler();
        }
    }];
    
    self.ins_infiniteScrollBackgroundView.preserveContentInset = NO;
    
    if (!self.ins_infiniteScrollBackgroundView.delegate) {
        CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
        UIView <INSAnimatable> *infinityIndicator = [[INSLappsyInfiniteIndicator alloc] initWithFrame:defaultFrame];
        [self.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
        [infinityIndicator startAnimating];
    }
}

- (void)beginPullToRefresh
{
    [self ins_beginPullToRefresh];
}

- (void)endPullToRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ins_endPullToRefresh];
    });
}

- (void)beginInfinityScroll
{
    [self ins_beginInfinityScroll];
}

- (void)endInfinityScroll
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ins_endInfinityScroll];
    });
}

@end
