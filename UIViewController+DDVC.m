//
//  UIViewController+DDVC.m
//  TianXianPei
//
//  Created by ccxdd on 13-12-27.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "UIViewController+DDVC.h"
#import <objc/runtime.h>

@implementation UIViewController (DDVC)

const char leftHandlerKey, rightHandleKey;

- (void)backButtonWithImageName:(NSString *)imageName
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(backAction)];
    [self.navigationItem setBackBarButtonItem:backBtn];
}

- (void)backButtonWithTitle:(NSString *)title
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(backAction)];
    [self.navigationItem setBackBarButtonItem:backBtn];
}

#pragma mark - rightButtonWithImageName

- (void)rightButtonWithImageName:(NSString *)imageName
                   renderingMode:(UIImageRenderingMode)renderingMode
                      clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[self imageWithName:imageName renderingMode:renderingMode]
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(rightButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &rightHandleKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

- (void)rightButtonWithImageName:(NSString *)imageName clickBlock:(void(^)(id))clickBlock
{
    [self rightButtonWithImageName:imageName renderingMode:UIImageRenderingModeAlwaysOriginal clickBlock:clickBlock];
}

- (void)rightButtonWithTitle:(NSString *)title clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(rightButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &rightHandleKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

#pragma mark - leftButtonWithImageName

- (void)leftButtonWithImageName:(NSString *)imageName
                  renderingMode:(UIImageRenderingMode)renderingMode
                     clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[self imageWithName:imageName renderingMode:renderingMode]
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(leftButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &leftHandlerKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

- (void)leftButtonWithImageName:(NSString *)imageName clickBlock:(void(^)(id))clickBlock
{
    [self leftButtonWithImageName:imageName renderingMode:UIImageRenderingModeAlwaysOriginal clickBlock:clickBlock];
}

- (void)leftButtonWithTitle:(NSString *)title clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(leftButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &leftHandlerKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

#pragma mark - backAction

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - rightButtonAction

- (void)rightButtonAction:(id)sender
{
    void (^theCompletionHandler)(id) = objc_getAssociatedObject(self, &rightHandleKey);
    
    if (theCompletionHandler) {
        theCompletionHandler(sender);
    }
}

#pragma mark - leftButtonAction

- (void)leftButtonAction:(id)sender
{
    void (^theCompletionHandler)(id) = objc_getAssociatedObject(self, &leftHandlerKey);
    
    if (theCompletionHandler) {
        theCompletionHandler(sender);
    }
}

- (UIImage *)imageWithName:(NSString *)name renderingMode:(UIImageRenderingMode)renderingMode
{   //iOS7_OR_LATER
    UIImage *image = [UIImage imageNamed:name];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
        return [image imageWithRenderingMode:renderingMode];
    }
    
    return image;
}

#pragma mark - navigation

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  是否存在pop栈中
 *
 *  @param className 类名
 *
 *  @return BOOL
 */
- (BOOL)isInPopArrayWithClass:(NSString *)className
{
    NSArray *vcArr = self.navigationController.viewControllers;
    for (id vc in vcArr) {
        if ([NSStringFromClass([vc class]) isEqualToString:className]) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  返回到指定的类名中
 *
 *  @param className 类名
 */
- (void)popToClass:(NSString *)className
{
    NSArray *vcArr = self.navigationController.viewControllers;
    for (id vc in vcArr) {
        if ([NSStringFromClass([vc class]) isEqualToString:className]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)pushToVC:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
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
