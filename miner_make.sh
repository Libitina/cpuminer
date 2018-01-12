cd deps
bash ./build_win_deps.sh

cd ..


#-march=native gcc-mingw-5.4 does not support ryzen yet

autoreconf -fi -I./deps/x86_64-w64-mingw32/share/aclocal
./configure --host=x86_64-w64-mingw32 \
CFLAGS="-Ofast -msse2 -msse4.1 -mfma4 -flto -msha -I./deps/x86_64-w64-mingw32/include -std=c99 -DWIN32 -DCURL_STATICLIB -DPTW32_STATIC_LIB" \
--disable-assembly \
--with-libcurl=deps/x86_64-w64-mingw32 LDFLAGS="-L./deps/x86_64-w64-mingw32/lib -static"
make clean
make

#cp minerd.exe /mnt/d/
