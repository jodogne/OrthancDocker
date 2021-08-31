#!/bin/bash

set -e
cd

URL=https://lsb.orthanc-server.com/
VERSION=3.4

wget ${URL}/plugin-python/debian-buster-python-3.7/${VERSION}/libOrthancPython.so

mv ./libOrthancPython.so  /usr/local/share/orthanc/plugins/
