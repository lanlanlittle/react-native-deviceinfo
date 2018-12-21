//
//  DeviceManager.h
//  QuZhanKe
//
//  Created by zhaoxx on 2018/7/14.
//  Copyright © 2018年 zsf. All rights reserved.
//

#ifndef DeviceManager_h
#define DeviceManager_h

@interface DeviceManager : NSObject
{
    NSString *puseragent;
}
+(instancetype) shareInstance;
//获取游戏版本
- (NSString*)getGameVer;
//获取手机类型
- (NSString*)getPhoneType;
// 获取渠道
- (NSString*)getBlchannel;
// 获取wifi
- (NSString*)getWifi;
// 获取udid
- (NSString*)getUdid;
// 获取useragent
- (NSString*)getUserAgent;
- (NSString*)getIdfa;
- (NSString*)getUpdateChannel;

- (void)setUserAgent:(NSString*)useragent;
@end

#endif /* DeviceManager_h */
