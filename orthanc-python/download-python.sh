#!/bin/bash

set -e
cd

URL=https://lsb.orthanc-server.com/
VERSION=mainline

wget ${URL}/plugin-python/debian-stable-python-3.7/${VERSION}/libOrthancPython.so

mv ./libOrthancPython.so  /usr/local/share/orthanc/plugins/
