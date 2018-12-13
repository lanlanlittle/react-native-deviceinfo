//
//  CCNSString.m
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-11-15.
//  Copyright 2010 XXX. All rights reserved.
//


#import "CCNSString.h"
#include <wchar.h>
#import "definition.h"


@implementation CCNSString

// not availble
// 获取字符在字符串第一次出现的位置
+ (NSInteger)firstIndexOfChar:(NSString *)str withChar:(unichar)ch
{
	return [CCNSString firstIndexOfChar:str withChar:ch withAppearCount:1];
}

// 获取字符在字符串最后一次出现的位置
+ (NSInteger)lastIndexOfChar:(NSString *)str withChar:(unichar)ch
{
	for(NSInteger i = str.length; i >= 0; i--)
	{
		if(ch == [str characterAtIndex:i])
		{
			return i;
		}
	}
	
	return -1;		// 没找到
}

// 获取字符在字符串第N次出现的位置
+ (NSInteger)firstIndexOfChar:(NSString *)str withChar:(unichar)ch withAppearCount:(NSInteger)count
{
	NSInteger appearCount = 0;
	
	for(NSInteger i = 0; i < str.length; i++)
	{
		if(ch == [str characterAtIndex:i])
		{
			appearCount++;
			if(appearCount == count)
			{
				return i;
			}
		}
	}
	
	return -1;		// 没找到
}

+ (void)trimBegin:(INOUT NSMutableString *)str
{
	ASSERT(str != nil);
	
	int i;
	for(i = 0; i < str.length; i++)
	{
		unichar ch = [str characterAtIndex:i];
		if(!iswspace(ch))
		{
			break;
		}
	}
	
	if(0 == i)
	{
		return;
	}
	
	[str deleteCharactersInRange:NSMakeRange(0, i)];
}

+ (void)trimEnd:(INOUT NSMutableString *)str
{
	ASSERT(str != nil);
	
	int i;
	for(i = str.length - 1; i >= 0; i--)
	{
		unichar ch = [str characterAtIndex:i];
		if(!iswspace(ch))
		{
			break;		//从后朝前找到不是空白字符的位置
		}
	}
	
	if(i == str.length - 1)
	{
		return;
	}
	
	NSUInteger loc = i + 1;
	[str deleteCharactersInRange:NSMakeRange(loc, str.length - loc)];
}

+ (void)trim:(INOUT NSMutableString *)str
{
	ASSERT(str != nil);
	
	[self trimBegin:str];
	[self trimEnd:str];
}


+ (NSString*)getDlqpServerString:(const char *)cString
{
	if (cString)
	{
        //kCFStringEncodingGB_2312_80  kCFStringEncodingGB_18030_2000
		NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000); 
		
		NSString* retStr = [NSString stringWithCString:cString 
											  encoding:enc];
		
		return retStr;
	}
	
	return nil;
}


+ (char*)getDlqpServerBuf:(NSString*)string
{
	if (string)
	{
		NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000); 
		
        char* retBuf = (char*)[string cStringUsingEncoding:enc];
		
		return retBuf;
	}
    return NULL;
}

+ (NSString*)getFormJSONbyGB2312:(NSString*)string
{
    int nLen = [string length];
    if (nLen > 0)
    {
        char* pWChar = (char*)[string cStringUsingEncoding:NSUTF16StringEncoding];
        char* pChar = new char[nLen+1];
        memset(pChar, 0, nLen+1);
        for (int i=0; i<nLen; i++)
        {
            pChar[i] = pWChar[i*2];
        }
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *textMsg  = [NSString stringWithCString:(char*)pChar encoding:enc]; 

        delete []pChar;
        
        return textMsg;
    }
    
    return nil;
}
//unicode转换成中文
+(NSString *)replaceUnicode:(NSString *)unicodeStr 
{  
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];  
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];  
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];  
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];  
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData  
                                                           mutabilityOption:NSPropertyListImmutable   
                                                                     format:NULL  
                                                           errorDescription:NULL];  
    
    //NSLog(@"Output = %@", returnStr);  
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];  
}  

+ (NSString*)reverseStringBySpace:(NSString*)str
{
    
    
    NSArray* array = [str componentsSeparatedByString:@" "];
    
    NSMutableString* mutString = [[NSMutableString alloc]init];
    //NSLog(@"%@",array);

    for (int i=[array count]-1; i>=0; i--) 
    {
        NSString* str = [array objectAtIndex:i];
        [mutString appendString:@" "];
        [mutString appendString:str];
    }
    
    
    [mutString autorelease];
    //NSLog(@"%@",mutString);
    return mutString;
}


//删除回车换行符
+ (NSMutableString*)deleteCarriageAndLineFeed:(NSMutableString*)str
{
    
    NSString* retStr = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //[str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (retStr)
    {
        NSMutableString* string = [[NSMutableString alloc] initWithString:retStr];
        [string autorelease];
        
        return string;
    }
    return nil;
}

//数字单位转化
+ (NSString*)getLongLongNumWithUnit:(NSString*)strNum
{
    long long lNum = [strNum longLongValue];
    return [CCNSString getLongLongNumWithUnitByLongLong:lNum];
}


//数字单位转化
+ (NSString*)getLongNumWithUnit:(NSString*)strNum
{
    int lNum = [strNum intValue];
    
    return [CCNSString getLongNumWithUnitByLong:lNum];
}


+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    int val=0;  
    return [scan scanInt:&val] && [scan isAtEnd];
}


+ (NSString*)getLongNumWithUnitByLong:(long)lNum
{
    //亿 
    if (lNum>=1000000000 || lNum<=-1000000000)
    {
        return [NSString stringWithFormat:@"%.3f亿",(float)lNum/100000000];
    }
    //亿
    if (lNum>=100000000 || lNum<=-100000000)
    {
        return [NSString stringWithFormat:@"%.4f亿",(float)lNum/100000000];
    }
    else if(lNum>=10000000 || lNum<=-10000000)
    {
        return [NSString stringWithFormat:@"%.1f万",(float)lNum/10000];
    }
    else if(lNum>=1000000 || lNum<=-1000000)
    {
        return [NSString stringWithFormat:@"%.2f万",(float)lNum/10000];
    }
    else if(lNum>=100000 || lNum<=-100000)
    {
        return [NSString stringWithFormat:@"%.2f万",(float)lNum/10000];
    }
    
    return [NSString stringWithFormat:@"%ld",lNum];;
}


//数字单位转化
+ (NSString*)getLongLongNumWithUnitByLongLong:(long long)llNum
{
    //亿
    if (llNum>=1000000000 || llNum<=-1000000000)
    {
        return [NSString stringWithFormat:@"%.3f亿",(float)llNum/100000000];
    }
    //亿
    if (llNum>=100000000 || llNum<=-100000000)
    {
        return [NSString stringWithFormat:@"%.4f亿",(float)llNum/100000000];
    }
    else if(llNum>=10000000 || llNum<=-10000000)
    {
        return [NSString stringWithFormat:@"%.1f万",(float)llNum/10000];
    }
    else if(llNum>=1000000 || llNum<=-1000000)
    {
        return [NSString stringWithFormat:@"%.2f万",(float)llNum/10000];
    }
    else if(llNum>=100000 || llNum<=-100000)
    {
        return [NSString stringWithFormat:@"%.2f万",(float)llNum/10000];
    }
    
    return [NSString stringWithFormat:@"%lld",llNum];;

}

//数字单位转化
+ (NSString*)getLongLongNumWithUnitByLongLongWithNoPoint:(long long)llNum
{
    //亿
    if (llNum>=1000000000 || llNum<=-1000000000)
    {
        return [NSString stringWithFormat:@"%.0f亿",(float)llNum/100000000];
    }
    //亿
    if (llNum>=100000000 || llNum<=-100000000)
    {
        return [NSString stringWithFormat:@"%.0f亿",(float)llNum/100000000];
    }
    else if(llNum>=10000000 || llNum<=-10000000)
    {
        return [NSString stringWithFormat:@"%.0f万",(float)llNum/10000];
    }
    else if(llNum>=1000000 || llNum<=-1000000)
    {
        return [NSString stringWithFormat:@"%.0f万",(float)llNum/10000];
    }
    else if(llNum>=100000 || llNum<=-100000)
    {
        return [NSString stringWithFormat:@"%.0f万",(float)llNum/10000];
    }
    
    return [NSString stringWithFormat:@"%lld",llNum];;
    
}

//数字单位转化百万
+ (NSString*)getMillionWithUnitByLong:(long)lNum
{
    if(lNum>=1000000 || lNum<=-1000000)
    {
        return [NSString stringWithFormat:@"%.1f百万",(float)lNum/1000000];
    }
 
    return [NSString stringWithFormat:@"%ld",lNum];;


}

//数字单位转化百万
+ (NSString*)getWanWithUnitByLong:(long)lNum
{
    if(lNum>=1000000 || lNum<=-1000000)
    {
        return [NSString stringWithFormat:@"%.1f万",(float)lNum/10000];
    }
    
    return [NSString stringWithFormat:@"%ld",lNum];;
    
    
}
//数字单位转化  如1.1亿 如果整除 就 1亿  1.1万 1万  1百万 1千万
+ (NSString*)getChineseWithUnitByLong:(long)lNum
{
    //亿以上
    if (lNum>=100000000 || lNum <=-100000000) {
        if (lNum%100000000 == 0) {
            return [NSString stringWithFormat:@"%ld亿",lNum/100000000];
        }
        else
            return [NSString stringWithFormat:@"%.2f亿",(float)lNum/100000000];
    }
    //千万 亿之间
    
    if (lNum>=10000000 || lNum <=-10000000) {
        if (lNum%10000000 == 0) {
            return [NSString stringWithFormat:@"%ld千万",lNum/10000000];
        }
        else
            return [NSString stringWithFormat:@"%ld万",lNum/10000];
    }
    //百万 千万之间
    
    if (lNum>=1000000 || lNum <=-1000000) {
        if (lNum%1000000 == 0) {
            return [NSString stringWithFormat:@"%ld百万",lNum/1000000];
        }
        else
            return [NSString stringWithFormat:@"%ld万",lNum/10000];
    }
    
    //一万 百万之间
    
    if (lNum>=10000 || lNum <=-10000) {
        if (lNum%10000 == 0) {
            return [NSString stringWithFormat:@"%ld万",lNum/10000];
        }
        else
            return [NSString stringWithFormat:@"%.1f万",(float)lNum/10000];
    }
    
    
    //一千 一万之间
    
    if (lNum>=1000 || lNum <=-1000) {
        if (lNum%1000 == 0) {
            return [NSString stringWithFormat:@"%ld千",lNum/1000];
        }
        else
            return [NSString stringWithFormat:@"%ld",lNum];
    }
    
    return [NSString stringWithFormat:@"%ld",lNum];;
    
    
}
@end


