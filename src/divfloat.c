/*******************************************************************************
* @brief        Divide 2 double numbers and return the result.                 *
* @file         divfloat.c                                                     *
* @author       Leandro - leandrohuff@programmer.net                           *
* @date         2025-09-01                                                     *
* @version      2.1.0                                                          *
* @copyright    CC01 1.0 Universal                                             *
* @syntax       divfloat <double> <double>                                     *
* @example      divfloat 6.2 2.0                                               *
*               3.1                                                            *
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/**
 @brief		Divide 2 double numbers and return the result
 @param		<double>	1st number
			<double>	2nd number
 @result	double		added numbers.
*/
int main(int argc, char *argv[])
{
	/* allocate 2 double variables */
    double d1=0.0f;
    double d2=0.0f;
	/* less than 2 command line parameters, return failure code. */
    if (argc < 2) return (EXIT_FAILURE);
    else
    {
    	/* translate parameters to double variables */
        d1=atof(argv[1]);
        d2=atof(argv[2]);
        /* check to avoid divide by zero */
        if (d2 > 0.0f || d2 < 0.0f)
        {
            d1=d1/d2;
            printf("%f",d1);
        }
        /* divide by zero, return failure code. */
        else return (EXIT_FAILURE);
    }
    /* return success */
    return (EXIT_SUCCESS);
}
