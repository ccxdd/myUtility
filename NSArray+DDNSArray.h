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
 *  @param key 数组中的Key值
 *  @param arr 用来比较数组
 *
 *  @return NSArray
 */
- (instancetype)filterKey:(NSString *)key equalArray:(NSArray *)arr;

@end
