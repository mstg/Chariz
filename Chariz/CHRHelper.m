//
//  CHRHelper.m
//  Chariz
//
//  Created by Mustafa Gezen on 15.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import "CHRHelper.h"

@implementation CHRHelper
- (NSError *)blessService {
	AuthorizationItem authItem		= { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
	AuthorizationRights authRights	= { 1, &authItem };
	AuthorizationFlags flags		=	kAuthorizationFlagDefaults				|
	kAuthorizationFlagInteractionAllowed	|
	kAuthorizationFlagPreAuthorize			|
	kAuthorizationFlagExtendRights;
	
	AuthorizationRef authRef = NULL;
	CFErrorRef tError;
	
	/* Obtain the right to install privileged helper tools (kSMRightBlessPrivilegedHelper). */
	OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
	if (status != errAuthorizationSuccess) {
		HBLogError(@"Failed to create AuthorizationRef. Error code: %d", (int)status);
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Authorization failed"];
		[alert runModal];
		exit(0);
	} else {
		/* This does all the work of verifying the helper tool against the application
		 * and vice-versa. Once verification has passed, the embedded launchd.plist
		 * is extracted and placed in /Library/LaunchDaemons and then loaded. The
		 * executable is placed in /Library/PrivilegedHelperTools.
		 */
		SMJobBless(kSMDomainSystemLaunchd, CFSTR("io.chariz.CharizHelper"), authRef, &tError);
	}
	
	return (__bridge NSError *)(tError);
}

- (void)startXPCService {
	xpc_connection_t connection = xpc_connection_create_mach_service("io.chariz.CharizHelper", NULL, XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);
	
	if (!connection) {
		HBLogError(@"Connection could not be established");
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Connection to XPC could not be established"];
		[alert runModal];
		exit(0);
	} else {
		xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
			xpc_type_t type = xpc_get_type(event);
			
			if (type == XPC_TYPE_ERROR) {
				
				if (event == XPC_ERROR_CONNECTION_INTERRUPTED) {
					HBLogError(@"XPC connection interupted.");
					
				} else if (event == XPC_ERROR_CONNECTION_INVALID) {
					HBLogError(@"XPC connection invalid, releasing.");
					
				} else {
					HBLogError(@"Unexpected XPC connection error.");
				}
				
			} else {
				HBLogError(@"Unexpected XPC connection event.");
			}
		});
		
		xpc_connection_resume(connection);
		
		self->con = connection;
	}
}

- (void)sendXPCRequest:(const char *)message completed:(completed)comp {
	if (!self->con) {
		HBLogError(@"Establish XPC connection first");
		return;
	}
	
	xpc_object_t message_request = xpc_dictionary_create(NULL, NULL, 0);
	xpc_dictionary_set_string(message_request, "request", message);
	
	HBLogInfo(@"Sending request: %s", message);
	
	xpc_connection_send_message_with_reply(self->con, message_request, dispatch_get_main_queue(), ^(xpc_object_t event) {
		const char* response = xpc_dictionary_get_string(event, "reply");
		self->last_response = response;
		HBLogInfo(@"Received response: %s.", response);
		comp();
	});
}

- (const char*)last_response {
	return self->last_response;
}


@end
