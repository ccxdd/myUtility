//
//  GlassTextField.m
//  WenStore
//
//  Created by ccxdd on 14/10/9.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "GlassTextField.h"

@implementation GlassTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configGlassField];
}

- (void)configGlassField
{
    self.backgroundColor = kGlassTextField;
    self.textColor = [UIColor blackColor];
    //[self setValue:kNavigationBarColor forKeyPath:@"_placeholderLabel.textColor"];
}

@end
