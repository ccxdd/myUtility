//
//  NSString+DDString.h
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-29.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DDString)

+ (NSString *)versionString;

+ (NSString *)buildString;

+ (NSString *)fromInt:(NSInteger)intValue;

- (NSURL *)toURL;

- (NSURLRequest *)toRequest;

- (id)toJSON;

- (NSData *)toData;

- (NSString *)addPrefix:(NSString *)string;

- (NSString *)addSuffix:(NSString *)string;

- (NSString *)delString:(NSString *)string;

- (NSString *)insert:(NSString *)string index:(NSUInteger)index;

- (NSString *)replaceFrom:(NSUInteger)from to:(NSUInteger)to with:(NSString *)string;

- (NSString *)filterToNumberString;

- (void)toPasteboard;

- (BOOL)inArray:(NSArray *)arr;

- (void)inArray:(NSArray *)arr
            key:(NSString *)key
     completion:(void(^)(NSInteger index))completion;

+ (NSString *)documentPath;

+ (NSString *)tempPath;

- (BOOL)isExistFile;

- (BOOL)deleteFile;

- (NSString *)stringToIndex:(NSUInteger)to;

- (NSString *)stringFromIndex:(NSUInteger)from;

- (NSString *)thousandSeparator:(BOOL)decimal;

- (NSNumber *)toNSNumber;

@end
