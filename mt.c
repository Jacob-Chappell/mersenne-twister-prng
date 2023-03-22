//
// Created by roboticowl4000 on 3/22/23.
//

#include "mt.h"
#include "math.h"

// seed of srand init of the mt array
#define SRAND_INIT 1

// initialize the mt data
MT_Data mt_init() {
    MT_Data data;
    data.i = 0;

#ifdef SRAND_INIT
    for (int i = 0; i < N; i ++) {
        data.mt[i] = srand(SRAND_INIT);
    }
#endif // SRAND_INIT

    return data;
}

// generate the next random number
unsigned int mt(MT_Data * data) {
    unsigned int y, i_1, i_m;

    i_1 = (data->i + 1) % N;
    i_m = (data->i + M) % N;

    // stage 1
    y = (data->mt[data->i] & 0xFFFF0000) | (x[i_1] & 0x0000FFFF); // need to replace the constants with ones that reflect R

    // stage 2
    data->mt[data->i] = data->mt[i_m] ^ (y >> 1) ^ (y[0] ? A : 0);

    // stage 3
    y = data->mt[data->i];
    y = y ^ (y >> U);
    y = y ^ ((y << S) & B);
    y = y ^ ((y << T) & C);
    y = y ^ (y >> L);

    // update i
    data->i = i_1;

    // return output
    return y;
}