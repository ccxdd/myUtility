//
//  UIViewController+DDVC.h
//  TianXianPei
//
//  Created by ccxdd on 13-12-27.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DDVC)

- (void)backButtonWithImageName:(NSString *)imageName;

- (void)backButtonWithTitle:(NSString *)title;

- (void)rightButtonWithImageName:(NSString *)imageName clickBlock:(void(^)(id object))clickBlock;

- (void)rightButtonWithTitle:(NSString *)title clickBlock:(void(^)(id object))clickBlock;

- (void)rightButtonWithImageName:(NSString *)imageName
                   renderingMode:(UIImageRenderingMode)renderingMode
                      clickBlock:(void(^)(id))clickBlock;

- (void)leftButtonWithImageName:(NSString *)imageName clickBlock:(void(^)(id object))clickBlock;

- (void)leftButtonWithTitle:(NSString *)title clickBlock:(void(^)(id object))clickBlock;

- (void)leftButtonWithImageName:(NSString *)imageName
                  renderingMode:(UIImageRenderingMode)renderingMode
                     clickBlock:(void(^)(id))clickBlock;

- (void)leftButtonAction:(id)sender;

- (void)rightButtonAction:(id)sender;

- (void)popVC;

- (void)popToRootVC;

- (void)pushToVC:(UIViewController *)vc;

/**
 *  是否存在pop栈中
 *
 *  @param className 类名
 *
 *  @return BOOL
 */
- (BOOL)isInPopArrayWithClass:(NSString *)className;

/**
 *  返回到指定的类名中
 *
 *  @param className 类名
 */
- (void)popToClass:(NSString *)className;

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

@end
