//
//  UIView+DDView.h
//  WenStore
//
//  Created by ccxdd on 14-6-5.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDView)

- (CGFloat)x1;

- (CGFloat)x2;

- (CGFloat)y1;

- (CGFloat)y2;

- (CGFloat)midX;

- (CGFloat)midY;

- (CGFloat)width;

- (CGFloat)height;

- (void)setX:(CGFloat)x;

- (void)setY:(CGFloat)y;

- (void)setX:(CGFloat)x y:(CGFloat)y;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setWidth:(CGFloat)width height:(CGFloat)height;

- (void)setCornerRadius:(CGFloat)radius;

- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)width;

@end
