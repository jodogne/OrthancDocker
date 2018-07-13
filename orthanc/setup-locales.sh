#!/bin/bash

set -e
cd

DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y locales wget

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
# ln -s /etc/locale.alias /usr/share/locale/locale.alias
locale-gen

rm -rf /var/lib/apt/lists/*
rm -rf /usr/share/i18n/
