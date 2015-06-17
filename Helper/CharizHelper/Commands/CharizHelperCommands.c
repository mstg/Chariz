//
//  CharizHelperCommands.c
//  Chariz
//
//  Created by Mustafa Gezen on 17.06.2015.
//	Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#include "CharizHelperCommands.h"
#include <syslog.h>

void check_brew(char additional_info[]) {
	syslog(LOG_NOTICE, "[Chariz] executed");
}