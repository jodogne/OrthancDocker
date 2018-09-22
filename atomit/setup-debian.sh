#!/bin/bash

set -e
cd

# Setup Debian
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y wget

rm -rf /var/lib/apt/lists/*
