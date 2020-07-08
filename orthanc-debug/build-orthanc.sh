#!/bin/bash

# Orthanc - A Lightweight, RESTful DICOM Store
# Copyright (C) 2012-2016 Sebastien Jodogne, Medical Physics
# Department, University Hospital of Liege, Belgium
# Copyright (C) 2017-2018 Osimis S.A., Belgium
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
cd /root/
hg clone https://hg.orthanc-server.com/orthanc/ orthanc
cd orthanc
echo "Switching Orthanc to branch: $1"
hg up -c "$1"

# Build the Orthanc core
mkdir Build
cd Build
cmake \
    -DALLOW_DOWNLOADS=ON \
    -DCMAKE_BUILD_TYPE:STRING=Debug \
    -DSTANDALONE_BUILD=ON \
    -DUSE_GOOGLE_TEST_DEBIAN_PACKAGE=ON \
    -DUSE_SYSTEM_DCMTK=OFF \
    -DUSE_SYSTEM_CIVETWEB=OFF \
    -DUSE_SYSTEM_MONGOOSE=OFF \
    -DUSE_SYSTEM_OPENSSL=OFF \
    -DUNIT_TESTS_WITH_HTTP_CONNEXIONS=OFF \
    ../OrthancServer
make -j$COUNT_CORES

# To run the unit tests, we need to install the "en_US" locale
locale-gen en_US
locale-gen en_US.UTF-8
update-locale 
./UnitTests

# Install the Orthanc core
make install

# Don't remove the build directory to recover space, as this
# is a debug image
#cd /root/
#rm -rf /root/orthanc

# Auto-generate, then patch the configuration file
CONFIG=/etc/orthanc/orthanc.json
Orthanc --config=$CONFIG
sed 's/\("Name" : \)".*"/\1"Orthanc inside Docker"/' -i $CONFIG
sed 's/\("IndexDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/\("StorageDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/\("Plugins" : \[\)/\1 \n    "\/usr\/share\/orthanc\/plugins", "\/usr\/local\/share\/orthanc\/plugins"/' -i $CONFIG
sed 's/"RemoteAccessAllowed" : false/"RemoteAccessAllowed" : true/' -i $CONFIG
sed 's/"AuthenticationEnabled" : false/"AuthenticationEnabled" : true/' -i $CONFIG
sed 's/\("RegisteredUsers" : {\)/\1\n    "orthanc" : "orthanc"/' -i $CONFIG
