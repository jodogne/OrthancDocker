#!/bin/bash

set -e
cd

URL=http://lsb.orthanc-server.com/
VERSION_ORTHANC=mainline

# Download binaries compiled with Linux Standard Base
wget ${URL}/orthanc/${VERSION_ORTHANC}/Orthanc
wget ${URL}/orthanc/${VERSION_ORTHANC}/OrthancRecoverCompressedFile
wget ${URL}/orthanc/${VERSION_ORTHANC}/UnitTests -O - > UnitTests-Orthanc
wget ${URL}/orthanc/${VERSION_ORTHANC}/libConnectivityChecks.so
wget ${URL}/orthanc/${VERSION_ORTHANC}/libModalityWorklists.so
wget ${URL}/orthanc/${VERSION_ORTHANC}/libServeFolders.so

chmod +x ./Orthanc
chmod +x ./OrthancRecoverCompressedFile
chmod +x ./UnitTests-Orthanc

# Run the unit tests
mkdir ~/UnitTests
cd ~/UnitTests
../UnitTests-Orthanc

# Recover space used by the unit tests
cd
rm -rf ./UnitTests
rm -rf ./UnitTests-Orthanc

# Move the binaries to their final location
mkdir -p /usr/local/sbin/
mkdir -p /usr/local/bin/
mkdir -p /usr/local/share/orthanc/plugins/

mv ./Orthanc                        /usr/local/sbin/
mv ./OrthancRecoverCompressedFile   /usr/local/bin/
mv ./libConnectivityChecks.so       /usr/local/share/orthanc/plugins/
mv ./libModalityWorklists.so        /usr/local/share/orthanc/plugins/
mv ./libServeFolders.so             /usr/local/share/orthanc/plugins/
