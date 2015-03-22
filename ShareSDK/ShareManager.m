//
//  ShareManager.m
//  ZH_iOS
//
//  Created by scofieldcai on 11/6/14.
//  Copyright (c) 2014 上海佐昊网络科技有限公司. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

#pragma mark - ShareSDK

+ (void)initShareSDK
{
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    
    //如果使用服务中配置的app信息，请把初始化代码改为下面的初始化方法。
    [ShareSDK registerApp:kShareKey useAppTrusteeship:YES];
    
    [ShareSDK setUIStyle:SSUIStyleiOS7];
    
    //如果使用服务器中配置的app信息，请把初始化平台代码改为下面的方法
    [self initializePlatForTrusteeship];
}


/**
 *	@brief	托管模式下的初始化平台
 */
+ (void)initializePlatForTrusteeship
{
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    //[ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    //连接邮件
    [ShareSDK connectMail];
    
    //连接打印
    //[ShareSDK connectAirPrint];
    
    //连接拷贝
    [ShareSDK connectCopy];
}

#pragma mark - 分享 -

+ (void)shareTypes:(NSArray *)types
      contentBlock:(NSString* (^)(NSUInteger selectIndex, NSUInteger sourceType))content
          urlBlock:(NSString* (^)(NSUInteger selectIndex, NSUInteger sourceType))url
             title:(NSString *)title
             image:(UIImage *)image
       description:(NSString *)description
           success:(void(^)())success
           failure:(void(^)())failure
{
    [BMWaitVC showActionSheet:@"分享" buttonTitles:types
                      keyName:nil
                   alertBlock:^(NSInteger buttonIndex)
     {
         /*
          0. 直接输入手机号，
          1. 新浪微博，
          2. 腾讯微博，
          3. QQ好友，
          4. SMS短信，
          5. 二维码，
          6. 微信/微信朋友圈，
          7. 其他
          */
         
         if (buttonIndex < 0) {
             return;
         }
         
         __block ShareType choseShareType;
         __block int sourceType = 0;
         
         if ([types[buttonIndex] isEqualToString:@"新浪微博"]) {
             choseShareType = ShareTypeSinaWeibo;
             sourceType = 1;
         } else if ([types[buttonIndex] isEqualToString:@"腾讯微博"]) {
             choseShareType = ShareTypeTencentWeibo;
             sourceType = 2;
         } else if ([types[buttonIndex] isEqualToString:@"微信朋友圈"]) {
             choseShareType = ShareTypeWeixiTimeline;
             sourceType = 6;
         } else if ([types[buttonIndex] isEqualToString:@"微信好友"]) {
             choseShareType = ShareTypeWeixiSession;
             sourceType = 6;
         } else if ([types[buttonIndex] isEqualToString:@"QQ好友"]) {
             choseShareType = ShareTypeQQ;
             sourceType = 3;
         } else if ([types[buttonIndex] isEqualToString:@"短信分享"]) {
             choseShareType = ShareTypeSMS;
             sourceType = 4;
         }
         
         //创建分享内容
         id<ISSContent> publishContent = [ShareSDK content:content ? content(buttonIndex, sourceType) : @""
                                            defaultContent:@""
                                                     image:[ShareSDK pngImageWithImage:image]
                                                     title:title
                                                       url:url ? url(buttonIndex, sourceType) : @""
                                               description:description
                                                 mediaType:SSPublishContentMediaTypeNews];
         
         //创建弹出菜单容器
         id<ISSContainer> container = [ShareSDK container];
         [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
         
         id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                              allowCallback:YES
                                                              authViewStyle:SSAuthViewStyleFullScreenPopup
                                                               viewDelegate:nil
                                                    authManagerViewDelegate:nil];
         
         //在授权页面中添加关注官方微博
         [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [ShareSDK userFieldWithType:SSUserFieldTypeUid value:kWeiboID],
                                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                         nil]];
         
         if ((choseShareType == ShareTypeSinaWeibo && ![WeiboSDK isWeiboAppInstalled]) || choseShareType == ShareTypeSMS) {
             //            [BMWaitVC showAlertMessage:@"新浪微博未安装，是否安装？" alertBlock:^(NSInteger buttonIndex) {
             //                if (buttonIndex) {
             //                    [[UIApplication sharedApplication] openURL:[[WeiboSDK getWeiboAppInstallUrl] toURL]];
             //                }
             //            }];
             //            return;
             
             [Utility dispatch_afterDelayTime:.5 block:^{
                 //显示分享菜单
                 [ShareSDK showShareViewWithType:choseShareType
                                       container:container
                                         content:publishContent
                                   statusBarTips:NO
                                     authOptions:authOptions
                                    shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                                        oneKeyShareList:nil
                                                                         qqButtonHidden:NO
                                                                  wxSessionButtonHidden:NO
                                                                 wxTimelineButtonHidden:NO
                                                                   showKeyboardOnAppear:NO
                                                                      shareViewDelegate:nil
                                                                    friendsViewDelegate:nil
                                                                  picViewerViewDelegate:nil]
                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                              
                                              if (state == SSPublishContentStateSuccess)
                                              {
                                                  if (success) {
                                                      success();
                                                  }
                                              }
                                              else if (state == SSPublishContentStateFail)
                                              {
                                                  if (failure) {
                                                      failure();
                                                  }
                                              }
                                          }];
             }];
         } else {
             //客户端调用
             [ShareSDK clientShareContent:publishContent
                                     type:choseShareType
                            statusBarTips:NO
                                   result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                       
                                       if (state == SSPublishContentStateSuccess)
                                       {
                                           if (success) {
                                               success();
                                           }
                                       }
                                       else if (state == SSPublishContentStateFail)
                                       {
                                           if (failure) {
                                               failure();
                                           }
                                       }
                                   }];
         }
     }];
}

+ (void)shareTypes:(NSArray *)types
           content:(NSString *)content
               url:(NSString *)url
             title:(NSString *)title
             image:(UIImage *)image
       description:(NSString *)description
           success:(void(^)())success
           failure:(void(^)())failure
{
    [self shareTypes:types
        contentBlock:^NSString *(NSUInteger selectIndex, NSUInteger sourceType) {
            return content;
        }
            urlBlock:^NSString *(NSUInteger selectIndex, NSUInteger sourceType) {
                return url;
            }
               title:title
               image:image
         description:description
             success:success
             failure:failure];
}

#pragma mark - 关注新浪微博 -

+ (void)followSinaWeiboWithUserId:(NSString *)userId
                          success:(void(^)())success
                          failure:(void(^)())failure
{
    [self followSinaWeiboWithValue:userId fieldType:SSUserFieldTypeUid success:success failure:failure];
}

+ (void)followSinaWeiboWithUserName:(NSString *)userName
                            success:(void(^)())success
                            failure:(void(^)())failure
{
    [self followSinaWeiboWithValue:userName fieldType:SSUserFieldTypeName success:success failure:failure];
}

+ (void)followSinaWeiboWithValue:(NSString *)value
                       fieldType:(SSUserFieldType)fieldType
                         success:(void(^)())success
                         failure:(void(^)())failure
{
    //关注用户
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:fieldType value:value],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    nil]];
    
    [ShareSDK followUserWithType:ShareTypeSinaWeibo                    //平台类型
                           field:value                                   //关注用户的名称或ID
                       fieldType:fieldType      //字段类型，用于指定第二个参数是名称还是ID
                     authOptions:authOptions                     //授权选项
                    viewDelegate:nil                    //授权视图委托
                          result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) { //返回回调
                              if (state == SSResponseStateSuccess)
                              {
                                  if (success) {
                                      success();
                                  }
                              }
                              else if (state == SSResponseStateFail)
                              {
                                  NSLog(@"%@", [NSString stringWithFormat:@"关注失败:%@", error.errorDescription]);
                                  if (failure) {
                                      failure();
                                  }
                              }
                          }];
}

+ (void)loginOfSinaWeiboCompletion:(void(^)(id userInfo))completion
{
    [self loginShareType:ShareTypeSinaWeibo completion:completion];
}

+ (void)loginOfWeiXinCompletion:(void(^)(id userInfo))completion
{
    [self loginShareType:ShareTypeWeixiSession completion:completion];
}

+ (void)loginOfQQCompletion:(void(^)(id userInfo))completion
{
    [self loginShareType:ShareTypeQQ completion:completion];
}

+ (void)loginShareType:(ShareType)type completion:(void(^)(id userInfo))completion
{
    [ShareSDK getUserInfoWithType:type authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result) {
                                   DLogSuccss(@"[userInfo sourceData] = %@", [userInfo sourceData]);
                                   completion ? completion(userInfo) : nil;
                               } else {
                                   DLogError(@"error code = %ld, description = %@", [error errorCode], [error errorDescription]);
                               }
                           }];
}

+ (void)logoutAuthCompletion:(void(^)())completion
{
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    [ShareSDK cancelAuthWithType:ShareTypeQQ];
    
    completion ? completion() : nil;
}

@end
