//
// Created by roboticowl4000 on 3/22/23.
//

#include "mt.h"
#include <stdlib.h>

//#define SRAND_INIT 1

// initialize the mt data
MT_Data mt_init() {
    MT_Data data;
    data.i = 0;

#ifdef SRAND_INIT
    srand(SRAND_INIT);
    for (int i = 0; i < N; i ++) {
        data.mt[i] = rand();
    }
#endif // SRAND_INI

    return data;
}

// generate the next random number
unsigned int mt(MT_Data * data) {
    unsigned int y, i_1, i_m, u_mask, l_mask;

    i_1 = (data->i + 1) % N;
    i_m = (data->i + M) % N;

    u_mask = 0xFFFFFFFF <<  R;
    l_mask = 0xFFFFFFFF >> (32 - R);

    // stage 1
    y = (data->mt[data->i] & u_mask) | (data->mt[i_1] & l_mask);

    // stage 2
    data->mt[data->i] = data->mt[i_m] ^ (y >> 1) ^ ((y & 0x1) ? A : 0);

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