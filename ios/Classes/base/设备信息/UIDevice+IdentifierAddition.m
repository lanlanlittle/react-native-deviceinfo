//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"
#import "SFHFKeychainUtils.h"

#import "OpenUDID_RN.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include "gameinfo.h"
#ifdef OPEN_IDFA
#import <AdSupport/AdSupport.h>
#endif




@interface UIDevice(Private)

- (NSString *) macaddress;

@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier
{
   // NSString *macaddress = [[UIDevice currentDevice] macaddress];
#ifdef OPEN_IDFA

    NSString* udid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
  
    if ([udid isEqualToString:@"00000000-0000-0000-0000-000000000000"])
    {//如果取不到 idfa  就取OpenUDID_RN
        udid = [OpenUDID_RN value];
    }

     udid = [NSString stringWithFormat:@"bl%@",udid]; //增加bl
    NSString *uniqueIdentifier = [udid stringFromMD5];
    
    return uniqueIdentifier;

#else
    NSString* udid = [OpenUDID_RN value];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",udid,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash stringFromMD5];
    
    return uniqueIdentifier;
#endif
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress stringFromMD5];
    
    return uniqueIdentifier;
}
#pragma mark udid

// 从keychain取出 没有生成
- (NSString*)getUDID
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
  //  NSString* systemUDID = [[UIDevice currentDevice] uniqueDeviceIdentifier];
   NSString* strCount =	[SFHFKeychainUtils getPasswordForUsername:_STR_USERCONFIG_UDID
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




- (void)setUDID:(NSString*)strUDID
{
    if (strUDID)
    {
        NSError* error = nil;
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        [SFHFKeychainUtils storeUsername:_STR_USERCONFIG_UDID
                             andPassword:strUDID
                          forServiceName:bundleIdentifier
                          updateExisting:YES error:&error];
    }
    
}

//获取OpenUDID_RN 先从keychain里取
-(NSString*)getKeyChainOpenUDID_RN
{
    //#if COCOS2D_DEBUG_REVIEW
    //    return [[NSString stringWithFormat:@"aaaaa"] stringFromMD5 ];
    //#endif
    NSString* udid =	[SFHFKeychainUtils getPasswordForUsername:_STR_USERCONFIG_OpenUDID_RN
                                                    andServiceName:@"blOpenUDID_RN"
                                                             error:nil];
    //  NSLog(@"%d",[strCount length]);
    //长度不对
    if (udid == nil )
    {
        
#ifdef OPEN_IDFA
        udid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     //   udid = [NSString stringWithFormat:@"bl%@",udid]; //增加bl
        udid = [udid stringFromMD5];
#else
        udid = [[OpenUDID_RN value] stringFromMD5];
#endif
        
        if (udid)
        {
            NSError* error = nil;
            // udid = [udid stringFromMD5];
            [SFHFKeychainUtils storeUsername:_STR_USERCONFIG_OpenUDID_RN
                                 andPassword:udid
                              forServiceName:@"blOpenUDID_RN"
                              updateExisting:YES error:&error];
        }
    }
    else if([udid length]!=32)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0  )
        {
#ifdef OPEN_IDFA
            udid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        //     udid = [NSString stringWithFormat:@"bl%@",udid];//增加bl
            udid = [udid stringFromMD5];
#else
        udid = [[OpenUDID_RN value] stringFromMD5];
#endif
        }
        else
        {
        udid = [[OpenUDID_RN value] stringFromMD5];
            
        }
        if (udid)
        {
            NSError* error = nil;
            // udid = [udid stringFromMD5];
            [SFHFKeychainUtils storeUsername:_STR_USERCONFIG_OpenUDID_RN
                                 andPassword:udid
                              forServiceName:@"blOpenUDID_RN"
                              updateExisting:YES error:&error];
        }
    }
    
    return udid;
}

-(NSString*) getMd5IDFA
{
    NSString* idfa= nil;
#ifdef  OPEN_IDFA
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0  )
    {
     idfa= [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    else
    {
        idfa = [OpenUDID_RN value];
    }
    idfa = [idfa stringFromMD5];
#endif
    return idfa;
}
@end
