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
@property (nonatomic, strong) NSArray *numberFields;
@property (nonatomic, strong) NSArray *uploadFields;

+ (instancetype)classWithFields:(NSArray *)fields
                   numberFields:(NSArray *)numberFields
                   uploadFields:(NSArray *)uploadFields;

@end

@implementation BmobClassField

+ (instancetype)classWithFields:(NSArray *)fields
                   numberFields:(NSArray *)numberFields
                   uploadFields:(NSArray *)uploadFields
{
    BmobClassField *classField = [super alloc];
    if (classField) {
        classField.fields = fields;
        classField.numberFields = numberFields;
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
                    [responseArrayM addObject:[self convertBmobObj:obj className:obj.className]];
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
    [query whereKey:@"hidden" notEqualTo:@"1"];
    [query orderByAscending:@"createdAt"];
    [self query:query findWithSuccess:success];
}

+ (void)saveClassName:(NSString *)className
           parameters:(NSDictionary *)parameters
              success:(void(^)(id responseObject))success
{
    BmobClassField *classField = [self classFields][className];
    NSDictionary *normalFields = [parameters filterKeys:classField.fields non:NO];
    NSDictionary *numberFields = [parameters filterKeys:classField.numberFields non:NO];
    NSDictionary *uploadFields = [parameters filterKeys:classField.uploadFields non:NO];
    DLogSuccss(@"normalFields = %@", normalFields);
    BmobObject *object = [BmobObject objectWithoutDatatWithClassName:className objectId:parameters[@"objectId"]];
    [object saveAllWithDictionary:normalFields];
    [object saveAllWithDictionary:[numberFields valueToNSNumber]];
    
    [self uploadFields:uploadFields className:tCategory resultBlock:^(NSDictionary *files){
        DLogSuccss(@"files = %@", files);
        [object saveAllWithDictionary:files];
        if (parameters[@"objectId"]) {
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(object);
                } else {
                    [self errorHandle:error];
                }
            }];
        } else {
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success(object);
                } else {
                    [self errorHandle:error];
                }
            }];
        }
    }];
    
}

+ (void)deleteObjectId:(NSString *)objectId
             className:(NSString *)className
               success:(void(^)(id responseObject))success
{
    BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:className objectId:objectId];
    [obj setObject:@"1" forKey:@"hidden"];
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(@YES);
        } else {
            [self errorHandle:error];
        }
    }];
}

+ (void)uploadFields:(NSDictionary *)fields
           className:(NSString *)className
         resultBlock:(void(^)(NSDictionary *files))resultBlock
{
    if ([fields count]) {
        __block NSMutableDictionary *files = [NSMutableDictionary dictionary];
        __block NSInteger count = 0;
        [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self uploadPathOrData:obj className:className resultBlock:^(BmobFile *fileObj) {
                count++;
                [files setValue:fileObj forKeyPath:key];
                
                if (count == [fields count]) {
                    resultBlock(files);
                }
            }];
        }];
    } else {
        resultBlock(nil);
    }
}

+ (void)uploadDataArray:(NSArray *)dataArr
              className:(NSString *)className
            resultBlock:(void(^)(NSMutableArray *urlArr))resultBlock
{
    if ([dataArr count]) {
        __block NSMutableArray *urlArr = [NSMutableArray array];
        __block NSInteger count = 0;
        
        if ([[dataArr firstObject] isKindOfClass:[NSString class]] && [[dataArr firstObject] hasPrefix:@"http://"]) {
            resultBlock([NSMutableArray arrayWithArray:dataArr]);
        } else {
            [dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self uploadPathOrData:obj className:className resultBlock:^(BmobFile *fileObj) {
                    count++;
                    if (fileObj) {
                        [urlArr addObject:fileObj.url];
                    }
                    if (count == [dataArr count]) {
                        resultBlock(urlArr);
                    }
                }];
            }];
        }
        
    } else {
        resultBlock(nil);
    }
}

+ (void)uploadPathOrData:(id)obj
               className:(NSString *)className
             resultBlock:(void(^)(BmobFile *fileObj))resultBlock
{
    BmobFile *fileObj;
    
    if ([obj isKindOfClass:[NSString class]]) {
        fileObj = [[BmobFile alloc] initWithClassName:className
                                         withFilePath:obj];
    }
    else if ([obj isKindOfClass:[NSData class]]) {
        fileObj = [[BmobFile alloc] initWithClassName:className
                                         withFileName:@"file"
                                         withFileData:obj];
    }
    
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
}

#pragma mark - 转换BmobObject到NSDictionary -

+ (NSMutableDictionary *)convertBmobObj:(BmobObject *)BmobObj className:(NSString *)className
{
    __block NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    BmobClassField *classField = [self classFields][className];
    [mdict setValue:BmobObj.objectId forKey:@"objectId"];
    
    [classField.fields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mdict setValue:[self getObjFromBmob:[BmobObj objectForKey:obj]]
                 forKey:obj];
    }];
    
    [classField.numberFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *num = [BmobObj objectForKey:obj];
        if ([num isKindOfClass:[NSNumber class]]) {
            [mdict setValue:[num stringValue] forKey:obj];
        }
    }];
    
    [classField.uploadFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mdict setValue:[self getObjFromBmob:[BmobObj objectForKey:obj]]
                 forKey:obj];
    }];
    
    return mdict;
}

+ (id)getObjFromBmob:(id)obj
{
    if ([obj isKindOfClass:[BmobFile class]]) {
        return [obj url];
    }
    
    return obj;
}

+ (NSDictionary *)classFields
{
    static dispatch_once_t pred;
    static NSMutableDictionary *classFields;
    dispatch_once(&pred, ^{
        classFields = [NSMutableDictionary dictionary];
        
        classFields[tCategory] = [BmobClassField classWithFields:@[@"name", @"subList"]
                                                    numberFields:nil
                                                    uploadFields:@[@"imageFile"]];
        
        classFields[tSubCategory] = [BmobClassField classWithFields:@[@"name", @"productList"]
                                                       numberFields:nil
                                                       uploadFields:@[@"imageFile"]];
        
        classFields[tProduct] = [BmobClassField classWithFields:@[@"name",
                                                                  @"describe",
                                                                  @"saleDate",
                                                                  @"mode",
                                                                  @"madeIn",
                                                                  @"tags",
                                                                  @"images",
                                                                  @"weight"]
                                                   numberFields:@[@"price",
                                                                  @"discount",
                                                                  @"stock"]
                                                   uploadFields:nil];
    });
    
    return classFields;
}

+ (void)errorHandle:(NSError *)error
{
    NSString *message;
    DLogError(@"error = %@", error);
    
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
