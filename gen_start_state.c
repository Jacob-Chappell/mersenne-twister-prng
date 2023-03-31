//
// Created by roboticowl4000 on 3/28/23.
//

#include <stdlib.h>
#include <stdio.h>

#define SRAND_INIT 1
#define N 624

int main(int argc, char ** argv) { // first arg is the output filename, second is file format (binary "b" or ascii "a")
    FILE* output;
    unsigned int data;

    output = fopen(argv[1], "w");
    if(!output) {
        fprintf(stderr, "Failed to open output file\n");
        return EXIT_FAILURE;
    }

    srand(SRAND_INIT);

    if(argv[2][0] == 'a') { // ascii format
        for (int i = 0; i < N; i ++) {
            data = rand();
            fprintf(output, "%#010x\n", data);
        }
    } else if(argv[2][0] == 'b') { // binary format
        for (int i = 0; i < N; i ++) {
            data = rand();
            fwrite(&data, sizeof(unsigned int), 1, output);
        }
    } else {
        fclose(output);
        fprintf(stderr, "Incorrect format specifier given ('a' -> ASCII, 'b' -> binary)\n");
        return EXIT_FAILURE;
    }

    fclose(output);
    fprintf(stdout, "Complete!\n");
    return EXIT_SUCCESS;
}
