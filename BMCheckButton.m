//
//  BMCheckButton.m
//  NTSCar
//
//  Created by ccxdd on 13-4-23.
//  Copyright (c) 2013年 Heidi. All rights reserved.
//

#import "BMCheckButton.h"

#define dBgUnSelName     @"icon_uncheck"
#define dBgSelName       @"icon_checked"

@implementation BMCheckButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:[UIImage imageNamed:dBgUnSelName] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)clickAction
{
    if (self.isChecked) {
        [self setBackgroundImage:[UIImage imageNamed:dBgUnSelName] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:dBgSelName] forState:UIControlStateNormal];
    }

    self.isChecked = !self.isChecked;
}

- (BOOL)isChecked
{
    return isChecked;
}

- (void)setIsChecked:(BOOL)checked
{
    isChecked = checked;
    
    if (isChecked) {
        [self setBackgroundImage:[UIImage imageNamed:dBgSelName] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:dBgUnSelName] forState:UIControlStateNormal];
    }
}

//- (void)dealloc
//{
//    [super dealloc];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
