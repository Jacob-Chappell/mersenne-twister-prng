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
        fprintf(output, "%010u\n", rand_out); // write the random number to the output file
    }

    fclose(output);
    return EXIT_SUCCESS;
}