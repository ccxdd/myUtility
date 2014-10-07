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

/**
 *  验证VC中的输入项
 *
 *  @param completion 回调
 */
- (void)verifyInputField:(void(^)(BOOL result))completion;

/**
 *  验证View中的输入项
 *
 *  @param view       待验证的View
 *  @param completion 回调
 */
- (void)verifyInputFieldFromView:(UIView *)view completion:(void(^)(BOOL result))completion;

/**
 *  清除内容
 */
- (void)clearPropertyText;

- (void)batchFindObject:(Class)objClass inArray:(NSArray *)arr completion:(void(^)(id arrObj))completion;

@end
