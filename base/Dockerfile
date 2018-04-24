FROM ubuntu:14.04

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Base environment to build Orthanc" Vendor="The Orthanc project"

RUN apt-get -y clean && apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget nano build-essential unzip cmake mercurial uuid-dev libcurl4-openssl-dev liblua5.1-0-dev libgtest-dev libpng-dev libsqlite3-dev libssl-dev libjpeg-dev zlib1g-dev libdcmtk2-dev libboost-all-dev libwrap0-dev libcharls-dev libjsoncpp-dev libpugixml-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
