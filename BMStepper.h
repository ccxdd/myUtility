//
//  BMStepper.h
//  WanYueHui
//
//  Created by ccxdd on 13-6-1.
//  Copyright (c) 2013年 Zhangcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeValueBlock)(NSInteger value);

@interface BMStepper : UIView
{
    UILabel *titleLab;
    NSInteger value;
}

- (id)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue;

- (id)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue changeValueBlock:(ChangeValueBlock)changeValueBlock;

- (void)setText:(NSString *)str;

- (void)setValue:(NSString *)str;

- (NSInteger)value;

@property (assign) NSInteger maxValue;
@property (assign) NSInteger minValue;

@end
