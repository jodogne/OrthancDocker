#!/bin/bash

set -e
cd

# Create the various directories as in the official Debian package
mkdir /etc/orthanc
mkdir -p /var/lib/orthanc/db

# Auto-generate, then patch the main configuration file
CONFIG=/etc/orthanc/orthanc.json
Orthanc --config=$CONFIG

sed 's/\("Name" : \)".*"/\1"Orthanc inside Docker"/' -i $CONFIG
sed 's/\("IndexDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/\("StorageDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/\("Plugins" : \[\)/\1 \n    "\/usr\/share\/orthanc\/plugins", "\/usr\/local\/share\/orthanc\/plugins"/' -i $CONFIG
sed 's/"RemoteAccessAllowed" : false/"RemoteAccessAllowed" : true/' -i $CONFIG
sed 's/"AuthenticationEnabled" : false/"AuthenticationEnabled" : true/' -i $CONFIG

# New since jodogne/orthanc:1.7.3
sed 's/\("HttpsCACertificates" : \)".*"/\1"\/etc\/ssl\/certs\/ca-certificates.crt"/' -i $CONFIG


# Starting with Orthanc 1.5.8, we let Orthanc create its default
# user. This results in showing a warning about "Insecure setup", both
# in the logs and in Orthanc Explorer. => The following call to "sed"
# on "RegisterUsers" must *NOT* be done.

# sed 's/\("RegisteredUsers" : {\)/\1\n    "orthanc" : "orthanc"/' -i $CONFIG
