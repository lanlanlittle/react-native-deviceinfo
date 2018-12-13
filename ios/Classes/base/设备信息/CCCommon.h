//
//  CCCommon.h
//  CCFC_IPHONE
//
//  Created by  zltianhen on 10-10-28.
//  Copyright 2010 XXX. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <stdbool.h>


#define	DO_NOTHING

#define	XUCHEN
#define XICHEN

// 转变成字符串类型
#define	TO_STR(var)	#var
// 数字转换成bool类型字符串
#define	TO_BOOL_STR(intNum)	(((intNum) != 0) ? "true" : "false")

// 标志参数的传入传出类型
#define	IN
#define	OUT
#define	INOUT

#ifdef __STDC__
#define	C_MACRO			__STDC__
#endif	//__STDC__

#ifdef __OBJC__
#define	OBJC_MACRO		__OBJC__
#endif	//__OBJC__

#ifdef __cplusplus
#define	CPP_MACRO		__cplusplus
#endif	//__cplusplus


//属性通用宏；默认是nonatomic类型
#define	PROPERTY_COMMON								@property (nonatomic, assign)
#define	PROPERTY_RETAIN								@property (nonatomic, retain)
#define	PROPERTY_COPY								@property (nonatomic, copy)

// atomic类型的属性
#define	PROPERTY_COMMON_ATOMIC						@property (atomic, assign)
#define	PROPERTY_RETAIN_ATOMIC						@property (atomic, retain)
#define	PROPERTY_COPY_ATOMIC						@property (atomic, copy)

#if defined(__cplusplus)
extern "C" {
#endif
	
	//获取设备相关信息
	NSString *getOSVersion();				//获取OS版本
	#define	GET_OS_VERSION	getOSVersion
	// 获取OS主版本号
	NSString *getOSMainVer();	
	// 获取OS子版本号
	NSString *getOSMinorVer();
    //获取设备名称
    NSString *getOSName();
		
	//not availble
	//NSString *getIphoneHardwareVersion();		//获取硬件版本
	//#define	GET_HARDWARE_VERSION	getIphoneHardwareVersion

	BOOL isSupportMultiTask();					//是否支持多任务
	#define	GET_SUPPORT_MULTITASK	isSupportMultiTask

	//获取IMEL号(****请谨慎使用：获取IMEL号涉及调用苹果SDK的私有框架，虽然可用，但最终极有可能不能上传到AppStore)
	NSString *getIMEL();
	#define	GET_IMEL	getIMEL
		
	// 获得设备唯一ID使用其他方式代替 请搜索uniqueDeviceIdentifier
	//NSString *getUniqueID();
		
	//获取设备的翻转状态:如水平向上、横向等
	//NB.如果您需要使用此功能，必须在代码处额外添加启动系统检测设备翻转状态的代码
	//[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	//[[NSNotificationCenter defaultCenter] addObserver:<委托类指针> selector:@selector(<方法名>) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	UIDeviceOrientation getOrientation();
		
	//振动设备
	void vibrateDevice();
	
	// 判断一个对象指针(不是对象的值)是否在数组中存在
	bool isObjExistsInArray(const id element, const NSArray *arr);
	
#if defined(__cplusplus)
	}
#endif





