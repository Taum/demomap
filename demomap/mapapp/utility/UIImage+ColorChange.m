//
//  UIImage+ColorChange.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-25.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "UIImage+ColorChange.h"


@implementation UIImage (ColorChange)

- (UIImage*)imageByChangingColorTo:(UIColor*)color {

    CGSize imgSize = self.size;
    UIImage *templateImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:imgSize];
    UIImage *newImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull ctx) {
        [color setFill];
        CGRect imgRect = CGRectMake(0, 0, imgSize.width, imgSize.height);
        [templateImage drawInRect:imgRect];
    }];
    
    return newImage;
}

@end
