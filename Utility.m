//
//  Utility.m
//
//  Created by ccxdd on 10-12-29.
//  Copyright 2013 ccxdd. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
//#import "FMPTripleDES.h"
//#import "FMPHexUtil.h"
//#import "GTMBase64.h"

UIImage * getImageAtRect(UIImage *source,CGRect clipRect){
	UIGraphicsBeginImageContext(clipRect.size);
	[source drawAtPoint:CGPointMake(-clipRect.origin.x, -clipRect.origin.y)];
	UIImage *dest=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return dest;
}
@implementation Utility

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static NSMutableDictionary *executeBlockDict;

#define gIv @"01234567"

/**
 *  3DES加密
 *
 *  @param plainText 需要加密的明文
 *  @param key       key
 *
 *  @return 加密后密文
 */
//+ (NSString *)encryptUse3DES:(NSString *)plainText key:(NSString *)key
//{
//    const void *vplainText;
//    size_t plainTextBufferSize;
//
//    //NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    NSData* data = [FMPHexUtil unhex:plainText];
//    plainTextBufferSize = [data length];
//    vplainText = (const void *)[data bytes];
//
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
//
//    const void *vkey = (const void *)[key UTF8String];//[DESKEY UTF8String];
//    // NSString *initVec = @"init Vec";
//    //const void *vinitVec = (const void *) [initVec UTF8String];
//    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
//    ccStatus = CCCrypt(kCCEncrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       vkey,
//                       kCCKeySize3DES,
//                       nil,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    //if (ccStatus == kCCSuccess) DLog(@"SUCCESS");
//    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
//     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
//     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
//     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
//     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
//     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
//
//
//
//    //NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//    //NSString *result = [GTMBase64 stringByEncodingData:myData];
//    NSString *result = [FMPHexUtil hex:nil withBytes:bufferPtr length:movedBytes];
//
//    return result;
//
//    //    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    //    size_t plainTextBufferSize = [data length];
//    //    const void *vplainText = (const void *)[data bytes];
//    //
//    //    CCCryptorStatus ccStatus;
//    //    uint8_t *bufferPtr = NULL;
//    //    size_t bufferPtrSize = 0;
//    //    size_t movedBytes = 0;
//    //
//    //    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    //    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    //    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    //
//    //    const void *vkey = (const void *) [key UTF8String];
//    //    const void *vinitVec = (const void *) [gIv UTF8String];
//    //
//    //    ccStatus = CCCrypt(kCCEncrypt,
//    //                       kCCAlgorithm3DES,
//    //                       kCCOptionPKCS7Padding,
//    //                       vkey,
//    //                       kCCKeySize3DES,
//    //                       vinitVec,
//    //                       vplainText,
//    //                       plainTextBufferSize,
//    //                       (void *)bufferPtr,
//    //                       bufferPtrSize,
//    //                       &movedBytes);
//    //
//    //    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//    //    NSString *result = [GTMBase64 stringByEncodingData:myData];
//    //    return result;
//}
//
///**
// *  3DES解密
// *
// *  @param encryptText 加密文
// *  @param key         key
// *
// *  @return 解密后的明文
// */
//+ (NSString *)decryptUse3DES:(NSString *)encryptText key:(NSString *)key
//{
//    const void *vplainText;
//    size_t plainTextBufferSize;
//
//    //NSData *EncryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
//    NSData *EncryptData = [FMPHexUtil unhex:encryptText];
//    plainTextBufferSize = [EncryptData length];
//    vplainText = [EncryptData bytes];
//
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
//
//    const void *vkey = (const void *)[key UTF8String];//[DESKEY UTF8String];
//    // NSString *initVec = @"init Vec";
//    //const void *vinitVec = (const void *) [initVec UTF8String];
//    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
//    ccStatus = CCCrypt(kCCDecrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       vkey,
//                       kCCKeySize3DES,
//                       nil,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    //if (ccStatus == kCCSuccess) DLog(@"SUCCESS");
//    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
//     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
//     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
//     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
//     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
//     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
//
//
//    //    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
//    //                                                                     length:(NSUInteger)movedBytes]
//    //                                             encoding:NSUTF8StringEncoding];
//
//    NSString *result = [FMPHexUtil hex:nil withBytes:bufferPtr length:movedBytes];
//
//    return result;
//}

//+ (NSString *)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
//{
//    const void *vplainText;
//    size_t plainTextBufferSize;
//
//    if (encryptOrDecrypt == kCCDecrypt)//解密
//    {
//        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
//        plainTextBufferSize = [EncryptData length];
//        vplainText = [EncryptData bytes];
//    }
//    else //加密
//    {
//        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//        plainTextBufferSize = [data length];
//        vplainText = (const void *)[data bytes];
//    }
//
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
//
//    const void *vkey = (const void *)[DESKEY UTF8String];
//    // NSString *initVec = @"init Vec";
//    //const void *vinitVec = (const void *) [initVec UTF8String];
//    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
//    ccStatus = CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       vkey,
//                       kCCKeySize3DES,
//                       nil,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    //if (ccStatus == kCCSuccess) DLog(@"SUCCESS");
//    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
//     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
//     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
//     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
//     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
//     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
//
//    NSString *result;
//
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
//                                                               length:(NSUInteger)movedBytes]
//                                       encoding:NSUTF8StringEncoding];
//    }
//    else
//    {
//        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//        result = [GTMBase64 stringByEncodingData:myData];
//    }
//
//    return result;
//}

//sha1加密方式
+ (NSString *)encryptUseSHA1:(NSString *)srcString
{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

//-(NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
//{
//    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
//    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
//    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
//    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
//    for (int i = 0; i < HMACData.length; ++i){
//        [HMAC appendFormat:@"%02x", buffer[i]];
//    }
//    return HMAC;
//}

//+ (NSString *)hmacSHA1:(NSString *)plant secret:(NSString *)key
//{
//    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [plant cStringUsingEncoding:NSASCIIStringEncoding];
//
//    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
//
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//
//    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
//
//    NSString *hash = [GTMBase64 stringByWebSafeEncodingData:HMACData padded:YES];
//
//    return hash;
//}

/**
 *  字符串转换到byte
 *
 *  @param srcString 要转换的字符串
 *
 *  @return 转换好后的byte
 */
+ (Byte *)string2Byte:(NSString *)srcString
{
    NSData *strData = [srcString dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger len = strData.length;
    Byte *byteData = (Byte*)malloc(strData.length);
    memcpy(byteData, [strData bytes], len);
    
    return byteData;
}

+ (NSString *)stringFromByte:(Byte)byteVal
{
    NSMutableString *str = [NSMutableString string];
    
    //取高四位
    Byte byte1 = byteVal>>4;
    //取低四位
    Byte byte2 = byteVal & 0xf;
    //拼接16进制字符串
    [str appendFormat:@"%X",byte1];
    [str appendFormat:@"%X",byte2];
    return str;
}

/**
 *  Data类型转Hex字符串
 *
 *  @param data 要转换的Data
 *
 *  @return 转换后的16进制
 */
+ (NSString *)hexStringFromData:(NSData *)data
{
    NSMutableString *str = [NSMutableString string];
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        // byte+i为指针
        [str appendString:[self stringFromByte:*(byte+i)]];
    }
    return str;
}

/**
 *  Hex字符串转Data
 *
 *  @param hexStr 要转换的Hex字符串
 *
 *  @return 转换后的Data
 */
+ (NSData *)dataFromHexString:(NSString *)hexStr
{
    //    if (hexStr.length%2 != 0) {
    //        return nil;
    //    }
    //    NSMutableData *data = [NSMutableData data];
    //    for (int i = 0 ; i<hexStr.length/2; i++) {
    //        NSString *str = [hexStr substringWithRange:NSMakeRange(i*2,2)];
    //        NSScanner *scanner = [NSScanner scannerWithString:str];
    //        int intValue;
    //        [scanner scanInt:&intValue];
    //        [data appendBytes:&intValue length:1];
    //    }
    //    return data;
    
    int j=0;
    Byte bytes[hexStr.length];
    for(int i=0;i<[hexStr length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexStr characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexStr characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [NSData dataWithBytes:bytes length:hexStr.length/2];
    
    return newData;
}

/**
 *  byte转字符串
 *
 *  @param bytes  要转换的byte
 *  @param length byte的长度
 *
 *  @return 转换好后的字符串
 */
+ (NSString *)byte2String:(Byte *)bytes length:(NSInteger)length
{
    NSData *data = [NSData dataWithBytes:bytes length:length];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //return [NSString stringWithUTF8String:(const char *)bytes];
}

/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text
{
    if (text.length == 0)
        return @"";
    
    char *characters = malloc(text.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    int end = text.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[text bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == text.length - 2)
    {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == text.length - 1)
    {
        int d = ((int)(((char *)[text bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
}

/**
 字节转化为16进制数
 */
+ (NSString *)byte2HexString:(Byte *) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    //DLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}

/**
 字节数组转化16进制数
 */
+ (NSString *)byteArray2HexString:(Byte[])bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    //DLog(@"bytes 的16进制数为:%@",hexStr);
    return [hexStr uppercaseString];
}

/*
 将16进制数据转化成NSData 数组
 */
+ (NSData *)hexString2Data:(NSString*)hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [NSData dataWithBytes:bytes length:hexString.length/2];
    DLog(@"newData=%@",newData);
    return newData;
}

+ (NSString *)decodeString:(NSString *)string{
	return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(NSString *)dictionaryToMD5String:(NSDictionary *)dictionary appSecret:(NSString *)secret{
	NSArray *array=[[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSMutableString *str=[[NSMutableString alloc] initWithCapacity:0];
	[str appendString:secret];
	for(id obj in array){
		
		[str appendFormat:@"%@%@",obj,[dictionary objectForKey:obj]];
	}
	[str appendString:secret];
#if DEBUG
	DLog(@"string before MD5:  %@",str);
#endif
    NSString *md5=[Utility stringWithMD5:str];
	return md5;
	
}

/**
 *  字符到16进制
 *
 *  @param str 要转的字符
 *
 *  @return 16进制字符
 */
+ (NSString *)stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

+ (NSString *)encodeString:(NSString *)string
{
    //(CFStringRef)@";/?:@&=$+<>{},"
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                             (CFStringRef)string,
                                                                                             NULL,
                                                                                             (CFStringRef)@";/?:@&=$+<>,",
                                                                                             kCFStringEncodingUTF8));
	//NSString *result=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return result;
}


+ (NSString *)stringWithMD5:(NSString *)source{
	
	
    //	const char *cStr = [source UTF8String];
    //    unsigned char result[32];
    //    CC_MD5( cStr, strlen(cStr), result );
    //    return [NSString stringWithFormat:
    //            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
    //            result[0], result[1], result[2], result[3],
    //            result[4], result[5], result[6], result[7],
    //            result[8], result[9], result[10], result[11],
    //            result[12], result[13], result[14], result[15]
    //            ];
    
    const char *cStr = [source UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)UpperCaseStringWithMD5:(NSString *)source{
	return [[Utility stringWithMD5:source] uppercaseString];
}

+ (NSDateFormatter *)_HTTPDateFormatter
{
    // Returns a formatter for dates in HTTP format (i.e. RFC 822, updated by RFC 1123).
    // e.g. "Sun, 06 Nov 1994 08:49:37 GMT"
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //    NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh" ];
    //    [dateFormatter setLocale:locale];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	return dateFormatter;
}

+ (NSString *)chinaDateWith:(NSString *)htmlDateString {
    NSDate *date = [self stringToDate:htmlDateString];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    NSInteger y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)y, (long)m, (long)d];
}

+ (NSDateFormatter *)_HTTPDateFormatterHasTime
{
    // Returns a formatter for dates in HTTP format (i.e. RFC 822, updated by RFC 1123).
    // e.g. "Sun, 06 Nov 1994 08:49:37 GMT"
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //    NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"e" ];
    //    [dateFormatter setLocale:locale];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	return dateFormatter;
}

/**
 *  返回系统当前时间 yyyy-MM-dd HH:mm:ss
 *  type 12, 24
 */
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

/**
 *  返回系统当前时间 HH:mm:ss
 *  type 12, 24
 */
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

/**
 *  返回系统当前时间 yyyy-MM-dd
 */
+ (NSString *)currentDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [df stringFromDate:[NSDate date]];
    return str;
}

//convert string to date
+ (NSDate *)stringToDate:(NSString *)httpDate
{
    NSDateFormatter *dateFormatter = [Utility _HTTPDateFormatter];
    return [dateFormatter dateFromString:httpDate];
}

//convert date to string
+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [Utility _HTTPDateFormatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [Utility _HTTPDateFormatterHasTime];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *resultStr = [dateFormatter stringFromDate:date];
    return resultStr.length ? resultStr : @"";
}

+ (NSString *)dateHasTimeToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [Utility _HTTPDateFormatterHasTime];
    return [dateFormatter stringFromDate:date];
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

+ (NSString *)queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            // [Utility encodeString:[params objectForKey:name]]]
            [str appendString:[NSString stringWithFormat:@"%@=%@",
							   name,[[params objectForKey:name] description]]];
        }
    }
    return str;
}

+ (NSString *)weekdayofDate:(NSDate *)date{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit |
													NSDayCalendarUnit | NSWeekdayCalendarUnit )
										  fromDate:date];
    switch ([comp weekday]) {
        case 7:
            return @"星期六";
            break;
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        default:
            return @"";
            break;
    }
}
+ (NSString *)dateWithWeekDay:(NSDate *)date{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit |
													NSDayCalendarUnit | NSWeekdayCalendarUnit )
										  fromDate:date];
    NSString *weekDay=@"";
    switch ([comp weekday]) {
        case 7:
            weekDay=@"星期六";
            break;
        case 1:
            weekDay=@"星期日";
            break;
        case 2:
            weekDay=@"星期一";
            break;
        case 3:
            weekDay=@"星期二";
            break;
        case 4:
            weekDay=@"星期三";
            break;
        case 5:
            weekDay=@"星期四";
            break;
        case 6:
            weekDay=@"星期五";
            break;
        default:
            weekDay=@"";
            break;
    }
    return [NSString stringWithFormat:@"%ld-%02ld-%02ld %@",(long)[comp year],(long)[comp month],(long)[comp day],weekDay];
}

+ (float)iosVersion{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (BOOL)validatePass:(NSString *)str
{
    NSString *patternStr = [NSString stringWithFormat:@"^[A-Za-z0-9]{6,16}$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
	
	
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

//验证身份证
+ (BOOL)validateIdCard:(NSString *)str
{
    //    NSString *patternStr = [NSString stringWithFormat:@"(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$)"];
    NSString *patternStr = [NSString stringWithFormat:@"^\\d{15}$|^\\d{17}([0-9]|X)$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
	
	
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)validateIP:(NSString *)str
{
    if (str.length < 7) {
        return NO;
    }
    NSString *string = [str substringFromIndex:7];
    
    NSRange range = [string rangeOfString:@"/"];
    if (range.location == NSNotFound) {
        return NO;
    }
    string = [string substringWithRange:NSMakeRange(0, range.location)];
    NSString *patternStr = [NSString stringWithFormat:@"((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]\\d)|\\d)(\\.((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]\\d)|\\d)){3}"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, string.length)];
	
	
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

//校验姓或名
+ (BOOL)validateName:(NSString *)str
{
    if (!str) {
        return NO;
    }
    
    NSString *patternStr = [NSString stringWithFormat:@"^[\u4E00-\u9FA5]{1,16}$|^[a-zA-Z]{1,32}$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

//校验用户名
+ (BOOL)validateUserName:(NSString *)str
{
    if (!str) {
        return NO;
    }
    
    NSString *patternStr = [NSString stringWithFormat:@"^.{0,4}$|.{21,}|^[^A-Za-z0-9\u4E00-\u9FA5]|[^\\w\u4E00-\u9FA5.-]|([_.-])\1"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)validateUserPhone:(NSString *) str
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
    
    if (([regextestmobile evaluateWithObject:str] == YES)
        || ([regextestcm evaluateWithObject:str] == YES)
        || ([regextestct evaluateWithObject:str] == YES)
        || ([regextestcu evaluateWithObject:str] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)validateUserId:(NSString *)str {
    if (!str) {
        return NO;
    }
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^.{0,16}$|.{16,}|^[^0-9]"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        DLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
	
    DLog(@"%@ isNumbericString: NO", str);
    return NO;
}

+ (BOOL)validateEmail:(NSString *)str {
    if (!str) {
        return NO;
    }
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        //DLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
	
    //DLog(@"%@ isNumbericString: NO", str);
    return NO;
}

// json日期格式得转换
+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string{
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil]; });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    if (regexResult) {
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

+ (BOOL)isNumberic:(NSString *)str{
	if (!str)
		return NO;
	
	NSScanner *scan = [NSScanner scannerWithString:str];
    double var;
	return ([scan scanDouble:&var]) && [scan isAtEnd];
}

+ (NSString *)generateUUID{
	CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
#ifdef DEBUG
    assert(uuid != NULL);
#endif
    uuidStr = CFUUIDCreateString(NULL, uuid);
#ifdef DEBUG
    assert(uuidStr != NULL);
#endif
	
	NSString *identifier=[ NSString stringWithString:(__bridge NSString *)uuidStr];
	CFRelease(uuidStr);
    CFRelease(uuid);
	return [Utility stringWithMD5:identifier];
}

+(NSString *)getHTMLChangge:(NSString *)_str
{
    
    if (_str) {
        NSString *TextString=[[NSString alloc] initWithString:_str];
        TextString=[[[[[[[[[[[[TextString stringByReplacingOccurrencesOfString:@"<p>" withString:@"\r"]
                              stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"]
                             stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"]
                            stringByReplacingOccurrencesOfString:@"#red" withString:@""]
                           stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "]
                          stringByReplacingOccurrencesOfString:@"&ge;" withString:@"—"]
                         stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"®"]
                        stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"]
                       stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"]
                      stringByReplacingOccurrencesOfString:@"</p>" withString:@""]
                     stringByReplacingOccurrencesOfString:@"&middot;" withString:@"."]
                    stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        return  TextString;
    }
    return nil;
}


+ (NSString *)intervalSinceNow:(NSDate *)theDate
{
    
    NSDate* dat = [NSDate date];
    NSTimeInterval cha=[theDate timeIntervalSinceDate:dat]*1;
    NSString *timeString=@"";
    
    int day = cha/86400;
    int hour = ((int)cha%86400)/3600;
    int minute = ((int)cha%3600)/60;
    int second = (int)cha%60;
    timeString = [NSString stringWithFormat:@"距离闹钟提醒还有%d天%d小时%d分钟%d秒",day,hour,minute,second];
    
    
    return timeString;
}

+ (NSString *)chinaNum:(int)num {
    switch (num) {
        case 0:
            return @"零";
            break;
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"七";
            break;
        case 8:
            return @"八";
            break;
        case 9:
            return @"九";
            break;
        case 10:
            return @"十";
            break;
        default:
            break;
    }
    return nil;
}

+ (UIImage *)getImageFromProject:(NSString *)path
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]];
}

+ (NSString *)documentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (BOOL)isExistDocumentFile:(NSString *)fileName
{
    //创建文件夹：
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self documentPath], fileName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    return existed;
}

+ (BOOL)deleteDocumentFile:(NSString *)fileName
{
    //删除文件夹及文件级内的文件：
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self documentPath], fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager removeItemAtPath:path error:nil];
}

+ (NSString *)documentPathAppandString:(NSString *)str
{
    return [NSString stringWithFormat:@"%@/%@", [self documentPath], str];
}

/**
 *  在Document目录后添加文件夹和文件名
 *
 *  @param dirName  文件夹名
 *  @param fileName 文件名
 *
 *  @return 完整的路径
 */
+ (NSString *)documentPathWithDir:(NSString *)dirName fileName:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@/%@/%@", [self documentPath], dirName, fileName];
}

+ (void)lineWithRect:(CGRect)frame color:(UIColor *)color toView:(UIView *)view
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    
    [view addSubview:line];
}

+ (UIView *)lineWithRect:(CGRect)frame color:(UIColor *)color
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    
    return line;
}

+ (NSString *)currentDeviceUUID
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return uuid;
}

+ (NSString *)fillZeroFromString:(NSString *)str
{
    NSInteger len = str.length/2;
    NSInteger count;
    NSString *zeroStr = @"0000000000000000";
    NSString *newStr = @"";
    
    if(len % 8 != 0){
        count = ((len/8)+1)*16-str.length;
        newStr = [zeroStr substringToIndex:count];
    }
    
    return [NSString stringWithFormat:@"%@%@", str, newStr];
}

+ (NSString *)fillZeroFromString:(NSString *)str number:(NSInteger)num
{
    if (str) {
        NSMutableString *mStr = [NSMutableString stringWithString:str];
        
        for (NSInteger i = 0; i < num-str.length; i++) {
            [mStr appendString:@"0"];
        }
        
        return mStr;
        
    } else {
        return @"";
    }
}

+ (NSString *)trimZeroFromString:(NSString *)str
{
    NSString *newStr = [str substringToIndex:str.length - 16];
    NSString *tailStr = [str substringFromIndex:str.length - 16];
    NSString *trimStr = [tailStr stringByReplacingOccurrencesOfString:@"00" withString:@""];
    
    return [NSString stringWithFormat:@"%@%@", newStr, trimStr];
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

+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:value forKey:defaultName];
    [userDef synchronize];
}

+ (void)removeObjectForKey:(NSString *)defaultName
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef removeObjectForKey:defaultName];
    [userDef synchronize];
}

+ (NSString *)stringForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSArray *)arrayForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (NSData *)dataForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSArray *)stringArrayForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)doubleForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSURL *)URLForKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0)
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setInteger:value forKey:defaultName];
    [userDef synchronize];
}

+ (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setFloat:value forKey:defaultName];
    [userDef synchronize];
}

+ (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setDouble:value forKey:defaultName];
    [userDef synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:value forKey:defaultName];
    [userDef synchronize];
}

+ (void)setURL:(NSURL *)url forKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0)
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setURL:url forKey:defaultName];
    [userDef synchronize];
}

/**
 *  点击显示图片
 *
 *  @param avatarImageView 需要显示的imageView
 */

static CGRect oldframe;
+ (void)showImageView:(UIImageView *)avatarImageView
{
    UIImage *image = avatarImageView.image;
    
    if (image) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.85];
        backgroundView.alpha = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
        imageView.image = image;
        imageView.tag = 1;
        [backgroundView addSubview:imageView];
        [window addSubview:backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
        [backgroundView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

+ (void)hideImage:(UITapGestureRecognizer*)tap
{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

+ (void)dispatch_afterDelayTime:(double)time block:(void(^)())afterBlock
{
    double delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        afterBlock();
    });
}

+ (void)safeNavVC:(UINavigationController *)navVC pushToVC:(UIViewController *)vc animated:(BOOL)animated
{
    NSString *lastVCName = NSStringFromClass([[navVC.viewControllers lastObject] class]);
    
    if (![lastVCName isEqualToString:NSStringFromClass([vc class])]) {
        [navVC pushViewController:vc animated:animated];
    }
}

+ (void)currentVCpushToVC:(UIViewController *)toVC animated:(BOOL)animated
{
    if (toVC) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        id currentVC = window.rootViewController;
        
        if ([currentVC isKindOfClass:[UITabBarController class]]) {
            id subVC = [currentVC selectedViewController];
            [subVC pushViewController:toVC animated:animated];
        } else if ([currentVC isKindOfClass:[UINavigationController class]]) {
            [currentVC pushViewController:toVC animated:animated];
        }
    }
}

+ (void)compareArray:(NSArray *)arrayObject
        compareValue:(NSString *)value
           objectKey:(NSString *)key
       completeBlock:(void(^)(NSInteger index))completeBlock
{
    __block NSInteger index = -1;
    
    [arrayObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (key) {
            NSString *objValue = [NSString stringWithFormat:@"%@", obj[key]];
            if ([objValue isEqualToString:[NSString stringWithFormat:@"%@", value]]) {
                index = idx;
                *stop = YES;
            }
        } else if ([obj isEqualToString:value]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (completeBlock) {
        completeBlock(index);
    }
}

+ (CGSize)calcSizeFromString:(NSString *)str font:(UIFont *)font width:(NSInteger)width
{
    CGSize calcSize = CGSizeMake(width,MAXFLOAT);
    CGSize labelsize = CGSizeZero;
    
    if (IOS7_OR_LATER) {
        labelsize = [str boundingRectWithSize:calcSize
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: font}
                                      context:nil].size;
    } else {
        labelsize = [str sizeWithFont:font constrainedToSize:calcSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return labelsize;
}

+ (NSString *)intToString:(NSInteger)number
{
    return [NSString stringWithFormat:@"%ld", (long)number];
}

+ (id)storyboardName:(NSString *)name identifier:(NSString *)identifier
{
    UIViewController *classVC = nil;
    
    @try {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        if (identifier) {
            classVC = [storyboard instantiateViewControllerWithIdentifier:identifier];
        } else {
            classVC = [storyboard instantiateInitialViewController];
        }
    }
    @catch (NSException *exception) {
        DLogError(@"%@", exception);
    }
    
    return classVC;
}

+ (void)modalVC:(UIViewController *)modalVC
         target:(id)target
     identifier:(NSString *)identifier
    resultBlock:(void (^)(id))resultBlock
{
    if (!executeBlockDict) {
        executeBlockDict = [NSMutableDictionary dictionary];
    }
    
    if (resultBlock && identifier) {
        executeBlockDict[identifier] = [resultBlock copy];
    } else {
        DLogError(@"ResultBlock or resultBlock not Exist!!! %@", resultBlock);
    }
    
    if (modalVC && target) {
        [target presentViewController:modalVC animated:YES completion:nil];
    }
}

+ (void)pushVC:(UIViewController *)pushVC
        target:(id)target
    identifier:(NSString *)identifier
   resultBlock:(void (^)(id))resultBlock
{
    if (!executeBlockDict) {
        executeBlockDict = [NSMutableDictionary dictionary];
    }
    
    if (resultBlock && identifier) {
        executeBlockDict[identifier] = [resultBlock copy];
    } else {
        DLogError(@"ResultBlock or resultBlock not Exist!!! %@", resultBlock);
    }
    
    if (pushVC && target) {
        [self safeNavVC:[target navigationController] pushToVC:pushVC animated:YES];
    }
}

+ (void)executeResultBlock:(id)sender identifier:(NSString *)identifier
{
    void(^blockObj)(id) = executeBlockDict[identifier];
    
    if (blockObj) {
        blockObj(sender);
    }
}

+ (void)executeResultBlock:(id)sender after:(NSTimeInterval)secs identifier:(NSString *)identifier
{
    void(^blockObj)(id) = executeBlockDict[identifier];
    
    if (blockObj) {
        [self dispatch_afterDelayTime:secs block:^{
            blockObj(sender);
        }];
    }
}

@end
