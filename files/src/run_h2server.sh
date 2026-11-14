#!/usr/bin/env bash

. /usr/bin/setdockerenv

mkdir -p "${WINEPREFIX}"

echo -ne "[INFO]\tExecuting server binary with the following flags:\n"
echo -ne "[INFO]\t${H2SERVER_ARGS}\n"
exec /usr/bin/screen -S h2server -D -m \
    ${EMULATOR} ${WINELOADER} ${H2SERVER_BIN} ${H2SERVER_ARGS}
