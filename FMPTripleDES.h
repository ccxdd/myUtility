//
//  FMPTripleDES.h
//  FroadMobilePlatform
//
//  Created by zhiwei zhu on 12-9-10.
//  Copyright (c) 2012年 froad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface FMPTripleDES : NSObject
/* 
 *3des key加密
 NSString* req = @"A4BFDE9CF8FCA168";
 NSString* key = @"12345678901234567890123456789012";
 NSString* ret1 = [FMPTripleDES TripleDES:req encryptOrDecrypt:kCCEncrypt key:key iv:nil];
 FLog(@"3DES/Base64 Encode Result=%@", ret1);
 //===========================================
 *使用散列的key做加密
 NSString *deviceKEY=[FMPHexUtil diverseKey:@"87654321123456788765432112345678" iv:@"A4BFDE9CF8FCA168"];
 NSString *data=[FMPHexUtil pbocPadding:[FMPHexUtil hex:nil withUTF8:@"trueblankaccount number:100001007blankid type:1blankid number:310112198808082234blankmobile no:13311411567"]];
 *----------------74727565626C616E6B6163636F756E74206E756D6265723A313030303031303037626C616E6B696420747970653A31626C616E6B6964206E756D6265723A333130313132313938383038303832323334626C616E6B6D6F62696C65206E6F3A3133333131343131353637800000000000
 FLog(@"----------------%@",data);
 NSString *des=[FMPTripleDES TripleDES:data encryptOrDecrypt:kCCEncrypt key:deviceKEY iv:nil];
 *+++++_  83CC081DAD7B34DBE0E7AFC2072CC9FFDFB7C0FCC8921E09705B20DD20CB3E3544CE2B807B793C775BC3E8D8E28B07A9202629BA4A799CD236C414BF10228BFEF36F1F1D2C15052C1797296FAAA468AA84D70A1435C4304595CC0C9CBC21F4F3B2A3C228F560516737D3294DD14AE8EA
 FLog(@"+++++_  %@",des);
 //===========================================
 *普通3des
 * 165F3E15B7216DA8  31323334353637388000000000000000+++  DE970F254DF8FB58D775CCADB5A1546E
 NSString *KEY=[deviceKEY substringToIndex:16];
 NSString *DATA=[FMPHexUtil pbocPadding:[FMPHexUtil hex:nil withUTF8:@"12345678"]];
 FLog(@"%@  %@+++  %@",KEY,DATA,[FMPTripleDES DES_ECB:DATA encryptOrDecrypt:kCCEncrypt key:KEY iv:nil]);
 //==========================================
 *des_cbc 
 *des cbc+++  CD49CEA9
 FLog(@"des cbc+++  %@",[[FMPTripleDES Froad_DES_CBC:des key:KEY] substringToIndex:8]);
 */
+ (NSString*)TripleDES:(NSString*)plainText
      encryptOrDecrypt:(CCOperation)encryptOrDecrypt
                   key:(NSString*)key
                    iv:(NSString*)iv;

+ (NSString*)DES_ECB:(NSString*)plainText
    encryptOrDecrypt:(CCOperation)encryptOrDecrypt
                 key:(NSString*)key
                  iv:(NSString*)iv;

+ (NSString*)Froad_DES_CBC:(NSString *)plainText
                       key:(NSString *)key;
@end
