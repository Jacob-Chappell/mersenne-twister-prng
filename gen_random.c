//
// Created by roboticowl4000 on 3/22/23.
//

#include <stdlib.h>
#include <stdio.h>
#include "mt.h"

int main(int argc, char ** argv) { // first arg is the number of random numbers, second is the start state file, and the third is the output file
    FILE* output;
    FILE* input;
    MT_Data mtData;
    int size;
    int rand_count;
    unsigned int rand_out;

    if(argc < 4) {
        fprintf(stderr, "Incorrect arg count");
        return EXIT_FAILURE;
    }

    // Init the mt algorithm
    mtData = mt_init(); // initialize the mt algorithm

    input = fopen(argv[2], "r");
    if(!input) {
        fprintf(stderr, "Failed to open start state file\n");
        return EXIT_FAILURE;
    }

    // check the input file length
    fseek(input, 0, SEEK_END);
    size = ftell(input);
    if(size != (N * sizeof(unsigned int))) {
        fclose(input);
        fprintf(stderr, "Input file wrong size (instead is %d bytes)\n", size);
        return EXIT_FAILURE;
    }

    // read in the start state
    fseek(input, 0, SEEK_SET);
    fread(mtData.mt, sizeof(unsigned int), N, input);
    fclose(input);

    // generate the numbers
    output = fopen(argv[3], "w");
    if(output == NULL) {
        fprintf(stderr, "Failed to open file for write");
        return EXIT_FAILURE;
    }

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