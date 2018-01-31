#if defined(__ARM_NEON__)||defined(__ARM_NEON)
#include "yescrypt-neon.c"
#elif defined __SSE2__
//#include "yescrypt-sse.c"
#include "yescrypt-sse_zny.c"
#else
#include "yescrypt-opt.c"
#endif
