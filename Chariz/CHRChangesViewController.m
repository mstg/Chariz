//
//  CHRChangesViewController.m
//  Chariz
//
//  Created by Adam D on 20/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRChangesViewController.h"
#import "CHRRefreshStatusView.h"
#import <CPMPackageManagerAggregate.h>

@implementation CHRChangesViewController {
	CHRRefreshState _refreshState;
	CHRRefreshStatusView *_refreshStatusView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = I18N(@"Recent");
	self.refreshState = CHRRefreshStateIdle;
	
	_refreshStatusView = [[CHRRefreshStatusView alloc] init];
}

- (CHRRefreshState)refreshState {
	return _refreshState;
}

- (void)setRefreshState:(CHRRefreshState)refreshState {
	_refreshState = refreshState;
	
	switch (refreshState) {
		case CHRRefreshStateIdle:
		{
			self.navigationItem.leftBarButtonItem = [[UXBarButtonItem alloc] initWithImage:[NSImage imageNamed:NSImageNameRefreshTemplate] style:UXBarButtonItemStyleBordered target:self action:@selector(beginRefresh)];
			break;
		}
		
		case CHRRefreshStateRefreshing:
			self.navigationItem.leftBarButtonItem = [[UXBarButtonItem alloc] initWithCustomView:_refreshStatusView];
			break;
		
		case CHRRefreshStateOffline:
			self.navigationItem.leftBarButtonItem.enabled = NO;
			break;
	}
}

- (void)beginRefresh {
	self.refreshState = CHRRefreshStateRefreshing;
	
	NSProgress *progress = [NSProgress progressWithTotalUnitCount:1];
	[progress addObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) options:NSKeyValueObservingOptionInitial context:nil];
	[progress addObserver:self forKeyPath:NSStringFromSelector(@selector(localizedDescription)) options:NSKeyValueObservingOptionInitial context:nil];
	[progress becomeCurrentWithPendingUnitCount:1];
	
	[[CPMPackageManagerAggregate sharedInstance] refreshWithCompletion:^(NSArray *errors) {
		[progress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
		[progress removeObserver:self forKeyPath:NSStringFromSelector(@selector(localizedDescription))];
		
		self.refreshState = CHRRefreshStateIdle;
		
		if (errors.count > 0) {
			NSMutableString *errorString = [NSMutableString string];
			
			if (errors.count == 1) {
				[errorString appendFormat:@"%@\n", ((NSError *)errors[0]).localizedDescription];
			} else {
				for (NSError *error in errors) {
					[errorString appendFormat:@"• %@\n", error];
				}
			}
			
			[errorString appendFormat:@"\n%@", I18N(@"This could mean a source is being blocked by a firewall, or the source is currently experiencing issues. Please try again later.")];
			
			NSAlert *alert = [[NSAlert alloc] init];
			alert.messageText = errors.count == 1 ? I18N(@"Could not refresh all sources because an error occurred.") : I18N(@"Could not refresh all sources because multiple errors occurred.");
			alert.informativeText = errorString;
			[alert beginSheetModalForWindow:self.view.window completionHandler:nil];
		}
	}];
	
	[progress resignCurrent];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSProgress *progress = object;
	
	if ([keyPath isEqualToString:NSStringFromSelector(@selector(fractionCompleted))]) {
		// TODO: implement loading indicator
		HBLogDebug(@"fractionCompleted = %f", progress.fractionCompleted);
	} else if ([keyPath isEqualToString:NSStringFromSelector(@selector(localizedDescription))]) {
		_refreshStatusView.statusText = progress.localizedDescription;
		HBLogDebug(@"localizedDescription = %@", progress.localizedDescription);
	}
}

@end
