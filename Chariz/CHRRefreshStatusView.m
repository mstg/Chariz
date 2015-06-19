//
//  CHRRefreshStatusView.m
//  Chariz
//
//  Created by Adam D on 25/05/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRRefreshStatusView.h"

@implementation CHRRefreshStatusView {
	NSProgressIndicator *_progressIndicator;
	UXLabel *_label;
}

- (instancetype)init {
	self = [super init];
	
	if (self) {
		_progressIndicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 22.f, 22.f)];
		_progressIndicator.style = NSProgressIndicatorSpinningStyle;
		_progressIndicator.controlSize = NSSmallControlSize;
		[_progressIndicator startAnimation:nil];
		[self addSubview:_progressIndicator];
		
		_label = [[UXLabel alloc] init];
		_label.text = I18N(@"Updating sources…");
		_label.font = [NSFont titleBarFontOfSize:0];
		_label.centerVertically = YES;
		_label.frame = CGRectMake(_progressIndicator.frame.size.width + 4.f, 0, ceilf([_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width), _progressIndicator.frame.size.height);
		[self addSubview:_label];
	}
	
	return self;
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(_progressIndicator.frame.size.width + _label.frame.origin.x + _label.frame.size.width, _progressIndicator.frame.size.height);
}

- (NSString *)statusText {
	return _label.text;
}

- (void)setStatusText:(NSString *)statusText {
	_label.text = statusText;
	self.needsDisplay = YES;
}

@end
