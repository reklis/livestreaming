//
//  AppSettings.m
//  livestream
//
//  Created by sfusco on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppSettings.h"

#define kUrlIdentifier @"url_identifier"

@implementation AppSettings

+ (AppSettings*) sharedSettings
{
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kUrlIdentifier];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
		NSString *urlDefault = nil;
		
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:kUrlIdentifier])
			{
				urlDefault = defaultValue;
			}
		}
        
		// since no default values have been set (i.e. no preferences file created), create it here		
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     urlDefault, kUrlIdentifier,
                                     nil];
        
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
    return [[[self alloc] init] autorelease];
}

- (NSURL*) feedUrl
{
    return [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kUrlIdentifier]];
}

@end
