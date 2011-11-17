//
//  main.m
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import "livestreamAppDelegate.h"

int main(int argc, char *argv[])
{
    srand ( time(NULL) );
    int retVal = 0;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([livestreamAppDelegate class]));
    [pool release];
    return retVal;
}
