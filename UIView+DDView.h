//
//  UIView+DDView.h
//  WenStore
//
//  Created by ccxdd on 14-6-5.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DDView)

/**
 *  返回x1
 *
 *  @return CGFloat
 */
- (CGFloat)x1;

/**
 *  返回x2
 *
 *  @return CGFloat
 */
- (CGFloat)x2;

/**
 *  返回y1
 *
 *  @return CGFloat
 */
- (CGFloat)y1;

/**
 *  返回y2
 *
 *  @return CGFloat
 */
- (CGFloat)y2;

/**
 *  返回x的居中值
 *
 *  @return CGFloat
 */
- (CGFloat)midX;

/**
 *  返回y的居中值
 *
 *  @return CGFloat
 */
- (CGFloat)midY;

/**
 *  返回宽度
 *
 *  @return CGFloat
 */
- (CGFloat)width;

/**
 *  返回高度
 *
 *  @return CGFloat
 */
- (CGFloat)height;

- (void)setX:(CGFloat)x;

- (void)setY:(CGFloat)y;

- (void)setX:(CGFloat)x y:(CGFloat)y;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setWidth:(CGFloat)width height:(CGFloat)height;

/**
 *  设置边角半径
 *
 *  @param radius 半径
 */
- (void)setCornerRadius:(CGFloat)radius;

/**
 *   设置边框颜色和边框宽度
 *
 *  @param borderColor 边框颜色
 *  @param width       线条宽度
 */
- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)width;

@end
