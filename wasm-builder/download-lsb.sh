#!/bin/bash

set -ex

SDK=lsb-sdk-5.0.0-3.x86_64.tar.gz

cd /root/
wget https://orthanc.uclouvain.be/downloads/third-party-downloads/linux-standard-base/${SDK}

tar xvf ${SDK}

( cd /root/lsb-sdk && yes | ./install.sh )

rm -rf /root/lsb-sdk
rm /root/${SDK}
