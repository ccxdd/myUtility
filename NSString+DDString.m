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

- (NSString *)addString:(NSString *)appendString
{
    return [NSString stringWithFormat:@"%@%@", self, appendString];
}

- (NSString *)filterToNumberString
{
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
}

- (void)toPasteboard
{
    [[UIPasteboard generalPasteboard] setString:self];
}

@end
