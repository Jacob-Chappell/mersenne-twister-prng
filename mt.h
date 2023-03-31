//
// Created by roboticowl4000 on 3/22/23.
//

#ifndef MERSENNE_TWISTER_PRNG_H
#define MERSENNE_TWISTER_PRNG_H

#define W 32
#define M 397
#define A 0x9908B0DF
#define N 624
#define R 31
#define U 11
#define S 7
#define B 0x9D2C5680
#define T 15
#define C 0xEFC60000
#define L 18

typedef struct {
    unsigned int i;
    unsigned int mt[N];
} MT_Data;

MT_Data mt_init();
unsigned int mt(MT_Data *);

#endif //MERSENNE_TWISTER_PRNG_H
