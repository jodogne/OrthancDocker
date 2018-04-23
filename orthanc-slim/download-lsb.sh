#!/bin/bash

set -e
cd

URL=http://lsb.orthanc-server.com/
VERSION_ORTHANC=1.3.2
VERSION_DICOM_WEB=0.5
VERSION_POSTGRESQL=2.1
VERSION_WEB_VIEWER=2.4
VERSION_WSI=0.5

# Download binaries compiled with Linux Standard Base
wget ${URL}/orthanc/${VERSION_ORTHANC}/Orthanc
wget ${URL}/orthanc/${VERSION_ORTHANC}/OrthancRecoverCompressedFile
wget ${URL}/orthanc/${VERSION_ORTHANC}/UnitTests -O - > UnitTests-Orthanc
wget ${URL}/orthanc/${VERSION_ORTHANC}/libModalityWorklists.so
wget ${URL}/orthanc/${VERSION_ORTHANC}/libServeFolders.so

wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/UnitTests -O - > UnitTests-DicomWeb
wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/libOrthancDicomWeb.so

wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/UnitTests -O - > UnitTests-PostgreSQL
wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLIndex.so
wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLStorage.so

wget ${URL}/plugin-webviewer/${VERSION_WEB_VIEWER}/UnitTests -O - > UnitTests-WebViewer
wget ${URL}/plugin-webviewer/${VERSION_WEB_VIEWER}/libOrthancWebViewer.so

wget ${URL}/whole-slide-imaging/${VERSION_WSI}/OrthancWSIDicomToTiff
wget ${URL}/whole-slide-imaging/${VERSION_WSI}/OrthancWSIDicomizer
wget ${URL}/whole-slide-imaging/${VERSION_WSI}/libOrthancWSI.so

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
../UnitTests-Orthanc
../UnitTests-DicomWeb
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
