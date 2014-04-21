//
//  HttpClient.h
//  aDiningHall
//
//  Created by ccxdd on 14-2-22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "AFHTTPClient.h"

@interface HttpClient : AFHTTPClient

+ (instancetype)sharedClient;

#pragma mark - 用户注册

- (void)registerWithUserName:(NSString *)USERNAME
                         PWD:(NSString *)PWD
                      MOBILE:(NSString *)MOBILE
                    NICKNAME:(NSString *)NICKNAME
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 用户登录

- (void)loginWithUserName:(NSString *)USERNAME
                      PWD:(NSString *)PWD
             successBlock:(void (^)(id responseObject))successBlock
             failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 首页的广告

- (void)queryADListWithSuccessBlock:(void (^)(id responseObject))successBlock
                       failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 查询推荐列表

- (void)queryRecommendListWithSuccessBlock:(void (^)(id responseObject))successBlock
                              failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 商品分类/科学饮食分类

- (void)queryItemsWithItemId:(NSString *)ItemId
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 商品列表，实现分页查询

- (void)queryProductsWithTypeId:(NSString *)typeId
                        pageNum:(NSString *)pageNum
                       pageSize:(NSString *)pageSize
                   successBlock:(void (^)(id responseObject))successBlock
                   failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 根据商品查询菜谱

- (void)queryrecipesWithProductId:(NSString *)productId
                          pageNum:(NSString *)pageNum
                         pageSize:(NSString *)pageSize
                     successBlock:(void (^)(id responseObject))successBlock
                     failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 菜谱详情

- (void)queryrecipeDetailWithRecipeId:(NSString *)recipeId
                         successBlock:(void (^)(id responseObject))successBlock
                         failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 获取商品评价

- (void)queryDiscussWithProductId:(NSString *)productId
                          pageNum:(NSString *)pageNum
                         pageSize:(NSString *)pageSize
                     successBlock:(void (^)(id responseObject))successBlock
                     failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 获取科学饮食列表

- (void)queryScienceDietsWithItemId:(NSString *)itemId
                            pageNum:(NSString *)pageNum
                           pageSize:(NSString *)pageSize
                       successBlock:(void (^)(id responseObject))successBlock
                       failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 获取科学饮食详细内容

- (void)queryScienceDietDetailWithScienceDietId:(NSString *)scienceDietId
                                   successBlock:(void (^)(id responseObject))successBlock
                                   failureBlock:(void (^)(id responseObject))failureBlock;

#pragma mark - 收藏

- (void)collectWithProductId:(NSString *)productId
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(id responseObject))failureBlock;

@end
