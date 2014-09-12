//
//  UIView+DDView.h
//  WenStore
//
//  Created by ccxdd on 14-6-5.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, UIViewAlignPosition) {
    UIViewAlignPositionTop,
    UIViewAlignPositionLeft,
    UIViewAlignPositionBottom,
    UIViewAlignPositionRight,
    UIViewAlignPositionCenter,
    UIViewAlignPositionHorizontalCenter,
    UIViewAlignPositionVerticalCenter,
};


@interface UIView (DDView)

@property (nonatomic, assign          ) CGFloat x;
@property (nonatomic, assign          ) CGFloat y;
@property (nonatomic, assign          ) CGFloat width;
@property (nonatomic, assign          ) CGFloat height;
@property (nonatomic, assign          ) CGPoint origin;
@property (nonatomic, assign          ) CGSize  size;
@property (nonatomic, assign, readonly) CGFloat x1;
@property (nonatomic, assign, readonly) CGFloat y1;

/**
 *  返回Xib中首个View
 *
 *  @return view
 */
+ (id)viewForXibName:(NSString *)xibName;

/**
 *  返回Xib中指定的索引View
 *
 *  @return view
 */
+ (id)viewForXibName:(NSString *)xibName atIndex:(NSInteger)index;

/**
 *  通用Frame
 *
 *  @param top    到top距离
 *  @param left   到left距离
 *  @param bottom 到bottom距离
 *  @param right  到right距离
 *
 *  @return CGRect
 */
+ (CGRect)commonFrameTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

/**
 *  截取屏幕
 *
 *  @return UIImage
 */
+ (UIImage *)screenCapture;

/**
 *  保存屏幕截图到相册
 */
+ (void)saveScreenToAlbum;

/**
 *  返回x2
 *
 *  @return CGFloat
 */
- (CGFloat)x2;

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

- (void)setX:(CGFloat)x animated:(BOOL)animated;
- (void)setX:(CGFloat)x animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setY:(CGFloat)y animated:(BOOL)animated;
- (void)setY:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setX:(CGFloat)x y:(CGFloat)y;
- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated;
- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setWidth:(CGFloat)width animated:(BOOL)animated;
- (void)setWidth:(CGFloat)width animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setHeight:(CGFloat)height animated:(BOOL)animated;
- (void)setHeight:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setWidth:(CGFloat)width height:(CGFloat)height;
- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated;
- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration;

- (void)setAlpha:(CGFloat)alpha duration:(NSTimeInterval)duration;

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

/**
 *  对齐
 *
 *  @param position 对齐方位
 *  @param offset   偏移量
 */
- (void)alignPostiion:(UIViewAlignPosition)position offset:(CGFloat)offset;

- (void)alignPostiion:(UIViewAlignPosition)position offset:(CGFloat)offset
             animated:(BOOL)animated;

- (void)alignPostiion:(UIViewAlignPosition)position offset:(CGFloat)offset
             animated:(BOOL)animated duration:(NSTimeInterval)duration;

/**
 *  画线
 */
+ (void)lineWithRect:(CGRect)frame color:(UIColor *)color toView:(UIView *)view;

/**
 *  画线
 */
+ (UIView *)lineWithRect:(CGRect)frame color:(UIColor *)color;

/**
 *  截取当前View图像
 *
 *  @return UIImage
 */
- (UIImage *)captureView;

/**
 *  保存View截图到相册
 */
- (void)saveCaptureToAlbum;

- (CGPoint)toWindowPoint;

@end
