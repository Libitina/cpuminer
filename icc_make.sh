#!/bin/bash -x
env CC=icc ./configure CFLAGS="-Ofast -m64 -axCORE-AVX2 -flto -fomit-frame-pointer -funroll-loops -D__SSE2__ -D__SSE4_1__ -D__SHA__"
make clean
make

