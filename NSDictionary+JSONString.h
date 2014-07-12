//
//  NSDictionary+JSONString.h
//  Trafish
//
//  Created by ccxdd on 13-11-23.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONString)

- (NSString *)JSONString;

- (NSData *)JsonUTF8Data;

/**
 *  过滤字典数据
 *
 *  @param keys 键
 *  @param non  非
 *
 *  @return 字典
 */
- (instancetype)filterWithKeys:(NSArray *)keys non:(BOOL)non;

@end
