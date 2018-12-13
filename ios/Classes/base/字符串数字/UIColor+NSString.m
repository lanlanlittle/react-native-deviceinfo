//
//  UIColor+NSString.m
//  majiang
//
//  Created by 张纲 on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+NSString.h"

@implementation UIColor (NSString)


+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) 
    {
       return nil;     
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
      cString = [cString substringFromIndex:2];      
    }
    if ([cString hasPrefix:@"#"]) 
    {
       cString = [cString substringFromIndex:1]; 
    }
    if ([cString length] != 6) 
    {
        return nil;    
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//通过字符串转颜色 BGR
+ (UIColor *) colorWithHexStringWithBGR: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) 
    {
        return nil;     
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];      
    }
    if ([cString hasPrefix:@"#"]) 
    {
        cString = [cString substringFromIndex:1]; 
    }
    if ([cString length] != 6) 
    {
        return nil;    
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:bString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:rString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];

}


@end
