#!/bin/bash

set -e
cd

# Build Orthanc core
hg clone https://s.jodogne@code.google.com/p/orthanc/ orthanc
cd orthanc
hg up -c Orthanc-0.8.6
mkdir Build
cd Build
cmake "-DDCMTK_LIBRARIES=boost_locale;CharLS;dcmjpls;wrap;oflog" \
    -DALLOW_DOWNLOADS=ON \
    -DUSE_SYSTEM_MONGOOSE=OFF \
    -DUSE_SYSTEM_JSONCPP=OFF \
    -DUSE_SYSTEM_GOOGLE_LOG=OFF \
    -DUSE_SYSTEM_PUGIXML=OFF \
    -DUSE_GTEST_DEBIAN_SOURCE_PACKAGE=ON \
    ..
make
./UnitTests
make install
