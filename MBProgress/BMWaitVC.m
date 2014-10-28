
//
//  BMWaitVC.m
//  WanYueHui
//
//  Created by ccxdd on 13-5-27.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "BMWaitVC.h"
#import "MBProgressHUD.h"

#define dHUD_TAG                12344321
#define dPOP_TAG                112233
#define HUD_FONT                [UIFont systemFontOfSize:16]

static const void(^alertViewBlock)(NSInteger buttonIndex);
static const void(^alertViewFieldBlock)(UITextField *field, NSInteger buttonIndex);
static const void(^popViewBlock)(void);
static NSUInteger kWaitViewCount = 0;
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
        useCount = 0;
    }
    return self;
}

+ (MBProgressHUD *)MBProgressHUDFormWindows
{
    UIView *windows = [self AppDelegateWindow];
    MBProgressHUD *HUD = (MBProgressHUD *)[windows viewWithTag:dHUD_TAG];
    
    if (HUD) {
        return HUD;
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:windows];
        [windows addSubview:HUD];
        HUD.tag = dHUD_TAG;
        HUD.userInteractionEnabled = NO;
        HUD.detailsLabelFont = HUD_FONT;
        HUD.labelFont = HUD_FONT;
    }
    
    return HUD;
}

+ (void)showWaitView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *HUD = [self MBProgressHUDFormWindows];
        [HUD setMinSize:CGSizeMake(120, 120)];
        HUD.labelText = @"请稍后";
        [HUD show:YES];
        kWaitViewCount++;
        
        UITapGestureRecognizer *hudGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
        [HUD addGestureRecognizer:hudGes];
        
        //            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        //            [lab setText:@"点击取消"];
        //            [lab setFont:[UIFont systemFontOfSize:14]];
        //            [lab setBackgroundColor:[UIColor clearColor]];
        //            [lab setTextColor:[UIColor lightGrayColor]];
        //            [lab setTextAlignment:NSTextAlignmentCenter];
        //            [lab setTag:dHUD_TAG+1];
        //            lab.center = CGPointMake(HUD.center.x, HUD.center.y+50);
        //            [HUD addSubview:lab];
    });
}

+ (void)showMessage:(NSString *)message
{
    [self showMessage:message afterDelay:2];
}

+ (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    if (message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *HUD = [self MBProgressHUDFormWindows];
            [HUD setMode:MBProgressHUDModeText];
            HUD.detailsLabelText = message;
            [HUD show:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //DLog(@"HUD = %@", HUD);
                [HUD hide:YES];
            });
        });
    }
}

+ (void)showProgress:(double)progress
{
    [self showProgress:progress message:@"请稍后"];
}

+ (void)showProgress:(double)progress message:(NSString *)message
{
    if (progress < 1) {
        
        //DLog(@"progress = %f", progress);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *HUD = [self MBProgressHUDFormWindows];
            HUD.mode = MBProgressHUDModeDeterminate;
            HUD.progress = progress;
            HUD.labelText = message;
            UITapGestureRecognizer *hudGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
            [HUD addGestureRecognizer:hudGes];
        });
    }
}

+ (void)closeWaitView
{
    if (kWaitViewCount > 1) {
        kWaitViewCount--;
        return;
    }
    
    double time = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = (MBProgressHUD *)[[self AppDelegateWindow] viewWithTag:dHUD_TAG];
        if (hud) {
            //DLog(@"HUD = %@", hud);
            [hud hide:YES];
            kWaitViewCount = 0;
        }
    });
}

+ (void)dismissAction
{
    DLog(@"MBProgress dismiss!");
    if ([[self sharedInstance] waitViewDelegate] && [[[self sharedInstance] waitViewDelegate] respondsToSelector:@selector(waitViewClickEvent)])
    {
        [[[self sharedInstance] waitViewDelegate] waitViewClickEvent];
    }
    
    [self closeWaitView];
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
    alertViewBlock = alertBlock;
    UIAlertView *alert;
    
    switch ([buttonTitles count]) {
        case 0: //
        {
            alert = [[UIAlertView alloc] initWithTitle:message
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"确认"
                                     otherButtonTitles:nil, nil];
        }
            break;
        case 1: //
        {
            alert = [[UIAlertView alloc] initWithTitle:message
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:buttonTitles[0]
                                     otherButtonTitles:nil, nil];
        }
            break;
        case 2:
        {
            alert = [[UIAlertView alloc] initWithTitle:message
                                               message:nil
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

- (NSInteger)useCount
{
    return useCount;
}

- (void)setUseCount:(NSInteger)value
{
    useCount = value;
}

- (void)incCount
{
    useCount++;
    //DLog(@"incCount = %d", useCount);
}

- (void)decCount
{
    useCount--;
    //DLog(@"decCount = %d", useCount);
}

#pragma mark - AppDelegateWindow

+ (UIView *)AppDelegateWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSString *className = NSStringFromClass([window class]);
    if (window == nil || [className isEqualToString:@"_UIModalItemHostingWindow"]) {
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
            field.text.length > 0 ? alertViewFieldBlock(field, buttonIndex):nil;
            //alertViewFieldBlock = nil;
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
    [self popView:popView completion:nil];
}

+ (void)popView:(UIView *)popView
        popBlur:(CGFloat)popBlur popTint:(UIColor *)popTint
       backBlur:(CGFloat)backBlur backTint:(UIColor *)backTint
       animated:(BOOL)animated
     completion:(void(^)())completion
{
    if (!popView) {
        return;
    }
    popViewBlock = completion;
    
    if (![[BMWaitVC AppDelegateWindow] viewWithTag:dPOP_TAG]) {
        UIView *popBackView = [[UIView alloc] initWithFrame:[BMWaitVC AppDelegateWindow].bounds];
        if (backBlur > 0) {
            [popBackView setBackgroundBlur:backBlur tintColor:backTint];
        } else if (backTint) {
            popBackView.backgroundColor = backTint;
        }
        popBackView.tag = dPOP_TAG;
        [popBackView addSubview:popView];
        
        [popView alignPostiion:UIViewAlignPositionCenter offset:0];
        
        if (popBlur > 0) {
            [popView setBackgroundBlur:backBlur tintColor:backTint];
        } else if (popTint) {
            popView.backgroundColor = backTint;
        } else {
            [popView setLightBlurBackground];
        }
        
        [[BMWaitVC AppDelegateWindow] addSubview:popBackView];
        popViewFrame = popView.frame;
        [BMWaitVC sharedInstance].popBackView = popBackView;
        [BMWaitVC sharedInstance].popView = popView;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView:)];
        tapGes.delegate = [self sharedInstance];
        [popBackView addGestureRecognizer:tapGes];
        
        if (animated) {
            [popView popScale_from:CGSizeMake(.5, .5) to:CGSizeMake(1, 1) velocity:CGSizeMake(5, 5) speed:15 bounciness:20 completion:^{
            }];
        }
    }
}

+ (void)popView:(UIView *)popView completion:(void(^)())completion
{
    [self popView:popView popBlur:0 popTint:nil backBlur:0 backTint:kUIColorRGBA(127, 127, 127, .3)
         animated:YES completion:completion];
}

+ (void)closePopView:(UITapGestureRecognizer *)tapGes
{
    [self closePopView];
}

+ (void)closePopView
{
    UIView *popBackView = [BMWaitVC sharedInstance].popBackView;
    UIView *popView = [BMWaitVC sharedInstance].popView;
    
    if (popBackView) {
        [popView popScale_from:CGSizeMake(1, 1) to:CGSizeMake(.9, .9) velocity:CGSizeMake(5, 5) speed:20 bounciness:10 completion:^{
            [popView popScale_from:CGSizeMake(1, 1) to:CGSizeMake(0, 0) velocity:CGSizeMake(0, 0) speed:15 bounciness:0 completion:^{
                [popBackView removeFromSuperview];
                if (popViewBlock) {
                    [Utility dispatch_afterDelayTime:0 block:^{
                        popViewBlock();
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
