//
//  CameraFeed.m
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraFeed.h"
#import <math.h>

@implementation CameraFeed

- (id)initAroundLocation:(CLLocationCoordinate2D)p
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        float r_x = rand() % 10;
        float r_x_pos = ((rand() % 2) == 0);
        float r_y = rand() % 10;
        float r_y_pos = ((rand() % 2) == 0);
        
        CLLocationDegrees x = p.latitude + r_x * (-1.0*r_x_pos);
        CLLocationDegrees y = p.longitude + r_y * (-1.0*r_y_pos);
        _loc = CLLocationCoordinate2DMake(x,y);
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return _loc;
}

- (NSString *)title
{
    return @"Camera";
}

- (NSString *)subtitle
{
    return @"Live Feed";
}

@end
