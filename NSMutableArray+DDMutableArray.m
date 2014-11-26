//
//  NSMutableArray+DDMutableArray.m
//  WenStore
//
//  Created by ccxdd on 14-6-22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "NSMutableArray+DDMutableArray.h"

@implementation NSMutableArray (DDMutableArray)

- (void)addUniqueObject:(id)object
{
    
}

- (void)addSafeObject:(id)object
{
    if (object) {
        [self addObject:object];
    } else {
        NSLog(@"========== addSafeObject ERROR!!! ==========");
    }
}

@end
