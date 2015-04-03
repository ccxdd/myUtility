//
//  NSNumber+DD.m
//  ZH_iOS
//
//  Created by ccxdd on 15/4/3.
//  Copyright (c) 2015年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "NSNumber+DD.h"

@implementation NSNumber (DD)

- (NSDecimalNumber *)toDecimalNumber
{
    return [[NSDecimalNumber alloc] initWithDouble:self.doubleValue];
}

- (NSDecimalNumber *)roundDownWithScale:(NSInteger)scale
{
    NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                               scale:scale
                                                                                    raiseOnExactness:NO
                                                                                     raiseOnOverflow:NO
                                                                                    raiseOnUnderflow:NO
                                                                                 raiseOnDivideByZero:NO];
    return [[self toDecimalNumber] decimalNumberByRoundingAccordingToBehavior:roundDown];
}

@end
