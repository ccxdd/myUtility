//
//  NSArray+DDNSArray.h
//  WenStore
//
//  Created by ccxdd on 14-6-22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DDNSArray)

- (id)atIndex:(NSUInteger)index;

/**
 *  返回Key所存在的Arr
 *
 *  @param key    数组中的Key值
 *  @param object 用来比较数组
 *
 *  @return NSArray
 */
- (instancetype)filterKey:(NSString *)key equal:(id)object;

/**
 *  返回Key所不存在的Arr
 *
 *  @param key    数组中的Key值
 *  @param object 用来比较数组
 *
 *  @return NSArray
 */
- (instancetype)filterKey:(NSString *)key notEqual:(id)object;

/**
 *  返回数组里所指定的Key的所有值
 *
 *  @param key 数组中的Key
 *
 *  @return NSArray
 */
- (instancetype)allValuesForKey:(NSString *)key;

/**
 *  查询数组中是否包含指定的值
 *
 *  @param key        字典中的键
 *  @param value      键所对应的值
 *  @param completion NSArray
 */
- (void)searchKey:(NSString *)key value:(NSString *)value completion:(void(^)(NSArray *resultArr))completion;

/**
 *  返回JSON字符串
 *
 *  @return NSString
 */
- (NSString *)JSONString;

@end
