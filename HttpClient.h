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

- (void)productCategory:(void(^)(id responseObject))success;

@end
