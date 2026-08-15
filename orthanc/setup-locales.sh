#!/bin/bash

set -ex

echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections

rm -f /etc/locale.gen

dpkg-reconfigure --frontend=noninteractive locales

update-locale LANG=en_US.UTF-8
