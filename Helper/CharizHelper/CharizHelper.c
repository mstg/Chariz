//
//  CharizHelper.c
//	Chariz
//
//  Created by Mustafa Gezen on 16.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#include <syslog.h>
#include <xpc/xpc.h>
#include "CharizHelperCommands.h"

static void __XPC_Peer_Event_Handler(xpc_connection_t connection, xpc_object_t event) {
	xpc_type_t type = xpc_get_type(event);
    
	if (type == XPC_TYPE_ERROR) {
		if (event == XPC_ERROR_CONNECTION_INVALID) {
			// tear down
            
		} else if (event == XPC_ERROR_TERMINATION_IMMINENT) {
			// clean up
		}
        
	} else {
        xpc_connection_t remote = xpc_dictionary_get_remote_connection(event);
		
		xpc_object_t reply = xpc_dictionary_create_reply(event);
		const char *request = xpc_dictionary_get_string(event, "request");
		
		char *_reply = "";
		
		for ( int i = 0; i < 1; i++ ) {
			char *func_name = command_list[0][0].command_name;
			if (strcmp(request, func_name) == 0) {
				command_list[0][0].function("");
				_reply = "executed";
			}
		}
		
		xpc_dictionary_set_string(reply, "reply", _reply);
		xpc_connection_send_message(remote, reply);
		xpc_release(reply);
	}
}

static void __XPC_Connection_Handler(xpc_connection_t connection)  {
	xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
		__XPC_Peer_Event_Handler(connection, event);
	});
	
	xpc_connection_resume(connection);
}

int main(int argc, const char *argv[]) {
	xpc_connection_t service = xpc_connection_create_mach_service("io.chariz.CharizHelper",
                                                                  dispatch_get_main_queue(),
                                                                  XPC_CONNECTION_MACH_SERVICE_LISTENER);
    
    if (!service) {
        exit(EXIT_FAILURE);
    }
	
	
    xpc_connection_set_event_handler(service, ^(xpc_object_t connection) {
        __XPC_Connection_Handler(connection);
	});
	
	syslog(LOG_NOTICE, "[Chariz] Test");
	
    xpc_connection_resume(service);
    
    dispatch_main();
    
    xpc_release(service);
    
    return EXIT_SUCCESS;
}

