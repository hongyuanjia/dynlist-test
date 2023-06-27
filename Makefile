CFLAGS += -Ldyncall/dynload -ldynload_s

all: config clean dynload test

clean:
	cd dyncall && make clean

config:
	cd dyncall && ./configure

dyncall:
	cd dyncall && make

test:
	${CC} main.c -o dynlist ${CFLAGS} && ./dynlist

.PHONY: config clean dynload test
