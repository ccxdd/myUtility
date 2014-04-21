//
//  Utility.h
//
//  Created by ccxdd on 10-12-29.
//  Copyright 2013 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

UIImage * getImageAtRect(UIImage *source,CGRect clipRect);
/**
 程序工具类
 */
@interface Utility : NSObject {
	
}

/**
 DES加密
 */
+ (NSString *)encryptUse3DES:(NSString *)plainText key:(NSString *)key;

/**
 DES解密
 */
+ (NSString *)decryptUse3DES:(NSString *)encryptText key:(NSString *)key;

/**
 *  SHA1加密
 */
+ (NSString *)encryptUseSHA1:(NSString *)srcString;

/**
 *  字符串到byte
 *
 *  @param srcString 要转换的字符串
 *
 *  @return 转换好后的byte
 */
+ (Byte *)string2Byte:(NSString *)srcString;

/**
 *  byte转字符串
 *
 *  @param bytes  要转换的byte
 *  @param length byte的长度
 *
 *  @return 转换好后的字符串
 */
+ (NSString *)byte2String:(Byte *)bytes length:(NSInteger)length;

/**
 *  Data类型转Hex字符串
 *
 *  @param data 要转换的Data
 *
 *  @return 转换后的16进制
 */
+ (NSString *)hexStringFromData:(NSData *)data;

/**
 *  Hex字符串转Data
 *
 *  @param hexStr 要转换的Hex字符串
 *
 *  @return 转换后的Data
 */
+ (NSData *)dataFromHexString:(NSString *)hexStr;

/**
 64编码
 */
+ (NSString *)base64Encoding:(NSData*)text;

/**
 字节转化为16进制数
 */
+ (NSString *)byte2HexString:(Byte *)bytes;

/**
 字节数组转化16进制数
 */
+ (NSString *)byteArray2HexString:(Byte[])bytes;

/*
 将16进制数据转化成NSData 数组
 */
+ (NSData *)hexString2Data:(NSString*)hexString;

/**
 对字符串进行URL解码
 @param string  要进行解码的字符串
 @return    解码后的字符串
 */
+ (NSString *)decodeString:(NSString *)string;

/**
 对字符串进行URL编码
 @param string  要进行编码的字符串
 @return    编码后的字符串
 */
+ (NSString *)encodeString:(NSString *)string;

/**
 结合MD5和密文对字典进行加密,用于网络请求时产生摘要
 @param dictionary  要进行加密的字典
 @param secret  加密使用的密文
 @return    加密后的字符串
 */
+ (NSString *)dictionaryToMD5String:(NSDictionary *)dictionary appSecret:(NSString *)secret;

/**
 将字符串进行MD5加密
 @param source  要进行MD5的源
 @return    加密后的字符串
 */
+ (NSString *)stringWithMD5:(NSString *)source;

/**
 将字符串转换为16进制形式
 @param str 待转换的字符串
 @return    转换后的16进制字符串
 */
+ (NSString *)stringToHex:(NSString *)str;

/**
 将字符串进行MD5返回大写形式
 @param source  待加密源
 @return    加密后大写字符串
 @
 */
+ (NSString *)UpperCaseStringWithMD5:(NSString *)source;

/**
 字符串格式日期转换成NSDate
 @param httpDate    字符串格式日期
 @param NSDate对象
 */
+ (NSDate *)stringToDate:(NSString *)httpDate;

/**
 *  中国格式日期:年月日
 *
 *  @param htmlDateString DateString
 *
 */
+ (NSString *)chinaDateWith:(NSString *)htmlDateString;

/**
 日期对象转换为字符串
 @param date 日期对象
 @return 日期字符串格式
 */
+ (NSString *)dateToString:(NSDate *)date;

/**
 日期和时间对象转换为字符串
 @param date 日期对象
 @return 日期字符串格式
 */
+ (NSString *)dateHasTimeToString:(NSDate *)date;

/**
 *  返回系统当前时间 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)currentDateTime:(NSInteger)timeType;

/**
 *  返回系统当前时间 HH:mm:ss
 *  type 12, 24
 */
+ (NSString *)currentTime:(NSInteger)timeType;

/**
 *  返回系统当前时间 yyyy-MM-dd
 */
+ (NSString *)currentDate;

/**
 *  返回字符串时间戳
 */
+ (NSString *)dateFromTimestamp;

/**
 *  返回13位的时间戳
 *
 */
+ (NSString *)dateFrom13lenTimestamp;

/**
 拼接GET请求字符串
 @param base    路径
 @param params  请求参数
 @param prefixed    是否有"?"前缀
 @return    拼接后字符串
 */
+ (NSString *)queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;

/**
 得到日期的星期
 @param date    日期对象
 @return 星期的字符串表示
 */
+ (NSString *)weekdayofDate:(NSDate *)date;

/**
 返回带有星期的日期字符串
 @param date    日期对象
 @return    带有星期的日期字符串
 */
+ (NSString *)dateWithWeekDay:(NSDate *)date;

/**
 获取系统版本
 @return    系统版本
 */
+ (float)iosVersion;

+ (BOOL) validatePass : (NSString *) str;

+ (BOOL)validateIP:(NSString *)str;

/**
 *校验姓或名
 *@param	str	用户名
 *@return		用户名是否合法
 */
+ (BOOL) validateName : (NSString *) str;

/**
 *校验身份证
 *@param	str	用户名
 *@return		用户名是否合法
 */
+ (BOOL) validateIdCard : (NSString *) str;

/**
 *校验用户ID
 *@param	str	用户名
 *@return		用户名是否合法
 */
+ (BOOL)validateUserId:(NSString *)str;

/**
 *校验用户名是否合法
 *@param	str	用户名
 *@return		用户名是否合法
 */
+ (BOOL) validateUserName : (NSString *) str;

/**
 *校验用户手机号码是否合法
 *@param	str	手机号码
 *@return		手机号是否合法
 */
+ (BOOL) validateUserPhone : (NSString *) str;

/**
 *校验用户邮箱是否合法
 *@param	str	邮箱
 *@return		邮箱是否合法
 */
+ (BOOL)validateEmail:(NSString *)str;

/**
 *.NET JSON字符串格式日期转换为NSDate日期对象
 *@param	string JSON字符串格式日期
 *@return	NSDate对象
 */
+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string;

/**
 *检测字符串是否是由纯数字组成
 *@param	str	要检测的字符串
 *@return	是否是纯数字
 */
+ (BOOL)isNumberic:(NSString *)str;

/**
 *生成唯一识别标识
 *@return 
 */
+ (NSString *)generateUUID;

+(NSString *)getHTMLChangge:(NSString *)_str;

+ (NSString *)intervalSinceNow:(NSDate *)theDate;

+ (NSString *)chinaNum:(int)num;

/**
 *从工程获取图片
 */
+ (UIImage*)getImageFromProject:(NSString*)path;

+ (CGSize) sizeWithLabel : (UILabel*) _label;

+ (CGSize) sizeWithLabel : (UILabel*) _label string : (NSString*) _str;

+ (CGSize) sizeWithString : (NSString*) _str font : (UIFont*) _font width : (int) _width;

/**
 *  返回Document路径
 */
+ (NSString *)documentPath;

/**
 *  在Document目录后添加文件名
 */
+ (NSString *)documentPathAppandString:(NSString *)str;

/**
 *  在Document目录后添加文件夹和文件名
 *
 *  @param dirName  文件夹名
 *  @param fileName 文件名
 *
 *  @return 完整的路径
 */
+ (NSString *)documentPathWithDir:(NSString *)dirName fileName:(NSString *)fileName;

/**
 *  在Document目录下是否存在该文件
 */
+ (BOOL)isExistDocumentFile:(NSString *)fileName;

/**
 *  删除文件
 */
+ (BOOL)deleteDocumentFile:(NSString *)fileName;

/**
 *  画线
 */
+ (void)lineWithRect:(CGRect)frame color:(UIColor *)color toView:(UIView *)view;

/**
 *  画线
 */
+ (UIView *)lineWithRect:(CGRect)frame color:(UIColor *)color;

/**
 *  得到设备UUID
 */
+ (NSString *)currentDeviceUUID;

/**
 *  右补0
 */
+ (NSString *)fillZeroFromString:(NSString *)str;
+ (NSString *)trimZeroFromString:(NSString *)str;
+ (NSString *)fillZeroFromString:(NSString *)str number:(NSInteger)num;

/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
+ (NSString *)generateRandomOfNum:(NSInteger)num;

/*********************************************************************************
 *
 * NSUserDefaults 集成
 *
**********************************************************************************/
+ (id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (void)removeObjectForKey:(NSString *)defaultName;

+ (NSString *)stringForKey:(NSString *)defaultName;
+ (NSArray *)arrayForKey:(NSString *)defaultName;
+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName;
+ (NSData *)dataForKey:(NSString *)defaultName;
+ (NSArray *)stringArrayForKey:(NSString *)defaultName;
+ (NSInteger)integerForKey:(NSString *)defaultName;
+ (float)floatForKey:(NSString *)defaultName;
+ (double)doubleForKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;
+ (NSURL *)URLForKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
+ (void)setFloat:(float)value forKey:(NSString *)defaultName;
+ (void)setDouble:(double)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
+ (void)setURL:(NSURL *)url forKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);
/*********************************************************************************/

/**
 *  点击显示图片
 *
 *  @param avatarImageView 需要显示的imageView
 */
+ (void)showImageView:(UIImageView*)avatarImageView;

/**
 *  延时
 *
 *  @param time       延时单位秒
 *  @param afterBlock afterBlock description
 */
+ (void)dispatch_afterDelayTime:(double)time block:(void(^)())afterBlock;

/**
 *  当前VCPush
 *
 *  @param toVC       目标VC
 *  @param animated animated
 */
+ (void)currentVCpushToVC:(UIViewController *)toVC animated:(BOOL)animated;

/**
 *  安全Push
 *
 *  @param navVC    navVC
 *  @param vc       目标VC
 *  @param animated animated
 */
+ (void)safeNavVC:(UINavigationController *)navVC pushToVC:(UIViewController *)vc animated:(BOOL)animated;

/**
 *  比较数组中是否存在值
 *
 *  @param arrayObject  arrayObject
 *  @param compareValue compareValue
 *  @param key          key
 *
 *  @return BOOL
 */
+ (void)compareArray:(NSArray *)arrayObject
        compareValue:(NSString *)value
           objectKey:(NSString *)key
       completeBlock:(void(^)(NSInteger index))completeBlock;

/**
 *  计算高度
 *
 *  @param str   str description
 *  @param font  font description
 *  @param width width description
 *
 *  @return return value description
 */
+ (CGSize)calculateSizeFromString:(NSString *)str font:(UIFont *)font width:(NSInteger)width;

/**
 *  数字到字符
 *
 *  @param number   要转换的数值
 *
 *  @return return value description
 */
+ (NSString *)intToString:(NSInteger)number;

@end
