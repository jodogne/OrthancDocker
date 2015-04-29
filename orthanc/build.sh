#!/bin/bash

# Orthanc - A Lightweight, RESTful DICOM Store
# Copyright (C) 2012-2015 Sebastien Jodogne, Medical Physics
# Department, University Hospital of Liege, Belgium
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


set -e

# Get the number of available cores to speed up the build
COUNT_CORES=`grep -c ^processor /proc/cpuinfo`
echo "Will use $COUNT_CORES parallel jobs to build Orthanc"

# Create the various directories as in the official Debian package
mkdir /etc/orthanc
mkdir -p /var/lib/orthanc/db
mkdir -p /usr/share/orthanc/plugins

# Clone the Orthanc repository and switch to the requested branch
cd /home/
hg clone https://s.jodogne@code.google.com/p/orthanc/ orthanc
cd orthanc
hg up -c "$1"

# Install the Orthanc core and run the unit tests
mkdir Build
cd Build
cmake "-DDCMTK_LIBRARIES:PATH=boost_locale;CharLS;dcmjpls;wrap;oflog" \
    -DALLOW_DOWNLOADS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DUSE_GTEST_DEBIAN_SOURCE_PACKAGE:BOOL=ON \
    -DUSE_SYSTEM_GOOGLE_LOG:BOOL=OFF \
    -DUSE_SYSTEM_JSONCPP:BOOL=OFF \
    -DUSE_SYSTEM_MONGOOSE:BOOL=OFF \
    -DUSE_SYSTEM_PUGIXML:BOOL=OFF \
    ..
make -j$COUNT_CORES
./UnitTests
make install

# Build the "ServeFolders" sample plugin
cd /home/orthanc
mkdir BuildServeFolders
cd BuildServeFolders
cmake -DCMAKE_BUILD_TYPE:STRING=Release ../Plugins/Samples/ServeFolders
make -j$COUNT_CORES
cp -L libServeFolders.so /usr/share/orthanc/plugins

# Remove the build directory to recover space
cd /home/
rm -rf /home/orthanc

# Auto-generate, then patch the configuration file
CONFIG=/etc/orthanc/orthanc.json
Orthanc --config=$CONFIG
sed 's/\("Name" : \)".*"/\1"Orthanc inside Docker"/' -i $CONFIG
sed 's/\("IndexDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/\("StorageDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/"RemoteAccessAllowed" : false/"RemoteAccessAllowed" : true/' -i $CONFIG
sed 's/\("Plugins" : \[\)/\1 "\/usr\/share\/orthanc\/plugins"/' -i $CONFIG
