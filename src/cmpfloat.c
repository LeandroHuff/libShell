#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

int main (int argc, char *argv[])
{
    double d1=0.0f;
    double d2=0.0f;

    if (argc < 2) return (EXIT_FAILURE);
    else
    {
        d1=atof(argv[1]);
        d2=atof(argv[2]);
        if (d1 < d2) printf("%d", -1);
        else if (d1 > d2) printf("%d", 1);
        else printf("%d", 0);
    }
    return EXIT_SUCCESS;
}
