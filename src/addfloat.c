/*******************************************************************************
* @brief        Add 2 double numbers from command line and return the result.  *
* @file         addfloat.c                                                     *
* @author       Leandro - leandrohuff@programmer.net                           *
* @date         2025-09-01                                                     *
* @version      2.1.0                                                          *
* @copyright    CC01 1.0 Universal                                             *
* @syntax       addfloat <double> <double>                                     *
* @example      addfloat 1.3 2.64                                              *
*               3.94                                                           *
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/**
	@brief		Add 2 double numbers from command line and return the result.
	@param		<double>	1st number
				<double>	2nd number
	@result		double		added numbers.
*/
int main(int argc, char *argv[])
{
	/* allocate 2 double variables */
    double d1=0.0f;
    double d2=0.0f;
	/* less than 2 arguments from command line, return failure code. */
    if (argc < 2) return (EXIT_FAILURE);
    else
    {
    	/* translate arguments to double numbers */
        d1=atof(argv[1]);
        d2=atof(argv[2]);
        /* add 2 double numbers */
        d1=d1+d2;
        /* print the results */
        printf("%f",d1);
    }
    /* return succes */
    return (EXIT_SUCCESS);
}
