/* Code generated by cmd/cgo; DO NOT EDIT. */

/* package github.com/hiddify/libcore/custom */


#line 1 "cgo-builtin-export-prolog"

#include <stddef.h>

#ifndef GO_CGO_EXPORT_PROLOGUE_H
#define GO_CGO_EXPORT_PROLOGUE_H

#ifndef GO_CGO_GOSTRING_TYPEDEF
typedef struct { const char *p; ptrdiff_t n; } _GoString_;
#endif

#endif

/* Start of preamble from import "C" comments.  */



#line 3 "custom.go"

#include "stdint.h"

#line 1 "cgo-generated-wrapper"


/* End of preamble from import "C" comments.  */


/* Start of boilerplate cgo prologue.  */
#line 1 "cgo-gcc-export-header-prolog"

#ifndef GO_CGO_PROLOGUE_H
#define GO_CGO_PROLOGUE_H

typedef signed char GoInt8;
typedef unsigned char GoUint8;
typedef short GoInt16;
typedef unsigned short GoUint16;
typedef int GoInt32;
typedef unsigned int GoUint32;
typedef long long GoInt64;
typedef unsigned long long GoUint64;
typedef GoInt64 GoInt;
typedef GoUint64 GoUint;
typedef size_t GoUintptr;
typedef float GoFloat32;
typedef double GoFloat64;
#ifdef _MSC_VER
#include <complex.h>
typedef _Fcomplex GoComplex64;
typedef _Dcomplex GoComplex128;
#else
typedef float _Complex GoComplex64;
typedef double _Complex GoComplex128;
#endif

/*
  static assertion to make sure the file is being used on architecture
  at least with matching size of GoInt.
*/
typedef char _check_for_64_bit_pointer_matching_GoInt[sizeof(void*)==64/8 ? 1:-1];

#ifndef GO_CGO_GOSTRING_TYPEDEF
typedef _GoString_ GoString;
#endif
typedef void *GoMap;
typedef void *GoChan;
typedef struct { void *t; void *v; } GoInterface;
typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;

#endif

/* End of boilerplate cgo prologue.  */

#ifdef __cplusplus
extern "C" {
#endif

extern char* AdminServiceStart(char* arg);
extern void setupOnce(void* api);
extern char* setup(char* baseDir, char* workingDir, char* tempDir, long long int statusPort, GoUint8 debug);
extern char* parse(char* path, char* tempPath, GoUint8 debug);
extern char* changeConfigOptions(char* configOptionsJson);
extern char* generateConfig(char* path);
extern char* start(char* configPath, GoUint8 disableMemoryLimit);
extern char* stop();
extern char* restart(char* configPath, GoUint8 disableMemoryLimit);
extern char* startCommandClient(int command, long long int port);
extern char* stopCommandClient(int command);
extern char* selectOutbound(char* groupTag, char* outboundTag);
extern char* urlTest(char* groupTag);
extern char* generateWarpConfig(char* licenseKey, char* accountId, char* accessToken);

#ifdef __cplusplus
}
#endif
