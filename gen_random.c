//
// Created by roboticowl4000 on 3/22/23.
//

#include <stdlib.h>
#include <stdio.h>
#include "mt.h"

int main(int argc, char ** argv) { // first arg is the number of random numbers, and the second is the output file
    FILE* output;
    MT_Data mtData;
    int rand_count;
    unsigned int rand_out;

    if(argc < 3) {
        fprintf(stderr, "Incorrect arg count");
        return EXIT_FAILURE;
    }

    output = fopen(argv[2], "w");
    if(output == NULL) {
        fprintf(stderr, "Failed to open file for write");
        return EXIT_FAILURE;
    }

    mtData = mt_init(); // initialize the mt algorithm
    sscanf(argv[1], "%d", &rand_count);

    for (int i = 0; i < rand_count; i ++) {
        rand_out = mt(&mtData); // generate the new random number
        fwrite(&rand_out, sizeof(unsigned int), 1, output); // write the random number to the output file
    }

#ifdef MASK_DEBUG
    unsigned int u_mask, l_mask;
    u_mask = 0xFFFFFFFF <<  R;
    l_mask = 0xFFFFFFFF >> (32 - R);
    printf("upper mask: %x, lower mask: %x\n", u_mask, l_mask);
#endif // MASK_DEBUG

    fclose(output);
    printf("Done!\n");
    return EXIT_SUCCESS;
}