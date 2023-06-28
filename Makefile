CFLAGS += -L dyncall/dynload -l dynload_s
UNAME = $(shell uname -s)

ifeq ($(OS), Windows_NT)
EXE = dynlist.exe
else
EXE = dynlist
endif

all: config dyncall test otool_libc otool_libsysb otool_libsysk otool_libsysp otool_libsyst

config:
	cd dyncall && chmod +x configure && ./configure

dyncall:
	cd dyncall && make -f Makefile.embedded

test:
	${CC} main.c ${CFLAGS} -o ${EXE} && ./${EXE}

otool_libc:
ifeq ($(UNAME), Darwin)
	otool -TV /usr/lib/libc.dylib || true
endif

otool_libsysb:
ifeq ($(UNAME), Darwin)
	otool -TV /usr/lib/libSystem.B.dylib || true
endif

otool_libsysk:
ifeq ($(UNAME), Darwin)
	otool -TV /usr/lib/system/libsystem_kernel.dylib || true
endif

otool_libsysp:
ifeq ($(UNAME), Darwin)
	otool -TV /usr/lib/system/libsystem_platform.dylib || true
endif

otool_libsyst:
ifeq ($(UNAME), Darwin)
	otool -TV /usr/lib/system/libsystem_pthread.dylib || true
endif

.PHONY: config dyncall test otool_libc otool_libsysb otool_libsysk otool_libsysp otool_libsyst
