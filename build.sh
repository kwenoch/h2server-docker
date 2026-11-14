#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)" # get current script dir portibly
cd "${SCRIPT_DIR}"

if [[ ! -f ".env" ]]; then
    echo -ne "[ERR]\tCouldn't find .env file. cd to the working directory, and run:\n"
    echo -ne "[ERR]\tcp env/defaults.env .env\n"
    echo -ne "[ERR]\tEdit the file, save, and then rerun this script\n"
    exit 1
fi

. ./.env

ARCH="$(uname -m)"
if [[ "${ARCH}" == "x86_64" ]]; then
    ARCH="amd64"
fi
if [[ "${ARCH}" == "aarch64" ]]; then
    ARCH="arm64"
fi

if [[ -z "${STEAM_USERNAME}" ]]; then
    echo -ne "[ERR]\tSTEAM_USERNAME unset, please add it to your .env\n"
    exit 1
else
    export STEAM_USERNAME
fi
if [[ -z "${STEAM_PASSWORD}" ]]; then
    echo -ne "[ERR]\tSTEAM_PASSWORD unset, please add it to your .env\n"
    exit 1
else
    export STEAM_PASSWORD
fi

if [[ -z "${H2SERVER_VERSION}" ]]; then
    H2SERVER_VERSION="latest"
    export H2SERVER_VERSION
fi

if [[ -z "${DOCKER_REGISTRY}" ]]; then
    echo -ne "[ERR]\tDOCKER_REGISTRY unset, please add it to your .env\n"
    exit 1
fi
if [[ -z "${DOCKER_USERNAME}" ]]; then
    echo -ne "[ERR]\tDOCKER_USERNAME unset, please add it to your .env\n"
    exit 1
fi
if [[ -z "${DOCKER_PROJECT}" ]]; then
    echo -ne "[ERR]\tDOCKER_PROJECT unset, please add it to your .env\n"
    exit 1
fi

DIST=resolute
TAG="${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${DOCKER_PROJECT}:${H2SERVER_VERSION}-${ARCH}"
PLATFORM="linux/${ARCH}"

echo -ne "[INFO]\tGenerating payload.tgz\n"
if [[ ! -f "${SCRIPT_DIR}/files/src/proton_dist.tgz" ]]; then
    echo -ne "[ERR]\tCould not find proton_dist.tgz. Verify it exists!\n"
    exit 1
fi
cd "${SCRIPT_DIR}/files/src" && rm -fv ../payload.tgz
tar --exclude='./*.box64' --exclude='./*.proton' -cvf - . | gzip -9 >../payload.tgz

echo -ne "[INFO]\tBuilding for ${DIST} on ${PLATFORM}\n"
cd "${SCRIPT_DIR}"
docker buildx build \
    --build-arg STEAM_USERNAME="${STEAM_USERNAME}" \
    --build-arg STEAM_PASSWORD="${STEAM_PASSWORD}" \
    --platform ${PLATFORM} \
    -t ${TAG} . || exit 1
echo -ne "[INFO]\tSuccess! Tagged as ${TAG}\n"

echo -ne "[INFO]\tPushing tag ${TAG}\n"
docker push ${TAG} || exit 1
echo -ne "[INFO]\tSuccess! Pushed ${TAG}\n"
