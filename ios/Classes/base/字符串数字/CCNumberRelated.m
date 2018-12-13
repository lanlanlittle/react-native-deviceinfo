//
//  CCNumberRelated.m
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-12-5.
//  Copyright 2010 XXX. All rights reserved.
//

#import "CCNumberRelated.h"


// 判断两个整形加法是否溢出
int addCheckOverflow(int a, int b, int *overFlowFlag)
{
	int sum = a + b;
	*overFlowFlag = 0;
	
	if((a > 0 && b > 0 && sum < 0)
	 || (a < 0 && b < 0 && sum > 0))
	{
		*overFlowFlag = 1;
	}
	
	return sum;
}

// 整型转换成字符串(对应于C库的atoi),返回转换后的字符串的实际长度
int itoa(char *str, const int maxLen, int n)
{
	//ASSERT(str != NULL && maxLen >= 0);
	
	char temp[INT_BITS] = {0};
	int i = 0;
	while(n)
	{
		if(i >= INT_BITS)
		{
			return 0;
		}
		temp[i++] = (n % 10) + '0';			// 将整型数的各位对应的字符值保存在数组中
		n /= 10;
	}
	
	if(i > maxLen)			// 长度过长，返回0
	{
		return 0;
	}
	
	int len = i;
	int j = 0;
	while (i >= 0) 
	{
		str[j++] = temp[--i];		// 拷贝到外部字符串中
	}
	str[i] = '\0';

	return len;
}

// 根据角度获取弧度值
double getRadiusByDegrees(double degrees) 
{
	return degrees * M_PI / 180;
}



@implementation CCNumberRelated

@end


