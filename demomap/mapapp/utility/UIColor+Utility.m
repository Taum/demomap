//
//  UIColor+Utility.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-25.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
