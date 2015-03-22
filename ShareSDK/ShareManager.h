//
//  ShareManager.h
//  ZH_iOS
//
//  Created by scofieldcai on 11/6/14.
//  Copyright (c) 2014 上海佐昊网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
//第三方平台的SDK头文件，根据需要的平台导入。
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>

@interface ShareManager : NSObject

+ (void)initShareSDK;

#pragma mark - 分享 -

+ (void)shareTypes:(NSArray *)types
      contentBlock:(NSString* (^)(NSUInteger selectIndex, NSUInteger sourceType))content
          urlBlock:(NSString* (^)(NSUInteger selectIndex, NSUInteger sourceType))url
             title:(NSString *)title
             image:(UIImage *)image
       description:(NSString *)description
           success:(void(^)())success
           failure:(void(^)())failure;

+ (void)shareTypes:(NSArray *)types
           content:(NSString *)content
               url:(NSString *)url
             title:(NSString *)title
             image:(UIImage *)image
       description:(NSString *)description
           success:(void(^)())success
           failure:(void(^)())failure;

#pragma mark - 关注新浪微博 -

+ (void)followSinaWeiboWithUserId:(NSString *)userId
                          success:(void(^)())success
                          failure:(void(^)())failure;

+ (void)followSinaWeiboWithUserName:(NSString *)userName
                            success:(void(^)())success
                            failure:(void(^)())failure;

#pragma mark - 登陆 -

+ (void)loginOfSinaWeiboCompletion:(void(^)(id userInfo))completion;
+ (void)loginOfWeiXinCompletion:(void(^)(id userInfo))completion;
+ (void)loginOfQQCompletion:(void(^)(id userInfo))completion;

#pragma mark - 注销 -

+ (void)logoutAuthCompletion:(void(^)())completion;

@end
