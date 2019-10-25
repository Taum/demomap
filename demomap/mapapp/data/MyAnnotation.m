//
//  MyAnnotation.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-25.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

/**
  Example data:
    {
        "id": 1,
        "name": "STM",
        "code": "STM",
        "feed_network_name": null,
        "timezone": "America/Montreal",
        "bounds": {
            "min_lat": 45.2679,
            "max_lat": 45.8312,
            "min_lon": -74.0912,
            "max_lon": -73.3466
        },
        "end_date": "2020-01-05",
        "start_date": "2019-10-17",
        "bgtfs_uploaded_at": "2019-10-23T17:52:20Z",
        "location": "Montréal",
        "country_code": "CA",
        "bgtfs_hash": "01458b33cdad95df28ddcf64eeb16da4"
    }
 */

- (id)initWithFeedItem:(NSDictionary *)item {
    self = [super init];
    if (self) {
        CLLocationDegrees minLat = [[item valueForKeyPath:@"bounds.min_lat"] doubleValue];
        CLLocationDegrees maxLat = [[item valueForKeyPath:@"bounds.max_lat"] doubleValue];
        CLLocationDegrees minLon = [[item valueForKeyPath:@"bounds.min_lon"] doubleValue];
        CLLocationDegrees maxLon = [[item valueForKeyPath:@"bounds.max_lon"] doubleValue];
            
        CLLocationDegrees lat = (minLat + maxLat) / 2.0;
        CLLocationDegrees lon = (minLon + maxLon) / 2.0;
        
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
        _title = [[item valueForKey:@"name"] copy];
        _subtitle = [[item valueForKey:@"location"] copy];
        _countryCode = [[item valueForKey:@"country_code"] copy];
    }
    return self;
}

@end
