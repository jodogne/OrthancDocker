#!/bin/bash

set -ex

DIR=`dirname $(readlink -f $0)`

VERSION=`grep RUN "${DIR}/Dockerfile" | grep download-emscripten.sh | cut -d '"' -f 2`

if [ -z "${VERSION}" ]; then
    echo "Cannot determine the emscripten version"
    exit -1
fi

NAME=wasm-builder:${VERSION}

# Make sure that login to DockerHub is possible
docker login --username=jodogne


# Create the image

# NB: "--network=host" is here to avoid "Temporary failure resolving"
# errors while running apt:
# https://medium.com/@faithfulanere/solved-docker-build-could-not-resolve-archive-ubuntu-com-apt-get-fails-to-install-anything-9ea4dfdcdcf2

echo "Building image ${NAME}"
( cd "${DIR}" && docker build --network=host --rm --no-cache -t ${NAME} . )



# Upload to DockerHub
ID=`docker images --filter=reference=${NAME} --format '{{.ID}}'`
docker tag ${ID} jodogne/${NAME}
docker push jodogne/${NAME}
