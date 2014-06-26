//
//  DDRadioBox.m
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-26.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "DDRadioBox.h"

#define dBgUnSelName     @"radio_unselected"
#define dBgSelName       @"radio_selected"

@interface DDRadioBox ()

@end

@implementation DDRadioBox

- (void)awakeFromNib
{
    [self configRadioBox];
}

+ (instancetype)radioBoxWithFrame:(CGRect)frame title:(NSString *)title checked:(BOOL)checked
{
    DDRadioBox *radioBox = [super buttonWithType:UIButtonTypeCustom];
    [radioBox setFrame:frame];
    [radioBox setTitle:title forState:UIControlStateNormal];
    [radioBox setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [radioBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [radioBox addTarget:radioBox action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [radioBox setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [radioBox setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [radioBox setChecked:checked];
    
    return radioBox;
}

- (void)clickAction:(DDRadioBox *)sender
{
    if (!sender.checked) {
        self.checked = YES;
        
        UIView *superView = [self superview];
        [superView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[DDRadioBox class]] && obj != self) {
                [obj setChecked:NO];
            }
        }];
    }
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if (_checked) {
        [self setImage:[UIImage imageNamed:dBgSelName] forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:[UIImage imageNamed:dBgUnSelName] forState:UIControlStateNormal];
    }
}

#pragma mark - configCheckBox

- (void)configRadioBox
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setChecked:self.checked];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
