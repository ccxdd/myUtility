//
//  ddlib.h
//
//
//  Created by ccxdd on 13-12-28.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "DDTextField.h"
#import "Utility.h"
#import "NSDictionary+JSONString.h"
#import "BMWaitVC.h"
#import "BMSelectButton.h"
#import "BMStepper.h"
#import "UIViewController+DDVC.h"
#import "UIControl+DDControl.h"
#import "DDTextView.h"
#import "DDPageCV.h"
#import "AFNetworking.h"
#import "GTMBase64.h"
#import "ProjectConfig.h"

#define IS_Simulator ([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"])

#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
#define kSCREEN_HEIGHT              (IS_IPHONE_5?(IOS7_OR_LATER?568:504):(IOS7_OR_LATER?480:416))
#define kVIEW_HEIGHT                kSCREEN_HEIGHT - kVIEW_Y
#define kVIEW_Y                     (IOS7_OR_LATER?64:0)
#define kTABLE_VIEW_Y               (self.navigationController?0:(IOS7_OR_LATER?64:0))
#define kTABLE_VIEW_OFFSET          (IOS7_OR_LATER?64:0)
#define kORIGIN_Y(object)           (CGRectGetMinY([object frame])+CGRectGetHeight([object frame]))
#define kORIGIN_X(object)           (CGRectGetMinX([object frame])+CGRectGetWidth([object frame]))
#define kSelf_X1(object)            (CGRectGetMinX([object frame]))
#define kSelf_Y1(object)            (CGRectGetMinY([object frame]))
#define kSelf_X2(object)            (CGRectGetMaxX([object frame]))
#define kSelf_Y2(object)            (CGRectGetMaxY([object frame]))
#define kSelf_W(object)             (CGRectGetWidth([object frame]))
#define kSelf_H(object)             (CGRectGetHeight([object frame]))
#define kCENTER(LEN, NUM)           ((LEN - NUM)/2)

#define kUIColorHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kUIColorRGB(rValue, gValue, bValue) [UIColor colorWithRed:rValue/255.0 green:gValue/255.0 blue:bValue/255.0 alpha:1.0]
#define kUIColorRGBA(rValue, gValue, bValue, aValue) [UIColor colorWithRed:rValue/255.0 green:gValue/255.0 blue:bValue/255.0 alpha:aValue]

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

//color Log
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["

#if 0//TARGET_OS_IPHONE
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_IOS
#else
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#endif

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#ifdef DEBUG
#   define DLogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,130;" @"%s [Line %d]\n " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#   define DLogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg130,0,0;" @"%s [Line %d]\n " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#   define DLogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,130,0;" @"%s [Line %d]\n " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#   define DLogError(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"bg130,0,0;" XCODE_COLORS_ESCAPE @"fg255,255,255;" @"%s [Line %d]\n " frmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLogBlue(...)
#   define DLogRed(...)
#   define DLogGreen(...)
#   define DLogError(...)
#endif
