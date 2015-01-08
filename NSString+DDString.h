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

- (BOOL)inArray:(NSArray *)arr forKey:(NSString *)key;

- (void)inArray:(NSArray *)arr
            key:(NSString *)key
     completion:(void(^)(NSInteger index))completion;

+ (NSString *)documentPath;

+ (NSString *)tempPath;

- (BOOL)isExistFile;

- (BOOL)deleteFile;

- (NSString *)stringToIndex:(NSUInteger)to;

- (NSString *)stringFromIndex:(NSUInteger)from;

/**
 *  千位分隔
 *
 *  @param decimal 是否保留2位小数
 *
 *  @return NSString
 */
- (NSString *)thousandSeparator:(BOOL)decimal;

- (NSNumber *)toNSNumber;

- (NSString *)yyyymmdd;

- (NSString *)yyyymmdd:(NSString *)separator;

- (NSString *)dateFormat:(NSString *)formatter;

- (BOOL)isNumberic;

- (BOOL)isInteger;

- (BOOL)isDouble;

- (BOOL)isFloat;

- (NSString *)encryptUseSHA1;

+ (NSString *)currentDateTime:(NSInteger)timeType;

+ (NSString *)currentTime:(NSInteger)timeType;

+ (NSString *)currentDate;

+ (NSString *)dateFromTimestamp;

+ (NSString *)dateFromTimestampInterval:(NSTimeInterval)interval;

+ (NSString *)dateFrom13lenTimestamp;

- (BOOL)isValidMobile;

- (BOOL)isValidEmail;

+ (NSString *)generateRandomOfNum:(NSInteger)num;

/**
 *  计算文字高度
 *
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return CGSize
 */
- (CGSize)calcSizeFromFont:(UIFont *)font width:(NSInteger)width;

@end
