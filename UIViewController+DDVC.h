//
//  UIViewController+DDVC.h
//  TianXianPei
//
//  Created by ccxdd on 13-12-27.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DDVC)

+ (id)storyboardName:(NSString *)name identifier:(NSString *)identifier;

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

- (void)pushVC:(UIViewController *)vc;

/**
 *  Push到VC时是否隐藏Tabbar
 *
 *  @param vc     要Push的VC
 *  @param isHide 是否隐藏Tabbar
 */
- (void)pushToVC:(UIViewController *)vc hideTabbar:(BOOL)isHide;

/**
 *  Push从Storyboard中取出的VC
 *
 *  @param identifier Storyboard中的ID
 *  @param isHide     是否隐藏Tabbar
 */
- (void)pushToStoryboardID:(NSString *)identifier hideTabbar:(BOOL)isHide;

/**
 *  Push从Storyboard中取出的VC
 *
 *  @param SbName     Storyboard的名字
 *  @param identifier Storyboard中的ID
 *  @param isHide     是否隐藏Tabbar
 */
- (void)pushToStoryboardName:(NSString *)SbName identifier:(NSString *)identifier hideTabbar:(BOOL)isHide;

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
 *  是否为Nav的rootVC
 *
 *  @return BOOL
 */
- (BOOL)isNavRootVC;

/**
 *  根据Storyboard ID返回VC
 *
 *  @param identifier VC的ID
 *
 *  @return VC
 */
- (id)storyboardID:(NSString *)identifier;

/**
 *  返回Storyboard初始化VC
 *
 *  @return VC
 */
- (id)storyboardInitialVC;

@end
