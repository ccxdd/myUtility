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
        NSLog(@"\n NSArray Execption: index = %ld", (long)index);
        return nil;
    }
}

- (instancetype)filterKey:(NSString *)key equalArray:(NSArray *)arr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", key, arr];
    return [self filteredArrayUsingPredicate:predicate];
}

- (void)searchKey:(NSString *)key value:(NSString *)value completion:(void(^)(NSArray *resultArr))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", key, value];
    NSArray *resultArr = [self filteredArrayUsingPredicate:predicate];
    if (completion) {
        completion(resultArr);
    }
}

@end
