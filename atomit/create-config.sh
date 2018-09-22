#!/bin/bash

set -e
cd

# Create the various directories
mkdir /etc/atomit
mkdir -p /var/lib/atomit/db

# Create a basic configuration
cat << EOF > /etc/atomit/atomit.json
{
  "TimeSeries" : {
    "hello" : {
      "Backend" : "SQLite",
      "Path" : "/var/lib/atomit/db/hello.db"
    }
  }
}
EOF
