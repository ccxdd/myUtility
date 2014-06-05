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

- (void)leftButtonWithImageName:(NSString *)imageName clickBlock:(void(^)(id object))clickBlock;

- (void)leftButtonWithTitle:(NSString *)title clickBlock:(void(^)(id object))clickBlock;

- (void)leftButtonAction:(id)sender;

- (void)rightButtonAction:(id)sender;

@end
