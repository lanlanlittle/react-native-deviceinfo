//
//  UIColor+NSString.h
//  majiang
//
//  Created by 张纲 on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NSString)
 
//通过字符串转颜色 RGB
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
//通过字符串转颜色 BGR
+ (UIColor *) colorWithHexStringWithBGR: (NSString *) stringToConvert;


@end
