//
//  HttpBmobClient.m
//  WenStore
//
//  Created by ccxdd on 14-6-21.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "HttpBmobClient.h"
#import "BMWaitVC.h"

@interface BmobClassField : NSObject

@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) NSArray *uploadFields;

+ (instancetype)classWithFields:(NSArray *)fields uploadFields:(NSArray *)uploadFields;

@end

@implementation BmobClassField

+ (instancetype)classWithFields:(NSArray *)fields uploadFields:(NSArray *)uploadFields
{
    BmobClassField *classField = [super alloc];
    if (classField) {
        classField.fields = fields;
        classField.uploadFields = uploadFields;
    }
    return classField;
}

@end

@implementation HttpBmobClient

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
    [self query:query findWithSuccess:success];
}

+ (void)saveClassName:(NSString *)className
           parameters:(NSDictionary *)parameters
              success:(void(^)(id responseObject))success
{
    BmobClassField *classField = [self classFields][className];
    NSDictionary *normalFields = [parameters filterWithKeys:classField.fields non:NO];
    NSDictionary *uploadFields = [parameters filterWithKeys:classField.uploadFields non:NO];
    
    BmobObject *object = [BmobObject objectWithoutDatatWithClassName:className objectId:normalFields[@"objectId"]];
    [object saveAllWithDictionary:normalFields];
    
    [self uploadFields:uploadFields className:tCategory resultBlock:^(NSDictionary *files){
        [object saveAllWithDictionary:files];
        if (normalFields[@"objectId"]) {
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@YES);
                } else {
                    [self errorHandle:error];
                }
            }];
        } else {
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(@YES);
                } else {
                    [self errorHandle:error];
                }
            }];
        }
    }];
    
}

+ (void)uploadFields:(NSDictionary *)fields
           className:(NSString *)className
         resultBlock:(void(^)(NSDictionary *files))resultBlock
{
    if ([fields count]) {
        __block NSMutableDictionary *files = [NSMutableDictionary dictionary];
        
        [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self uploadFilePath:obj className:className resultBlock:^(BmobFile *fileObj) {
                [files setValue:fileObj forKeyPath:key];
                
                if ([files count] == [fields count]) {
                    resultBlock(files);
                }
            }];
        }];
    } else {
        resultBlock(nil);
    }
}

+ (void)uploadFilePath:(NSString *)path
             className:(NSString *)className
           resultBlock:(void(^)(BmobFile *fileObj))resultBlock
{
    if (path) {
        BmobFile *fileObj = [[BmobFile alloc] initWithClassName:className
                                                   withFilePath:path];
        [fileObj saveInBackground:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                resultBlock(fileObj);
            } else {
                [self errorHandle:error];
            }
        } withProgressBlock:^(float progress) {
            DLog(@"%@ : progress = %f", className, progress);
            [BMWaitVC showProgress:progress message:nil];
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
        
        [dict setValue:[obj objectForKey:@"name"] forKey:@"name"];
        [dict setValue:[obj objectForKey:@"sub"] forKey:@"sub"];
        [dict setValue:[self getObjFromBmob:[obj objectForKey:@"imageFile"]]
                forKey:@"imageFile"];;
        
    } else if ([className isEqualToString:tSubCategory]) { //子类
        
        [dict setValue:[obj objectForKey:@"name"] forKey:@"name"];
        [dict setValue:[self getObjFromBmob:[obj objectForKey:@"imageFile"]]
                forKey:@"imageFile"];
    }
    
    return dict;
}

+ (id)getObjFromBmob:(id)obj
{
    if ([obj isKindOfClass:[BmobFile class]]) {
        return [obj url];
    }
    
    return nil;
}

+ (NSDictionary *)classFields
{
    static dispatch_once_t pred;
    static NSMutableDictionary *classFields;
    dispatch_once(&pred, ^{
        classFields = [NSMutableDictionary dictionary];
        
        classFields[tCategory] = [BmobClassField classWithFields:@[@"objectId", @"name", @"sub"]
                                                    uploadFields:@[@"imageFile"]];
        
        classFields[tSubCategory] = [BmobClassField classWithFields:@[@"objectId", @"name"]
                                                       uploadFields:@[@"imageFile"]];
    });
    
    return classFields;
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
