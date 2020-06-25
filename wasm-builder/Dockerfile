FROM ubuntu:18.04

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Build environment for WebAssembly" Vendor="The Orthanc project"

# "python-clang-4.0" and "python-pystache" are necessary for
# "ParseWebAssemblyExports.py" in Stone Web viewer. "alien" is to
# install the Linux Standard Base SDK.
RUN apt-get -y clean && apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget nano unzip cmake git ninja-build python-clang-4.0 libclang-4.0-dev python-pystache python-pip alien lsb-core g++-4.8 && apt-get clean && rm -rf /var/lib/apt/lists/*

# We install the latest version of Mercurial, so as to be able to run
# "hg archive" or "hg clone" on repository folders managed by a recent
# version of Mercurial
RUN pip install --upgrade pip
RUN pip install --upgrade mercurial

ADD ./download-lsb.sh /root/download-lsb.sh
RUN bash /root/download-lsb.sh

ADD ./download-emscripten.sh /root/download-emscripten.sh
RUN bash /root/download-emscripten.sh "1.39.17-upstream"
