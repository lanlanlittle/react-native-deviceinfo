//
//  CCNumberRelated.h
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-10-28.
//  Copyright 2010 XXX. All rights reserved.
//

#ifndef	CC_NUMBER_RELATED
#define	CC_NUMBER_RELATED

#import <Foundation/Foundation.h>

#include <math.h>

#define	INT_BITS	32

//单精度浮点数是否可以看成等于0  (默认精确到小数点第六位)
#define	FLOAT_EQUAL_TO_ZERO(floatNumber)	(fabsf((float)(floatNumber) - 0.0f) < (float)1e-6)

// 判断两个单精度浮点数是否近似相等
#define	FLOAT_EQUAL_TO_FLOAT(firstFloat, secondFloat)	FLOAT_EQUAL_TO_ZERO(firstFloat - secondFloat)

#if defined(__cplusplus)
extern "C" {
#endif	//__cplusplus
	
	// 判断两个整形加法是否溢出
	int addCheckOverflow(int a, int b, int *overFlowFlag);

	// 整型转换成字符串(对应于C库的atoi),返回转换后的字符串的实际长度
	int itoa(char *str, const int maxLen, int n);
	
	// 根据角度获取弧度值
	double getRadiusByDegrees(double degrees);
#if defined(__cplusplus)
}
#endif	//__cplusplus

/*
//随机值

#import <time.h>
#import <mach/mach_time.h>

srandom()的使用
srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));

直接使用 random() 来调用随机数
 
arc4random()
*/


@interface CCNumberRelated : NSObject

@end

#endif	

