//
//  WapActionManager.h
//  QuZhanKe
//
//  Created by zhaoxx on 2018/7/14.
//  Copyright © 2018年 zsf. All rights reserved.
//

#ifndef WapActionManager_h
#define WapActionManager_h

@interface WapActionManager : NSObject
+(instancetype) shareInstance;
-(NSDictionary*)getIosDeviceInfo:(NSDictionary*)str;
@end

#endif /* WapActionManager_h */
