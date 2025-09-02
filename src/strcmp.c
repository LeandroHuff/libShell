/*******************************************************************************
* @brief        Compare 2 strings from command line and return the result.     *
* @file         strcmp.c                                                       *
* @author       Leandro - leandrohuff@programmer.net                           *
* @date         2025-09-01                                                     *
* @version      2.1.0                                                          *
* @copyright    CC01 1.0 Universal                                             *
* @syntax       strcmp "1st string" "2nd string"                               *
* @example      strcmp "alpha" "bravo"                                         *
*               -1                                                             *
* @example      strcmp "delta" "charlie"                                       *
*               1                                                              *
* @example      strcmp "omega" "omega"                                         *
*               0                                                              *
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 @brief		Compare 2 strings from command line and return the result.
 @param		<string>	1st parameter
			<string>	2nd parameter
 @result	-1			1st parameter is lower than 2nd
 			 0			bouth is equal
 			+1			1st parameter is greater than 2nd
*/
int main(int argc, char *argv[])
{
	/* less than 2 command line paraemters, return failure */
    if ( argc < 2) exit (EXIT_FAILURE);
    /* print compare result */
    else printf( "%d" , strcmp(argv[1],argv[2]) );
    /* return success */
    exit (EXIT_SUCCESS);
}
