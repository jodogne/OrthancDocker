#!/bin/bash

set -e
cd
URL=https://lsb.orthanc-server.com/
VERSION=mainline

wget --no-check-certificate -O OrthancPython-4.1.tar.gz https://www.orthanc-server.com/downloads/get.php?path=/plugin-python/OrthancPython-4.1.tar.gz
tar -xvf  OrthancPython-4.1.tar.gz
cp /CMakeLists.txt OrthancPython-4.1/CMakeLists.txt
cd OrthancPython-4.1
mkdir Build
cd Build
cmake -DALLOW_DOWNLOADS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DUSE_GOOGLE_TEST_DEBIAN_PACKAGE:BOOL=ON \
    -DUSE_SYSTEM_JSONCPP:BOOL=OFF \
    ..
make -j$COUNT_CORES

chmod +x libOrthancPython.so
ls -l *
cp -L libOrthancPython.so /usr/share/orthanc/plugins/

ls -l /usr/local/share/orthanc/plugins/
