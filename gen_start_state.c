//
// Created by roboticowl4000 on 3/28/23.
//

#include <stdlib.h>
#include <stdio.h>

#define SRAND_INIT 1
#define N 624

int main(int argc, char ** argv) { // first arg is the output filename
    FILE* output;
    unsigned int data;

    output = fopen(argv[1], "w");
    if(!output) {
        fprintf(stderr, "Failed to open output file\n");
        return EXIT_FAILURE;
    }

    srand(SRAND_INIT);
    for (int i = 0; i < N; i ++) {
        data = rand();
        fwrite(&data, sizeof(unsigned int), 1, output);
    }

    fclose(output);
    fprintf(stdout, "Complete!\n");
    return EXIT_SUCCESS;
}
