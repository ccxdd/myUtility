//
//  NSObject+DDObjc.h
//  WenStore
//
//  Created by ccxdd on 14-7-21.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DDObjc)

/**
 *  返回所有属性名
 *
 *  @return 属性列表
 */
- (NSArray *)getPropertyNames;

/**
 *  返回属性字典
 *
 *  @return 字典
 */
- (NSMutableDictionary *)getPropertyObjects;

/**
 *  返回所有属性值
 *
 *  @return 字典
 */
- (NSMutableDictionary *)getPropertyValues;

/**
 *  设置所有属性值
 *
 *  @param values values
 */
- (void)setPropertyValues:(NSDictionary *)values;

@end
