//
//  UIView+DDView.h
//  WenStore
//
//  Created by ccxdd on 14-6-5.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDView)

- (void)setX:(CGFloat)x y:(CGFloat)y;

- (void)setWidth:(CGFloat)width height:(CGFloat)height;

- (void)setCornerRadius:(CGFloat)radius;

- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)width;

@end
