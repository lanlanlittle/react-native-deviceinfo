//
//  CCCommon.m
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-10-29.
//  Copyright 2010 XXX. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CCCommon.h"
//#import "UIDevice-IOKitExtensions.h"
//#import "CCAudioFiles.h"
#import "CCNSString.h"
//#import "definition.h"

//获取OS版本
NSString *getOSVersion()	
{
	return [[UIDevice currentDevice] systemVersion];
}

// 获取OS主版本号
NSString *getOSMainVer()
{
	NSString *osVer = getOSVersion();
//	CCASSERT(osVer != nil,"CCASSERT");
	
	NSInteger index = [CCNSString firstIndexOfChar:osVer withChar:'.'];
	if(index < 0)
	{
		return osVer;
	}
	else if(0 == index)
	{
		return @"";
	}
	else
	{
		return [osVer substringToIndex:index];
	}
}

// 获取OS子版本号
NSString *getOSMinorVer()
{
	NSString *osVer = getOSVersion();
//	ASSERT(osVer != nil);
	
	NSInteger firstIndex = [CCNSString firstIndexOfChar:osVer withChar:'.'];
	NSInteger lastIndex = [CCNSString firstIndexOfChar:osVer withChar:'.' withAppearCount:2];
	if(firstIndex < 0)
	{
		return @"";
	}
	else if(lastIndex < 0)
	{
		if(firstIndex == osVer.length - 1)
		{
			return @"";
		}
		return [osVer substringWithRange:NSMakeRange(firstIndex + 1, osVer.length - firstIndex - 1)];
	}
	else
	{
		return [osVer substringWithRange:NSMakeRange(firstIndex + 1, lastIndex - firstIndex - 1)];
	}
}

//not availble
/*//获取硬件版本
NSString *getIphoneHardwareVersion()
{
	return [[UIDevice currentDevice] model];
}
 */

////是否支持多任务
//BOOL isSupportMultiTask()
//{
//	return [[UIDevice currentDevice] isMultitaskingSupported];
//}

//获取IMEL号(****请谨慎使用：获取IMEL号涉及调用苹果SDK的私有框架，虽然可用，但最终极有可能不能上传到AppStore)
NSString *getIMEL()
{
	//return [[UIDevice currentDevice] imei];
    return nil;
}

//// 获得设备唯一ID
//NSString *getUniqueID()
//{
//	return [[UIDevice currentDevice] uniqueIdentifier];
//}

//获取设备的翻转状态
UIDeviceOrientation getOrientation()
{
	return [[UIDevice currentDevice] orientation];
}

////振动设备
//void vibrateDevice()
//{
//	//需要添加　　Framework	 AudioToolbox/AudioToolbox.h
//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//}

// 判断一个对象指针(不是对象的值)是否在数组中存在
bool isObjExistsInArray(const id element, const NSArray *arr)
{
//	ASSERT(element != nil && arr != nil);
	
	for(id temp in arr)
	{
		if(temp == element)
		{
			return true;
		}
	}
	
	return false;
}


//获取设备名称
NSString *getOSName()
{
    return [[UIDevice currentDevice] name];

}

