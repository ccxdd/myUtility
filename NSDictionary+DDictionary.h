//
//  NSDictionary+DDictionary.h
//  Trafish
//
//  Created by ccxdd on 13-11-23.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DDictionary)

- (NSString *)JSONString;

- (NSData *)JsonUTF8Data;

/**
 *  过滤字典数据
 *
 *  @param keys 键
 *  @param non  是否取反
 *
 *  @return 字典
 */
- (instancetype)existKeys:(NSArray *)keys non:(BOOL)non;

- (instancetype)valueToNSNumber;

@end
