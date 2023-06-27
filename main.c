#include <stdio.h>
#include <sys/stat.h>
#include "dyncall/dynload/dynload.h"

#define F_OK 0
int main(int argc, char *argv[])
{
    DLLib *pLib;
    int buf = 1024;
    char path[buf];
    int bs = 0;

    const char* clibs[] = {
        /* windows */
        "msvcrt.dll",
        /* linux */
        "libc.so.6",
        /* macOS */
        "/usr/lib/libc.dylib"
    };

    for (int i = 0; i < (sizeof(clibs)/sizeof(const char*)); i++) {
        if ((pLib = dlLoadLibrary(clibs[i]))) {
            bs = dlGetLibraryPath(pLib, path, buf);
            printf("successfully locate C library at '%s' using path '%s'\n", path, clibs[i]);
            dlFreeLibrary(pLib);
            break;
        }
    }

    if (bs == 0) {
        printf("failed to locate C library\n");
        return 1;
    }

    DLSyms *pSyms;
    pSyms = dlSymsInit(path);
    int n;
    const char *name;
    n = dlSymsCount(pSyms);
    printf("number of symbols found: %d\n", n);
    for (int i = 0; i < n; i++) {
        name = dlSymsName(pSyms, i);
        printf("[%d] '%s'\n", i, name);
    }

    dlSymsCleanup(pSyms);
    return 0;
}
