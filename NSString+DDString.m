//
//  NSString+DDString.m
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-29.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "NSString+DDString.h"

@implementation NSString (DDString)

+ (NSString *)versionString
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildString
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

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

- (NSData *)toData
{
    return  [self dataUsingEncoding:NSUTF8StringEncoding];
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
    if (self.length > 0) {
        return [NSString stringWithFormat:@"%@%@", string, self];
    }
    
    return @"";
}

- (NSString *)addSuffix:(NSString *)string
{
    if (self.length > 0) {
        return [NSString stringWithFormat:@"%@%@", self, string];
    }
    return @"";
}

- (NSString *)delString:(NSString *)string
{
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
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

+ (NSString *)documentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

- (BOOL)isExistFile
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:self isDirectory:&isDir];
    
    return existed;
}

- (BOOL)deleteFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager removeItemAtPath:self error:nil];
}

- (NSString *)stringToIndex:(NSUInteger)to
{
    if (self.length > to) {
        return [self substringToIndex:to];
    } else {
        return @"";
    }
}

- (NSString *)stringFromIndex:(NSUInteger)from;
{
    if (self.length > from) {
        return [self substringFromIndex:from];
    } else {
        return @"";
    }
}

- (NSString *)insert:(NSString *)string index:(NSUInteger)index
{
    if (self.length > index) {
        return [[[self stringToIndex:index] addSuffix:string] addSuffix:[self stringFromIndex:index]];
    } else {
        return @"";
    }
}

- (NSString *)replaceFrom:(NSUInteger)from to:(NSUInteger)to with:(NSString *)string
{
    if (to > from && self.length > to ) {
        NSString *sub = [self substringWithRange:NSMakeRange(from, to-from)];
        return [self stringByReplacingOccurrencesOfString:sub withString:string];
    } else {
        return @"";
    }
}

- (NSString *)thousandSeparator:(BOOL)decimal
{
    if (self.length > 3) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:decimal?@"###,##0.00":@"###,###"];
        NSString *formattedNumberString = [numberFormatter stringFromNumber:@([self doubleValue])];
        return formattedNumberString;
    } else {
        return self;
    }
}

- (NSNumber *)toNSNumber
{
    return @([self doubleValue]);
}

@end
