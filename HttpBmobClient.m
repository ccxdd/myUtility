//
//  HttpBmobClient.m
//  WenStore
//
//  Created by ccxdd on 14-6-21.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "HttpBmobClient.h"
#import "BMWaitVC.h"

@implementation HttpBmobClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (void)query:(BmobQuery *)query findWithSuccess:(void(^)(id responseObject))success
{
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            
            NSMutableArray *responseArrayM = [NSMutableArray array];
            
            if ([array count] > 0) {
                for (BmobObject *obj in array) {
                    [responseArrayM addObject:[self convertObject:obj className:obj.className]];
                }
                
                success(responseArrayM);
                
            } else {
                [self errorHandle:nil];
            }
            
        } else {
            [self errorHandle:error];
        }
    }];
}

+ (void)queryWithClassName:(NSString *)className
                   success:(void(^)(id responseObject))success
{
    BmobQuery *query = [BmobQuery queryWithClassName:className];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            
            NSMutableArray *responseArrayM = [NSMutableArray array];
            
            if ([array count] > 0) {
                for (BmobObject *obj in array) {
                    [responseArrayM addObject:[self convertObject:obj className:className]];
                }
                
                success(responseArrayM);
                
            } else {
                [self errorHandle:nil];
            }
            
        } else {
            [self errorHandle:error];
        }
    }];
}

+ (void)categoryWithName:(NSString *)name
                filePath:(NSString *)filePath
                objectId:(NSString *)objectId
                     sub:(NSArray *)sub
                   isNew:(BOOL)isNew
                 success:(void(^)(id responseObject))success
{
    if (isNew) {
        BmobObject *object = [BmobObject objectWithClassName:tCategory];
        [self uploadFilePath:filePath className:tCategory resultBlock:^(BmobFile *fileObj){
            [object setObject:name forKey:@"name"];
            [object setObject:fileObj forKey:@"imageFile"];
            [object addUniqueObjectsFromArray:sub forKey:@"sub"];
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@YES);
                } else {
                    [self errorHandle:error];
                }
            }];
        }];
    } else {
        BmobObject *object = [BmobObject objectWithoutDatatWithClassName:tCategory objectId:objectId];
        [self uploadFilePath:filePath className:tCategory resultBlock:^(BmobFile *fileObj){
            [object setObject:name forKey:@"name"];
            [object setObject:fileObj forKey:@"imageFile"];
            [object addUniqueObjectsFromArray:sub forKey:@"sub"];
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@YES);
                } else {
                    [self errorHandle:error];
                }
            }];
        }];
    }
}

+ (void)subCategoryWithName:(NSString *)name
                   filePath:(NSString *)filePath
                   objectId:(NSString *)objectId
                       main:(NSArray *)main
                      isNew:(BOOL)isNew
                    success:(void(^)(id responseObject))success
{
    if (isNew) {
        BmobObject *object = [BmobObject objectWithClassName:tSubCategory];
        [self uploadFilePath:filePath className:tSubCategory resultBlock:^(BmobFile *fileObj){
            [object setObject:name forKey:@"name"];
            [object setObject:fileObj forKey:@"imageFile"];
            [object addUniqueObjectsFromArray:main forKey:@"main"];
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@YES);
                } else {
                    [self errorHandle:error];
                }
            }];
        }];
    } else {
        BmobObject *object = [BmobObject objectWithoutDatatWithClassName:tSubCategory objectId:objectId];
        [self uploadFilePath:filePath className:tSubCategory resultBlock:^(BmobFile *fileObj){
            [object setObject:name forKey:@"name"];
            [object setObject:fileObj forKey:@"imageFile"];
            [object addUniqueObjectsFromArray:main forKey:@"main"];
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@YES);
                } else {
                    [self errorHandle:error];
                }
            }];
        }];
    }
}

+ (void)uploadFilePath:(NSString *)path className:(NSString *)className
           resultBlock:(void(^)(BmobFile *fileObj))resultBlock
{
    if (path) {
        BmobFile *fileObj = [[BmobFile alloc] initWithClassName:className withFilePath:path];
        [fileObj saveInBackgroundByDataSharding:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                resultBlock(fileObj);
            } else {
                [self errorHandle:error];
            }
        }];
    } else {
        resultBlock(nil);
    }
    
}

+ (NSMutableDictionary *)convertObject:(BmobObject *)obj className:(NSString *)className
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"objectId"] = obj.objectId;
    dict[@"createdAt"] = obj.createdAt;
    dict[@"updatedAt"] = obj.updatedAt;
    
    if ([className isEqualToString:tCategory]) {           //分类
        
        dict[@"name"] = [obj objectForKey:@"name"];
        [self joinObj:[obj objectForKey:@"imageFile"] toContainer:dict key:@"imageFile"];
        [self joinObj:[obj objectForKey:@"sub"] toContainer:dict key:@"sub"];
        
    } else if ([className isEqualToString:tSubCategory]) { //子类
        
        dict[@"name"] = [obj objectForKey:@"name"];
        [self joinObj:[obj objectForKey:@"imageFile"] toContainer:dict key:@"imageFile"];
        [self joinObj:[obj objectForKey:@"main"] toContainer:dict key:@"main"];
    }
    
    return dict;
}

+ (void)joinObj:(id)obj toContainer:(id)container key:(NSString *)key
{
    if ([obj isKindOfClass:[BmobFile class]]) {
        if ([container isKindOfClass:[NSMutableDictionary class]] && key) {
            container[key] = [obj url];
        } else if ([container isKindOfClass:[NSMutableDictionary class]] && key) {
            [container addObject:[obj url]];
        }
    } else if (obj) {
        if ([container isKindOfClass:[NSMutableDictionary class]] && key) {
            container[key] = obj;
        } else if ([container isKindOfClass:[NSMutableDictionary class]] && key) {
            [container addObject:obj];
        }
    }
    
}

+ (void)errorHandle:(NSError *)error
{
    NSString *message;
    DLog(@"error = %@", error);
    
    switch (error.code) {
        case 20002: //
        {
            message = @"网络连接失败";
        }
            break;
        case 1: //
        {
        }
            break;
        case 2: //
        {
        }
            break;
        case 3: //
        {
        }
            break;
        case 4: //
        {
        }
            break;
            
        default:
            message = error ? error.userInfo[@"error"] : @"无查询结果";
            break;
    }
    
    [BMWaitVC showMessage:message];
}

@end
