//
// Created by roboticowl4000 on 3/22/23.
//

#include <stdlib.h>
#include <stdio.h>
#include "mt.h"

int main(int argc, char ** argv) {
    // arg[1] amount to generate, arg[2] input state, arg[3] input state format (binary "b" or ascii "a"), arg[4] output file, arg[5] output file format
    FILE* output;
    FILE* input;
    MT_Data mtData;
    int size;
    int i;
    int rand_count;
    unsigned int rand_out;

    if(argc < 6) {
        fprintf(stderr, "Incorrect arg count\n");
        return EXIT_FAILURE;
    }

    if((argv[3][0] != 'a') && (argv[3][0] != 'b')) {
        fprintf(stderr, "Incorrect input file format specifier given\n");
        return EXIT_FAILURE;
    }

    if((argv[5][0] != 'a') && (argv[5][0] != 'b')) {
        fprintf(stderr, "Incorrect output file format specifier given\n");
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
    int expectedSize = argv[3][0] == 'a' ? N * (W/4 + 3) : N * sizeof(unsigned int);
    if(size != expectedSize) {
        fclose(input);
        fprintf(stderr, "Input file wrong size of %d bytes, should be %d bytes\n", size, expectedSize);
        return EXIT_FAILURE;
    }

    // read in the start state
    fseek(input, 0, SEEK_SET);

    if(argv[3][0] == 'b') {
        fread(mtData.mt, sizeof(unsigned int), N, input);
    } else {
        for(i = 0; i < N; i ++) {
            fscanf(input, "%x\n", mtData.mt + i);
        }
    }
    fclose(input);

    // generate the numbers
    output = fopen(argv[4], "w");
    if(output == NULL) {
        fprintf(stderr, "Failed to open file for write");
        return EXIT_FAILURE;
    }

    sscanf(argv[1], "%d", &rand_count);

    for (i = 0; i < rand_count; i ++) {
        rand_out = mt(&mtData); // generate the new random number
        if(argv[5][0] == 'b') {
            fwrite(&rand_out, sizeof(unsigned int), 1, output); // write the random number to the output file
        } else {
            fprintf(output, "%#010x\n", rand_out);
        }
    }

    fclose(output);
    printf("Done!\n");
    return EXIT_SUCCESS;
}