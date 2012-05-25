//
//  ViewController.m
//  HappiestPlaceOnEarth
//
//  Created by T. Binkowski on 5/24/12.
//  Copyright (c) 2012 University of Chicago. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

#import "MyLocation.h"


#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end

@implementation ViewController

@synthesize locationManager = _locationManager;
@synthesize mapView = _mapView;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecyle
////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDistanceFilter:500]; // meters
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setHeadingFilter:kCLDistanceFilterNone];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Location Delegate
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
 * @method          <# Method Name #>
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{ 
    NSLog(@"%@", newLocation);
    NSString *prettyLocation = [NSString stringWithFormat:@"%.2f %.2f",
                                newLocation.coordinate.longitude,
                                newLocation.coordinate.latitude];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Location Set In Simulator" 
                                                    message:prettyLocation
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)locationManager:(CLLocationManager *)manager  didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"%@",newHeading);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
 * @method          tapShowLocation
 * @abstract        Pan to a new location on the map based on the current user location
 * @description     Location has to be simulated on iOS simulator
 ******************************************************************************/
- (IBAction)tapShowLocation:(UIBarButtonItem *)sender 
{
    CLLocation *userLoc = self.mapView.userLocation.location;
    [self.mapView setCenterCoordinate:userLoc.coordinate animated:YES];
}

- (IBAction)tapGoToDisney:(UIBarButtonItem *)sender {
    
    // Set the initial position of the map
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 28.53806;
    zoomLocation.longitude = -81.37944;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10*METERS_PER_MILE, 10*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
    [self.mapView setRegion:adjustedRegion animated:YES];  
}

- (IBAction)tapDropPins:(UIBarButtonItem *)sender {
    // Remove existing
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }

    // Add some new pins
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = 28.53806;
    coordinates.longitude = -81.37944;
    MyLocation *annotation = [[MyLocation alloc] initWithName:@"Disney World" address:@"Orlando" coordinate:coordinates];
    [self.mapView addAnnotation:annotation];
    
    // Add another point
    CLLocationCoordinate2D coordinates2;
    coordinates2.latitude = 41.7897563;
    coordinates2.longitude = -87.5997711;
    MyLocation *annotation2 = [[MyLocation alloc] initWithName:@"University of Chicago" address:@"Chicago" coordinate:coordinates2];
    [self.mapView addAnnotation:annotation2];

}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Map Helpers
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
 * @method          mapView
 * @abstract        <# Abstract #>
 * @description     <# Description #>
 ******************************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";   
    
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MyLocation *location = (MyLocation *) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:location reuseIdentifier:identifier];
        } else {
            annotationView.annotation = location;
        }
        
        // Set the pin properties
        annotationView.animatesDrop = YES;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        // Show Mickey
        if ([location.title isEqualToString:@"Disney World"]) {
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"MickeyMouse.png"]];
        } else {
            // Since we are reusing cells we need to nil out the inmage
            annotationView.leftCalloutAccessoryView = nil;
        }
        return annotationView;
    }
    
    return nil; 
}

/*******************************************************************************
 * @method          mapView:annotationView:calloutAccesoryControlTapped
 * @abstract        When annotation is tapped
 * @description     <# Description #>
 ******************************************************************************/
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%@ %@",view,control);
}
@end





