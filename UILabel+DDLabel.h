//
//  UILabel+DDLabel.h
//  WenStore
//
//  Created by ccxdd on 14-7-17.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DDLabel)

/**
 *  富文本
 *
 *  @param text  要改变的字符
 *  @param color 颜色
 *  @param font  字体
 *  @param range 范围
 */
- (void)attribText:(NSString *)text color:(UIColor *)color font:(UIFont *)font range:(NSRange)range;

/**
 *  指定要富文本字符串
 *
 *  @param text  要改变的字符
 *  @param color 颜色
 *  @param font  字体
 */
- (void)attribFindText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

/**
 *  添加下划线
 *
 *  @param text 要改变的字符
 */
- (void)attribUnderLineText:(NSString *)text;

- (void)textPrefix:(NSString *)string;

- (void)textSuffix:(NSString *)string;

@end
