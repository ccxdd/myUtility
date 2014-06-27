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

#pragma mark ------------rightButtonWithImageName---------------

- (void)rightButtonWithImageName:(NSString *)imageName
                   renderingMode:(UIImageRenderingMode)renderingMode
                      clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:renderingMode]
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

#pragma mark ------------leftButtonWithImageName---------------

- (void)leftButtonWithImageName:(NSString *)imageName
                  renderingMode:(UIImageRenderingMode)renderingMode
                     clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:renderingMode]
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

#pragma mark ------------backAction---------------

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------RightBtnAction---------------

- (void)rightButtonAction:(id)sender
{
    void (^theCompletionHandler)(id) = objc_getAssociatedObject(self, &rightHandleKey);
    
    if (theCompletionHandler) {
        theCompletionHandler(sender);
    }
}

#pragma mark ------------LeftBtnAction---------------

- (void)leftButtonAction:(id)sender
{
    void (^theCompletionHandler)(id) = objc_getAssociatedObject(self, &leftHandlerKey);
    
    if (theCompletionHandler) {
        theCompletionHandler(sender);
    }
}

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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


@end
