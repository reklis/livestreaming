//
//  livestreamAppDelegate.h
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface livestreamAppDelegate : UIResponder <UIApplicationDelegate>

@property (readwrite, nonatomic, retain) UIWindow *window;

@property (readwrite, nonatomic, retain) MainViewController *mainViewController;

@end
