#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

int main (int argc, char *argv[])
{
    double d1=0.0f;
    double d2=0.0f;
    double d3=0.0f;

    if (argc < 3) return (EXIT_FAILURE);
    else
    {
        d1=atof(argv[1]);
        d2=atof(argv[2]);
        d3=atof(argv[3]);
        if ((d1 >= d2) && (d1 <= d3)) printf("%s", "true");
        else printf("%s", "false");
    }
    return EXIT_SUCCESS;
}
