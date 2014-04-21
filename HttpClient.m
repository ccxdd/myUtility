//
//  HttpClient.m
//  aDiningHall
//
//  Created by ccxdd on 14-2-22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "HttpClient.h"

#define kBASE_API_URL           @"http://172.20.10.3:8080/csp/"

@implementation HttpClient

+ (instancetype)sharedClient
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBASE_API_URL]];
    });
    return _sharedObject;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    // By default, the example ships with SSL pinning enabled for the app.net API pinned against the public key of adn.cer file included with the example. In order to make it easier for developers who are new to AFNetworking, SSL pinning is automatically disabled if the base URL has been changed. This will allow developers to hack around with the example, without getting tripped up by SSL pinning.
    if ([[url scheme] isEqualToString:@"https"] && [[url host] isEqualToString:@"http://116.228.153.46:11010/MVTM"]) {
        self.defaultSSLPinningMode = AFSSLPinningModePublicKey;
    } else {
        self.defaultSSLPinningMode = AFSSLPinningModeNone;
    }
    
    return self;
}

#pragma mark - post

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
    successBlock:(void (^)(id responseObject))successBlock
    failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *requestData = @{@"requestData": [NSString stringWithFormat:@"[%@]", [parameters JSONString]]};
    
    [self postPath:path parameters:requestData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"responseObject = %@", responseObject);
        
        if ([responseObject[@"isSuccess"] boolValue]) {
            successBlock(responseObject);
        } else {
            [BMWaitVC showWaitViewWithMessage:responseObject[@"message"]];
            failureBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}

#pragma mark - 用户注册

- (void)registerWithUserName:(NSString *)USERNAME
                         PWD:(NSString *)PWD
                      MOBILE:(NSString *)MOBILE
                    NICKNAME:(NSString *)NICKNAME
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"OP": @"211",
                                 @"EID": @"358059047063346",
                                 @"app_mode": @"PosBusiness_DoBusinessProcess",
                                 @"USERNAME": USERNAME,
                                 @"USERCODE": USERNAME,
                                 @"PWD": PWD,
                                 @"MOBILE": MOBILE,
                                 @"NICKNAME": NICKNAME,
                                 @"MOBILEVERIFICATIONCODE": @"121"};
    
    [self postPath:@"HandlerService.ashx" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 用户登录

- (void)loginWithUserName:(NSString *)USERNAME
                      PWD:(NSString *)PWD
             successBlock:(void (^)(id responseObject))successBlock
             failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"OP": @"210",
                                 @"EID": @"358059047063346",
                                 @"app_mode": @"PosBusiness_DoBusinessProcess",
                                 @"USERCODE": USERNAME,
                                 @"PWD": PWD};
    
    [self postPath:@"HandlerService.ashx" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 首页的广告

- (void)queryADListWithSuccessBlock:(void (^)(id responseObject))successBlock
                       failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryADList"};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 查询推荐列表

- (void)queryRecommendListWithSuccessBlock:(void (^)(id responseObject))successBlock
                              failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryRecommendList"};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 商品分类/科学饮食分类

- (void)queryItemsWithItemId:(NSString *)ItemId
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryItems",
                                 @"ItemId": ItemId};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 商品列表，实现分页查询

- (void)queryProductsWithTypeId:(NSString *)typeId
                        pageNum:(NSString *)pageNum
                       pageSize:(NSString *)pageSize
                   successBlock:(void (^)(id responseObject))successBlock
                   failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryProducts",
                                 @"typeId": typeId,
                                 @"pageNum": pageNum,
                                 @"pageSize": pageSize};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 根据商品查询菜谱

- (void)queryrecipesWithProductId:(NSString *)productId
                          pageNum:(NSString *)pageNum
                         pageSize:(NSString *)pageSize
                     successBlock:(void (^)(id responseObject))successBlock
                     failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryrecipes",
                                 @"productId": productId,
                                 @"pageNum": pageNum,
                                 @"pageSize": pageSize};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 菜谱详情

- (void)queryrecipeDetailWithRecipeId:(NSString *)recipeId
                         successBlock:(void (^)(id responseObject))successBlock
                         failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryrecipeDetail",
                                 @"recipeId": recipeId};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 获取商品评价

- (void)queryDiscussWithProductId:(NSString *)productId
                          pageNum:(NSString *)pageNum
                         pageSize:(NSString *)pageSize
                     successBlock:(void (^)(id responseObject))successBlock
                     failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryDiscuss",
                                 @"productId": productId,
                                 @"pageNum": pageNum,
                                 @"pageSize": pageSize};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 获取科学饮食列表

- (void)queryScienceDietsWithItemId:(NSString *)itemId
                            pageNum:(NSString *)pageNum
                           pageSize:(NSString *)pageSize
                       successBlock:(void (^)(id responseObject))successBlock
                       failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryScienceDiets",
                                 @"itemId": itemId,
                                 @"pageNum": pageNum,
                                 @"pageSize": pageSize};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 获取科学饮食详细内容

- (void)queryScienceDietDetailWithScienceDietId:(NSString *)scienceDietId
                                   successBlock:(void (^)(id responseObject))successBlock
                                   failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"queryScienceDietDetail",
                                 @"scienceDietId": scienceDietId};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 获取美食菜谱列表

//- (void)queryScienceDietsWithItemId:(NSString *)itemId
//                            pageNum:(NSString *)pageNum
//                           pageSize:(NSString *)pageSize
//                       successBlock:(void (^)(id responseObject))successBlock
//                       failureBlock:(void (^)(id responseObject))failureBlock
//{
//
//}

#pragma mark - 收藏

- (void)collectWithProductId:(NSString *)productId
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(id responseObject))failureBlock
{
    NSDictionary *parameters = @{@"service": @"collect",
                                 @"productId": productId};
    
    [self postPath:@"gateway.do" parameters:parameters successBlock:successBlock failureBlock:failureBlock];
    
}


@end
