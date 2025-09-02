/*******************************************************************************
* @brief        Calculate the string lenght.                                   *
* @file         strlen.c                                                       *
* @author       Leandro - leandrohuff@programmer.net                           *
* @date         2025-09-01                                                     *
* @version      2.1.0                                                          *
* @copyright    CC01 1.0 Universal                                             *
* @syntax       strlen <string>                                                *
* @example      strlen "abcdefghij"                                            *
*               10                                                             *
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 @brief		Calculate the string lenght of a command line parameter.
 @param		<string>	String to calculate the lenght
 @result	lenght		String lenght.
*/
int main(int argc, char *argv[])
{
	/* less than 1 command line parameter, return failure */
    if (argc < 1) return ( EXIT_FAILURE );
    /* print string lenght */
    else printf("%lu",strlen(argv[1]));
    /* return success */
    return (EXIT_SUCCESS);
}
