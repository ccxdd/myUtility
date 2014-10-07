//
//  HttpClient.h
//  WenStore
//
//  Created by ccxdd on 14-6-2.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface HttpClient : AFHTTPSessionManager

+ (instancetype)sharedInstance;

#pragma mark - 注册

- (void)userRegisterWithUserName:(NSString *)userName
                        nickName:(NSString *)nickName
                        password:(NSString *)password
                         success:(void(^)(id responseObject))success;

#pragma mark - 登录

- (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
                      success:(void(^)(id responseObject))success;
@end
