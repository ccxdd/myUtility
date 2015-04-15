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
        NSLog(@"\n Execption: index = %@", @(index));
        return nil;
    }
}

- (instancetype)filterKey:(NSString *)key equal:(id)object
{
    if (object) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", key, object];
        return [self filteredArrayUsingPredicate:predicate];
    }
    
    return nil;
}

- (instancetype)filterKey:(NSString *)key notEqual:(id)object
{
    NSMutableArray *mArray = [self mutableCopy];
    [mArray removeObjectsInArray:[self filterKey:key equal:object]];
    return mArray;
}

- (instancetype)allValuesForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    
    NSMutableArray *marr = [self valueForKeyPath:key];
    
    return marr;
}

- (void)searchObject:(id)object completion:(void(^)(NSUInteger index))completion
{
    if (object && completion) {
        completion([self indexOfObject:object]);
    }
}

- (void)searchKey:(NSString *)key value:(NSString *)value completion:(void(^)(NSArray *resultArr))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", key, value];
    NSArray *resultArr = [self filteredArrayUsingPredicate:predicate];
    if (completion) {
        completion(resultArr);
    }
}

- (NSString *)JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"%@", jsonString];
    } else {
        DLogError(@"NSArray to JSONString Error! error = %@", error);
        return nil;
    }
}

@end
