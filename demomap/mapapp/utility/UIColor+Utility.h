//
//  UIColor+Utility.h
//  mapapp
//
//  Created by Thomas Brian on 2019-10-25.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Utility)

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
