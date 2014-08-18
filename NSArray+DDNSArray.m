//
//  NSArray+DDNSArray.m
//  WenStore
//
//  Created by ccxdd on 14-6-22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "NSArray+DDNSArray.h"

@implementation NSArray (DDNSArray)

- (id)atIndex:(NSUInteger)index
{
    if (self.count > index) {
        return self[index];
    } else {
        NSLog(@"\n Execption: index = %d", index);
        return nil;
    }
}

@end
