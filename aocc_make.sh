#!/bin/bash -x
#CFLAGS="-Ofast -msse2 -msse4.1 -msha -flto -funroll-loops -fomit-frame-pointer -fuse-ld=lld" \
./configure CC=clang \
CFLAGS="-m64 -Ofast -msse2 -msse4.1 -msha -flto -funroll-loops -fomit-frame-pointer" \
LDFLAGS="-fuse-ld=lld -mllvm -unroll-runtime -mllvm -unroll-allow-partial"
#make clean
#make

