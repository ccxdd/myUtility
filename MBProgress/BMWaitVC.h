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
//显示自义定文字
+ (void)showMessage:(NSString *)message;
//显示
+ (void)showWaitView;
//消失
+ (void)closeWaitView;

+ (void)showAlertMessage:(NSString *)message alertBlock:(void(^)(NSInteger buttonIndex))alertBlock;

+ (void)showAlertMessage:(NSString *)message
            buttonTitles:(NSArray *)buttonTitles
              alertBlock:(void(^)(NSInteger buttonIndex))alertBlock;

+ (void)showAlertFieldMessage:(NSString *)message
                    fieldText:(NSString *)text
               alertViewStyle:(UIAlertViewStyle)alertViewStyle
                 keyboardType:(UIKeyboardType)keyboardType
                   alertBlock:(void(^)(UITextField *field, NSInteger buttonIndex))alertBlock;

+ (void)showActionSheet:(NSString *)message
           buttonTitles:(NSArray *)buttonTitles
                keyName:(NSString *)keyName
             alertBlock:(void(^)(NSInteger buttonIndex))alertBlock;

+ (void)showWaitViewProgress:(double)progress;

+ (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

@end


