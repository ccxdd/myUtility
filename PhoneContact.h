//
//  PhoneContact.h
//  ZH_iOS
//
//  Created by ccxdd on 15/7/13.
//  Copyright (c) 2015年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneContact : NSObject

+ (void)selectedWithCompletion:(void(^)(NSString *name, NSString *phone))completion;

@end
