//
//  FMPTripleDES.m
//  FroadMobilePlatform
//
//  Created by zhiwei zhu on 12-9-10.
//  Copyright (c) 2012年 froad. All rights reserved.
//

#import "FMPTripleDES.h"
#import "GTMBase64.h"
#import "FMPHexUtil.h"
@implementation FMPTripleDES
+ (NSString*)TripleDES:(NSString*)plainText
      encryptOrDecrypt:(CCOperation)encryptOrDecrypt
                   key:(NSString*)key
                    iv:(NSString*)iv
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt){
        NSData *EncryptData =[FMPHexUtil unhex:plainText];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else{
        NSData *plaintextData=[FMPHexUtil unhex:plainText];
        Byte *testByte = (Byte *)[plaintextData bytes];
        plainTextBufferSize = [plaintextData length];
        vplainText=(const void *)testByte;
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtrSize=plainTextBufferSize;
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //NSString *deskey=[[NSString alloc]initWithFormat:@"%@%@",key,[key substringToIndex:16]];
    NSString *deskey=[[NSString alloc]initWithFormat:@"%@",key];

    Byte *testByte = (Byte *)[[FMPHexUtil unhex:deskey]bytes];
    const void *vkey=testByte;
//    [deskey release];
    
    const void *vinitVec;
    if (iv==nil) {
        vinitVec=nil;
    }else {
        vinitVec = (const void *) [iv UTF8String];
    }
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
   
    
//    NSData *data = [NSData dataWithBytes:bufferPtr length:movedBytes];
//    NSLog(@"data len = %d", data.length);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt){   
        result = [FMPHexUtil hex:nil withBytes:bufferPtr length:movedBytes];
    }else{
        result= [FMPHexUtil hex:nil withBytes:bufferPtr length:movedBytes];
    }
    return result;
}


+ (NSString*)DES_ECB:(NSString*)plainText
    encryptOrDecrypt:(CCOperation)encryptOrDecrypt
                 key:(NSString*)key
                  iv:(NSString*)iv
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt){
        NSData *EncryptData =[FMPHexUtil unhex:plainText];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else{
        NSData *plaintextData=[FMPHexUtil unhex:plainText];
        Byte *testByte = (Byte *)[plaintextData bytes];
        plainTextBufferSize = [plaintextData length];
        vplainText=(const void *)testByte;
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
        
    
    bufferPtrSize = (plainTextBufferSize + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    Byte *testByte = (Byte *)[[FMPHexUtil unhex:key]bytes];
    const void *vkey=testByte;

    
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionECBMode,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySizeDES,
                       nil, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt){   
        result = [FMPHexUtil hex:nil withBytes:bufferPtr length:movedBytes];
    }else{
        result= [FMPHexUtil hex:nil withBytes:bufferPtr length:movedBytes];
    }
    return result;
}

+ (NSString*)Froad_DES_CBC:(NSString *)plainText
                       key:(NSString *)key
{
    
    Byte iv[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    NSData *plaintextData=[FMPHexUtil unhex:[FMPHexUtil pbocPadding:plainText]];
    Byte *plainTextBytes = (Byte *)[plaintextData bytes];
    size_t plainTextBufferSize = [plaintextData length];
    size_t movedBytes = 0;
    Byte *testByte = (Byte *)[[FMPHexUtil unhex:key]bytes];
    const void *vkey=testByte;
        
    for (int i=0; i<(plainTextBufferSize/8); i++) {
        Byte data[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
        for (int j=0; j<8; j++) {
            data[j] = (Byte) (iv[j] ^ plainTextBytes[(i*8)+j]);
        }
        CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                           kCCAlgorithmDES,
                           kCCOptionECBMode,
                           vkey, //"123456789012345678901234", //key
                           kCCKeySizeDES,
                           nil, //"init Vec", //iv,
                           data, //"Your Name", //plainText,
                           kCCKeySizeDES,
                           (void *)iv,
                           kCCKeySizeDES,
                           &movedBytes);
        
    }
    return [FMPHexUtil hex:nil withBytes:iv length:8];
}
@end
