//
//  QiniuSimpleUploader.m
//  QiniuSimpleUploader
//
//  Created by Qiniu Developers 2013
//

#import "QiniuConfig.h"
#import "QiniuSimpleUploader.h"
#import "QiniuUtils.h"
#import "QiniuHttpClient.h"

#define kQiniuUserAgent  @"qiniu-ios-sdk"

@interface QiniuSimpleUploader ()
//@property(nonatomic,copy)NSString *filePath;
//@property(nonatomic,assign)uint64_t *fileSize;
//@property(nonatomic,assign)uint64_t *sentBytes;
@end

// ------------------------------------------------------------------------------------------

@implementation QiniuSimpleUploader

+ (id) uploaderWithToken:(NSString *)token {
    return [[self alloc] initWithToken:token];
}

// Must always override super's designated initializer.
- (id)init {
    return [self initWithToken:nil];
}

- (id)initWithToken:(NSString *)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (void) uploadFile:(NSString *)filePath
                key:(NSString *)key
              extra:(QiniuPutExtra *)extra
{
    [QiniuClient uploadFile:filePath
                        key:key
                      token:self.token
                      extra:extra progress:^(float percent) {
                        if ([self.delegate respondsToSelector:@selector(uploadProgressUpdated:percent:)]) {
                          [self.delegate uploadProgressUpdated:filePath percent:percent];
                        }
    } complete:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            [self.delegate uploadFailed:filePath error:error];
        }else{
            NSDictionary *resp = operation.responseObject;
            [self.delegate uploadSucceeded:filePath ret:resp];
        }
    }];
    
}

+ (void) uploadFile:(NSString *)filePath
                key:(NSString *)key
              extra:(QiniuPutExtra *)extra
            success:(void(^)(id response))success
            failure:(void(^)(NSError *error))failure
{
    [QiniuClient uploadFile:filePath
                        key:key
                      token:[self getToken]
                      extra:extra progress:^(float percent) {
                          
                      } complete:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (error) {
                              DLogError(@"%@", error);
                              failure(error);
                          } else {
                              NSDictionary *resp = operation.responseObject;
                              DLogGreen(@"%@", resp);
                              success(resp);
                          }
                      }];
}

#pragma mark - genToken

+ (NSString *)getToken
{
    NSString *AK = @"HjJEmgOzCyib7qsoO_W28r7QneTdtxcKIqNBMJ0-";
    NSString *SK = @"v8km7-3G3b8_sO0osjzuS-jwe5RxKdUr8raom1Dx";
    NSString *deadline = [Utility dateFromTimestampInterval:MN_HOUR * 5];
    NSString *putPolicy = [@{@"scope": @"ccxdd", @"deadline": @([deadline integerValue])} JSONString];
    NSString *encodedPutPolicy = [GTMBase64 stringByWebSafeEncodingData:[putPolicy dataUsingEncoding:NSUTF8StringEncoding] padded:YES];
    NSString *sign = [Utility hmacSHA1:encodedPutPolicy secret:SK];
    NSString *uploadToken = [NSString stringWithFormat:@"%@:%@:%@", AK, sign, encodedPutPolicy];
    
    return uploadToken;
}

+ (NSString *)getFileName
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *str = [df stringFromDate:[NSDate date]];
    NSString *num = [Utility generateRandomOfNum:48-str.length];
    
    return [NSString stringWithFormat:@"%@%@", str, num];
}

@end

