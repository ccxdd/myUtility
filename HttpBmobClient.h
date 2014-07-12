//
//  HttpBmobClient.h
//  WenStore
//
//  Created by ccxdd on 14-6-21.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface HttpBmobClient : NSObject

+ (void)query:(BmobQuery *)query findWithSuccess:(void(^)(id responseObject))success;

+ (void)queryWithClassName:(NSString *)className
                   success:(void(^)(id responseObject))success;

+ (void)saveClassName:(NSString *)className
           parameters:(NSDictionary *)parameters
              success:(void(^)(id responseObject))success;

+ (void)uploadFields:(NSDictionary *)fields
           className:(NSString *)className
         resultBlock:(void(^)(NSDictionary *files))resultBlock;

+ (void)uploadFilePath:(NSString *)path
             className:(NSString *)className
           resultBlock:(void(^)(BmobFile *fileObj))resultBlock;

@end
