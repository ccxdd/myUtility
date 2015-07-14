
//
//  BMWaitVC.m
//  WanYueHui
//
//  Created by ccxdd on 13-5-27.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "BMWaitVC.h"
#import "SVProgressHUD.h"

#define dPOP_TAG                112233

static const void(^alertViewBlock)(NSInteger buttonIndex);
static const void(^alertViewFieldBlock)(UITextField *field, NSInteger buttonIndex);
static const void(^popViewBlock)(id userInfo);
static CGRect     popViewFrame;

@implementation BMWaitVC

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)showWaitView
{
    [SVProgressHUD show];
}

+ (void)closeWaitView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showSuccessMessage:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)showErrorMessage:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:message];
}

+ (void)showMessage:(NSString *)message
{
    if (message.length) {
        [SVProgressHUD showInfoWithStatus:message];
    }
}

+ (void)showProgress:(double)progress
{
    [SVProgressHUD showProgress:progress status:@"请稍后"];
}

+ (void)showProgress:(double)progress message:(NSString *)message
{
    [SVProgressHUD showProgress:progress status:message];
}

+ (void)showAlertMessage:(NSString *)message
{
    [self showAlertMessage:message buttonTitles:nil alertBlock:nil];
}

+ (void)showAlertMessage:(NSString *)message alertBlock:(void(^)(NSInteger buttonIndex))alertBlock
{
    alertViewBlock = alertBlock;
    [self showAlertMessage:message buttonTitles:@[@"取消", @"确定"] alertBlock:alertBlock];
}

+ (void)showAlertMessage:(NSString *)message
            buttonTitles:(NSArray *)buttonTitles
              alertBlock:(void(^)(NSInteger buttonIndex))alertBlock
{
    [self showAlertMessage:message title:nil buttonTitles:buttonTitles alertBlock:alertBlock];
}

+ (void)showAlertMessage:(NSString *)message
                   title:(NSString *)title
            buttonTitles:(NSArray *)buttonTitles
              alertBlock:(void(^)(NSInteger buttonIndex))alertBlock
{
    alertViewBlock = alertBlock;
    UIAlertView *alert;
    
    switch ([buttonTitles count]) {
        case 0: //
        {
            alert = [[UIAlertView alloc] initWithTitle:title ? title : message
                                               message:title ? message : nil
                                              delegate:self
                                     cancelButtonTitle:@"确认"
                                     otherButtonTitles:nil, nil];
        }
            break;
        case 1: //
        {
            alert = [[UIAlertView alloc] initWithTitle:title ? title : message
                                               message:title ? message : nil
                                              delegate:self
                                     cancelButtonTitle:buttonTitles[0]
                                     otherButtonTitles:nil, nil];
        }
            break;
        case 2:
        {
            alert = [[UIAlertView alloc] initWithTitle:title ? title : message
                                               message:title ? message : nil
                                              delegate:self
                                     cancelButtonTitle:buttonTitles[0]
                                     otherButtonTitles:buttonTitles[1], nil];
        }
            break;
        default: //
        {
            DLog(@"超出界限: %@", buttonTitles);
        }
            break;
    }
    
    [alert show];
}

+ (void)showAlertFieldMessage:(NSString *)message
                    fieldText:(NSString *)text
               alertViewStyle:(UIAlertViewStyle)alertViewStyle
                 keyboardType:(UIKeyboardType)keyboardType
                   alertBlock:(void(^)(UITextField *field, NSInteger buttonIndex))alertBlock
{
    alertViewFieldBlock = alertBlock;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = alertViewStyle;
    UITextField *field = [alert textFieldAtIndex:0];
    field.text = text;
    field.keyboardType = keyboardType;
    [alert show];
}

+ (void)showActionSheet:(NSString *)message
           buttonTitles:(NSArray *)buttonTitles
                keyName:(NSString *)keyName
             alertBlock:(void(^)(NSInteger buttonIndex))alertBlock
{
    alertViewBlock = alertBlock;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:message
                                                             delegate:(id)self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (int i = 0; i < [buttonTitles count]; i++) {
        
        if ([buttonTitles[i] isKindOfClass:[NSDictionary class]] && keyName) {
            [actionSheet addButtonWithTitle:buttonTitles[i][keyName]];
        } else {
            [actionSheet addButtonWithTitle:buttonTitles[i]];
        }
    }
    
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet setDestructiveButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showInView:[self AppDelegateWindow]];
}

#pragma mark - AppDelegateWindow

+ (UIView *)AppDelegateWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSString *className = NSStringFromClass([window class]);
    if (window == nil || [className isEqualToString:@"_UIModalItemHostingWindow"] || [className isEqualToString:@"_UIAlertControllerShimPresenterWindow"]) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    return window;
}

#pragma mark - AlertView Delegate

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        if (alertViewFieldBlock) {
            UITextField *field = [alertView textFieldAtIndex:0];
            alertViewFieldBlock(field, buttonIndex);
        }
    } else {
        if (alertViewBlock) {
            alertViewBlock(buttonIndex);
        }
    }
}

#pragma mark - ActionSheet Delegate

+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        buttonIndex = -1;
    }
    
    if (alertViewBlock) {
        alertViewBlock(buttonIndex);
    }
}

#pragma mark - PopView

+ (void)popView:(UIView *)popView
{
    [self popView:popView align:UIViewAlignPositionCenter offset:0 completion:nil];
}

+ (void)popView:(UIView *)popView
          align:(UIViewAlignPosition)align
         offset:(CGFloat)offset
     completion:(void(^)(id userInfo))completion
{
    [self popView:popView
          popBlur:0
          popTint:nil
         backBlur:5
         backTint:kUIColorRGBA(0, 0, 0, .3)
            align:align
           offset:offset
         animated:YES completion:completion];
}

+ (void)popView:(UIView *)popView
        popBlur:(CGFloat)popBlur popTint:(UIColor *)popTint
       backBlur:(CGFloat)backBlur backTint:(UIColor *)backTint
          align:(UIViewAlignPosition)align
         offset:(CGFloat)offset
       animated:(BOOL)animated
     completion:(void(^)(id userInfo))completion
{
    if (!popView) {
        return;
    }
    popViewBlock = [completion copy];
    
    if (![[BMWaitVC AppDelegateWindow] viewWithTag:dPOP_TAG]) {
        UIView *backView = [[UIView alloc] initWithFrame:[BMWaitVC AppDelegateWindow].bounds];
        if (backBlur > 0) {
            [backView setBackgroundBlur:backBlur tintColor:backTint];
        } else if (backTint) {
            backView.backgroundColor = backTint;
        }
        backView.tag = dPOP_TAG;
        [backView addSubview:popView];
        
        [popView alignPostiion:align offset:offset];
        
        if (popBlur > 0) {
            [popView setBackgroundBlur:popBlur tintColor:popTint];
        } else if (popTint) {
            popView.backgroundColor = backTint;
        } else {
            [popView setLightBlurBackground];
        }
        
        [[BMWaitVC AppDelegateWindow] addSubview:backView];
        popViewFrame = popView.frame;
        [BMWaitVC sharedInstance].popBackView = backView;
        [BMWaitVC sharedInstance].popView = popView;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView:)];
        tapGes.delegate = [self sharedInstance];
        [backView addGestureRecognizer:tapGes];
        
        if (animated) {
            [popView popScale_from:CGSizeMake(.5, .5) to:CGSizeMake(1, 1) velocity:CGSizeMake(5, 5) speed:15 bounciness:20 completion:^{
            }];
        }
    }
}

+ (void)closePopView:(UITapGestureRecognizer *)tapGes
{
    [self closePopView];
}

+ (void)closePopView
{
    [self closePopViewWithUserInfo:nil];
}

+ (void)closePopViewWithUserInfo:(id)userInfo
{
    UIView *popBackView = [BMWaitVC sharedInstance].popBackView;
    UIView *popView = [BMWaitVC sharedInstance].popView;
    
    if (popBackView) {
        [popView popScale_from:CGSizeMake(1, 1) to:CGSizeMake(.9, .9) velocity:CGSizeMake(5, 5) speed:20 bounciness:10 completion:^{
            [popView popScale_from:CGSizeMake(1, 1) to:CGSizeMake(0, 0) velocity:CGSizeMake(0, 0) speed:15 bounciness:0 completion:^{
                [popBackView removeFromSuperview];
                if (popViewBlock) {
                    [Utility dispatch_afterDelayTime:0 block:^{
                        popViewBlock(userInfo ? userInfo : nil);
                    }];
                }
            }];
        }];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    BOOL result = CGRectContainsPoint(popViewFrame, touchPoint);
    return !result;
}

@end
