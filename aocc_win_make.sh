#! /bin/bash -x

#rm -f config.status
#autoreconf -fi -I./deps/x86_64-w64-mingw32/share/aclocal

#-march=native gcc-mingw-5.4 does not support ryzen yet
#--disable-assembly \

#./configure CC=clang --target=x86_64-w64-mingw32 \
#CFLAGS="--target=x86_64-w64-mingw32 -Ofast -msse2 -msse4.1 -mfma4 -mavx -mavx2 -msha -flto -funroll-loops -fomit-frame-pointer -madx -mrdseed -mmwaitx -mxsavec -mxsaves -mclflushopt -mpopcnt -I./deps/x86_64-w64-mingw32/include -std=c99 -DWIN32 -DCURL_STATICLIB -DPTW32_STATIC_LIB " \
#--enable-assembly \
#--with-libcurl=deps/x86_64-w64-mingw32 \
#LDFLAGS="-L./deps/x86_64-w64-mingw32/lib -L/usr/lib/gcc/x86_64-w64-mingw32/5.3-win32/ -static -fuse-ld=lld" \
#LIBS="deps/x86_64-w64-mingw32/lib/libcurl.a deps/x86_64-w64-mingw32/lib/libpthread.a"

CC=clang
CFLAGS="--target=x86_64-w64-mingw32 -Ofast -msse2 -msse4.1 -mfma4 -mavx -mavx2 -msha -flto -funroll-loops -fomit-frame-pointer -madx -mrdseed -mmwaitx -mxsavec -mxsaves -mclflushopt -mpopcnt -I./deps/x86_64-w64-mingw32/include -std=c99 -DWIN32 -DCURL_STATICLIB -DPTW32_STATIC_LIB -fvectorize"
LDFLAGS="-L./deps/x86_64-w64-mingw32/lib -L/usr/lib/gcc/x86_64-w64-mingw32/5.3-win32/ -static -flto"
LIBS="deps/x86_64-w64-mingw32/lib/libcurl.a deps/x86_64-w64-mingw32/lib/libpthread.a"
CLFLAGS="-mllvm -vectorize-loops -mllvm -unroll-runtime -mllvm -unroll-allow-partial"

###C->s
${CC} -c -S -emit-llvm ${CFLAGS} ${CLFLAGS} cpu-miner.c
${CC} -c -S -emit-llvm ${CFLAGS} ${CLFLAGS} util.c 
${CC} -c -S -emit-llvm ${CFLAGS} ${CLFLAGS} sha2.c
${CC} -c -S -emit-llvm ${CFLAGS} ${CLFLAGS} scrypt.c 
${CC} -c -S -emit-llvm ${CFLAGS} ${CLFLAGS} yescrypt.c

##s->s.bc #Bitcode
llvm-as cpu-miner.s
llvm-as util.s 
llvm-as sha2.s
llvm-as scrypt.s
llvm-as yescrypt.s

##s.bc->s,s #ASM
#llc cpu-miner.s.bc
#llc util.s.bc
#llc sha2.s.bc
#llc scrypt.s.bc
#llc yescrypt.s.bc

##s.bc->s,o #OBJ
llc -march=x86-64 -filetype=obj -o cpu-miner.s.o cpu-miner.s.bc
llc -march=x86-64 -filetype=obj -o util.s.o util.s.bc
llc -march=x86-64 -filetype=obj -o sha2.s.o sha2.s.bc
llc -march=x86-64 -filetype=obj -o scrypt.s.o scrypt.s.bc
llc -march=x86-64 -filetype=obj -o yescrypt.s.o yescrypt.s.bc
#x86_64-w64-mingw32-gcc ${CFLAGS} -c sha2-x64.S -o sha2-x64.o
#x86_64-w64-mingw32-gcc ${CFLAGS} -c scrypt-x64.S -o scrypt-x64.o
#x86_64-w64-mingw32-gcc ${CFLAGS} -c chkstk.S -o chkstk.o
#x86_64-w64-mingw32-gcc ${CFLAGS} -c ctor.c -o ctor.o


#lld-link /out:minerd.exe cpu-miner.s.o util.s.o sha2.s.o scrypt.s.o yescrypt.s.o \
#sha2-x64.o \
#scrypt-x64.o \
#chkstk.o \
#ctor.o \
#./deps/x86_64-w64-mingw32/lib/libpthread.a \
#./deps/x86_64-w64-mingw32/lib/libcurl.a \
#./compat/jansson/libjansson.a \
#/usr/x86_64-w64-mingw32/lib/libntdll.a \
#/usr/x86_64-w64-mingw32/lib/libws2_32.a \
#/usr/x86_64-w64-mingw32/lib/libadvapi32.a \
#/usr/x86_64-w64-mingw32/lib/libmsvcrt.a \
#/usr/x86_64-w64-mingw32/lib/libkernel32.a \
#/usr/x86_64-w64-mingw32/lib/libcrtdll.a \
#/usr/x86_64-w64-mingw32/lib/libmsvcr110.a \
#/usr/x86_64-w64-mingw32/lib/libmingw32.a \
#/usr/x86_64-w64-mingw32/lib/libmingwex.a \
#/usr/x86_64-w64-mingw32/lib/libwldap32.a \
#/usr/x86_64-w64-mingw32/lib/libcrypt32.a \
#/libpath:"./deps/x86_64-w64-mingw32/lib /usr/lib/gcc/x86_64-w64-mingw32/5.3-win32 /usr/x86_64-w64-mingw32/lib/" \
#--rsp-quoting=windows \
#/entry:main \
#/subsystem:console \
#/machine:X64

x86_64-w64-mingw32-gcc ${LDFLAGS} \
-o minerd.exe \
cpu-miner.s.o util.s.o sha2.s.o scrypt.s.o yescrypt.s.o \
sha2-x64.o scrypt-x64.o \
./deps/x86_64-w64-mingw32/lib/libpthread.a \
./deps/x86_64-w64-mingw32/lib/libcurl.a \
./compat/jansson/libjansson.a \
/usr/x86_64-w64-mingw32/lib/libntdll.a \
/usr/x86_64-w64-mingw32/lib/libws2_32.a \
/usr/x86_64-w64-mingw32/lib/libadvapi32.a \
/usr/x86_64-w64-mingw32/lib/libmsvcr110.a \
/usr/x86_64-w64-mingw32/lib/libkernel32.a \
/usr/x86_64-w64-mingw32/lib/libmingw32.a \
/usr/x86_64-w64-mingw32/lib/libmingwex.a \
/usr/x86_64-w64-mingw32/lib/libwldap32.a \
/usr/x86_64-w64-mingw32/lib/libcrypt32.a


#make clean
#make

cp minerd.exe /mnt/d/
