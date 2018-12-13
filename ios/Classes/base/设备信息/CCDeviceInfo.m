//
//  CCDeviceInfo.m
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-11-15.
//  Copyright 2010 XXX. All rights reserved.
//



#import "CCDeviceInfo.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 获取设备类型：iPhone、iPod等,返回字符串类型
NSString *getDeviceType()
{
	return [[UIDevice currentDevice] model];
}

// 获取磁盘空间总大小  NB.not availble
CGFloat getTotalDiskSpace()
{  
    CGFloat totalSpace = 0.0f;   
    NSError *error = nil; 
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
						NSDocumentDirectory, NSUserDomainMask, YES);   
    NSDictionary *dictionary = [[NSFileManager defaultManager] 
								attributesOfFileSystemForPath:[paths lastObject] 
								error: &error];   
	
    if (dictionary) 
	{   
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];   
        totalSpace = [fileSystemSizeInBytes floatValue];   
    } 
	else 
	{
		totalSpace = -1.0f;			// 表示获取磁盘空间出错
	}

    return totalSpace;   
}  

// 获取磁盘剩余空间大小   NB.not availble
CGFloat getFreeDiskSpace()
{  
    CGFloat freeSpace = 0.0f;   
    NSError *error = nil; 
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
														 NSDocumentDirectory, NSUserDomainMask, YES);   
    NSDictionary *dictionary = [[NSFileManager defaultManager] 
								attributesOfFileSystemForPath:[paths lastObject] 
								error: &error];   
	
    if (dictionary) 
	{   
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];   
        freeSpace = [fileSystemSizeInBytes floatValue];   
    } 
	else 
	{
		freeSpace = -1.0f;			// 表示获取磁盘空间出错
	}
	
    return freeSpace;   
}  

@implementation CCDeviceInfo

@end


