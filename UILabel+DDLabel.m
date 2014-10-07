//
//  UILabel+DDLabel.m
//  WenStore
//
//  Created by ccxdd on 14-7-17.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "UILabel+DDLabel.h"

@implementation UILabel (DDLabel)

/**
 *  富文本
 *
 *  @param text  要改变的字符
 *  @param color 颜色
 *  @param font  字体
 *  @param range 范围
 */
- (void)attribText:(NSString *)text color:(UIColor *)color font:(UIFont *)font range:(NSRange)range
{
    NSString *attribText = text ? text : self.text;
    UIColor *attribColor = color ? color : self.textColor;
    NSRange attribRange  = NSEqualRanges(range, NSMakeRange(0, 0)) ? NSMakeRange(0, attribText.length) : range;
    UIFont *attribFont   = font ? font : self.font;
    
    NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:attribText];
    
    [attribString addAttributes:@{
                                  NSForegroundColorAttributeName : attribColor,
                                  NSFontAttributeName : attribFont
                                  }
                          range:attribRange];
    
    self.attributedText = attribString;
}

/**
 *  指定要富文本字符串
 *
 *  @param text  要改变的字符
 *  @param color 颜色
 *  @param font  字体
 */
- (void)attribFindText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    NSRange findRange = [self.text rangeOfString:text];
    
    if (findRange.length > 0) {
        [self attribText:self.text color:color font:font range:findRange];
    }
}

/**
 *  添加下划线
 *
 *  @param text 要改变的字符
 */
- (void)attribUnderLineText:(NSString *)text
{
    NSString *attribText = text ? text : self.text;
    
    NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:attribText];
    
    [attribString addAttributes:@{
                                  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                                  }
                          range:NSMakeRange(0, attribText.length)];
    
    self.attributedText = attribString;
}

- (void)textPrefix:(NSString *)string
{
    self.text = [self.text addPrefix:string];
}

- (void)textSuffix:(NSString *)string
{
    self.text = [self.text addSuffix:string];
}

- (void)thousandSeparator:(BOOL)decimal
{
    self.text = [self.text thousandSeparator:decimal];
}

@end
