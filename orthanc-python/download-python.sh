#!/bin/bash

set -ex
cd

URL=https://orthanc.uclouvain.be/downloads/linux-standard-base
VERSION=7.1

wget ${URL}/orthanc-python/debian-trixie-python-3.13/${VERSION}/libOrthancPython.so

mv ./libOrthancPython.so  /usr/local/share/orthanc/plugins/
