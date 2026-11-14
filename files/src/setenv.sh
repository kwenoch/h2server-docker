#!/bin/sh

WINEPATH="/proton7"
PATH="${WINEPATH}/bin:${PATH}"
WINESERVER="${WINEPATH}/bin/wineserver"
WINELOADER="${WINEPATH}/bin/wine"
WINEDLLPATH="${WINEPATH}/lib64/wine/x86_64-windows"

unset LD_LIBRARY_PATH
LD_LIBRARY_PATH="/proton7/lib:/proton7/lib64"

unset WINEPREFIX
WINEPREFIX="${H2SERVER_ROOT}/.wine"

EMULATOR=""
if [ "${TARGETARCH}" = "arm64" ]; then
    EMULATOR="/usr/local/bin/box64"
fi

I386_LIB_ROOT="/usr/lib/i386-linux-gnu"
AMD64_LIB_ROOT="/usr/lib/x86_64-linux-gnu"
if [ "${TARGETARCH}" = "arm64" ]; then
    I386_LIB_ROOT="/usr/lib/box64-i386-linux-gnu"
    AMD64_LIB_ROOT="/usr/lib/box64-x86_64-linux-gnu"
fi

export WINEPATH
export PATH
export WINESERVER
export WINELOADER
export WINEDLLPATH
export WINEPREFIX
export LD_LIBRARY_PATH
export EMULATOR
export I386_LIB_ROOT
export AMD64_LIB_ROOT
