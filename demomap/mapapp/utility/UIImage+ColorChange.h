//
//  UIImage+ColorChange.h
//  mapapp
//
//  Created by Thomas Brian on 2019-10-25.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ColorChange)

- (UIImage*)imageByChangingColorTo:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
