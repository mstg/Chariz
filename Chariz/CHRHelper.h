//
//  CHRHelper.h
//  Chariz
//
//  Created by Mustafa Gezen on 15.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>

@interface CHRHelper : NSObject {
	xpc_connection_t con;
	const char* last_response;
	NSInteger _brew_installed;
	NSString *_install_status;
	NSInteger _dpkg_installed;
}
- (NSError *)blessService;
- (void)startXPCService;
typedef void(^completed)(void);
- (void)sendXPCRequest:(const char *)message completed:(completed)comp;
- (NSString *)last_response;
- (void) check_brew:(completed)comp;
- (void)install_brew:(completed)comp;
- (void) check_dpkg:(completed)comp;
- (void) install_dpkg:(completed)comp;
- (NSString *)install_status;
- (NSInteger)dpkg_installed;
- (NSInteger)brew_installed;
typedef void (^comp)(NSError *error, id json, NSString *output, NSString *errorOutput);
@end
