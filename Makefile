CFLAGS += -L dyncall/dynload -l dynload_s
ifeq ($(OS), Windows_NT)
	EXE = dynlist.exe
else
	EXE = dynlist
endif

all: config dyncall test

config:
	cd dyncall && chmod +x configure && ./configure

dyncall:
	cd dyncall && make -f Makefile.embedded

test:
	${CC} main.c ${CFLAGS} -o ${EXE} && ./${EXE}

.PHONY: config dyncall test
