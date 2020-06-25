#!/bin/bash

set -ex

DIR=`dirname $(readlink -f $0)`

VERSION=`grep bash "${DIR}/Dockerfile" | cut -d '"' -f 2`

if [ -z "${VERSION}" ]; then
    echo "Cannot determine the emscripten version"
    exit -1
fi

NAME=wasm-builder:${VERSION}

# Make sure that login to DockerHub is possible
docker login --username=jodogne

# Create the image
echo "Building image ${NAME}"
( cd "${DIR}" && docker build --rm --no-cache -t ${NAME} . )

# Upload to DockerHub
ID=`docker images --filter=reference=${NAME} --format '{{.ID}}'`
docker tag ${ID} jodogne/${NAME}
docker push jodogne/${NAME}
