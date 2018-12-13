//
//  WapActionManager.m
//  QuZhanKe
//
//  Created by zhaoxx on 2018/7/14.
//  Copyright © 2018年 zsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WapActionManager.h"
#import "DeviceManager.h"
#import "EasyManager.h"
#import <objc/runtime.h>

@implementation WapActionManager

static WapActionManager* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [WapActionManager shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [WapActionManager shareInstance] ;
}

-(NSDictionary*)getIosDeviceInfo:(NSDictionary*)str
{
    NSLog(@"getIosDeviceInfo");
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];

    NSString* ver = [[DeviceManager shareInstance] getGameVer];
    [dict setValue:ver forKey:@"gamever"];
    
    NSString* phonetype = [[DeviceManager shareInstance]  getPhoneType];
    [dict setValue:phonetype forKey:@"phonetype"];
    
    NSString* blchannel = [[DeviceManager shareInstance] getBlchannel];
    [dict setValue:blchannel forKey:@"blchannel"];
    
    NSString* udid = [[DeviceManager shareInstance] getUdid];
    [dict setValue:udid forKey:@"udid"];
    
    NSString* wifi = [[DeviceManager shareInstance] getWifi];
    [dict setValue:wifi forKey:@"wifi"];
    
    NSString* useragent = [[DeviceManager shareInstance] getUserAgent];
    [dict setValue:useragent forKey:@"useragent"];
    
    NSString* idfa = [[DeviceManager shareInstance] getIdfa];
    [dict setValue:idfa forKey:@"idfa"];

    return dict;
}

@end
