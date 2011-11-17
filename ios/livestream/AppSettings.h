//
//  AppSettings.h
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



@interface AppSettings : NSObject

+ (AppSettings*) sharedSettings;

- (NSURL*) feedUrl;

@end
