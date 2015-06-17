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
}
- (NSError *)blessService;
- (void)startXPCService;
typedef void(^completed)(void);
- (void)sendXPCRequest:(const char *)message completed:(completed)comp;
- (const char*)last_response;
@end
