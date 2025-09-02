/*******************************************************************************
* @brief        Compare 2 double numbers from command line, return the result. *
* @file         cmpfloat.c                                                     *
* @author       Leandro - leandrohuff@programmer.net                           *
* @date         2025-09-01                                                     *
* @version      2.1.0                                                          *
* @copyright    CC01 1.0 Universal                                             *
* @syntax       cmpfloat <double> <double>                                     *
* @example      cmpfloat 1.3 2.64                                              *
*               -1                                                             *
*               cmpfloat 3.0 1.2                                               *
*               1                                                              *
*               cmpfloat 5.1 5.1                                               *
*               0                                                              *
*******************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

/**
 @brief		Compare 2 double numbers from command line and return the result.
 @param		<double>	1st number.
 			<double>	2nd number.
 @return	-1			1st parameter is lower than 2nd parameter.
 			 0			bouth parameters is equal.
 			+1			1st parameter is greater than 2nd parameter.
*/
int main (int argc, char *argv[])
{
	/* allocate 2 double variables */
    double d1=0.0f;
    double d2=0.0f;
	/* less than 2 parameters from command line, return failure code. */
    if (argc < 2) return (EXIT_FAILURE);
    else
    {
    	/* translate command line parameters to double variables */
        d1=atof(argv[1]);
        d2=atof(argv[2]);
        /* compare variable numbers and print the result */
        if (d1 < d2) printf("%d", -1);
        else if (d1 > d2) printf("%d", 1);
        else printf("%d", 0);
    }
	/* return success */
    return EXIT_SUCCESS;
}
