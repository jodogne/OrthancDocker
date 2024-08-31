#!/bin/bash

set -e
cd

URL=https://orthanc.uclouvain.be/downloads/linux-standard-base
VERSION=mainline

wget ${URL}/orthanc-python/debian-bookworm-python-3.11/${VERSION}/libOrthancPython.so

mv ./libOrthancPython.so  /usr/local/share/orthanc/plugins/
