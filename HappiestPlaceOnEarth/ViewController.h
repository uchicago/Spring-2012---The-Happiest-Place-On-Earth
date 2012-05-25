//
//  ViewController.h
//  HappiestPlaceOnEarth
//
//  Created by T. Binkowski on 5/24/12.
//  Copyright (c) 2012 University of Chicago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController 
<CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)tapShowLocation:(UIBarButtonItem *)sender;
- (IBAction)tapGoToDisney:(UIBarButtonItem *)sender;
- (IBAction)tapDropPins:(UIBarButtonItem *)sender;

@end
