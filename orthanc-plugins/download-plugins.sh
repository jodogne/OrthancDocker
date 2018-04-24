#!/bin/bash

set -e
cd

URL=http://lsb.orthanc-server.com/
VERSION_DICOM_WEB=mainline
VERSION_POSTGRESQL=mainline
VERSION_WEB_VIEWER=mainline
VERSION_WSI=mainline

# Download binaries compiled with Linux Standard Base
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

chmod +x ./OrthancWSIDicomToTiff
chmod +x ./OrthancWSIDicomizer
chmod +x ./UnitTests-DicomWeb
chmod +x ./UnitTests-PostgreSQL
chmod +x ./UnitTests-WebViewer

# Run the unit tests
mkdir ~/UnitTests
cd ~/UnitTests
../UnitTests-DicomWeb
# ../UnitTests-PostgreSQL
../UnitTests-WebViewer

# Recover space used by the unit tests
cd
rm -rf ./UnitTests
rm -rf ./UnitTests-DicomWeb
rm -rf ./UnitTests-PostgreSQL
rm -rf ./UnitTests-WebViewer

# Move the binaries to their final location
mv ./OrthancWSIDicomToTiff          /usr/local/bin/
mv ./OrthancWSIDicomizer            /usr/local/bin/
mv ./libOrthancDicomWeb.so          /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLIndex.so   /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLStorage.so /usr/local/share/orthanc/plugins/
mv ./libOrthancWSI.so               /usr/local/share/orthanc/plugins/
mv ./libOrthancWebViewer.so         /usr/local/share/orthanc/plugins/
