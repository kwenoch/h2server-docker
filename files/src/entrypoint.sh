#!/usr/bin/env bash

. /usr/bin/setdockerenv

if [[ -z "$(tty)" ]]; then
    echo -ne "[ERR]\tNo tty detected - please add `tty: true` to your compose\n"
    exit 1
fi

if [[ ! -d "${H2SERVER_ROOT}" ]]; then
    echo -ne "[ERR]\t${H2SERVER_ROOT} not found - please mount a volume here\n"
    exit 1
fi
if [[ ! -f "${H2SERVER_BIN}" ]]; then
    echo -ne "[ERR]\t${H2SERVER_BIN} not found\n"
    echo -ne "[ERR]\tPlease extract Halo 2 for Vista Dedicated Server into the mounted volume\n"
    exit 1
fi

usermod -u ${USER_UID:-1000} h2server || exit 1
groupmod -g ${USER_GID:-1000} h2server || exit 1

chown -R h2server /home/h2server
chgrp -R h2server /home/h2server

chown -R h2server /proton7
chgrp -R h2server /proton7

chown -R h2server /h2server
chgrp -R h2server /h2server

exec su h2server /bin/bash -c '/run_h2server.sh'
