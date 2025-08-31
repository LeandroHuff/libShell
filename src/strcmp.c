#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    if ( argc < 2) exit (EXIT_FAILURE);
    else printf( "%d" , strcmp(argv[1],argv[2]) );
    exit (EXIT_SUCCESS);
}
