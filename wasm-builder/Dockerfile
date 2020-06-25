FROM ubuntu:18.04

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Build environment for WebAssembly" Vendor="The Orthanc project"

# "python-clang-4.0" and "python-pystache" are necessary for
# "ParseWebAssemblyExports.py" in Stone Web viewer
RUN apt-get -y clean && apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget nano build-essential unzip cmake git ninja-build python-clang-4.0 python-pystache python-pip && apt-get clean && rm -rf /var/lib/apt/lists/*

# We install the latest version of Mercurial, so as to be able to run
# "hg archive" or "hg clone" on repository folders managed by a recent
# version of Mercurial
RUN pip install --upgrade pip
RUN pip install --upgrade mercurial

ADD ./download-emscripten.sh /root/download-emscripten.sh
RUN bash /root/download-emscripten.sh "1.39.17-upstream"
