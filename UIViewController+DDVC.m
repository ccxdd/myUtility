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

const char completionHandlerKey;

- (void)backButtonWithImageName:(NSString *)imageName
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(backAction)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
}

- (void)backButtonWithTitle:(NSString *)title
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(backAction)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
}

#pragma mark ------------rightButtonWithImageName---------------

- (void)rightButtonWithImageName:(NSString *)imageName clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(rightButtonAction)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &completionHandlerKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

- (void)rightButtonWithTitle:(NSString *)title clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(rightButtonAction)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &completionHandlerKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

#pragma mark ------------leftButtonWithImageName---------------

- (void)leftButtonWithImageName:(NSString *)imageName clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(leftButtonAction)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &completionHandlerKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

- (void)leftButtonWithTitle:(NSString *)title clickBlock:(void(^)(id))clickBlock
{
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:title
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(leftButtonAction)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    if(clickBlock != nil)
    {
        objc_setAssociatedObject(self, &completionHandlerKey, clickBlock, OBJC_ASSOCIATION_COPY);
    }
    
}

#pragma mark ------------backAction---------------

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------RightBtnAction---------------

- (void)rightButtonAction
{
    void (^theCompletionHandler)(id) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if (theCompletionHandler == nil) {
        return;
    }
    
    theCompletionHandler(self);
}

#pragma mark ------------LeftBtnAction---------------

- (void)leftButtonAction
{
    void (^theCompletionHandler)(id) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if (theCompletionHandler == nil) {
        return;
    }
    
    theCompletionHandler(self);
}


@end
