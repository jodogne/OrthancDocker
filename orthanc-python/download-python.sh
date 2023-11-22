#!/bin/bash

set -e
cd

URL=https://orthanc.uclouvain.be/downloads/linux-standard-base
VERSION=4.1

wget ${URL}/orthanc-python/debian-buster-python-3.7/${VERSION}/libOrthancPython.so

mv ./libOrthancPython.so  /usr/local/share/orthanc/plugins/
