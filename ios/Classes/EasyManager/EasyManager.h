//
//  EasyManager.h
//  QuZhanKe
//
//  Created by zhaoxx on 2018/7/16.
//  Copyright © 2018年 zsf. All rights reserved.
//

#ifndef EasyManager_h
#define EasyManager_h

@interface EasyManager : NSObject
+(instancetype) shareInstance;
-(void) copyToClipBoard:(NSObject*) prms;
-(void) openAppStoreSearchPage:(NSObject*) prms;
- (BOOL)isAppInstall:(NSDictionary*) str;
- (NSArray*)getInstallList:(NSDictionary*)str;
- (NSString *)getParseBundleIdString:(NSString *)description;
- (void)openSetting:(NSObject*) prms;

// 解析url参数
- (NSDictionary*)getUrlData:(NSString*) prms;
-(NSString *)encodeURIComponent:(NSString *)str;
-(NSString *)decodeURIComponent:(NSString *)str;

// 打开url
-(void)openUrlScheme:(NSString*) urlstr;

-(void)openQQGroup:(NSDictionary*)str;
@end

#endif /* EasyManager_h */
