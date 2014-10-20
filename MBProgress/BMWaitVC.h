//
//  BMWaitVC.h
//  WanYueHui
//
//  Created by ccxdd on 13-5-27.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMWaitVC;

@protocol WaitViewDelegate <NSObject>
@optional
//点击事件
- (void)waitViewClickEvent;
@end

@interface BMWaitVC : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>
{
    NSInteger useCount;
}

@property (nonatomic, assign) id<WaitViewDelegate> waitViewDelegate;

+ (instancetype)sharedInstance;

/**
 *  显示文字提示框
 *
 *  @param message 显示文字
 */
+ (void)showMessage:(NSString *)message;

/**
 *  显示文字提示框
 *
 *  @param message 显示文字
 *  @param delay   显示时间
 */
+ (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

/**
 *  显示等待框
 */
+ (void)showWaitView;

/**
 *  关闭等待框
 */
+ (void)closeWaitView;

/**
 *  显示alertView
 *
 *  @param message    显示文字
 *  @param alertBlock 回调block
 */
+ (void)showAlertMessage:(NSString *)message alertBlock:(void(^)(NSInteger buttonIndex))alertBlock;

/**
 *  显示自定义按钮标题alertView
 *
 *  @param message      显示的文字
 *  @param buttonTitles 按钮标题
 *  @param alertBlock   回调block
 */
+ (void)showAlertMessage:(NSString *)message
            buttonTitles:(NSArray *)buttonTitles
              alertBlock:(void(^)(NSInteger buttonIndex))alertBlock;

+ (void)showAlertFieldMessage:(NSString *)message
                    fieldText:(NSString *)text
               alertViewStyle:(UIAlertViewStyle)alertViewStyle
                 keyboardType:(UIKeyboardType)keyboardType
                   alertBlock:(void(^)(UITextField *field, NSInteger buttonIndex))alertBlock;

/**
 *  显示actionSheet
 *
 *  @param message      显示文字
 *  @param buttonTitles 按钮标题
 *  @param keyName      字典类型的key若不是填nil
 *  @param alertBlock   回调block
 */
+ (void)showActionSheet:(NSString *)message
           buttonTitles:(NSArray *)buttonTitles
                keyName:(NSString *)keyName
             alertBlock:(void(^)(NSInteger buttonIndex))alertBlock;

/**
 *  显示进度条
 *
 *  @param progress 进度指数
 */
+ (void)showProgress:(double)progress;

/**
 *  显示进度条
 *
 *  @param progress 进度指数
 *  @param message  提示文字
 */
+ (void)showProgress:(double)progress message:(NSString *)message;

/**
 *  弹出框
 *
 *  @param popView 想要弹出的View
 */
+ (void)popView:(UIView *)popView;

/**
 *  弹出框
 *
 *  @param popView    想要弹出的View
 *  @param completion 回调
 */
+ (void)popView:(UIView *)popView completion:(void(^)())completion;

@end


