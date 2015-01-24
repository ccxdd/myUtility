//
//  HttpBmobClient.m
//  WenStore
//
//  Created by ccxdd on 14-6-21.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "HttpBmobClient.h"
#import "BMWaitVC.h"

#pragma mark - BmobClassField －

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

#pragma mark - HttpBmobClient －

@implementation HttpBmobClient

#pragma mark - 查询

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
                showHidden:(BOOL)showHidden
                   success:(void(^)(id responseObject))success
{
    [self queryWithClassName:className showHidden:showHidden limit:0 success:success];
}

+ (void)queryWithClassName:(NSString *)className
                showHidden:(BOOL)showHidden
                     limit:(NSUInteger)limit
                   success:(void(^)(id responseObject))success
{
    [self queryWithClassName:className showHidden:showHidden selectKeys:nil limit:limit success:success];
}

+ (void)queryWithClassName:(NSString *)className
                showHidden:(BOOL)showHidden
                selectKeys:(NSArray *)selectKeys
                     limit:(NSUInteger)limit
                   success:(void(^)(id responseObject))success
{
    BmobQuery *query = [BmobQuery queryWithClassName:className];
    if (limit > 0) {
        query.limit = limit;
    }
    if (!showHidden) {
        [query whereKey:@"hidden" notEqualTo:@"1"];
    }
    if (selectKeys) {
        [query selectKeys:selectKeys];
    }
    [query orderByDescending:@"updatedAt"];
    [self query:query findWithSuccess:success];
}

+ (void)queryWithObjectId:(NSString *)objectId
                className:(NSString *)className
                  success:(void(^)(id responseObject))success
{
    BmobQuery *query = [BmobQuery queryWithClassName:className];
    [query whereKey:kObjectID equalTo:objectId];
    [self query:query findWithSuccess:^(id responseObject) {
        if (success) {
            success(responseObject[0]);
        }
    }];
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
    BmobObject *object = [BmobObject objectWithoutDatatWithClassName:className objectId:parameters[kObjectID]];
    [object saveAllWithDictionary:normalFields];
    [object saveAllWithDictionary:[numberFields valueToNSNumber]];
    
    [self uploadFields:uploadFields className:className resultBlock:^(NSDictionary *files){
        DLogSuccss(@"files = %@", files);
        [object saveAllWithDictionary:files];
        if (parameters[kObjectID]) {
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success([self convertBmobObj:object className:className]);
                } else {
                    [self errorHandle:error];
                }
            }];
        } else {
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    success([self convertBmobObj:object className:className]);
                } else {
                    [self errorHandle:error];
                }
            }];
        }
    }];
    
}

#pragma mark - API

+ (void)apiWithName:(NSString *)name success:(void(^)(id responseObject))success
{
    [self queryWithClassName:name showHidden:NO success:^(id responseObject) {
        if (success) {
            success(responseObject[0]);
        }
    }];
}

+ (void)apiWithName:(NSString *)name selectKeys:(NSArray *)selectKeys success:(void(^)(id responseObject))success
{
    [self queryWithClassName:name showHidden:NO selectKeys:selectKeys limit:0 success:^(id responseObject) {
        if (success) {
            success(responseObject[0]);
        }
    }];
}

+ (void)updateAPI:(NSString *)apiName
              key:(NSString *)key
            value:(id)value
          success:(void(^)(id responseObject))success
{
    [self queryWithClassName:apiName showHidden:YES limit:1 success:^(id responseObject) {
        NSMutableDictionary *parameters = [@{key:value} mutableCopy];
        [parameters setValue:responseObject[0][kObjectID] forKey:kObjectID];
        [self saveClassName:apiName parameters:parameters success:success];
    }];
}

+ (void)apiToHomeCompletion:(void(^)(id responseObject))completion
{
    [self apiWithName:API_StoreHomePage success:^(NSMutableDictionary *homeDict) {
        NSArray *productSection = [homeDict[@"recommendList"] valueForKeyPath:@"productList"];
        NSMutableArray *product_id_array = [NSMutableArray array];
        for (NSArray *list in productSection) {
            [product_id_array addObjectsFromArray:list];
        }
        
        BmobQuery *query = [BmobQuery queryWithClassName:tProduct];
        [query whereKey:kObjectID containedIn:product_id_array];
        [query whereKey:@"hidden" notEqualTo:@"1"];
        [self query:query findWithSuccess:^(NSMutableArray *productList) {
            
            for (NSInteger i = 0; i < productSection.count; i++) {
                homeDict[@"recommendList"][i][@"productInfoList"] = [productList filterKey:kObjectID equal:productSection[i]];
            }
            
            if (completion) {
                completion(homeDict);
            }
        }];
        
    }];
}

#pragma mark - 隐藏记录

+ (void)hiddenObjectId:(NSString *)objectId
             boolValue:(BOOL)boolValue
             className:(NSString *)className
               success:(void(^)(id responseObject))success
{
    BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:className objectId:objectId];
    [obj setObject:boolValue ? @"1" : @"0" forKey:@"hidden"];
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            success(@YES);
        } else {
            [self errorHandle:error];
        }
    }];
}

#pragma mark - 上传

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
    [mdict setValue:BmobObj.objectId forKey:kObjectID];
    
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

#pragma mark - classFields

+ (NSDictionary *)classFields
{
    static dispatch_once_t pred;
    static NSMutableDictionary *classFields;
    dispatch_once(&pred, ^{
        classFields = [NSMutableDictionary dictionary];
        
        classFields[tCategory] = [BmobClassField classWithFields:@[@"name", @"subList", @"hidden"]
                                                    numberFields:nil
                                                    uploadFields:@[@"imageFile"]];
        
        classFields[tSubCategory] = [BmobClassField classWithFields:@[@"name", @"productList", @"hidden"]
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
        classFields[API_StoreHomePage] = [BmobClassField classWithFields:@[@"advert",
                                                                           @"categoryList",
                                                                           @"recommendList"]
                                                            numberFields:nil
                                                            uploadFields:nil];
        
        classFields[tTag] = [BmobClassField classWithFields:@[@"name",
                                                              @"showHome",
                                                              @"productList"]
                                               numberFields:@[@"homeCount"]
                                               uploadFields:nil];
        
        classFields[tOrder] = [BmobClassField classWithFields:@[@"contentList",
                                                                @"state",
                                                                @"discount",
                                                                @"address"]
                                                 numberFields:nil
                                                 uploadFields:nil];
    });
    
    return classFields;
}

#pragma mark - errorHandle:

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
        case 100: //
        {
            message = @"服务器正忙请稍等";
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
