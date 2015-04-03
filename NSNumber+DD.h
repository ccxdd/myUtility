//
//  NSNumber+DD.h
//  ZH_iOS
//
//  Created by ccxdd on 15/4/3.
//  Copyright (c) 2015年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (DD)

- (NSDecimalNumber *)toDecimalNumber;

- (NSDecimalNumber *)roundDownWithScale:(NSInteger)scale;

@end
