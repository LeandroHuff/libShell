/*******************************************************************************
* @brief        Subtract 2 double numbers from command line.                   *
* @file         subfloat.c                                                     *
* @author       Leandro - leandrohuff@programmer.net                           *
* @date         2025-09-01                                                     *
* @version      2.1.0                                                          *
* @copyright    CC01 1.0 Universal                                             *
* @syntax       subfloat <double> <double>                                     *
* @example      subfloat 5.4 2.1                                               *
*               3.3                                                            *
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/**
 @brief		Subtract 2 double numbers from command line and return the result.
 @param		<double>	1st number
			<double>	2nd number
 @result	double		subtracted numbers.
*/
int main(int argc, char *argv[])
{
	/* allocate double variables */
    double d1=0.0f;
    double d2=0.0f;
	/* less than 2 command line parameters, return failure */
    if (argc < 2)
        return (EXIT_FAILURE);
    else
    {
    	/* translate command line parameters to double */
        d1=atof(argv[1]);
        d2=atof(argv[2]);
        /* subtract double numbers and print the result */
        d1=d1-d2;
        printf ("%f",d1);
    }
    /* return success */
    return EXIT_SUCCESS;
}
