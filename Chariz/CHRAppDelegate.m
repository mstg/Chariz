//
//  CHRAppDelegate.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRAppDelegate.h"
#import "CHRRootViewController.h"
#import "CHRFirstLaunchSource.h"
#import "CHRPreferences.h"

static NSString *const kCHRUserDefaultsRootWindowFrameKey = @"RootWindowFrame";

@implementation CHRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	if ([CHRPreferences sharedInstance].firstLaunch == NO) {
		_rootWindowController = [[UXWindowController alloc] initWithRootViewController:[[CHRFirstLaunchSource alloc] init]];
	} else {
		_rootWindowController = [[UXWindowController alloc] initWithRootViewController:[[CHRRootViewController alloc] init]];
	}

	_rootWindowController.window.minSize = CGSizeMake(1000.f, 500.f);
	_rootWindowController.window.contentSize = CGSizeMake(1000.f, 800.f);
	[_rootWindowController.window center];
	_rootWindowController.windowFrameAutosaveName = kCHRUserDefaultsRootWindowFrameKey;
	[_rootWindowController showWindow:self];
	
	[CHRPreferences sharedInstance].lastLaunch = [NSDate date];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
