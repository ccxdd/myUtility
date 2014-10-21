//
//  GlassButton.m
//  WenStore
//
//  Created by ccxdd on 14/10/5.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "GlassButton.h"

@implementation GlassButton

- (void)awakeFromNib
{
    [self configButton];
}

+ (instancetype)buttonWithStyle:(NSString *)style frame:(CGRect)frame
{
    GlassButton *glassBtn = [GlassButton buttonWithType:UIButtonTypeSystem];
    glassBtn.frame = frame;
    glassBtn.colorStyle = style;
    [glassBtn configButton];
    
    return glassBtn;
}

- (void)configButton
{
    if (self.radius == 0) {
        [self setCornerRadius:self.height/3];
    } else if (self.radius > 0) {
        [self setCornerRadius:self.radius];
    }
    
    if ([self.colorStyle isEqualToString:@"r"]) {
        self.backgroundColor = kGlassRed;
    } else if ([self.colorStyle isEqualToString:@"g"]) {
        self.backgroundColor = kGlassGreen;
    } else {
        self.backgroundColor = kGlassBlue;
    }
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
