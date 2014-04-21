//
//  BMStepper.m
//  WanYueHui
//
//  Created by ccxdd on 13-6-1.
//  Copyright (c) 2013年 Zhangcc. All rights reserved.
//

#import "BMStepper.h"

#define dMinusBg                @"-"
#define dPlusBg                 @"+"
#define dMinusBg_HightLight     @"-_activity"
#define dPlusBg_HightLight      @"+_activity"
#define dViewBg                 @"meal_text"

@interface BMStepper ()

@property (copy) ChangeValueBlock changeValueBlock;

@end

@implementation BMStepper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        int width = frame.size.width;
        
        UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
        [plus setFrame:CGRectMake(width-30, 0, 30, 30)];
        [plus setImage:[UIImage imageNamed:dPlusBg] forState:UIControlStateNormal];
        [plus setImage:[UIImage imageNamed:dPlusBg_HightLight] forState:UIControlStateHighlighted];
        [plus addTarget:self action:@selector(plusMinusAction:) forControlEvents:UIControlEventTouchUpInside];
        [plus setTag:54321];
        [self addSubview:plus];
        
        UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
        [minus setImage:[UIImage imageNamed:dMinusBg] forState:UIControlStateNormal];
        [minus setImage:[UIImage imageNamed:dMinusBg_HightLight] forState:UIControlStateHighlighted];
        [minus setFrame:CGRectMake(0, 0, 30, 30)];
        [minus addTarget:self action:@selector(plusMinusAction:) forControlEvents:UIControlEventTouchUpInside];
        [minus setTag:12345];
        [self addSubview:minus];
        
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, width-30*2, 30)];
        [titleLab setFont:[UIFont systemFontOfSize:17]];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setTextColor:[UIColor redColor]];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLab];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:titleLab.frame];
        [iv setImage:[[UIImage imageNamed:dViewBg]resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)]];
        [self insertSubview:iv belowSubview:titleLab];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue
{
    self = [self initWithFrame:frame];
    self.minValue = minValue;
    self.maxValue = maxValue;
    value = minValue;
    
    [titleLab setText:[NSString stringWithFormat:@"%ld", (long)value]];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue changeValueBlock:(ChangeValueBlock)changeValueBlock
{
    self = [self initWithFrame:frame];
    self.minValue = minValue < 0 ? 0 : minValue;
    self.maxValue = maxValue < 0 ? 0 : maxValue;
    self.changeValueBlock = changeValueBlock;
    value = minValue;
    
    [titleLab setText:[NSString stringWithFormat:@"%ld", (long)value]];
    
    return self;
}

- (void)setText:(NSString *)str
{
    value = [str intValue];
    titleLab.text = [NSString stringWithFormat:@"%ld", (long)value];
}

- (void)setValue:(NSString *)str
{
    value = [str intValue];
    titleLab.text = [NSString stringWithFormat:@"%ld", (long)value];
}

- (NSInteger)value
{
    return titleLab.text ? [titleLab.text integerValue] : 0;
}

#pragma mark 加减操作
- (void)plusMinusAction:(id)sender
{
    switch ([sender tag]) {
        case 12345:  //减
        {
            [sender setImage:[UIImage imageNamed:dMinusBg_HightLight] forState:UIControlStateNormal];
            [Utility dispatch_afterDelayTime:.1 block:^{
                [sender setImage:[UIImage imageNamed:dMinusBg] forState:UIControlStateNormal];
            }];
            value <= self.minValue ? value = self.minValue : value--;
        }
            break;
        case 54321:  //加
        {
            [sender setImage:[UIImage imageNamed:dPlusBg_HightLight] forState:UIControlStateNormal];
            [Utility dispatch_afterDelayTime:.1 block:^{
                [sender setImage:[UIImage imageNamed:dPlusBg] forState:UIControlStateNormal];
            }];
            value >= self.maxValue ? value = self.maxValue : value++;
        }
            break;
            
        default:
            break;
    }
    
    titleLab.text = [NSString stringWithFormat:@"%ld", (long)value];
    
    if (self.changeValueBlock) {
        self.changeValueBlock(value);
    }
}

@end
