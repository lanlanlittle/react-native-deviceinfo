//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define _STR_USERCONFIG_UDID                        @"userudid"                 //用户的UDID 如果用户修改UDID就无法使用软件
#define _STR_USERCONFIG_OPENUDID                        @"bailinopenudid"

@interface UIDevice (IdentifierAddition)

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;


#pragma mark udid
- (NSString*)getUDID;
- (void)setUDID:(NSString*)strUDID;

//获取openudid 先从keychain里取
-(NSString*)getKeyChainOpenUDID;

-(NSString*) getMd5IDFA;
@end
