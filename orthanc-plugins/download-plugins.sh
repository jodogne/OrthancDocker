#!/bin/bash

set -e
cd

URL=http://lsb.orthanc-server.com/

VERSION_AUTHORIZATION=0.2.3
VERSION_DICOM_WEB=1.1
VERSION_GCP=1.0
VERSION_MYSQL=2.0
VERSION_POSTGRESQL=3.2
VERSION_TRANSFERS=1.0
VERSION_WEB_VIEWER=2.5
VERSION_WSI=0.6

# Download binaries compiled with Linux Standard Base

# 2020-01-24: The DICOMweb and Web viewer plugins have no unit test
# anymore, as they are now built using the Holy Build Box because of
# incompatibility between GDCM 3.0 and LSB compilers

#wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/UnitTests -O - > UnitTests-DicomWeb
wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/libOrthancDicomWeb.so

wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/UnitTests -O - > UnitTests-PostgreSQL
wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLIndex.so
wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLStorage.so

wget ${URL}/plugin-mysql/${VERSION_MYSQL}/UnitTests -O - > UnitTests-MySQL
wget ${URL}/plugin-mysql/${VERSION_MYSQL}/libOrthancMySQLIndex.so
wget ${URL}/plugin-mysql/${VERSION_MYSQL}/libOrthancMySQLStorage.so

wget ${URL}/plugin-transfers/${VERSION_TRANSFERS}/UnitTests -O - > UnitTests-Transfers
wget ${URL}/plugin-transfers/${VERSION_TRANSFERS}/libOrthancTransfers.so

#wget ${URL}/plugin-webviewer/${VERSION_WEB_VIEWER}/UnitTests -O - > UnitTests-WebViewer
wget ${URL}/plugin-webviewer/${VERSION_WEB_VIEWER}/libOrthancWebViewer.so

wget ${URL}/whole-slide-imaging/${VERSION_WSI}/OrthancWSIDicomToTiff
wget ${URL}/whole-slide-imaging/${VERSION_WSI}/OrthancWSIDicomizer
wget ${URL}/whole-slide-imaging/${VERSION_WSI}/libOrthancWSI.so

wget ${URL}/plugin-authorization/${VERSION_AUTHORIZATION}/libOrthancAuthorization.so

wget ${URL}/plugin-google-cloud/${VERSION_GCP}/libOrthancGoogleCloudPlatform.so

chmod +x ./OrthancWSIDicomToTiff
chmod +x ./OrthancWSIDicomizer
#chmod +x ./UnitTests-DicomWeb
chmod +x ./UnitTests-PostgreSQL
chmod +x ./UnitTests-MySQL
chmod +x ./UnitTests-Transfers
#chmod +x ./UnitTests-WebViewer

# Run the unit tests
mkdir ~/UnitTests
cd ~/UnitTests
#../UnitTests-DicomWeb
# ../UnitTests-PostgreSQL
# ../UnitTests-MySQL
../UnitTests-Transfers
#../UnitTests-WebViewer

# Recover space used by the unit tests
cd
rm -rf ./UnitTests
rm -rf ./UnitTests-DicomWeb
rm -rf ./UnitTests-PostgreSQL
rm -rf ./UnitTests-MySQL
rm -rf ./UnitTests-Transfers
rm -rf ./UnitTests-WebViewer

# Move the binaries to their final location
mv ./OrthancWSIDicomToTiff             /usr/local/bin/
mv ./OrthancWSIDicomizer               /usr/local/bin/
mv ./libOrthancDicomWeb.so             /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLIndex.so      /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLStorage.so    /usr/local/share/orthanc/plugins/
mv ./libOrthancMySQLIndex.so           /usr/local/share/orthanc/plugins/
mv ./libOrthancMySQLStorage.so         /usr/local/share/orthanc/plugins/
mv ./libOrthancTransfers.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancWSI.so                  /usr/local/share/orthanc/plugins/
mv ./libOrthancWebViewer.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancAuthorization.so        /usr/local/share/orthanc/plugins/
mv ./libOrthancGoogleCloudPlatform.so  /usr/local/share/orthanc/plugins/
