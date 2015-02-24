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
        [self setCornerRadius:self.height/3 borderColor:self.borderColor width:self.borderWidth];
    } else if (self.radius > 0) {
        [self setCornerRadius:self.radius];
    }
    
    if ([self.colorStyle isEqualToString:@"c"]) {
        self.backgroundColor = kClearColor;
    } else if ([self.colorStyle isEqualToString:@"r"]) {
        self.backgroundColor = kGlassRed;
    } else if ([self.colorStyle isEqualToString:@"g"]) {
        self.backgroundColor = kGlassGreen;
    } else if ([self.colorStyle isEqualToString:@"b"]) {
        self.backgroundColor = kGlassBlue;
    }
}

- (void)setTitleColor:(UIColor *)titleColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    self.borderColor = borderColor;
    self.borderWidth = borderWidth;
}

@end
