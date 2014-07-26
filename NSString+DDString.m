//
//  NSString+DDString.m
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-29.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "NSString+DDString.h"

@implementation NSString (DDString)

+ (NSString *)fromInt:(NSInteger)intValue
{
    return [NSString stringWithFormat:@"%ld", (long)intValue];
}

- (NSURL *)toURL
{
    return [NSURL URLWithString:self];
}

- (NSURLRequest *)toRequest
{
    return [NSURLRequest requestWithURL:[self toURL]];
}

- (id)toJSON
{
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if (!error) {
        return jsonObject;
    }
    
    return nil;
}

- (NSString *)addPrefix:(NSString *)string;
{
    return [NSString stringWithFormat:@"%@%@", string, self];
}

- (NSString *)addSuffix:(NSString *)string
{
    return [NSString stringWithFormat:@"%@%@", self, string];
}

- (NSString *)filterToNumberString
{
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
}

- (void)toPasteboard
{
    [[UIPasteboard generalPasteboard] setString:self];
}

- (BOOL)inArray:(NSArray *)arr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", self];
    NSArray *resultArr = [arr filteredArrayUsingPredicate:predicate];
    
    return [resultArr count] > 0;
}

- (void)inArray:(NSArray *)arr
            key:(NSString *)key
     completion:(void(^)(NSInteger index))completion
{
    __block NSInteger index = -1;
    
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (key) {
            NSString *objValue = [NSString stringWithFormat:@"%@", obj[key]];
            if ([objValue isEqualToString:[NSString stringWithFormat:@"%@", self]]) {
                index = idx;
                *stop = YES;
            }
        } else if ([obj isEqualToString:self]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (completion) {
        completion(index);
    }
}

@end
