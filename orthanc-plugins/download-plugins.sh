#!/bin/bash

set -e
cd

URL=http://lsb.orthanc-server.com/

VERSION_AUTHORIZATION=mainline
VERSION_DICOM_WEB=mainline
VERSION_GDCM=mainline-gdcm3
VERSION_INDEXER=mainline
VERSION_MYSQL=mainline
VERSION_NEURO=mainline
VERSION_ODBC=mainline
VERSION_POSTGRESQL=mainline
VERSION_TCIA=mainline
VERSION_TRANSFERS=mainline
VERSION_WEB_VIEWER=mainline
VERSION_WSI=mainline
VERSION_STONE_WEB_VIEWER=mainline
VERSION_STONE_RT_SAMPLE=mainline

# Download binaries compiled with Linux Standard Base

# 2020-01-24: The DICOMweb and Web viewer plugins have no unit test
# anymore, as they are now built using the Holy Build Box because of
# incompatibility between GDCM 3.0 and LSB compilers

wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/UnitTests -O - > UnitTests-DicomWeb
wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/libOrthancDicomWeb.so

wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/UnitTests -O - > UnitTests-PostgreSQL
wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLIndex.so
wget ${URL}/plugin-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLStorage.so

wget ${URL}/plugin-mysql/${VERSION_MYSQL}/UnitTests -O - > UnitTests-MySQL
wget ${URL}/plugin-mysql/${VERSION_MYSQL}/libOrthancMySQLIndex.so
wget ${URL}/plugin-mysql/${VERSION_MYSQL}/libOrthancMySQLStorage.so

wget ${URL}/plugin-odbc/${VERSION_ODBC}/UnitTests -O - > UnitTests-Odbc
wget ${URL}/plugin-odbc/${VERSION_ODBC}/libOrthancOdbcIndex.so
wget ${URL}/plugin-odbc/${VERSION_ODBC}/libOrthancOdbcStorage.so

wget ${URL}/plugin-transfers/${VERSION_TRANSFERS}/UnitTests -O - > UnitTests-Transfers
wget ${URL}/plugin-transfers/${VERSION_TRANSFERS}/libOrthancTransfers.so

wget ${URL}/plugin-webviewer/${VERSION_WEB_VIEWER}/UnitTests -O - > UnitTests-WebViewer
wget ${URL}/plugin-webviewer/${VERSION_WEB_VIEWER}/libOrthancWebViewer.so

wget ${URL}/whole-slide-imaging/${VERSION_WSI}/OrthancWSIDicomToTiff
wget ${URL}/whole-slide-imaging/${VERSION_WSI}/OrthancWSIDicomizer
wget ${URL}/whole-slide-imaging/${VERSION_WSI}/libOrthancWSI.so

wget ${URL}/plugin-authorization/${VERSION_AUTHORIZATION}/libOrthancAuthorization.so

wget ${URL}/plugin-gdcm/${VERSION_GDCM}/libOrthancGdcm.so

wget ${URL}/plugin-tcia/${VERSION_TCIA}/libOrthancTcia.so

wget ${URL}/plugin-indexer/${VERSION_INDEXER}/libOrthancIndexer.so
wget ${URL}/plugin-indexer/${VERSION_INDEXER}/UnitTests -O - > UnitTests-Indexer

wget ${URL}/plugin-neuro/${VERSION_NEURO}/libOrthancNeuro.so
wget ${URL}/plugin-neuro/${VERSION_NEURO}/UnitTests -O - > UnitTests-Neuro

wget ${URL}/stone-webviewer/${VERSION_STONE_WEB_VIEWER}/libStoneWebViewer.so
wget ${URL}/stone-rt-sample/${VERSION_STONE_RT_SAMPLE}/libRtViewerPlugin.so

chmod +x ./OrthancWSIDicomToTiff
chmod +x ./OrthancWSIDicomizer
chmod +x ./UnitTests-DicomWeb
chmod +x ./UnitTests-PostgreSQL
chmod +x ./UnitTests-MySQL
chmod +x ./UnitTests-Odbc
chmod +x ./UnitTests-Transfers
chmod +x ./UnitTests-WebViewer
chmod +x ./UnitTests-Indexer
chmod +x ./UnitTests-Neuro

# Run the unit tests
mkdir ~/UnitTests
cd ~/UnitTests
../UnitTests-DicomWeb
# ../UnitTests-PostgreSQL
# ../UnitTests-MySQL
# ../UnitTests-Odbc
../UnitTests-Transfers
../UnitTests-WebViewer
../UnitTests-Indexer
../UnitTests-Neuro

# Recover space used by the unit tests
cd
rm -rf ./UnitTests
rm -rf ./UnitTests-DicomWeb
rm -rf ./UnitTests-PostgreSQL
rm -rf ./UnitTests-MySQL
rm -rf ./UnitTests-Odbc
rm -rf ./UnitTests-Transfers
rm -rf ./UnitTests-WebViewer
rm -rf ./UnitTests-Indexer
rm -rf ./UnitTests-Neuro

# Move the binaries to their final location
mv ./OrthancWSIDicomToTiff             /usr/local/bin/
mv ./OrthancWSIDicomizer               /usr/local/bin/
mv ./libOrthancDicomWeb.so             /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLIndex.so      /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLStorage.so    /usr/local/share/orthanc/plugins/
mv ./libOrthancMySQLIndex.so           /usr/local/share/orthanc/plugins/
mv ./libOrthancMySQLStorage.so         /usr/local/share/orthanc/plugins/
mv ./libOrthancOdbcIndex.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancOdbcStorage.so          /usr/local/share/orthanc/plugins/
mv ./libOrthancTransfers.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancWSI.so                  /usr/local/share/orthanc/plugins/
mv ./libOrthancWebViewer.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancAuthorization.so        /usr/local/share/orthanc/plugins/
mv ./libOrthancGdcm.so                 /usr/local/share/orthanc/plugins/
mv ./libOrthancTcia.so                 /usr/local/share/orthanc/plugins/
mv ./libOrthancIndexer.so              /usr/local/share/orthanc/plugins/
mv ./libOrthancNeuro.so                /usr/local/share/orthanc/plugins/
mv ./libStoneWebViewer.so              /usr/local/share/orthanc/plugins/
mv ./libRtViewerPlugin.so              /usr/local/share/orthanc/plugins/
