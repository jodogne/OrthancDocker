FROM ubuntu:12.04.5

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget nano build-essential unzip cmake mercurial uuid-dev libcurl4-openssl-dev liblua5.1-0-dev libgtest-dev libpng-dev libsqlite3-dev libssl-dev zlib1g-dev libdcmtk2-dev libboost1.48-all-dev libwrap0-dev libcharls-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
