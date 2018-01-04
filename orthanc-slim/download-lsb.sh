#!/bin/bash

set -e
cd

# Download binaries compiled with Linux Standard Base
URL=http://buildbot.orthanc-server.com/linux-standard-base/2018-01-04
wget ${URL}/Orthanc
wget ${URL}/OrthancRecoverCompressedFile
wget ${URL}/OrthancWSIDicomToTiff
wget ${URL}/OrthancWSIDicomizer
wget ${URL}/UnitTests-DicomWeb
wget ${URL}/UnitTests-Orthanc
wget ${URL}/UnitTests-PostgreSQL
wget ${URL}/UnitTests-WebViewer
wget ${URL}/libModalityWorklists.so
wget ${URL}/libOrthancDicomWeb.so
wget ${URL}/libOrthancPostgreSQLIndex.so
wget ${URL}/libOrthancPostgreSQLStorage.so
wget ${URL}/libOrthancWSI.so
wget ${URL}/libOrthancWebViewer.so
wget ${URL}/libServeFolders.so

chmod +x ./Orthanc
chmod +x ./OrthancRecoverCompressedFile
chmod +x ./OrthancWSIDicomToTiff
chmod +x ./OrthancWSIDicomizer
chmod +x ./UnitTests-DicomWeb
chmod +x ./UnitTests-Orthanc
chmod +x ./UnitTests-PostgreSQL
chmod +x ./UnitTests-WebViewer

# Run the unit tests
mkdir ~/UnitTests
cd ~/UnitTests
../UnitTests-DicomWeb
../UnitTests-Orthanc
# ../UnitTests-PostgreSQL
../UnitTests-WebViewer

# Recover space used by the unit tests
cd
rm -rf ./UnitTests
rm -rf ./UnitTests-DicomWeb
rm -rf ./UnitTests-Orthanc
rm -rf ./UnitTests-PostgreSQL
rm -rf ./UnitTests-WebViewer

# Move the binaries to their final location
mkdir -p /usr/local/sbin/
mkdir -p /usr/local/bin/
mkdir -p /usr/local/share/orthanc/plugins/

mv ./Orthanc                        /usr/local/sbin/
mv ./OrthancRecoverCompressedFile   /usr/local/bin/
mv ./OrthancWSIDicomToTiff          /usr/local/bin/
mv ./OrthancWSIDicomizer            /usr/local/bin/
mv ./libModalityWorklists.so        /usr/local/share/orthanc/plugins/
mv ./libOrthancDicomWeb.so          /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLIndex.so   /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLStorage.so /usr/local/share/orthanc/plugins/
mv ./libOrthancWSI.so               /usr/local/share/orthanc/plugins/
mv ./libOrthancWebViewer.so         /usr/local/share/orthanc/plugins/
mv ./libServeFolders.so             /usr/local/share/orthanc/plugins/
