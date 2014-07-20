//
//  ddlib.h
//
//
//  Created by ccxdd on 13-12-28.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

/* category */
#import "NSDictionary+DDictionary.h"
#import "UITableView+DDTableView.h"
#import "NSString+DDString.h"
#import "UIViewController+DDVC.h"
#import "UIControl+DDControl.h"
#import "UILabel+DDLabel.h"
#import "UIView+DDView.h"
/* category */

#import "BMWaitVC.h"
#import "DDTextField.h"
#import "DDDataSource.h"
#import "Utility.h"
#import "BMStepper.h"
#import "DDCheckBox.h"
#import "DDRadioBox.h"
#import "DDTableVC.h"
#import "DDTextView.h"
#import "DDPageCV.h"
#import "ButtonGroup.h"
#import "AFNetworking.h"
#import "GTMBase64.h"

#define IS_Simulator ([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"])

#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
#define kSCREEN_BOUNDS              [[UIScreen mainScreen] bounds]
#define kSCREEN_HEIGHT              [[UIScreen mainScreen] bounds].size.height
#define kSCREEN_WIDTH               [[UIScreen mainScreen] bounds].size.width
#define kVIEW_HEIGHT                (IOS7_OR_LATER ? kSCREEN_HEIGHT : kSCREEN_HEIGHT - 20)
#define kVIEW_Y                     (IOS7_OR_LATER ? kNAV_HEIGHT : 0)
#define kNAV_HEIGHT                 (self.navigationController ? 44 : 0)
#define kTABBAR_HEIGHT              (self.tabBarController ? 49 : 0)
#define kIOS67_VIEW_OFFSET          (IOS7_OR_LATER ? 0 : -64)
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

#ifndef kCFCoreFoundationVersionNumber_iOS_6_1
#define kCFCoreFoundationVersionNumber_iOS_6_1 793.00
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) \
{ \
__VA_ARGS__ ; \
}
#else
#define IF_IOS7_OR_GREATER(...)
#endif
