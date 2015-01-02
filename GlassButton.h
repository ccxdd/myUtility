//
//  GlassButton.h
//  WenStore
//
//  Created by ccxdd on 14/10/5.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlassButton : UIButton

@property (nonatomic, copy  ) NSString *colorStyle;
@property (nonatomic, strong) UIColor  *borderColor;
@property (nonatomic, assign) CGFloat  radius;
@property (nonatomic, assign) CGFloat  borderWidth;

+ (instancetype)buttonWithStyle:(NSString *)style frame:(CGRect)frame;

- (void)setTitleColor:(UIColor *)titleColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
