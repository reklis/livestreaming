//
//  CameraFeed.h
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CameraFeed : NSObject
<MKAnnotation>
{
@private
    CLLocationCoordinate2D _loc;
    
}

- (id)initAroundLocation:(CLLocationCoordinate2D)p;

@end
