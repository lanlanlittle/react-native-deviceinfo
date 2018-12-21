//
//  DeviceManager.m
//  QuZhanKe
//
//  Created by zhaoxx on 2018/7/14.
//  Copyright © 2018年 zsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceManager.h"

#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"
#import "SFHFKeychainUtils.h"
#import "OpenUDID_RN.h"
#import "UIDevice-Hardware.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AdSupport/AdSupport.h>

@implementation DeviceManager

static DeviceManager* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}


//获取游戏版本
- (NSString*)getGameVer
{
    NSDictionary* dict = [[NSBundle mainBundle ] infoDictionary];
    if (dict)
    {
        // NSString* version = [dict objectForKey:@"CFBundleVersion"];
        NSString* version = [dict objectForKey:@"CFBundleShortVersionString"];
        [version UTF8String];
        return version;
    }
    
    return nil;
}

//获取手机类型
- (NSString*)getPhoneType
{
    NSString* version = [[UIDevice currentDevice] platform];
    
    return version;
}

// 获取渠道
- (NSString*)getBlchannel
{
    NSDictionary* dictBundle = [[NSBundle mainBundle ] infoDictionary];
    if (dictBundle)
    {
        NSString* blchannel = [dictBundle objectForKey:@"blchannel"];
        if ([blchannel length]>0) {
            return blchannel;
        }
    }
    
    return nil;
}

// 获取wifi
- (NSString*)getWifi
{
    NSArray *ifs = (__bridge   id)CNCopySupportedInterfaces();
    for (NSString *ifname in ifs)
    {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        
        if (info && [info description])
        {
            NSMutableDictionary* dicWifi = [NSMutableDictionary dictionary];
            NSString* bssid =  [info objectForKey:@"BSSID"];
            NSString* SSID =  [info objectForKey:@"SSID"];
            if (bssid)
            {
                [dicWifi setObject: [NSString stringWithUTF8String:[bssid UTF8String]] forKey:@"BSSID"];
            }
            if (SSID)
            {
                [dicWifi setObject: [NSString stringWithUTF8String:[SSID UTF8String]] forKey:@"SSID"];
            }
            
            NSError* error;
            NSData *str = [NSJSONSerialization dataWithJSONObject:dicWifi
                                                          options:kNilOptions error:&error];
            
            if (str)
            {
                NSString* wifi = [[NSString alloc] initWithData:str encoding:NSUTF8StringEncoding];
                return wifi;
            }
        }
    }
    
    return nil;
}

// 获取udid
- (NSString*)getUdid
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    //  NSString* systemUDID = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString* strCount =    [SFHFKeychainUtils getPasswordForUsername:_STR_USERCONFIG_UDID
                                                       andServiceName:bundleIdentifier
                                                                error:nil];
    
    //长度不对
    if (strCount == nil  ||
        [strCount length]!=32 ||
        (strCount !=nil &&
         ([strCount isEqualToString:@"ae506bbded1cc5cb591c04922659a8d6"] || [strCount isEqualToString:@"b643f655a4bac138f04e404a024fe459"])
         )
        )
    {
        NSString* systemUDID = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        
        if ([systemUDID isEqualToString:@"ae506bbded1cc5cb591c04922659a8d6"])
        {
            //过滤特殊的
            systemUDID = [[OpenUDID_RN value] stringFromMD5];
        }
        
        if (systemUDID != nil)
        {
            [[UIDevice currentDevice] setUDID:systemUDID];
        }
        
        return systemUDID;
    }
    
    return strCount;
}

// 获取useragent
- (NSString*)getUserAgent
{
    return puseragent;
}

- (void)setUserAgent:(NSString*)useragent
{
    puseragent = useragent;
}

- (NSString*)getIdfa
{
    NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adid;
}

- (NSString*)getUpdateChannel
{
    NSDictionary* dictBundle = [[NSBundle mainBundle ] infoDictionary];
    if (dictBundle)
    {
        NSString* updatechannel = [dictBundle objectForKey:@"updatechannel"];
        if ([updatechannel length]>0) {
            return updatechannel;
        }
    }
    
    return nil;
}
@end
