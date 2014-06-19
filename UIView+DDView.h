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
- (void)setX:(CGFloat)x animated:(BOOL)animated;
- (void)setX:(CGFloat)x animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setY:(CGFloat)y;
- (void)setY:(CGFloat)y animated:(BOOL)animated;
- (void)setY:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setX:(CGFloat)x y:(CGFloat)y;
- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated;
- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setWidth:(CGFloat)width;
- (void)setWidth:(CGFloat)width animated:(BOOL)animated;
- (void)setWidth:(CGFloat)width animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setHeight:(CGFloat)height;
- (void)setHeight:(CGFloat)height animated:(BOOL)animated;
- (void)setHeight:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setWidth:(CGFloat)width height:(CGFloat)height;
- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated;
- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setFrame:(CGRect)frame animated:(BOOL)animated duration:(NSTimeInterval)duration;

/**
 *  设置边角半径
 *
 *  @param radius 半径
 */
- (void)setCornerRadius:(CGFloat)radius;

/**
 *  设置边角半径、边框颜色及边框宽度
 *
 *  @param radius      半径
 *  @param borderColor 边框颜色
 *  @param width       线条宽度
 */
- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor width:(CGFloat)width;

/**
 *   设置边框颜色和边框宽度
 *
 *  @param borderColor 边框颜色
 *  @param width       线条宽度
 */
- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)width;

/**
 *  设置阴影
 *
 *  @param x       x偏移量
 *  @param y       y偏移量
 *  @param color   阴影颜色
 *  @param opacity 透明度
 *  @param radius  阴影半径
 *  @param usePath 使用阴影路径
 */
- (void)setShadowX:(CGFloat)x y:(CGFloat)y color:(UIColor *)color opacity:(float)opacity radius:(CGFloat)radius
           usePath:(BOOL)usePath;

@end
