//
//  NSString+DDString.m
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-29.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "NSString+DDString.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (DDString)

+ (NSString *)versionString
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildString
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)fromInt:(NSInteger)intValue
{
    return [NSString stringWithFormat:@"%ld", (long)intValue];
}

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

- (NSURL *)toURL
{
    return [NSURL URLWithString:self];
}

- (void)openURLWithMessage:(NSString *)message
{
    if (message) {
        [BMWaitVC showAlertMessage:message alertBlock:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                [[UIApplication sharedApplication] openURL:[self toURL]];
            }
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[self toURL]];
    }
}

- (NSURLRequest *)toRequest
{
    return [NSURLRequest requestWithURL:[self toURL]];
}

- (NSData *)toData
{
    return  [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)toJSON
{
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if (!error) {
        return jsonObject;
    }
    
    return nil;
}

- (NSString *)addPrefix:(NSString *)string;
{
    if (self.length > 0) {
        return [NSString stringWithFormat:@"%@%@", string, self];
    }
    
    return @"";
}

- (NSString *)addSuffix:(NSString *)string
{
    if (self.length > 0) {
        return [NSString stringWithFormat:@"%@%@", self, string];
    }
    return @"";
}

- (NSString *)delString:(NSString *)string
{
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}

- (NSString *)filterToNumberString
{
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
}

- (void)toPasteboard
{
    [[UIPasteboard generalPasteboard] setString:self];
}

- (BOOL)inArray:(NSArray *)arr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", self];
    NSArray *resultArr = [arr filteredArrayUsingPredicate:predicate];
    
    return [resultArr count] > 0;
}

- (BOOL)inArray:(NSArray *)arr forKey:(NSString *)key
{
    return [arr filterKey:key equal:self].count > 0;
}

- (void)inArray:(NSArray *)arr
            key:(NSString *)key
     completion:(void(^)(NSInteger index))completion
{
    id item = [[arr filterKey:key equal:self] firstObject];
    NSUInteger index = [arr indexOfObject:item];
    
    if (completion) {
        completion(index == NSNotFound ? -1 : index);
    }
}

+ (NSString *)documentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

- (BOOL)isExistFile
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:self isDirectory:&isDir];
    
    return existed;
}

- (BOOL)deleteFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager removeItemAtPath:self error:nil];
}

- (NSString *)stringToIndex:(NSUInteger)to
{
    if (self.length > to) {
        return [self substringToIndex:to];
    } else {
        return @"";
    }
}

- (NSString *)stringFromIndex:(NSUInteger)from;
{
    if (self.length > from) {
        return [self substringFromIndex:from];
    } else {
        return @"";
    }
}

- (NSString *)insert:(NSString *)string index:(NSUInteger)index
{
    if (self.length > index) {
        return [[[self stringToIndex:index] addSuffix:string] addSuffix:[self stringFromIndex:index]];
    } else {
        return @"";
    }
}

- (NSString *)replaceFrom:(NSUInteger)from to:(NSUInteger)to with:(NSString *)string
{
    if (to > from && self.length > to ) {
        NSString *sub = [self substringWithRange:NSMakeRange(from, to-from)];
        return [self stringByReplacingOccurrencesOfString:sub withString:string];
    } else {
        return @"";
    }
}

- (NSString *)thousandSeparator:(BOOL)decimal
{
    if (self.length > 3) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:decimal?@"###,##0.00":@"###,###"];
        NSString *formattedNumberString = [numberFormatter stringFromNumber:@([self doubleValue])];
        return formattedNumberString;
    } else {
        return self;
    }
}

- (NSString *)toChinaDigital
{
    if ([self isInteger]) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.locale = locale;
        numberFormatter.numberStyle = NSNumberFormatterSpellOutStyle;
        return [numberFormatter stringFromNumber:[self toNSNumber]];
    } else {
        return self;
    }
}

- (NSNumber *)toNSNumber
{
    return @([self doubleValue]);
}

- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

- (NSString *)yyyymmdd
{
    return [self yyyymmdd:@"-"];
}

- (NSString *)yyyymmdd:(NSString *)separator
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
    NSDate *date = [dateFormatter dateFromString:self];
    if (date) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd", separator, separator]];
        NSString *resultStr = [dateFormatter stringFromDate:date];
        return resultStr.length ? resultStr : self;
    } else if (self.isInteger && self.length == 8) {
        return [[self insert:separator index:4] insert:separator index:7];
    }
    
    return self;
}

- (NSString *)dateFormat:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
    NSDate *date = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:formatter];
    NSString *resultStr = [dateFormatter stringFromDate:date];
    return resultStr.length ? resultStr : self;
}

- (BOOL)isNumberic
{
    return [self isDouble];
}

- (BOOL)isInteger
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    NSInteger var;
    return ([scan scanInteger:&var]) && [scan isAtEnd];
}

- (BOOL)isDouble
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    double var;
    return ([scan scanDouble:&var]) && [scan isAtEnd];
}

- (BOOL)isFloat
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    float var;
    return ([scan scanFloat:&var]) && [scan isAtEnd];
}

- (NSString *)encryptUseSHA1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

+ (NSString *)currentDateTime:(NSInteger)timeType
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (timeType == 24) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else if (timeType == 12) {
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
    NSString *str = [df stringFromDate:[NSDate date]];
    return str;
}

+ (NSString *)currentTime:(NSInteger)timeType
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (timeType == 24) {
        [df setDateFormat:@"HH:mm:ss"];
    } else if (timeType == 12) {
        [df setDateFormat:@"hh:mm:ss"];
    }
    NSString *str = [df stringFromDate:[NSDate date]];
    return str;
}

+ (NSString *)currentDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [df stringFromDate:[NSDate date]];
    return str;
}

+ (NSString *)dateFromTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%.0f", a];
}

+ (NSString *)dateFromTimestampInterval:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSTimeInterval a = [date timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%.0f", a];
}

+ (NSString *)dateFrom13lenTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%.0f", a];
}

- (BOOL)isValidMobile
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isValidEmail
{
    if (!self) {
        return NO;
    }
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:self
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, self.length)];
    if(numberofMatch > 0)
    {
        //DLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    
    //DLog(@"%@ isNumbericString: NO", str);
    return NO;
}

/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
+ (NSString *)generateRandomOfNum:(NSInteger)num
{
    const NSInteger N = num;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < N; i++)
    {
        unsigned index = arc4random() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

- (CGSize)calcSizeFromFont:(UIFont *)font width:(NSInteger)width
{
    CGSize calcSize = CGSizeMake(width,MAXFLOAT);
    CGSize labelsize = CGSizeZero;
    
    if (IOS7_OR_LATER) {
        labelsize = [self boundingRectWithSize:calcSize
                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil].size;
    } else {
        labelsize = [self sizeWithFont:font constrainedToSize:calcSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return labelsize;
}

- (NSAttributedString *)toFont:(UIFont *)font color:(UIColor *)color
{
    NSString *attribText = self;
    UIColor *attribColor = color ? color : [UIColor blackColor];
    NSRange attribRange  = NSMakeRange(0, self.length);
    UIFont *attribFont   = font ? font : [UIFont systemFontOfSize:14];
    
    NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:attribText];
    
    [attribString addAttributes:@{
                                  NSForegroundColorAttributeName : attribColor,
                                  NSFontAttributeName : attribFont
                                  }
                          range:attribRange];
    
    return attribString;
}

@end
