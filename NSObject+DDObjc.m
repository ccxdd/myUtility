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

+ (NSString *)dd_className
{
    return NSStringFromClass([self class]);
}

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
    return [self getPropertyValuesEqualKeys:nil non:YES];
}

- (NSMutableDictionary *)getPropertyValuesEqualKeys:(NSArray *)keys non:(BOOL)non
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *uiClassDict = [self.getPropertyObjects existKeys:keys non:non];
    [uiClassDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
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
        else if ([obj isKindOfClass:[UISwitch class]])
        {
            [dict setValue:[obj isOn] ? @"1" : @"0" forKey:key];
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
    if (![propertyObjects isKindOfClass:[NSDictionary class]] || ![propertyObjects count]) {
        return;
    }
    
    NSMutableDictionary *uiClassDict = self.getPropertyObjects;
    
    for (NSString *key in [propertyObjects allKeys]) {
        id obj = uiClassDict[key];
        id propertyValue = propertyObjects[key];
        
        if ([obj isKindOfClass:[UILabel class]] ||
            [obj isKindOfClass:[UITextField class]] ||
            [obj isKindOfClass:[UITextView class]])
        {
            [obj setText:propertyValue];
        }
        else if ([obj isKindOfClass:[UISwitch class]])
        {
            [obj setOn:([propertyValue integerValue] == 1) animated:YES];
        }
        else {
            @try {
                [self setValue:propertyValue forKey:key];
            }
            @catch (NSException *exception) {
                DLogError(@"key: %@ not found class %@", key, NSStringFromClass([obj class]));
            }
        }
    }
}

#pragma mark - 验证输入项 -

/**
 *  验证VC中的输入项
 *
 *  @param completion 回调
 */
- (void)verifyInputField:(void(^)(BOOL result))completion
{
    __block BOOL result = YES;
    
    [[self getPropertyObjects] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[DDTextField class]]) {
            if (![obj isValid]) {
                result = NO;
                *stop = YES;
            }
        }
    }];
    
    completion(result);
}

/**
 *  验证View中的输入项
 *
 *  @param view       待验证的View
 *  @param completion 回调
 */
- (void)verifyInputFieldFromView:(UIView *)view completion:(void(^)(BOOL result))completion
{
    __block BOOL result = YES;
    
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DDTextField class]]) {
            if (![obj isValid]) {
                result = NO;
                *stop = YES;
            }
        }
    }];
    
    completion(result);
}

/**
 *  清除内容
 */
- (void)clearPropertyText
{
    [[self getPropertyObjects] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[UILabel class]] ||
            [obj isKindOfClass:[UITextField class]] ||
            [obj isKindOfClass:[UITextView class]])
        {
            [obj setText:@""];
        }
    }];
}

- (void)batchFindObject:(Class)objClass inArray:(NSArray *)arr completion:(void(^)(id arrObj))completion
{
    [arr enumerateObjectsUsingBlock:^(id arrObj, NSUInteger idx, BOOL *stop) {
        if ([arrObj isKindOfClass:objClass]) {
            completion(arrObj);
        }
    }];
}

#pragma mark - 通用回调 -

- (void)setCallbackBlock:(void (^)(id parm1, id parm2))callbackBlock
{
    if (callbackBlock) {
        objc_setAssociatedObject(self, @selector(setCallbackBlock:), callbackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)executeCallback:(id)parm1 parm2:(id)parm2
{
    void(^aBlock)(id, id) = objc_getAssociatedObject(self, @selector(setCallbackBlock:));
    !aBlock ?: aBlock(parm1, parm2);
}

@end
