//
//  NSObject+DDObjc.m
//  WenStore
//
//  Created by ccxdd on 14-7-21.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "NSObject+DDObjc.h"
#import <objc/runtime.h>

@implementation NSObject (DDObjc)

#pragma mark - 返回所有属性名
/**
 *  返回所有属性名
 *
 *  @return 属性列表
 */
- (NSArray *)getPropertyNames
{
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray *propertyArr = [NSMutableArray array];
    
    for (int i = 0; i < propertyCount; i++) {
        
        const char *name = property_getName(properties[i]);
        [propertyArr addObject:[NSString stringWithUTF8String:name]];
    }
    
    return propertyArr;
}

#pragma mark - 返回属性字典
/**
 *  返回属性字典
 *
 *  @return 字典
 */
- (NSMutableDictionary *)getPropertyObjects
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *list = [self getPropertyNames];
    for (NSString *name in list) {
        [dict setValue:[self valueForKey:name] forKey:name];
    }
    
    return dict;
}

#pragma mark - 返回所有属性值
/**
 *  返回所有属性值
 *
 *  @return 字典
 */
- (NSMutableDictionary *)getPropertyValues
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self.getPropertyObjects enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[UILabel class]] ||
            [obj isKindOfClass:[UITextField class]] ||
            [obj isKindOfClass:[UITextView class]])
        {
            [dict setValue:[obj text] forKey:key];
        }
        else if ([obj isKindOfClass:[NSArray class]] ||
                 [obj isKindOfClass:[NSDictionary class]] ||
                 [obj isKindOfClass:[NSString class]] ||
                 [obj isKindOfClass:[NSNumber class]])
        {
            [dict setValue:obj forKey:key];
        }
    }];
    
    return dict;
}

#pragma mark - 设置所有属性值
/**
 *  设置所有属性值
 *
 *  @param values values
 */
- (void)setPropertyValues:(NSDictionary *)propertyObjects
{
    NSMutableDictionary *uiClassDict = self.getPropertyObjects;
    NSMutableDictionary *objcClassDict = [NSMutableDictionary dictionaryWithDictionary:propertyObjects];
    
    [uiClassDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[UILabel class]] ||
            [obj isKindOfClass:[UITextField class]] ||
            [obj isKindOfClass:[UITextView class]])
        {
            [obj setText:[propertyObjects objectForKey:key]];
            [objcClassDict removeObjectForKey:key];
        }
    }];
    
    [objcClassDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        @try {
            [self setValue:[propertyObjects objectForKey:key] forKey:key];
        }
        @catch (NSException *exception) {
            DLogBlue(@"key: %@ not found", key);
        }
    }];
}

@end
