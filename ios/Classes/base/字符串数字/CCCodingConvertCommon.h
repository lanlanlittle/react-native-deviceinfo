//
//  CCCodingConvertCommon.h
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-11-27.
//  Copyright 2010 XXX. All rights reserved.
//
#ifndef	CC_CODING_CONVERT_COMMON
#define	CC_CODING_CONVERT_COMMON



// 是否是中文字符    not available
#define IS_CHINESE_CHAR(lo,hi) ((unsigned char)lo >= 0x81 && hi >= 0x40 && hi <= 0xFE)

#if defined(__cplusplus)
extern "C" {
#endif
	
///*将UTF8格式的数据进行URL编码,返回编码后的总字节*/
//int URLEncode(const char *src, 
//              const int srcLen, 
//              char *dest,
//              const int destLen);
	
#if defined(__cplusplus)
}
#endif
		

#import <Foundation/Foundation.h>

#if defined(__cplusplus)
extern "C" {
#endif
	
	// 是否是非ASCII字符
	BOOL isNoneASCIICharacter(unichar ch);
	// 是否是ASCII字符
	BOOL isASCIICharacter(unichar ch);
	
	// NSString *   ---->   char *      NB. 转换成UTF8格式的char *
	const char *codingNSStringToCharSimply(NSString *src);
	
	// NSString *   ---->   char * , 转换后的数据保存在申请的内存中  NB. 转换成UTF8格式的char *
	BOOL codingNSStringToChar(NSString *src, char *dest, int destLen);
	
	// char *       ---->   NSString *  NB. UTF8格式的char *转换成NSString *
	NSString *codingCharToNSString(const char *src);

	// char *       ---->   NSString *  NB. GB2312格式的char *转换成NSString *  not available
	NSString *codingGB2312CharToNSString(const char *src);
	
#if defined(__cplusplus)
}
#endif
		
@interface CCCodingConvertCommon : NSObject 
{

}

@end

#endif	

