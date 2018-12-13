//
//  CCNSString.h
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-11-15.
//  Copyright 2010 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "CCCommon.h"
#endif
@interface CCNSString : NSMutableString
{
	
}


// 获取字符在字符串第一次出现的位置
+ (NSInteger)firstIndexOfChar:(NSString *)str withChar:(unichar)ch;
// 获取字符在字符串最后一次出现的位置
+ (NSInteger)lastIndexOfChar:(NSString *)str withChar:(unichar)ch;
// 获取字符在字符串第N次出现的位置
+ (NSInteger)firstIndexOfChar:(NSString *)str withChar:(unichar)ch withAppearCount:(NSInteger)count;



// 移除字符串首部、尾部、首部和尾部的空白字符（Unicode形式的空格，'\t', '\n'）
+ (void)trimBegin:(  NSMutableString *)str;
+ (void)trimEnd:(  NSMutableString *)str;
+ (void)trim:(  NSMutableString *)str;

+ (NSString*)reverseStringBySpace:(NSString*)str;

+ (BOOL)isPureInt:(NSString *)string;

//删除回车换行符
+ (NSMutableString*)deleteCarriageAndLineFeed:(NSMutableString*)str;

//转换gb的字符串 char* 转gb的字符串
+ (NSString*)getDlqpServerString:(const char *)cString;	
//gb 转char* 的字符串
+ (char*)getDlqpServerBuf:(NSString*)string;
//转换gb的字符串 NSString* 转gb的字符串 这里的数据是来源是JSON
+ (NSString*)getFormJSONbyGB2312:(NSString*)string;
//数字单位转化
+ (NSString*)getLongNumWithUnit:(NSString*)strNum;
//数字单位转化
+ (NSString*)getLongLongNumWithUnit:(NSString*)strNum;
//数字单位转化
+ (NSString*)getLongNumWithUnitByLong:(long)lNum;
//数字单位转化
+ (NSString*)getLongLongNumWithUnitByLongLong:(long long)llNum;
//数字单位转化百万
+ (NSString*)getMillionWithUnitByLong:(long)lNum;
//数字单位转化百万
+ (NSString*)getWanWithUnitByLong:(long)lNum;
//数字单位转化 不需要小数点
+ (NSString*)getLongLongNumWithUnitByLongLongWithNoPoint:(long long)llNum;
//数字单位转化一位小数点的单位  如1.1亿 如果整除 就 1亿  1.1万 1万  1百万 1千万
+ (NSString*)getChineseWithUnitByLong:(long)lNum;
@end

