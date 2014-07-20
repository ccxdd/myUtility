//
//  NSString+DDString.h
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-29.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DDString)

+ (NSString *)fromInt:(NSInteger)intValue;

- (NSURL *)toURL;

- (NSURLRequest *)toRequest;

- (id)toJSON;

- (NSString *)addPrefix:(NSString *)string;

- (NSString *)addSuffix:(NSString *)string;

- (NSString *)filterToNumberString;

- (void)toPasteboard;

@end
