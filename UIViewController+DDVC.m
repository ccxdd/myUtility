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

#pragma mark - backButton

- (void)backButtonWithImageName:(NSString *)imageName
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(popVC)];
    [self.navigationItem setBackBarButtonItem:backBtn];
}

- (void)backButtonWithTitle:(NSString *)title
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(popVC)];
    [self.navigationItem setBackBarButtonItem:backBtn];
}

#pragma mark - rightButtonWithImageName

- (void)rightButtonWithImageName:(NSString *)imageName
                   renderingMode:(UIImageRenderingMode)renderingMode
                      clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[self imageWithName:imageName renderingMode:renderingMode]
                                                                 style:UIBarButtonItemStylePlain
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
    [self rightButtonWithImageName:imageName renderingMode:UIImageRenderingModeAutomatic clickBlock:clickBlock];
}

- (void)rightButtonWithTitle:(NSString *)title clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStylePlain
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
                                                                style:UIBarButtonItemStylePlain
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
    [self leftButtonWithImageName:imageName renderingMode:UIImageRenderingModeAutomatic clickBlock:clickBlock];
}

- (void)leftButtonWithTitle:(NSString *)title clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(leftButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &leftHandlerKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
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

- (BOOL)isNavRootVC
{
    return ([self.navigationController.viewControllers count] == 1);
}

- (IBAction)dismissModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)endEditing
{
    [self.view endEditing:YES];
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

#pragma mark - POP

- (IBAction)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popToRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - PUSH

- (void)pushVC:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToStoryboardID:(NSString *)identifier
{
    [self pushVC:[self storyboardID:identifier]];
}

- (void)pushToStoryboardName:(NSString *)SbName identifier:(NSString *)identifier
{
    UIViewController *classVC = [UIViewController storyboardName:SbName
                                                      identifier:identifier];
    [self pushVC:classVC];
}

- (void)pushToVC:(UIViewController *)vc isBlurBg:(BOOL)isBlurBg
{
    if (isBlurBg) {
        [vc.view setLightBlurBackground];
    }
    [self pushVC:vc];
}

- (void)pushToStoryboardID:(NSString *)storyboardID customInfo:(id)customInfo isBlurBg:(BOOL)isBlurBg
{
    id classVC = [self storyboardID:storyboardID];
    if ([classVC respondsToSelector:@selector(customInfo)]) {
        [classVC setCustomInfo:customInfo];
    }
    [self pushToVC:classVC isBlurBg:isBlurBg];
}

#pragma mark - Storyboard

+ (id)storyboardName:(NSString *)name identifier:(NSString *)identifier
{
    UIViewController *classVC = nil;
    
    @try {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        if (identifier) {
            classVC = [storyboard instantiateViewControllerWithIdentifier:identifier];
        } else {
            classVC = [storyboard instantiateInitialViewController];
        }
    }
    @catch (NSException *exception) {
        DLogError(@"%@", exception);
    }
    
    return classVC;
}

- (id)storyboardID:(NSString *)identifier
{
    return [self.storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (id)storyboardInitialVC
{
    return [self.storyboard instantiateInitialViewController];
}

- (void)setBackgroundImage:(UIImage *)image blur:(CGFloat)blur tintColor:(UIColor *)tintColor
{
    [self.view setBackgroundImage:image blur:blur tintColor:tintColor];
}

+ (UIViewController *)currentVC
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootVC = window.rootViewController;
    UIViewController *currentVC;
    
    UIViewController* (^currentVC_Block)(UIViewController *vc) =  ^UIViewController* (UIViewController *vc) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            return [[(UINavigationController *)vc viewControllers] lastObject];
        } else {
            return vc;
        }
    };
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectVC = [(UITabBarController *)rootVC selectedViewController];
        currentVC = currentVC_Block(selectVC);
    } else {
        currentVC = currentVC_Block(rootVC);
    }
    
    return currentVC;
}



@end
