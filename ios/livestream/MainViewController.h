//
//  MainViewController.h
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CameraFeed.h"

@interface MainViewController : UIViewController
<FlipsideViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate>
{
    UIPopoverController* _flipsidePopoverController;
    MKMapView *_map;
    CLLocationManager* _locMgr;
    
    NSMutableArray* _cameraFeeds;
}

@property (nonatomic, readwrite, retain) IBOutlet MKMapView *map;

@property (nonatomic, readwrite, retain) UIPopoverController *flipsidePopoverController;

- (IBAction)showInfo:(id)sender;

- (void) initCameraFeedsInLocation:(CLLocationCoordinate2D)coords;
- (void) selectAnnotation:(id<MKAnnotation>)annotation;

- (void) moviePlayerDidFinish:(NSNotification*)n;


@end
