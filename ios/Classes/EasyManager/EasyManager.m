//
//  EasyManager.m
//  QuZhanKe
//
//  Created by zhaoxx on 2018/7/16.
//  Copyright © 2018年 zsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation EasyManager

static EasyManager* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}

-(void) copyToClipBoard:(NSObject*) prms
{
    if (prms && [prms isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dict = (NSDictionary*) prms;
        if (dict)
        {
            NSString* shareText = [dict objectForKey:@"content"];
            if (shareText == nil) {
                return;
            }
            [[UIPasteboard generalPasteboard] setPersistent:YES];
            [[UIPasteboard generalPasteboard] setValue:shareText forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        }
    }
}

-(void) openAppStoreSearchPage:(NSObject*) prms
{
    NSString* SearchFormat = @"itms-apps://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=all";
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        SearchFormat = @"https://search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=Software";
    }
    
    NSString *search = SearchFormat;
    NSString *sstring = [NSString stringWithFormat:SearchFormat, [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL* url = [NSURL URLWithString:sstring];

    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open %d",success);
                                     }];
        } else
        {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }

    } else
    {
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (BOOL)isAppInstall:(NSDictionary*) str
{
    //iOS 11 判断APP是否安装
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        NSString* mbfwaokpath = [str objectForKey:@"mbfwaokpath"];
        NSString* mbclsscont = [str objectForKey:@"mbclsscont"];
        NSString* mbcontideni = [str objectForKey:@"mbcontideni"];
        NSBundle *container = [NSBundle bundleWithPath:mbfwaokpath];
        if ([container load]) {
            Class appContainer = NSClassFromString(mbclsscont);

            id test = [appContainer performSelector:(NSSelectorFromString(mbcontideni)) withObject:[str objectForKey:@"bundle_id"] withObject:nil];
            NSLog(@"%@",test);
            if (test) {
                return YES;
            } else {
                return NO;
            }
        }
        return NO;

    } else {
        NSArray* arr = [self getInstallList: [str objectForKey:@"bundle_id"]];
        for (NSInteger n = 0; n < arr.count; n ++) {
            if([arr[n] isEqualToString:str]){
                return YES;
            }
        }

        return NO;
    }
}

- (NSArray*)getInstallList:(NSDictionary*)str
{
    NSString* defaultws = [str objectForKey:@"defaultws"];
    NSString* allapps = [str objectForKey:@"allapps"];
    //非iOS11通过获取安装列表判断即可
    NSString* lsappws = [str objectForKey:@"lsappws"];
    Class lsappws_class = objc_getClass([lsappws UTF8String]);
    NSObject* workspace = [lsappws_class performSelector:NSSelectorFromString(defaultws)];
    NSArray *Arr = [workspace performSelector:NSSelectorFromString(allapps)];
    
    for (id obj in Arr) {
        NSLog(@"obj:%@", obj);
    }
    NSLog(@"apps: %@", [workspace performSelector:NSSelectorFromString(allapps)]);
    
    return Arr;
}

- (NSString *)getParseBundleIdString:(NSString *)description
{
    NSString * ret = @"";
    NSString * target = [description description];
    
    // iOS8.0 "LSApplicationProxy: com.apple.videos",
    // iOS8.1 "<LSApplicationProxy: 0x898787998> com.apple.videos",
    // iOS9.0 "<LSApplicationProxy: 0x145efbb0> com.apple.PhotosViewService <file:///Applications/PhotosViewService.app>"
    
    if (target == nil)
    {
        return ret;
    }
    NSArray * arrObj = [target componentsSeparatedByString:@" "];
    switch ([arrObj count])
    {
        case 2: // [iOS7.0 ~ iOS8.1)
        case 3: // [iOS8.1 ~ iOS9.0)
        {
            ret = [arrObj lastObject];
        }
            break;
            
        case 4: // [iOS9 +)
        {
            ret = [arrObj objectAtIndex:2];
        }
            break;
            
        default:
            break;
    }
    return ret;
}

- (void)openSetting:(NSObject*) prms
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        NSURL*url = [NSURL URLWithString:@"App-Prefs:root=Privacy"];
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open %d",success);
                                     }];
        } else
        {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else
    {
        NSURL*url = [NSURL URLWithString:@"prefs:root=General"];
    
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (NSDictionary*)getUrlData:(NSString*) prms
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if(prms)
    {
        NSArray* arrData = [prms componentsSeparatedByString:@"&"];
        if(arrData.count > 0)
        {
            for (NSUInteger i = 0; i < arrData.count; i ++)
            {
                NSArray* keyvalue = [arrData[i] componentsSeparatedByString:@"="];
                if(keyvalue.count > 1)
                {
                    if([keyvalue[0] compare:@"url"] == NSOrderedSame)
                    {
                        NSString *decodeString = [self decodeURIComponent: keyvalue[1]];
                        [dic setObject:decodeString forKey:keyvalue[0]];
                    }
                    else
                        [dic setObject:keyvalue[1] forKey:keyvalue[0]];
                }
            }
        }
    }
    
    return dic;
}

-(NSString *)encodeURIComponent:(NSString *)str
{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//decode URL string

-(NSString *)decodeURIComponent:(NSString *)str
{
    
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

-(void)openUrlScheme:(NSString*) urlstr
{
    NSURL* url = [NSURL URLWithString:urlstr];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open %d",success);
                                     }];
        } else
        {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else
    {
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(void)openQQGroup:(NSDictionary*)str
{
    NSLog(@"openQQGroup");

    if(str != NULL){
        NSString* uin = [str objectForKey:@"uin"];
        NSString* key = [str objectForKey:@"key"];
        
        NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", uin,key];
        [[EasyManager shareInstance] openUrlScheme:urlStr];
    }
    else
    {

    }
}
@end
