CFLAGS += -L dyncall/dynload -l dynload_s
UNAME = $(shell uname -s)

ifeq ($(OS), Windows_NT)
EXE = dynlist.exe
else
EXE = dynlist
endif

all: config dyncall test nm_libc nm_libsysb nm_libsysk nm_libsysp

config:
	cd dyncall && chmod +x configure && ./configure

dyncall:
	cd dyncall && make -f Makefile.embedded

test:
	${CC} main.c ${CFLAGS} -o ${EXE} && ./${EXE}

nm_libc:
ifeq ($(UNAME), Darwin)
	nm /usr/lib/libc.dylib || true
endif

nm_libsysb:
ifeq ($(UNAME), Darwin)
	nm /usr/lib/libSystem.B.dylib || true
endif

nm_libsysk:
ifeq ($(UNAME), Darwin)
	nm /usr/lib/system/libsystem_kernel.dylib && head -c 10 || true
endif

nm_libsysp:
ifeq ($(UNAME), Darwin)
	nm /usr/lib/system/ibsystem_platform.dylib && head -c 10 || true
endif

.PHONY: config dyncall test nm_libc nm_libsysb nm_libsysk nm_libsysp
