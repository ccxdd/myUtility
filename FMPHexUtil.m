//
//  FMPHexUtil.m
//  FroadMobilePlatform
//
//  Created by zhiwei zhu on 12-9-17.
//  Copyright (c) 2012年 froad. All rights reserved.
//

#import "FMPHexUtil.h"
#import "FMPTripleDES.h"

static NSMutableArray * _USER_BYTEHEX_TABLE = nil;

@implementation FMPHexUtil

+(NSMutableArray *)getByteHexTable
{    
    if (_USER_BYTEHEX_TABLE == nil) {
        _USER_BYTEHEX_TABLE=[[NSMutableArray alloc]initWithObjects:
                             @"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"0A",@"0B",@"0C",@"0D",@"0E",@"0F",
                             @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"1A",@"1B",@"1C",@"1D",@"1E",@"1F",
                             @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"2A",@"2B",@"2C",@"2D",@"2E",@"2F",
                             @"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"3A",@"3B",@"3C",@"3D",@"3E",@"3F",
                             @"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"4A",@"4B",@"4C",@"4D",@"4E",@"4F",
                             @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"5A",@"5B",@"5C",@"5D",@"5E",@"5F",
                             @"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"6A",@"6B",@"6C",@"6D",@"6E",@"6F",
                             @"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"7A",@"7B",@"7C",@"7D",@"7E",@"7F",
                             @"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"8A",@"8B",@"8C",@"8D",@"8E",@"8F",
                             @"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"9A",@"9B",@"9C",@"9D",@"9E",@"9F",
                             @"A0",@"A1",@"A2",@"A3",@"A4",@"A5",@"A6",@"A7",@"A8",@"A9",@"AA",@"AB",@"AC",@"AD",@"AE",@"AF",
                             @"B0",@"B1",@"B2",@"B3",@"B4",@"B5",@"B6",@"B7",@"B8",@"B9",@"BA",@"BB",@"BC",@"BD",@"BE",@"BF",
                             @"C0",@"C1",@"C2",@"C3",@"C4",@"C5",@"C6",@"C7",@"C8",@"C9",@"CA",@"CB",@"CC",@"CD",@"CE",@"CF",
                             @"D0",@"D1",@"D2",@"D3",@"D4",@"D5",@"D6",@"D7",@"D8",@"D9",@"DA",@"DB",@"DC",@"DD",@"DE",@"DF",
                             @"E0",@"E1",@"E2",@"E3",@"E4",@"E5",@"E6",@"E7",@"E8",@"E9",@"EA",@"EB",@"EC",@"ED",@"EE",@"EF",
                             @"F0",@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",@"F8",@"F9",@"FA",@"FB",@"FC",@"FD",@"FE",@"FF", nil];
    }
    
    return _USER_BYTEHEX_TABLE;
   
}

#pragma mark - 内部方法
+(Byte) h2b:(Byte) c
{
    if (c<='9' && c>='0'){
        return (Byte) (c-'0');
    }else if (c>='a' && c<='z'){
        return (Byte) (c-'a'+10);
    }else{
        return (Byte) (c-'A'+10);
    }
}


+(NSString *) toBinary:(NSUInteger) input
{
    if (input == 1 || input == 0)
        return [NSString stringWithFormat:@"%u", input];
    return [NSString stringWithFormat:@"%@%u", [self toBinary:input / 2], input % 2];
}

#pragma mark - hex
+ (NSString*) getTime
{
    NSDateFormatter *nsDate=[[NSDateFormatter alloc] init];   
    [nsDate setDateStyle:NSDateFormatterShortStyle];   
    [nsDate setDateFormat:@"YYYYMMddHHmmss"];   
    NSString *t2=[nsDate stringFromDate:[NSDate date]];
//    [nsDate release];
    return t2;
}
+ (NSString*) hex:(NSData*) data
{    
    NSMutableString *hexBytes=[[NSMutableString alloc]init];
    Byte *testByte = (Byte *)[data bytes];
    for (int i=0; i<data.length; i++) {
        [hexBytes appendString:[    [FMPHexUtil getByteHexTable]  objectAtIndex:testByte[i]&0xff]];
    }
    NSString *returnString=[NSString stringWithString:hexBytes];
//    [hexBytes release];
    return returnString;
}


+ (NSString*) hex:(NSData*) data withAssic:(NSString*) Adata
{
//    const char *gbk  = [Adata cStringUsingEncoding:NSASCIIStringEncoding];
//    NSData *hexData=[NSData dataWithBytes:gbk length:strlen(gbk)];
    NSData *hexData=[Adata dataUsingEncoding:NSASCIIStringEncoding];
    return [self hex:hexData];
}

+ (NSString*) hex:(NSData*) data withGBK:(NSString*) Adata
{
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *hexData=[Adata dataUsingEncoding:gb2312];
    return [self hex:hexData];
}
+ (NSString*) hex:(NSData*) data withUTF8:(NSString*) Adata
{
    NSData *hexData=[Adata dataUsingEncoding:NSUTF8StringEncoding];
    return [self hex:hexData];
}
//8 to 08
+ (NSString*) hex:(NSData*) data withInt:(int) idata
{
    return [    [FMPHexUtil getByteHexTable]   objectAtIndex:idata&0xff];
}
//01234567 to 0001020304050607
+ (NSString*) hex:(NSData*) data withIntString:(NSString*) idata
{
    NSMutableString *hexBytes=[[NSMutableString alloc]init];
    for (int i=0; i<idata.length; i++) {
        [hexBytes appendString:[    [FMPHexUtil getByteHexTable]   objectAtIndex:[[idata substringWithRange:NSMakeRange(i, 1)]intValue]&0xff]];
    }
    NSString *returnString=[NSString stringWithString:hexBytes];
//    [hexBytes release];
    return returnString;
    
}
+ (NSString*) hex:(NSData*) data withByte:(Byte) bdata
{
    return [    [FMPHexUtil getByteHexTable]   objectAtIndex:bdata&0xff];
}
+ (NSString*) hex:(NSData*) data withBytes:(Byte*) bdata length:(int) byteslength
{
    NSMutableString *hexBytes=[[NSMutableString alloc]init];
    for (int i=0; i<byteslength; i++) {
        [hexBytes appendString:[    [FMPHexUtil getByteHexTable]   objectAtIndex:bdata[i]&0xff]];
    }
    NSString *returnString=[NSString stringWithString:hexBytes];
//    [hexBytes release];
    return returnString;
}

#pragma mark - unhex
+(NSData*) unhex:(NSString*) hexString
{
    NSMutableString *ss=[[NSMutableString alloc]initWithString:hexString];
    [ss replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, ss.length)];
    if(ss.length%2!=0)
    {
        [ss insertString:@"0" atIndex:0];
    }
    NSData *testData=[ss dataUsingEncoding:NSUTF8StringEncoding];
    Byte *testByte = (Byte*)[testData bytes];
    const int i = testData.length/2;
    Byte ba[i];
    for(int i=0;i<testData.length;i+=2){
        Byte a1=[self h2b:testByte[i]]*16;
        Byte a2=[self h2b:testByte[i+1]];
        ba[i/2] = a1+a2;
    }
    NSData *returnba=[[NSData alloc]initWithBytes:ba length:(ss.length/2)];
    return returnba;
}

+ (NSString*) unhextobinary:(NSString*) hexString
{
    NSUInteger hexAsInt;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hexAsInt];
    NSMutableString *binary = [[NSMutableString alloc]initWithFormat:@"%@", [self toBinary:hexAsInt]];
    while (binary.length!=(hexString.length*4)) {
        [binary insertString:@"0" atIndex:0];
    }
    NSString * returnString=[NSString stringWithFormat:@"%@",binary];
    return returnString;
}
+ (NSString*) pad:(NSString*)a :(NSString*)b :(int)i
{
    NSMutableString *result=[[NSMutableString alloc]init];
    if (a!=nil) {
        [result appendString:a];
    }
    while (result.length<i) {
        [result appendString:b];
    }
    NSString *returnString=[NSString stringWithString:result];
    return returnString;
}
+ (int) unhex16to10:(NSString*) hexString
{
    int dec=0;
    for (int i=0; i<hexString.length; i++) {
        char c=[hexString characterAtIndex:i];
        int cInt=0;
        if (c!='0') {
            //数字字符。
            if(c >= '0' && c <= '9')
            {
                cInt=(int) c - '0';
            }else if(c >= 'a' && c <= 'f')//小写abcdef。
            {
                cInt =(int) c - 'a' + 10;
            }else if(c >= 'A' && c <= 'F')             //大写ABCDEF。
            {
                cInt =(int) c - 'A' + 10;
            }
            dec+=cInt*pow(16, hexString.length-i-1);
        }
    }
    return dec;
}
+ (NSString*) pbocPadding:(NSString*)data
{
    NSMutableString *ss=[[NSMutableString alloc]initWithString:data];
    if(ss!=nil && ss.length%2==0){
        int len = ss.length;
        if(len%16!=0){
            [ss appendString:@"80"];
            len+=2;
        }else{
            [ss appendString:@"8000000000000000"];
            len+=16;
        }
        while(len%16!=0){
            [ss appendString:@"00"];
            len+=2;
        }
        return ss;
    }else {
        return nil;
    }
}
+ (NSString*) diverseKey:(NSString*)key iv:(NSString*)iv
{
//    NSData *keyData=[self unhex:key];
//    Byte *keyByte=[self unByte:(Byte*)[keyData bytes] len:keyData.length]; 
    NSString *left=[FMPTripleDES TripleDES:iv encryptOrDecrypt:kCCEncrypt key:key iv:nil];
    
    NSData *ivData=[self unhex:iv];
    Byte *ivByte=[self unByte:(Byte*)[ivData bytes] len:ivData.length];
    NSString *univ=[self hex:nil withBytes:ivByte length:ivData.length];
    NSString *right=[FMPTripleDES TripleDES:univ encryptOrDecrypt:kCCEncrypt key:key iv:nil];
    return [NSString stringWithFormat:@"%@%@",left,right];
}
+ (Byte*) unByte:(Byte*)data len:(int)length
{
    for(int i=0;i<length;i++)
    {
        data[i]=~data[i];
    }
    return data;
}
@end
