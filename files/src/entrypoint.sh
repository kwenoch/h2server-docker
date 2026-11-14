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

usermod -u ${USER_UID:-1000} steam || exit 1
groupmod -g ${USER_GID:-1000} steam || exit 1

chown -R steam /home/steam
chgrp -R steam /home/steam

chown -R steam /proton7
chgrp -R steam /proton7

chown -R steam /h2server
chgrp -R steam /h2server

exec su steam /bin/bash -c '/run_h2server.sh'
