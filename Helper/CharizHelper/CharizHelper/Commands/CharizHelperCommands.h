//
//  CharizHelperCommands.h
//  
//
//  Created by Mustafa Gezen on 17.06.2015.
//
//

#ifndef ____CharizHelperCommands__
#define ____CharizHelperCommands__

#include <stdio.h>
#include <stdlib.h>

struct commands {
	char *command_name;
	void (*function)(char additional_info[]);
};

void check_brew(char additional_info[]);

static struct commands command_list[1][2] =
{
	{ "check_brew", &check_brew }
};

#endif
