#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(int argc, char *argv[])
{
    double d1=0.0f;
    double d2=0.0f;

    if (argc < 2) return (EXIT_FAILURE);
    else
    {
        d1=atof(argv[1]);
        d2=atof(argv[2]);
        d1=d1*d2;
        printf("%f",d1);
    }
    return (EXIT_SUCCESS);
}
