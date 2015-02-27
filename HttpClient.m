//
//  HttpClient.m
//  WenStore
//
//  Created by ccxdd on 14-6-2.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "HttpClient.h"

static NSString * const BaseURLString = @"http://api.isuperlife.com/api";

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
            DLogSuccss(@"%@", responseObject);
            success(responseObject);
        } else {
            DLogError(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.userInfo[@"NSLocalizedDescription"]) {
            [BMWaitVC showMessage:error.userInfo[@"NSLocalizedDescription"]];
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
            DLogSuccss(@"%@", responseObject);
            success(responseObject);
        } else {
            [BMWaitVC showMessage:responseObject[@"errors"]];
            DLogError(@"%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.userInfo[@"NSLocalizedDescription"]) {
            [BMWaitVC showMessage:error.userInfo[@"NSLocalizedDescription"]];
            DLogError(@"%@", error);
        }
    }];
}

- (void)productCategory:(void(^)(id responseObject))success
{
    [self GenericGET:@"ProductCategory" parameters:nil success:success];
}

@end
