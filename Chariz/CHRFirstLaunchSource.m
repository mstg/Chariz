//
//  CHRFirstLaunchSource.m
//  Chariz
//
//  Created by Mustafa Gezen on 14.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRFirstLaunchSource.h"
#import "CHRFirstLaunchViewController.h"

@implementation CHRFirstLaunchSource

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.rootViewControllers = @[
		[[CHRFirstLaunchViewController alloc] init]
	];
}

@end
