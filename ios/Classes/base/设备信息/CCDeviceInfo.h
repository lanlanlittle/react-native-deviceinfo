//
//  CCDeviceInfo.h
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-11-15.
//  Copyright 2010 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 电池信息
//below NB.****不支持iPhone4,仅适用于iPhone3****
// 获取电池状态
#define	GET_BATTERY_STATE()		[[UIDevice currentDevice] batteryState]
// 获取电池电量
#define	GET_BATTERY_LEVEL()		[[UIDevice currentDevice] batteryLevel]
//above NB.****不支持iPhone4,仅适用于iPhone3****

#if defined(__cplusplus)
extern "C" {
#endif
	
// 获取设备类型：iPhone、iPod等
NSString *getDeviceType();

// 获取磁盘剩余空间大小  NB.not availble
CGFloat getDiskFreeSpace();
// 获取磁盘剩余空间大小   NB.not availble
CGFloat getFreeDiskSpace();
	
#if defined(__cplusplus)
}
#endif

@interface CCDeviceInfo : NSObject 
{

}

@end


