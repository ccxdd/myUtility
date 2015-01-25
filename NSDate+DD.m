//
//  NSDate+DD.m
//  WenStore
//
//  Created by ccxdd on 15/1/25.
//  Copyright (c) 2015年 ccxdd. All rights reserved.
//

#import "NSDate+DD.h"

@implementation NSDate (DD)

- (NSString *)toString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [df stringFromDate:self];
    
    return str;
}

@end
