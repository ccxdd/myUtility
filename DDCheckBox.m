//
//  DDCheckBox
//  NTSCar
//
//  Created by ccxdd on 13-4-23.
//  Copyright (c) 2013年 Heidi. All rights reserved.
//

#import "DDCheckBox.h"

#define dBgUnSelName     @"checkbox_off"
#define dBgSelName       @"checkbox_on"

@interface DDCheckBox ()

@end

@implementation DDCheckBox

- (void)awakeFromNib
{
    [self configCheckBox];
}

+ (instancetype)checkBoxWithFrame:(CGRect)frame title:(NSString *)title checked:(BOOL)checked
{
    DDCheckBox *checkBox = [super buttonWithType:UIButtonTypeCustom];
    [checkBox setFrame:frame];
    [checkBox setTitle:title forState:UIControlStateNormal];
    [checkBox setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [checkBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkBox addTarget:checkBox action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [checkBox setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [checkBox setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [checkBox setChecked:checked];
    
    return checkBox;
}

- (void)clickAction
{
    self.checked = !self.checked;
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

- (void)configCheckBox
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
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
