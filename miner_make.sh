cd deps
#bash ./build_win_deps.sh

cd ..
autoreconf -fi -I./deps/x86_64-w64-mingw32/share/aclocal
./configure --host=x86_64-w64-mingw32 \
CFLAGS="-O3 -march=native -I./deps/x86_64-w64-mingw32/include -std=c99 -DWIN32 -DCURL_STATICLIB -DPTW32_STATIC_LIB" \
--with-libcurl=deps/x86_64-w64-mingw32 LDFLAGS="-L./deps/x86_64-w64-mingw32/lib -static"
make
