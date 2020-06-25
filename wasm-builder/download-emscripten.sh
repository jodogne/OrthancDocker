#!/bin/bash

set -e
cd /opt/

if [ -z "$1" ]; then
    echo "Please provide a version for emscripten"
    exit -1
fi

git clone https://github.com/emscripten-core/emsdk.git
/opt/emsdk/emsdk install $1
/opt/emsdk/emsdk activate $1
