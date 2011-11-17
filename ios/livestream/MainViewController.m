//
//  MainViewController.m
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppSettings.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation MainViewController

@synthesize map = _map;
@synthesize flipsidePopoverController = _flipsidePopoverController;

- (void)dealloc {
    [_map release];
    [_flipsidePopoverController release];
    [_locMgr release];
    [_cameraFeeds release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locMgr = [[CLLocationManager alloc] init];
        _locMgr.delegate = self;
        
        [_locMgr setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [_locMgr startUpdatingLocation];
        
        self.title = NSLocalizedString(@"Locating...", @"Locating...");
    } else {
        [self initCameraFeedsInLocation:[self.map centerCoordinate]];
    }
}

- (void)viewDidUnload
{
    [_locMgr release];
    _locMgr = nil;
    
    [_cameraFeeds release];
    _cameraFeeds = nil;
    
    [self setMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (IBAction)showInfo:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
    } else {
        if (!self.flipsidePopoverController) {
            FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
            controller.delegate = self;
            
            self.flipsidePopoverController = [[[UIPopoverController alloc] initWithContentViewController:controller] autorelease];
        }
        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
        } else {
            [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

- (void)initCameraFeedsInLocation:(CLLocationCoordinate2D)coords
{
    CameraFeed* c = [[[CameraFeed alloc] initAroundLocation:coords] autorelease];
    if (!_cameraFeeds) {
        _cameraFeeds = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    [_cameraFeeds addObject:c];
    [self.map addAnnotation:c];
    
    [self.map setCenterCoordinate:[c coordinate]];
    [self.map setRegion:MKCoordinateRegionMake([c coordinate], MKCoordinateSpanMake(10, 10)) animated:YES];
    
    [self performSelector:@selector(selectAnnotation:) withObject:c afterDelay:2.5];
}

- (void) selectAnnotation:(id<MKAnnotation>)annotation
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.map selectAnnotation:annotation animated:YES];
    });
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.map setShowsUserLocation:YES];
    
    if (!_cameraFeeds) {
        CLLocationCoordinate2D coords = [newLocation coordinate];
        
        [self initCameraFeedsInLocation:coords];
        [_locMgr stopUpdatingLocation];
        
        self.title = [NSString stringWithFormat:@"%.2f, %.2f", coords.latitude, coords.longitude];
    }
}


#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CameraFeed class]]) {
        static NSString* viewId = @"camerafeed";
        MKPinAnnotationView* dropPin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
        if (nil == dropPin) {
            dropPin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                      reuseIdentifier:viewId] autorelease];

            dropPin.pinColor = MKPinAnnotationColorPurple;
            dropPin.animatesDrop = YES;
            dropPin.canShowCallout = YES;
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightButton addTarget:self
//                            action:@selector(showDetails:)
//                  forControlEvents:UIControlEventTouchUpInside];
            dropPin.rightCalloutAccessoryView = rightButton;
            
        } else {
            dropPin.annotation = annotation;
        }
        
        return dropPin;
        
    } else {
        return nil; // user location
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSURL* feed = [[AppSettings sharedSettings] feedUrl];
    
    NSAssert(feed != nil, @"feed is nil");
    NSLog(@"%@", feed);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    MPMoviePlayerViewController* playerController = [[[MPMoviePlayerViewController alloc] initWithContentURL:feed] autorelease];
    [self presentMoviePlayerViewControllerAnimated:playerController];
}

- (void) moviePlayerDidFinish:(NSNotification*)n
{
    MPMovieFinishReason reason = [[[n userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    if (reason == MPMovieFinishReasonPlaybackError) {
        NSError* e = [[n userInfo] objectForKey:@"error"];
        NSLog(@"Error with feed url %@", [e localizedDescription]);
        
        UIAlertView* errorView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Feed Error", @"Feed Error")
                                                             message:[e localizedDescription]
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                   otherButtonTitles:nil] autorelease];
        [errorView show];
        
    } else {
        [self dismissMoviePlayerViewControllerAnimated];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissMoviePlayerViewControllerAnimated];
}

@end
