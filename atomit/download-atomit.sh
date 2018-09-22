#!/bin/bash

set -e
cd

URL=http://lsb.orthanc-server.com/
VERSION_ATOMIT=mainline

# Download binaries compiled with Linux Standard Base
wget ${URL}/atomit/${VERSION_ATOMIT}/AtomIT
wget ${URL}/atomit/${VERSION_ATOMIT}/UnitTests

chmod +x ./AtomIT
chmod +x ./UnitTests

# Run the unit tests
mkdir ~/UnitTestsRun
cd ~/UnitTestsRun
../UnitTests

# Recover space used by the unit tests
cd
rm -f ./UnitTests

# Move the binaries to their final location
mkdir -p /usr/local/sbin/

mv ./AtomIT  /usr/local/sbin/
