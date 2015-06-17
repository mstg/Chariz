//
//  CHRFirstLaunchViewController.m
//  Chariz
//
//  Created by Mustafa Gezen on 14.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRFirstLaunchViewController.h"
#import "CHRLoadingIndicatorView.h"

#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>

@implementation CHRFirstLaunchViewController

- (void)loadView {
    [super loadView];
	
	self.title = @"Setup";
	
	NSURL *html = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"first_launch" ofType:@"html"] isDirectory:NO];
	[self.webView loadRequest:[NSURLRequest requestWithURL:html]];
}

@end