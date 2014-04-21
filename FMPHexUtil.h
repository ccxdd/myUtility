//
//  FMPHexUtil.h
//  FroadMobilePlatform
//
//  Created by zhiwei zhu on 12-9-17.
//  Copyright (c) 2012年 froad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMPHexUtil : NSObject

+(NSMutableArray *)getByteHexTable;


+ (NSString*) getTime;
+ (NSString*) hex:(NSData*) data;
+ (NSString*) hex:(NSData*) data withAssic:(NSString*) Adata;
+ (NSString*) hex:(NSData*) data withUTF8:(NSString*) Adata;
+ (NSString*) hex:(NSData*) data withInt:(int) idata;
+ (NSString*) hex:(NSData*) data withIntString:(NSString*) idata;
+ (NSString*) hex:(NSData*) data withByte:(Byte) bdata;
+ (NSString*) hex:(NSData*) data withBytes:(Byte*) bdata length:(int) byteslength;

//unhex
+ (NSData*) unhex:(NSString*) hexString;
+ (NSString*) unhextobinary:(NSString*) hexString;
+ (NSString*) pad:(NSString*)a :(NSString*)b :(int)i;
+ (int) unhex16to10:(NSString*) hexString;
//兰州银行使用的padding
+ (NSString*) pbocPadding:(NSString*)data;
+ (NSString*) diverseKey:(NSString*)key iv:(NSString*)iv;
+ (Byte*) unByte:(Byte*)data len:(int)length;
@end
