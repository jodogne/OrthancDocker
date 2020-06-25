FROM ubuntu:18.04

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Build environment for WebAssembly" Vendor="The Orthanc project"

RUN apt-get -y clean && apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget nano build-essential unzip cmake mercurial git ninja-build && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD ./download-emscripten.sh /root/download-emscripten.sh
RUN bash /root/download-emscripten.sh "1.39.17-upstream"
