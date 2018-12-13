//
//  CCProcessInfo.h
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-11-15.
//  Copyright 2010 XXX. All rights reserved.
//



#import <Foundation/Foundation.h>

#define	GET_PROC_GLO_UNI_STR()			[[NSProcessInfo processInfo] globallyUniqueString]
#define	GET_PROC_OPERATING_OS()			[[NSProcessInfo processInfo] operatingSystemName]
#define	GET_PROC_NAME()					[[NSProcessInfo processInfo] processName]

//获取系统物理内存大小
#define	GET_PROCE_PHY_MEM_SIZE()		[[NSProcessInfo processInfo] physicalMemory]

@interface CCProcessInfo : NSObject 
{

}

@end


