#!/usr/bin/env bash

. /usr/bin/setdockerenv

CARTO_TMP="/tmp/carto"
CARTO_BASEURL="https://cartographer.online"
CARTO_UPDATE1="$(curl -s -L ${CARTO_BASEURL}'/update1.ini' | grep 'xlive.dll' | cut -c 20-)"
CARTO_NEWDLL="${CARTO_BASEURL}/${CARTO_UPDATE1}"

if [[ -f "${H2SERVER_ROOT}/xlive.dll" ]]; then
    mkdir -p ${CARTO_TMP}

    echo -ne "[INFO]\tDownloading latest xlive.dll . . . \n"
    curl -s -L -f ${CARTO_NEWDLL} >${CARTO_TMP}/xlive.dll || exit 1

    echo -ne "[INFO]\tSumming old and new dll to check for changes . . . \n"
    OLD_SUM="$(sha256sum < ${H2SERVER_ROOT}/xlive.dll)"
    NEW_SUM="$(sha256sum < ${CARTO_TMP}/xlive.dll)"

    if [[ "${OLD_SUM}" != "${NEW_SUM}" ]]; then
        echo -ne "[INFO]\tSums differ! Overwriting existing file with new dll . . . \n"
        mv -v ${CARTO_TMP}/xlive.dll ${H2SERVER_ROOT}/xlive.dll
    else
        echo -ne "[IFNO]\tNo change found . . . We are done\n"
    fi

    rm -rf ${CARTO_TMP}
else
    echo -ne "[ERR]\tNo xlive.dll found in ${H2SERVER_ROOT}, bailing\n"
    exit 1
fi
