//
//  HttpClient.m
//  WenStore
//
//  Created by ccxdd on 14-6-2.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "HttpClient.h"

static NSString * const BaseURLString = @"http://localhost:8000";

@implementation HttpClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static HttpClient *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    return _sharedObject;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

#pragma mark - Generic GET

- (void)GenericGET:(NSString *)URLString
        parameters:(id)parameters
           success:(void(^)(id responseObject))success
{
    [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"success"] integerValue]) {
            DLogGreen(@"%@", responseObject);
            success(responseObject);
        } else {
            DLogError(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.userInfo[@"NSLocalizedDescription"]) {
            [BMWaitVC showMessage:error.userInfo[@"NSLocalizedDescription"]
                       afterDelay:2];
            DLogError(@"%@", error);
        }
    }];
}

#pragma mark - Generic POST

- (void)GenericPOST:(NSString *)URLString
         parameters:(id)parameters
            success:(void(^)(id responseObject))success
{
    [self POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"success"] integerValue]) {
            DLogGreen(@"%@", responseObject);
            success(responseObject);
        } else {
            [BMWaitVC showMessage:responseObject[@"errors"]
                       afterDelay:2];
            DLogError(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.userInfo[@"NSLocalizedDescription"]) {
            [BMWaitVC showMessage:error.userInfo[@"NSLocalizedDescription"]
                       afterDelay:2];
            DLogError(@"%@", error);
        }
    }];
}

#pragma mark - 注册

- (void)userRegisterWithUserName:(NSString *)userName
                        nickName:(NSString *)nickName
                        password:(NSString *)password
                         success:(void(^)(id responseObject))success
{
    NSDictionary *parameters = @{@"userName": userName,
                                 @"nickName": nickName,
                                 @"password": password};
    
    [self GenericPOST:@"user_reg" parameters:parameters success:success];
}

#pragma mark - 登录

- (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
                      success:(void(^)(id responseObject))success
{
    NSDictionary *parameters = @{@"userName": userName,
                                 @"password": password};
    
    [self GenericPOST:@"user_login" parameters:parameters success:success];
}


@end
