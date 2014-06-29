//
//  NSString+DDString.h
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-29.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DDString)

- (NSURL *)toURL;

- (NSURLRequest *)toRequest;

- (id)toJSON;

@end
