#!/bin/bash

set -e
cd

URL=https://orthanc.uclouvain.be/downloads/linux-standard-base

VERSION_AUTHORIZATION=mainline
VERSION_DICOM_WEB=mainline
VERSION_GDCM=mainline
VERSION_INDEXER=mainline
VERSION_MYSQL=mainline
VERSION_NEURO=mainline
VERSION_ODBC=mainline
VERSION_OE2=mainline
VERSION_OHIF=mainline
VERSION_POSTGRESQL=mainline
VERSION_STL=mainline
VERSION_STONE_WEB_VIEWER=mainline
VERSION_TCIA=mainline
VERSION_TRANSFERS=mainline
VERSION_VOLVIEW=mainline
VERSION_WEB_VIEWER=mainline
VERSION_WSI=mainline

VERSION_STONE_RT_SAMPLE=mainline

# Download binaries compiled with Linux Standard Base

# 2020-01-24: The DICOMweb and Web viewer plugins have no unit test
# anymore, as they are now built using the Holy Build Box because of
# incompatibility between GDCM 3.0 and LSB compilers

wget ${URL}/orthanc-dicomweb/${VERSION_DICOM_WEB}/UnitTests -O - > UnitTests-DicomWeb
wget ${URL}/orthanc-dicomweb/${VERSION_DICOM_WEB}/libOrthancDicomWeb.so

wget ${URL}/orthanc-postgresql/${VERSION_POSTGRESQL}/UnitTests -O - > UnitTests-PostgreSQL
wget ${URL}/orthanc-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLIndex.so
wget ${URL}/orthanc-postgresql/${VERSION_POSTGRESQL}/libOrthancPostgreSQLStorage.so

wget ${URL}/orthanc-mysql/${VERSION_MYSQL}/UnitTests -O - > UnitTests-MySQL
wget ${URL}/orthanc-mysql/${VERSION_MYSQL}/libOrthancMySQLIndex.so
wget ${URL}/orthanc-mysql/${VERSION_MYSQL}/libOrthancMySQLStorage.so

wget ${URL}/orthanc-odbc/${VERSION_ODBC}/UnitTests -O - > UnitTests-Odbc
wget ${URL}/orthanc-odbc/${VERSION_ODBC}/libOrthancOdbcIndex.so
wget ${URL}/orthanc-odbc/${VERSION_ODBC}/libOrthancOdbcStorage.so

wget ${URL}/orthanc-transfers/${VERSION_TRANSFERS}/UnitTests -O - > UnitTests-Transfers
wget ${URL}/orthanc-transfers/${VERSION_TRANSFERS}/libOrthancTransfers.so

wget ${URL}/orthanc-webviewer/${VERSION_WEB_VIEWER}/UnitTests -O - > UnitTests-WebViewer
wget ${URL}/orthanc-webviewer/${VERSION_WEB_VIEWER}/libOrthancWebViewer.so

wget ${URL}/orthanc-wsi/${VERSION_WSI}/OrthancWSIDicomToTiff
wget ${URL}/orthanc-wsi/${VERSION_WSI}/OrthancWSIDicomizer
wget ${URL}/orthanc-wsi/${VERSION_WSI}/libOrthancWSI.so

wget ${URL}/orthanc-authorization/${VERSION_AUTHORIZATION}/libOrthancAuthorization.so

wget ${URL}/orthanc-gdcm/${VERSION_GDCM}/libOrthancGdcm.so

wget ${URL}/orthanc-tcia/${VERSION_TCIA}/libOrthancTcia.so

wget ${URL}/orthanc-indexer/${VERSION_INDEXER}/libOrthancIndexer.so
wget ${URL}/orthanc-indexer/${VERSION_INDEXER}/UnitTests -O - > UnitTests-Indexer

wget ${URL}/orthanc-neuro/${VERSION_NEURO}/libOrthancNeuro.so
wget ${URL}/orthanc-neuro/${VERSION_NEURO}/UnitTests -O - > UnitTests-Neuro

wget ${URL}/orthanc-volview/${VERSION_VOLVIEW}/libOrthancVolView.so

wget ${URL}/orthanc-explorer-2/${VERSION_OE2}/libOrthancExplorer2.so

wget ${URL}/orthanc-ohif/${VERSION_OHIF}/libOrthancOHIF.so

wget ${URL}/orthanc-stl/${VERSION_STL}/libOrthancSTL.so

wget ${URL}/stone-web-viewer/${VERSION_STONE_WEB_VIEWER}/libStoneWebViewer.so
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
mv ./libOrthancAuthorization.so        /usr/local/share/orthanc/plugins/
mv ./libOrthancDicomWeb.so             /usr/local/share/orthanc/plugins/
mv ./libOrthancExplorer2.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancGdcm.so                 /usr/local/share/orthanc/plugins/
mv ./libOrthancIndexer.so              /usr/local/share/orthanc/plugins/
mv ./libOrthancMySQLIndex.so           /usr/local/share/orthanc/plugins/
mv ./libOrthancMySQLStorage.so         /usr/local/share/orthanc/plugins/
mv ./libOrthancNeuro.so                /usr/local/share/orthanc/plugins/
mv ./libOrthancOHIF.so                 /usr/local/share/orthanc/plugins/
mv ./libOrthancOdbcIndex.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancOdbcStorage.so          /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLIndex.so      /usr/local/share/orthanc/plugins/
mv ./libOrthancPostgreSQLStorage.so    /usr/local/share/orthanc/plugins/
mv ./libOrthancSTL.so                  /usr/local/share/orthanc/plugins/
mv ./libOrthancTcia.so                 /usr/local/share/orthanc/plugins/
mv ./libOrthancTransfers.so            /usr/local/share/orthanc/plugins/
mv ./libOrthancVolView.so              /usr/local/share/orthanc/plugins/
mv ./libOrthancWSI.so                  /usr/local/share/orthanc/plugins/
mv ./libOrthancWebViewer.so            /usr/local/share/orthanc/plugins/
mv ./libRtViewerPlugin.so              /usr/local/share/orthanc/plugins/
mv ./libStoneWebViewer.so              /usr/local/share/orthanc/plugins/
