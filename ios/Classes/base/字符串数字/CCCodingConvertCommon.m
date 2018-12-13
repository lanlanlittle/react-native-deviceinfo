//
//  CCCodingConvertCommon.m
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-11-27.
//  Copyright 2010 XXX. All rights reserved.
//


///*将UTF8格式的数据进行URL编码,返回编码后的总字节*/
//int URLEncode(const char *src,
//              const int srcLen,
//              char *dest,
//              const int destLen)
//{
//
//    //ASSERT(src && dest && srcLen >= 0 && destLen >= 0);
//
//    int i;
//    int j = 0;
//    char ch;
//
//    for (i = 0; (i < srcLen) && (j < destLen); i++)
//    {
//        ch = src[i];
//        if ( ((ch >= 'A') && (ch <= 'Z'))
//            || ((ch >= 'a') && (ch <= 'z'))
//            || ((ch >= '0') && (ch <= '9')))
//        {
//            dest[j++] = ch;            // 普通ASCII字符
//        }
//        else if(' ' == ch)
//        {
//            dest[j++] = '+';
//        }
//        else
//        {
//            if (j + 3 < destLen)    // 是中文
//            {
//                sprintf(dest + j, "%%%02X", (unsigned char)ch);
//                j += 3;
//            }
//            else                    // 出现保存空间不足的错误
//            {
//                return 0;
//            }
//        }
//    }
//
//    dest[j] = '\0';                    // char*字符串结尾符
//    return j;
//}


#import <Foundation/Foundation.h>
#import "CCCodingConvertCommon.h"

// 是否是非ASCII字符
BOOL isNoneASCIICharacter(unichar ch)
{
	return !isASCIICharacter(ch);
}

// 是否是ASCII字符
BOOL isASCIICharacter(unichar ch)
{
	if(ch <= 127)
	{
		return TRUE;
	}
	return FALSE;
}

// NSString *   ---->   char * 
const char *codingNSStringToCharSimply(NSString *src)
{
	//ASSERT(src);
	
	return [src UTF8String]; 
}

// NSString *   ---->   char * , 转换后的数据保存在申请的内存中
BOOL codingNSStringToChar(NSString *src, char *dest, int destLen)
{
	//ASSERT(src && dest && destLen >= 0);
	
	const char *temp = [src UTF8String];
	
	size_t len = strlen(temp);
	if(len + 1 > destLen)		// 目标存储区空间不足，那么能保存多少就保存多少
	{
		memcpy(dest, temp, destLen - 1);
		dest[destLen - 1] = '\0';
		return FALSE;			// 返回没成功
	}
	
	memcpy(dest, temp, len);	// 正常存储
	dest[len] = '\0';
	return TRUE;
}

// char *       ---->   NSString *    NB. UTF8格式的char *转换成NSString *
NSString *codingCharToNSString(const char *src)
{
	return [NSString stringWithCString:src encoding:NSUTF8StringEncoding];
}

// char *       ---->   NSString *  NB. GB2312格式的char *转换成NSString * ; not available
NSString *codingGB2312CharToNSString(const char *src)
{
	return nil;
}

@implementation CCCodingConvertCommon

@end


