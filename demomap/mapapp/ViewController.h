//
//  ViewController.h
//  mapapp
//
//  Created by Thomas Brian on 2019-10-23.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSArray *feedData;

@end

