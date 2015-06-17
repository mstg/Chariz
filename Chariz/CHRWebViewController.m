//
//  CHRWebViewController.m
//  Chariz
//
//  Created by Adam D on 6/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRWebViewController.h"
#import "CHREmailSendingController.h"
#import "CHRLoadingIndicatorView.h"
#import "CHRHelper.h"


static NSString *const kCHRWebViewUserScript = @"(function(window, undefined) {"
	"var handlers = webkit.messageHandlers;"
	"window.chariz = {};"

	"for (var i in handlers) {"
		"if (handlers.hasOwnProperty(i)) {"
			"window.chariz[i] = function() {"
				"handlers[i].postMessage.apply(this, arguments.length == 0 ? [ null ] : arguments);"
			"};"
		"}"
	"}"
"})(window, undefined)";

@implementation CHRWebViewController {
	CHRLoadingIndicatorView *_loadingIndicatorView;
	NSURLRequest *_initialRequest;
}

+ (Class)viewControllerClassForURL:(NSURL *)url {
	// TODO: implement
	HBLogInfo(@"url: %@", url);
	return CHRWebViewController.class;
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
	self = [super init];
	
	if (self) {
		_initialRequest = [request copy];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.title = I18N(@"Untitled");
	
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.preferences.plugInsEnabled = NO;
	configuration.preferences.javaEnabled = NO; // probably redundant?
	
	_userContentController = [[WKUserContentController alloc] init];
	[_userContentController addUserScript:[[WKUserScript alloc] initWithSource:kCHRWebViewUserScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO]];
	configuration.userContentController = _userContentController;
	
	_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
	_webView.autoresizingMask = UXViewAutoresizingFlexibleWidth | UXViewAutoresizingFlexibleHeight;
	_webView.UIDelegate = self;
	_webView.navigationDelegate = self;
	[self.view addSubview:_webView];
	
	_loadingIndicatorView = [[CHRLoadingIndicatorView alloc] init];
	self.navigationItem.leftBarButtonItem = [[UXBarButtonItem alloc] initWithCustomView:_loadingIndicatorView];
	
	if (_initialRequest) {
		[self.webView loadRequest:_initialRequest];
		_initialRequest = nil;
	}
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	[_loadingIndicatorView startAnimation:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	[_loadingIndicatorView stopAnimation:nil];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
	if (!navigationAction.targetFrame) {
		Class viewControllerClass = [self.class viewControllerClassForURL:navigationAction.request.URL];
		
		CHRWebViewController *viewController = [[viewControllerClass alloc] initWithRequest:navigationAction.request];
		[self.navigationController pushViewController:viewController animated:YES];
		
		return nil;
	}
	
	HBLogWarn(@"%@: attempting to perform a navigation action in a frame that's not supported", self);
	return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler {
	// TODO: implement
	HBLogDebug(@"alert: %@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
	// TODO: implement
	HBLogDebug(@"confirm: %@", message);
	completionHandler(NO);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler {
	// TODO: implement
	HBLogDebug(@"prompt: %@", prompt);
	completionHandler(@"");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
	if ([navigationAction.request.URL.scheme isEqualToString:@"mailto"]) {
		decisionHandler(WKNavigationActionPolicyCancel);
		
		CHREmailSendingController *emailSendingController = [[CHREmailSendingController alloc] init];
		[emailSendingController handleEmailWithURL:navigationAction.request.URL window:self.view.window];
	} else if ([navigationAction.request.URL.scheme isEqualToString:@"startinstall"]) {
		decisionHandler(WKNavigationActionPolicyCancel);
		CHRHelper *helper = [[CHRHelper alloc] init];
		NSError *createHelper = [helper blessService];
		if (createHelper) {
			HBLogError(@"Failed to create Helper. Error: %@", createHelper);
			NSAlert *alert = [[NSAlert alloc] init];
			[alert setMessageText:[NSString stringWithFormat:@"Failed to create Helper. Error: %@", createHelper]];
			[alert runModal];
			exit(0);
		} else {
			[helper startXPCService];
			[helper sendXPCRequest:"check_brew" completed:^(void){
				
			}];
		}
	} else {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
	HBLogDebug(@"unhandled script message: %@", message);
}

@end
