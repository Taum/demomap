//
//  MyAnnotation.h
//  mapapp
//
//  Created by Thomas Brian on 2019-10-25.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MyAnnotation : NSObject <MKAnnotation>

- (id)initWithFeedItem:(NSDictionary*)item;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

@property (nonatomic, readonly, copy, nullable) NSString *countryCode;

@end

NS_ASSUME_NONNULL_END
